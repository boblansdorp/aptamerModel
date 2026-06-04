(* ::Package:: *)

(* ::Input:: *)
(*ClearAll["Global`*"]*)


(* ::Input:: *)
(*CHISignalBaselineSubtractedExpr=-4 CDL E^(-(5/(2 CDL fSWV Rsol))) (-1+E^(1/(4 CDL fSWV Rsol))+2 E^(1/(2 CDL fSWV Rsol))-2 E^(3/(4 CDL fSWV Rsol))-2 E^(1/(CDL fSWV Rsol))+2 E^(5/(4 CDL fSWV Rsol))+2 E^(3/(2 CDL fSWV Rsol))-2 E^(7/(4 CDL fSWV Rsol))-2 E^(2/(CDL fSWV Rsol))+2 E^(9/(4 CDL fSWV Rsol))) fSWV V0-4 CDL E^(-(3/(CDL fSWV Rsol))) (1-E^(1/(4 CDL fSWV Rsol))-2 E^(1/(2 CDL fSWV Rsol))+2 E^(3/(4 CDL fSWV Rsol))+2 E^(1/(CDL fSWV Rsol))-2 E^(5/(4 CDL fSWV Rsol))-2 E^(3/(2 CDL fSWV Rsol))+2 E^(7/(4 CDL fSWV Rsol))+2 E^(2/(CDL fSWV Rsol))-2 E^(9/(4 CDL fSWV Rsol))-2 E^(5/(2 CDL fSWV Rsol))+2 E^(11/(4 CDL fSWV Rsol))) fSWV V0+(2 E^(-((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(2 Capt CDL fSWV Rct Rsol))) fSWV (CDL^2 (-1+E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))+E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))+3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))-3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))-4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))+4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))-4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))-3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))+4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))+4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))) Rsol+Capt CDL (Rct-E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct-E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rct-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct+4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct-4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct+4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct+4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct-4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rct-3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct+3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct-4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct+E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-2 Rsol+2 E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol+2 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol+6 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol-6 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol+8 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol-8 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rsol+6 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol-6 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol+8 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-8 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-2 E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol)+Capt^2 (-Rct+E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct+E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct+3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct-3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rct+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct-4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct+4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct-4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rct-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rct+4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rct+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct-3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rct+4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct+4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rct-Rsol+E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol+E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol+3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol-3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol+4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol)) Rsol-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol)) Rsol+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol-3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol+4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol-E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol)) Rsol)+Capt (1+E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))-3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))+4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))+4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))) Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]+CDL (1+E^((3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-3 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((7 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-4 E^((9 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((11 (CDL Rsol+Capt (Rct+Rsol)+Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+2 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(Capt CDL fSWV Rct Rsol))-4 E^((3 (CDL Rsol+Capt (Rct+Rsol)+3 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(4 Capt CDL fSWV Rct Rsol))+4 E^((CDL Rsol+Capt (Rct+Rsol)+5 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(2 Capt CDL fSWV Rct Rsol))+3 E^((3 (CDL Rsol+Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]))/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+7 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))-3 E^((CDL Rsol+Capt (Rct+Rsol)+11 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(4 Capt CDL fSWV Rct Rsol))+4 E^((11 CDL Rsol+11 Capt (Rct+Rsol)+13 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((9 CDL Rsol+9 Capt (Rct+Rsol)+15 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))+4 E^((7 CDL Rsol+7 Capt (Rct+Rsol)+17 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-4 E^((5 CDL Rsol+5 Capt (Rct+Rsol)+19 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))-E^((CDL Rsol+Capt (Rct+Rsol)+23 Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2])/(8 Capt CDL fSWV Rct Rsol))) Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]) V0)/(Sqrt[CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]);*)


(* ::Input:: *)
(*(* define parameters for simulating around *)*)
(*bestFitParameters = <|*)
(*  "CDL" -> 71/200000000,*)
(*  "Rsol" -> 294,*)
(*  "Rct0" -> 17021.386901767124`,*)
(*  "Rct1" -> 6573.064966390861`,*)
(*  "kD" -> 0.017733158127065773`,*)
(*  "Capt" -> 2.2012032765291434`*^-7,*)
(*  "V0" -> 0.025*)
(*|>;*)
(*(* pars=<|"RctU"->62500,"RctB"->6250,"KD"->17/10000,(*1.7*10^-3,but exact*)"C0"->0,"CDL"->5*10^-7,"Capt"->4*10^-7,"V0"->25/1000,(*0.025,but exact*)"fL"->20,"fH"->200,"RsolRef"->200|>; *)*)
(*pars=<|"RctU"->bestFitParameters["Rct0"],"RctB"->bestFitParameters["Rct1"],"KD"->bestFitParameters["kD"],(*1.7*10^-3,but exact*)"C0"->0,"CDL"->bestFitParameters["CDL"],"Capt"->bestFitParameters["Capt"],"V0"->25/1000,(*0.025,but exact*)"fL"->20,"fH"->200,"RsolRef"->200|>;  *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(*Build one high-precision copy once (so we do not redo SetPrecision every sample)*)*)
(*CHISignalBaselineSubtractedExprHP=SetPrecision[CHISignalBaselineSubtractedExpr,200];*)
(**)
(*(*Make a numeric function of Rsol with parameters baked in*)*)
(*ClearAll[CHISignalBaselineSubtractedExprSafe];*)
(**)
(*CHISignalBaselineSubtractedExprSafe[rules_List,wp_:80]:=Module[{rrules},rrules=rules/. x_Real:>SetPrecision[x,wp];*)
(*Function[{rsol},If[!NumericQ[rsol],Return[Indeterminate]];*)
(*Quiet[Check[Block[{$MaxExtraPrecision=10 wp},N[Re[CHISignalBaselineSubtractedExprHP/. rrules/. Rsol->SetPrecision[rsol,wp]],wp]],Indeterminate],{General::munfl,Power::infy,Infinity::indet,Plot::precw}]]];*)
(*chi20=CHISignalBaselineSubtractedExprSafe[{Rct->10000,CDL->5*10^-7,Capt->4*10^-7,fSWV->20,V0->25/1000}];*)
(**)
(*chi200=CHISignalBaselineSubtractedExprSafe[{Rct->10000,CDL->5*10^-7,Capt->4*10^-7,fSWV->200,V0->25/1000}];*)
(**)
(*Plot[{chi20[Rsol],chi200[Rsol]},{Rsol,1,5000},WorkingPrecision->80,Method->{"GlobalAdaptive","SymbolicProcessing"->0},PlotRange->All]*)
(**)


(* ::Input:: *)
(*(*Langmuir occupancy*)*)
(*theta[C_,KD_]:=C/(C+KD);*)
(**)
(*(*Mix rates (conductances):1/Rct=(1-\[Theta])/RctU+\[Theta]/RctB*)*)
(*RctEff[C_,KD_,RctU_,RctB_]:=1/((1-theta[C,KD])/RctU+theta[C,KD]/RctB); *)
(**)
(**)


(* ::Input:: *)
(*(* ============================================================*)(*1) Short name for the "safe" current evaluator:iDiff[rules][Rsol]*)(* ============================================================*)CHIexprHP=SetPrecision[CHISignalBaselineSubtractedExpr,200];*)
(**)
(*(*iDiff now expects Rsol->... inside the rules list and returns a number*)*)
(*ClearAll[iDiff];*)
(*iDiff[rules_List]:=CHISignalBaselineSubtractedExprSafe[DeleteCases[rules,Rsol->_]][Rsol/. rules];*)
(*(*NOTE:use Rsol (lowercase s),not RSol*)*)
(**)
(*ClearAll[kdm];*)
(*kdm[calparams_Association,expParams_Association,eps_:10^-70]:=Module[{Rct0,RctC,iH0,iL0,iH,iL,A,B,den},*)
(*Rct0=RctEff[calparams["C0"],calparams["KD"],calparams["RctU"],calparams["RctB"]];*)
(*RctC=RctEff[expParams["C"],expParams["KD"],expParams["RctU"],expParams["RctB"]];*)
(*(*calibration currents at (C0,RsolRef)*)*)
(*iH0=iDiff[{Rct->Rct0,CDL->calparams["CDL"],Capt->calparams["Capt"],fSWV->calparams["fH"],V0->calparams["V0"],Rsol->calparams["RsolRef"]}];*)
(*iL0=iDiff[{Rct->Rct0,CDL->calparams["CDL"],Capt->calparams["Capt"],fSWV->calparams["fL"],V0->calparams["V0"],Rsol->calparams["RsolRef"]}];*)
(*If[Chop[iH0,eps]==0||Chop[iL0,eps]==0,Return[Indeterminate]];*)
(*(*measurement currents at (C,Rsol)*)*)
(*iH=iDiff[{Rct->RctC,CDL->expParams["CDL"],Capt->expParams["Capt"],fSWV->expParams["fH"],V0->expParams["V0"],Rsol->expParams["Rsol"]}];*)
(*iL=iDiff[{Rct->RctC,CDL->expParams["CDL"],Capt->expParams["Capt"],fSWV->expParams["fL"],V0->expParams["V0"],Rsol->expParams["Rsol"]}];*)
(*A=iH/iH0;*)
(*B=iL/iL0;*)
(*den=(A+B)/2;*)
(*If[Chop[den,eps]==0,Return[Indeterminate]];*)
(*(A-B)/den];*)
(**)
(**)
(*calparams=pars;*)
(*(* *)
(*LogPlot[{kdm[calparams,Join[pars,<|"C"->0,"Rsol"->RsolToPlot|>]], kdm[calparams,Join[pars,<|"C"->(pars["KD"]/1000),"Rsol"->RsolToPlot|>]], kdm[calparams,Join[pars,<|"C"->(pars["KD"]/100),"Rsol"->RsolToPlot|>]],kdm[calparams,Join[pars,<|"C"->(pars["KD"]/10),"Rsol"->RsolToPlot|>]],kdm[calparams,Join[pars,<|"C"->pars["KD"]/1,"Rsol"->RsolToPlot|>]]},{RsolToPlot,1,5000}] *)*)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(*----------Choose the calibration resistance for the KDM(C) calibration curve----------*)*)
(*Rcal=1000;   (*example:100 ohms calibration*)*)
(**)
(*calparamsCal=Join[pars,<|"RsolRef"->Rcal|>];*)
(**)
(*(*----------10 log-spaced concentrations for the "experiment"----------*)*)
(*concList=N[10^Subdivide[-8,-2,41]]*)
(**)
(*(*----------Compute calibration KDM(C) under calibration conditions (Rsol=Rcal)----------*)*)
(*calData=Table[{c,kdm[calparamsCal,Join[pars,<|"C"->c,"Rsol"->Rcal|>]]},{c,concList}];*)
(**)
(*(*drop any Indeterminate points,if they occur*)*)
(*calDataClean=Select[calData,NumericQ[#[[2]]]&];*)
(**)
(*(*----------Fit to Langmuir:KDM(C)=Bmax*C/(C+KDexp)----------*)*)
(*fit=NonlinearModelFit[calDataClean,Bmax*c/(c+KDexp),{{Bmax,Max[calDataClean[[All,2]]]},{KDexp,pars["KD"]}},c,Method->"NMinimize"];*)
(**)
(*BmaxExp=Bmax/. fit["BestFitParameters"];*)
(*KDExp=KDexp/. fit["BestFitParameters"];*)
(**)
(*Print["BmaxExp = ",BmaxExp];*)
(*Print["KDExp   = ",KDExp];*)
(**)
(*(*----------Invert Langmuir to estimate concentration from a measured KDM----------*)*)
(*cEstFromKDM[k_]:=Module[{kk=k},If[!NumericQ[kk],Return[Indeterminate]];*)
(*kk=Clip[kk,{0,1*BmaxExp}];*)
(*KDExp*kk/(BmaxExp-kk)];*)
(**)
(*(*----------Build datasets:actual concentration vs estimated concentration----------*)*)
(*estData[Rmeas_]:=Table[{c,cEstFromKDM@kdm[calparamsCal,Join[pars,<|"C"->c,"Rsol"->Rmeas|>]]},{c,concList}];*)
(**)
(*d100=estData[100];*)
(*d500=estData[500];*)
(*d1000=estData[1000];*)
(**)
(*(*----------Plot actual vs estimated (log-log) with y=x reference line----------*)*)
(*Show[ListLogLogPlot[{d100,d500,d1000},PlotRange->All,AxesLabel->{Style["Actual concentration",14],Style["Estimated concentration",14]},PlotLegends->Placed[LineLegend[{"Rsol = 100 \[CapitalOmega]","Rsol = 500 \[CapitalOmega]","Rsol = 1000 \[CapitalOmega]"}],{0.8,0.2}],PlotLabel->Style["Actual vs estimated concentration (calibration at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega])",14],ImageSize->450],LogLogPlot[x,{x,10^-8,10^-2},PlotStyle->Dashed]]*)
(*cMin=Min[calDataClean[[All,1]]];*)
(*cMax=Max[calDataClean[[All,1]]];*)
(*(*----------Plot calibration data+best-fit Langmuir isotherm----------*)*)
(*Show[ListLogLinearPlot[calDataClean,PlotRange->All,PlotMarkers->Automatic,AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLinearPlot[fit[c],{c,cMin,cMax},PlotRange->All]]*)
(*Show[ListLogLogPlot[calDataClean,PlotRange->All,PlotMarkers->Automatic,AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLogPlot[fit[c],{c,cMin,cMax},PlotRange->All]]*)
(**)


(* ::Input:: *)
(*rsolList={500,950,995,1000,1005,1050,1500};*)
(**)
(*colors=ColorData["Rainbow"]/@Rescale[Range[Length[rsolList]]];*)
(*(* *)
(*Show[ListLogLogPlot[estData/@rsolList,Joined->True,PlotRange->All,PlotStyle->colors,AxesLabel->{Style["Actual concentration",14],Style["Estimated concentration",14]},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["Actual vs estimated concentration (calibration and single-point normalization at "<>ToString[Rcal]<>" \[CapitalOmega]) and drift to Rsol",14],ImageSize->450],LogLogPlot[x,{x,10^-6,10^-2},PlotStyle->Dashed]] *)*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(* Now repeat with Hill coefficients! *)*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(*----------Choose the calibration resistance for the KDM(C) calibration curve----------*)*)
(*Rcal=200;   (*example:100 ohms calibration*)*)
(*Rcal=1000;   (*example:100 ohms calibration*)*)
(**)
(*calparamsCal=Join[pars,<|"RsolRef"->Rcal|>];*)
(**)
(*(*----------Compute calibration KDM(C) under calibration conditions (Rsol=Rcal)----------*)*)
(*calData=Table[{c,kdm[calparamsCal,Join[pars,<|"C"->c,"Rsol"->Rcal|>]]},{c,concList}];*)
(**)
(*(*drop any Indeterminate points,if they occur*)*)
(*calDataClean=Select[calData,NumericQ[#[[2]]]&];*)
(**)
(*(*----------Fit to Hill:KDM(C)=KDMmax*C^nH/(C^nH+KDexp^nH)----------*)(*Reparameterize to enforce positivity without ParameterConstraints:KDMmax=Exp[a],KDexp=Exp[d],nH=Exp[b]*)fit=NonlinearModelFit[calDataClean,(Exp[a]*c^Exp[b])/(c^Exp[b]+Exp[d]^Exp[b]),{{a,Log[Max[calDataClean[[All,2]]]]},(*log KDMmax initial guess*){d,Log[pars["KD"]]},(*log KD initial guess*){b,Log[1.0]}                            (*log nH initial guess,nH=1*)},c,Method->"NMinimize"];*)
(**)
(*BmaxExp=Exp[a/. fit["BestFitParameters"]];*)
(*KDExp=Exp[d/. fit["BestFitParameters"]];*)
(*nHExp=Exp[b/. fit["BestFitParameters"]];*)
(**)
(*Print["BmaxExp = ",BmaxExp];*)
(*Print["KDExp   = ",KDExp];*)
(*Print["nHExp   = ",nHExp];*)
(**)
(*(*----------Invert Hill to estimate concentration from a measured KDM----------*)*)
(*Clear[cEstFromKDM]*)
(*cEstFromKDM[k_]:=Module[{kk=k},If[!NumericQ[kk],Return[Indeterminate]];*)
(*kk=Clip[kk,{0,(1-10^-12)*BmaxExp}];*)
(*KDExp*(kk/(BmaxExp-kk))^(1/nHExp)];*)
(**)
(**)
(**)
(*(*----------Build datasets:actual concentration vs estimated concentration----------*)*)
(*estData[Rmeas_]:=Table[{c,cEstFromKDM@kdm[calparamsCal,Join[pars,<|"C"->c,"Rsol"->Rmeas|>]]},{c,concList}];*)
(**)
(*d800=estData[800];*)
(*d1000=estData[1000];*)
(*d1200=estData[1200];*)
(**)
(*(*----------Plot actual vs estimated (log-log) with y=x reference line----------*)*)
(*Show[ListLogLogPlot[{d800,d1000,d1200},PlotRange->All,AxesLabel->{Style["Actual concentration",14],Style["Estimated concentration",14]},PlotLegends->Placed[LineLegend[{"Rsol = 100 \[CapitalOmega]","Rsol = 500 \[CapitalOmega]","Rsol = 1000 \[CapitalOmega]"}],{0.8,0.2}],PlotLabel->Style["Actual vs estimated concentration (calibration at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega])",14],ImageSize->450],LogLogPlot[x,{x,10^-8,10^-2},PlotStyle->Dashed]]*)
(*cMin=Min[calDataClean[[All,1]]];*)
(*cMax=Max[calDataClean[[All,1]]];*)
(*(*----------Plot calibration data+best-fit Langmuir isotherm----------*)*)
(*Show[ListLogLinearPlot[calDataClean,PlotRange->All,PlotMarkers->Automatic,AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLinearPlot[fit[c],{c,cMin,cMax},PlotRange->All]]*)
(*Show[ListLogLogPlot[calDataClean,PlotRange->All,PlotMarkers->Automatic,AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLogPlot[fit[c],{c,cMin,cMax},PlotRange->All]]*)


(* ::Input:: *)
(*rsolList={500,950,995,1000,1005,1050,1500, 5000};*)
(**)
(*colors=ColorData["Rainbow"]/@Rescale[Range[Length[rsolList]]];*)
(*(* *)
(*Show[ListLogLogPlot[estData/@rsolList,Joined->True,PlotStyle->colors,AxesLabel->{Style["Actual concentration [M]",14],Style["Estimated concentration [M]",14]},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["Actual vs estimated concentration (calibration and single-point normalization at "<>ToString[Rcal]<>" \[CapitalOmega]) and drift to Rsol",14],ImageSize->450, PlotRange->{{10^-6,10^-2},{10^-6,10^-2}}],LogLogPlot[x,{x,10^-6,10^-2},PlotStyle->Dashed], ImageSize->800] *)*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(* rsolList={1000}; *)*)


(* ::Input:: *)
(*driftFigure = Show[ListLogLogPlot[estData/@rsolList,Joined->True,PlotStyle->colors,Frame->True,FrameTicks->{{{{10^-5,Superscript[10,-5]},{10^-4,Superscript[10,-4]},{10^-3,Superscript[10,-3]},{10^-2,Superscript[10,-2]}},None},{{{10^-5,Superscript[10,-5]},{10^-4,Superscript[10,-4]},{10^-3,Superscript[10,-3]},{10^-2,Superscript[10,-2]}},None}},Axes->False,FrameLabel->{{Rotate[Style["Estimated concentration [M]",14],0],None},{Style["Actual concentration [M]",14],None}},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["Solution resistance drift from "<>ToString[Rcal]<>" \[CapitalOmega] to Rsol",14],PlotRange->{{10^-5,10^-2},{10^-5,10^-2}}],LogLogPlot[x,{x,10^-5,10^-2},PlotStyle->Dashed,Frame->True,Axes->False,PlotRange->{{10^-5,10^-2},{10^-5,10^-2}}],AspectRatio->1,ImageSize->400]*)


(* ::Input:: *)
(*Export["driftFigure.png",Show[driftFigure,ImageSize->400],ImageResolution->600]*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*driftFigureLinear = Show[ListPlot[estData/@rsolList,Joined->True,PlotStyle->colors,Frame->True,Axes->False,FrameLabel->{{Rotate[Style["Estimated concentration [M]",14],0],None},{Style["Actual concentration [M]",14],None}},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["Solution resistance drift from "<>ToString[Rcal]<>" \[CapitalOmega] to Rsol",14],PlotRange->{{0,10^-3},{0,10^-3}}], Plot[x,{x,0,10^-3},PlotStyle->Dashed,Frame->True,Axes->False,PlotRange->{{0,10^-3},{0,10^-3}}],AspectRatio->1,ImageSize->400]*)


(* ::Input:: *)
(*driftFigureLinearCompressed = Show[ListPlot[estData/@rsolList,Joined->True,PlotStyle->colors,Frame->True,Axes->False,FrameLabel->{{Rotate[Style["Estimated concentration [M]",14],0],None},{Style["Actual concentration [M]",14],None}},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["Solution resistance drift from "<>ToString[Rcal]<>" \[CapitalOmega] to Rsol",14],PlotRange->{{10^-6,10^-3},{10^-6,10^-3}}], Plot[x,{x,10^-6,10^-3},PlotStyle->Dashed,Frame->True,Axes->False,PlotRange->{{0,10^-3},{0,10^-3}}],AspectRatio->1,ImageSize->400]*)


scale = 1000; (* M -> mM *)
(* 
driftFigureLinearCompressed =
 Show[
  ListPlot[
   (scale*# & /@ estData[#]) & /@ rsolList,
   Joined -> True,
   PlotStyle -> colors,
   Frame -> True,
   Axes -> False,
   FrameLabel -> {{
      Style["Estimated concentration [mM]", 14], None},
     {Style["Actual concentration [mM]", 14], None}},
   PlotLegends ->
    Placed[
     LineLegend[
      colors,
      ("Rsol = " <> ToString[#] <> " \[CapitalOmega]") & /@ rsolList
     ],
     {0.8, 0.2}
    ],
   PlotLabel ->
    Style[
     "Methotrexate sensor accuracy as a function of solution resistance drift from " <> ToString[Rcal] <>
      " \[CapitalOmega] to Rsol",
     14
    ],
   PlotRange -> {{10^-3, 1}, {10^-3, 1}}
   ],

  Plot[
   x,
   {x, 10^-3, 1},
   PlotStyle -> Dashed,
   Frame -> True,
   Axes -> False,
   PlotRange -> {{0, 1}, {0, 1}}
   ],

  AspectRatio -> 1,
  ImageSize -> 400
 ] *)


(* Export["driftFigureLinearCompressed.png",Show[driftFigureLinearCompressed,ImageSize->400],ImageResolution->600] *)


(* ::Input:: *)
(*scale=10^6;*)
(**)
(*driftFigureLinearCompressed=Show[ListPlot[(scale #&)/@(estData/@rsolList),Joined->True,PlotStyle->colors,Frame->True,Axes->False,FrameLabel->{{Rotate[Style["Estimated concentration [\[Micro]M]",14],0],None},{Style["Actual concentration [\[Micro]M]",14],None}},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["Solution resistance drift from "<>ToString[Rcal]<>" \[CapitalOmega] to Rsol",14],PlotRange->{{1,1000},{1,1000}}],Plot[x,{x,1,1000},PlotStyle->Dashed,Frame->True,Axes->False,PlotRange->{{0,1000},{0,1000}}],AspectRatio->1,ImageSize->400]*)


(* ::Input:: *)
(*Export["driftFigureCompressed.png",Show[driftFigureLinearCompressed,ImageSize->400],ImageResolution->600]*)


(* ::Input:: *)
(*(* now using a 200 ohm calibration parameters, renormalize data at a few different resistances *)*)


(* ::Input:: *)
(*(*----------Choose the calibration resistance for the KDM(C) calibration curve----------*)*)
(*Rcal=200;   (*example:100 ohms calibration*)*)
(**)
(*calparamsCal=Join[pars,<|"RsolRef"->Rcal|>];(* this sets the normalization conditions *)*)
(**)
(*(*----------Compute calibration KDM(C) under calibration conditions (Rsol=Rcal)----------*)*)
(*calData=Table[{c,kdm[calparamsCal,Join[pars,<|"C"->c,"Rsol"->Rcal|>]]},{c,concList}];*)
(**)
(*(*drop any Indeterminate points,if they occur*)*)
(*calDataClean=Select[calData,NumericQ[#[[2]]]&];*)
(**)
(*(*----------Fit to Hill:KDM(C)=KDMmax*C^nH/(C^nH+KDexp^nH)----------*)(*Reparameterize to enforce positivity without ParameterConstraints:KDMmax=Exp[a],KDexp=Exp[d],nH=Exp[b]*)fit=NonlinearModelFit[calDataClean,(Exp[a]*c^Exp[b])/(c^Exp[b]+Exp[d]^Exp[b]),{{a,Log[Max[calDataClean[[All,2]]]]},(*log KDMmax initial guess*){d,Log[pars["KD"]]},(*log KD initial guess*){b,Log[1.0]}                            (*log nH initial guess,nH=1*)},c,Method->"NMinimize"];*)
(**)
(*BmaxExp=Exp[a/. fit["BestFitParameters"]];*)
(*KDExp=Exp[d/. fit["BestFitParameters"]];*)
(*nHExp=Exp[b/. fit["BestFitParameters"]];*)
(**)
(*Print["BmaxExp = ",BmaxExp];*)
(*Print["KDExp   = ",KDExp];*)
(*Print["nHExp   = ",nHExp];*)
(**)
(*(*----------Invert Hill to estimate concentration from a measured KDM----------*)*)
(*Clear[cEstFromKDM]*)
(*cEstFromKDM[k_]:=Module[{kk=k},If[!NumericQ[kk],Return[Indeterminate]];*)
(*kk=Clip[kk,{0,(1-10^-12)*BmaxExp}];*)
(*KDExp*(kk/(BmaxExp-kk))^(1/nHExp)];*)
(**)
(**)
(*normalizationParams[Rmeas_] :=Join[pars,<|"RsolRef"->Rmeas|>];(* this sets the normalization conditions *)*)
(**)
(*(*----------Build datasets:actual concentration vs estimated concentration----------*)*)
(*estData[Rmeas_]:=Table[{c,cEstFromKDM@kdm[normalizationParams[Rmeas],Join[pars,<|"C"->c,"Rsol"->Rmeas|>]]},{c,concList}];*)
(**)
(*cMin=Min[calDataClean[[All,1]]];*)
(*cMax=Max[calDataClean[[All,1]]];*)
(*(*----------Plot calibration data+best-fit Langmuir isotherm----------*)*)
(*Show[ListLogLinearPlot[calDataClean,PlotRange->All,PlotMarkers->Automatic,AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLinearPlot[fit[c],{c,cMin,cMax},PlotRange->All]]*)
(*Show[ListLogLogPlot[calDataClean,PlotRange->All,PlotMarkers->Automatic,AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLogPlot[fit[c],{c,cMin,cMax},PlotRange->All]]*)
(**)
(*rsolList={200,500,1000,1500,2000,2500};*)
(**)
(*colors=ColorData["Rainbow"]/@Rescale[Range[Length[rsolList]]];*)
(**)
(*Show[ListLogLogPlot[estData/@rsolList,Joined->True,PlotRange->All,PlotStyle->colors,AxesLabel->{Style["Actual concentration [M]",14],Style["Estimated concentration [M]",14]},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["Calibrated at "<>ToString[Rcal]<> " \[CapitalOmega], single-point normalized and measured at Rsol (no solution resistance drift)",14],ImageSize->450],LogLogPlot[x,{x,10^-6,10^-2},PlotStyle->Dashed]]*)
(**)
(*stepChangeLowR =Show[ListLogLogPlot[estData/@rsolList,Joined->True,PlotStyle->colors,Frame->True,Axes->False,FrameLabel->{{Rotate[Style["Estimated concentration [M]",14],0],None},{Style["Actual concentration [M]",14],None}},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["Calibrated at "<>ToString[Rcal]<>" \[CapitalOmega], normalized and measured at Rsol",14],PlotRange->{{10^-6,10^-2},{10^-6,10^-2}}],LogLogPlot[x,{x,10^-6,10^-2},PlotStyle->Dashed,Frame->True,Axes->False,PlotRange->{{10^-6,10^-2},{10^-6,10^-2}}],AspectRatio->1,ImageSize->400]*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*stepChangeLowRLinear =Show[ListPlot[estData/@rsolList,Joined->True,PlotStyle->colors,Frame->True,Axes->False,FrameLabel->{{Rotate[Style["Estimated concentration [M]",14],0],None},{Style["Actual concentration [M]",14],None}},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["Calibrated at "<>ToString[Rcal]<>" \[CapitalOmega], normalized and measured at Rsol",14],PlotRange->{{10^-6,10^-2},{10^-6,10^-2}}],Plot[x,{x,0,10^-2},PlotStyle->Dashed,Frame->True,Axes->False,PlotRange->{{0,10^-2},{0,10^-2}}],AspectRatio->1,ImageSize->400]*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*GraphicsRow[{stepChangeLowR,stepChangeLowRLinear}]*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(*----------Choose the calibration resistance for the KDM(C) calibration curve----------*)*)
(*Rcal=1000;   (*example:100 ohms calibration*)*)
(**)
(*calparamsCal=Join[pars,<|"RsolRef"->Rcal|>];(* this sets the normalization conditions *)*)
(**)
(*(*----------Compute calibration KDM(C) under calibration conditions (Rsol=Rcal)----------*)*)
(*calData=Table[{c,kdm[calparamsCal,Join[pars,<|"C"->c,"Rsol"->Rcal|>]]},{c,concList}];*)
(**)
(*(*drop any Indeterminate points,if they occur*)*)
(*calDataClean=Select[calData,NumericQ[#[[2]]]&];*)
(**)
(*(*----------Fit to Hill:KDM(C)=KDMmax*C^nH/(C^nH+KDexp^nH)----------*)(*Reparameterize to enforce positivity without ParameterConstraints:KDMmax=Exp[a],KDexp=Exp[d],nH=Exp[b]*)fit=NonlinearModelFit[calDataClean,(Exp[a]*c^Exp[b])/(c^Exp[b]+Exp[d]^Exp[b]),{{a,Log[Max[calDataClean[[All,2]]]]},(*log KDMmax initial guess*){d,Log[pars["KD"]]},(*log KD initial guess*){b,Log[1.0]}                            (*log nH initial guess,nH=1*)},c,Method->"NMinimize"];*)
(**)
(*BmaxExp=Exp[a/. fit["BestFitParameters"]];*)
(*KDExp=Exp[d/. fit["BestFitParameters"]];*)
(*nHExp=Exp[b/. fit["BestFitParameters"]];*)
(**)
(*Print["BmaxExp = ",BmaxExp];*)
(*Print["KDExp   = ",KDExp];*)
(*Print["nHExp   = ",nHExp];*)
(**)
(*(*----------Invert Hill to estimate concentration from a measured KDM----------*)*)
(*Clear[cEstFromKDM]*)
(*cEstFromKDM[k_]:=Module[{kk=k},If[!NumericQ[kk],Return[Indeterminate]];*)
(*kk=Clip[kk,{0,(1-10^-12)*BmaxExp}];*)
(*KDExp*(kk/(BmaxExp-kk))^(1/nHExp)];*)
(**)
(**)
(*normalizationParams[Rmeas_] :=Join[pars,<|"RsolRef"->Rmeas|>];(* this sets the normalization conditions *)*)
(**)
(*(*----------Build datasets:actual concentration vs estimated concentration----------*)*)
(*estData[Rmeas_]:=Table[{c,cEstFromKDM@kdm[normalizationParams[Rmeas],Join[pars,<|"C"->c,"Rsol"->Rmeas|>]]},{c,concList}];*)
(**)
(*cMin=Min[calDataClean[[All,1]]];*)
(*cMax=Max[calDataClean[[All,1]]];*)
(*(*----------Plot calibration data+best-fit Langmuir isotherm----------*)*)
(*Show[ListLogLinearPlot[calDataClean,PlotRange->All,PlotMarkers->Automatic,AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLinearPlot[fit[c],{c,cMin,cMax},PlotRange->All]]*)
(*Show[ListLogLogPlot[calDataClean,PlotRange->All,PlotMarkers->Automatic,AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLogPlot[fit[c],{c,cMin,cMax},PlotRange->All]]*)
(**)
(*rsolList={200,500,1000,1500,2000,2500};*)
(**)
(*colors=ColorData["Rainbow"]/@Rescale[Range[Length[rsolList]]];*)
(**)
(*Show[ListLogLogPlot[estData/@rsolList,Joined->True,PlotRange->All,PlotStyle->colors,AxesLabel->{Style["Actual concentration [M]",14],Style["Estimated concentration [M]",14]},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["Calibrated at "<>ToString[Rcal]<> " \[CapitalOmega], single-point normalized and measured at Rsol (no solution resistance drift)",14],ImageSize->450],LogLogPlot[x,{x,10^-6,10^-2},PlotStyle->Dashed]]*)
(**)


(* ::Input:: *)
(*stepChange =Show[ListLogLogPlot[estData/@rsolList,Joined->True,PlotStyle->colors,Frame->True,Axes->False,FrameLabel->{{Rotate[Style["Estimated concentration [M]",14],0],None},{Style["Actual concentration [M]",14],None}},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["Calibrated at "<>ToString[Rcal]<>" \[CapitalOmega], normalized and measured at Rsol",14],PlotRange->{{10^-6,10^-2},{10^-6,10^-2}}],LogLogPlot[x,{x,10^-6,10^-2},PlotStyle->Dashed,Frame->True,Axes->False,PlotRange->{{10^-6,10^-2},{10^-6,10^-2}}],AspectRatio->1,ImageSize->400]*)


(* ::Input:: *)
(*GraphicsRow[{stepChangeLowR,stepChange, driftFigure}]*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(* Langmuir vs Hill *)*)


(* ::Input:: *)
(*concList=N[10^Subdivide[-6,-2,31]]*)
(*(*----------Compute calibration KDM(C) under calibration conditions (Rsol=Rcal)----------*)*)
(*calData=Table[{c,kdm[calparamsCal,Join[pars,<|"C"->c,"Rsol"->Rcal|>]]},{c,concList}];*)
(**)
(*(*drop any Indeterminate points,if they occur*)*)
(*calDataClean=Select[calData,NumericQ[#[[2]]]&];*)
(**)
(**)
(*(*----------Fit to Langmuir:KDM(C)=Bmax*C/(C+KDexp)----------*)*)
(*fitLang=NonlinearModelFit[calDataClean,Exp[b]*c/(c+Exp[kd]),{{b,Log[Max[calDataClean[[All,2]]]]},{kd,Log[pars["KD"]]}},c,Method->"NMinimize"];*)
(**)
(*BmaxExp=Exp[b]/. fitLang["BestFitParameters"];*)
(*KDExp=Exp[kd]/. fitLang["BestFitParameters"];*)
(**)
(*Print["Langmuir: BmaxExp = ",BmaxExp];*)
(*Print["Langmuir: KDExp   = ",KDExp];*)
(**)
(*(*----------Fit to Hill:KDM(C)=Bmax*C^n/(C^n+KDexp^n)----------*)*)
(*fitHill=NonlinearModelFit[calDataClean,Exp[b]*c^Exp[nh]/(c^Exp[nh]+Exp[kd]^Exp[nh]),{{b,Log[Max[calDataClean[[All,2]]]]},{kd,Log[pars["KD"]]},{nh,Log[1.0]}},c,Method->"NMinimize"];*)
(**)
(**)
(*BmaxHill=Exp[b]/. fitHill["BestFitParameters"];*)
(*KDHill=Exp[kd]/. fitHill["BestFitParameters"];*)
(*nHill=Exp[nh]/. fitHill["BestFitParameters"];*)
(**)
(*Print["Hill: Bmax = ",BmaxHill];*)
(*Print["Hill: KD   = ",KDHill];*)
(*Print["Hill: n    = ",nHill];*)
(**)
(**)
(*(*---goodness-of-fit from residuals (works even if MSE property is missing)---*)rmseFromFit[fm_]:=Module[{res=fm["FitResiduals"]},Sqrt[Mean[res^2]]];*)
(**)
(*r2Lang=fitLang["RSquared"];*)
(*adjr2Lang=fitLang["AdjustedRSquared"];*)
(*rmseLang=rmseFromFit[fitLang];*)
(**)
(*r2Hill=fitHill["RSquared"];*)
(*adjr2Hill=fitHill["AdjustedRSquared"];*)
(*rmseHill=rmseFromFit[fitHill];*)
(**)
(*Print["Langmuir: R^2     = ",r2Lang];*)
(*Print["Langmuir: Adj R^2 = ",adjr2Lang];*)
(*Print["Langmuir: RMSE    = ",rmseLang];*)
(**)
(*Print["Hill: R^2     = ",r2Hill];*)
(*Print["Hill: Adj R^2 = ",adjr2Hill];*)
(*Print["Hill: RMSE    = ",rmseHill];*)
(**)
(**)
(**)
(**)
(*(*----------Overlay:experimental points+Langmuir fit+Hill fit----------*)*)
(*cMin=Min[calDataClean[[All,1]]];*)
(*cMax=Max[calDataClean[[All,1]]];*)
(**)
(*Show[ListLogLinearPlot[calDataClean,PlotRange->{{10^-5,10^-2},All},PlotMarkers->Automatic,PlotStyle->{GrayLevel[0]},AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLinearPlot[{fitLang[c],fitHill[c]},{c,cMin,cMax},PlotRange->All,PlotStyle->{Directive[Red,Thick],Directive[Blue,Thick]}],PlotLegends->Placed[LineLegend[{Directive[GrayLevel[0]],Directive[Red,Thick],Directive[Blue,Thick]},{"Data","Langmuir fit","Hill fit"}],{0.8,0.2}]];*)
(**)
(**)
(**)
(*Show[ListLogLogPlot[calDataClean,PlotRange->{{10^-5,10^-2},All},PlotMarkers->Automatic,PlotStyle->{GrayLevel[0]},AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLogPlot[{fitLang[c],fitHill[c]},{c,cMin,cMax},PlotRange->All,PlotStyle->{Directive[Red,Thick],Directive[Blue,Thick]}],PlotLegends->Placed[LineLegend[{Directive[GrayLevel[0]],Directive[Red,Thick],Directive[Blue,Thick]},{"Data","Langmuir fit","Hill fit"}],{0.8,0.2}]];*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*Legended[Show[ListLogLinearPlot[calDataClean,PlotRange->{{10^-3,2 10^-2},All},PlotMarkers->Automatic,PlotStyle->{GrayLevel[0]},AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLinearPlot[{fitLang[c],fitHill[c]},{c,cMin,cMax},PlotRange->All,PlotStyle->{Directive[Red,Thick],Directive[Blue,Thick]}]],Placed[LineLegend[{Directive[GrayLevel[0]],Directive[Red,Thick],Directive[Blue,Thick]},{"Simulated Data","Langmuir fit","Hill fit"}],{0.8,0.2}]]*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input::Plain:: *)
(*Legended[*)
(* Show[*)
(*  ListLogLogPlot[*)
(*   calDataClean,*)
(*   PlotRange -> {{10^-5, 10^-2}, All},*)
(*   PlotMarkers -> Automatic,*)
(*   PlotStyle -> {GrayLevel[0]},*)
(*   AxesLabel -> {Style["Concentration", 14], Style["KDM", 14]},*)
(*   PlotLabel ->*)
(*    Style["Calibration KDM(C) at RsolRef = " <> ToString[Rcal] <>*)
(*      " \[CapitalOmega]", 14],*)
(*   ImageSize -> 450*)
(*  ],*)
(*  LogLogPlot[*)
(*   {fitLang[c], fitHill[c]},*)
(*   {c, cMin, cMax},*)
(*   PlotRange -> All,*)
(*   PlotStyle -> {Directive[Red, Thick], Directive[Blue, Thick]}*)
(*  ]*)
(* ],*)
(* Placed[*)
(*  LineLegend[*)
(*   {Directive[GrayLevel[0]], Directive[Red, Thick], Directive[Blue, Thick]},*)
(*   {"Data", "Langmuir fit", "Hill fit"}*)
(*  ],*)
(*  {0.8, 0.2}*)
(* ]*)
(*]*)


(* ::Input:: *)
(*pars*)


(* ::Input:: *)
(*(* Ratiometric KDM (rKDM)*)*)
(**)
(*(*----------Choose the calibration resistance for the KDM(C) calibration curve----------*)*)
(*Rcal=200;   (*example:100 ohms calibration*)*)
(**)
(*calparamsCal=Join[\[AliasDelimiter],<|"RsolRef"->Rcal|>];(* this sets the normalization conditions *)*)
(**)
(*rKDM[calparams_Association,expParams_Association,eps_:10^-70]:=*)
(*Module[{Rct0,RctC,Ratio,iH,iL,A,B,den},*)
(*Rct0=RctEff[calparams["C0"],calparams["KD"],calparams["RctU"],calparams["RctB"]];*)
(*RctC=RctEff[expParams["C"],expParams["KD"],expParams["RctU"],expParams["RctB"]];*)
(*(*calibration currents at (C0,RsolRef)*)*)
(*Ratio = iDiff[{Rct->Rct0,CDL->calparams["CDL"],Capt->calparams["Capt"],fSWV->calparams["fH"],V0->calparams["V0"],Rsol->calparams["RsolRef"]}]/iDiff[{Rct->Rct0,CDL->calparams["CDL"],Capt->calparams["Capt"],fSWV->calparams["fL"],V0->calparams["V0"],Rsol->calparams["RsolRef"]}];*)
(**)
(*(*measurement currents at (C,Rsol)*)*)
(*iH=iDiff[{Rct->RctC,CDL->expParams["CDL"],Capt->expParams["Capt"],fSWV->expParams["fH"],V0->expParams["V0"],Rsol->expParams["Rsol"]}];*)
(*iL=iDiff[{Rct->RctC,CDL->expParams["CDL"],Capt->expParams["Capt"],fSWV->expParams["fL"],V0->expParams["V0"],Rsol->expParams["Rsol"]}];*)
(*A=iH;*)
(*B=iL  Ratio ;*)
(*den=(A+B)/2;*)
(*If[Chop[den,eps]==0,Return[Indeterminate]];*)
(*(A-B)/den];*)
(**)
(**)
(**)
(*(*----------Compute calibration KDM(C) under calibration conditions (Rsol=Rcal)----------*)*)
(*calData=Table[{c,rKDM[calparamsCal,Join[pars,<|"C"->c,"Rsol"->Rcal|>]]},{c,concList}];*)
(**)
(*(*drop any Indeterminate points,if they occur*)*)
(*calDataClean=Select[calData,NumericQ[#[[2]]]&];*)
(**)
(*(*----------Fit to Hill:KDM(C)=KDMmax*C^nH/(C^nH+KDexp^nH)----------*)(*Reparameterize to enforce positivity without ParameterConstraints:KDMmax=Exp[a],KDexp=Exp[d],nH=Exp[b]*)fit=NonlinearModelFit[calDataClean,(Exp[a]*c^Exp[b])/(c^Exp[b]+Exp[d]^Exp[b]),{{a,Log[Max[calDataClean[[All,2]]]]},(*log KDMmax initial guess*){d,Log[pars["KD"]]},(*log KD initial guess*){b,Log[1.0]}                            (*log nH initial guess,nH=1*)},c,Method->"NMinimize"];*)
(**)
(*BmaxExp=Exp[a/. fit["BestFitParameters"]];*)
(*KDExp=Exp[d/. fit["BestFitParameters"]];*)
(*nHExp=Exp[b/. fit["BestFitParameters"]];*)
(**)
(*Print["BmaxExp = ",BmaxExp];*)
(*Print["KDExp   = ",KDExp];*)
(*Print["nHExp   = ",nHExp];*)
(**)
(*(*----------Invert Hill to estimate concentration from a measured KDM----------*)*)
(*Clear[cEstFromKDM]*)
(*cEstFromKDM[k_]:=Module[{kk=k},If[!NumericQ[kk],Return[Indeterminate]];*)
(*kk=Clip[kk,{0,(1-10^-12)*BmaxExp}];*)
(*KDExp*(kk/(BmaxExp-kk))^(1/nHExp)];*)
(**)
(*Clear[normalizationParams]*)
(*(* normalizationParams[Rmeas_] :=Join[pars,<|"RsolRef"->Rmeas|>];(* this sets the normalization conditions *) *)*)
(**)
(*(*----------Build datasets:actual concentration vs estimated concentration----------*)*)
(*estData[Rmeas_]:=Table[{c,cEstFromKDM@rKDM[calparamsCal,Join[pars,<|"C"->c,"Rsol"->Rmeas|>]]},{c,concList}];*)
(**)
(*cMin=Min[calDataClean[[All,1]]];*)
(*cMax=Max[calDataClean[[All,1]]];*)
(*(*----------Plot calibration data+best-fit Langmuir isotherm----------*)*)
(*Show[ListLogLinearPlot[calDataClean,PlotRange->All,PlotMarkers->Automatic,AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLinearPlot[fit[c],{c,cMin,cMax},PlotRange->All]]*)
(*Show[ListLogLogPlot[calDataClean,PlotRange->All,PlotMarkers->Automatic,AxesLabel->{Style["Concentration",14],Style["KDM",14]},PlotLabel->Style["Calibration KDM(C) at RsolRef = "<>ToString[Rcal]<>" \[CapitalOmega]",14],ImageSize->450],LogLogPlot[fit[c],{c,cMin,cMax},PlotRange->All]]*)
(**)
(*rsolList={200,500,1000,1500,2000,2500};*)
(**)
(*colors=ColorData["Rainbow"]/@Rescale[Range[Length[rsolList]]];*)
(**)
(*Show[ListLogLogPlot[estData/@rsolList,Joined->True,PlotRange->All,PlotStyle->colors,AxesLabel->{Style["Actual concentration [M]",14],Style["Estimated concentration [M]",14]},PlotLegends->Placed[LineLegend[colors,("Rsol = "<>ToString[#]<>" \[CapitalOmega]")&/@rsolList],{0.8,0.2}],PlotLabel->Style["rKDM, Ratio obtained at "<>ToString[Rcal]<> " \[CapitalOmega], measured at Rsol",14],ImageSize->450],LogLogPlot[x,{x,10^-6,10^-2},PlotStyle->Dashed]]*)


(* ============================================================ *)
(* KDM vs concentration                                          *)
(* Black  = calibrated/normalized at 200 ohms, measured at 200  *)
(* Purple = calibrated/normalized at 200 ohms, measured at 2000 *)
(* Red    = calibrated/normalized at 2000 ohms, measured at 2000*)
(* ============================================================ *)

rsolList = {200, 2000};

plotStyles = {
   Directive[Black, Thick],
   Directive[Purple, Thick],
   Directive[Red, Thick]
};

(* ---------- calibration at 200 ohms ---------- *)

calparams200 = Join[
   pars,
   <|"RsolRef" -> 200|>
];

kdmData200Norm[Rmeas_] :=
  Select[
    Table[
      {
        c,
        kdm[
          calparams200,
          Join[
            pars,
            <|"C" -> c, "Rsol" -> Rmeas|>
          ]
        ]
      },
      {c, concList}
    ],
    NumericQ[#[[2]]] &
  ];

data200on200 = kdmData200Norm[200];
data2000on200 = kdmData200Norm[2000];

(* ---------- calibration at 2000 ohms ---------- *)

calparams2000 = Join[
   pars,
   <|"RsolRef" -> 2000|>
];

data2000on2000 =
  Select[
    Table[
      {
        c,
        kdm[
          calparams2000,
          Join[
            pars,
            <|"C" -> c, "Rsol" -> 2000|>
          ]
        ]
      },
      {c, concList}
    ],
    NumericQ[#[[2]]] &
  ];

(* ---------- plot ---------- *)

kdmPlot =
  ListLogLinearPlot[
    {
      data200on200,
      data2000on200,
      data2000on2000
    },
    Joined -> True,
    PlotStyle -> plotStyles,
    Frame -> True,
    Axes -> False,
    FrameLabel -> {
      Style["Concentration [M]", 14],
      Style["KDM", 14]
    },
    PlotLegends ->
      Placed[
        LineLegend[
          plotStyles,
          {
            "200 \[CapitalOmega] calibrated, 200 \[CapitalOmega] measured",
            "200 \[CapitalOmega] calibrated, 2000 \[CapitalOmega] measured",
            "2000 \[CapitalOmega] calibrated, 2000 \[CapitalOmega] measured"
          }
        ],
        {0.72, 0.25}
      ],
    PlotLabel ->
      Style[
        "Effect of solution resistance on KDM calibration",
        14
      ],
    ImageSize -> 650,
    PlotRange -> All
  ];

kdmPlot


(* ============================================================ *)
(* Print all current model parameters                           *)
(* ============================================================ *)

Print["---------------- PARAMETERS ----------------"];

KeyValueMap[
  Print[#1, " = ", #2] &,
  pars
];

Print["--------------------------------------------"];



pars2 = Join[
    pars,
    <|
      "KD" -> pars["KD"]/1,
      "CDL" -> pars["CDL"]/2
    |>
  ];


(* ============================================================ *)
(* KDM vs concentration with modified KD                         *)
(* Here KD is changed to KD/3                                    *)
(* Uses new variable names                                       *)
(* ============================================================ *)

parsKD3 =
  Join[
    pars,
    <|
      "KD" -> pars["KD"]/1
    |>
  ];
rsolListKD3 = {200, 2000};

plotStylesKD3 = {
   Directive[Black, Thick],
   Directive[Purple, Thick],
   Directive[Red, Thick]
};

(* ---------- calibration at 200 ohms ---------- *)

calparams200KD3 =
  Join[
    parsKD3,
    <|"RsolRef" -> 200|>
  ];

kdmData200NormKD3[Rmeas_] :=
  Select[
    Table[
      {
        c,
        kdm[
          calparams200KD3,
          Join[
            parsKD3,
            <|"C" -> c, "Rsol" -> Rmeas|>
          ]
        ]
      },
      {c, concList}
    ],
    NumericQ[#[[2]]] &
  ];

data200on200KD3 = kdmData200NormKD3[200];
data2000on200KD3 = kdmData200NormKD3[2000];

(* ---------- calibration at 2000 ohms ---------- *)

calparams2000KD3 =
  Join[
    parsKD3,
    <|"RsolRef" -> 2000|>
  ];

data2000on2000KD3 =
  Select[
    Table[
      {
        c,
        kdm[
          calparams2000KD3,
          Join[
            parsKD3,
            <|"C" -> c, "Rsol" -> 2000|>
          ]
        ]
      },
      {c, concList}
    ],
    NumericQ[#[[2]]] &
  ];

(* ---------- plot ---------- *)

kdmPlotKD3 =
  ListLogLinearPlot[
    {
      data200on200KD3,
      data2000on200KD3,
      data2000on2000KD3
    },
    Joined -> True,
    PlotStyle -> plotStylesKD3,
    Frame -> True,
    Axes -> False,
    FrameLabel -> {
      Style["Concentration [M]", 14],
      Style["KDM", 14]
    },
    PlotLegends ->
      Placed[
        LineLegend[
          plotStylesKD3,
          {
            "200 \[CapitalOmega] calibrated, 200 \[CapitalOmega] measured",
            "200 \[CapitalOmega] calibrated, 2000 \[CapitalOmega] measured",
            "2000 \[CapitalOmega] calibrated, 2000 \[CapitalOmega] measured"
          }
        ],
        {0.72, 0.25}
      ],
    PlotLabel ->
      Style[
        "Effect of solution resistance on KDM calibration, KD/3",
        14
      ],
    ImageSize -> 650,
    PlotRange -> All
  ];

kdmPlotKD3


kdmPlotKD3Linear =
  ListPlot[
    {
      data200on200KD3,
      data2000on200KD3,
      data2000on2000KD3
    },
    Joined -> True,
    PlotStyle -> plotStylesKD3,
    Frame -> True,
    Axes -> False,
    FrameLabel -> {
      Style["Concentration [M]", 14],
      Style["KDM", 14]
    },
    PlotLegends ->
      Placed[
        LineLegend[
          plotStylesKD3,
          {
            "200 \[CapitalOmega] calibrated, 200 \[CapitalOmega] measured",
            "200 \[CapitalOmega] calibrated, 2000 \[CapitalOmega] measured",
            "2000 \[CapitalOmega] calibrated, 2000 \[CapitalOmega] measured"
          }
        ],
        {0.72, 0.25}
      ],
    PlotLabel ->
      Style[
        "Effect of solution resistance on KDM calibration, KD/3",
        14
      ],
    ImageSize -> 650,
    PlotRange -> All
  ];

kdmPlotKD3Linear


pars


(* ============================================================ *)
(* KDM vs concentration                                          *)
(* Calibrated/normalized at 1000 ohms                            *)
(* Measured with Rsol drift from 900 to 1100 ohms                 *)
(* Uses new variable names                                       *)
(* ============================================================ *)

rsolDriftList1000 =
  Range[100, 2000, 100];

plotStylesDrift1000 =
  ColorData["Rainbow"] /@ Rescale[Range[Length[rsolDriftList1000]]];

calparams1000Drift =
  Join[
    pars,
    <|"RsolRef" -> 1000|>
  ];

kdmDataDrift1000[Rmeas_] :=
  Select[
    Table[
      {
        c,
        kdm[
          calparams1000Drift,
          Join[
            pars,
            <|"C" -> c, "Rsol" -> Rmeas|>
          ]
        ]
      },
      {c, concList}
    ],
    NumericQ[#[[2]]] &
  ];

dataDrift1000 =
  kdmDataDrift1000 /@ rsolDriftList1000;

kdmPlotDrift1000 =
  ListLogLinearPlot[
    dataDrift1000,
    Joined -> True,
    PlotStyle -> plotStylesDrift1000,
    Frame -> True,
    Axes -> False,
    FrameLabel -> {
      Style["Concentration [M]", 14],
      Style["KDM", 14]
    },
    PlotLegends ->
      Placed[
        LineLegend[
          plotStylesDrift1000,
          ("Rsol = " <> ToString[#] <> " \[CapitalOmega]") & /@
            rsolDriftList1000
        ],
        {0.75, 0.25}
      ],
    PlotLabel ->
      Style[
        "KDM with calibration at 1000 \[CapitalOmega] and Rsol drift",
        14
      ],
    ImageSize -> 650,
    PlotRange -> All
  ];

kdmPlotDrift1000



(* ::InheritFromParent:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::InheritFromParent:: *)
(**)


ListPlot[
  dataDrift1000 /. {x_, y_} :> {x*10^3, y},
  Joined -> True,
  PlotStyle -> plotStylesDrift1000,
  Frame -> True,
  Axes -> False,
  FrameLabel -> {
    Style["Concentration [mM]", 14],
    Style["KDM", 14]
  },
  PlotLegends ->
    Placed[
      LineLegend[
        plotStylesDrift1000,
        ("Rsol = " <> ToString[#] <> " \[CapitalOmega]") & /@
          rsolDriftList1000
      ],
      {0.75, 0.25}
    ],
  PlotLabel ->
    Style[
      "KDM with calibration at 1000 \[CapitalOmega] and Rsol drift",
      14
    ],
  ImageSize -> 650,
  PlotRange -> All
]


(* ::InheritFromParent:: *)
(**)
