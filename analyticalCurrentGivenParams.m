(* ::Package:: *)

(* ::Input:: *)
(*ClearAll["Global`*"]*)
(*(*Create functions to compute impedance*)*)
(*ZDL[w_, CDL_]:=1/(I*w*CDL);*)
(**)
(*(* ZFaradaic[w_,RCT_, CApt_]:=RCT+1/(I*w*CApt);*)
(*Y0=1.10*10^-6;*)
(*Nexponent=0.873;*)
(*ZFaradaic[w_,RCT_, Capt_]:=RCT+1/(Y0*(I*w)^Nexponent); *) (* constant phase element *)*)
(**)
(*ZFaradaic[w_,RCT_, CApt_]:=RCT+1/(I*w*CApt); *)
(**)
(*ZParallel[w_,CDL_, RCT_, CApt_]:=1/(1/ZDL[w, CDL]+1/ZFaradaic[w,RCT, CApt]); *)
(**)
(*ZTotalNonFaradaic[w_,CDL_, RCT_, Rsol_, Capt_]:=ZDL[w, CDL]+Rsol; *)
(**)
(* ZTotal[w_,CDL_, RCT_, Rsol_, CApt_]:=Rsol+ZParallel[w,CDL, RCT, CApt];  (* PREVIOUS DEFINITION! *)*)
(* *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(*Compute Laplace-domain current for step*)*)
(*(*Time-domain voltage*)*)
(*(* V0=0.025; *)(*volts*)*)
(**)
(**)
(**)
(*V0FWD=   V0 ; (* In SWV,the instrument \[OpenCurlyDoubleQuote]Amplitude\[CloseCurlyDoubleQuote] (V0) is the pulse height E_sw, so total should be twice this *)*)
(*NSTEPS = 2; (* how many square wave steps is enough? *)*)
(**)
(**)
(*(* vtime[t_,nSteps_, fSWV_]:=V0FWD (UnitStep[t] + Sum[ UnitStep[t+n/fSWV]+UnitStep[t+(n+1)/fSWV]-2UnitStep[t+(n+1/2)/fSWV], {n,0,nSteps-1}]) *)*)
(*vtime[t_,nSteps_, fSWV_]:=V0FWD (- Sum[ HeavisideTheta[t-n/fSWV]+HeavisideTheta[t-(n+1)/fSWV]-2HeavisideTheta[t-(n+1/2)/fSWV ] -(VDELTA /V0FWD)HeavisideTheta[t-(n+1)/fSWV], {n,0,nSteps-1}])*)
(**)


(* ::Input:: *)
(*Plot[{vtime[t,NSTEPS, fSWV]/.{V0FWD->0.025, fSWV->100, VDELTA->0.00}}, {t,-0.01,0.03}, PlotRange->Automatic, AxesLabel->{"Time (s)", "Applied SWV Potential (V)"}]*)
(**)


(* ::Input:: *)
(*vtime[t,3, 600]*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(*Laplace transform*)*)
(*VofS=LaplaceTransform[vtime[t, NSTEPS, fSWV],t,s,Assumptions->{ V0\[Element]Reals, VDELTA->0, fSWV>0}]*)
(**)


(* ::Input:: *)
(*VofS=LaplaceTransform[vtime[t, NSTEPS, fSWV]/.{VDELTA->0},t,s,Assumptions->{ V0\[Element]Reals, fSWV>0}]*)


(* ::Input:: *)
(*VofS=Simplify[VofS, Assumptions->{fSWV>0}]*)


(* ::Input:: *)
(*IsNonFaradaic = VofS/(ZTotalNonFaradaic[-I s,CDL, Rct, Rsol, Capt])*)


(* ::Input:: *)
(*Simplify[IsNonFaradaic,Assumptions->{fSWV>0}]*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*itNonFaradaic =InverseLaplaceTransform[IsNonFaradaic,s,t,Assumptions->{CDL Rsol!=0,fSWV>0}] (* the current versus time in response to a step of amplitude V0 *)*)


(* ::Input:: *)
(*itNonFaradaic=Simplify[itNonFaradaic, Assumptions->{V0>0,fSWV>0, t>0}]*)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(*(* itNonFaradaicInfinite=itNonFaradaic-(itNonFaradaic/.{t->1/(2fSWV)}  )/2 *)     (*current at end of forward half-pulse*)*)


