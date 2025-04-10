(* ::Package:: *)

(* Directory and file list *)
resultsDir = FileNameJoin[{NotebookDirectory[], "results"}];
fileNames = FileNames["SimulationReport_*.txt", resultsDir];

(* Function to extract RSol and Cint from the header *)
extractRC[reportText_] := Module[
  {rVal, cVal},
  rVal = StringCases[reportText, 
    "RSol = " ~~ x : NumberString ~~ ___ ~~ "ohms" :> ToExpression[x]] // First;
  cVal = StringCases[reportText, 
    "Cint = " ~~ x : NumberString ~~ ___ ~~ "F" :> ToExpression[x]] // First;
  {rVal, cVal}
];

(* Function to extract KDM plot data *)
extractKDMPlotData[reportText_] := Module[
  {kdmSection, lines, dataLines, parsedData, numericData},
  
  kdmSection = 
    StringCases[reportText, 
      Shortest[
        "Simulation Results (KDM)\n" ~~ ___ ~~ 
         "Frequency (Hz)\tDeltaI (f=0, uA)\tDeltaI (f=1, uA)\tKDM (%)\n" ~~ 
         s__ ~~ EndOfString] :> s] // First;
  
  lines = StringSplit[kdmSection, "\n"];
  dataLines = Select[lines, StringContainsQ[#, DigitCharacter] &];
  parsedData = StringSplit[#, Whitespace] & /@ dataLines;
  numericData = ToExpression /@ parsedData;
  
  numericData[[All, {1, 4}]]
];

(* Gather all data + labels *)
plotDataList = 
  Table[
    Module[
      {text, rcVals, kdmData, label, rVal, cValMicro},
      text = Import[file, "Text"];
      rcVals = extractRC[text];
      rVal = rcVals[[1]];
      cValMicro = rcVals[[2]]*10^6; (* Convert F to \[Micro]F *)
      kdmData = extractKDMPlotData[text];
      label = StringTemplate["R = `` \[CapitalOmega], C = `` \[Micro]F"][rVal, NumberForm[cValMicro, {4, 2}]];
      {kdmData, label}
    ],
    {file, fileNames}
  ];
;

(* Generate color-coded plot with RC legends *)
ListLogLinearPlot[
  plotDataList[[All, 1]],
  Joined -> True,
  PlotMarkers -> Automatic,
  PlotStyle -> ColorData[97] /@ Range[Length[plotDataList]],
  PlotLabel -> "Simulated KDM Overlay",
  FrameLabel -> {
    Style["Frequency (Hz)", 15], 
    Style["KDM Gain (%)", 15]
  },
  PlotRange -> {{1, 1000}, {-0.5, 0.8} * 100},
  Background -> White,
  Frame -> True,
  FrameStyle -> Black,
  PlotLegends -> Placed[
    plotDataList[[All, 2]], 
    Right
  ]
]

