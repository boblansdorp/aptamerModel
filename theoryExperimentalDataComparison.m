(* ::Package:: *)

(* ::Input:: *)
(* ClearAll["Global`*"]*)


(* ::Input:: *)
(*(* Load TXT files *)*)
(**)
(*(* voltammogramPath="C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\experimentalData\\voltammograms\\" *)*)
(*voltammogramPath="C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\experimentalData\\spikeVoltammograms\\"*)
(**)
(*(* in voltammogram we need to pick which channels correspond to high and low resistance experiments from voltammogramPath *)*)
(*channelLowResistor = 5;*)
(*channelHighResistor = 2;*)
(*channelHighResistor = 6;*)
(*(* dataSeriesToUseNoResistor = 7; (* which column of data (e.g. which recorded potentiostat channel *)*)
(*dataSeriesToUseWithResistor = 4; (* which column of data (e.g. which recorded potentiostat channel *) *)*)
(**)
(*dataSeriesToUseLowConc = 2; (* which filename (e.g. S1_5Hz__1.txt would be 1 *)*)
(*dataSeriesToUseHighConc = 18; (* which filename (e.g. S1_5Hz__18.txt would be 18 *)*)
(**)
(**)
(*(* simulationDataWithResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_highRhighKet3.txt" *)*)
(**)
(*simulationDataWithResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_export_CDL-355 Rsol-1620 k0u-133 k0b-345 kD-0.0177 Lamda-2E-12.txt"*)
(*simulationDataWithResistor=Import[simulationDataWithResistorFilePath,"Table"];*)
(*(* simulationDataWithNoResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_lowRhighKet2.txt" *)*)
(**)
(*simulationDataWithNoResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_export_CDL-355 Rsol-294 k0u-133 k0b-345 kD-0.0177 Lamda-2E-12.txt"*)
(*simulationDataWithNoResistor=Import[simulationDataWithNoResistorFilePath,"Table"];*)
(**)
(**)


(* ::Input:: *)
(*(* Preprocess experimental data into the plots of interest *)*)
(**)
(**)
(*(* Preprocess theoretical data into the plots of interest *)*)


(* ::Input:: *)
(*importLabeledTheoryBlock[filePath_String,sectionHeader_String,targetSymbol_Symbol]:=Module[{lines,startIdx,startLineNum,endLineNum,subsequentLines,nextBlockIdx,headerParts,frequencies,theoryDataLines,parsedData},(* ===Import lines===*)lines=Import[filePath,"Lines"];*)
(*If[!ListQ[lines]||!AllTrue[lines,StringQ],Print["\:274c Error: File content is not a list of strings."];*)
(*Return[$Failed];];*)
(*(* ===Find block start===*)startIdx=FirstPosition[lines,s_/;StringContainsQ[s,sectionHeader],Missing["NotFound"]];*)
(*If[startIdx===Missing["NotFound"],Print["\:274c Section header not found: ",sectionHeader];*)
(*Return[$Failed];];*)
(*startLineNum=startIdx[[1]];*)
(*(* ===Find end of block===*)subsequentLines=Drop[lines,startLineNum+2];*)
(*nextBlockIdx=FirstPosition[subsequentLines,s_/;StringMatchQ[StringTrim[s],"## ==="~~___~~"==="]&&Not@StringContainsQ[s,sectionHeader],Missing["NotFound"]];*)
(*endLineNum=If[nextBlockIdx===Missing["NotFound"],Length[lines],startLineNum+nextBlockIdx[[1]]-1];*)
(*(* ===Parse frequency header===*)headerParts=StringSplit[StringReplace[lines[[startLineNum+1]]," [Current in \[Micro]A]"->""],"\t"];*)
(*frequencies=ToExpression@StringReplace[headerParts[[2;;]],{"f="->"","Hz"->""," "->""}];*)
(*(* ===Parse data lines===*)theoryDataLines=lines[[startLineNum+2;;endLineNum]];*)
(*parsedData=Table[Module[{parts=StringSplit[StringTrim[line],"\t"]},With[{conc=ToExpression[parts[[1]]],currents=ToExpression/@parts[[2;;]]},If[Length[currents]===Length[frequencies],{conc,Transpose[{frequencies,currents}]},Print["\:26a0\:fe0f Skipping bad row at conc = ",conc," due to length mismatch"];*)
(*Nothing]]],{line,theoryDataLines}];*)
(*(* ===Assign parsed result to target symbol===*)targetSymbol=parsedData;*)
(*Print["\:2705 Parsed ",Length[parsedData]," rows into variable ",SymbolName[Unevaluated[targetSymbol]]];]*)
(**)
(**)


(* ::Input:: *)
(*importCalibrationBlock[filePath_String,sectionHeader_String]:=Module[{lines,startIdx,startLineNum,endLineNum,subsequentLines,nextBlockIdx,dataLines,parsedData},lines=Import[filePath,"Lines"];*)
(*If[!ListQ[lines]||!AllTrue[lines,StringQ],Print["\:274c Error: File content is not valid."];Return[$Failed]];*)
(*startIdx=FirstPosition[lines,s_/;StringContainsQ[s,sectionHeader],Missing["NotFound"]];*)
(*If[startIdx===Missing["NotFound"],Print["\:274c Section header not found: ",sectionHeader];*)
(*Return[$Failed]];*)
(*startLineNum=startIdx[[1]];*)
(*subsequentLines=Drop[lines,startLineNum+2];*)
(*nextBlockIdx=FirstPosition[subsequentLines,s_/;StringMatchQ[StringTrim[s],"## ==="~~___~~"==="]&&Not@StringContainsQ[s,sectionHeader],Missing["NotFound"]];*)
(*endLineNum=If[nextBlockIdx===Missing["NotFound"],Length[lines],startLineNum+nextBlockIdx[[1]]-1];*)
(*dataLines=lines[[startLineNum+2;;endLineNum]];*)
(*parsedData=Cases[dataLines,s_:>With[{parts=StringSplit[StringTrim[s],"\t"]},If[Length[parts]==2,Quiet[{ToExpression[parts[[1]]],ToExpression[parts[[2]]]}],Nothing]]];*)
(*parsedData]*)
(**)


importVoltammogramBlock[filePath_String, sectionHeader_String, targetSymbol_Symbol] := 
 Module[
  {
    lines, startIdx, startLineNum, endLineNum, subsequentLines,
    nextBlockIdx, headerParts, freqs, dataLines, parsedTable, voltages, currents
  },

  (* Import and clean up lines *)
  lines = Import[filePath, "Lines"];
  lines = Flatten[lines];
  lines = Select[lines, StringQ];

  (* === Find block start === *)
  startIdx = 
    FirstPosition[
      lines,
      s_String /; StringContainsQ[s, sectionHeader],
      Missing["NotFound"]
    ];

  If[startIdx === Missing["NotFound"],
    Print["\:274c Section header not found: ", sectionHeader];
    Return[$Failed];
  ];

  startLineNum = startIdx[[1]];

  (* Find end of block *)
  subsequentLines = Drop[lines, startLineNum + 2];
  nextBlockIdx = 
    FirstPosition[
      subsequentLines,
      s_String /; 
        StringMatchQ[
          StringTrim[s],
          "## ===" ~~ ___ ~~ "==="] &&
        Not@StringContainsQ[s, sectionHeader],
      Missing["NotFound"]
    ];

  endLineNum = 
    If[nextBlockIdx === Missing["NotFound"],
      Length[lines],
      startLineNum + nextBlockIdx[[1]] - 1
    ];

  (* Parse header line to extract frequencies *)
  headerParts = StringSplit[
    StringReplace[
      lines[[startLineNum + 1]],
      " [Current in \[Micro]A]" -> ""
    ],
    "\t"
  ];

  freqs = ToExpression@
    StringReplace[
      headerParts[[2 ;;]],
      {"f=" -> "", "Hz" -> "", " " -> ""}
    ];

  (* Parse data lines *)
  dataLines = lines[[startLineNum + 2 ;; endLineNum]];
  dataLines = Select[dataLines, StringQ];

  parsedTable = Table[
    With[{parts = StringSplit[line, "\t"]},
      {ToExpression[parts[[1]]], ToExpression /@ parts[[2 ;;]]}
    ],
    {line, dataLines}
  ];

  voltages = parsedTable[[All, 1]];
  currents = Transpose[parsedTable[[All, 2]]];

  (* Assign association *)
  targetSymbol =
    Association@
      MapThread[
        #1 -> Transpose[{voltages, #2}] &,
        {freqs, currents}
      ];

  Print[
    "\:2705 Parsed ", Length[freqs],
    " frequency traces into ",
    SymbolName[Unevaluated[targetSymbol]]
  ];
];




(* ::Input:: *)
(*(* Voltammogram Data  *)*)
(*Clear[theoryVoltammogramsConc0withResistor, theoryVoltammogramsConc0withNoResistor]*)
(*importVoltammogramBlock[simulationDataWithResistorFilePath,"## === Voltammograms at Conc = 0 M ===",theoryVoltammogramsConc0withResistor];*)
(*importVoltammogramBlock[simulationDataWithNoResistorFilePath,"## === Voltammograms at Conc = 0 M ===",theoryVoltammogramsConc0withNoResistor]*)


simulationDataWithNoResistorFilePath


theoryVoltammogramsConc0withNoResistor


Get["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\loadExperimentalVoltammogramGeneratePlots.m"]


(* Get["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\testLoad.m"] *)


rawData = LoadVoltammogramData`loadAllVoltammograms[voltammogramPath];






experimentalVoltammogramdataWithResistorLowConc = selectVoltammogramCurve[rawData, dataSeriesToUseLowConc, "IDiff", channelHighResistor];
experimentalVoltammogramdataNoResistorLowConc = selectVoltammogramCurve[rawData, dataSeriesToUseLowConc, "IDiff", channelLowResistor];
experimentalVoltammogramdataWithResistorHighConc = selectVoltammogramCurve[rawData, dataSeriesToUseHighConc, "IDiff", channelHighResistor];
experimentalVoltammogramdataNoResistorHighConc = selectVoltammogramCurve[rawData, dataSeriesToUseHighConc, "IDiff", channelLowResistor];



plotRangeVoltammograms = {Automatic, {0, 20}};

makeVoltammogramPlot[dataAssoc_, conc_, label_, isPending_: False, showLegend_: True] := Module[
  {plot, freqs, colors, legendLabels},

  (* Make real plot even if data is missing *)
  freqs = Sort[Keys[dataAssoc]];
  colors = ColorData["BlueGreenYellow"] /@ Rescale[Reverse@Range[Length[freqs]]];

  plot = ListLinePlot[
    Table[dataAssoc[f], {f, freqs}],
    PlotStyle -> (Directive[#, Thick] & /@ colors),
    Joined -> True,
    Frame -> True,
    GridLines -> {None, None},
    PlotRange -> plotRangeVoltammograms,
    ImageSize -> 300,
    Axes -> False,
    FrameLabel -> {"Potential (V)", "\[CapitalDelta]I (\[Micro]A)"},
    PlotLabel -> label,
    PlotLegends ->
      If[showLegend && Length[freqs] > 0,
        Placed[SwatchLegend[colors, Map["f = " <> ToString[#] <> " Hz" &, freqs]], Right],
        None
      ],
    BaseStyle -> {FontSize -> 10}
  ];

  If[isPending,
    Show[
      plot,
      Graphics[{Text[Style["Pending data", 20, Bold, Gray], Scaled[{0.5, 0.5}]]}]
    ],
    plot
  ]
];

voltammogramPlots = Grid[
  {
    {
     makeVoltammogramPlot[experimentalVoltammogramdataNoResistorLowConc, 0, "Experimental, no added resistor, 0mM target", False, False  (* no Legend *)],
     makeVoltammogramPlot[theoryVoltammogramsConc0withNoResistor, 0, "Simulation, no added resistor, 0mM target", False, True]
    },
    {
     makeVoltammogramPlot[experimentalVoltammogramdataWithResistorLowConc, 0, "Experimental, with added resistor, 0mM target", False, False (* no Legend *)],
     makeVoltammogramPlot[theoryVoltammogramsConc0withResistor, 0, 
       "Simulation, with added resistor, 0mM target", False, True]
    }
  },
  Spacings -> {2, 2}
]


Get["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\AnalyzeVoltammogram.m"];
AppendTo[$ContextPath, "AnalyzeVoltammogram`"];


(* reshape the voltammogram data for the form required by analyzeVoltammogram*)
(* Reshape experimentalVoltmammogramdata into curvesByConc *)

curvesByConc = <|
  0 -> Table[
    <|
      "label" -> 
        "Freq_" <> StringPadLeft[ToString[freq], 3, "0"] <> "_Conc_0e",
      "freq" -> freq,
      "conc" -> 0,
      "diff" -> experimentalVoltammogramdataNoResistorLowConc[freq]
    |>,
    {freq, Keys[experimentalVoltammogramdataNoResistorLowConc]}
  ]
|>;

(* Pick one random voltammogram *)
entry = RandomChoice @ RandomChoice @ Values[curvesByConc];
(* Extract data *)
data = entry["diff"];
(* Run the analysis *)
result = analyzeVoltammogram[data];
(* Plot the result *)
Show[
  ListPlot[
    Take[data, {6, -6}],
    PlotStyle -> {Black, PointSize[0.012]},
    Frame -> True,
    FrameLabel -> {"Voltage (V)", "\[CapitalDelta]I (A)"},
    PlotLabel -> StringJoin[
      "QC Fit \[LongDash] Label: ", entry["label"],
      " | Freq: ", ToString[entry["freq"]], " Hz",
      " | Conc: ", ToString[entry["conc"]], " M\n",
      "Baseline: ", 
        ToString[NumberForm[result["Baseline"], {5, 3}]], " \[Micro]A, ",
      "\[CapitalDelta]I: ", 
        ToString[NumberForm[result["DeltaI"], {5, 3}]], " \[Micro]A, ",
      "Peak: ", 
        ToString[NumberForm[result["PeakCurrent"], {5, 3}]], " \[Micro]A"
    ],
    PlotRange->{Automatic,Automatic},
    ImageSize -> Large
  ],
  Plot[
    result["Fit"][x],
    {x, Min[data[[All, 1]]], Max[data[[All, 1]]]},
    PlotStyle -> {Red, Thick},
    PlotRange->{Automatic,{0,0.5}}
  ]
]



(* Iterate over all frequencies in experimentalVoltmammogramdata *)
baselineVsFrequency = 
  Table[
    Module[
      {freq, data, result},
      
      freq = f;
      data = experimentalVoltammogramdataNoResistorLowConc[freq];
      
      result = analyzeVoltammogram[data];
      
      {freq, result["Baseline"]}
    ],
    {f, Keys[experimentalVoltammogramdataNoResistorLowConc]}
  ];

(* Convert to microamps *)
baselineVsFrequencyMicroA = baselineVsFrequency;

(* Sort by frequency for nice plotting *)
baselineVsFrequencyMicroASorted = 
  SortBy[baselineVsFrequencyMicroA, First];



(* Iterate over all frequencies in experimentalVoltmammogramdata *)
baselineVsFrequencyWithResistor = 
  Table[
    Module[
      {freq, data, result},
      
      freq = f;
      data = experimentalVoltammogramdataWithResistorLowConc[freq];
      
      result = analyzeVoltammogram[data];
      
      {freq, result["Baseline"]}
    ],
    {f, Keys[experimentalVoltammogramdataWithResistorLowConc]}
  ];

(* Convert to microamps *)
baselineVsFrequencyMicroAWithResistor = baselineVsFrequencyWithResistor;

(* Sort by frequency for nice plotting *)
baselineVsFrequencyMicroASortedWithResistor = 
  SortBy[baselineVsFrequencyMicroAWithResistor, First];




(* ::Input::Initialization:: *)
(* Baseline *)
importLabeledTheoryBlock[simulationDataWithResistorFilePath,"## === Baseline Current vs Frequency ===",parsedBaselineDataHighResistor];

importLabeledTheoryBlock[simulationDataWithNoResistorFilePath,"## === Baseline Current vs Frequency ===",parsedBaselineDataLowResistor];

(*Helper to compute mean baseline*)
meanBaselineLine[group_,conc_]:=Transpose[{frequencies,10^6*Mean/@Transpose[group[conc]]}];

baselineLineStandardLowConc=meanBaselineLine[grouped1,minConc];
baselineLineStandardHighConc=meanBaselineLine[grouped1,maxConc];
baselineLineAddedResistorLowConc=meanBaselineLine[grouped2,minConc];
baselineLineAddedResistorHighConc=meanBaselineLine[grouped2,maxConc];


plotRanges = {{5,700}, {-2,20}};

(* ===Extract theory curve data only===*)
theoryCurve[conc_,data_]:=
	Module[
	{nearestConc,entry},
	nearestConc=First@Nearest[
	data[[All,1]],conc];
	    entry=SelectFirst[data,#[[1]]==nearestConc&];
        If[ListQ[entry]&&Length[entry]==2,entry[[2]],Missing["NotFound"]]
]





Get["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\CustomTicks\\CustomTicks.m"]
Needs["CustomTicks`"]
(* { NameQ["CustomTicks`LinTicks"], NameQ["CustomTicks`LogTicks"] } *)
Options[CustomTicks`LinTicks]


Options[CustomTicks`LogTicks]


CHISignalDiffNonFaradaic=4 CDL E^(-(3/(CDL fSWV Rsol))) (1-E^(1/(4 CDL fSWV Rsol))-3 E^(1/(2 CDL fSWV Rsol))+3 E^(3/(4 CDL fSWV Rsol))+4 E^(1/(CDL fSWV Rsol))-4 E^(5/(4 CDL fSWV Rsol))-4 E^(3/(2 CDL fSWV Rsol))+4 E^(7/(4 CDL fSWV Rsol))+4 E^(2/(CDL fSWV Rsol))-4 E^(9/(4 CDL fSWV Rsol))-4 E^(5/(2 CDL fSWV Rsol))+4 E^(11/(4 CDL fSWV Rsol))) fSWV V0



(* --- best-fit parameters (no added resistor) --- *)
bestFitParameters = <|
  "CDL" -> 71/200000000,
  "Rsol" -> 294,
  "Rct0" -> 17021.386901767124`,
  "Rct1" -> 6573.064966390861`,
  "kD" -> 0.017733158127065773`,
  "Capt" -> 2.2012032765291434`*^-7,
  "V0" -> 0.025
|>;

(* --- added resistor (ohms) --- *)
RfromEIS = 1619;

bestFitParametersHighR =
  Association[
    bestFitParameters,
    <|"Rsol" -> RfromEIS|>
  ];


plotStyles = {
  RGBColor @@ ({31, 119, 180}/255.),  (* blue *)
  RGBColor @@ ({125, 61, 152}/255.)   (* purple *)
};

lineStyles={Thick,{Medium, Dashed}};

(* 2) Helper: transform a dataset {x,y} -> {log10(x), y} *)
log10[x_] := Log[10, x];
logXData[data_] := data /. {x_?NumericQ, y_?NumericQ} :> {log10[x], y};

(* 3) Your plotting function: linear plot with x scaled by log10 *)
makeConsistentBaselinePlot[data_, label_, plotRanges_] := Module[
  {
    dataLog = logXData /@ data,                 (* transform each series *)
    xRangeLog = log10 /@ plotRanges[[1]],       (* transform x-range *)
    yRange    = plotRanges[[2]]
  },
  ListLinePlot[
    dataLog,
    Joined -> True,
    PlotMarkers->Automatic,
    PlotStyle -> MapThread[{#1, #2} &, {plotStyles[[{1, 2, 1, 2}]], lineStyles[[{1, 1, 1,1}]]}],
    Axes -> False,
    Frame -> True,
    FrameLabel -> {"Frequency (Hz)", "Current (\[Micro]A)"},
    PlotLabel -> label,
    PlotRange -> {xRangeLog, yRange},
    BaseStyle -> {FontSize -> 10},
    (* {{yLeft, yRight}, {xBottom, xTop}} *)
    FrameTicks -> {{CustomTicks`LinTicks[0,20,TickDirection->Out], None}, {CustomTicks`LogTicks[1,2,TickDirection->Out], None}},
    PlotLegends -> Placed[LineLegend[{"low resistance", "high resistance","low resistance (experiment)","low resistance (theory)"}], {1.02, .5}],
    ImagePadding -> {{All, Scaled[.12]}, {All, All}},  (* reserve room at right *)
    ImageSize -> 600
  ]
];

(* plotStyles={
RGBColor[0.1216,0.4667,0.7059],(*Muted blue*)
RGBColor[0.1725,0.6275,0.1725]   (*Muted green*)
}; *)

(* Top: experimental data only *)
baselineStandardPlot2Exp =
  makeConsistentBaselinePlot[
    {
      baselineVsFrequencyMicroASorted,
      baselineVsFrequencyMicroASortedWithResistor
    },
    "Experimental",
    plotRanges
  ];

(* Bottom: theory only *)
baselineStandardPlot2Theory =
  makeConsistentBaselinePlot[
    {
      theoryCurve[0, parsedBaselineDataLowResistor],
      theoryCurve[0, parsedBaselineDataHighResistor]
    },
    "Theory",
    plotRanges
  ];

(* Stack vertically *)
baselineStandardPlot2 =
  Column[
    {
      baselineStandardPlot2Exp,
      baselineStandardPlot2Theory
    },
    Spacings -> 1
  ];


(* ============================================================ *)
(* Replace ONLY the bottom theory plot with a 4-series version:  *)
(*   1) sim low R  (unjoined dots)                               *)
(*   2) sim high R (unjoined dots)                               *)
(*   3) analytic low R  from CHISignalDiffNonFaradaic (joined)    *)
(*   4) analytic high R from CHISignalDiffNonFaradaic (joined)    *)
(* Top experimental plot stays exactly as-is.                     *)
(* ============================================================ *)

baselineStandardPlot2Theory := Module[
  {
    simLow, simHigh, freqLow, freqHigh,
    chiNFmicroA, anaLow, anaHigh,
    data, dataLog, xRangeLog, yRange
  },

  (* time-domain sim curves you already plot *)
  simLow  = theoryCurve[0, parsedBaselineDataLowResistor];
  simHigh = theoryCurve[0, parsedBaselineDataHighResistor];

  freqLow  = simLow[[All, 1]];
  freqHigh = simHigh[[All, 1]];

  (* analytic expression in microamps *)
  chiNFmicroA[f_?NumericQ, params_Association] :=
    Quiet @ Chop @ N[
      10^6*(CHISignalDiffNonFaradaic /. {
          fSWV -> f,
          CDL  -> params["CDL"],
          Rsol -> params["Rsol"],
          V0   -> params["V0"]
        })
    ];

	
	(* Replace ONLY the analytic frequency-grid part with a denser grid. *)
	
	(* choose how many analytic points you want *)
	nAna = 300;  (* try 300\[Dash]800 *)
	
	(* dense log-spaced frequency grids spanning your plot range *)
	freqGridLow  = 10^Subdivide[log10[plotRanges[[1, 1]]], log10[plotRanges[[1, 2]]], nAna];
	freqGridHigh = freqGridLow;  (* same range is fine *)
	
	(* build analytic curves on the dense grids (instead of using simLow/simHigh freqs) *)
	anaLow  = Select[{#, chiNFmicroA[#, bestFitParameters]}      & /@ freqGridLow,  VectorQ[#, NumericQ] &];
	anaHigh = Select[{#, chiNFmicroA[#, bestFitParametersHighR]} & /@ freqGridHigh, VectorQ[#, NumericQ] &];

  (* 4 series total *)
  data = {simLow, simHigh, anaLow, anaHigh};

  (* apply your exact x-log transform and ranges *)
  dataLog   = logXData /@ data;
  xRangeLog = log10 /@ plotRanges[[1]];
  yRange    = plotRanges[[2]];

  ListLinePlot[
    dataLog,

    (* sim: dots only, analytic: joined lines *)
    Joined       -> {False, False, True, True},
    PlotMarkers  -> {Automatic, Automatic, None, None},

    (* reuse your two colors; analytic is thicker *)
    PlotStyle -> {
      Directive[plotStyles[[1]]],              (* sim low R *)
      Directive[plotStyles[[2]]],              (* sim high R *)
      Directive[plotStyles[[1]], Thick],       (* analytic low R *)
      Directive[plotStyles[[2]], Thick]        (* analytic high R *)
    },

    Axes -> False,
    Frame -> True,
    FrameLabel -> {"Frequency (Hz)", "Current (\[Micro]A)"},
    PlotLabel -> "Theory",
    PlotRange -> {xRangeLog, yRange},
    BaseStyle -> {FontSize -> 10},

    FrameTicks -> {
      {CustomTicks`LinTicks[0, 20, TickDirection -> Out], None},
      {CustomTicks`LogTicks[1, 2, TickDirection -> Out], None}
    },

    PlotLegends -> Placed[
      LineLegend[{
        "sim low resistance",
        "sim high resistance",
        "analytic low resistance",
        "analytic high resistance"
      }],
      {1.02, .5}
    ],

    ImagePadding -> {{All, Scaled[.12]}, {All, All}},
    ImageSize -> 600
  ]
];

(* re-make the stacked plot; top stays unchanged *)
baselineStandardPlot2 =
  Column[
    {baselineStandardPlot2Exp, baselineStandardPlot2Theory},
    Spacings -> 1
  ];

baselineStandardPlot2




(* ::Input:: *)
(*(* deltaI *)*)
(*(* Iterate over all frequencies in experimentalVoltammogramdataNoResistorLowConc *)*)
(*deltaIVsFrequencyMicroA = *)
(*  Table[*)
(*    Module[*)
(*      {freq, data, result},*)
(*      *)
(*      freq = f;*)
(*      data = experimentalVoltammogramdataNoResistorLowConc[freq];*)
(*      *)
(*      result = analyzeVoltammogram[data];*)
(*      *)
(*      {freq, result["DeltaI"]}*)
(*    ],*)
(*    {f, Keys[experimentalVoltammogramdataNoResistorLowConc]}*)
(*  ];*)
(**)
(*(* Sort by frequency for nice plotting *)*)
(*deltaIVsFrequencyMicroASorted = *)
(*  SortBy[deltaIVsFrequencyMicroA, First]*)
(**)
(**)


(* Iterate over all frequencies in experimentalVoltmammogramdata *)
(* first the low conc (no target *)
deltaIVsFrequencyNoResistorLowConc = 
  Table[
    Module[
      {freq, data, result},
      
      freq = f;
      data = experimentalVoltammogramdataNoResistorLowConc[freq];
      
      result = analyzeVoltammogram[data];
      
      {freq, result["DeltaI"]}
    ],
    {f, Keys[experimentalVoltammogramdataNoResistorLowConc]}
  ]
 
(* Convert to microamps *)
(* deltaIStandardVsFrequencyMicroAWithResistor = deltaIStandardVsFrequencyWithResistor;
*)
(* Sort by frequency for nice plotting *)
deltaIVsFrequencyNoResistorLowConc = 
  SortBy[deltaIVsFrequencyNoResistorLowConc, First];

deltaIVsFrequencyWithResistorLowConc = 
  Table[
    Module[
      {freq, data, result},
      
      freq = f;
      data = experimentalVoltammogramdataWithResistorLowConc[freq];
      
      result = analyzeVoltammogram[data];
      
      {freq, result["DeltaI"]}
    ],
    {f, Keys[experimentalVoltammogramdataWithResistorLowConc]}
  ]
 
(* Convert to microamps *)
(* deltaIStandardVsFrequencyMicroAWithResistor = deltaIStandardVsFrequencyWithResistor;
*)
(* Sort by frequency for nice plotting *)
deltaIVsFrequencyWithResistorLowConc = 
  SortBy[deltaIVsFrequencyWithResistorLowConc, First];


deltaILowConcPlotExp =
  makeConsistentBaselinePlot[
    {
      deltaIVsFrequencyNoResistorLowConc,
      deltaIVsFrequencyWithResistorLowConc
    },
    "Exp5 (Standard, Baseline) \[Dash] Experimental",
    plotRanges
  ];




(* Iterate over all frequencies in experimentalVoltmammogramdata *)
(* first the low conc (no target *)
deltaIVsFrequencyNoResistorHighConc = 
  Table[
    Module[
      {freq, data, result},
      
      freq = f;
      data = experimentalVoltammogramdataNoResistorHighConc[freq];
      
      result = analyzeVoltammogram[data];
      
      {freq, result["DeltaI"]}
    ],
    {f, Keys[experimentalVoltammogramdataNoResistorHighConc]}
  ];
 
(* Convert to microamps *)
(* deltaIStandardVsFrequencyMicroAWithResistor = deltaIStandardVsFrequencyWithResistor;
*)
(* Sort by frequency for nice plotting *)
deltaIVsFrequencyNoResistorHighConc = 
  SortBy[deltaIVsFrequencyNoResistorHighConc, First];

deltaIVsFrequencyWithResistorHighConc = 
  Table[
    Module[
      {freq, data, result},
      
      freq = f;
      data = experimentalVoltammogramdataWithResistorHighConc[freq];
      
      result = analyzeVoltammogram[data];
      
      {freq, result["DeltaI"]}
    ],
    {f, Keys[experimentalVoltammogramdataWithResistorHighConc]}
  ];
 
(* Convert to microamps *)
(* deltaIStandardVsFrequencyMicroAWithResistor = deltaIStandardVsFrequencyWithResistor;
*)
(* Sort by frequency for nice plotting *)
deltaIVsFrequencyWithResistorHighConc = 
  SortBy[deltaIVsFrequencyWithResistorHighConc, First];


deltaIHighConcPlotExp =
  makeConsistentBaselinePlot[
    {
      deltaIVsFrequencyNoResistorHighConc,
      deltaIVsFrequencyWithResistorHighConc
    },
    "Exp5 (Standard, Baseline) \[Dash] Experimental",
    plotRanges
  ];


(* ::Input:: *)
(*importLabeledTheoryBlock[simulationDataWithResistorFilePath,"## === Peak \[CapitalDelta]I vs Frequency ===",parsedTheoryDataHighResistor];*)
(*importLabeledTheoryBlock[simulationDataWithNoResistorFilePath,"## === Peak \[CapitalDelta]I vs Frequency ===",parsedTheoryDataLowResistor];*)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*plotRanges = {{5,700}, {-2,10}};*)
(**)
(**)
(*(* ===Function to make consistent plots===*)*)
(*makeConsistentPlot[data_,label_, legendLabel_]:=ListLogLinearPlot[data,Joined->True,PlotStyle->MapThread[{#1,#2}&,{plotStyles,lineStyles}],PlotMarkers->Automatic, Frame->True,FrameLabel->{"Frequency (Hz)","Current (\[Micro]A)"},PlotLabel->label,PlotRange->plotRanges,ImageSize->300,BaseStyle->{FontSize->10},PlotLegends->legendLabel];*)
(*legendLabel={"no added R","added resistor"};*)
(*(* ===Create each plot===*)*)
(*(* theoryStandardPlot=makeConsistentPlot[{theoryCurve[0, parsedTheoryDataLowResistor],theoryCurve[0.0093, parsedTheoryDataLowResistor]},"Theory (Standard)", legendLabel]; *)*)
(*theoryLowConcPlot = makeConsistentPlot[{theoryCurve[0, parsedTheoryDataLowResistor],theoryCurve[0, parsedTheoryDataHighResistor]},"Simulation - no added target", legendLabel];*)
(*theoryHighConcPlot = makeConsistentPlot[{theoryCurve[0.0093, parsedTheoryDataLowResistor],theoryCurve[0.0093, parsedTheoryDataHighResistor]},"High Concentration", legendLabel];*)
(**)
(**)
(*(* theoryResistorPlot=makeConsistentPlot[{theoryCurve[0, parsedTheoryDataHighResistor],theoryCurve[0.0093, parsedTheoryDataHighResistor]},"Theory (added resistor)", legendLabel]; *)*)
(**)
(*(* lowResistorDeltaIPlot=makeConsistentPlot[{lineStandardLowConc,lineStandardHighConc},"Exp5 (Standard)", None]; *)*)
(*(*  lowResistorDeltaIPlot=makeConsistentPlot[{deltaIVsFrequencyMicroASorted},"Exp5 (Standard)", None];*)*)
(**)
(*(* highResistorDeltaIPlot=makeConsistentPlot[{deltaIVsFrequencyMicroASortedWithResistor},"Exp6 (Added Resistor)", None];*)
(*highResistorDeltaIPlot=makeConsistentPlot[{lineAddedResistorLowConc,lineAddedResistorHighConc},"Exp6 (Added Resistor)", None]; *)*)
(*deltaIHighConcPlotExp =*)
(*  makeConsistentPlot[*)
(*    {*)
(*      deltaIVsFrequencyNoResistorHighConc,*)
(*      deltaIVsFrequencyWithResistorHighConc*)
(*    },*)
(*    "Experiment 9.3mM ",*)
(*    legendLabel={"no added R","added resistor"}*)
(*  ];*)
(**)
(*deltaILowConcPlotExp =*)
(*  makeConsistentPlot[*)
(*    {*)
(*      deltaIVsFrequencyNoResistorLowConc,*)
(*      deltaIVsFrequencyWithResistorLowConc*)
(*    },*)
(*    "Experiment no added target",*)
(*    legendLabel={"no added R","added resistor"}*)
(*  ];*)
(*(* ===Arrange in 2x2 Grid===*)*)
(*deltaIPlots = Grid[{{deltaILowConcPlotExp,deltaIHighConcPlotExp},{theoryLowConcPlot,theoryHighConcPlot}},Spacings->{2,2}]*)
(**)
(**)
(**)


CHISignalBaselineSubtractedExpr=-4 CDL E^(-(5/(2 CDL fSWV Rsol))) (-1+E^(1/(4 CDL fSWV Rsol))+2 E^(1/(2 CDL fSWV Rsol))-2 E^(3/(4 CDL fSWV Rsol))-2 E^(1/(CDL fSWV Rsol))+2 E^(5/(4 CDL fSWV Rsol))+2 E^(3/(2 CDL fSWV Rsol))-2 E^(7/(4 CDL fSWV Rsol))-2 E^(2/(CDL fSWV Rsol))+2 E^(9/(4 CDL fSWV Rsol))) fSWV V0-4 CDL E^(-(3/(CDL fSWV Rsol))) (1-E^(1/(4 CDL fSWV Rsol))-2 E^(1/(2 CDL fSWV Rsol))+2 E^(3/(4 CDL fSWV Rsol))+2 E^(1/(CDL fSWV Rsol))-2 E^(5/(4 CDL fSWV Rsol))-2 E^(3/(2 CDL fSWV Rsol))+2 E^(7/(4 CDL fSWV Rsol))+2 E^(2/(CDL fSWV Rsol))-2 E^(9/(4 CDL fSWV Rsol))-2 E^(5/(2 CDL fSWV Rsol))+2 E^(11/(4 CDL fSWV Rsol))) fSWV V0+(2 E^(-((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(2 Capt CDL fSWV Rct Rsol))) fSWV (CDL^2 (-1+E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))+E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))+3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))-3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))-4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))+4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))-4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))-3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))+4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))+4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))) Rsol+Capt CDL (Rct-E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct-E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rct-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct+4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct-4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct+4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct+4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct-4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rct-3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct+3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct-4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct+E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-2 Rsol+2 E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol+2 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol+6 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol-6 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol+8 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol-8 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rsol+6 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol-6 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-2 E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol)+Capt^2 (-Rct+E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct+E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct+3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct-3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rct+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct-4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct+4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct-4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct+4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rct+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct-3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct+4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-Rsol+E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol+E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol+3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol-3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol+4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rsol+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol-3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol)+Capt (1+E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))-3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))+4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))+4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))) Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]+CDL (1+E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))-3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))+4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))+4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))) Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]) V0)/(Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]);


