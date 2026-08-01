(* ::Package:: *)

(* ================================================================
   fitRCData_2026_07_15.m
   Fit Rsol and CDL from non-Faradaic SWV baseline current vs frequency.
   Dataset: 2026-07-15, true RC circuits (resistor + capacitor in series).
     * 2 k\[CapitalOmega]  + 220 nF
     * 47 k\[CapitalOmega] + 220 nF
   Reuses analyticalBaselineExpression and fitting logic from
   fitRsolCDLfromData.m; imports via loadExperimentalVoltammogramGeneratePlots.m
   ================================================================ *)

Get["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\loadExperimentalVoltammogramGeneratePlots.m"]


(* ---- Analytical non-Faradaic baseline current (from analyticalCurrentGivenParams.m) ---- *)
(* analyticalBaselineExpression =  4 CDL E^(-(2/(CDL fSWV Rsol)))(-1 + E^(1/(4 CDL fSWV Rsol)))(-1 + 3 E^(1/(2 CDL fSWV Rsol)) - 4 E^(1/(CDL fSWV Rsol)) + 4 E^(3/(2 CDL fSWV Rsol)))fSWV V0; *)

analyticalBaselineExpression=4 CDL E^(-(2/(CDL fSWV Rsol))) (-1+E^(1/(4 CDL fSWV Rsol))) (-1+3 E^(1/(2 CDL fSWV Rsol))-4 E^(1/(CDL fSWV Rsol))+4 E^(3/(2 CDL fSWV Rsol))) fSWV V0
analyticalBaselineExpression = analyticalBaselineExpression /. {fSWV -> 1/(2 t1), V0 -> 0.025};

ModelFunction[frequency_?NumericQ, params_Association] := Module[{t1Local},
  t1Local = 1/(2*frequency);
  N[analyticalBaselineExpression /. {CDL -> params["CDL"], Rsol -> params["Rsol"], t1 -> t1Local}]
];

FitFunctionRC[data_, initialGuesses_Association, rsolMax_: 200000] :=
  Module[{modelFunc, fit},
    modelFunc[f_, cdl_, rsol_] := ModelFunction[f, <|"CDL" -> cdl, "Rsol" -> rsol|>];
    fit = FindFit[
      data,
      modelFunc[f, cdl, rsol],
      {{cdl,  initialGuesses["CDL"],  1*^-10, 1*^-5},
       {rsol, initialGuesses["Rsol"], 10,     rsolMax}},
      f,
      Method -> {"NMinimize"}, AccuracyGoal -> 6, PrecisionGoal -> 6, MaxIterations -> 5000
    ];
    <|"CDL" -> (cdl /. fit), "Rsol" -> (rsol /. fit)|>
  ];


(* ---- Import voltammograms ---- *)
baseDir = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\experimentalData\\2026_07_15\\";

raw2k  = LoadVoltammogramData`loadAllVoltammograms[baseDir <> "2kOhm_resistor_220nF_capacitor_inseries"];
raw47k = LoadVoltammogramData`loadAllVoltammograms[baseDir <> "47kOhm_resistor_220nF_capacitor_inseries"];


(* ---- Extract {frequency (Hz), mean |IDiff| (A)} per file ----
   Pure RC: no Faradaic peak, so the mean of the Diff column is the
   non-Faradaic baseline current for that frequency. *)
extractBaselineData[records_] :=
  SortBy[
    Table[
      {record["Frequency"], Mean[Abs[record["IDiff"][[All, 1]]]]},
      {record, records}
    ],
    First
  ];

data2k  = extractBaselineData[raw2k];
data47k = extractBaselineData[raw47k];

Print["=== 2 k\[CapitalOmega] dataset  {freq Hz, current A} ==="];  Print[data2k];
Print["=== 47 k\[CapitalOmega] dataset {freq Hz, current A} ==="];  Print[data47k];


(* ---- Tick helpers (borrowed from fitRsolCDLfromData.m) ---- *)
makeOutsideTicksCustom[vals_] :=
  Table[{x, x, {0, 0.02}}, {x, vals}];
