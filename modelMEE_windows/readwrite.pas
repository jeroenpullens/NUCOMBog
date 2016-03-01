unit readwrite;

{$MODE Delphi}

interface
uses
  inifiles, plant, water, Messages, Dialogs,SysUtils;

const
  ifParam=1; ifIniVal=2; ifClim=3; ifEnv=4;
  ofMonth=1; ofYear=2;

var
  FromYeartext, ToYeartext: string;
  InDir, OutDir, ModelDir: string;
  InFile:array[1..4] of string;
  OutFile: array[1..2] of string;

procedure ReadParam;
procedure ReadIniVal;
procedure ReadEnv;
procedure OpenEnv(FromYear: integer);
procedure CloseEnv;
procedure ReadClim;
procedure OpenClim(FromYear: integer);
procedure CloseClim;
procedure OpenOutMonth;
procedure WriteOutMonth;
procedure CloseOutMonth;
procedure OpenOutYear;
procedure WriteOutYear;
procedure CloseOutYear;

implementation

var
  Fenv, Fclim, Fom, Foy: TextFile;

procedure ReadParam;
var
  fIni: TIniFile;
  spc, org: word;
begin
  fIni:= TIniFile.Create(ModelDir+'\input\'+InFile[ifParam]);
  writeln(OutDir);
  CO2Ref := fIni.ReadFloat('Bog','CO2ref',0);
  FixDepthLcnp := fIni.ReadFloat('Bog', 'FixDepthlcnp', 0);
  FixDepthTcnp := fIni.ReadFloat('Bog', 'FixDepthtcnp', 0);
  MinDepthLvms := fIni.ReadFloat('Bog', 'MinDepthlvms', 0);
  MaxDepthLvms := fIni.ReadFloat('Bog', 'MaxDepthlvms', 0);
  MaxDepthAcro := fIni.ReadFloat('Bog', 'MaxDepthacro', 0);
  TOptDec := fIni.ReadFloat('Bog','TOptDec',0);
  TDecParLvms := fIni.ReadFloat('Bog','TDecParLvms',0);
  TDecParAcro := fIni.ReadFloat('Bog','TDecParacro',0);
  TDecParCato := fIni.ReadFloat('Bog','TDecParcato',0);
  CritNCLvms := fIni.ReadFloat('Bog','CritNCLvms',0);
  CritNCAcro := fIni.ReadFloat('Bog','CritNCAcro',0);
  CritNCCato := fIni.ReadFloat('Bog','CritNCCato',0);
  MicrEffLvms := fIni.ReadFloat('Bog','MicrEffLvms',0);
  MicrEffAcro := fIni.ReadFloat('Bog','MicrEffAcro',0);
  MicrEffCato := fIni.ReadFloat('Bog','MicrEffCato',0);
  MuTcnp := fIni.ReadFloat('Bog','Mutcnp',0);
  MuLcnp := fIni.ReadFloat('Bog','Mulcnp',0);
  MuLvms := fIni.ReadFloat('Bog','Mulvms',0);
  MuAcro := fIni.ReadFloat('Bog','Muacro',0);
  MuCato := fIni.ReadFloat('Bog','Mucato',0);
  for spc:= 1 to 5 do
  with Species[spc] do
  begin
    Beta:= fIni.ReadFloat(SpcName[spc],'Beta',0);
   if Beta=0 then begin
      writeln('inifile not found!');
         //ShowMessage('inifile not found!');
      exit;
    end;
    SLA := fIni.ReadFloat(SpcName[spc], 'SLA', 0);
    KExt := fIni.ReadFloat(SpcName[spc], 'KExt', 0);
    MaxGr:= fIni.ReadFloat(SpcName[spc],'MaxGr',0);
    TminGr:= fIni.ReadFloat(SpcName[spc],'TminGr',0);
    TOpt1Gr:= fIni.ReadFloat(SpcName[spc],'TOpt1Gr',0);
    TOpt2Gr:= fIni.ReadFloat(SpcName[spc],'TOpt2Gr',0);
    TMaxGr:= fIni.ReadFloat(SpcName[spc],'TMaxGr',0);
    WLMin:= fIni.ReadFloat(SpcName[spc],'WLMin',0);
    WLOpt1:= fIni.ReadFloat(SpcName[spc],'WLOpt1',0);
    WLOpt2:= fIni.ReadFloat(SpcName[spc],'WLOpt2',0);
    WLMax:= fIni.ReadFloat(SpcName[spc],'WLMax',0);
    NConcMin := fIni.ReadFloat(SpcName[spc], 'NConcMin', 0);
    NConcMax := fIni.ReadFloat(SpcName[spc], 'NConcMax', 0);
    CropFc := fIni.ReadFloat(SpcName[spc], 'CropFc', 0);
    for org:= leaf to shoot do if Organ[org] <> nil then with Organ[org] do
    begin
      CAllocFr:= fIni.ReadFloat(SpcName[spc], 'CAllocFr'+OrgName[org],0);
      NAllocFr:= fIni.ReadFloat(SpcName[spc], 'NAllocFr'+OrgName[org],0);
      MortFrLvms := fIni.ReadFloat(SpcName[spc], 'MortFrLvms'+OrgName[org], 0);
      MortFrAcro := fIni.ReadFloat(SpcName[spc], 'MortFrAcro'+OrgName[org], 0);
      MortFrCato := fIni.ReadFloat(SpcName[spc], 'MortFrCato'+OrgName[org], 0);
      ReallFr := fIni.ReadFloat(SpcName[spc], 'ReallFr'+OrgName[org], 0);
      DecParLvms := fIni.ReadFloat(SpcName[spc], 'DecParLvms'+OrgName[org], 0);
      DecParAcro := fIni.ReadFloat(SpcName[spc], 'DecParAcro'+OrgName[org], 0);
      DecParCato := fIni.ReadFloat(SpcName[spc], 'DecParCato'+OrgName[org], 0);
      BDLvms := fIni.ReadFloat(SpcName[spc], 'BDLvms'+OrgName[org], 0);
      BDAcro := fIni.ReadFloat(SpcName[spc], 'BDAcro'+OrgName[org], 0);
      BDCato := fIni.ReadFloat(SpcName[spc], 'BDCato'+OrgName[org], 0);
    end;
  end;
  
  fIni.Free;
end;

procedure ReadIniVal;
var
  fIni: TIniFile;
  spc, org, yr: word;
begin
  fIni:= TIniFile.Create(InDir+InFile[ifIniVal]);
  NInoAcro := fIni.ReadFloat('bog', 'NAvailacro', 0);
  NInoCato := fIni.ReadFloat('bog', 'NAvailcato', 0);
  NAccCato := fIni.ReadFloat('bog', 'NAcccato', 0);
  W := fIni.ReadFloat('bog', 'W', 0);
  AvgWLMax := fIni.ReadFloat('bog','AvgWLMin',0);
  for spc:= 1 to 5 do with Species[spc] do
  begin
    NLeft := 0;
    for org:= 1 to 4 do if Organ[org] <> nil then with Organ[org] do
    begin
      CBiomass:= fIni.ReadFloat(SpcName[spc], 'CBiomass'+OrgName[org],0);
      NBiomass:= fIni.ReadFloat(SpcName[spc], 'NBiomass'+OrgName[org],0);
      CDMLvms:= fIni.ReadFloat(SpcName[spc], 'CDMLvms'+OrgName[org],0);
      NDMLvms:= fIni.ReadFloat(SpcName[spc], 'NDMLvms'+OrgName[org],0);
      CDMAcro:= fIni.ReadFloat(SpcName[spc], 'CDMAcro'+OrgName[org],0);
      NDMAcro:= fIni.ReadFloat(SpcName[spc], 'NDMAcro'+OrgName[org],0);
      CDMCato:= fIni.ReadFloat(SpcName[spc], 'CDMCato'+OrgName[org],0);
      NDMCato:= fIni.ReadFloat(SpcName[spc], 'NDMCato'+OrgName[org],0);
    end;
    SumOrgans;
  end;
  SumSpecies;
  CalcDepthAndHeight;
  CalcCover;
  TotalN := TotNBiomass+TotNDMLvms+TotNDMAcro+TotNDMCato+NAccCato+TotNleft;
  TotalC := TotCBiomass + TotCDMLvms + TotCDMAcro + TotCDMCato;
  WaterLevel;
//  BERIWaterLevel;
  for yr := 1 to 30 do WLMax30yr[yr] := AvgWLMax;
  WLPoint := 1;
  fIni.Free;
end;

procedure OpenEnv(FromYear: integer);
var
  Year: integer;
begin
  AssignFile(Fenv, InDir+InFile[ifEnv]);
  Reset(Fenv);
  Readln(Fenv);
  Readln(Fenv, Year);
  if FromYear = Year then
  begin
    Reset(Fenv);
    Readln(Fenv);
  end
  else
  begin
    Reset(Fenv);
    Readln(Fenv);
    repeat Readln(Fenv, Year) until (Year=FromYear-1);
  end;
end;

procedure ReadEnv;
var 
  YearDummy: integer;
begin
  Readln(Fenv, YearDummy, CO2, NDep);   {bij historische runs}
  NDep := NDep / 12;
//  Readln(Fenv, YearDummy, CO2);         {bij BERI runs}
end;

procedure CloseEnv;
begin
  CloseFile(Fenv);
end;

procedure OpenClim(FromYear: integer);
var
  Year: integer;
begin
  AssignFile(FClim, InDir+InFile[ifClim]);
  Reset(FClim);
  Readln(FClim);
  Readln(FClim, Year);
  if FromYear = Year then
  begin
    Reset(FClim);
    Readln(FClim);
  end
  else
  repeat Readln(FClim, Year, Month) until (Year=FromYear-1) and (Month=12);
end;

procedure ReadClim;
var
  YearDummy, MonthDummy: integer;
begin
  Readln(FClim, YearDummy,MonthDummy,Temp,Prec,Evap); {bij historische runs}
//  Readln(FClim, YearDummy,MonthDummy,Temp,Prec,NetRad,RelHum,WindSp,NDep,WAdded); {bij BERI runs}
end;

procedure CloseClim;
begin
  CloseFile(FClim);
end;

procedure OpenOutMonth;
//var spc: word;
begin
  Assignfile(Fom, OutDir+OutFile[ofMonth]);
  Rewrite(Fom);
//  WriteLn(Fom, 'climate:     '+InFile[ifClim]);
//  WriteLn(Fom, 'environment: '+InFile[ifEnv]);
//  WriteLn(Fom, 'parameters:  '+InFile[ifParam]);
//  WriteLn(Fom, 'init.val:    '+InFile[ifIniVal]);
//  WriteLn(Fom, '-------------------------------------------------------');
//  Writeln(Fom); Writeln(Fom);
//  Writeln(Fom, 'Year  Month  CBiomass PotGr  ActGr TotCBiomass TotCDMAcro, TotCDMCato TotalC');
//  Writeln(Fom, '             gram    eric    humm    lawn    holl');
end;

procedure WriteOutMonth;
var spc: word;
begin
  Write(Fom, Year:6,' ',Month:6);
//  for spc := 1 to 5 do with Species[spc] do
//    for org := 1 to 4 do with Organ[org] do if Organ[org] <> nil then
//    Write(Fom,' ',CBiomass:6:1,' ',NBiomass:6:2);
//  Write(Fom,' ',NDep:6:2,' ',Temp:6:1,' ',Prec:6:0,' ',ETRef:6:0,' ',WLevel:6:0,' ',SumEvap:6:0,' ',SumTransp:6:0);
//  Write(Fom,' ',Temp:6:1,' ',WLevel:6:0,' ',Prec:6:0,' ',ETRef:6:0,' ',SumEvap:6:0,' ',SumTransp:6:0,' ',Drain:6:0);
  for spc:= 1 to 5 do with Species[spc] do
  begin
//    Write(Fom, ' ', CBiomass:6:0);
    Write(Fom, ' ', PotGr:6:1, ' ', ActGr:6:1);
    Write(Fom, ' ', PotNUpt:6:2, ' ', ActNUPt:6:2);
    Write(Fom,' ',CDecLvms:6:0,' ',CDecAcro:6:0,' ',CDecCato:6:0);
//    Write(Fom,' ',LIntFr:6:2,' ',TGrF:6:2,' ',WGrF:6:2);
//    if PotGr > 0 then Write(Fom,' ',ActGr/PotGr:6:2) else Write(Fom,' ',1.00:6:2);
//    Write(Fom,' ',Evap:5:0,' ',Transp:5:0);
  end;
//  for spc:= gram to eric do with Species[spc] do with Organ[leaf] do
//  begin
//    Write(Fom,' ',CBiomass:6:1,' ',NBiomass:6:2);
//    if CBiomass > 0 then Write(Fom,' ',NBiomass/CBiomass:6:2) else Write(Fom,' ',-99.99:6:2);
//  end;
{  for spc:= humm to holl do with Species[spc] do with Organ[shoot] do
  begin
    if CBiomass > 0 then Write(Fom,' ',NBiomass/CBiomass:6:2) else Write(Fom,' ',-99.99:6:2);
  end;}
//  Write(Fom, ' ', TotCBiomass:6:1, ' ', TotCDMAcro:6:1,' ',TotCDMCato:6:1,' ',TotalC:6:1);
//  Write(Fom,' ',TotNMinAcro:6:2,' ',TotNminCato:6:3{,' ',NAccCato:6:2,' ',NDrain:6:2});
//  Write(Fom,' ',NAvaillvms:6:2,' ',NAvailacro:6:2,' ',NAvailcato:6:2);
//  Write(Fom,' ',TotCDecAcro:6:1,' ',TotCDecCato:6:1);
//  Write(Fom,' ',SphHGr:6:1,' ',Heightlvms:6:0,' ',DepthCato:6:0,' ',DepthAcro:6:0,' ',DepthLvms:6:0);
  Write(Fom,' ',WLevel:6:0,' ',SumEvap:6:0,' ',SumTransp:6:0,' ',Drain:6:0);
//  Write(Fom,' ',SphHGrBERI:6:1);}
  Writeln(Fom);
end;

procedure CloseOutMonth;
begin
  WriteLn(Fom, 'climate:     '+InFile[ifClim]);
  WriteLn(Fom, 'environment: '+InFile[ifEnv]);
  WriteLn(Fom, 'parameters:  '+InFile[ifParam]);
  WriteLn(Fom, 'init.val:    '+InFile[ifIniVal]);
  CloseFile(Fom);
end;

procedure OpenOutYear;
//var spc: word;
begin
  Assignfile(Foy, OutDir+OutFile[ofYear]);
  Rewrite(Foy);
//  WriteLn(Foy, 'climate:     '+InFile[ifClim]);
//  WriteLn(Foy, 'environment: '+InFile[ifEnv]);
//  WriteLn(Foy, 'parameters:  '+InFile[ifParam]);
//  WriteLn(Foy, 'init.val:    '+InFile[ifIniVal]);
//  WriteLn(Foy, '-------------------------------------------------------');
//  Writeln(Foy); Writeln(Foy);
//  Writeln(Foy, 'Year   LIntFr  TotalC  HeightLvms   DepthCato   DepthAcro   DepthLvms');
//  Writeln(Foy, '       gram    eric    humm    lawn    holl');
end;

procedure WriteOutYear;
var spc: word;
begin
  Write(Foy, Year:6);
  for spc:= 1 to 5 do with Species[spc] do
  begin
    Write(Foy,' ',LIntFr:6:2);
  end;
  for spc:= 1 to 5 do with Species[spc] do
  begin
    Write(Foy,' ',CBiomass:6:0);
  end;
//  for spc:= 1 to 2 do with Species[spc] do with Organ[leaf] do
//  begin
//    Write(Foy,' ',CBiomass:6:0);
//  end;
//  Write(Foy, ' ',TotalC:8:0);
  Write(Foy,' ',TotCBiomass:6:0,' ',TotNBiomass:6:1);
  Write(Foy,' ',TotCDMLvms:6:0,' ',TotCDMAcro:6:0,' ',TotCDMCato:6:0);
  Write(Foy,' ',TotNDMLvms:6:1,' ',TotNDMAcro:6:1,' ',TotNDMCato:6:1);
  Write(Foy,' ',NInoAcro:6:1,' ',NInoCato:6:1,' ',NAccCato:6:1);
{  for spc:= 1 to 5 do with Species[spc] do
  begin
    Write(Foy,' ',PotGr:6:1,' ',ActGr:6:1,' ',PotNUpt:6:2,' ',ActNUpt:6:2);
  end;
  Write(Foy,' ',SphHGr:6:1,' ',WLevel:6:0,' ',Prec:6:0,' ',ETRef:6:0,' ',Temp:6:1);}
//--carbon and nitrogen flows--
  for spc:= gram to holl do with Species[spc] do
  begin
    Write(Foy,' ',YrActGr:6:1);
  end;
  for spc:= gram to holl do with Species[spc] do
  begin
    Write(Foy,' ',YrActNUpt:6:2);
  end;
//    Write(Foy,' ',YrPotGr:6:1,' ',YrActGr:6:1,' ',YrPotNUpt:6:2,' ',YrActNUpt:6:2);
//    Write(Foy,' ',YrCLitPr:6:1,' ',YrNLitPr:6:2);
//  end;
//  Write(Foy,' ',YrTotActGr:6:1,' ',YrTotActNUpt:6:2,' ',YrTotCLitPr:6:1,' ',YrTotNLitPr:6:2);
  Write(Foy,' ',YrTotCDecLvms:6:1,' ',YrTotCDecAcro:6:1,' ',YrTotCDecCato:6:1);
  Write(Foy,' ',YrTotNMinLvms:6:2,' ',YrTotNMinAcro:6:2,' ',YrTotNMinCato:6:2);
  Write(Foy,' ',12*NDep:6:2,' ',YrNDrain:6:2);
//---------------
  Write(Foy,' ',DepthLvms:6:0,' ',DepthAcro:6:0,' ',DepthCato:6:0,' ',Heightlvms:6:0);
  Write(Foy,' ',-MeanWL:6:0,' ',-MinWL:6:0,' ',-MaxWL:6:0,' ',MeanTemp:6:1);
  for spc:= gram to holl do with Species[spc] do
  begin
    Write(Foy,' ',YrTWGrF:6:1);
    if YrPotGr>0 then Write(Foy,' ',1-YrActGr/YrPotGr:6:2) else Write(Foy,' ',0.00:6:2);
  end;
//--water flows--
  Write(Foy,' ',W:6:0,' ',YrETRef:6:0,' ',YrET:6:0,' ', YrEvap:6:0,' ', YrTransp:6:0,' ',YrPrec:6:0,' ',YrDrain:6:0);
//  Write(Foy,' ',DepthAcro:6:0,' ',MaxDepthAcro:6:0,' ',AvgWLMax:6:0);
//---------------
  Writeln(Foy);
end;

procedure CloseOutYear;
begin
  WriteLn(Foy, 'climate:     '+InFile[ifClim]);
  WriteLn(Foy, 'environment: '+InFile[ifEnv]);
  WriteLn(Foy, 'parameters:  '+InFile[ifParam]);
  WriteLn(Foy, 'init.val:    '+InFile[ifIniVal]);
  CloseFile(Foy);
end;

end.