(* ::Input:: *)
(*(* attempt to quantify Bioligic discrete measuremnet *)*)
(**)
(*(* *)
(*BiologicSampleRate = 5000; (* actually 4 measurements per sample *)*)
(*BiologicNpoints = Round[BiologicSampleRate*BiologicDutyCycle*(1/(2*fSWV))]*4*)
(*BiologicNpoints/.{BiologicDutyCycle->0.6, fSWV->625}*)
(*BiologicNpoints/.{BiologicDutyCycle->0.6, fSWV->1250}*)
(*BiologicNpoints/.{BiologicDutyCycle->0.6,fSWV->frequenciesList}*)
(*N[1000(NSTEPS/fSWV-(n-50/100)/BiologicSampleRate)/.{fSWV->500, n->2}]*)
(*BiologicSignalNonFaradaicFWD = Sum[itNonFaradaic/.{t->(NSTEPS/fSWV-(n+0)/(4*BiologicSampleRate))},{n,BiologicNpoints}]/BiologicNpoints*)
(*BiologicSignalNonFaradaicREV= Sum[itNonFaradaic/.{t->(NSTEPS/fSWV-1/(2*fSWV)-(n+0)/(4*BiologicSampleRate))},{n,BiologicNpoints}]/BiologicNpoints*)
(*(* BiologicSignalNonFaradaicFWD=Integrate[itNonFaradaic,{t,NSTEPS/fSWV-(BiologicNpoints+1/2)/BiologicSampleRate, NSTEPS/fSWV-(1/2)/BiologicSampleRate}, Assumptions->{ fSWV>0, fSWV\[Element]Reals}]/(BiologicNpoints/BiologicSampleRate) *)*)
(*BiologicSignalNonFaradaicDIFF = BiologicSignalNonFaradaicFWD-BiologicSignalNonFaradaicREV*)
(*10^6BiologicSignalNonFaradaicDIFF/.{CDL->220*10^-9, Rsol->2200, BiologicDutyCycle->0.6, fSWV->500, V0->0.025}*)
(*10^6BiologicSignalNonFaradaicDIFF/.{CDL->220*10^-9, Rsol->2200, BiologicDutyCycle->0.6, fSWV->625, V0->0.025}*)
(*10^6BiologicSignalNonFaradaicDIFF/.{CDL->220*10^-9, Rsol->2200, BiologicDutyCycle->0.6, fSWV->833.33333, V0->0.025}*)
(*10^6BiologicSignalNonFaradaicDIFF/.{CDL->220*10^-9, Rsol->2200, BiologicDutyCycle->0.6, fSWV->1250, V0->0.025}*)
(*ListPlot[2*10^6BiologicSignalNonFaradaicFWD/.{CDL->220*10^-9, Rsol->2200, BiologicDutyCycle->0.6, V0->0.025,SWV/.frequenciesList}]  *)*)


