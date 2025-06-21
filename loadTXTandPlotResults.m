(* ::Package:: *)

(* Set directory and read the first matching file *)
resultsDir = FileNameJoin[{NotebookDirectory[], "results"}];
file = First@FileNames["SimulationReport_*.txt", resultsDir];
reportText = Import[file, "Text"];

(* Extract KDM block *)
kdmBlock = StringCases[
   reportText,
   "Simulation Results (KDM)\n" ~~ s__ :> s
] // First;

(* Split into rows and columns *)
lines = StringSplit[kdmBlock, "\n"];
dataLines = Select[lines, StringContainsQ[#, DigitCharacter] &];
parsed = StringSplit[#, Whitespace] & /@ dataLines;

(* Drop the first row if it contains headers *)
numericRows = Rest[parsed];

(* Define column names *)
headers = {
  "Frequency (Hz)", 
  "\[CapitalDelta]I (f=0) [\[Micro]A]", 
  "\[CapitalDelta]I (f=1) [\[Micro]A]", 
  "Baseline (f=0) [\[Micro]A]", 
  "Baseline (f=1) [\[Micro]A]", 
  "\[CapitalDelta]I - Baseline (f=0) [\[Micro]A]", 
  "\[CapitalDelta]I - Baseline (f=1) [\[Micro]A]"
};

(* Construct dataset *)
kdmTable = Dataset[
  AssociationThread[headers, ToExpression /@ #] & /@ numericRows
];

(* Plot selected columns *)
ListLogLinearPlot[
  {
    kdmTable[[All, {"Frequency (Hz)", "\[CapitalDelta]I - Baseline (f=0) [\[Micro]A]"}]] // Normal // Values,
    kdmTable[[All, {"Frequency (Hz)", "\[CapitalDelta]I - Baseline (f=1) [\[Micro]A]"}]] // Normal // Values
  },
  Joined -> True,
  PlotMarkers -> {Automatic},
  PlotStyle -> {Blue, Orange},
  PlotLabel -> "Baseline-Subtracted SWV Currents",
  AxesLabel -> {"Frequency (Hz)", "Current (\[Micro]A)"},
  PlotRange -> {{1, 1000}, Automatic},
  Background -> White,
  Frame -> True,
  GridLines -> Automatic,
  PlotLegends -> {
    "f = 0 (\[CapitalDelta]I - baseline)", 
    "f = 1 (\[CapitalDelta]I - baseline)"
  }
]



(* === Compute Signal Gain from Simulation Report === *)

(* Convert dataset to list of associations *)
rows = Normal[kdmTable];

(* Extract numeric lists from associations *)
freqs = rows[[All, "Frequency (Hz)"]];
i0 = rows[[All, "\[CapitalDelta]I - Baseline (f=0) [\[Micro]A]"]];
i1 = rows[[All, "\[CapitalDelta]I - Baseline (f=1) [\[Micro]A]"]];

(* Compute signal gain: (I_f=1 - I_f=0)/I_f=0 *)
gainSim = MapThread[
  {#1, (#2 - #3)/#3} &,
  {freqs, i1, i0}
];

(* Plot simulated signal gain *)
ListLogLinearPlot[
  gainSim,
  Joined -> True,
  PlotMarkers -> Automatic,
  PlotStyle -> {Black, Thick},
  Frame -> True,
  FrameLabel -> {"Frequency (Hz)", "Signal Gain"},
  PlotLabel -> "Simulated Signal Gain vs Frequency\n(I_f=1 - I_f=0) / I_f=0",
  PlotRange -> All,
  GridLines -> Automatic
]

