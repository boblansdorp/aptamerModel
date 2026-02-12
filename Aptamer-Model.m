(* ::Package::"Tags"-><|"SuspiciousBox" -> <|Enabled -> False|>|>:: *)

(* Clear All *)
ClearAll["Global`*"]


(* ===================================== *)
(* ========== Physical Constants ========= *)
(* ===================================== *)


F=96485; (* Faraday's constant (C/mol) *)
R=8.314; (* Gas constant (J/mol K) *)
T=298; (* Temperature (K) *)


(* ===================================== *)
(* ========== Model Parameters =========== *)
(* ===================================== *)


analyticalModelFit=<|"CDL"->71/200000000,"Rsol"->294,"Rct0"->17021.386901767124`,"Rct1"->6573.064966390861`,"kD"->0.017733158127065773`,"Capt"->2.2012032765291434`*^-7|> (* obtained using a simple 2R, 2C, Rct0, Rct1, kD model. Assumes data was baseline subtracted! *)


(* System Impedence*)

RSol = 238; (* 238 ohms Randle resistance [Ohms] *) (* 1.58k total with resistor *)
RSol = 1580; (* 238 ohms Randle resistance [Ohms] *) (* 1.58k total with resistor *)
RSol = 1620; (* from EIS fit with added resistor *)

RSol = analyticalModelFit["Rsol"];  (* 294 Ohm from Jenny's EIS fits *)

Cint = 3.55*10^-7; (* average of 337nF and 370nF  *) (* just assume capacitance not CPE *)

Cint = analyticalModelFit["CDL"];



(* k0u=0.5; *) (*Standard rate constant for unbound state (cm/s)*) (* let's not do the tunneling calculation done in Langmuir.2017 May 09;33(18):4407\[Dash]4413... *)
k0u=60; (* Standard rate constant for unbound state (1/s) *)
k0b=160; (* Standard rate constant for bound state (1/s) *)
k0u = 1/(2* analyticalModelFit["Rct0"] * analyticalModelFit["Capt"]);
k0b = 1/(2* analyticalModelFit["Rct1"] * analyticalModelFit["Capt"]);



(* note "Simulation-Based Approach to Determining Electron Transfer Rates Using Square-Wave Voltammetry" publication uses incorrect units for current which is confusing  
- Eq 8,9 are current /cm^2 not actual current *)


alpha=0.5; (*Charge transfer coefficient*)
nElec = 2; (* assume two electron transfer per Methylene Blue  *)

E0=-.32; (*Standard redox potential (V)*)
E0=0;  (* Set the Methylene Blue Standard redox potential to zero volts so that equations solve more easily. We can add it back in later! *)

A = 2* Pi * 0.075 * 3 / 100; (*Electrode electrochemical area (cm^2) for 3mm long electrode, 75 micrometer radius*)
A=A*2; (* assume that electrochemical roughening increases A by 2 *)

Lambda= 3*10^12/(6.02*10^23); (*Surface concentration (moles/cm^2)*) (* this parameter is fudged to match current amplitude observed *)
Lambda = 4 R T analyticalModelFit["Capt"] / ( (nElec F )^2 A)

(* roughly 10^12 molecules/cm^2 from Anal.Chem.2023,95,2229\[Minus]2237 *)



(* ===================================== *)
(* ========== Graphing Parameters ========= *)
(* ===================================== *)
(* --- Log-Spaced Frequency Sweep Setup --- *)

(* 
numFreqs = 20;
freqValues = N@Exp[Subdivide[Log[5], Log[999], numFreqs - 1]] *)

(* Experimental parameters Plaxco Lab
Current_10	
Current_15	
Current_20	
Current_25	
Current_30	
Current_40	
Current_70	
Current_80	
Current_100	
Current_200	
Current_300	
Current_400	
Current_500	
Current_600 
*)

freqValues = {10, 15, 20, 25, 30, 40, 70, 80, 100, 200, 300, 400, 500, 600};  (* use multiple frequencies for frequency-dependence *)



freqValues = {25, 200};  (* use just 2 for "calibration curves" (KDM vs freq) since we only need 2 frequencies for KDM*)



(* Format frequency for label as a zero-padded integer *)
formatFreqLabel[freq_] := StringPadLeft[ToString[Round[freq]], 3, "0"];
(* concValues = Prepend[10.^Range[-8, -2], 0.]; *) (* from 10^-7 to 10^-2 M, with a zero thrown in *)
(* Experimental parameters Plaxco Lab
0.0E+00 M - rows 1-4
1.0E-05 M - rows 5-7
4.0E-05 M - rows 8-10
1.0E-04 M - rows 11-13
3.2E-04 M - rows 14-16
9.3E-03 M - rows 17-19
*)
(* concValues = {0,9.3*10^-3}; *) (* quick test only highest and lowest *)

concValues = {
	0,
	1*10^-5,
	4*10^-5,
	1*10^-4,
	3.2*10^-4,
	9.3*10^-3
}; (* use multiple concentrations for a titration "calibration curve" *)
 
concValues = {0}; (* only absence of target data *)
concValues = {0, 9.3*10^-3}; (* use 2 concentrations for frequency dependence *)


(* ===================================== *)
(* ========== Applied Voltage ============ *)
(* ===================================== *)



(* Time and Frequency range *)
deltaV = 0.004; (* 4mV per step *) (* for ease of subsequent calcualations, make this an even number of milliseconds *)
Tmax[SquareWaveFreq_] :=2*VRampAmplitude/deltaV/SquareWaveFreq; (*50 ms total time*)

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


(* ===================================== *)
(* ========== Aptamer Equations ========== *)
(* ===================================== *)

ClampExp[x_] := Exp[Clip[x, {-10, 10}]] (* clamp the eponential so we don't get insanely high or low values *)


(* the rate that bound and unbound states interchange is related to the dissociation constant *)
Kd = 1*10^-6;           (* Dissociation constant in M - value can vary depending on aptamer!! *) 
Kd = 2.951*10^-3;           (* Dissociation constant in M - value can vary depending on aptamer!! 2.951mM from experimental fit *)
Kd = analyticalModelFit["kD"] ;

kon = 3*10^5;          (* Association rate in M^-1 s^-1 - a typical value is diffusion limited to around this value*)
(* C = ...; *)            (* Constant analyte concentration in M *)
koff = Kd*kon;
(*Define rate constants based on VAptamerGold*)
(* note, we define the variable VAptamerGold, equal to double-layer capacitance potential, because it's more intuitive to think of it as the aptamer potential *)
 
koxBoundExpr := k0b ClampExp[ alpha nElec F (VAptamerGold[t]-E0)/(R T)];
kredBoundExpr := k0b ClampExp[-(1- alpha) nElec F (VAptamerGold[t]-E0)/(R T)]
koxUnboundExpr := k0u ClampExp[alpha nElec F (VAptamerGold[t]-E0)/(R T)];
kredUnboundExpr := k0u ClampExp[-(1-alpha) nElec F (VAptamerGold[t]-E0)/(R T)];

(*Oxidation fraction differential equation*)

aptamerBoundODEs := { 
	fOxBound'[t] == koxBoundExpr fRedBound[t] - kredBoundExpr fOxBound[t] + kon Conc fOxUnbound[t] - koff fOxBound[t], 
	fRedBound'[t] == -koxBoundExpr fRedBound[t] + kredBoundExpr fOxBound[t] + kon Conc fRedUnbound[t] - koff fRedBound[t]
	};

aptamerUnboundODEs := {
	fOxUnbound'[t] == koxUnboundExpr fRedUnbound[t] - kredUnboundExpr fOxUnbound[t] - kon Conc fOxUnbound[t] + koff fOxBound[t],
	fRedUnbound'[t] == -koxUnboundExpr fRedUnbound[t] + kredUnboundExpr fOxUnbound[t] - kon Conc fRedUnbound[t] + koff fRedBound[t]
}

(* initial conditions *)
initialAptamer={fOxBound[0]==0, fOxUnbound[0]==0, fRedUnbound[0] == 1-Conc / (Conc + Kd), fRedBound[0] == Conc / (Conc + Kd)};



(* ===================================== *)
(* ========== Circuit Equations ========== *)
(* ===================================== *)


(* Current through capacitor *)
iCap[t_]:=Cint VAptamerGold'[t];

(* Current through aptamer - due to changing oxidation state from sum of both bound and unbound aptamers *)
iAptamerExpr[t] :=nElec*F*A*Lambda*( fOxBound'[t]+ fOxUnbound'[t]);

(*Total current through resistor*)
iTotalExpr[t]:=iCap[t]+iAptamerExpr[t];

(*Voltage drop across resistor*)
circuitODE = VApplied[t]-VAptamerGold[t]==RSol*iTotalExpr[t];

VCap0 = 0; (* assume initial charge zero *)
VCap0 = makeSquareWave[x][0]; (* assume initial double layer is fully charged (zero current through solutino resistance) *)

(*Initial voltage condition*)
initialRC=VAptamerGold[0]==VCap0;



(* ===================================== *)
(* ========== Solve Equations ============ *)
(* ===================================== *)


formatConc[conc_] := Module[{n = N[conc, 3]},
  StringReplace[
    ToString[
      NumberForm[n, {3, 2}, 
        ExponentFunction -> (If[True, #1, #1] &), 
        NumberFormat -> (StringJoin[#1, "e", #3] &)
      ]
    ],
    " " -> ""
  ]
];

freqScanConditions = 
  Flatten[
    Table[
      <|
        "label" -> "Freq_" <> formatFreqLabel[freq] <> "_Conc_" <> formatConc[conc],
        "freq" -> freq,
        "squareWave" -> makeSquareWave[freq],
        "Conc" -> conc
      |>,
      {freq, freqValues},
      {conc, concValues}
    ],
    1
  ];

makeSquareWave[freq_] := 
  Function[t, 
   E0 - VRampAmplitude/2 + VRampAmplitude*t/Tmax[freq] + 
    VPeakAmplitude*SmoothSquareWave[t, freq, epsilonWidth]];

(* Solve for each condition with progress monitor *)
freqSolutionsAssoc = Association[];





(* 
Monitor[
 Do[
  Module[{label, squareWaveInput, fValue, freqValue, solution},
   label = freqScanConditions[[i, "label"]];
   squareWaveInput = freqScanConditions[[i, "squareWave"]];
   freqValue = freqScanConditions[[i, "freq"]];
   concValue = freqScanConditions[[i, "Conc"]];
  solution = NDSolve[
	  {
	    aptamerBoundODEs /. Conc -> concValue,
	    aptamerUnboundODEs /. Conc -> concValue,
	    circuitODE,
	    initialAptamer/. Conc -> concValue,
	    initialRC,
	    VApplied[t] == squareWaveInput[t]
	  },
	  {fOxBound, fOxUnbound, VAptamerGold},
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
]; *)
{totalTime, timingResult} =
  AbsoluteTiming[
    Monitor[
      Do[
        Module[{label, squareWaveInput, fValue, freqValue, concValue, solution},
          label          = freqScanConditions[[i, "label"]];
          squareWaveInput = freqScanConditions[[i, "squareWave"]];
          freqValue      = freqScanConditions[[i, "freq"]];
          concValue      = freqScanConditions[[i, "Conc"]];

          solution = NDSolve[
            {
              aptamerBoundODEs   /. Conc -> concValue,
              aptamerUnboundODEs /. Conc -> concValue,
              circuitODE,
              initialAptamer /. Conc -> concValue,
              initialRC,
              VApplied[t] == squareWaveInput[t]
            },
            {fOxBound, fOxUnbound, VAptamerGold},
            {t, 0, Tmax[freqValue]},
            (* Method -> {"IDA"}, *)
            MaxSteps -> Infinity,
            AccuracyGoal -> 6,
            PrecisionGoal -> 6,
            Compiled -> True
          ];

          freqSolutionsAssoc[label] = solution;
        ],
        {i, Length[freqScanConditions]}
      ],
      Row[{
        "Solving ", Dynamic[freqScanConditions[[i, "label"]]],
        ProgressIndicator[i, {1, Length[freqScanConditions]}]
      }]
    ]
  ];

Print["Total solve time = ", totalTime, " s"];







(* ===================================== *)
(* ======= Store results to file ====== *)
(* ===================================== *)
simulationMetadata = <|
	"Timestamp" -> DateString[Now, "ISODateTime"],
	"NotebookDirectory" -> NotebookDirectory[],
  "Parameters" -> Association@{
    "F" -> F,
    "R" -> R,
    "T" -> T,
    "RSol" -> RSol,
    "Cint" -> Cint,
    "k0u" -> k0u,
    "k0b" -> k0b,
    "alpha" -> alpha,
    "nElec" -> nElec,
    "E0" -> E0,
    "A" -> A,
    "Lambda" -> Lambda,
    "numFreqs" -> numFreqs,
    "freqValues" -> freqValues,
    "concValues" -> concValues,
    "deltaV" -> deltaV,
    "SquareWaveFastFreq" -> SquareWaveFastFreq,
    "SquareWaveSlowFreq" -> SquareWaveSlowFreq,
    "VRampAmplitude" -> VRampAmplitude,
    "VPeakAmplitude" -> VPeakAmplitude,
    "epsilonWidth" -> epsilonWidth,
    "samplingWidth" -> samplingWidth,
    "Kd" -> Kd,
    "kon" -> kon,
    "koff" -> koff
  },
  "Equations" -> <|
	  "aptamerBoundODEs"    -> DownValues[aptamerBoundODEs],
	  "aptamerUnboundODEs"  -> DownValues[aptamerUnboundODEs],
	  "circuitODE"          -> DownValues[circuitODE],
	  "initialAptamer"      -> DownValues[initialAptamer],
	  "initialRC"           -> DownValues[initialRC],
	  "makeSquareWave"      -> DownValues[makeSquareWave],
	  "Tmax"                -> DownValues[Tmax],
	  "SmoothSquareWave"    -> DownValues[SmoothSquareWave]
	|>,
  "SweepConditions" -> freqScanConditions
|>;

allResultsPackage = <|
  "Solutions" -> freqSolutionsAssoc,
  "Metadata" -> simulationMetadata
|>;
(* Custom label for the run, optional *)

(* Determine directory of the running notebook or script *)
baseDirectory = If[
  StringQ[NotebookDirectory[]], 
  NotebookDirectory[], 
  DirectoryName[$InputFileName] (* fallback for scripts *)
];

(* Optional label and timestamp *)
runLabel = "matchToExperiment";
timestamp = StringReplace[DateString[{"Year", "Month", "Day", "Hour", "Minute", "Second"}], ":" -> ""];
outputDirectory = FileNameJoin[{baseDirectory, "results"}];

(* Ensure results directory exists *)
Quiet[
  CreateDirectory[outputDirectory, CreateIntermediateDirectories -> True]
];

(* Construct full file path *)
dynamicFilePath = FileNameJoin[{outputDirectory, "aptamer_results_" <> runLabel <> "_" <> timestamp <> ".mx"}];

Export[dynamicFilePath, allResultsPackage]





Keys[freqSolutionsAssoc];


(* ===================================== *)
(* === Extracting voltage and current ====== *)
(* ===================================== *)
(* Total current = (V_applied - V) / R *)
VAptamerSol[label_][t_] := VAptamerGold[t] /. freqSolutionsAssoc[label][[1]];
iSWV[label_, squareWave_][t_] := (squareWave[t] - VAptamerSol[label][t]) / RSol;



freqScanConditions


(* ===================================== *)
(* ======= Sanity Check Raw current ====== *)
(* ===================================== *)
label = "Freq_025_Conc_0e"; (* a representative data trace *)
entry = SelectFirst[freqScanConditions, #["label"] == label &];
freq = entry["freq"];
squareWave = entry["squareWave"];
TmaxVal = Tmax[freq]

Plot[
	{fOxBound[t]/. freqSolutionsAssoc[label][[1]], fOxUnbound[t]/. freqSolutionsAssoc[label][[1]]},
	{t, 0,  TmaxVal},
	PlotLabel -> "Fraction of oxidized Methelyne Blue vs time",
	AxesLabel -> {"t", "f_ox"},
	PlotRange -> All
]
Plot[{10^3 squareWave[t], 10^3 VAptamerSol[label][t], 10^6*iSWV[label, squareWave][t]}, {t, 0.45 TmaxVal, 0.55 TmaxVal}, PlotLabel -> "Voltages and current", AxesLabel -> {"t", "I(t)"}, 
	PlotRange -> {Automatic,{-10,10}}, PlotLegends -> {"squareWave (mV)", "VAptamer (mV)", "iSWV (\[Micro]A)"}
]


(* ===================================== *)
(* ==== Sanity Check Difference Current === *)
(* ===================================== *)

computeDiffCurve[label_] := Module[
  {
    entry, freq, squareWave, TmaxVal, upSwitchTimes, downSwitchTimes,
    fwd, rev, minN, diff, offsetBeforeSwitch, sampleAvg, iFunc
  },
  
  entry = SelectFirst[freqScanConditions, #["label"] == label &];
  freq = entry["freq"];
  squareWave = entry["squareWave"];
  TmaxVal = Tmax[freq];
  offsetBeforeSwitch = 1/(100 freq);
  iFunc = iSWV[label, squareWave];  (* freeze label and squareWave *)

  (* Switching times *)
  upSwitchTimes = Table[n/freq, {n, 1, Floor[TmaxVal*freq]}];
  downSwitchTimes = Table[(n + 0.5)/freq, {n, 0, Floor[TmaxVal*freq - 0.5]}];

  (* Averaging function over final portion of half-cycle *)
  sampleAvg[nextSwitchTime_] := Module[{t1, t2, ts},
    t2 = nextSwitchTime - offsetBeforeSwitch;
    t1 = t2 - samplingWidth/(2*freq);  (* 25% of full cycle *)
    ts = Subdivide[t1, t2, 99];        (* 100 points *)
    Mean[iFunc /@ ts]
  ];

  (* Compute forward and reverse SWV with averaging *)
  fwd = Table[
    {
      -squareWave[downSwitchTimes[[n]]],
      10^6 * sampleAvg[downSwitchTimes[[n]]]
    },
    {n, Length[downSwitchTimes]}
  ];

  rev = Table[
    {
      -squareWave[upSwitchTimes[[n]]],
      10^6 * sampleAvg[upSwitchTimes[[n]]]
    },
    {n, Length[upSwitchTimes]}
  ];

  minN = Min[Length[fwd], Length[rev]];

  diff = Table[
    {fwd[[n, 1]], fwd[[n, 2]] - rev[[n, 2]]},
    {n, minN}
  ];

  <|
    "fwd" -> fwd,
    "rev" -> rev,
    "diff" -> diff
  |>
];


curve = computeDiffCurve[label];

ListPlot[
  {curve["fwd"], curve["rev"], curve["diff"]},
  Joined -> True,
  PlotLegends -> {"Forward", "Reverse", "Diff"},
  AxesLabel -> {"Potential (V)", "Current (\[Micro]A)"},
  PlotLabel -> "SWV Components",
  PlotRange -> All,
  ImageSize -> Large
]


(* ===================================== *)
(* == This file just generates .mx files === *)
(* == for different starting conditions ==== *)
(* ===================================== *)


(* ===================================== *)
(* == Almost all the plotting logic  ====== *)
(* == has been moved to another file ====== *)
(* ===================================== *)
