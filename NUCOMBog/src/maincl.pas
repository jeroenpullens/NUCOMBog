unit maincl;

interface

uses
  SysUtils, inifiles;

procedure Start;  
procedure ReadInOutFiles;
procedure WriteInOutFiles;

implementation

uses plant, water, readwrite;

procedure ReadInOutFiles;
var
  fIni: TIniFile;
begin
  fIni:= TIniFile.Create(ModelDir+'/'+'Filenames');
  InDir := fini.ReadString('in','directory','input/');
  OutDir := fini.ReadString('out','directory','output/');
  InFile[ifClim] := fini.ReadString('in','climate','ClimLVMhis.txt');
  InFile[ifEnv] := fini.ReadString('in','environment','EnvLVMhis.txt');
  InFile[ifParam] := fini.ReadString('in','parameters','param.txt');
  InFile[ifIniVal] := fini.ReadString('in','initval','InivalLVMhis.txt');
  OutFile[ofMonth] := fini.ReadString('out','month','outmoLVMhis.txt');
  OutFile[ofYear] := fini.ReadString('out','year','outyrLVMhis.txt');
  FromYeartext:= fini.ReadString('year','start','1766');
  ToYeartext:= fini.ReadString('year','end','1999');
end;

procedure WriteInOutFiles;
var
  fIni: TIniFile;
begin
  fIni:= TIniFile.Create(ModelDir+'/'+'Filenames');
  fini.WriteString('in','directory',InDir);
  fini.WriteString('out','directory',OutDir);
  fini.WriteString('in','climate',InFile[ifClim]);
  fini.WriteString('in','environment',InFile[ifEnv]);
  fini.WriteString('in','parameters',InFile[ifParam]);
  fini.WriteString('in','initval',InFile[ifIniVal]);
  fini.WriteString('out','month',OutFile[ofMonth]);
  fini.WriteString('out','year',OutFile[ofYear]);
  fini.WriteString('year','start',FromYeartext);
  fini.WriteString('year','end',ToYeartext);
end;


procedure Start;
var
  LoopYear, LoopMonth, FromYear, ToYear: integer;
begin
//-- first reset variables for output files to zero values --
  CreatePlants; {in unit plant}
  Year:=0; Month:=0;
  SumEvap:=0; SumTransp:=0; Drain:=0;
  YrTotCDecLvms:=0; YrTotCDecAcro:=0; YrTotCDecCato:=0;
  YrTotNMinLvms:=0; YrTotNMinAcro:=0; YrTotNMinCato:=0;
  NDep:=0; YrNDrain:=0;
  MeanWL:=0; MinWL:=0; MaxWL:=0; MeanTemp:=0;
  YrETRef:=0; YrET:=0; YrPrec:=0; YrDrain:=0;

  FromYear:=StrToIntDef(FromYeartext,1998);
  ToYear:=StrToIntDef(ToYeartext,2000);
  ReadParam; {in unit readwrite}
//-- let op bij uitsluiten bepaalde soorten: --
//  Species[humm].MaxGr := 0;
//  Species[lawn].MaxGr := 0;
//----------------------------------------------
//  ShowSomeParam;
  ReadIniVal; {in unit readwrite}
//  ShowSomeIniVal;
  OpenEnv(FromYear); {in unit readwrite}
//  Memo3.Clear;
//  Memo3.lines.add('Year   CO2  NDep');
  OpenClim(FromYear); {in unit readwrite}
//  Memo4.Clear;
//  Memo4.lines.add('Year Month Temp');
//  Memo5.Clear;
//  Memo5.lines.add('  CBiomass');
  OpenOutMonth; {in unit readwrite}
  WriteOutMonth; {in unit readwrite}
  OpenOutYear; {in unit readwrite}
  WriteOutYear; {in unit readwrite}

  for LoopYear := FromYear to ToYear do
  begin
    Year:= LoopYear;
    ReadEnv; {in unit readwrite}
//    CO2 := 280;
//    NDep := 3/12;
//    ShowEnv;
    for LoopMonth := 1 to 12 do
    begin
      Month:= LoopMonth;
      ReadClim; {in unit readwrite}
//      ShowClim;
//-- Attention! when changing climate --
//      Temp := Temp - 2;
//      Evap := 0.93*Evap;
//      Prec := Prec - 10;
//      Prec := MAX(Prec,0);
//--------------------------------------
      CalcWater; {in unit water}
//      CalcBERIWater; {in unit water}
      CalcPlant; {in unit plant}
      WriteOutMonth; {in unit readwrite}
//      if Month = 8 then WriteOutYear; {in unit readwrite}
      //Application.ProcessMessages;
    end;
    WriteOutYear; {in unit readwrite}
//    ShowPlant;
  end;

  CloseEnv;
  CloseClim;
  CloseOutMonth;
  CloseOutYear;
end;

{

procedure TModelForm.ShowSomeParam;
var spc, org: word;
begin
  memo1.clear;
  Memo1.lines.add(' Mu cato:'+FloatToStr(MuCato));
  Memo1.lines.add(' Mu acro:'+FloatToStr(MuAcro));
  Memo1.lines.add(' Mu lvms:'+FloatToStr(MuLvms));
  for spc:= 1 to 5 do
  with Species[spc] do
  begin
    Memo1.lines.add(spcname[spc]+':');
    Memo1.lines.add('  beta: '+floatToStr(beta));
    Memo1.lines.add('  KExt: '+floatToStr(KExt));
    Memo1.lines.add('  Cropfactor: '+floatToStr(CropFc));
//    for org:= 1 to 4 do if Organ[org] <> nil then
//      Memo1.lines.add('  '+orgname[org]+': alloc = '+formatfloat('0.00',organ[org].CAllocFr));
  end;
end;

procedure TModelForm.ShowSomeIniVal;
var spc, org: word;
begin
  memo2.clear;
  Memo2.lines.add(' Depth cato:'+FloatToStr(DepthCato));
  Memo2.lines.add(' Depth acro:'+FloatToStr(DepthAcro));
  Memo2.lines.add(' Depth lvms:'+FloatToStr(DepthLvms));
  Memo2.lines.add(' Water level:'+FloatToStr(WLevel));
  for spc:= 1 to 5 do
  with Species[spc] do
  begin
    Memo2.lines.add(spcname[spc]+':');
    Memo2.lines.add('  CBiomass: '+floatToStr(CBiomass));
    Memo2.lines.add('  Cover: '+floatToStr(Cover));
  end;
end;

procedure TModelForm.ShowEnv;
begin
  Memo3.lines.add(IntToStr(year)+': '+FormatFloat('0.0',CO2)+' '+FormatFloat('0.0',NDep));
end;

procedure TModelForm.ShowClim;
begin
  Memo4.lines.add(IntToStr(year)+' '+IntToStr(Month)+': '+FormatFloat('0.0',Temp));
end;

procedure TModelForm.ShowPlant;
var spc: word;
begin
  Memo5.lines.add(IntToStr(year)+': ');
//  Memo5.lines.add('Water level: '+FormatFloat('0',WLevel));
//  Memo5.lines.add('NDrain: '+FormatFloat('0.0',NDrain));
//  Memo5.lines.add('NAcc: '+FormatFloat('0.0',NAccCato));
  for spc:= 1 to 5 do with Species[spc] do
  begin
    Memo5.lines.add(SpcName[spc]+': ');
    Memo5.lines.add('LIntFr: '+FormatFloat('0.00',LIntFr));
//    Memo5.lines.add('Cover: '+FormatFloat('0.00', Cover));
  end;
  Memo5.lines.add('Total C: '+FormatFloat('0',TotalC));
end;

}
end.
