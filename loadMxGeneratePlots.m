(* ::Package:: *)

(* ::Input:: *)
(*ClearAll["Global`*"] *)

$aptamerModelDir = If[StringQ[NotebookDirectory[]], NotebookDirectory[], DirectoryName[$InputFileName]];


(* ::Input:: *)
(*(* =====================================*)(* ===Load Latest Simulation Results===*)(* =====================================*)*)
(*resultsDir=NotebookDirectory[]<>"results\\";*)
(*latestFile=Last[SortBy[FileNames["aptamer_results_*.mx",resultsDir],FileDate]];*)
(**)
(*(* latestFile=FileNameJoin[{resultsDir,"aptamer_results_matchToExperiment_20251121183420.mx"}] *)*)
(*data=Import[latestFile];*)
(**)
(*solutions=data["Solutions"];*)
(*freqSolutionsAssoc = solutions;*)
(*metadata=data["Metadata"];*)
(**)
(**)
(*params=metadata["Parameters"]; (* make sure to call this before equations *)*)
(*(* Scan[Function[{keyVal},With[{sym=Symbol["Global`"<>keyVal[[1]]]},Unprotect[sym];*)
(*sym=keyVal[[2]];]],Normal[params]]; *)*)
(*Module[{warningTriggered=False},Scan[Function[{keyVal},With[{sym=Symbol["Global`"<>keyVal[[1]]]},Quiet[Check[(Unprotect[sym];*)
(*sym=keyVal[[2]];),If[!warningTriggered,Print[Style["\:26a0 You may need to clear global memory and try again.",Orange,Bold]];*)
(*warningTriggered=True;];*)
(*Print[Style["\:26a0 Failed to assign: "<>ToString[sym],Red]];],{Unprotect::pssl,General::readp,General::setraw}]]],Normal[params]]];*)
(**)
(**)
(*(* ===Restore function definitions from DownValues===*)*)
(*equations=metadata["Equations"];*)
(*DownValues[aptamerBoundODEs]=equations["aptamerBoundODEs"];*)
(*DownValues[aptamerUnboundODEs]=equations["aptamerUnboundODEs"];*)
(*DownValues[circuitODE]=equations["circuitODE"];*)
(*DownValues[initialRC]=equations["initialRC"];*)
(*DownValues[Tmax]=equations["Tmax"];*)
(*DownValues[SmoothSquareWave]=equations["SmoothSquareWave"];*)
(*DownValues[initialAptamer]=equations["initialAptamer"];*)
(*DownValues[makeSquareWave]=equations["makeSquareWave"];*)
(**)
(*ReleaseHold/@Values[equations]; (* release the hold on equations at the end *)*)
(**)
(**)
(*runTime=metadata["Timestamp"];*)
(*freqScanConditions=metadata["SweepConditions"];*)
(**)
(**)
(*Print["\:2714 Simulation data and metadata loaded from: ",latestFile];*)
(*Print["   \[RightArrow] Timestamp: ",runTime];*)
(*Print["   \[RightArrow] Parameters: ",Keys[params]//Length," total"];*)
(*Print["   \[RightArrow] Frequency/Concentration Sweeps: ",Length[freqScanConditions]];*)
(**)
(**)


(* ::Input:: *)
(*(* ===================================== *)*)
(*(* === Extracting voltage and current ====== *)*)
(*(* ===================================== *)*)
(**)
(*(* Total current = (V_applied - V) / R *)*)
(**)
(*VAptamerSol[label_][t_] := VAptamerGold[t] /. freqSolutionsAssoc[label][[1]];*)
(*iSWV[label_, squareWave_][t_] := (squareWave[t] - VAptamerSol[label][t]) / RSol;*)
(**)
(*(* ===================================== *)*)
(*(* ======= Sanity Check Raw current ====== *)*)
(*(* ===================================== *)*)
(*(*Preview one solution*)*)
(*sampleKey=Keys[solutions][[1]];*)
(*sampleSol=solutions[sampleKey];*)
(*freqScanConditionsLocal=metadata["SweepConditions"];*)
(*labelList=Keys[freqSolutionsAssoc];  (*solutions=data["Solutions"]*)*)
(*middleIndex=Round[Length[labelList]/2]*)
(**)
(*label=labelList[[middleIndex]];*)
(*label=labelList[[Length[labelList]]]*)
(**)
(*(* label = "Freq_248_Conc_1.e-5"; *)(* a representative data trace *)*)
(*entry = SelectFirst[freqScanConditions, #["label"] == label &];*)
(*freq = entry["freq"];*)
(*squareWave = entry["squareWave"];*)
(*TmaxVal = Tmax[freq];*)
(*Plot[*)
(*	{fOxBound[t]/. freqSolutionsAssoc[label][[1]], fOxUnbound[t]/. freqSolutionsAssoc[label][[1]]},*)
(*	{t, 0,  TmaxVal},*)
(*	PlotLabel -> "Fraction of oxidized Methelyne Blue vs time",*)
(*	AxesLabel -> {"t", "f_ox"},*)
(*	PlotRange -> All*)
(*]*)
(*Plot[{10^3 squareWave[t], 10^3 VAptamerSol[label][t], 10^6*iSWV[label, squareWave][t]}, {t, 0.35 TmaxVal, 0.45 TmaxVal}, PlotLabel -> "Voltages and current", AxesLabel -> {"t", "I(t)"}, *)
(*	PlotRange -> {Automatic,{-10,10}}, PlotLegends -> {"squareWave (mV)", "VAptamer (mV)", "iSWV (\[Micro]A)"}*)
(*]*)


Plot[{10^3 squareWave[t], 10^3 VAptamerSol[label][t]}, {t, 0.0 TmaxVal, 0.05 TmaxVal}, PlotLabel -> "Voltages and current", AxesLabel -> {"t", "I(t)"}, 
	PlotRange -> {Automatic,Automatic}, PlotLegends -> {"squareWave (mV)", "VAptamer (mV)", "iSWV (\[Micro]A)"}
]



itNonFaradaicTheory = (E^(-(t/(CDL Rsol))) V0)/Rsol
itNonFaradaicTheory = itNonFaradaicTheory/.{t->(t-0.0/600)}
paramstemp={V0->0.025,(*25 mV amplitude*)CDL->255*10^-9,Rsol->1500,Capt->850*10^-9,Rct->100000};

Plot[{10^6 iSWVFourier[t,V0,f,mMax]/. paramstemp, 10^6 itNonFaradaicTheory/.{CDL->394*10^-9, Rsol->1550, V0->0.025, fSWV->600}, 10^6*iSWV[label, squareWave][t]}, {t, 0.0 TmaxVal, 0.025 TmaxVal}, PlotLabel -> "Voltages and current", AxesLabel -> {"t", "I(t)"}, 
	PlotRange -> {Automatic,{-10,20}}, PlotLegends -> {"squareWave (mV)", "VAptamer (mV)", "iSWV (\[Micro]A)"}
]


infiniteNonFaradaic/.{CDL->394*10^-9, Rsol->1550, V0->0.025, fSWV->600}





(* ::Input:: *)
(*(* =====================================*)*)
(*(* ====Sanity Check Difference Current===*)*)
(*(* =====================================*)*)
(**)
(*computeDiffCurve[label_]:=*)
(*Module[*)
(*{entry,freq,squareWave,TmaxVal,upSwitchTimes,downSwitchTimes,fwd,rev,minN,diff,offsetBeforeSwitch,sampleAvg,iFunc},*)
(*entry=SelectFirst[freqScanConditions,#["label"]==label&];*)
(*	freq=entry["freq"];*)
(*	squareWave=entry["squareWave"];*)
(*	TmaxVal=Tmax[freq];*)
(*	offsetBeforeSwitch=1/(100 freq);*)
(*	iFunc=iSWV[label,squareWave];(*freeze label and squareWave*)(*Switching times*)*)
(*upSwitchTimes=Table[n/freq,{n,1,Floor[TmaxVal*freq]}];*)
(*	downSwitchTimes=Table[(n+0.5)/freq,{n,0,Floor[TmaxVal*freq-0.5]}];*)
(*	(*Averaging function over final portion of half-cycle*)*)
(*sampleAvg[nextSwitchTime_]:=*)
(*Module[*)
(*{t1,t2,ts},*)
(*t2=nextSwitchTime-offsetBeforeSwitch;*)
(*t1=t2-samplingWidth/(2*freq)+ offsetBeforeSwitch;(* CHI potentiostat uses 50 % avegaing over each half cycle*)*)
(*ts=Subdivide[t1,t2,99];(*100 points*) (* Print["freq = " , freq, "   t1 = ", t1, "  t2 = ", t2]; *)*)
(*Mean[iFunc/@ts]*)
(*];*)
(*(*Compute forward and reverse SWV with averaging*)*)
(*	fwd=Table[{-squareWave[downSwitchTimes[[n]]],10^6*sampleAvg[downSwitchTimes[[n]]]},{n,Length[downSwitchTimes]}];*)
(*	rev=Table[{-squareWave[upSwitchTimes[[n]]],10^6*sampleAvg[upSwitchTimes[[n]]]},{n,Length[upSwitchTimes]}];*)
(*	minN=Min[Length[fwd],Length[rev]];*)
(*	diff=Table[{fwd[[n,1]],fwd[[n,2]]-rev[[n,2]]},{n,minN}];*)
(*	<|"fwd"->fwd,"rev"->rev,"diff"->diff|>*)
(*];*)
(*exampleCurve=computeDiffCurve[label];*)
(**)
(*ListPlot[{exampleCurve["fwd"],exampleCurve["rev"],exampleCurve["diff"]},Joined->True,PlotLegends->{"Forward","Reverse","Diff"},AxesLabel->{"Potential (V)","Current (\[Micro]A)"},PlotLabel->"SWV Components",PlotRange->All,ImageSize->Large]*)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(*Keys[freqSolutionsAssoc]*)


(* ::Input:: *)
(*parseMetadata[label_String]:=Module[{matches,fstr,cstr,freq,conc},matches=StringCases[label,"Freq_"~~f__~~"_Conc_"~~c__:>{f,c}];*)
(*If[matches==={}||Length[matches[[1]]]=!=2,Return[{Missing["BadFreq"],Missing["BadConc"]}]];*)
(*{fstr,cstr}=matches[[1]];*)
(*freq=Quiet@Check[ToExpression@StringReplace[fstr,StartOfString~~"0"..->""],Missing["BadFreq"]];*)
(*conc=Quiet@Check[ToExpression@StringReplace[cstr,{"e-"->"*10^-",(*handle scientific notation*)"e"->"*10^0"     (*handle case like "0e"\[RightArrow]0*)}],Missing["BadConc"]];*)
(*{freq,conc}];*)
(**)
(*parsedDiffCurvesFixed=Association@KeyValueMap[Function[{label,sol},Module[{curve,freq,conc},curve=computeDiffCurve[label];*)
(*{freq,conc}=parseMetadata[label];*)
(*label-><|"label"->label,"freq"->freq,"conc"->conc,"diff"->curve["diff"],"fwd"->curve["fwd"],"rev"->curve["rev"]|>]],freqSolutionsAssoc];*)
(**)


(* ::Input:: *)
(*(* === Group by corrected concentration and sort by frequency === *)*)
(*curvesByConc = GroupBy[*)
(*  Values[parsedDiffCurvesFixed],*)
(*  #["conc"] &,*)
(*  Function[curves, SortBy[curves, #["freq"] &]]*)
(*];*)


(* === Generate plots === *)
plotsByConc = KeyValueMap[
  Function[{conc, curves},
    Module[
      {freqs, colors, legendLabels, lines},
      
      freqs = curves[[All, "freq"]];
      colors = ColorData["BlueGreenYellow"] /@ Rescale[Reverse@Range[Length[freqs]]];
      legendLabels = Placed[
        SwatchLegend[colors, Map["f = " <> ToString[#] <> " Hz" &, freqs]],
        Right
      ];

      lines = MapThread[
        ListLinePlot[#1["fwd"], PlotStyle -> {#2, Thick}, Joined -> True] &,
        {curves, colors}
      ];
      
      Show[
        lines,
        PlotLabel -> Row[{"SWV forward I vs Potential at Conc = ", conc, " M"}],
        AxesLabel -> {"Potential (V)", "\[CapitalDelta]I (nA)"},
        Frame -> True,
        PlotLegends -> legendLabels,
        ImageSize -> Large,
        PlotRange -> {Automatic, {0, 20}}
      ]
    ]
  ],
  curvesByConc
]




(* ::Input:: *)
(*(* === Generate plots === *)*)
(*plotsByConc = KeyValueMap[*)
(*  Function[{conc, curves},*)
(*    Module[*)
(*      {freqs, colors, legendLabels, lines},*)
(*      *)
(*      freqs = curves[[All, "freq"]];*)
(*      colors = ColorData["BlueGreenYellow"] /@ Rescale[Reverse@Range[Length[freqs]]];*)
(*      legendLabels = Placed[*)
(*        SwatchLegend[colors, Map["f = " <> ToString[#] <> " Hz" &, freqs]],*)
(*        Right*)
(*      ];*)
(**)
(*      lines = MapThread[*)
(*        ListLinePlot[#1["diff"], PlotStyle -> {#2, Thick}, Joined -> True] &,*)
(*        {curves, colors}*)
(*      ];*)
(*      *)
(*      Show[*)
(*        lines,*)
(*        PlotLabel -> Row[{"SWV \[CapitalDelta]I vs Potential at Conc = ", conc, " M"}],*)
(*        AxesLabel -> {"Potential (V)", "\[CapitalDelta]I (nA)"},*)
(*        Frame -> True,*)
(*        PlotLegends -> legendLabels,*)
(*        ImageSize -> Large,*)
(*        PlotRange -> {Automatic, {0, 20}}*)
(*      ]*)
(*    ]*)
(*  ],*)
(*  curvesByConc*)
(*]*)
(**)
(**)


(* ::Input:: *)
(*(* now extract the baselin and peak currents as a function of frequency for each concentration*)*)


Remove["Global`analyzeVoltammogram"];
$aptamerModelDir = If[StringQ[NotebookDirectory[]], NotebookDirectory[], DirectoryName[$InputFileName]];
Get[FileNameJoin[{$aptamerModelDir, "AnalyzeVoltammogram.m"}]];
AppendTo[$ContextPath, "AnalyzeVoltammogram`"];



entry = RandomChoice @ RandomChoice @ Values[curvesByConc];
data = entry["diff"];
result = analyzeVoltammogram[data];

Show[
  ListPlot[
    Take[data, {6, -6}],
    PlotStyle -> {Black, PointSize[0.012]},
    Frame -> True,
    FrameLabel -> {"Voltage (V)", "\!\(\Delta\)I (A)"},
    PlotLabel -> StringJoin[
      "QC Fit \[LongDash] Label: ", entry["label"],
      " | Freq: ", ToString[entry["freq"]], " Hz",
      " | Conc: ", ToString[entry["conc"]], " M\n",
      "Baseline: ", ToString[NumberForm[result["Baseline"], {5, 3}]], " \[Micro]A, ",
      "\[CapitalDelta]I: ", ToString[NumberForm[result["DeltaI"], {5, 3}]], " \[Micro]A, ",
      "Peak: ", ToString[NumberForm[result["PeakCurrent"], {5, 3}]], " \[Micro]A"
    ],
    ImageSize -> Large
  ],
  Plot[
    result["Fit"][x],
    {x, Min[data[[All, 1]]], Max[data[[All, 1]]]},
    PlotStyle -> {Red, Thick}
  ]
]



resultsByConc = AssociationMap[
  Function[conc,
    Table[
      Module[{entry = curve, result},
        result = analyzeVoltammogram[curve["diff"]];
        <|
          "freq" -> curve["freq"],
          "label" -> curve["label"],
          "Baseline" -> result["Baseline"],
          "DeltaI" -> result["DeltaI"]
        |>
      ],
      {curve, curvesByConc[conc]}
    ]
  ],
  Keys[curvesByConc]
];



baselineDataByConc = AssociationMap[
  With[{curves = resultsByConc[#]},
    SortBy[Table[{c["freq"], c["Baseline"]}, {c, curves}], First]
  ] &,
  Keys[resultsByConc]
];

ListLogLinearPlot[
  Values[baselineDataByConc],
  Joined -> True,
  PlotStyle -> Thick,
  PlotLegends -> Placed[
    LineLegend[Keys[baselineDataByConc], LabelStyle -> Small],
    Right
  ],
  PlotLabel -> "Baseline Current vs Frequency",
  FrameLabel -> {"Frequency (Hz)", "Baseline I (\[Mu]A)"},
  Frame -> True,
  ImageSize -> Large
]




peakDeltaIBaselineSubtractedByConc = AssociationMap[
  With[{curves = resultsByConc[#]},
    SortBy[Table[{c["freq"], c["DeltaI"]}, {c, curves}], First]
  ] &,
  Keys[resultsByConc]
];

ListLogLinearPlot[
  Values[peakDeltaIBaselineSubtractedByConc],
  Joined -> True,
  PlotStyle -> Thick,
  PlotLegends -> Placed[
    LineLegend[Keys[peakDeltaIBaselineSubtractedByConc], LabelStyle -> Small],
    Right
  ],
  PlotLabel -> "Peak Current vs Frequency",
  FrameLabel -> {"Frequency (Hz)", "Peak I (\[Mu]A)"},
  Frame -> True,
  ImageSize -> Large
]



(* === Extract lowest and highest concentration datasets === *)
lowestConc = Min[Keys[peakDeltaIBaselineSubtractedByConc]];
highestConc = Max[Keys[peakDeltaIBaselineSubtractedByConc]];

lowData = AssociationThread @@ Transpose[peakDeltaIBaselineSubtractedByConc[lowestConc]]
highData = AssociationThread @@ Transpose[peakDeltaIBaselineSubtractedByConc[highestConc]]

(* === Compute normalized current (iNorm = I_high / I_low) at common frequencies === *)
commonFreqs = Intersection[Keys[lowData], Keys[highData]];

iNormData = Table[
   {f, highData[f]/lowData[f]-1},
   {f, commonFreqs}
]

(* === Plot iNorm vs Frequency === *)
ListLogLinearPlot[iNormData,
 PlotStyle -> {Blue, Thick},
 Joined -> True,
 PlotLabel -> "iNorm Gain vs Frequency",
 Frame -> True,
 FrameLabel -> {"Frequency (Hz)", "iNorm Gain = I_highConc / I_lowConc - 1"},
 ImageSize -> Large
]



(* ::Input:: *)
(*(* Lovric Plot *)*)
(*peakDeltaIBaselineSubtractedByConc;*)
(*(* ===Normalize by frequency to create Lovric plot===*)*)
(*(* lovricDataByConc=AssociationMap[Function[data,data/. {f_,y_}:>{f,y/f}],peakDeltaIBaselineSubtractedByConc] *)*)
(*lovricDataByConc=Association@Map[Function[{rule},Module[{conc=rule[[1]],data=rule[[2]]},conc->({#[[1]],#[[2]]/#[[1]]}&/@data)]],Normal[peakDeltaIBaselineSubtractedByConc]];*)
(**)
(*(*Format concentration labels*)*)
(*legendLabels=Map[ToString[#]<>" M"&,Keys[lovricDataByConc]];*)
(**)
(*(* ===Plot Lovric plot===*)*)
(*ListLogLinearPlot[Values[lovricDataByConc],Joined->True,PlotStyle->Thick,PlotLegends->Placed[LineLegend[legendLabels,LabelStyle->Small],Right],PlotLabel->"Lovri\[CAcute] Plot: Normalized SWV Peak vs Frequency",FrameLabel->{"Frequency (Hz)","\!\(\*FractionBox[\(\[CapitalDelta]I\), \(f\)]\) (\[Mu]A/Hz)"},Frame->True,ImageSize->Large]*)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(*(* Step 1: Flatten all {f, i/f} values from all concentrations *)*)
(*allLovricValues = Flatten[Values[lovricDataByConc], 1][[All, 2]];*)
(**)
(*(* Step 2: Find the global maximum *)*)
(*maxLovric = Max[allLovricValues];*)
(**)
(*(* Step 3: Normalize each value by maxLovric *)*)
(*normalizedLovricDataByConc = *)
(*  Map[# /. {f_, y_} :> {f, y/maxLovric} &, lovricDataByConc, {1}];*)
(**)
(**)
(*ListLogLinearPlot[Values[normalizedLovricDataByConc],Joined->True,PlotLegends->Placed[LineLegend[legendLabels,LabelStyle->Small],Right],PlotLabel->"Lovri\[CAcute] Plot: Normalized SWV Peak vs Frequency",FrameLabel->{"Frequency (Hz)","\!\(\*FractionBox[\(\[CapitalDelta]I\), \(f\)]\) (\[Mu]A/Hz)"},Frame->True,ImageSize->Large]*)
(**)
(**)


(* ::Input:: *)
(*(* Calibration curve (based on 25 and 200 Hz data) *)*)


(* ::Input:: *)
(*(* KDM = currents at 200 Hz*)*)


(* ::Input:: *)
(*(*Define frequencies used in KDM*)*)
(*lowFreq=25;*)
(*highFreq=200;*)
(**)
(*(*Helper to extract y-value at a specific frequency from a list of {freq,value}*)*)
(*getAtFreq[data_,freq_]:=Lookup[AssociationThread[data[[All,1]],data[[All,2]]],freq,Missing[]];*)
(**)
(*(*Extract {conc,iLow,iHigh} for all concentrations*)*)
(*valuesByConc=Table[Module[{data=peakDeltaIBaselineSubtractedByConc[conc]},{conc,getAtFreq[data,lowFreq],getAtFreq[data,highFreq]}],{conc,Keys[peakDeltaIBaselineSubtractedByConc]}]*)
(**)
(*(*Get baseline-subtracted values at zero concentration*)*)
(*(*Identify zero-concentration values for normalization*)*)
(*i0Low=getAtFreq[peakDeltaIBaselineSubtractedByConc[0],lowFreq];*)
(*i0High=getAtFreq[peakDeltaIBaselineSubtractedByConc[0],highFreq];*)
(**)
(*(* use the "New KDM" method from Plaxco group *)*)
(* kdmGain[iNormHighFreq_, iNormLowFreq_] := (iNormHighFreq-iNormLowFreq)/((1/2) *(iNormHighFreq+iNormLowFreq)); *)
(**)


(* ::Input:: *)
(*(* ===Compute KDM points===*)*)
(*kdmPoints=Select[Table[Module[{*)
(*conc=row[[1]],*)
(*iLow=row[[2]],*)
(*iHigh=row[[3]],*)
(*gainLow,*)
(*gainHigh,*)
(*iNormLow,*)
(*iNormHigh,*)
(*kdm},*)
(*	If[conc==0||AnyTrue[{iLow,iHigh},MissingQ],Nothing,*)
(*	iNormLow =iLow/i0Low ;*)
(*	iNormHigh=iHigh/i0High;*)
(*	kdm=kdmGain[iNormHigh,iNormLow];*)
(*	{conc,kdm}]*)
(*	],{row,valuesByConc}],ListQ*)
(*]*)
(**)
(*(* ===Optionally show the raw table for sanity check===*)*)
(*Grid[Prepend[kdmPoints,{"Concentration (M)","KDM Signal"}],Frame->All]*)
(**)
(*(* ===Plot===*)*)
(*ListLogLinearPlot[kdmPoints,Joined->True,PlotStyle->{Red,Thin},PlotMarkers->Automatic,Frame->True,FrameLabel->{"Concentration (M)","KDM Signal"},PlotLabel->"Kinetic Differential Measurement (KDM) vs Concentration",ImageSize->Large, PlotRange->{{10^-7,10^-2},{0,2}}]*)


(* digest the voltammograms for TXT export *)
voltammogramText = StringJoin @ KeyValueMap[
  Function[{conc, curves},
    
    voltages = curves[[1, "diff"]][[All, 1]];
    freqs = curves[[All, "freq"]];
    
    dataMatrix = Transpose @ Map[
      #[["diff"]][[All, 2]] &,  (* already in \[Micro]A *)
      curves
    ];
    
    header = StringJoin[
      "## === Voltammograms at Conc = ", ToString[conc], " M ===\n",
      StringRiffle[
        Prepend[Map["f=" <> ToString[#] <> " Hz" &, freqs], "Voltage (V)"],
        "\t"
      ],
      "  [Current in \[Micro]A]\n"
    ];
    
    rows = StringRiffle[
      MapThread[
        Function[{v, row},
          StringJoin[
            ToString[NumberForm[v, {4, 3}, ExponentFunction -> (Null &)]], "\t",
            StringRiffle[
              Map[
                ToString[
                  NumberForm[#, {6, 6}, ExponentFunction -> (Null &)]
                ] &,
                row
              ],
              "\t"
            ]
          ]
        ],
        {voltages, dataMatrix}
      ],
      "\n"
    ];
    
    StringJoin[header, rows, "\n\n"]
  ],
  curvesByConc
];



(* digest the current vs freq data for TXT export *)
formatTableByConc = Function[{dataByConc, label},
  concs = Keys[dataByConc];
  freqs = Union @@ (dataByConc[#][[All, 1]] & /@ concs);
  
  header = StringJoin[
    "## === ", label, " ===\n",
    StringRiffle[Prepend[freqs, "Conc (M)"] /. f_ /; NumberQ[f] :> "f=" <> ToString[f] <> " Hz", "\t"],
    "  [Current in \[Micro]A]\n"
  ];
  
  rows = StringRiffle[
    Table[
      StringJoin[
        ToString[conc], "\t",
        StringRiffle[
          Map[
            Function[freq,
              With[{row = SelectFirst[dataByConc[conc], #[[1]] == freq &]},
                If[row === Missing["NotFound"], "NA",
                  ToString[NumberForm[row[[2]], {6, 6}, ExponentFunction -> (Null &)]]
                ]
              ]
            ],
            freqs
          ],
          "\t"
        ]
      ],
      {conc, concs}
    ],
    "\n"
  ];
  
  StringJoin[header, rows, "\n\n"]
];

baselineText = formatTableByConc[baselineDataByConc, "Baseline Current vs Frequency"];
deltaIText = formatTableByConc[peakDeltaIBaselineSubtractedByConc, "Peak \[CapitalDelta]I vs Frequency"];



lovricDataByConc;


(* Get all unique frequencies in sorted order *)
allFreqs = Union[Flatten[Values[lovricDataByConc][[All, All, 1]]]];

(* Construct table header *)
lovricHeader = StringJoin[
  "## === Lovric Plot Data ===\n",
  "## \[CapitalDelta]I/f in \[Micro]A/Hz\n",
  "Conc (M)\t",
  StringRiffle[ToString[#, InputForm] <> " Hz" & /@ allFreqs, "\t"],
  "\n"
];

(* Construct rows for each concentration *)
lovricRows = StringRiffle[
  KeyValueMap[
    Function[{conc, data},
      Module[{assoc = Association[Rule @@@ data]},
        ToString[conc] <> "\t" <>
        StringRiffle[
          Map[
            Function[f,
              ToString[NumberForm[Lookup[assoc, f, "NaN"], {6, 6}]]
            ],
            allFreqs
          ],
          "\t"
        ]
      ]
    ],
    lovricDataByConc
  ],
  "\n"
];

(* Combine into full text *)
lovricText = StringJoin[lovricHeader, lovricRows, "\n\n"];




iNormData


(* === Format iNorm Gain Section === *)
iNormHeader = StringJoin[
  "## === iNorm Gain Data ===\n",
  "## Definition: iNorm Gain = I_highConc / I_lowConc - 1\n",
  "Frequency (Hz)\tiNorm Gain (unitless)\n"
];

iNormRows = StringRiffle[
  Map[
    Function[pair,
      ToString[pair[[1]]] <> "\t" <> ToString[NumberForm[pair[[2]], {6, 6}]]
    ],
    iNormData
  ],
  "\n"
];


iNormText = StringJoin[iNormHeader, iNormRows, "\n\n"];




kdmPoints


kdmTableText = StringJoin[
  "## === Calibration Curve (KDM vs Concentration) ===\n",
  "Concentration (M)\tKDM Signal\n",
  StringRiffle[
    Map[
      Function[pair,
        ToString[pair[[1]]] <> "\t" <> ToString[NumberForm[pair[[2]], {6, 6}]]
      ],
      kdmPoints
    ],
    "\n"
  ],
  "\n\n"
];




(* Now prepare and write the TXT file *)

paramsAssoc = Association@params;

(* Format each key-value pair to string *)
paramsText = StringJoin[
  "## === Simulation Parameters ===\n",
  StringRiffle[
    Map[
      Function[{rule},
        ToString[rule[[1]]] <> " = " <> ToString[rule[[2]], InputForm]
      ],
      Normal[paramsAssoc]
    ],
    "\n"
  ],
  "\n\n"
];

(* Optional header section *)
headerText = StringJoin[
  "## === Simulation Export ===\n",
  "Timestamp: ", metadata["Timestamp"], "\n\n",
  paramsText
];
(* Updated plot section with actual data *)
plotSection = StringJoin[
  "## === Voltammogram Data ===\n",
  voltammogramText,
  "## === Currents vs Freq ===\n\n",
  baselineText,
  deltaIText,
  "## === Lovric Plot\n",
  lovricText,
  "## === iNorm Gain vs Freq\n",
  iNormText,
  "## === Calibration Curve\n",
  kdmTableText
];


(* Combine and export *)
fullText = StringJoin[headerText, plotSection];
outputFile = FileNameJoin[{NotebookDirectory[], "results", "simulation_export_full_header.txt"}];
Export[outputFile, fullText, "Text"]