makeOutsideTicksCustom[vals_] :=
  ({#, If[IntegerQ[#], #, N[#]], {0, 0.02}} &) /@ vals;

makeOutsideLogTicks[min_, max_] := Module[{major},
  major = 10^Range[Ceiling[Log10[min]], Floor[Log10[max]]];
  ({#, Superscript[10, Log10[#]], {0, 0.02}} &) /@ major
];

(* Auto-compute nice linear y ticks from {freq, currentA} baseline data *)
makeYTicks[data_] := Module[{ymax, step, vals},
  ymax = Max[10^6 * data[[All, 2]]];
  step = 10^Floor[Log10[ymax / 4]];
  vals = Range[0, Ceiling[ymax * 1.15, step], step];
  makeOutsideTicksCustom[vals]
];

(* Auto-compute nice linear y ticks from a known max value (already in \[Micro]A) *)
makeYTicksFromMax[ymax_] := Module[{step, vals},
  step = 10^Floor[Log10[ymax / 4]];
  vals = Range[0, Ceiling[ymax * 1.15, step], step];
  makeOutsideTicksCustom[vals]
];


(* ---- Diagnostic: plot raw voltammograms at one frequency ----
   Plots IDiff vs potential for both datasets to verify import and
   confirm the expected flat (no Faradaic peak) shape for a pure RC. *)
voltFreq = 10;  (* Hz to inspect *)

getVoltammogram[records_, targetFreq_] := Module[{rec},
  rec = SelectFirst[records, #["Frequency"] == targetFreq &];
  If[MissingQ[rec],
    Print["\[WarningSign] No record found at ", targetFreq, " Hz"]; {},
    Transpose[{rec["Voltage"], 10^6 * rec["IDiff"][[All, 1]]}]
  ]
];

volt2k  = getVoltammogram[raw2k,  voltFreq];
volt47k = getVoltammogram[raw47k, voltFreq];

makeVoltPlot[data_, label_] := Module[{vTicks, iTicks, imax},
  (* voltage runs ~-0.12 to -0.45 V; current range from data *)
  vTicks = makeOutsideTicksCustom[{-0.45, -0.35, -0.25, -0.15}];
  imax   = Max[data[[All, 2]]];
  iTicks = makeYTicksFromMax[imax];
  ListLinePlot[data,
    Frame -> True, Axes -> False,
    FrameLabel -> {
      {Style["IDiff (\[Micro]A)", 14, Bold, FontFamily -> "Helvetica"], None},
      {Style["Potential (V)",     14, Bold, FontFamily -> "Helvetica"], None}
    },
    FrameTicks -> {{iTicks, None}, {vTicks, None}},
    FrameTicksStyle -> Directive[FontFamily -> "Helvetica", FontSize -> 12, Black],
    PlotLabel  -> Style[label <> " @ " <> ToString[voltFreq] <> " Hz", 12, FontFamily -> "Helvetica"],
    PlotStyle  -> {Blue, Thick},
    Background -> White,
    BaseStyle  -> {FontFamily -> "Helvetica"},
    PlotRange->{Automatic,{0,Automatic}},
    ImageSize  -> 400
  ]
];

voltPlot2k  = makeVoltPlot[volt2k,  "2 k\[CapitalOmega]"];
voltPlot47k = makeVoltPlot[volt47k, "47 k\[CapitalOmega]"];

GraphicsRow[{voltPlot2k, voltPlot47k}, Spacings -> 0.15, Background -> White, ImageSize -> 860]


(* ---- Fit CDL and Rsol ---- *)
result2k  = FitFunctionRC[data2k,  <|"CDL" -> 220*^-9, "Rsol" -> 2000|>,   10000];
result47k = FitFunctionRC[data47k, <|"CDL" -> 220*^-9, "Rsol" -> 47000|>, 200000];

Print[""];
Print["=== Fit results ==="];
Print["2 k\[CapitalOmega]:   Rsol = ", NumberForm[N@result2k["Rsol"],  {6,0}], " \[CapitalOmega]   CDL = ", NumberForm[N[result2k["CDL"]*10^9],  {4,1}], " nF"];
Print["47 k\[CapitalOmega]:  Rsol = ", NumberForm[N@result47k["Rsol"], {6,0}], " \[CapitalOmega]   CDL = ", NumberForm[N[result47k["CDL"]*10^9], {4,1}], " nF"];


fmtLabel[tag_, params_] :=
  Style[
    Column[{
      tag,
      Row[{
        Subscript["R", "sol"], " = ", Round[N @ params["Rsol"]], " \[CapitalOmega]",
        "    ",
        Subscript["C", "DL"],  " = ", NumberForm[N[params["CDL"]*10^9], {4, 1}], " nF"
      }]
    }, Alignment -> Center],
    12, FontFamily -> "Helvetica"
  ];



makeFitPlot[data_, result_, label_] :=
  Module[{pts, ymaxData, rawStep, mag, nf, step, ymax, yTicks, fittedModel},
    pts      = ({#[[1]], 10^6 * #[[2]]} &) /@ data;
    ymaxData = Max[pts[[All, 2]]];
    (* Nice-step algorithm: target ~4 intervals; rounds step to 1, 2, or 5 \[Times] 10^n *)
    rawStep  = ymaxData * 1.2 / 4;
    mag      = 10^Floor[Log10[rawStep]];
    nf       = rawStep / mag;
    step     = mag * Which[nf < 1.5, 1, nf < 3.5, 2, nf < 7.5, 5, True, 10];
    ymax     = Ceiling[ymaxData * 1.2, step];
    yTicks   = makeOutsideTicksCustom[Range[0, ymax, step]];
    fittedModel[f_] := ModelFunction[f, result];

    Show[
      ListLogLinearPlot[pts,
        PlotStyle  -> {Black, PointSize[0.015]},
        PlotRange  -> {{7, 700}, {0, ymax}},
        Frame -> True, Axes -> False,
        FrameLabel -> {
          Style["Frequency (Hz)",      14, Bold, FontFamily -> "Helvetica"],
          Style["Current (\[Micro]A)", 14, Bold, FontFamily -> "Helvetica"]
        },
        FrameTicks -> {{yTicks, None}, {makeOutsideLogTicks[8, 700], None}},
        FrameTicksStyle -> Directive[FontFamily -> "Helvetica", FontSize -> 12, Black],
        Background  -> White,
        BaseStyle   -> {FontFamily -> "Helvetica"},
        PlotLabel   -> fmtLabel[label, result]
      ],
      LogLinearPlot[10^6 fittedModel[f], {f, 7, 700},
        PlotStyle -> {Red, Thick},
        PlotRange -> {{7, 700}, {0, ymax}}
      ],
      ImageSize -> 430
    ]
  ];


plot2k  = makeFitPlot[data2k,  result2k,  "2 k\[CapitalOmega] resistor"];
plot47k = makeFitPlot[data47k, result47k, "47 k\[CapitalOmega] resistor"];

plot2k
plot47k


(* ---- Side-by-side comparison ---- *)
GraphicsRow[{plot2k, plot47k}, Spacings -> 0.15, Background -> White, ImageSize -> 950]


(* ---- Summary table ---- *)
Grid[
  {
    {Style["",                                   Bold, FontFamily -> "Helvetica"],
     Style["2 k\[CapitalOmega] fitted",          Bold, FontFamily -> "Helvetica"],
     Style["2 k\[CapitalOmega] error",           Bold, FontFamily -> "Helvetica"],
     Style["47 k\[CapitalOmega] fitted",         Bold, FontFamily -> "Helvetica"],
     Style["47 k\[CapitalOmega] error",          Bold, FontFamily -> "Helvetica"]},
    {Row[{Subscript["R", "sol"], " (\[CapitalOmega])"}],
     NumberForm[N @ result2k["Rsol"],  {6, 0}],
     Row[{NumberForm[N[100 (result2k["Rsol"]  - 2000)  / 2000],  {4, 1}], "%"}],
     NumberForm[N @ result47k["Rsol"], {6, 0}],
     Row[{NumberForm[N[100 (result47k["Rsol"] - 47000) / 47000], {4, 1}], "%"}]},
    {Row[{Subscript["C", "DL"], " (nF)"}],
     NumberForm[N[result2k["CDL"]  * 10^9], {4, 1}],
     Row[{NumberForm[N[100 (result2k["CDL"]  * 10^9 - 220) / 220], {4, 1}], "%"}],
     NumberForm[N[result47k["CDL"] * 10^9], {4, 1}],
     Row[{NumberForm[N[100 (result47k["CDL"] * 10^9 - 220) / 220], {4, 1}], "%"}]}
  },
  Frame -> All,
  Spacings -> {2, 1},
  Background -> {None, {White, {LightBlue, White}}},
  BaseStyle  -> {FontFamily -> "Helvetica", FontSize -> 12}
]

