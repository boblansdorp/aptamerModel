(* ::Package:: *)

(* ::Input:: *)
(* ClearAll["Global`*"]*)


(* ::Input:: *)
(*(* Load TXT files *)*)
(*experimentalDataWithNoResistor=Import["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\experimentalData\\E5Ir_vs_Freq10Hz_15Hz_20Hz_25Hz_30Hz_40Hz_70Hz_80Hz_100Hz_200Hz_300Hz_400Hz_500Hz_600Hz_.txt","Table"];*)
(**)
(*experimentalDataWithResistor=Import["C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\experimentalData\\E6Ir_vs_Freq10Hz_15Hz_20Hz_25Hz_30Hz_40Hz_70Hz_80Hz_100Hz_200Hz_300Hz_400Hz_500Hz_600Hz_.txt","Table"];*)
(**)
(*simulationDataWithResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_highRhighKet3.txt";*)
(*simulationDataWithResistor=Import[simulationDataWithResistorFilePath,"Table"];*)
(**)
(*simulationDataWithNoResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_lowRhighKet2.txt"*)
(*simulationDataWithNoResistor=Import[simulationDataWithNoResistorFilePath,"Table"];*)
(**)
(*simulationCalDataWithResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_Cal_highR.txt";*)
(*simulationCalDataWithResistor = Import[simulationCalDataWithResistorFilePath,"Table"];*)
(*simulationCalDataWithNoResistorFilePath = "C:\\Users\\Bob Lansdorp\\Documents\\Wolfram Mathematica\\aptamerModel\\results\\simulation_Cal_lowR.txt"*)
(*simulationCalDataWithNoResistor = Import[simulationCalDataWithNoResistorFilePath,"Table"];*)


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


(* ::Input:: *)
(*(* Voltammogram Data  *)*)
(**)
(**)
(*(* Currents vs Freq  *)*)
(*(* Baseline *)*)
(**)
(*(* deltaI *)*)
(**)
(**)


(* ::Input:: *)
(*importLabeledTheoryBlock[simulationDataWithResistorFilePath,"## === Peak \[CapitalDelta]I vs Frequency ===",parsedTheoryDataHighResistor];*)
(*importLabeledTheoryBlock[simulationDataWithNoResistorFilePath,"## === Peak \[CapitalDelta]I vs Frequency ===",parsedTheoryDataLowResistor];*)
(**)


(* ::Input:: *)
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
(*(*Helper to compute average current at each frequency for a group*)*)
(*meanLine[group_,conc_]:=Transpose[{frequencies,10^6*Mean/@Transpose[group[conc]]}];*)
(*(*Compute lines*)*)
(*lineStandardLowConc=meanLine[grouped1,minConc];*)
(*lineAddedResistorLowConc=meanLine[grouped2,minConc];*)
(*lineStandardHighConc=meanLine[grouped1,maxConc];*)
(*lineAddedResistorHighConc=meanLine[grouped2,maxConc];*)
(**)
(*(* ===Define reusable styles===*)*)
(*plotStyles={*)
(*RGBColor[0.1216,0.4667,0.7059],(*Muted blue*)*)
(*RGBColor[0.1725,0.6275,0.1725]   (*Muted green*)*)
(*};*)
(**)
(*lineStyles={Thick,Thick};*)
(*plotRanges = {{5,700}, {0,10}};*)
(*(* ===Function to make consistent plots===*)*)
(*makeConsistentPlot[data_,label_]:=ListLogLinearPlot[data,Joined->True,PlotStyle->MapThread[{#1,#2}&,{plotStyles,lineStyles}],Frame->True,FrameLabel->{"Frequency (Hz)","Current (\[Micro]A)"},PlotLabel->label,PlotRange->plotRanges,ImageSize->300,BaseStyle->{FontSize->10},PlotLegends->{"0 mM","9.3 mM"}];*)
(*(* ===Extract and plot theory lines===*)(* ===Extract theory curve data only===*)*)
(*theoryCurve[conc_, data_]:=Module[*)
(*{entry=SelectFirst[data,#[[1]]==conc&]},If[ListQ[entry]&&Length[entry]==2,entry[[2]],(*just the list of {freq,current} pairs*)*)
(*Missing["NotFound"]]];*)
(**)
(*(* ===Create each plot===*)*)
(*theoryStandardPlot=makeConsistentPlot[{theoryCurve[0, parsedTheoryDataLowResistor],theoryCurve[0.0093, parsedTheoryDataLowResistor]},"Theory (Standard)"];*)
(**)
(*theoryResistorPlot=makeConsistentPlot[{theoryCurve[0, parsedTheoryDataHighResistor],theoryCurve[0.0093, parsedTheoryDataHighResistor]},"Theory (added resistor)"];*)
(**)
(*lowResistorDeltaIPlot=makeConsistentPlot[{lineStandardLowConc,lineStandardHighConc},"Exp5 (Standard)"];*)
(**)
(*highResistorDeltaIPlot=makeConsistentPlot[{lineAddedResistorLowConc,lineAddedResistorHighConc},"Exp6 (Added Resistor)"];*)
(**)
(*(* ===Arrange in 2x2 Grid===*)*)
(*Grid[{{lowResistorDeltaIPlot,theoryStandardPlot},{highResistorDeltaIPlot,theoryResistorPlot}},Spacings->{2,2}]*)
(**)
(**)
(**)


(* ::Input:: *)
(*(* Lovric Plot  *)*)
(*importLabeledTheoryBlock[simulationDataWithResistorFilePath,"## === Peak \[CapitalDelta]I vs Frequency ===",parsedTheoryDataHighResistor];*)
(**)
(*importLabeledTheoryBlock[simulationDataWithNoResistorFilePath,"## === Peak \[CapitalDelta]I vs Frequency ===",parsedTheoryDataLowResistor];*)
(*lovricCurve[conc_,parsedData_]:=Module[{entry},entry=SelectFirst[parsedData,#[[1]]==conc&];*)
(*If[ListQ[entry]&&Length[entry]==2,entry[[2]]/. {f_,i_}:>{f,i/(f)},Missing["NotFound"]]];*)
(*(*Experimental Lovri\[CAcute] curves*)*)
(*parsedTheoryDataLowResistor;*)
(*(*Theory Lovri\[CAcute] curves*)*)
(*lovricTheoryLow=lovricCurve[0,parsedTheoryDataLowResistor];*)
(*lovricTheoryHigh=lovricCurve[0.0093,parsedTheoryDataLowResistor];*)
(**)
(*(* ===Plot all normalized Lovri\[CAcute] curves===*)*)
(**)
(*TheoryPlot=ListLogLinearPlot[{lovricTheoryLow,lovricTheoryHigh},Joined->True,PlotMarkers->False,PlotStyle->plotStyles,PlotRange->{Automatic,{0,0.05}},PlotLegends->Automatic,Frame->True,FrameLabel->{"Frequency (Hz)","\!\(\*FractionBox[\(i\), \(f\)]\) (microA/Hz)"},PlotLabel->"Lovri\[CAcute] Plot: i/f vs Frequency",ImageSize->300];*)
(**)
(**)
(*(* ===Step 1:Create raw Lovri\[CAcute] data from each curve (i/f)===*)*)
(*lovricStandardLowConcRaw=lineStandardLowConc/. {f_,i_}:>{f,i/f};*)
(*lovricStandardHighConcRaw=lineStandardHighConc/. {f_,i_}:>{f,i/f};*)
(*(* ===Plot all normalized Lovri\[CAcute] curves===*)*)
(*ExperimentPlot=ListLogLinearPlot[{lovricStandardLowConcRaw,lovricStandardHighConcRaw},Joined->True,PlotMarkers->None,PlotStyle->plotStyles,PlotRange->{Automatic,{0,0.05}},PlotLegends->Automatic,Frame->True,FrameLabel->{"Frequency (Hz)","\!\(\*FractionBox[\(i\), \(f\)]\) (microA/Hz)"},PlotLabel->"Lovri\[CAcute] Plot: i/f vs Frequency",ImageSize->300];*)
(**)
(*Grid[ {{ExperimentPlot, TheoryPlot}}]*)
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
ListLogLinearPlot[data,Joined->True,PlotStyle->{Directive[plotStyles,Thick]},
Frame->True,FrameLabel->{"Frequency (Hz)","\[CapitalDelta]I (\[Micro]A)"},PlotLabel->label,PlotRange->{Automatic, {-1,2}},ImageSize->300,BaseStyle->{FontSize->10}];

iNormStandardPlot=makeINormPlot[iNormExpStandard,"\[CapitalDelta]I Exp5 (Standard)"];
iNormResistorPlot=makeINormPlot[iNormExpResistor,"\[CapitalDelta]I Exp6 (Resistor)"];
iNormTheoryStandardPlot=makeINormPlot[iNormTheoryStandard,"\[CapitalDelta]I Theory (Standard)"];
iNormTheoryResistorPlot=makeINormPlot[iNormTheoryResistor,"\[CapitalDelta]I Theory (Resistor)"];

Grid[{{iNormStandardPlot,iNormTheoryStandardPlot},{iNormResistorPlot,iNormTheoryResistorPlot}},Spacings->{2,2}]


(* ::InheritFromParent:: *)
(**)
(**)


(* ::InheritFromParent:: *)
(**)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*(* Calibration Curve  *)*)


(* ::Input:: *)
(*kdmDataHigh=importCalibrationBlock[simulationCalDataWithResistorFilePath,"## === Calibration Curve (KDM vs Concentration) ==="];*)
(**)
(*kdmDataLow=importCalibrationBlock[simulationCalDataWithNoResistorFilePath,"## === Calibration Curve (KDM vs Concentration) ==="];*)
(**)


(* ::Input:: *)
(*plotStyles={*)
(*RGBColor[0.1216,0.4667,0.7059],(*Muted blue*)*)
(*RGBColor[0.5804,0.4039,0.7412],  (*Soft purple*)*)
(*RGBColor[0.1725,0.6275,0.1725],(*Muted green*)*)
(*RGBColor[0.8392,0.1529,0.1569]  (*Muted red*)*)
(*};*)
(**)
(**)


(* ::Input:: *)
(*ListLogLinearPlot[{kdmDataLow,kdmDataHigh},Joined->True,PlotStyle->plotStyles,PlotMarkers->Automatic,Frame->True,FrameLabel->{"Concentration (M)","KDM Signal"},PlotLabel->"KDM vs Concentration",ImageSize->Large,PlotRange->{{10^-6,10^-2},All},PlotLegends->{"Low R","High R"}]*)
(**)
