(* ::Package::"Tags"-><|"SuspiciousBox" -> <|Enabled -> False|>|>:: *)

(* Clear All *)
ClearAll["Global`*"]


(*Physical Constants*)

F=96485; (*Faraday's constant (C/mol)*)
R=8.314; (*Gas constant (J/mol K)*)
T=298; (*Temperature (K)*)
alpha=0.5; (*Charge transfer coefficient*)

(* System Parameters *)
nElec = 2; (* assume two electron transfer per Methylene Blue  *)
A=1*10*^-4; (*Electrode electrochemical area (m^2) = 1 cm^2*)
Lambda=1*^12/(6.02*10^23); (*Surface concentration (moles/m^2)*) (* roughly 10^12 mocleuls/cm^2 from Anal.Chem.2023,95,2229\[Minus]2237 *)
Lambda=1*^14/(6.02*10^23); (* arbitrary surface concentration *)

(* k0u=0.5; *) (*Standard rate constant for unbound state (cm/s)*) (* let's not do the tunneling calculation done in Langmuir.2017 May 09;33(18):4407\[Dash]4413... *)
k0u=5; (*Standard rate constant for unbound state (1/s)*)
k0b=100; (*Standard rate constant for bound state (1/s)*)
(* note Simulation-Based Approach to Determining Electron Transfer
Rates Using Square-Wave Voltammetry uses incorrect units for current which is confusing  - Eq 8,9 are current /cm^2 not actual current*)
E0=-.32; (*Standard redox potential (V)*)
E0=0; (* Set the Methylene Blue Standard redox potential to zero volts so that equations solve more easily. We can add it back in later! *)

(* Rratio=k0b/k0u; *) (*Ratio of bound to unbound rate constants*)
(* fBound = 0.5; *)(* the fraction of bound aptamers - replace with an analyte dependence function later *) 

(* Time and Frequency range *)
deltaV = 0.004; (* 10mV per step *) (* for ease of subsequent calcualations, make this an even number of milliseconds *)
Tmax[SquareWaveFreq_] :=2*VRampAmplitude/deltaV/SquareWaveFreq; (*50 ms total time*)
Npoints=2^15; (*Number of time samples*)
dt[SquareWaveFreq_] :=Tmax[SquareWaveFreq]/(Npoints-1); (*Time step size*)
timeSamples[SquareWaveFreq_]:=Range[0,Tmax[SquareWaveFreq],dt[SquareWaveFreq]]; (*Discrete time points for evaluation*)
freqResolution[SquareWaveFreq_]:=1/(Npoints*dt[SquareWaveFreq]); (*Frequency resolution*)
frequencyList[SquareWaveFreq_]=Table[n freqResolution[SquareWaveFreq],{n,0,Npoints/2-1}]; (*Positive frequencies only*)

(* System Impedence*)
RSol = 147; (* 147 ohms Randle resistance *)
Cint = 4.4*10^-7; (*0.4 microFarads *) (* values from Subsecond-Resolved Molecular Measurements Using
Electrochemical Phase Interrogation of AptamerBased Sensors - but just assume capacitance not CPE *)



(*Equations for Applied Voltage *)
(* square wave input *)
SquareWaveFastFreq = 200; (* Hz *)(* subsequent visualization relies on this being an even number *)

SquareWaveSlowFreq = 20; (* Hz *) (* subsequent visualization relies on this being an even number *)

VRampAmplitude = 0.2; (* Volts total = 200mV on either side *)
VPeakAmplitude = 0.025; (* Volts total = 25mV *)

(*Define square wave function for voltage*)
(*Define a smooth square wave approximation using tanh*)
epsilonWidth = 0.0005;
 SmoothSquareWave[t_,freq_,width_]:=Tanh[Sin[2 Pi freq t]/width];  
(* SmoothSquareWave[t_,freq_,width_]:=SquareWave[ freq t]; *)

(* VApplied[t_]:=E0-VRampAmplitude/2+VRampAmplitude*t/Tmax+VPeakAmplitude*SmoothSquareWave[t,squareWaveFreq,0.01]; *)


(*Generate times for up and down switches*)
upSwitchTimesSlow=Table[n/SquareWaveSlowFreq,{n,1,Floor[Tmax[SquareWaveSlowFreq]*SquareWaveSlowFreq]}];
downSwitchTimesSlow=Table[(n+0.5)/SquareWaveSlowFreq,{n,0,Floor[Tmax[SquareWaveSlowFreq]*SquareWaveSlowFreq-0.5]}];

upSwitchTimesFast=Table[n/SquareWaveFastFreq,{n,1,Floor[Tmax[SquareWaveFastFreq]*SquareWaveFastFreq]}];
downSwitchTimesFast=Table[(n+0.5)/SquareWaveFastFreq,{n,0,Floor[Tmax[SquareWaveFastFreq]*SquareWaveFastFreq-0.5]}];



(*Equations for Aptamer Signal*)


ClampExp[x_] := Exp[Clip[x, {-10, 10}]]


(*Define rate constants based on VAptamerGold*)
koxExpr[fB_]:=(1-fB) k0u ClampExp[alpha F (VAptamerGold[t]-E0)/(R T)]+fB k0b ClampExp[alpha F (VAptamerGold[t]-E0)/(R T)];

kredExpr[fB_]:=(1-fB) k0u ClampExp[-(1-alpha) F (VAptamerGold[t]-E0)/(R T)]+fB k0b ClampExp[-(1-alpha) F (VAptamerGold[t]-E0)/(R T)];

(*Oxidation fraction differential equation*)
aptamerODE[fB_]:=fOx'[t]==koxExpr[fB] (1-fOx[t])-kredExpr[fB] fOx[t];

initialAptamer=fOx[0]==0;


(* Circuit Equations *)

(*Current through capacitor*)
iCap[t_]:=Cint VAptamerGold'[t];

(*Current through aptamer*)
iAptamerExpr[fB_]:=nElec*F*A*Lambda*(koxExpr[fB]*(1-fOx[t])-kredExpr[fB]*fOx[t]);

(*Total current through resistor*)
iTotalExpr[fB_]:=iCap[t]+iAptamerExpr[fB];

(*Voltage drop across resistor*)
circuitODE[fB_]:=VApplied[t]-VAptamerGold[t]==RSol*iTotalExpr[fB];

VCap0 =0; (* assume initial charge zero *)

(*Initial voltage condition*)
initialRC=VAptamerGold[0]==VCap0;

VSWVSlow[t_]:=E0-VRampAmplitude/2+VRampAmplitude*t/Tmax[SquareWaveSlowFreq]+VPeakAmplitude*SmoothSquareWave[t,SquareWaveSlowFreq,epsilonWidth]; 
VSWVFast[t_]:=E0-VRampAmplitude/2+VRampAmplitude*t/Tmax[SquareWaveFastFreq]+VPeakAmplitude*SmoothSquareWave[t,SquareWaveFastFreq,epsilonWidth]

(*Solve for VAptamerGold and fOx simultaneously*)
(* solutionSWVSlow=NDSolve[{aptamerODE[0.5],circuitODE[0.5],initialAptamer,initialRC, VApplied[t]==VSWVSlow[t]},{fOx,VAptamerGold},{t,0,Tmax[SquareWaveSlowFreq]}, Method->"Automatic"];
solutionSWVFast=NDSolve[{aptamerODE[0.5],circuitODE[0.5],initialAptamer,initialRC, VApplied[t]==VSWVFast[t]},{fOx,VAptamerGold},{t,0,Tmax[SquareWaveFastFreq]}, Method->"Automatic"];
*)


(*Step 1:Define a list of simulation conditions*)
conditionsList={
<|"label"->"Slow_f00","squareWave"->VSWVSlow,"fBound"->0.0,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f01","squareWave"->VSWVSlow,"fBound"->0.1,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f02","squareWave"->VSWVSlow,"fBound"->0.2,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f03","squareWave"->VSWVSlow,"fBound"->0.3,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f04","squareWave"->VSWVSlow,"fBound"->0.4,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f05","squareWave"->VSWVSlow,"fBound"->0.5,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f06","squareWave"->VSWVSlow,"fBound"->0.6,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f07","squareWave"->VSWVSlow,"fBound"->0.7,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f08","squareWave"->VSWVSlow,"fBound"->0.8,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f09","squareWave"->VSWVSlow,"fBound"->0.9,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f10","squareWave"->VSWVSlow,"fBound"->1,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Fast_f00","squareWave"->VSWVFast,"fBound"->0,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f01","squareWave"->VSWVFast,"fBound"->0.1,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f02","squareWave"->VSWVFast,"fBound"->0.2,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f03","squareWave"->VSWVFast,"fBound"->0.3,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f04","squareWave"->VSWVFast,"fBound"->0.4,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f05","squareWave"->VSWVFast,"fBound"->0.5,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f06","squareWave"->VSWVFast,"fBound"->0.6,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f07","squareWave"->VSWVFast,"fBound"->0.7,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f08","squareWave"->VSWVFast,"fBound"->0.8,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f09","squareWave"->VSWVFast,"fBound"->0.9,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f10","squareWave"->VSWVFast,"fBound"->1,"freq"->SquareWaveFastFreq|>
};
conditionsList={
<|"label"->"Slow_f00","squareWave"->VSWVSlow,"fBound"->0.0,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f05","squareWave"->VSWVSlow,"fBound"->0.5,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Slow_f10","squareWave"->VSWVSlow,"fBound"->1,"freq"->SquareWaveSlowFreq|>,
<|"label"->"Fast_f00","squareWave"->VSWVFast,"fBound"->0,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f05","squareWave"->VSWVFast,"fBound"->0.5,"freq"->SquareWaveFastFreq|>,
<|"label"->"Fast_f10","squareWave"->VSWVFast,"fBound"->1,"freq"->SquareWaveFastFreq|>
};

(*Step 2:Initialize an empty association*)
solutionsAssoc=Association[];
(*Step 3:Loop through conditions and solve for each*)

Monitor[Do[Module[{label,squareWaveInput,fValue,freqValue,solution},
label=conditionsList[[i,"label"]];
squareWaveInput=conditionsList[[i,"squareWave"]];
fValue=conditionsList[[i,"fBound"]];
freqValue=conditionsList[[i,"freq"]];
solution=NDSolve[{aptamerODE[fValue],circuitODE[fValue],initialAptamer,initialRC,VApplied[t]==squareWaveInput[t]},{fOx,VAptamerGold},{t,0,Tmax[freqValue]},Method->"Automatic"];
solutionsAssoc[label]=solution;],{i,Length[conditionsList]}],Row[{"Solving ",Dynamic[conditionsList[[i,"label"]]],"  ",
ProgressIndicator[i,{1,Length[conditionsList]}]}]]





(*Redefine fOx and VAptamer solutions based on solutionsAssoc*)
fOxSol[label_][t_]:=fOx[t]/. solutionsAssoc[label][[1]];
VAptamerSol[label_][t_]:=VAptamerGold[t]/. solutionsAssoc[label][[1]];

(*Redefine total current function*)
iSWV[label_,squareWaveFunc_][t_]:=(squareWaveFunc[t]-VAptamerGold[t]/. solutionsAssoc[label][[1]])/RSol;

(*Example Plots*)

(*Slow frequency,fBound=0.5*)
Plot[fOxSol["Slow_f05"][t],{t,0,Tmax[SquareWaveSlowFreq]},PlotLabel->"Oxidation Fraction (Slow, fBound=0.5)",AxesLabel->{"Time (s)","fOx"}]

(*Fast frequency,fBound=0.5*)
Plot[fOxSol["Fast_f05"][t],{t,0,Tmax[SquareWaveFastFreq]},PlotLabel->"Oxidation Fraction (Fast, fBound=0.5)",AxesLabel->{"Time (s)","fOx"}]

(*Plot total current for Slow,fBound=0.5*)
Plot[{iSWV["Slow_f00",VSWVSlow][t],iSWV["Slow_f05",VSWVSlow][t],iSWV["Slow_f10",VSWVSlow][t]},{t,0,0.1*Tmax[SquareWaveSlowFreq]},PlotLabel->"SWV Current",AxesLabel->{"Time (s)","Current (A)"},PlotLegends->{Subscript["f","Bound"]==0,Subscript["f","Bound"]==0.5,Subscript["f","Bound"]==1}]

(*Plot total current for Fast,fBound=0.5*)
Plot[{iSWV["Fast_f00",VSWVFast][t],iSWV["Fast_f05",VSWVFast][t],iSWV["Fast_f10",VSWVFast][t]},{t,0,0.1*Tmax[SquareWaveFastFreq]},PlotLabel->"Total Current (Fast, fBound=0.5)",AxesLabel->{"Time (s)","Current (A)"}]



(* ::InheritFromParent:: *)
(**)



Plot[
  Evaluate[
    {
      10^6 * iSWV["Fast_f00", VSWVFast][t],
      10^6 * iSWV["Fast_f05", VSWVFast][t],
      10^6 * iSWV["Fast_f10", VSWVFast][t]
    }
  ],
  {t, 0.50*Tmax[SquareWaveFastFreq], 0.52*Tmax[SquareWaveFastFreq]},
  PlotLabel -> "Simulated Current vs Time at 200 Hz",
  AxesLabel -> {"Time (s)", "Current (\[Micro]A)"},
  Background -> White,
  PlotStyle -> {
   {Automatic, Thick}, 
    {Automatic, Dashed, Thick}, 
    {Automatic, Dotted, Thick}
    },
  PlotLegends -> Placed[{"f = 0", "f = 0.5", "f = 1"}, {0.8, 0.85}]
]




(*Visual Check*)
(*Plot applied voltage vs aptamer voltage for a given condition*)Plot[{VSWVSlow[t],VAptamerSol["Slow_f05"][t]},{t,0,Tmax[SquareWaveSlowFreq]/30},PlotLabel->"Applied vs Aptamer Voltage (Slow, fBound = 0.5)",PlotLegends->{"Applied Voltage","Aptamer Voltage"},AxesLabel->{"Time (s)","Voltage (V)"}]



Plot[{VSWVFast[t],VAptamerSol["Fast_f05"][t]},{t,0,Tmax[SquareWaveFastFreq]/10},PlotLabel->"Applied vs Aptamer Voltage"]





(* Noise Modeling *)
(*Define which labels to plot*)
(* labelsToPlot={"Slow_f05","Fast_f05"};
labelsToPlot={"Slow_f00","Fast_f00","Slow_f02","Fast_f02","Slow_f05","Fast_f05","Slow_f10","Fast_f10"};
*)
(* Extract available labels from conditionsList *)
availableLabels = conditionsList[[All, "label"]];

(* Generate all possible fBound-based labels *)
labelsToPlot = Select[
   Flatten[
    Table[
     {
      "Slow_f" <> StringPadLeft[ToString[IntegerPart[fb*10]], 2, "0"],
      "Fast_f" <> StringPadLeft[ToString[IntegerPart[fb*10]], 2, "0"]
     },
     {fb, 0.0, 1.0, 0.1}
    ]
   ],
   MemberQ[availableLabels, #] &
]



(*Noise parameters*)
noiseStd=1*10^-12; (*Standard deviation in Amperes*)

(*Time samples for each label*)
ts=Association[Table[label->timeSamples[If[StringStartsQ[label,"Slow"],SquareWaveSlowFreq,SquareWaveFastFreq]],{label,labelsToPlot}]];

(*Model current function for each label*)
iSWV=Association[Table[label->Function[t,(If[StringStartsQ[label,"Slow"],VSWVSlow[t],VSWVFast[t]]-VAptamerSol[label][t])/RSol],{label,labelsToPlot}]];

(*Generate noisy current data for each label*)
noisyCurrentSWVData=Association[Table[Module[{timeVec=ts[label],modelVals=iSWV[label]/@ts[label],noise=RandomVariate[NormalDistribution[0,noiseStd],Length[ts[label]]]},label->Transpose[{timeVec,modelVals+noise}]],{label,labelsToPlot}]];

(*Plot all curves*)
plots=Table[ListPlot[noisyCurrentSWVData[label],PlotLabel->"Noisy Current SWV: "<>label,AxesLabel->{"t (s)","Current (A)"},Joined->True],{label,labelsToPlot}];

(*Display all plots together*)
GraphicsGrid[{plots}]



(*Labels to analyze*)
(*Get frequency and dt per label*)
labelFreq=Association[Table[label->If[StringStartsQ[label,"Slow"],SquareWaveSlowFreq,SquareWaveFastFreq],{label,labelsToPlot}]];

labelDt=Association[Table[label->dt[labelFreq[label]],{label,labelsToPlot}]];

(*Get median up-switch time per label*)
medianUpSwitchTime=Association[Table[label->Median[If[StringStartsQ[label,"Slow"],upSwitchTimesSlow,upSwitchTimesFast]],{label,labelsToPlot}]];

(*Build aligned time-current slices (relative to up-switch)*)
voltageTimePairs=Association[Table[Module[{data=Lookup[noisyCurrentSWVData,label,{}],t0=medianUpSwitchTime[label],halfPeriod=1/(2*labelFreq[label])},If[Length[data]>0,Module[{processed},processed=Select[data/. {x_,y_}:>{(x-t0)*1000,Abs[Re[y]]},#[[1]]>=0&&#[[1]]<=halfPeriod*1000&&#[[2]]>0&];
If[Length[processed]>0,label->processed,Nothing]],Nothing]],{label,labelsToPlot}]];

(*Final Plot*)
ListLogLogPlot[Values[voltageTimePairs],PlotLegends->Keys[voltageTimePairs],AxesLabel->{"time (ms)","|i| (A)"},PlotLabel->"Current Decay After Up-Step (Log-Log)",Joined->True,PlotRange->{{0.01,100},Automatic},ImageSize->Large]




(* Step 1: Define frequency and dt per label *)
labelFreq = Association[
  Table[
    label -> If[StringStartsQ[label, "Slow"], SquareWaveSlowFreq, SquareWaveFastFreq],
    {label, labelsToPlot}
  ]
];

labelDt = Association[
  Table[
    label -> dt[labelFreq[label]],
    {label, labelsToPlot}
  ]
];

(* Step 2: Compute median up-switch time per label *)
medianUpSwitchTime = Association[
  Table[
    label -> Median[
      If[StringStartsQ[label, "Slow"], upSwitchTimesSlow, upSwitchTimesFast]
    ],
    {label, labelsToPlot}
  ]
];

(* Step 3: Filter labels to f0 and f1 only *)
filteredLabels = Select[labelsToPlot, StringContainsQ[#, "f00" | "f1"] &];

(* Step 4: Align and extract voltage-time pairs (relative to median up-switch) *)
voltageTimePairs = Association[
  Table[
    Module[
      {
        data = Lookup[noisyCurrentSWVData, label, {}],
        t0 = medianUpSwitchTime[label],
        halfPeriod = 1/(2 * labelFreq[label])
      },
      If[Length[data] > 0,
        Module[{processed},
          processed = Select[
            data /. {x_, y_} :> {(x - t0)*1000, Abs[Re[y]]},
            #[[1]] >= 0 && #[[1]] <= halfPeriod*1000 && #[[2]] > 0 &
          ];
          If[Length[processed] > 0,
            label -> processed,
            Nothing
          ]
        ],
        Nothing
      ]
    ],
    {label, filteredLabels}
  ]
];

(* Step 5: Plot aligned log-log current traces with manual styling *)
ListLogLogPlot[
  Values[voltageTimePairs],
  PlotLegends -> Keys[voltageTimePairs],
  AxesLabel -> {"time (ms)", "|i| (A)"},
  PlotLabel -> "Current Decay After Up-Step (Log-Log)",
  Joined -> True,
  PlotRange -> {{0.01, 100}, Automatic},
  Background -> White,
  Frame -> True,
  FrameStyle -> Black,
  ImageSize -> Large,
  PlotStyle -> {
    Black, Black, Blue, Blue
  }
]




(* Custom labels for legend *)
legendLabels = {
  "f = 0", 
  "f = 1"
};

(* Final Plot with legend inside the frame *)
ListLogLogPlot[
  Values[voltageTimePairs],
  PlotLegends -> Placed[
    LineLegend[{Black, Blue, Black, Blue}, legendLabels],
    {0.85, 0.85}  (* top-right corner inside frame *)
  ],
  AxesLabel -> {"time (ms)", "|i| (A)"},
  PlotLabel -> "Current Decay After Up-Step (Log-Log)",
  Joined -> True,
  PlotRange -> {{0.01, 100}, Automatic},
  Background -> White,
  Frame -> True,
  FrameStyle -> Black,
  ImageSize -> Large,
  PlotStyle -> {
    Black, Black, Blue, Blue
  }
]



legendLabels = {
  "f = 0", 
  "f = 1"
};

(* Final Plot with legend inside the frame and labeled axes *)
ListLogLogPlot[
  Values[voltageTimePairs],
  PlotLegends -> Placed[
    LineLegend[{Black, Blue, Black, Blue}, legendLabels],
    {0.85, 0.85}  (* top-right corner inside frame *)
  ],
  Frame -> True,
  FrameLabel -> {
    Style["time (ms)", 16],
    Style["|i| (A)", 16]
  },
  LabelStyle -> Directive[Black, 16],
  PlotLabel -> Style["Current decay after voltage step", 16],
  Joined -> True,
  PlotRange -> {{0.01, 100}, Automatic},
  Background -> White,
  FrameStyle -> Black,
  ImageSize -> Large,
  PlotStyle -> {
    Black, Black, Blue, Blue
  }
]



(* Generate a list of SWV data points *)
(* iForwardSWV and iReverseSWV and IdiffSWV *)
(* First: get the time before each a potential switch in VAptamerGold[t] for forward steps and backward steps *)

(* Next: using the iForwardStepTimes list calculate the current at that time iForwardSWV[t] *) 
(* Next: using the iReverseStepTimes list calculate the current at that time iReverseSWV[t] *) 
(* Finally calculate idiffSWV as the difference between forward and reverse *)


(*Function to find the current value just before each switch time*)(* findPrecedingCurrent[switchTimes_List,data_List]:=Module[{times=data[[All,1]],result},result=Table[Module[{index},index=SelectFirst[Reverse[Range[Length[times]]],times[[#]]<t&,Missing["NotAvailable"]];
If[MissingQ[index],{t,Missing["NotAvailable"]},data[[index]]]],{t,switchTimes}];
result]; *)
(*---Helper to find the current just before switch---*)findPrecedingCurrent[switchTimes_List,data_List]:=Module[{times=data[[All,1]]},Table[Module[{index},index=SelectFirst[Reverse[Range[3,Length[times]]],times[[#]]<t&,Missing["NotAvailable"]];
If[MissingQ[index]||index<2,{t,Missing["NotAvailable"]},data[[index-1]]]],{t,switchTimes}]];

(*---Main SWV Current Extractor---*)
computeSWV[label_,squareWaveFunc_,switchUpTimes_,switchDownTimes_,data_]:=Module[{fwdCurrents,revCurrents,minN,diffData,fwdData,revData},fwdCurrents=findPrecedingCurrent[switchDownTimes,data];
revCurrents=findPrecedingCurrent[switchUpTimes,data];
minN=Min[Length[fwdCurrents],Length[revCurrents],Length[switchUpTimes]];
diffData=Table[{-squareWaveFunc[switchUpTimes[[n]]],fwdCurrents[[n,2]]-revCurrents[[n,2]]},{n,1,minN}];
fwdData=Table[{-squareWaveFunc[switchUpTimes[[n]]],fwdCurrents[[n,2]]},{n,1,minN}];
revData=Table[{-squareWaveFunc[switchDownTimes[[n]]],revCurrents[[n,2]]},{n,1,Min[Length[revCurrents],Length[switchDownTimes]]}];
<|"label"->label,"diff"->diffData,"fwd"->fwdData,"rev"->revData|>];

(*---Run for Slow and Fast---*)
swvResults={computeSWV["Slow_f05",VSWVSlow,upSwitchTimesSlow,downSwitchTimesSlow,noisyCurrentSWVData["Slow_f05"]],computeSWV["Fast_f05",VSWVFast,upSwitchTimesFast,downSwitchTimesFast,noisyCurrentSWVData["Fast_f05"]]};

(*---Plotting---*)

ListPlot[{swvResults[[1,"fwd"]],swvResults[[1,"rev"]],swvResults[[1,"diff"]]},AxesLabel->{"Potential (V)","Current (A)"},PlotLegends->{"Forward","Reverse","Difference"},PlotLabel->"SWV (Slow)",PlotRange->All,Joined->True]

ListPlot[{swvResults[[2,"fwd"]],swvResults[[2,"rev"]],swvResults[[2,"diff"]]},AxesLabel->{"Potential (V)","Current (A)"},PlotLegends->{"Forward","Reverse","Difference"},PlotLabel->"SWV (Fast)",PlotRange->All,Joined->True]

ListPlot[{swvResults[[1,"diff"]],swvResults[[2,"diff"]]},AxesLabel->{"Potential (V)","Current (A)"},PlotLegends->{"Slow","Fast"},PlotLabel->"SWV Difference",PlotRange->{{-0.2,0.2},{0,Automatic}},Joined->True,ImageSize->Large]





ListPlot[{swvResults[[1,"fwd"]],swvResults[[1,"rev"]],swvResults[[1,"diff"]]},AxesLabel->{"Potential (V)","Current (A)"},PlotLegends->{"Forward","Reverse","Difference"},PlotLabel->"SWV (Slow)",PlotRange->All,Joined->True]



ListPlot[
  {
    swvResults[[1, "fwd"]] /. {x_, y_} :> {x, 10^6 y},
    swvResults[[1, "rev"]] /. {x_, y_} :> {x, 10^6 y},
    swvResults[[1, "diff"]] /. {x_, y_} :> {x, 10^6 y}
  },
  AxesLabel -> {"E\:2081/\:2082 Offset (V)", "Current (\[Micro]A)"},
  PlotLegends -> Placed[
    LineLegend[Automatic, {"Forward", "Reverse", "Difference"}],
    {0.85, 0.85}
  ],
  PlotLabel -> "Simulated SWV signal",
  PlotRange -> All,
  Joined -> True,
  PlotStyle -> Thick,
  Background -> White,
  Frame -> True,
  FrameStyle -> Black,
  ImageSize -> 250
]



(* ::InheritFromParent:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::InheritFromParent:: *)
(**)


extractSWVDiffPeak[result_] := Max[result["diff"][[All, 2]]];
peakSlow = extractSWVDiffPeak[swvResults[[1]]];
peakFast = extractSWVDiffPeak[swvResults[[2]]];

Print["Peak \[CapitalDelta]i (Slow) = ", peakSlow];
Print["Peak \[CapitalDelta]i (Fast) = ", peakFast];



Keys[noisyCurrentSWVData]


(* --- Log-Spaced Frequency Sweep Setup --- *)

(* ClearAll[freqValues, makeSquareWave, freqScanConditions, freqSolutionsAssoc] *)

numFreqs = 25;
freqValues = N@Exp[Subdivide[Log[5], Log[1000], numFreqs - 1]];

(*numFreqs = 4;
freqValues = N@Exp[Subdivide[Log[600], Log[1000], numFreqs - 1]];
*)
makeSquareWave[freq_] := 
  Function[t, 
   E0 - VRampAmplitude/2 + VRampAmplitude*t/Tmax[freq] + 
    VPeakAmplitude*SmoothSquareWave[t, freq, epsilonWidth]];
(* Format frequency for label as a zero-padded integer *)
formatFreqLabel[freq_] := StringPadLeft[ToString[Round[freq]], 3, "0"];

(* Build frequency scan conditions with cleaned labels *)
freqScanConditions = Flatten[
   Table[
    {
     <|"label" -> "Freq_" <> formatFreqLabel[freq] <> "_f0",
       "freq" -> freq,
       "squareWave" -> makeSquareWave[freq],
       "fBound" -> 0|>,
     
     <|"label" -> "Freq_" <> formatFreqLabel[freq] <> "_f1",
       "freq" -> freq,
       "squareWave" -> makeSquareWave[freq],
       "fBound" -> 1|>
     },
    {freq, freqValues}
   ],
   1
];

(* Solve for each condition with progress monitor *)
freqSolutionsAssoc = Association[];

Monitor[
 Do[
  Module[{label, squareWaveInput, fValue, freqValue, solution},
   label = freqScanConditions[[i, "label"]];
   squareWaveInput = freqScanConditions[[i, "squareWave"]];
   fValue = freqScanConditions[[i, "fBound"]];
   freqValue = freqScanConditions[[i, "freq"]];
   
   solution = 
    NDSolve[
     {aptamerODE[fValue], circuitODE[fValue], initialAptamer, 
      initialRC, VApplied[t] == squareWaveInput[t]},
     {fOx, VAptamerGold},
     {t, 0, Tmax[freqValue]},
     Method -> {"IDA", "MaxDifferenceOrder" -> 5},
     MaxSteps -> Infinity
     ];
   
   freqSolutionsAssoc[label] = solution;
   ],
  {i, Length[freqScanConditions]}
 ],
 Row[{"Solving ", Dynamic[freqScanConditions[[i, "label"]]], 
   ProgressIndicator[i, {1, Length[freqScanConditions]}]}]
];



Keys[freqSolutionsAssoc]


(* Extract VAptamer from solution *)
Clear[VAptamerSol, iSWV]



label = "Freq_000_f0";
entry = SelectFirst[freqScanConditions, #["label"] == label &];
freq = entry["freq"];
squareWave = entry["squareWave"];
TmaxVal = Tmax[freq];

(* Total current = (V_applied - V) / R *)
VAptamerSol[t_] := VAptamerGold[t] /. freqSolutionsAssoc[label][[1]];
iSWV[t_] := (squareWave[t] - VAptamerSol[t]) / RSol;

Plot[iSWV[t], {t, 0.0 TmaxVal, 0.8 TmaxVal}, PlotLabel -> "Raw current", AxesLabel -> {"t", "I(t)"}, PlotRange -> All]

(* --- Define switch times --- *)
upSwitchTimes = Table[n/freq, {n, 1, Floor[TmaxVal*freq]}];
downSwitchTimes = Table[(n + 0.5)/freq, {n, 0, Floor[TmaxVal*freq - 0.5]}];

(* --- Define fixed time offset before switches --- *)
offsetBeforeSwitch = 1/(100 freq);

(* --- Sample current just before each voltage switch --- *)
fwd = Table[
  { -squareWave[downSwitchTimes[[n]]], iSWV[downSwitchTimes[[n]] - offsetBeforeSwitch] },
  {n, Length[downSwitchTimes]}
];

rev = Table[
  { -squareWave[upSwitchTimes[[n]]], iSWV[upSwitchTimes[[n]] - offsetBeforeSwitch] },
  {n, Length[upSwitchTimes]}
];

(* --- Compute SWV difference --- *)
minN = Min[Length[fwd], Length[rev]];
diff = Table[
  {fwd[[n, 1]], fwd[[n, 2]] - rev[[n, 2]]},
  {n, minN}
];

(* --- Plot SWV --- *)
ListPlot[{fwd, rev, diff},
  Joined -> True,
  PlotLegends -> {"Forward", "Reverse", "Diff"},
  AxesLabel -> {"Potential (V)", "Current (A)"},
  PlotLabel -> "SWV with Fixed Offset (Freq_000_f0)",
  PlotRange -> All,
  ImageSize -> Large
]



(* ::InheritFromParent:: *)
(**)


peakDeltaI = Max[Select[diff[[All, 2]], NumericQ]];



peakDeltaI = Max[diff[[All, 2]]]






(* ::InheritFromParent:: *)
(**)


(* --- Small constant to avoid division by zero --- *)
epsilon = 10^-6;

(* --- Function to compute peak \[CapitalDelta]I from label --- *)
getPeakDeltaI[label_] := Module[
  {
    entry, freq, squareWave, TmaxVal,
    VAptamerSol, iSWV, upSwitchTimes, downSwitchTimes,
    offsetBeforeSwitch, fwd, rev, minN, diff
  },
  
  entry = SelectFirst[freqScanConditions, #["label"] == label &];
  freq = entry["freq"];
  squareWave = entry["squareWave"];
  TmaxVal = Tmax[freq];

  VAptamerSol[t_] := VAptamerGold[t] /. freqSolutionsAssoc[label][[1]];
  iSWV[t_] := (squareWave[t] - VAptamerSol[t]) / RSol;

  upSwitchTimes = Table[n/freq, {n, 1, Floor[TmaxVal*freq]}];
  downSwitchTimes = Table[(n + 0.5)/freq, {n, 0, Floor[TmaxVal*freq - 0.5]}];
  offsetBeforeSwitch = 1/(100 freq);

  fwd = Table[
    { -squareWave[downSwitchTimes[[n]]], iSWV[downSwitchTimes[[n]] - offsetBeforeSwitch] },
    {n, Length[downSwitchTimes]}
  ];
  
  rev = Table[
    { -squareWave[upSwitchTimes[[n]]], iSWV[upSwitchTimes[[n]] - offsetBeforeSwitch] },
    {n, Length[upSwitchTimes]}
  ];

  minN = Min[Length[fwd], Length[rev]];
  diff = Table[
    {fwd[[n, 1]], fwd[[n, 2]] - rev[[n, 2]]},
    {n, minN}
  ];

  Max[diff[[All, 2]]]
];

(* --- Table of peak \[CapitalDelta]I and KDM --- *)
kdmTable = Table[
  Module[
    {freq, label0, label1, i0, i1, kdm},
    freq = Round[freqVal, 0.001];
    label0 = "Freq_" <> StringPadLeft[ToString[Round[freqVal]], 3, "0"] <> "_f0";
    label1 = "Freq_" <> StringPadLeft[ToString[Round[freqVal]], 3, "0"] <> "_f1";

    If[
      KeyExistsQ[freqSolutionsAssoc, label0] && KeyExistsQ[freqSolutionsAssoc, label1],
      i0 = getPeakDeltaI[label0];
      i1 = getPeakDeltaI[label1];
      kdm = (i1 - i0)/(0.5*(i1 + i0 + epsilon));
      <|"Frequency (Hz)" -> freq, "\[CapitalDelta]I (f=0)" -> i0*10^6, "\[CapitalDelta]I (f=1)" -> i1*10^6, "KDM" -> kdm|>,
      Nothing
    ]
  ],
  {freqVal, freqValues}
];

kdmTable // Dataset



ListLogLinearPlot[
  kdmTable[[All, {"Frequency (Hz)", "KDM"}]] // Normal // Values,
  Joined -> True,
  PlotMarkers -> {Automatic, Black},
  PlotStyle -> Black,
  PlotLabel -> "KDM vs Frequency",
  AxesLabel -> {"Frequency (Hz)", "KDM Gain (%)"},
  PlotRange -> {{1, 1000}, {-1, 1.5}},
  Background -> White,
  Frame -> True,
  FrameStyle -> Black,
  GridLines -> Automatic
]




ListLogLinearPlot[
  kdmTable[[All, {"Frequency (Hz)", "KDM"}]] // Normal // Values,
  Joined -> True,
  PlotMarkers -> {Automatic, Black},
  PlotStyle -> Black,
  PlotLabel -> "Simulated data",
  FrameLabel -> {
    Style["Frequency (Hz)", 18], 
    Style["KDM Gain (%)", 18]
  },
  PlotRange -> {{1, 1000}, {-1, 1.5}},
  Background -> White,
  Frame -> True,
  FrameStyle -> Black
]



ListLogLinearPlot[
  kdmTable[[All, {"Frequency (Hz)", "KDM"}]] // 
    Normal // 
    (Values[#] /. {f_, kdm_} :> {f, 100 kdm}) &,
  
  Joined -> True,
  PlotMarkers -> {Automatic, Black},
  PlotStyle -> Black,
  PlotLabel -> "Simulated data",
  FrameLabel -> {
    Style["Frequency (Hz)", 15], 
    Style["KDM Gain (%)", 15]
  },
  PlotRange -> {{1, 1000}, {-0.5, 0.8} * 100},  (* percentage range *)
  Background -> White,
  Frame -> True,
  FrameStyle -> Black
]



(* Export results to txt file *)

(* 1. Header section *)
headerText = StringJoin[
  "Simulation Parameters\n",
  "---------------------\n",
  "Physical Constants:\n",
  StringTemplate["F = `` C/mol\n"][F],
  StringTemplate["R = `` J/mol\[CenterDot]K\n"][R],
  StringTemplate["T = `` K\n"][T],
  StringTemplate["alpha = ``\n\n"][alpha],

  "System Parameters:\n",
  StringTemplate["nElec = `` electrons\n"][nElec],
  StringTemplate["Electrode Area A = `` m^2\n"][A],
  StringTemplate["Surface concentration Lambda = `` mol/m^2\n"][Lambda],
  StringTemplate["k0u (unbound) = `` 1/s\n"][k0u],
  StringTemplate["k0b (bound) = `` 1/s\n"][k0b],
  StringTemplate["E0 = `` V\n\n"][E0],

  "Time and Frequency:\n",
  StringTemplate["deltaV = `` V\n"][deltaV],
  StringTemplate["Npoints = ``\n"][Npoints],
  StringTemplate["SquareWaveFastFreq = `` Hz\n"][SquareWaveFastFreq],
  StringTemplate["SquareWaveSlowFreq = `` Hz\n"][SquareWaveSlowFreq],
  StringTemplate["VRampAmplitude = `` V\n"][VRampAmplitude],
  StringTemplate["VPeakAmplitude = `` V\n\n"][VPeakAmplitude],

  "Circuit Impedance:\n",
  StringTemplate["RSol = `` ohms\n"][RSol],
  StringTemplate["Cint = `` F\n\n"][Cint],

  "Voltage Function:\n",
  StringTemplate["epsilonWidth = ``\n\n"][epsilonWidth]
];

(* 2. KDM result table section *)
resultTableText = StringJoin[
  "Simulation Results (KDM)\n",
  "------------------------\n",
  "Frequency (Hz)\tDeltaI (f=0, uA)\tDeltaI (f=1, uA)\tKDM (%)\n",
  StringRiffle[
    kdmTable /. <|
      "Frequency (Hz)" -> f_,
      "\[CapitalDelta]I (f=0)" -> i0_,
      "\[CapitalDelta]I (f=1)" -> i1_,
      "KDM" -> kdm_
    |> :> StringTemplate["``\t``\t``\t``\n"][f, i0, i1, NumberForm[100 kdm, {4, 2}]],
    ""
  ]
];

(* 3. Combine and export *)
fullText = headerText <> "\n" <> resultTableText;

(* Define base directory and filename *)
resultsDir = FileNameJoin[{NotebookDirectory[], "results"}];
baseName = "SimulationReport";
ext = ".txt";

(* Create results directory if needed *)
If[!DirectoryQ[resultsDir], CreateDirectory[resultsDir]];

(* Generate a unique filename if one already exists *)
reportPath = Module[{i = 0, path},
  path = FileNameJoin[{resultsDir, baseName <> ext}];
  While[FileExistsQ[path],
    i++;
    path = FileNameJoin[{resultsDir, baseName <> "_" <> ToString[i] <> ext}];
  ];
  path
];

(* Export the text safely *)
Export[reportPath, fullText, "Text"]

