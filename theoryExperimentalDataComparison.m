(* ::Package:: *)

(* ::Input:: *)
(* ClearAll["Global`*"]*)


(* ::Input:: *)
(*(* Load TXT files *)*)
(**)
(*experimentalDataWithNoResistor=Import["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\experimentalData\\E4Ir_vs_Freq10Hz_15Hz_20Hz_25Hz_30Hz_40Hz_70Hz_80Hz_100Hz_200Hz_300Hz_400Hz_500Hz_600Hz_.txt","Table"];*)
(**)
(*experimentalDataWithResistor=Import["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\experimentalData\\E6Ir_vs_Freq10Hz_15Hz_20Hz_25Hz_30Hz_40Hz_70Hz_80Hz_100Hz_200Hz_300Hz_400Hz_500Hz_600Hz_.txt","Table"];*)
(**)
(*(* simulationDataWithResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_highRhighKet3.txt" *)*)
(**)
(*simulationDataWithResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_R1580_FreqScan.txt"*)
(*simulationDataWithResistor=Import[simulationDataWithResistorFilePath,"Table"];*)
(*(* simulationDataWithNoResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_lowRhighKet2.txt" *)*)
(**)
(*simulationDataWithNoResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_RSmall_FreqScan.txt"*)
(*simulationDataWithNoResistor=Import[simulationDataWithNoResistorFilePath,"Table"];*)
(**)
(*simulationCalDataWithResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_cal_k0u60k0b160largeR.txt"*)
(*simulationCalDataWithResistor = Import[simulationCalDataWithResistorFilePath,"Table"];*)
(**)
(*simulationCalDataWithNoResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_cal_R238.txt"*)
(*simulationCalDataWithNoResistor = Import[simulationCalDataWithNoResistorFilePath,"Table"];*)
(**)
(*simulationCalDataWithResistor10000FilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_cal_R10000.txt"*)
(*simulationCalDataWithResistor10000 = Import[simulationCalDataWithResistor10000FilePath,"Table"];*)
(**)
(*simulationCalDataWithResistor3000FilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_cal_R3000.txt"*)
(*simulationCalDataWithResistor3000 = Import[simulationCalDataWithResistor3000FilePath,"Table"];*)
(**)
(*simulationCalDataWithResistor6000FilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_cal_R6000.txt"*)
(*simulationCalDataWithResistor6000 = Import[simulationCalDataWithResistor6000FilePath,"Table"];*)
(**)
(*simulationCalDataWithResistor4000FilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_cal_R4000.txt"*)
(*simulationCalDataWithResistor4000 = Import[simulationCalDataWithResistor4000FilePath,"Table"];*)
(**)
(*simulationCalDataWithResistor5000FilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_cal_R5000.txt"*)
(*simulationCalDataWithResistor5000 = Import[simulationCalDataWithResistor5000FilePath,"Table"];*)
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


Get["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\testLoad.wl"]


TestLoad`helloWorld[]


Get["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\loadExperimentalVoltammogramGeneratePlots.m"]


Get["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\testLoad.m"]


rawData = LoadVoltammogramData`loadAllVoltammograms["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\experimentalData\\voltammograms\\"];





experimentalVoltmammogramdata = LoadVoltammogramData`reshapeVoltammogramData[rawData, "IDiff", 4];




experimentalVoltmammogramdataWithResistor = LoadVoltammogramData`reshapeVoltammogramData[rawData, "IDiff", 1];



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
     makeVoltammogramPlot[experimentalVoltmammogramdata, 0, "Exp5 (Standard, 0 mM)", False, False  (* no Legend *)],
     makeVoltammogramPlot[theoryVoltammogramsConc0withNoResistor, 0, "Theory (Standard, 0 mM)", False, True]
    },
    {
     makeVoltammogramPlot[experimentalVoltmammogramdataWithResistor, 0, "Exp6 (Resistor, 0 mM)", False, False (* no Legend *)],
     makeVoltammogramPlot[theoryVoltammogramsConc0withResistor, 0, 
       "Theory (added Resistor, 0 mM)", False, True]
    }
  },
  Spacings -> {2, 2}
]


Get["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\AnalyzeVoltammogram.m"];
AppendTo[$ContextPath, "AnalyzeVoltammogram`"];


experimentalVoltmammogramdata


(* reshape the voltammogram data for the form required by analyzeVoltammogram*)
(* Reshape experimentalVoltmammogramdata into curvesByConc *)

curvesByConc = <|
  0 -> Table[
    <|
      "label" -> 
        "Freq_" <> StringPadLeft[ToString[freq], 3, "0"] <> "_Conc_0e",
      "freq" -> freq,
      "conc" -> 0,
      "diff" -> experimentalVoltmammogramdata[freq]
    |>,
    {freq, Keys[experimentalVoltmammogramdata]}
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
    PlotRange->{Automatic,{0,0.5}},
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
      data = experimentalVoltmammogramdata[freq];
      
      result = analyzeVoltammogram[data];
      
      {freq, result["Baseline"]}
    ],
    {f, Keys[experimentalVoltmammogramdata]}
  ];

(* Convert to microamps *)
baselineVsFrequencyMicroA = baselineVsFrequency;

(* Sort by frequency for nice plotting *)
baselineVsFrequencyMicroASorted = 
  SortBy[baselineVsFrequencyMicroA, First]

(* Plot *)
ListLogLogPlot[
  baselineVsFrequencyMicroASorted,
  PlotStyle -> {Red, PointSize[0.015]},
  Joined -> True,
  Frame -> True,
  FrameLabel -> {"1/f (s)", "Current (A)"},
  PlotLabel -> "Plot of 1/f vs Current",
  ImageSize -> 400
]




(* Transform to 1/f *)
transformedData = {1.0/#1, #2} & @@@ baselineVsFrequencyMicroASorted;

(* Transform to 1/f *)
transformedData = {#1, #2} & @@@ baselineVsFrequencyMicroASorted;

(* Fit power law: I = a * (1/f)^b *)
fit = FindFit[
  transformedData,
  a * x^b,
  {{a, 0.01}, {b, 0.5}},
  x
];

Print["Fitted slope: ", b /. fit];

(* Generate points for the fitted curve *)
xVals = 
  Subdivide[
    Min[transformedData[[All, 1]]],
    Max[transformedData[[All, 1]]],
    200
  ];

fitCurve = {#, (a /. fit) * #^(b /. fit)} & /@ xVals;

(* Plot data and fit together *)
ListLogLogPlot[
  {
    transformedData,
    fitCurve
  },
  PlotStyle -> {
    {Red, PointSize[0.015]},
    {Blue, Dashed, Thick}
  },
  Joined -> {False, True},
  Frame -> True,
  FrameLabel -> {"f (Hz)", "Current (A)"},
  PlotLabel -> "Current vs f on Log-Log Scale",
  PlotLegends -> {"Data", "Fit"},
  ImageSize -> 400
]


(* Iterate over all frequencies in experimentalVoltmammogramdata *)
baselineVsFrequencyWithResistor = 
  Table[
    Module[
      {freq, data, result},
      
      freq = f;
      data = experimentalVoltmammogramdataWithResistor[freq];
      
      result = analyzeVoltammogram[data];
      
      {freq, result["Baseline"]}
    ],
    {f, Keys[experimentalVoltmammogramdataWithResistor]}
  ];

(* Convert to microamps *)
baselineVsFrequencyMicroAWithResistor = baselineVsFrequencyWithResistor;

(* Sort by frequency for nice plotting *)
baselineVsFrequencyMicroASortedWithResistor = 
  SortBy[baselineVsFrequencyMicroAWithResistor, First];




(* Transform to 1/f *)
transformedData = {#1, #2} & @@@ baselineVsFrequencyMicroASortedWithResistor;

(* Fit power law: I = a * (1/f)^b *)
fit = FindFit[
  transformedData,
  a * x^b,
  {{a, 0.01}, {b, 0.5}},
  x
];

Print["Fitted slope: ", b /. fit];

(* Generate points for the fitted curve *)
xVals = 
  Subdivide[
    Min[transformedData[[All, 1]]],
    Max[transformedData[[All, 1]]],
    200
  ];

fitCurve = {#, (a /. fit) * #^(b /. fit)} & /@ xVals;

(* Plot data and fit together *)
ListLogLogPlot[
  {
    transformedData,
    fitCurve
  },
  PlotStyle -> {
    {Red, PointSize[0.015]},
    {Blue, Dashed, Thick}
  },
  Joined -> {False, True},
  Frame -> True,
  FrameLabel -> {"1/f (s)", "Current (A)"},
  PlotLabel -> "1/f vs. Current on Log-Log Scale",
  PlotLegends -> {"Data", "Fit"},
  ImageSize -> 400
]


(* ::Input:: *)
(*(* Currents vs Freq  *)*)
(**)
(*columnHeaders=experimentalDataWithNoResistor[[1]];*)
(*data1=experimentalDataWithNoResistor[[2;;]];*)
(*frequencies=ToExpression[StringReplace[columnHeaders,"Current_"->""]];*)
(**)
(*concentrationList=Join[ConstantArray[0.0,4],ConstantArray[1.0*^-5,3],ConstantArray[4.0*^-5,3],ConstantArray[1.0*^-4,3],ConstantArray[3.2*^-4,3],ConstantArray[9.3*^-3,3]];*)
(*concentrationList=Take[concentrationList,Length[data1]];*)
(*grouped1=GroupBy[Thread[{concentrationList,data1}],First->Last];*)
(**)
(*(*Load file 2*)*)
(*data2=experimentalDataWithResistor[[2;;]];*)
(*concentrationList2=Take[concentrationList,Length[data2]];*)
(*grouped2=GroupBy[Thread[{concentrationList2,data2}],First->Last];*)
(**)
(*(*Identify min and max concentration*)*)
(*minConc=Min[Keys[grouped1]];*)
(*maxConc=Max[Keys[grouped1]];*)
(**)
(**)
(*(* Baseline *)*)
(*importLabeledTheoryBlock[simulationDataWithResistorFilePath,"## === Baseline Current vs Frequency ===",parsedBaselineDataHighResistor];*)
(**)
(*importLabeledTheoryBlock[simulationDataWithNoResistorFilePath,"## === Baseline Current vs Frequency ===",parsedBaselineDataLowResistor];*)
(**)
(*(*Helper to compute mean baseline*)*)
(*meanBaselineLine[group_,conc_]:=Transpose[{frequencies,10^6*Mean/@Transpose[group[conc]]}];*)
(**)
(*baselineLineStandardLowConc=meanBaselineLine[grouped1,minConc];*)
(*baselineLineStandardHighConc=meanBaselineLine[grouped1,maxConc];*)
(*baselineLineAddedResistorLowConc=meanBaselineLine[grouped2,minConc];*)
(*baselineLineAddedResistorHighConc=meanBaselineLine[grouped2,maxConc];*)
(**)
(**)
(*(* plotRangesBaseline = {{5,700}, {0,20}}; *)*)
(*(* ===Define reusable styles===*)*)
(*plotStyles={*)
(*RGBColor[0.1216,0.4667,0.7059],(*Muted blue*)*)
(*RGBColor[0.1725,0.6275,0.1725]   (*Muted green*)*)
(*};*)
(**)
(*lineStyles={Thick,Thick};*)
(*plotRanges = {{5,700}, {0,20}};*)
(*plotRangesNoResistor = {{5,700}, {0,1}};*)
(*makeConsistentBaselinePlot[data_,label_, plotRanges_]:=ListLogLinearPlot[data,Joined->True,PlotStyle->MapThread[{#1,#2}&,{plotStyles,lineStyles}],Frame->True,FrameLabel->{"Frequency (Hz)","Current (\[Micro]A)"},PlotLabel->label,PlotRange->plotRanges,ImageSize->300,BaseStyle->{FontSize->10},PlotLegends->{"0 mM","9.3 mM"}];*)
(**)
(**)
(*baselineStandardPlot=makeConsistentBaselinePlot[{baselineVsFrequencyMicroASorted},"Exp5 (Standard, Baseline)", plotRangesNoResistor];*)
(*baselineResistorPlot=makeConsistentBaselinePlot[{baselineVsFrequencyMicroASortedWithResistor},"Exp6 (Added Resistor, Baseline)", plotRanges];*)
(*makePendingPlot[label_]:=Show[makeConsistentBaselinePlot[{{},{}},label],Graphics[{Text[Style["Pending data",20,Bold,Gray],Scaled[{0.5,0.5}]]}]]*)
(*(* *)
(*baselineStandardPlot=makePendingPlot["Exp5 (Standard, Baseline)"];*)
(*baselineResistorPlot=makePendingPlot["Exp6 (Added Resistor, Baseline)"];*)
(**)*)
(*(* ===Extract and plot theory lines===*)(* ===Extract theory curve data only===*)*)
(*theoryCurve[conc_,data_]:=*)
(*	Module[*)
(*	{nearestConc,entry},*)
(*	nearestConc=First@Nearest[*)
(*	data[[All,1]],conc];*)
(*	    entry=SelectFirst[data,#[[1]]==nearestConc&];*)
(*        If[ListQ[entry]&&Length[entry]==2,entry[[2]],Missing["NotFound"]]*)
(*]*)
(**)
(*theoryBaselineStandardPlot=makeConsistentBaselinePlot[{theoryCurve[0,parsedBaselineDataLowResistor]},"Theory (Standard, Baseline)", plotRangesNoResistor];*)
(*theoryBaselineResistorPlot=makeConsistentBaselinePlot[{theoryCurve[0,parsedBaselineDataHighResistor]},"Theory (Added Resistor, Baseline)", plotRanges];*)
(**)
(*baselinePlots = Grid[{{baselineStandardPlot,theoryBaselineStandardPlot},{baselineResistorPlot,theoryBaselineResistorPlot}},Spacings->{2,2}]*)
(**)
(**)


(* ::Input:: *)
(*(* deltaI *)*)
(*(* Iterate over all frequencies in experimentalVoltmammogramdata *)*)
(*deltaIVsFrequencyMicroA = *)
(*  Table[*)
(*    Module[*)
(*      {freq, data, result},*)
(*      *)
(*      freq = f;*)
(*      data = experimentalVoltmammogramdata[freq];*)
(*      *)
(*      result = analyzeVoltammogram[data];*)
(*      *)
(*      {freq, result["DeltaI"]}*)
(*    ],*)
(*    {f, Keys[experimentalVoltmammogramdata]}*)
(*  ];*)
(**)
(*(* Sort by frequency for nice plotting *)*)
(*deltaIVsFrequencyMicroASorted = *)
(*  SortBy[deltaIVsFrequencyMicroA, First]*)
(**)
(**)


deltaIVsFrequencyMicroAWithResistor = 
  Table[
    Module[
      {freq, data, result},
      
      freq = f;
      data = experimentalVoltmammogramdataWithResistor[freq];
      
      result = analyzeVoltammogram[data];
      
      {freq, result["DeltaI"]}
    ],
    {f, Keys[experimentalVoltmammogramdataWithResistor]}
  ];

(* Sort by frequency for nice plotting *)
deltaIVsFrequencyMicroASortedWithResistor = 
  SortBy[deltaIVsFrequencyMicroAWithResistor, First]



(* ::Input:: *)
(*importLabeledTheoryBlock[simulationDataWithResistorFilePath,"## === Peak \[CapitalDelta]I vs Frequency ===",parsedTheoryDataHighResistor];*)
(*importLabeledTheoryBlock[simulationDataWithNoResistorFilePath,"## === Peak \[CapitalDelta]I vs Frequency ===",parsedTheoryDataLowResistor];*)
(**)


(* ::Input:: *)
(*(*Compute lines*)*)
(*(*Helper to compute average current at each frequency for a group*)*)
(*meanLine[group_,conc_]:=Transpose[{frequencies,10^6*Mean/@Transpose[group[conc]]}];*)
(**)
(*lineStandardLowConc=meanLine[grouped1,minConc];*)
(*lineAddedResistorLowConc=meanLine[grouped2,minConc];*)
(*lineStandardHighConc=meanLine[grouped1,maxConc];*)
(*lineAddedResistorHighConc=meanLine[grouped2,maxConc];*)
(**)
(**)
(*(* ===Function to make consistent plots===*)*)
(*makeConsistentPlot[data_,label_, legendLabel_]:=ListLogLinearPlot[data,Joined->True,PlotStyle->MapThread[{#1,#2}&,{plotStyles,lineStyles}],Frame->True,FrameLabel->{"Frequency (Hz)","Current (\[Micro]A)"},PlotLabel->label,PlotRange->plotRanges,ImageSize->300,BaseStyle->{FontSize->10},PlotLegends->legendLabel];*)
(*legendLabel={"0 mM","9.3 mM"};*)
(*(* ===Create each plot===*)*)
(*theoryStandardPlot=makeConsistentPlot[{theoryCurve[0, parsedTheoryDataLowResistor],theoryCurve[0.0093, parsedTheoryDataLowResistor]},"Theory (Standard)", legendLabel];*)
(*theoryResistorPlot=makeConsistentPlot[{theoryCurve[0, parsedTheoryDataHighResistor],theoryCurve[0.0093, parsedTheoryDataHighResistor]},"Theory (added resistor)", legendLabel];*)
(**)
(*(* lowResistorDeltaIPlot=makeConsistentPlot[{lineStandardLowConc,lineStandardHighConc},"Exp5 (Standard)", None]; *)*)
(*lowResistorDeltaIPlot=makeConsistentPlot[{deltaIVsFrequencyMicroASorted},"Exp5 (Standard)", None];*)
(**)
(*highResistorDeltaIPlot=makeConsistentPlot[{deltaIVsFrequencyMicroASortedWithResistor},"Exp6 (Added Resistor)", None];*)
(*highResistorDeltaIPlot=makeConsistentPlot[{lineAddedResistorLowConc,lineAddedResistorHighConc},"Exp6 (Added Resistor)", None];*)
(**)
(**)
(*(* ===Arrange in 2x2 Grid===*)*)
(*deltaIPlots = Grid[{{lowResistorDeltaIPlot,theoryStandardPlot},{highResistorDeltaIPlot,theoryResistorPlot}},Spacings->{2,2}]*)
(**)
(**)
(**)


(* ::Input:: *)
(*(* Lovric Plot  *)*)
(*importLabeledTheoryBlock[simulationDataWithResistorFilePath,"## === Peak \[CapitalDelta]I vs Frequency ===",parsedTheoryDataHighResistor];*)
(*importLabeledTheoryBlock[simulationDataWithNoResistorFilePath,"## === Peak \[CapitalDelta]I vs Frequency ===",parsedTheoryDataLowResistor];*)
(**)
(*legendLabels={"0 mM","9.3 mM"};*)
(**)
(**)
(*lovricCurve[conc_,parsedData_]:=Module[{entry},entry=SelectFirst[parsedData,#[[1]]==conc&];*)
(*If[ListQ[entry]&&Length[entry]==2,entry[[2]]/. {f_,i_}:>{f,i/(f)},Missing["NotFound"]]];*)
(*(*Experimental Lovri\[CAcute] curves*)*)
(*parsedTheoryDataLowResistor;*)
(*(*Theory Lovri\[CAcute] curves*)*)
(*lovricTheoryLow=lovricCurve[0,parsedTheoryDataLowResistor];*)
(*lovricTheoryHigh=lovricCurve[0.0093,parsedTheoryDataLowResistor];*)
(**)
(*(* ===Plot all normalized Lovri\[CAcute] curves===*)*)
(*lovricPlotRanges={{10,600},{0,0.05}};*)
(*TheoryPlot=ListLogLinearPlot[{lovricTheoryLow,lovricTheoryHigh},Joined->True,PlotMarkers->False,PlotStyle->plotStyles,PlotRange->lovricPlotRanges,PlotLegends->LineLegend[plotStyles,legendLabels],Frame->True,FrameLabel->{"Frequency (Hz)","\!\(\*FractionBox[\(i\), \(f\)]\) (microA/Hz)"},PlotLabel->"Lovri\[CAcute] Plot: i/f vs Frequency",ImageSize->300];*)
(**)
(**)
(*(* ===Step 1:Create raw Lovri\[CAcute] data from each curve (i/f)===*)*)
(*lovricStandardLowConcRaw=lineStandardLowConc/. {f_,i_}:>{f,i/f};*)
(*lovricStandardHighConcRaw=lineStandardHighConc/. {f_,i_}:>{f,i/f};*)
(*(* ===Plot all normalized Lovri\[CAcute] curves===*)*)
(*ExperimentPlot=ListLogLinearPlot[{lovricStandardLowConcRaw,lovricStandardHighConcRaw},Joined->True,PlotMarkers->None,PlotStyle->plotStyles,PlotRange->lovricPlotRanges,Frame->True,FrameLabel->{"Frequency (Hz)","\!\(\*FractionBox[\(i\), \(f\)]\) (microA/Hz)"},PlotLabel->"Lovri\[CAcute] Plot: i/f vs Frequency",ImageSize->300, PlotLegends->None];*)
(**)
(*LovricPlots = Grid[ {{ExperimentPlot, TheoryPlot}}]*)
(**)


(* ::Input:: *)
(**)


(* iNorm Gain vs Freq  *)
iNormLine[highData_,lowData_]:=If[highData[[All,1]]===lowData[[All,1]],Module[{f=highData[[All,1]],iHigh=highData[[All,2]],iLow=lowData[[All,2]]},Transpose[{f,iHigh/iLow-1}]],Print["\:26a0\:fe0f Frequency mismatch in iNormLine"];$Failed];

(*Experimental \[CapitalDelta]I*)
iNormExpStandard=iNormLine[lineStandardHighConc,lineStandardLowConc];
iNormExpResistor=iNormLine[lineAddedResistorHighConc,lineAddedResistorLowConc];

(*Theory \[CapitalDelta]I*)
iNormTheoryStandard=iNormLine[theoryCurve[0.0093,parsedTheoryDataLowResistor],theoryCurve[0,parsedTheoryDataLowResistor]];

iNormTheoryResistor=iNormLine[theoryCurve[0.0093,parsedTheoryDataHighResistor],theoryCurve[0,parsedTheoryDataHighResistor]];

makeINormPlot[data_,label_]:=
ListLogLinearPlot[data,Joined->True,PlotStyle->plotStyles,
Frame->True,FrameLabel->{"Frequency (Hz)","\[CapitalDelta]Inorm - 1 (\[Micro]A)"},PlotLabel->label,PlotRange->{Automatic, {-1,2}},ImageSize->300,BaseStyle->{FontSize->10}];

iNormStandardPlot=makeINormPlot[iNormExpStandard,"\[CapitalDelta]Inorm-1 Exp5 (Standard)"];
iNormResistorPlot=makeINormPlot[iNormExpResistor,"\[CapitalDelta]Inorm-1 Exp6 (Resistor)\n compared with low conc high resistance"];
iNormTheoryStandardPlot=makeINormPlot[iNormTheoryStandard,"\[CapitalDelta]Inorm-1 Theory (Standard)"];
iNormTheoryResistorPlot=makeINormPlot[iNormTheoryResistor,"\[CapitalDelta]Inorm-1 Theory (Resistor) \n compared with low conc high resistance"];

iNormPlots = Grid[{{iNormStandardPlot,iNormTheoryStandardPlot},{iNormResistorPlot,iNormTheoryResistorPlot}},Spacings->{2,2}]


(* ::InheritFromParent:: *)
(**)


(* now repeat, but compare against the original low reisstance value *)
(*Experimental \[CapitalDelta]I*)
iNormExpStandard=iNormLine[lineStandardHighConc,lineStandardLowConc];
iNormExpResistor=iNormLine[lineAddedResistorHighConc,lineStandardLowConc];

(*Theory \[CapitalDelta]I*)
iNormTheoryStandard=iNormLine[theoryCurve[0.0093,parsedTheoryDataLowResistor],theoryCurve[0,parsedTheoryDataLowResistor]];
iNormTheoryResistor=iNormLine[theoryCurve[0.0093,parsedTheoryDataHighResistor],theoryCurve[0,parsedTheoryDataLowResistor]];

iNormStandardPlot=makeINormPlot[iNormExpStandard,"\[CapitalDelta]Inorm-1 Exp5 (Standard)"];
iNormResistorPlot=makeINormPlot[iNormExpResistor,"\[CapitalDelta]Inorm-1 Exp6 (Resistor) \n compared with low conc low resistance"];
iNormTheoryStandardPlot=makeINormPlot[iNormTheoryStandard,"\[CapitalDelta]Inorm-1 Theory (Standard)"];
iNormTheoryResistorPlot=makeINormPlot[iNormTheoryResistor,"\[CapitalDelta]Inorm-1 Theory (Resistor) \n compared with low conc low resistance"];

iNormPlots2 = Grid[{{iNormStandardPlot,iNormTheoryStandardPlot},{iNormResistorPlot,iNormTheoryResistorPlot}},Spacings->{2,2}]


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(* Calibration Curve  *)*)
(*(* ===KDM Frequencies===*)*)
(*KDMLowFreq=25;*)
(*KDMHighFreq=200;*)
(*(* ===Helper to extract mean \[CapitalDelta]I line for each concentration===*)*)
(*extractDeltaILine[group_,conc_]:=Module[{rows=group[conc]},Transpose[{frequencies,10^6*Mean/@Transpose[rows]}]];*)
(**)
(*(* ===Build delta I lines per condition===*)*)
(*deltaILinesLowResistor=AssociationMap[extractDeltaILine[grouped1,#]&,Keys[grouped1]];*)
(**)
(*deltaILinesHighResistor=AssociationMap[extractDeltaILine[grouped2,#]&,Keys[grouped2]];*)
(**)
(*(* ===Extract 0 mM Baselines===*)*)
(*baselineLowResistor=deltaILinesLowResistor[0.0];*)
(*baselineHighResistor=deltaILinesHighResistor[0.0];*)
(**)
(**)


(* ::Input:: *)
(*(* ===Robust iNorm computation===*)*)
(*iNormLineRelative[baseline_,target_]:=Module[{fBase,iBase,iTarget},{fBase,iBase}=Transpose[baseline];*)
(*{_,iTarget}=Transpose[target];*)
(*If[Length[iBase]=!=Length[iTarget],Print["\:26a0\:fe0f Mismatch in current vector lengths"];*)
(*Return[$Failed];];*)
(*Transpose[{fBase,iTarget/iBase}]];*)
(**)
(*(* ===Compute KDM from iNorm===*)*)
(*getKDMValueFixed[group_,baseline_]:=Function[conc,Module[{line,normLine,iLow,iHigh},line=group[conc];*)
(*normLine=iNormLineRelative[baseline,line];*)
(*If[normLine===$Failed,Return[$Failed]];*)
(*iLow=Interpolation[normLine][KDMLowFreq];*)
(*iHigh=Interpolation[normLine][KDMHighFreq];*)
(*(iHigh-iLow)/(0.5*(iHigh+iLow))]];*)
(**)
(*(* ===Compute KDM values per concentration===*)*)
(*nonzeroConcsLow=DeleteCases[Keys[deltaILinesLowResistor],0.0];*)
(*nonzeroConcsHigh=DeleteCases[Keys[deltaILinesHighResistor],0.0];*)
(**)
(*kdmDataExpLow=Transpose@{nonzeroConcsLow,getKDMValueFixed[deltaILinesLowResistor,baselineLowResistor]/@nonzeroConcsLow};*)
(**)
(*kdmDataExpHigh=Transpose@{nonzeroConcsHigh,getKDMValueFixed[deltaILinesHighResistor,baselineHighResistor]/@nonzeroConcsHigh};*)
(**)
(*plotStyles2={*)
(*RGBColor[0.1216,0.4667,0.7059],(*Muted blue*)*)
(*RGBColor[0.5804,0.4039,0.7412],  (*Soft purple*)*)
(*RGBColor[0.1725,0.6275,0.1725],(*Muted green*)*)
(*RGBColor[0.8392,0.1529,0.1569]  (*Muted red*)*)
(*};*)
(*calibrationPlotLinearRanges = {{5*10^-6,10^-2},{0,2}}*)
(*kdmPlotExp=ListLogLinearPlot[{kdmDataExpLow,kdmDataExpHigh},Joined->True,PlotStyle->plotStyles2,PlotMarkers->Automatic,Frame->True,FrameLabel->{"Concentration (M)","KDM Signal"},PlotLabel->"Experimental KDM vs Concentration",PlotRange->calibrationPlotLinearRanges,ImageSize->300,PlotLegends->{"Low R","High R"}]*)
(*kdmPlotExpLogLog=ListLogLogPlot[{kdmDataExpLow,kdmDataExpHigh},Joined->True,PlotStyle->plotStyles2,PlotMarkers->Automatic,Frame->True,FrameLabel->{"Concentration (M)","KDM Signal"},PlotLabel->"Experimental KDM vs Concentration",PlotRange->{{10^-6,10^-2},All},ImageSize->300,PlotLegends->{"Low R","High R"}]*)
(**)


simulationCalDataWithNoResistorFilePath


(* ::Input:: *)
(*(* theory *)*)
(*kdmDataHigh=importCalibrationBlock[simulationCalDataWithResistorFilePath,"## === Calibration Curve (KDM vs Concentration) ==="];*)
(*kdmDataLow=importCalibrationBlock[simulationCalDataWithNoResistorFilePath,"## === Calibration Curve (KDM vs Concentration) ==="];*)
(*kdMData10000 = importCalibrationBlock[simulationCalDataWithResistor10000FilePath,"## === Calibration Curve (KDM vs Concentration) ==="];*)
(*kdMData3000 = importCalibrationBlock[simulationCalDataWithResistor3000FilePath,"## === Calibration Curve (KDM vs Concentration) ==="]*)
(*kdMData6000 = importCalibrationBlock[simulationCalDataWithResistor6000FilePath,"## === Calibration Curve (KDM vs Concentration) ==="]*)
(*kdMData4000 = importCalibrationBlock[simulationCalDataWithResistor4000FilePath,"## === Calibration Curve (KDM vs Concentration) ==="]*)
(*kdMData5000 = importCalibrationBlock[simulationCalDataWithResistor5000FilePath,"## === Calibration Curve (KDM vs Concentration) ==="]*)
(**)
(*(* ===Pending Placeholder===*)pendingPlot=Show[ListLogLinearPlot[{},Frame->True,PlotRange->calibrationPlotLinearRanges],Graphics[{Text[Style["Pending data",20,Bold,Gray],Scaled[{0.5,0.5}]]}],ImageSize->300];*)
(**)
(*(* ===Theory Plot===*)*)
(*theoryPlot=ListLogLinearPlot[{kdmDataLow,kdmDataHigh},Joined->True,PlotStyle->plotStyles2,PlotMarkers->Automatic,Frame->True,FrameLabel->{"Concentration (M)","KDM Signal"},PlotLabel->"KDM vs Concentration",ImageSize->300,PlotRange->calibrationPlotLinearRanges,PlotLegends->{"238","1580"}];*)
(**)
(**)
(**)
(*(* ===Combine Side by Side===*)*)
(*calibrationPlots=Grid[{{kdmPlotExp,theoryPlot}},Spacings->{2,2}]*)
(**)


theoryPlotLogLog = ListLogLogPlot[{kdmDataLow,kdmDataHigh},
Joined->True,PlotStyle->plotStyles2,PlotMarkers->Automatic,Frame->True,FrameLabel->{"Concentration (M)","KDM Signal"},
PlotLabel->"KDM vs Concentration",ImageSize->300,PlotRange->{{10^-6,10^-2},All},PlotLegends->{"238","1580", "3000", "4000", "6000", "10000"}];
calibrationPlotsLogLog=Grid[{{kdmPlotExpLogLog,theoryPlotLogLog}},Spacings->{2,2}]


(* ===Theory Plot===*)
(* Generate a gradient of colors from blue to green *)
plotStyles3 = 
 ColorData["BlueGreenYellow"] /@ 
    Rescale[Reverse@Range[
      Length[{kdmDataLow, kdmDataHigh, kdMData3000, kdMData4000, 
        kdMData5000, kdMData6000, kdMData10000}]]];


theoryPlot2=
ListLogLinearPlot[{kdmDataLow,kdmDataHigh, kdMData3000, kdMData4000, kdMData5000, kdMData6000, kdMData10000},
	Joined->True,
	PlotStyle->plotStyles3,
	PlotMarkers->Automatic,
	Frame->True,
	FrameLabel->{"Concentration (M)","KDM Signal"},PlotLabel->"KDM vs Concentration for various solution resistance",
	ImageSize->600,
	PlotRange->{{8*10^-6,1*10^-2}, {0,1.6}},
	PlotLegends->{"238 \[CapitalOmega]","1580 \[CapitalOmega]", "3000 \[CapitalOmega]","4000 \[CapitalOmega]", "5000 \[CapitalOmega]","6000 \[CapitalOmega]", "10000 \[CapitalOmega]"}
	]

theoryPlot3=
ListPlot[{kdmDataLow,kdmDataHigh, kdMData3000, kdMData4000, kdMData5000, kdMData6000, kdMData10000},
	Joined->True,
	PlotStyle->plotStyles3,
	PlotMarkers->Automatic,
	Frame->True,
	FrameLabel->{"Concentration (M)","KDM Signal"},PlotLabel->"KDM vs Concentration for various solution resistance zoomed in",
	ImageSize->600,
	PlotRange->{{8*10^-6,1*10^-4}, {0,0.1}},
	PlotLegends->{"238 \[CapitalOmega]","1580 \[CapitalOmega]", "3000 \[CapitalOmega]","4000 \[CapitalOmega]", "5000 \[CapitalOmega]","6000 \[CapitalOmega]", "10000 \[CapitalOmega]"}
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
params3 = extractParams[simulationCalDataWithResistorFilePath];
params4 = extractParams[simulationCalDataWithNoResistorFilePath];

allParams = <|
  "simulationDataWithResistorFilePath" -> params1,
  "simulationDataWithNoResistorFilePath" -> params2,
  "simulationCalDataWithResistorFilePath" -> params3,
  "simulationCalDataWithNoResistorFilePath" -> params4
|>;



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



(* Format key-value pairs for display *)
formatParamAssoc[assoc_] := Column[
  KeyValueMap[
    Function[{k, v},
      Row[{Style[k, Plain], " = ", ScientificForm[N[v], 3]}]
    ],
    assoc
  ],
  Spacings -> 0.2
]

paramSection = Column[{
   Style["Simulation Parameters", 14, Bold],
   
   Style["Common Parameters", 12, Bold],
   Style[formatParamAssoc[commonParams], FontSize -> 10],
   
   Style["Differing Parameters by File", 12, Bold],
   Column[
     KeyValueMap[
       Function[{file, paramAssoc},
         Column[{
           Style[file, FontSize -> 10, Bold],
           Style[formatParamAssoc[paramAssoc], FontSize -> 10]
         }, Spacings -> 0.5]
       ],
       differingParams
     ],
     Spacings -> 1
   ]
  },
  Spacings -> 2
]








allPlots = {
	voltammogramPlots,
  baselinePlots,
  deltaIPlots,
  LovricPlots,
  iNormPlots,
  iNormPlots2,
  calibrationPlots,
  calibrationPlotsLogLog,
  theoryPlot2,
  theoryPlot3
};
(* Export["all_experiment_plots2.pdf",
  Column[allPlots, Spacings -> 2],
  "PDF"
] 
Export["all_experiment_plots_with_params.pdf",
  Column[
    Append[allPlots, paramSection],
    Spacings -> 2
  ],
  "PDF"
];*)
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
];

