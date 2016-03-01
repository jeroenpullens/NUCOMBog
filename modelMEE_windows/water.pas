unit water;

interface

uses
  plant, Math;

const
  Lambda = 2450000; Gamma = 1616*101.3/Lambda;

procedure Calcwater;
procedure CalcBERIwater;
procedure ReferenceET;
procedure BERIReferenceET;
procedure Evaporation;
procedure Transpiration;
procedure Evapotranspiration;
procedure Drainage;
procedure BERIDrainage;
procedure Storage;
procedure BERIStorage;
procedure WaterBalance;
procedure WaterLevel;
procedure BERIWaterLevel;
procedure SumWater;
procedure CalcMeanMinMaxWL;
procedure CalcYearSums;
procedure Calc30yrWLMax;

var
  Prec, NetRad, RelHum, WindSp, Evap, WAdded: real;
  ETRef, ETPenm, SumEvap, SumTransp, SumET, Drain, StorCh: real;
  PeatWkEvap, WkSumEvap, WkSumTransp, WkSumET, WkDrain, WkStorCh: real;
  W, WHeight, SumWL, SumTemp, MeanWL, MinWL, MaxWL, MeanTemp: real;
  WStorPrut, WStorCato, WStorAcro, WStorLvms, WStorLcnp, WStorTcnp: real;
  MuCato, MuAcro, MuLvms, MuLcnp, MuTcnp: real;
  MonthDays: integer;
  WLMax30yr: array[1..30] of real;
  WLPoint: integer;

implementation

procedure Calcwater;
var Week: integer;
begin
  ReferenceET;
  LightInterception;
  SumEvap := 0;
  SumTransp := 0;
  SumET := 0;
  Drain := 0;
  NDrain := 0;
  for Week := 1 to 4 do
  begin
    Evaporation;
    Transpiration;
    Evapotranspiration;
    Drainage;
    Storage;
    WaterBalance;
    WaterLevel;
    SumWater;
  end;
  CalcMeanMinMaxWL;
  CalcYearSums;
  if Month = 12 then Calc30yrWLMax;
end;

procedure ReferenceET;
begin       {bij historische runs}
  ETRef := evap;
//  ETRef := ETMakk;
end;

procedure Evaporation;
var spc: word;
begin
  for spc := humm to holl do with Species[spc] do
  begin
    if WLevel < WLOpt2 then WevF:= 1
    else if WLevel < WLMax then WEvF:= (WLMax-WLevel)/(WLMax-WLOpt2)
    else WEvF := 0;
    WkEvap := 0.25 * ETRef * CropFc * LIntFr * WEvF;
  end;
  PeatWkEvap := 0.25 * ETRef * 1.0 * PeatLIntFr * Species[holl].WEvF;
end;

procedure Transpiration;
var spc: word;
begin
  for spc := gram to eric do with Species[spc] do
  begin
//    CO2TrF:= (1 - Beta*LN(CO2/CO2ref));
    CO2TrF:= 1/(1 + Beta*LN(CO2/CO2ref));
//    if WLevel < WLMin then WTrF:= 0
//    else if WLevel < WLOpt1 then WTrF:= (WLevel-WLMin)/(WLOpt1-WLMin)
//    else if WLevel < WLOpt2 then WTrF:= 1
    if WLevel < WLOpt2 then WtrF:= 1
    else if WLevel < WLMax then WTrF:= (WLMax-WLevel)/(WLMax-WLOpt2)
    else WTrF := 0;
    WkTransp := 0.25 * ETRef * CropFc * LIntFr * CO2TrF * WTrF;
  end;
end;

procedure Evapotranspiration;
var spc: word;
begin
  WkSumEvap := 0;
  WkSumTransp := 0;
  WkSumET := 0;
  for spc := gram to holl do with Species[spc] do
  begin
    WkSumEvap := WkSumEvap + WkEvap;
    WkSumTransp := WkSumTransp + WkTransp;
  end;
  WkSumET := WkSumEvap + PeatWkEvap + WkSumTransp;
end;

procedure Drainage;
begin
  WkDrain := WStorLvms + WStorLcnp + WStorTcnp; {bij historische runs}
//  WkNDrain := (WStorLvms/MuLvms)/DepthLvms* 0.25 * NDep/12; {bij N drain}
  WkNDrain := 0; {bij geen N drain}
end;

procedure Storage;
begin
  WkStorCh := 0.25 * Prec - WkSumET - WkDrain; {bij historische runs}
end;

procedure WaterBalance;
begin
  W := W + WkStorCh * TimeStep;
end;

procedure WaterLevel;
var WLeft: real;
begin
  WLeft := W;
  WStorCato := MIN(MuCato * DepthCato, WLeft);
  WLeft := WLeft - WStorCato;
  WStorAcro := MIN(MuAcro * DepthAcro, WLeft);
  WLeft := WLeft - WStorAcro;
  WStorLvms := MIN(MuLvms * DepthLvms, WLeft);
  WLeft := WLeft - WStorLvms;
  WStorLcnp := MIN(MuLcnp * DepthLcnp, WLeft);
  WLeft := WLeft - WStorLcnp;
  WStorTcnp := MIN(MuTcnp * DepthTcnp, WLeft);
  WLeft := WLeft - WStorTcnp;
  WHeight:=(WStorCato/MuCato+WStorAcro/MuAcro+WStorLvms/MuLvms+WStorLcnp/MuLcnp+WStorTcnp/MuTcnp);
  WLevel := HeightLvms - WHeight;
end;