(* ============================================================= *)
(* CLEAN VERSION: NO UNDERSCORES IN VARIABLE NAMES               *)
(* ============================================================= *)


(* ---- analytical current (\[Micro]A), numeric only ---- *)
chiAnalytical[f_?NumericQ, params_Association] :=
 Quiet @ Chop @ N[
   10^6*
    (CHISignalBaselineSubtractedExpr /. {
       fSWV -> f,
       CDL  -> params["CDL"],
       Rsol -> params["Rsol"],
       Capt -> params["Capt"],
       Rct  -> params["Rct"],
       V0   -> params["V0"]
     })
 ];
 (* --- use the same Rct mixing logic as ModelFunction --- *)
theta[c_, p_Association] := c/(p["kD"] + c);

rctEff[c_, p_Association] :=
  1/((1 - theta[c, p])/p["Rct0"] + theta[c, p]/p["Rct1"]);

(* choose the concentrations you want *)
cLow  = 0.0;
cHigh = 0.0093;

(* ---- parameter sets (Rct computed from Rct0/Rct1/kD and concentration) ---- *)
paramsLowNoR  = Association[bestFitParameters,      <|"Rct" -> rctEff[cLow,  bestFitParameters]|>];
paramsLowAddR = Association[bestFitParametersHighR, <|"Rct" -> rctEff[cLow,  bestFitParametersHighR]|>];

