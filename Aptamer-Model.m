(* ::Package::"Tags"-><|"SuspiciousBox" -> <|Enabled -> False|>|>:: *)

(* Clear All *)
ClearAll["Global`*"]


(* ===================================== *)
(* ========== Physical Constants ========= *)
(* ===================================== *)


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
k0u=30; (* Standard rate constant for unbound state (1/s) *)
k0b=50; (* Standard rate constant for bound state (1/s) *)
(* note "Simulation-Based Approach to Determining Electron Transfer Rates Using Square-Wave Voltammetry" publication uses incorrect units for current which is confusing  
- Eq 8,9 are current /cm^2 not actual current *)

E0=-.32; (*Standard redox potential (V)*)
E0=0;  (* Set the Methylene Blue Standard redox potential to zero volts so that equations solve more easily. We can add it back in later! *)

(* Rratio=k0b/k0u; *) (*Ratio of bound to unbound rate constants*)
(* fBound = 0.5; *)(* the fraction of bound aptamers - replace with an analyte dependence function later *) 

(* Time and Frequency range *)
deltaV = 0.004; (* 10mV per step *) (* for ease of subsequent calcualations, make this an even number of milliseconds *)
Tmax[SquareWaveFreq_] :=2*VRampAmplitude/deltaV/SquareWaveFreq; (*50 ms total time*)
Npoints=2^13; (*Number of time samples*)
dt[SquareWaveFreq_] :=Tmax[SquareWaveFreq]/(Npoints-1); (*Time step size*)
timeSamples[SquareWaveFreq_]:=Range[0,Tmax[SquareWaveFreq],dt[SquareWaveFreq]]; (*Discrete time points for evaluation*)
freqResolution[SquareWaveFreq_]:=1/(Npoints*dt[SquareWaveFreq]); (*Frequency resolution*)
frequencyList[SquareWaveFreq_]=Table[n freqResolution[SquareWaveFreq],{n,0,Npoints/2-1}]; (*Positive frequencies only*)

(* System Impedence*)
RSol = 1470; (* 147 ohms Randle resistance *)
Cint = 4.4*10^-7; (*0.4 microFarads *) (* values from Subsecond-Resolved Molecular Measurements Using
Electrochemical Phase Interrogation of AptamerBased Sensors - but just assume capacitance not CPE *)



(* ===================================== *)
(* ========== Applied Voltage ============ *)
(* ===================================== *)


(* square wave input *)
SquareWaveFastFreq = 200; (* Hz *)(* subsequent visualization relies on this being an even number *)
SquareWaveSlowFreq = 10; (* Hz *) (* subsequent visualization relies on this being an even number *)

VRampAmplitude = 0.3; (* Volts total = 300mV total range *)
VPeakAmplitude = 0.025; (* Volts total = 25mV *)

(* Define square wave function for voltage *)
(* Define a smooth square wave approximation using tanh *)
epsilonWidth = 0.0005;

SmoothSquareWave[t_,freq_,width_]:=Tanh[Sin[2 Pi freq t]/width];  
(* SmoothSquareWave[t_,freq_,width_]:=SquareWave[ freq t]; *)

samplingWidth = 0.5; (* the CH Instruments potentiostat measures the average current over the last 50% of the cycle *)

(* VApplied[t_]:=E0-VRampAmplitude/2+VRampAmplitude*t/Tmax+VPeakAmplitude*SmoothSquareWave[t,squareWaveFreq,0.01]; *)
(*Generate times for up and down switches*)
upSwitchTimesSlow=Table[n/SquareWaveSlowFreq,{n,1,Floor[Tmax[SquareWaveSlowFreq]*SquareWaveSlowFreq]}];
downSwitchTimesSlow=Table[(n+0.5)/SquareWaveSlowFreq,{n,0,Floor[Tmax[SquareWaveSlowFreq]*SquareWaveSlowFreq-0.5]}];

upSwitchTimesFast=Table[n/SquareWaveFastFreq,{n,1,Floor[Tmax[SquareWaveFastFreq]*SquareWaveFastFreq]}];
downSwitchTimesFast=Table[(n+0.5)/SquareWaveFastFreq,{n,0,Floor[Tmax[SquareWaveFastFreq]*SquareWaveFastFreq-0.5]}];



(* ===================================== *)
(* ========== Aptamer Equations ========== *)
(* ===================================== *)

