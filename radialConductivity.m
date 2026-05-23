(* ::Package:: *)

(* ::Input:: *)
(*Needs["NDSolve`FEM`"]*)


(* ::Input:: *)
(*(* Geometric parameters *)*)
(*a=0.1;         (*electrode radius (mm)*)*)
(*L1=5;          (*upper electrode length*)*)
(*L2=3;          (*lower electrode length*)*)
(*g=1;           (*gap between electrodes*)*)
(*H=L1+g+L2+ 2;   (*total height - add a millimeter of space on top*)*)
(**)
(**)
(*R=1;           (* outer radial boundary - assume a rat artery is 2mm diameter - 1mm radius *)*)
(*R=15;           (* outer radial boundary - 15mm is a "shot glass" where calibration is done - assume subcutaneous is the same *) (* 0.6mm is the inner diameter of a 20 guage catheter *)*)
(**)
(**)
(*V1=1;            (*upper electrode potential*)*)
(*V2=0;            (*lower electrode potential*)*)
(**)
(*(*Define region and mesh*)*)
(*region=ImplicitRegion[a<=r<=R&&0<=z<=H,{r,z}];*)
(**)
(*mesh=ToElementMesh[region,"MaxCellMeasure"->0.0001,"MeshOrder"->2];*)
(**)
(*(*PDE in axial symmetry*)*)
(*Clear[\[CurlyPhi],r,z]*)
(**)
(**)
(**)
(*pde=(1/r) D[r D[\[CurlyPhi][r,z],r],r]+ D[\[CurlyPhi][r,z],{z,2}]==0;*)
(**)
(*(*Electrode z ranges*)*)
(*zTop1=H-L1-1;*)
(*zTop2=L2+1;*)
(**)
(*(*Boundary conditions*)*)
(* bc={DirichletCondition[\[CurlyPhi][r,z]==V1,zTop1<=z<=H-1&&r==a],DirichletCondition[\[CurlyPhi][r,z]==V2,1<=z<=zTop2&&r==a]}; (* two cylindrical electrodes seperated by a gap *) *)
(**)
(*(*Solve PDE*)*)
(*progress=0.;  (*global progress tracker*)*)
(**)
(*sol=NDSolveValue[{pde,bc},\[CurlyPhi],Element[{r,z},mesh]];*)
(**)
(*(*Plot potential field*)*)
(* DensityPlot[sol[r,z],{r,a,R},{z,0,H},PlotPoints->60,ColorFunction->"ThermometerColors",ColorFunctionScaling->False,PlotRange->{V2,V1},PlotLegends->Automatic,AspectRatio->1, FrameLabel->{Style["r (mm)",18,Bold],Style["z (mm)",18,Bold]},LabelStyle->{FontFamily->"Helvetica",FontSize->16,Bold},PlotLabel->Style["Potential Field \[Phi](r, z)",20,Bold]] *)
(**)
(**)


(* ::Input:: *)
(*(* mesh["Wireframe"] *)*)