(* ::Text:: *)
(* *)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(* CHISignalDiffNonFaradaic = CHISignalNonFaradaic-CHISignalNonFaradaicRev *) *)
(*(* SWVPulseAvg =1/4; *) (* expressed as a fraction. so max is 1, represents aveging entire pulse. 0.5 is CHI spec, 50% of pulse *)*)
(*CHISignalNonFaradaicFWD = Integrate[itNonFaradaic, {t,NSTEPS/fSWV-SWVPulseAvg/(2 fSWV), NSTEPS/fSWV}, Assumptions->{ fSWV>0, fSWV\[Element]Reals}]/(SWVPulseAvg/(2 fSWV));*)
(*CHISignalNonFaradaicREV = Integrate[itNonFaradaic, {t,NSTEPS/fSWV-2/(4 fSWV)-SWVPulseAvg/(2 fSWV), NSTEPS/fSWV-2/(4 fSWV)}, Assumptions->{fSWV>0, fSWV\[Element]Reals}]/(SWVPulseAvg/(2 fSWV));*)
(**)
(**)
(*CHISignalDiffNonFaradaic =  CHISignalNonFaradaicFWD-CHISignalNonFaradaicREV (* since it's symmetric and we are waiting infinite time, forward minus reverse is double just the forward step size *)*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*LogLinearPlot[{10^6CHISignalDiffNonFaradaic/.{V0 ->0.025,VDELTA->0.000, Rsol->2200, CDL->220*10^-9, SWVPulseAvg->1/4}, 10^6CHISignalDiffNonFaradaic/.{V0 ->0.025,VDELTA->0.000, Rsol->2200, CDL->220*10^-9, SWVPulseAvg->1/2}, 10^6CHISignalDiffNonFaradaic/.{V0 ->0.025,VDELTA->0.000, Rsol->2200, CDL->220*10^-9, SWVPulseAvg->3/4},10^6CHISignalDiffNonFaradaic/.{V0 ->0.025,VDELTA->0.000, Rsol->2200, CDL->220*10^-9, SWVPulseAvg->1}}, {fSWV, 10,600}, AxesLabel->{"Frequency [Hz]", "Difference Current [microA]"}, PlotLegends->{"25%", "50%",  "75%",  "100%"}]*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*CHISignalDiffNonFaradaic=CHISignalDiffNonFaradaic/.{VDELTA->0 ,SWVPulseAvg->1/2} (* use the CHI potentiostat settings *)*)


(* ::Input:: *)
(*CHISignalDiffNonFaradaic=Simplify[CHISignalDiffNonFaradaic, Assumptions->{fSWV>0}]*)


(* ::Input:: *)
(*(* VofSRev=LaplaceTransform[vtimeRev[t],t,s] *)*)
(*(*Laplace current*)*)
(*Is=(VofS/ZTotal[-I s,CDL,Rct,Rsol,Capt])/.{VDELTA->0}*)
(*(* IsRev=VofSRev/ZTotal[-I s,CDL,Rct,Rsol,Capt]; *)*)
(**)
(**)
(*(*Compute time-domain current*)*)
(*(*Inverse Laplace*)*)
(*it=InverseLaplaceTransform[Is,s,t, Assumptions->{fSWV>0}]*)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(*Plot[{10^6 it/.{t->(timems + 5)/1000,fSWV->200, Capt->300*10^-9, CDL->300*10^-9, Rsol->100, V0->0.025, Rct->10000}, 10^6 it/.{t->(timems + 5)/1000,fSWV->200, Capt->300*10^-9, CDL->300*10^-9, Rsol->1000, V0->0.025, Rct->10000}}, {timems,0,5}, PlotRange->{{0,5}, {-10,10}}, PlotLegends->{"Low Rs", "High Rs"}, AxesLabel->{"time (s)", "current (microA)"},AspectRatio->1]*)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(*(* it = it//FullSimplify *)*)
(**)





(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Code:: *)
(**)


(* ::Input:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(* itInfinite=it-(it/.{t->1/(2fSWV)}  )/2  ;   *)   (*current at end of forward half-pulse*)*)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(* IsNonFaradaicRev = VofSRev/(ZTotalNonFaradaic[-I s,CDL, Rct, Rsol, Capt]); *)*)
(**)
(**)
(*(* *)
(*Is=V0/(s*ZTotal[-I s,CDL, Rct, Rsol, Capt]);*)
(*IsNonFaradaic = V0/(s*ZTotalNonFaradaic[-I s,CDL, Rct, Rsol, Capt]);*)
(**) *)


(* ::Input:: *)
(*(* itRev=FullSimplify[InverseLaplaceTransform[IsRev,s,t]] *)*)


(* ::Input:: *)
(*(* itNonFaradaicRev =FullSimplify[InverseLaplaceTransform[IsNonFaradaicRev,s,t]] *)*)


(* ::Input:: *)
(*(*make it exact,then integrate*)*)
(*(* itExact=Rationalize[it,0];   (*kills 0.25,0.5,etc and makes them rationals*)*)
(*itExact=Simplify[itExact, Assumptions->{fSWV>0 && t>(NSTEPS-3/4)/fSWV, t<(NSTEPS)/fSWV}] *)*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*expr1=it/. {(CDL Rsol+Capt (Rct+Rsol))->\[Lambda]1};*)
(*expr2=expr1/.{Sqrt[ CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2]->\[Lambda]2};*)
(*expr3=expr2/.{ Capt CDL Rct Rsol->\[Lambda]3} ;*)
(*Simplify[expr3]*)
(**)
(**)


(* ::Input:: *)
(*CHISignalFWD = Integrate[expr3, {t,NSTEPS/fSWV-(1/fSWV)/4, NSTEPS/fSWV}, Assumptions->{fSWV>0, fSWV\[Element]Reals, Capt>0, CDL>0,  Rct>0, Rsol>0,\[Lambda]1>0, \[Lambda]2>0, \[Lambda]3>0}]/(1/(4 fSWV))*)


(* ::Input:: *)
(*CHISignalREV = Integrate[expr3, {t,NSTEPS/fSWV-(3/fSWV)/4, NSTEPS/fSWV-(2/fSWV)/4}, Assumptions->{fSWV>0, fSWV\[Element]Reals, Capt>0, CDL>0,  Rct>0, Rsol>0,\[Lambda]1>0, \[Lambda]2>0, \[Lambda]3>0}]/(1/(4 fSWV))*)


(* ::Input:: *)
(*CHISignalRefactoredFWD=CHISignalFWD/.{\[Lambda]1->(CDL Rsol+Capt (Rct+Rsol)),\[Lambda]2->Sqrt[ CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2], \[Lambda]3-> Capt CDL Rct Rsol}*)
(*CHISignalRefactoredREV=CHISignalREV/.{\[Lambda]1->(CDL Rsol+Capt (Rct+Rsol)),\[Lambda]2->Sqrt[ CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2], \[Lambda]3-> Capt CDL Rct Rsol}*)
(**)


(* ::Input:: *)
(*(* CHISignalFWD = Integrate[it, {t,NSTEPS/fSWV-(1/fSWV)/4, NSTEPS/fSWV}, Assumptions->{NSTEPS\[Element]PositiveIntegers, fSWV>0, fSWV\[Element]Reals, Capt>0, CDL>0,  Rct>0, Rsol>0, t<NSTEPS/fSWV, t>(NSTEPS-1/4)/fSWV}]/(1/(4 fSWV)) *)*)


(* ::Input:: *)
(* (* CHISignalREV= Integrate[it, {t,NSTEPS/fSWV-(3/fSWV)/4, NSTEPS/fSWV-(2/fSWV)/4}, Assumptions->{NSTEPS\[Element]PositiveIntegers, fSWV>0, fSWV\[Element]Reals, Capt>0, CDL>0,  Rct>0, Rsol>0, \[Lambda]1>0, \[Lambda]2>0, \[Lambda]3>0}]/(1/(4 fSWV)) *)*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(* CHISignalRefactored=CHISignal/.{\[Lambda]1->(CDL Rsol+Capt (Rct+Rsol)),\[Lambda]2->Sqrt[ CDL^2 Rsol^2+2 Capt CDL Rsol (-Rct+Rsol)+Capt^2 (Rct+Rsol)^2], \[Lambda]3-> Capt CDL Rct Rsol} *)*)


(* ::Input:: *)
(*(* CHISignal = Integrate[itExact/.{fSWV->t1}, {t,t1/2, t1}]/(t1-t1/2) *)*)


(* ::Input:: *)
(*(* CHISignal = Integrate[itExact, {t,NSTEPS/fSWV-(1/fSWV)/4, NSTEPS/fSWV}, Assumptions->{NSTEPS\[Element]Integers, fSWV>0, fSWV\[Element]Reals}]/(1/(4 fSWV)); *)*)


(* ::Input:: *)
(*(* CHISignalRev= Integrate[-itExact, {t,t1/2, t1}]/(t1-t1/2) *)*)


(* ::Input:: *)
(*(* CHISignalNonFaradaicRev = Integrate[itNonFaradaicRev, {t,t1/2, t1}]/(t1-t1/2); *)*)
(*(* CHISignalDiff =  CHISignal-CHISignalRev *)*)
(*(* CHISignalDiff =  2 CHISignalRefactored *) (* With a linear circuit model, forward and reverse steps are symmetric so we can do this! *)*)


(* ::Input:: *)
(*CHISignalDiff = CHISignalRefactoredFWD-CHISignalRefactoredREV*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*CHISignalDiffSimple = Simplify[CHISignalDiff, Assumptions->{CDL>0,Rsol>0 , Capt>0, Rct>0, V0>0,fSWV>0 }]*)


Simplify[CHISignalDiffSimple/.{V0->0.025}]


(* ::Input:: *)
(*CHISignalBaselineSubtracted = CHISignalDiffSimple-CHISignalDiffNonFaradaic*)
(**)


(* ::Input:: *)
(* Simplify[CHISignalBaselineSubtracted, Assumptions->{fSWV>0}]*)