procedure SumWater;
begin
  SumEvap := SumEvap + WkSumEvap;
  SumTransp := SumTransp + WkSumTransp;
  SumET := SumET + WkSumET;
  Drain := Drain + WkDrain;
  NDrain := NDrain + WkNDrain;
end;

procedure CalcMeanMinMaxWL;
begin
 if Month = 1 then
 begin
   SumWL := WLevel; MinWL := WLevel; MaxWL := WLevel;
   SumTemp := Temp;
 end
 else
 if Month = 12 then
 begin
   SumWL := SumWL + WLevel; SumTemp := SumTemp + Temp;
   if WLevel < MinWL then MinWL := WLevel;
   if WLevel > MaxWL then MaxWL := WLevel;
   MeanWL := SumWL/12; MeanTemp := SumTemp/12;
 end
 else
 begin
   SumWL := SumWL + WLevel; SumTemp := SumTemp + Temp;
   if WLevel < MinWL then MinWL := WLevel;
   if WLevel > MaxWL then MaxWL := WLevel;
 end;
end;

Procedure CalcYearSums;
begin
  if Month = 1 then
  begin
    YrETRef := ETRef; YrET := SumET; YrEvap := sumEvap; YrTransp := sumTransp;
    YrDrain := Drain; YrPrec := Prec;
  end
  else
  begin
    YrETRef := YrETRef + ETRef; YrET := YrET + SumET;
    YrEvap := YrEvap + sumEvap; YrTransp := YrTransp + sumTransp;
    YrDrain := YrDrain + Drain; YrPrec := YrPrec + Prec;
  end;
end;

procedure Calc30yrWLMax;
var yr: word; sum: real;
begin
  WLMax30yr[WLPoint] := MaxWL;
  Inc(WLPoint);
  if WLPoint = 11 then WLPoint := 1;
  Sum := 0;
  for yr := 1 to 10 do Sum := Sum + WLMax30yr[yr];
  AvgWLMax := Sum / 10;
end;

procedure CalcBERIwater;
var Week: integer;
begin
  BERIReferenceET;
  LightInterception;
  SumEvap := 0;
  SumTransp := 0;
  SumET := 0;
  Drain := 0;
  NDrain := 0;
  for Week := 1 to 4 do
  begin
    Evaporation;
    Transpiration;
    Evapotranspiration;
    BERIDrainage;
    BERIStorage;
    WaterBalance;
    BERIWaterLevel;
    SumWater;
  end;
  CalcMeanMinMaxWL;
  CalcYearSums;
  if Month = 12 then Calc30yrWLMax;
end;

procedure BERIReferenceET;
var
  SatVP, ActVP, Slope, WindF, ETRad, ETAir: real;
begin
  if (Year = 1996) and (Month = 2) then MonthDays := 29
  else if Month = 2 then MonthDays := 28
  else if (Month=4) or (Month=6) or (Month=9) or (Month=11) then MonthDays := 30
  else MonthDays := 31;
  SatVP := 0.6108*EXP(17.27*Temp/(Temp+237.3));
  ActVP := SatVP*RelHum/100;
  Slope := 4098*SatVP/SQR(Temp+237.2);
  WindF := 37+40*WindSp;
  ETRad := (Slope*NetRad*10000/Lambda)/(Slope+Gamma);
  ETAir := (Gamma*(MonthDays*86400*WindF*(SatVP-ActVP)/Lambda))/(Slope+Gamma);
  ETPenm := ETRad + ETAir;
  ETRef := ETPenm;
end;

procedure BERIDrainage;
var WOverflow, BERIDrain: real; {bij BERI runs}
begin
  WOverflow := 440;
  if WHeight > WOverflow then
  begin
    BERIDrain := (MIN(WHeight, HeightAcro+300) - WOverflow)/0.8;
//    BERINDrain := (BERIDrain/0.8)/DepthAcro * 0.25 * NAvailAcro;
  end
  else
  begin
    BERIDrain := 0;
//    BERINDrain := 0;
  end;
  WkDrain := BERIDrain + WStorLvms + WStorLcnp + WStorTcnp; {bij BERI runs}
//  WkNDrain := BERINDrain + (WStorLvms/0.9)/DepthLvms* 0.25 * NDep; {bij N drain}
  WkNDrain := 0; {bij geen N drain}
end;

procedure BERIStorage;
begin
  WkStorCh := 0.25 * (Prec + WAdded) - WkSumET - WkDrain; {bij BERI runs}
end;

procedure BERIWaterLevel;
var WLeft: real;
begin
  WLeft := W;
  WStorPrut := MIN(1.0 * 300, WLeft);
  WLeft := WLeft - WStorPrut;
  WStorCato := MIN(0.7 * DepthCato, WLeft);
  WLeft := WLeft - WStorCato;
  WStorAcro := MIN(0.8 * DepthAcro, WLeft);
  WLeft := WLeft - WStorAcro;
  WStorLvms := MIN(0.9 * DepthLvms, WLeft);
  WLeft := WLeft - WStorLvms;
  WStorLcnp := MIN(MuLcnp * DepthLcnp, WLeft);
  WLeft := WLeft - WStorLcnp;
  WStorTcnp := MIN(MuTcnp * DepthTcnp, WLeft);
  WLeft := WLeft - WStorTcnp;
  WHeight:=(WStorPrut/1.0+WStorCato/0.7+WStorAcro/0.8+WStorLvms/0.9+WStorLcnp/MuLcnp+WStorTcnp/MuTcnp);
  WLevel := HeightLvms+WStorPrut/1.0 - WHeight;
end;

end.
