(* ::Package:: *)

(* ::Input::Initialization:: *)
(* ::Package::*)
BeginPackage["AnalyzeVoltammogram`"]

analyzeVoltammogram::usage="analyzeVoltammogram[data] fits a Gaussian peak to voltammogram    data and returns an association with Baseline, DeltaI,    PeakCurrent, and the Fit object.";

Begin["`Private`"]

analyzeVoltammogram[data_]:=Module[{trimmed,voltages, minV,maxV, baselineRegion,b0,x0init,fit,fitParams},

	(*Remove edges to avoid unstable data*)
	trimmed=Take[data,{6,-6}];

(*Extract voltage range*)voltages=trimmed[[All,1]];
	minV=Min[voltages];
	maxV=Max[voltages];


(*Estimate baseline from central voltages*)
(* baselineRegion=Select[trimmed,-0.1<=#[[1]]<=0.1&]; *) (* old logic hardcoded basline region *)

baselineRegion=Select[trimmed,(#1[[1]]<=(minV+0.05))||(#1[[1]]>=(maxV-0.05))&];

b0=Mean[baselineRegion[[All,2]]];

(*Initial guess for peak position*)
x0init=trimmed[[Ordering[trimmed[[All,2]],-1][[1]],1]];

(*Fit a Gaussian plus baseline*)
fit=NonlinearModelFit[trimmed,b+C*Exp[-((x-x0)/\[Sigma])^2],{{b,b0},{C,Max[trimmed[[All,2]]]-Min[trimmed[[All,2]]]},{\[Sigma],0.025},{x0,x0init}},x];
fitParams=fit["BestFitParameters"];
Association["Baseline"->(b/. fitParams),"DeltaI"->(C/. fitParams),"PeakCurrent"->((b+C)/. fitParams),"Fit"->fit]];

End[]
Print["\:2705 AnalyzeVoltammogram Package loaded."];
EndPackage[]