paramsHighNoR  = Association[bestFitParameters,      <|"Rct" -> rctEff[cHigh, bestFitParameters]|>];
paramsHighAddR = Association[bestFitParametersHighR, <|"Rct" -> rctEff[cHigh, bestFitParametersHighR]|>];


(* ---- frequency grids ---- *)
freqLow  = theoryCurve[0.0,   parsedTheoryDataLowResistor][[All, 1]];
freqHigh = theoryCurve[0.0093, parsedTheoryDataLowResistor][[All, 1]];

(* ---- analytical curves ---- *)
analyticLowNoR  = Select[{#, chiAnalytical[#, paramsLowNoR]} & /@ freqLow,  VectorQ[#, NumericQ] &];
analyticLowAddR = Select[{#, chiAnalytical[#, paramsLowAddR]} & /@ freqLow, VectorQ[#, NumericQ] &];

analyticHighNoR  = Select[{#, chiAnalytical[#, paramsHighNoR]} & /@ freqHigh,  VectorQ[#, NumericQ] &];
analyticHighAddR = Select[{#, chiAnalytical[#, paramsHighAddR]} & /@ freqHigh, VectorQ[#, NumericQ] &];

(* ---- simulation curves ---- *)
simLowCurves = {
  theoryCurve[0.0, parsedTheoryDataLowResistor],
  theoryCurve[0.0, parsedTheoryDataHighResistor]
};

simHighCurves = {
  theoryCurve[0.0093, parsedTheoryDataLowResistor],
  theoryCurve[0.0093, parsedTheoryDataHighResistor]
};

(* ---- overlay helper ---- *)
makeSimAnalyticPlot[simData_, anaData_, title_] :=
 ListLogLinearPlot[
  Join[simData, anaData],

  (* simulation = points, analytical = lines *)
  Joined -> Join[
    ConstantArray[False, Length@simData],
    ConstantArray[True, Length@anaData]
  ],

  PlotMarkers -> Join[
    ConstantArray[Automatic, Length@simData],
    ConstantArray[None, Length@anaData]
  ],

  PlotStyle -> Join[
    MapThread[{#1, #2} &, {plotStyles, lineStyles}][[;; Length@simData]],
    (Directive[#, Thick] & /@ plotStyles[[;; Length@anaData]])
  ],

  Frame -> True,
  FrameLabel -> {"Frequency (Hz)", "Current (\[Micro]A)"},
  PlotLabel -> title,
  PlotRange -> plotRanges,
  ImageSize -> 300,
  BaseStyle -> {FontSize -> 10},

  PlotLegends -> Join[
    {"Sim: no added R", "Sim: added resistor"},
    {"Analytical: no added R", "Analytical: added resistor"}
  ]
];


(* ---- bottom plots ---- *)
theoryLowConcPlot =
  makeSimAnalyticPlot[
    simLowCurves,
    {analyticLowNoR, analyticLowAddR},
    "Simulation vs Analytical (Low Concentration)"
  ];

theoryHighConcPlot =
  makeSimAnalyticPlot[
    simHighCurves,
    {analyticHighNoR, analyticHighAddR},
    "Simulation vs Analytical (High Concentration)"
  ];

(* ---- final grid ---- *)
finalComparisonGrid =
 Grid[
  {
    {deltaILowConcPlotExp, deltaIHighConcPlotExp},
    {theoryLowConcPlot,    theoryHighConcPlot}
  },
  Spacings -> {2, 2}
 ];

finalComparisonGrid




(* ============================================================ *)
(* Lovri\[CAcute] plots laid out like your current grid:                  *)
(*   top row  = experiments (low, high)                           *)
(*   bottom   = theory (sim+analytical) (low, high)               *)
(* Lovri\[CAcute] = (current / frequency) vs frequency                    *)
(* ============================================================ *)

ClearAll[lovricTransform, filterLogPairs, makeLovricExpPlot, makeLovricTheoryPlot];

lovricTransform[data_] := ({#[[1]], #[[2]]/#[[1]]} & /@ data);

filterLogPairs[data_] :=
  Select[
    data,
    VectorQ[#, NumericQ] && Length[#] == 2 && #[[1]] > 0 &&
      FreeQ[#[[2]], Indeterminate | Infinity | ComplexInfinity] &
  ];

(* --- EXP only: two curves, styling like your exp deltaI plots --- *)
makeLovricExpPlot[data_, label_, legendLabel_] :=
  ListLogLinearPlot[
    filterLogPairs /@ (lovricTransform /@ data),
    Joined -> True,
    PlotStyle -> MapThread[{#1, #2} &, {plotStyles, lineStyles}],
    PlotMarkers -> Automatic,
    Frame -> True,
    FrameLabel -> {"Frequency (Hz)", "\!\(\*FractionBox[\(i\), \(f\)]\) (\[Micro]A/Hz)"},
    PlotLabel -> label,
    PlotRange -> All,
    ImageSize -> 300,
    BaseStyle -> {FontSize -> 10},
    PlotLegends -> legendLabel
  ];

(* --- THEORY: sim (points) + analytical (lines), like your overlay helper --- *)
makeLovricTheoryPlot[simData_, anaData_, title_] :=
  ListLogLinearPlot[
    Join[
      filterLogPairs /@ (lovricTransform /@ simData),
      filterLogPairs /@ (lovricTransform /@ anaData)
    ],

    (* simulation = points, analytical = lines *)
    Joined -> Join[
      ConstantArray[False, Length@simData],
      ConstantArray[True,  Length@anaData]
    ],

    PlotMarkers -> Join[
      ConstantArray[Automatic, Length@simData],
      ConstantArray[None,      Length@anaData]
    ],

    PlotStyle -> Join[
      MapThread[{#1, #2} &, {plotStyles, lineStyles}][[;; Length@simData]],
      (Directive[#, Thick] & /@ plotStyles[[;; Length@anaData]])
    ],

    Frame -> True,
    FrameLabel -> {"Frequency (Hz)", "\!\(\*FractionBox[\(i\), \(f\)]\) (\[Micro]A/Hz)"},
    PlotLabel -> title,
    PlotRange -> All,
    ImageSize -> 300,
    BaseStyle -> {FontSize -> 10},

    PlotLegends -> Join[
      {"Sim: no added R", "Sim: added resistor"},
      {"Analytical: no added R", "Analytical: added resistor"}
    ]
  ];

legendLabelLovric = {"no added R", "added resistor"};

(* ---- Top row: experiments ---- *)
lovricLowConcPlotExp =
  makeLovricExpPlot[
    {deltaIVsFrequencyNoResistorLowConc, deltaIVsFrequencyWithResistorLowConc},
    "Lovri\[CAcute] (Experiment, 0 mM)",
    legendLabelLovric
  ];

lovricHighConcPlotExp =
  makeLovricExpPlot[
    {deltaIVsFrequencyNoResistorHighConc, deltaIVsFrequencyWithResistorHighConc},
    "Lovri\[CAcute] (Experiment, 9.3 mM)",
    legendLabelLovric
  ];

(* ---- Bottom row: theory (sim + analytical) ---- *)
lovricLowConcPlotTheory =
  makeLovricTheoryPlot[
    simLowCurves,
    {analyticLowNoR, analyticLowAddR},
    "Lovri\[CAcute] (Theory, 0 mM)"
  ];

lovricHighConcPlotTheory =
  makeLovricTheoryPlot[
    simHighCurves,
    {analyticHighNoR, analyticHighAddR},
    "Lovri\[CAcute] (Theory, 9.3 mM)"
  ];

LovricPlots =
  Grid[
    {
      {lovricLowConcPlotExp,    lovricHighConcPlotExp},
      {lovricLowConcPlotTheory, lovricHighConcPlotTheory}
    },
    Spacings -> {2, 2}
  ]



(* Helper to extract parameter block from file *)
extractParams[file_] := Module[
  {lines, startIndex, endIndex, paramLines, keyVals},

  lines = Import[file, "Lines"];

  (* Find start of parameter section *)
  startIndex = FirstPosition[lines, "## === Simulation Parameters ===", Missing["NotFound"]];
  If[startIndex === Missing["NotFound"], Return[<||>]];
  startIndex = startIndex[[1]] + 1;

  (* Find next section header to mark end *)
  endIndex = FirstPosition[
    Drop[lines, startIndex],
    s_String /; StringMatchQ[StringTrim[s], "## ===" ~~ ___ ~~ "==="],
    {Length[lines]}
  ][[1]] + startIndex - 1;

  (* Get trimmed lines *)
  paramLines = StringTrim /@ lines[[startIndex ;; endIndex - 1]];

  (* Convert valid key=value lines into rules *)
  keyVals = Association@Cases[
    paramLines,
    line_String :> With[
      {parts = StringSplit[line, "="]},
      If[Length[parts] == 2,
        Rule[StringTrim[parts[[1]]], Quiet@ToExpression@StringTrim[parts[[2]]]],
        Nothing
      ]
    ]
  ];

  keyVals
];



(* Read all four parameter blocks *)
params1 = extractParams[simulationDataWithResistorFilePath];
params2 = extractParams[simulationDataWithNoResistorFilePath];
(* params3 = extractParams[simulationCalDataWithResistorFilePath];
params4 = extractParams[simulationCalDataWithNoResistorFilePath]; *)

allParams = <|
  "simulationDataWithResistorFilePath" -> params1,
  "simulationDataWithNoResistorFilePath" -> params2
|>;
(* 
allParams = <|
  "simulationDataWithResistorFilePath" -> params1,
  "simulationDataWithNoResistorFilePath" -> params2,
  "simulationCalDataWithResistorFilePath" -> params3,
  "simulationCalDataWithNoResistorFilePath" -> params4
|>;
*)


allKeys = Union[Flatten[Keys /@ Values[allParams]]];
commonParamKeys = Select[
  allKeys,
  Function[k,
    Module[{vals},
      vals = Lookup[Values[allParams], k, Missing["NotFound"]];
      Length[DeleteDuplicates[vals]] === 1 && FreeQ[vals, _Missing]
    ]
  ]
];

commonParams = AssociationMap[
  First@Lookup[Values[allParams], #] &,
  commonParamKeys
];



(* Keys that are not common *)
differingParamKeys = Complement[allKeys, commonParamKeys];

(* Extract differing values for each file *)
differingParams = AssociationMap[
  Function[fileLabel,
    Association[
      Table[
        key -> Lookup[allParams[fileLabel], key, Missing["NotFound"]],
        {key, differingParamKeys}
      ]
    ]
  ],
  Keys[allParams]
];



(* ===================== Experimental preamble section ===================== *)

firstTxtFile[dir_] := Module[{files},
  files = Sort @ FileNames["*.txt", dir];
  If[Length[files] == 0, Missing["NoTxtFiles"], First[files]]
];

getPreambleLines[file_, maxLines_: 12] := Module[{txt, lines},
  txt = Import[file, "Text"];
  lines = StringSplit[txt, {"\r\n", "\n", "\r"}];
  StringTrim /@ Take[lines, UpTo[maxLines]]
];

experimentalPreambleSection[dir_, maxLines_: 12] := Module[{file, lines},
  file = firstTxtFile[dir];
  If[MissingQ[file],
    Column[
      {
        Style["No .txt files found in this directory:", 10, Bold],
        Style[dir, FontSize -> 9]
      },
      Spacings -> 0.3
    ],
    lines = getPreambleLines[file, maxLines];
    Column[
      {
        Style["Experimental data (from first .txt file in directory)", 10, Bold],
        Row[{Style["Directory:", Plain], " ", Style[dir, FontSize -> 9]}],
        Row[{Style["Example file:", Plain], " ", Style[FileNameTake[file], FontSize -> 9]}],
        "",
        Column[Style[#, FontSize -> 9] & /@ lines, Spacings -> 0.1]
      },
      Spacings -> 0.3
    ]
  ]
];

(* ===================== Add to your existing paramSection ===================== *)

paramSection = Column[
  {
    Style["Simulation Parameters", 14, Bold],

    Style["Common Parameters", 12, Bold],
    Style[formatParamAssoc[commonParams], FontSize -> 10],

    Style["Differing Parameters by File", 12, Bold],
    Column[
      KeyValueMap[
        Function[{file, paramAssoc},
          Column[
            {
              Style[file, FontSize -> 10, Bold],
              Style[formatParamAssoc[paramAssoc], FontSize -> 10]
            },
            Spacings -> 0.5
          ]
        ],
        differingParams
      ],
      Spacings -> 1
    ],

    Style["Analytical Theory Parameters", 14, Bold],
    Column[
      KeyValueMap[
        Function[{label, paramAssoc},
          Column[
            {
              Style[label, FontSize -> 10, Bold],
              Style[formatParamAssoc[paramAssoc], FontSize -> 10]
            },
            Spacings -> 0.5
          ]
        ],
        <|
          "Low R (no added resistor)" -> bestFitParameters,
          "High R (added resistor)"   -> bestFitParametersHighR
        |>
      ],
      Spacings -> 1
    ],

    (* NEW: experimental preamble pulled from the first .txt in voltammogramPath *)
    Style["Experimental Data Info", 14, Bold],
    experimentalPreambleSection[voltammogramPath, 8]
  },
  Spacings -> 2
]




allPlots = {
	voltammogramPlots,
  baselineStandardPlot2,
  finalComparisonGrid,
  LovricPlots, 
};

header = Graphics[
  Text[
    Style["EXPERIMENT                       THEORY", 20, Bold, FontFamily -> "Helvetica"],
    Scaled[{0.5, 0.5}]
  ],
  ImageSize -> {600, 80}
];

Export[
  "all_experiment_plots_with_params.pdf",
  Column[
    Prepend[
      Append[allPlots, paramSection],
      header
    ],
    Spacings -> 2
  ],
  "PDF"
]



(* ============================================================ *)
(* THEORY-ONLY RAW EXPORT + HEADER FROM FIRST EXP TXT PREAMBLE    *)
(* Reads first .txt in voltammogramPath and includes its preamble *)
(* ============================================================ *)

Module[
  {
    (* ---- USER SETTINGS ---- *)
    nPreambleLines = 8,  (* how many lines from the experimental txt to include *)
    filePattern = "*.txt",

    (* ---- preamble/header ---- *)
    firstTxt, preambleLines, preambleHeaderLines,

    (* helpers *)
    cleanPairs, toAssoc, unionFreqs, buildUnionTable,
    numStr, paramLine, paramBlockLines, tableToLines,
    log10, getSeries,

    (* baseline series *)
    tdBaselineLowR, tdBaselineHighR,
    chiNFmicroA, freqGridNF, anaBaselineLowR, anaBaselineHighR,

    (* faradaic series *)
    tdFar0LowR, tdFar0HighR, tdFarHighLowR, tdFarHighHighR,
    anaFar0LowR, anaFar0HighR, anaFarHighLowR, anaFarHighHighR,

    (* columns + tables *)
    colBaselineTD, colBaselineANA, colFarTD, colFarANA,
    tableBaselineTD, tableBaselineANA, tableFarTD, tableFarANA,

    (* header + export *)
    headerWithParams, dataLines,
    baseDir, fileOut,

    (* parameter blocks *)
    paramsAnalyticLowR, paramsAnalyticHighR,
    farParamAssocPairs,

    (* analytic baseline grid control *)
    nAnaLocal
  },

  (* ---------- pull experimental preamble from first txt ---------- *)
  firstTxt = Quiet @ Check[
     First @ Sort @ FileNames[filePattern, voltammogramPath],
     Missing["NoTxtFound"]
  ];

  preambleLines =
    If[firstTxt === Missing["NoTxtFound"],
      {"(No experimental .txt files found in voltammogramPath)"},
      Quiet @ Check[
        Take[Import[firstTxt, "Lines"], UpTo[nPreambleLines]],
        {"(Failed to read experimental preamble from: " <> ToString[firstTxt] <> ")"}
      ]
    ];

  preambleHeaderLines = Join[
    {
      "# --- Experimental file preamble (first file in voltammogramPath) ---",
      "# FileRead = " <> If[StringQ[firstTxt], firstTxt, "None"]
    },
    ("# " <> # & /@ preambleLines),
    {
      "# ------------------------------------------------------------",
      ""
    }
  ];

  (* ---------- helpers ---------- *)
  cleanPairs[data_] := Select[data, VectorQ[#, NumericQ] && Length[#] == 2 && #[[1]] > 0 &];

  toAssoc[data_] := Module[{pairs = cleanPairs[data], groups},
    groups = GatherBy[pairs, First];
    Association @ ((First@First[#] -> Mean[#[[All, 2]]]) & /@ groups)
  ];

  unionFreqs[assocs_List] := Sort @ DeleteDuplicates @ Flatten[Keys /@ assocs];

  buildUnionTable[freqs_List, assocs_List] :=
    Table[
      Join[{f}, Lookup[assocs, f, Missing["NoData"]] /. Missing[__] -> Missing["NoData"]],
      {f, freqs}
    ];

  numStr[v_] := Which[
    MissingQ[v] || v === Indeterminate || v === ComplexInfinity || v === Infinity || v === -Infinity,
      "NaN",
    True,
      ToString[FortranForm @ N @ v]
  ];

  tableToLines[header_String, colNames_List, table_List] :=
    Join[
      {header},
      {StringRiffle[colNames, "\t"]},
      (StringRiffle[(numStr /@ #), "\t"] & /@ table),
      {""}
    ];

  paramLine[key_, val_] := "# " <> ToString[key] <> " = " <> numStr[val];

  paramBlockLines[title_, assoc_Association] := Module[{keys = Keys[assoc]},
    Join[
      {"# ------------------------------------------------------------", "# " <> title},
      (paramLine[#, assoc[#]] & /@ keys),
      {"# ------------------------------------------------------------", ""}
    ]
  ];

  log10[x_] := Log[10, x];
  getSeries[s_] := If[ListQ[s], s, {}];

  (* ============================================================ *)
  (* Baseline TIME-DOMAIN                                          *)
  (* ============================================================ *)
  colBaselineTD = {"Frequency_Hz","Baseline_TimeDomain_LowR_uA","Baseline_TimeDomain_HighR_uA"};

  tdBaselineLowR  = theoryCurve[0, parsedBaselineDataLowResistor];
  tdBaselineHighR = theoryCurve[0, parsedBaselineDataHighResistor];

  tableBaselineTD = buildUnionTable[
    unionFreqs[toAssoc /@ {tdBaselineLowR, tdBaselineHighR}],
    toAssoc /@ {tdBaselineLowR, tdBaselineHighR}
  ];

  (* ============================================================ *)
  (* Baseline ANALYTICAL                                           *)
  (* ============================================================ *)
  colBaselineANA = {"Frequency_Hz","Baseline_Analytic_LowR_uA","Baseline_Analytic_HighR_uA"};

  chiNFmicroA[f_?NumericQ, params_Association] :=
    Quiet @ Chop @ N[
      10^6*(CHISignalDiffNonFaradaic /. {
          fSWV -> f, CDL -> params["CDL"], Rsol -> params["Rsol"], V0 -> params["V0"]
        })
    ];

  nAnaLocal = If[ValueQ[nAnaBaseline] && IntegerQ[nAnaBaseline] && nAnaBaseline > 10, nAnaBaseline, 300];

  freqGridNF = 10^Subdivide[
    log10[plotRanges[[1, 1]]],
    log10[plotRanges[[1, 2]]],
    nAnaLocal
  ];

  anaBaselineLowR  = Select[{#, chiNFmicroA[#, bestFitParameters]}      & /@ freqGridNF, VectorQ[#, NumericQ] &];
  anaBaselineHighR = Select[{#, chiNFmicroA[#, bestFitParametersHighR]} & /@ freqGridNF, VectorQ[#, NumericQ] &];

  tableBaselineANA = buildUnionTable[
    unionFreqs[toAssoc /@ {anaBaselineLowR, anaBaselineHighR}],
    toAssoc /@ {anaBaselineLowR, anaBaselineHighR}
  ];

  (* ============================================================ *)
  (* Faradaic TIME-DOMAIN                                          *)
  (* ============================================================ *)
  colFarTD = {
    "Frequency_Hz",
    "FaradaicLowConc_TimeDomain_LowR_uA","FaradaicLowConc_TimeDomain_HighR_uA",
    "FaradaicHighConc_TimeDomain_LowR_uA","FaradaicHighConc_TimeDomain_HighR_uA"
  };

  tdFar0LowR      = simLowCurves[[1]];
  tdFar0HighR     = simLowCurves[[2]];
  tdFarHighLowR   = simHighCurves[[1]];
  tdFarHighHighR  = simHighCurves[[2]];

  tableFarTD = buildUnionTable[
    unionFreqs[toAssoc /@ {tdFar0LowR, tdFar0HighR, tdFarHighLowR, tdFarHighHighR}],
    toAssoc /@ {tdFar0LowR, tdFar0HighR, tdFarHighLowR, tdFarHighHighR}
  ];

  (* ============================================================ *)
  (* Faradaic ANALYTICAL                                           *)
  (* ============================================================ *)
  colFarANA = {
    "Frequency_Hz",
    "FaradaicLowConc_Analytic_LowR_uA","FaradaicLowConc_Analytic_HighR_uA",
    "FaradaicHighConc_Analytic_LowR_uA","FaradaicHighConc_Analytic_HighR_uA"
  };

  anaFar0LowR      = getSeries[analyticLowNoR];
  anaFar0HighR     = getSeries[analyticLowAddR];
  anaFarHighLowR   = getSeries[analyticHighNoR];
  anaFarHighHighR  = getSeries[analyticHighAddR];

  tableFarANA = buildUnionTable[
    unionFreqs[toAssoc /@ {anaFar0LowR, anaFar0HighR, anaFarHighLowR, anaFarHighHighR}],
    toAssoc /@ {anaFar0LowR, anaFar0HighR, anaFarHighLowR, anaFarHighHighR}
  ];

  (* ============================================================ *)
  (* Parameter blocks                                               *)
  (* ============================================================ *)
  paramsAnalyticLowR  = bestFitParameters;
  paramsAnalyticHighR = bestFitParametersHighR;

  farParamAssocPairs = {
    {"Analytical FARADAIC (Low conc, low R)",   paramsLowNoR},
    {"Analytical FARADAIC (Low conc, high R)",  paramsLowAddR},
    {"Analytical FARADAIC (High conc, low R)",  paramsHighNoR},
    {"Analytical FARADAIC (High conc, high R)", paramsHighAddR}
  };

  headerWithParams = Join[
    preambleHeaderLines,
    paramBlockLines["Analytical theory parameters (no added R)", paramsAnalyticLowR],
    paramBlockLines["Analytical theory parameters (added resistor)", paramsAnalyticHighR],
    Flatten @ (paramBlockLines[#[[1]], #[[2]]] & /@ farParamAssocPairs)
  ];

  (* ============================================================ *)
  (* Data lines + export                                            *)
  (* ============================================================ *)
  dataLines = Join[
    tableToLines["## Non-faradaic baseline (TIME-DOMAIN theory) [microA]", colBaselineTD,  tableBaselineTD],
    tableToLines["## Non-faradaic baseline (ANALYTICAL theory) [microA]",  colBaselineANA, tableBaselineANA],
    tableToLines["## Faradaic peak \[CapitalDelta]I (TIME-DOMAIN theory) [microA]",      colFarTD,       tableFarTD],
    tableToLines["## Faradaic peak \[CapitalDelta]I (ANALYTICAL theory) [microA]",       colFarANA,      tableFarANA]
  ];

  baseDir = Quiet @ Check[NotebookDirectory[], $TemporaryDirectory];
  fileOut = FileNameJoin[{baseDir, "export_simulation_and_theory_results.txt"}];

  Export[fileOut, StringRiffle[Join[headerWithParams, dataLines], "\n"], "Text"];

  fileOut
]