ClampExp[x_] := Exp[Clip[x, {-10, 10}]] (* clamp the eponential so we don't get insanely high or low values *)

(*Define rate constants based on VAptamerGold*)
(* note, we define the variable VAptamerGold, equal to double-layer capacitance potential, because it's more intuitive to think of it as the aptamer potential *)
koxExpr[fB_]:=(1-fB) k0u ClampExp[alpha nElec F (VAptamerGold[t]-E0)/(R T)]+fB k0b ClampExp[ alpha nElec F (VAptamerGold[t]-E0)/(R T)];
kredExpr[fB_]:=(1-fB) k0u ClampExp[-(1-alpha) nElec F (VAptamerGold[t]-E0)/(R T)]+fB k0b ClampExp[-(1-alpha) nElec F (VAptamerGold[t]-E0)/(R T)];

(*Oxidation fraction differential equation*)
aptamerODE[fB_]:=fOx'[t]==koxExpr[fB] (1-fOx[t])-kredExpr[fB] fOx[t];

initialAptamer=fOx[0]==0;


(* ===================================== *)
(* ========== Circuit Equations ========== *)
(* ===================================== *)


(* Current through capacitor *)
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
(*
VSWVSlow[t_]:=E0-VRampAmplitude/2+VRampAmplitude*t/Tmax[SquareWaveSlowFreq]+VPeakAmplitude*SmoothSquareWave[t,SquareWaveSlowFreq,epsilonWidth]; 
VSWVFast[t_]:=E0-VRampAmplitude/2+VRampAmplitude*t/Tmax[SquareWaveFastFreq]+VPeakAmplitude*SmoothSquareWave[t,SquareWaveFastFreq,epsilonWidth]
*)


(* ===================================== *)
(* ========== Solve Equations ============ *)
(* ===================================== *)


(* --- Log-Spaced Frequency Sweep Setup --- *)
numFreqs = 25;

freqValues = N@Exp[Subdivide[Log[5], Log[1000], numFreqs - 1]];

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
   
  solution = NDSolve[
	  {
	    aptamerODE[fValue],
	    circuitODE[fValue],
	    initialAptamer,
	    initialRC,
	    VApplied[t] == squareWaveInput[t]
	  },
	  {fOx, VAptamerGold},
	  {t, 0, Tmax[freqValue]},
	  Method -> {
	    "IDA" 
	  },
	  MaxSteps -> Infinity,
	  AccuracyGoal -> 6,
	  PrecisionGoal -> 6,
	  Compiled -> True                            (* Speeds up ODE RHS evaluation *)
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



(* ===================================== *)
(* ========== Sanity Checks =============== *)
(* ===================================== *)

label = "Freq_071_f1"; (* a representative data trace *)
entry = SelectFirst[freqScanConditions, #["label"] == label &];
freq = entry["freq"];
squareWave = entry["squareWave"];
TmaxVal = Tmax[freq];

(* Total current = (V_applied - V) / R *)
VAptamerSol[t_] := VAptamerGold[t] /. freqSolutionsAssoc[label][[1]];
iSWV[t_] := (squareWave[t] - VAptamerSol[t]) / RSol;

Plot[
	{fOx[t]/. freqSolutionsAssoc[label][[1]]},
	{t, 0,  TmaxVal},
	PlotLabel -> "Fraction of oxidized Methelyne Blue vs time",
	AxesLabel -> {"t", "f_ox"},
	PlotRange -> All
]

Plot[{10^3 squareWave[t], 10^3 VAptamerSol[t], 10^6*iSWV[t]}, {t, 0.35 TmaxVal, 0.45 TmaxVal}, PlotLabel -> "Voltages and current", AxesLabel -> {"t", "I(t)"}, PlotRange -> All, PlotLegends -> {"squareWave (mV)", "VAptamer (mV)", "iSWV (\[Micro]A)"}
]

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


(* ===================================== *)
(* == Plot Frequency dependent currents ==== *)
(* ===================================== *)


(* Separate f0 and f1 labels *)
f0labels = Select[Keys[freqSolutionsAssoc], StringEndsQ[#, "f0"] &];
f1labels = Select[Keys[freqSolutionsAssoc], StringEndsQ[#, "f1"] &];

(* Shared function to compute SWV diff curves *)
computeDiffCurve[label_] := Module[
  {entry, freq, squareWave, TmaxVal, VAptamerSol, iSWV,
   upSwitchTimes, downSwitchTimes, fwd, rev, minN, diff,
   offsetBeforeSwitch},

  entry = SelectFirst[freqScanConditions, #["label"] == label &];
  freq = entry["freq"];
  squareWave = entry["squareWave"];
  TmaxVal = Tmax[freq];
  offsetBeforeSwitch = 1/(100 freq);

  VAptamerSol[t_] := VAptamerGold[t] /. freqSolutionsAssoc[label][[1]];
  iSWV[t_] := (squareWave[t] - VAptamerSol[t]) / RSol;

  upSwitchTimes = Table[n/freq, {n, 1, Floor[TmaxVal*freq]}];
  downSwitchTimes = Table[(n + 0.5)/freq, {n, 0, Floor[TmaxVal*freq - 0.5]}];

  fwd = Table[
    { -squareWave[downSwitchTimes[[n]]],
      10^6 * iSWV[downSwitchTimes[[n]] - offsetBeforeSwitch] },
    {n, Length[downSwitchTimes]}];

  rev = Table[
    { -squareWave[upSwitchTimes[[n]]],
      10^6 * iSWV[upSwitchTimes[[n]] - offsetBeforeSwitch] },
    {n, Length[upSwitchTimes]}];

  minN = Min[Length[fwd], Length[rev]];

  diff = Table[
    {fwd[[n, 1]], fwd[[n, 2]] - rev[[n, 2]]},
    {n, minN}];

  diff
];

(* Compute difference curves *)
diffCurvesF0 = computeDiffCurve /@ f0labels;
diffCurvesF1 = computeDiffCurve /@ f1labels;

(* Frequency labels *)
frequenciesHz = ToExpression[
  StringReplace[f0labels, StartOfString ~~ "Freq_" ~~ f : NumberString ~~ "_f0" :> f]
];

(* Colors *)
nCurves = Length[diffCurvesF0];
lineColors = ColorData["BlueGreenYellow"] /@ Rescale[Reverse@Range[nCurves]];

(* Plot 1: fBound = 0 *)
curvePlotsF0 = MapThread[
  ListLinePlot[#1, PlotStyle -> {#2, Thick}, Joined -> True] &,
  {diffCurvesF0, lineColors}
];

plotF0 = Show[
  curvePlotsF0,
  PlotLegends -> Placed[
    Map["f = " <> ToString[#] <> " Hz" &, frequenciesHz],
    Right
  ],
  AxesLabel -> {"Potential (V)", "Forward - Reverse Current (\[Micro]A)"},
  PlotLabel -> "SWV \[CapitalDelta]I for fBound = 0",
  Frame -> True,
  ImageSize -> Large,
  PlotRange -> {Automatic, {0, 10}}
];

(* Plot 2: fBound = 1 *)
curvePlotsF1 = MapThread[
  ListLinePlot[#1, PlotStyle -> {#2, Thick}, Joined -> True] &,
  {diffCurvesF1, lineColors}
];

plotF1 = Show[
  curvePlotsF1,
  PlotLegends -> Placed[
    Map["f = " <> ToString[#] <> " Hz" &, frequenciesHz],
    Right
  ],
  AxesLabel -> {"Potential (V)", "Forward - Reverse Current (\[Micro]A)"},
  PlotLabel -> "SWV \[CapitalDelta]I for fBound = 1",
  Frame -> True,
  ImageSize -> Large,
  PlotRange -> {Automatic, {0, 10}}
];

(* Output both plots *)
{plotF0, plotF1}



(* ::InheritFromParent:: *)
(**)


(* ===================================== *)
(* ========== Generate data table ======== *)
(* ===================================== *)

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

(* --- Function to compute peak \[CapitalDelta]I from label --- *)
getBaselineI[label_] := Module[
  {
    entry, freq, squareWave, TmaxVal,
    VAptamerSol, iSWV, upSwitchTimes, downSwitchTimes,
    offsetBeforeSwitch, fwd, rev, minN, diff,
    potentials, deltaI, lowRegion, highRegion,
    lowMean, highMean
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

  potentials = diff[[All, 1]];
  deltaI = diff[[All, 2]];

  lowRegion = Pick[deltaI, potentials, _?(# < -0.015 &)];
  highRegion = Pick[deltaI, potentials, _?(# > 0.015 &)];

  lowMean = If[Length[lowRegion] > 0, Mean[lowRegion], 0];
  highMean = If[Length[highRegion] > 0, Mean[highRegion], 0];

  Mean[{lowMean, highMean}]
];
(* --- Table of peak \[CapitalDelta]I and KDM, with added baseline columns --- *)
(* --- Table of peak \[CapitalDelta]I and \[CapitalDelta]I-Baseline values --- *)
kdmTable = Table[
  Module[
    {freq, label0, label1, i0, i1, baseline0, baseline1},
    freq = Round[freqVal, 0.001];
    label0 = "Freq_" <> StringPadLeft[ToString[Round[freqVal]], 3, "0"] <> "_f0";
    label1 = "Freq_" <> StringPadLeft[ToString[Round[freqVal]], 3, "0"] <> "_f1";

    If[
      KeyExistsQ[freqSolutionsAssoc, label0] && KeyExistsQ[freqSolutionsAssoc, label1],
      i0 = getPeakDeltaI[label0];
      i1 = getPeakDeltaI[label1];
      baseline0 = getBaselineI[label0];
      baseline1 = getBaselineI[label1];
      <|
        "Frequency (Hz)" -> freq,
        "\[CapitalDelta]I (f=0) [\[Micro]A]" -> i0*10^6,
        "\[CapitalDelta]I (f=1) [\[Micro]A]" -> i1*10^6,
        "Baseline (f=0) [\[Micro]A]" -> baseline0*10^6,
        "Baseline (f=1) [\[Micro]A]" -> baseline1*10^6,
        "\[CapitalDelta]I - Baseline (f=0) [\[Micro]A]" -> (i0 - baseline0)*10^6,
        "\[CapitalDelta]I - Baseline (f=1) [\[Micro]A]" -> (i1 - baseline1)*10^6
      |>,
      Nothing
    ]
  ],
  {freqVal, freqValues}
];

kdmTable // Dataset


ListLogLinearPlot[
  {
    kdmTable[[All, {"Frequency (Hz)", "\[CapitalDelta]I - Baseline (f=0) [\[Micro]A]"}]] // Normal // Values,
    kdmTable[[All, {"Frequency (Hz)", "\[CapitalDelta]I - Baseline (f=1) [\[Micro]A]"}]] // Normal // Values
  },
  Joined -> True,
  PlotMarkers -> {Automatic},
  PlotStyle -> {Blue, Orange, Dashed, Dashed},
  PlotLabel -> "Peak and Baseline-Adjusted Currents vs Frequency",
  AxesLabel -> {"Frequency (Hz)", "Current (\[Mu]A)"},
  PlotRange -> {{1, 1000}, {0,3}},
  Background -> White,
  Frame -> False,
  FrameStyle -> Black,
  GridLines -> Automatic,
  PlotLegends -> {
    "f = 0 (\[CapitalDelta]I - baseline)", 
    "f = 1 (\[CapitalDelta]I - baseline)"
  }
]



(* Extract raw data *)
raw0 = kdmTable[[All, {"Frequency (Hz)", "\[CapitalDelta]I (f=0) [\[Micro]A]"}]] // Normal // Values;
raw1 = kdmTable[[All, {"Frequency (Hz)", "\[CapitalDelta]I (f=1) [\[Micro]A]"}]] // Normal // Values;

(* Normalize each by their value at the lowest frequency *)
norm0 = raw0[[All, 2]]/First[raw0[[All, 2]]];
norm1 = raw1[[All, 2]]/First[raw1[[All, 2]]];

(* Combine back with frequency for plotting *)
normData0 = Transpose[{raw0[[All, 1]], norm0}];
normData1 = Transpose[{raw1[[All, 1]], norm1}];

(* Plot *)
ListLogLinearPlot[
  {normData0, normData1},
  Joined -> True,
  PlotMarkers -> {Automatic},
  PlotStyle -> {Blue, Orange},
  PlotLabel -> "Normalized Current vs Frequency",
  AxesLabel -> {"Frequency (Hz)", "Normalized Current"},
  PlotRange -> {{1, 1000}, {0,500}},
  Background -> White,
  Frame -> True,
  FrameStyle -> Black,
  GridLines -> Automatic,
  PlotLegends -> {"f = 0", "f = 1"}
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
(* Extract headers *)
headers = Keys[First@kdmTable];

(* Fixed column width in characters *)
colWidth = 20;

(* Format cell: pad and align *)
formatCell[val_] := Module[{str},
  str = If[NumericQ[val], ToString[NumberForm[val, {7, 4}]], ToString[val]];
  StringPadRight[str, colWidth]
];

(* Format header row *)
formatHeader := StringJoin[formatCell /@ headers] <> "\n";

(* Format data row *)
formatRow[row_Association] := StringJoin[
  formatCell /@ Lookup[row, headers]
] <> "\n";

(* Build full table string *)
resultTableText = StringJoin[
  "Simulation Results (KDM)\n",
  "------------------------\n",
  formatHeader,
  StringJoin[formatRow /@ kdmTable]
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