(* ::Input:: *)
(*(*---Parameters for current calculation---*)*)
(**)
(**)
(*\[Sigma]=(0.0014+0.00178)/2 * (1+0.0214*(37-25)) ;  (*conductivity of 1X PBS in S/mm*) (* https://www.fishersci.ie/webfiles/uk/web-docs/UKLS_1257.PDF 1.4 - 1.78 at 25 C.. with a temperature coeffeicient of 2.14 per degree... https://en.wikipedia.org/wiki/Electrical_conductivity_meter *)*)
(**)
(**)
(*\[Sigma]=0.002;   (*conductivity of PBS (S/mm)*)*)
(*\[Sigma]=0.0007;   (*conductivity of blood in S/mm*)*)
(*\[Sigma]=0.00013;   (*conductivity in S/mm-for muscle fiber perpendicular:https://pubmed.ncbi.nlm.nih.gov/39825696/*)*)
(*\[Sigma]=0.00056;   (*conductivity in S/mm - for muscle fiber parallel: https://pubmed.ncbi.nlm.nih.gov/39825696/*)*)
(*\[Sigma]=0.00004;   (*conductivity in S/mm - for fat 10.1088/0031-9155/55/9/N03 *)*)
(*\[Sigma]=0.00021;   (*conductivity in S/mm - for fatty tissue: https://pubmed.ncbi.nlm.nih.gov/39825696/*)*)
(**)
(*zElectrode=L2+1+g/2;   (*Midpoint of gap *)*)
(**)
(*Jz[r_]:=-\[Sigma] D[sol[r,z],z]/. z->zElectrode*)
(**)
(*(*Total current through the electrode*)*)
(*Itotal=-2 \[Pi] NIntegrate[r Jz[r],{r,a,R},AccuracyGoal->4,Method->"GlobalAdaptive"]; (* negative sign to correct for negative current flux *)*)
(*ReferencePotential = sol[0.1, H] (* the reference electrode senses the potential above the Pt counter.. this means that uncompensated resistance is less than teh total CE-WE resistance! thin Pt CE is wire not a problem *)*)
(*V=ReferencePotential-V2;*)
(*Resistance=V/Itotal//N;*)
(**)
(*(*Compute geometry factor*)*)
(*GeometryFactor=Resistance*\[Sigma];  (*Units:mm\:207b\.b9*)*)
(**)
(*(*Output results*)*)
(*Print["--- Resistance Estimation ---"];*)
(*Print["ReferencePotential (V): ",ReferencePotential];*)
(*Print["Total current (mA): ",1000 Itotal];*)
(*Print["Resistance (Ohms): ",Resistance];*)
(*Print["Geometry Factor (mm\:207b\.b9): ",GeometryFactor];*)
(**)


(* ============================================ *)
(* Publication-quality potential field plot     *)
(* outward-facing ticks                         *)
(* full axis from 0 to max radius               *)
(* data only shown from r = a to R              *)
(* ============================================ *)

makeOutsideTicks[min_, max_, n_: 5] :=
  Table[
    {
      x,
      NumberForm[x, {5, 2}],
      {0, 0.02}
    },
    {x, Subdivide[min, max, n]}
  ];

makePotentialPanel[Rmax_, displayRmax_, panelLabel_] :=

 Module[
  {region, mesh, pde, bc, sol, zTop1, zTop2},

  region = ImplicitRegion[
    a <= r <= Rmax && 0 <= z <= H,
    {r, z}
  ];

  mesh = ToElementMesh[
    region,
    "MaxCellMeasure" -> 0.0001,
    "MeshOrder" -> 2
  ];

  pde =
    (1/r) D[r D[\[CurlyPhi][r, z], r], r] +
      D[\[CurlyPhi][r, z], {z, 2}] == 0;

  zTop1 = H - L1 - 1;
  zTop2 = L2+1;

  bc = {
    DirichletCondition[
      \[CurlyPhi][r, z] == V1,
      zTop1 <= z <= H - 1 && r == a
    ],

    DirichletCondition[
      \[CurlyPhi][r, z] == V2,
      1 <= z <= zTop2 && r == a
    ]
  };

  sol = NDSolveValue[
    {pde, bc},
    \[CurlyPhi],
    Element[{r, z}, mesh]
  ];

  DensityPlot[
    sol[r, z],
    {r, a, Rmax},
    {z, 0, H},

    PlotPoints -> 80,
    MaxRecursion -> 2,

    ColorFunction -> "ThermometerColors",
    ColorFunctionScaling -> False,

    PlotRange -> {
      {0, displayRmax},
      {0, H},
      {V2, V1}
    },

    PlotRangePadding -> None,

    Frame -> True,
    Axes -> False,

    FrameTicks -> {
      {makeOutsideTicks[0, H, H], None},
      {makeOutsideTicks[0, displayRmax], None}
    },

    FrameTicksStyle -> Directive[
      FontFamily -> "Helvetica",
      FontSize -> 13,
      Black
    ],

    FrameLabel -> {
      Style["r (mm)", 16, Bold],
      Style["z (mm)", 16, Bold]
    },

    LabelStyle -> Directive[
      FontFamily -> "Helvetica",
      FontSize -> 14,
      Black
    ],

    AspectRatio -> 1,
    Background -> White,
    BaseStyle -> {FontFamily -> "Helvetica"},

    ImagePadding -> {{65, 15}, {55, 20}},

    ImageSize -> 430,

    PlotLabel -> Style[
      panelLabel,
      18,
      Bold,
      Black
    ]
  ]
];

shotGlassPanel =
  makePotentialPanel[
    15,
    15,
    "Shot glass, R = 15 mm"
  ];

veinPanel =
  makePotentialPanel[
    1,
    15,
    "Vein, R = 1 mm"
  ];

legend =
  Framed[
    BarLegend[
      {"ThermometerColors", {V2, V1}},

      LegendLabel ->
        Style[
          "Potential, \[Phi] (V)",
          14
        ],

      LabelStyle ->
        Directive[
          FontFamily -> "Helvetica",
          FontSize -> 13,
          Black
        ]
    ],

    Background -> White,
    FrameStyle -> White,
    FrameMargins -> 5
  ];

twoPanelFigure =
  Legended[
    GraphicsRow[
      {
        shotGlassPanel,
        veinPanel
      },

      Spacings -> 0.25,
      Background -> White,
      ImageSize -> 900
    ],

    Placed[
      legend,
      Right
    ]
  ];

twoPanelFigure



Export[
 "potential_field_two_panel.png",
 twoPanelFigure,
 ImageResolution -> 600
]
