(* ::Package:: *)

(* ::Input::Initialization:: *)
BeginPackage["LoadVoltammogramData`"]
loadAllVoltammograms::usage="loadAllVoltammograms[dir] loads and parses voltammogram files.";

reshapeVoltammogramData::usage="reshapeVoltammogramData[data, currentKey, channel] reshapes the voltammogram data into an Association.";


Begin["`Private`"]

parseDataFile[file_]:=Module[{lines,headerLineIndex,startIndex,dataLines,stringValues,convertENotation,stringValuesFixed,numericValues,numCols,dataMatrix,voltages,currents,nChan,iDiff,iFwd,iRev,frequencyHz},(*Read lines*)lines=Import[file,"Lines"];
(*Extract frequency from metadata*)frequencyHz=Quiet@Check[ToExpression@StringTrim@StringReplace[SelectFirst[lines,StringContainsQ[#,"Frequency"]&],"Frequency (Hz) = "->""],Missing["NotFound"]];
(*Find header*)headerLineIndex=FirstPosition[lines,s_/;StringContainsQ[s,"Potential"]];
If[headerLineIndex===Missing["NotFound"],Print["\:26a0\:fe0f Header line not found in ",file];Return[$Failed];];
startIndex=headerLineIndex[[1]];
(*Extract and clean data*)dataLines=Select[lines[[startIndex+1;;]],StringTrim[#]=!=""&];
stringValues=StringTrim/@StringSplit[StringRiffle[dataLines,","],","];
If[stringValues==={},Print["\:26a0\:fe0f No data found in ",file];
Return[$Failed];];
(*Fix E notation*)convertENotation[str_]:=StringReplace[str,RegularExpression["([\\d\\.]+)[eE]([+-]?\\d+)"]->"$1*10^$2"];
stringValuesFixed=convertENotation/@stringValues;
numericValues=Quiet@Check[ToExpression[stringValuesFixed],Print["\:26a0\:fe0f Error converting string to numbers in ",file];
Return[$Failed];];
(*Detect number of columns*)numColsGuess=StringCount[First@dataLines,","]+1;
If[Mod[numColsGuess-1,3]=!=0,Print["\:26a0\:fe0f Unexpected number of columns in ",file];
Return[$Failed];];
nChan=(numColsGuess-1)/3;
numCols=1+3*nChan;
(*Reshape and extract*)If[Mod[Length[numericValues],numCols]=!=0,Print["\:26a0\:fe0f Incorrect column count in ",file];Return[$Failed];];
dataMatrix=Partition[numericValues,numCols];
voltages=dataMatrix[[All,1]];
currents=dataMatrix[[All,2;;]];
iDiff=currents[[All,Range[1,3*nChan,3]]];
iFwd=currents[[All,Range[2,3*nChan,3]]];
iRev=currents[[All,Range[3,3*nChan,3]]];
(*Output*)(*<|"File"->file,"Frequency"->frequencyHz,"Voltage"->voltages,"IDiff"->iDiff,"IFwd"->iFwd,"IRev"->iRev|>*)(*Step 10:Build output structure\[LongDash]one curve per channel per currentKey*)

Association["Frequency"->frequencyHz,"Voltage"->voltages,"IDiff"->iDiff,"IFwd"->iFwd,"IRev"->iRev,"Curves"-><|"IDiff"->Table[frequencyHz->Transpose[{voltages,10^6*i}],{i,Transpose[iDiff]}],"IFwd"->Table[frequencyHz->Transpose[{voltages,10^6*i}],{i,Transpose[iFwd]}],"IRev"->Table[frequencyHz->Transpose[{voltages,10^6*i}],{i,Transpose[iRev]}]|>] 
];

loadAllVoltammograms[dir_]:=
	Module[{txtFiles,parsedData},
	Print["Calling loadAllVoltammograms 2"];
	Print["Loading from: ",dir];
	txtFiles=FileNames["*.txt",dir,Infinity];
	Print["Found files: ",txtFiles];
	parsedData=Select[parseDataFile[#]&/@txtFiles,AssociationQ];
	parsedData
]; 

reshapeVoltammogramData[data_,currentKey_:"IDiff",channel_:4]:=Association[Table[Module[{freq,volts,currents},freq=record["Frequency"];
volts=record["Voltage"];
currents=Lookup[record,currentKey][[All,channel]];
freq->Transpose[{volts,10^6*currents}]],{record,data}]];



End[]  (*`Private` context*)

EndPackage[]




