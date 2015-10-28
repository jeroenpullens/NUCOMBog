unit plant;

{$MODE Delphi}

interface

uses Math;

const
  gram = 1; eric = 2; humm = 3; lawn = 4; holl = 5;
  leaf = 1; stem = 2; root = 3; shoot = 4;
  SpcName: array[1..5] of string = ('gram', 'eric', 'humm', 'lawn', 'holl');
  OrgName: array[1..4] of string = ('leaf','stem','root','shoot');
  TimeStep = 1; MinCover = 0.001; MinLeafArea = 0.001;

type
  TOrgan = class(TObject)
    CBiomass, NBiomass, CDMLvms, NDMLvms, CDMAcro, NDMAcro, CDMCato, NDMCato: real;
    Growth, NUptake, NReall, CLPLvms, CLPAcro, CLPCato, NLPLvms, NLPAcro, NLPCato: real;
    CDecLvms, CDecAcro, CDecCato, NMinLvms, NMinAcro, NMinCato: real;
    NImmLvms, NImmAcro, NImmCato: real;
    CAllocFr, NAllocFr, MortFrLvms, MortFrAcro, MortFrCato, ReallFr: real;
    DecParLvms, DecParAcro, DecParCato, BDLvms, BDAcro, BDCato: real;
    PotCBiomass, PotNBiomass, PotCDMAcro, PotNDMAcro: real;
    CTransfAcro, NTransfAcro, CTransfCato, NTransfCato: real;
    procedure LitterProduction;
    procedure Decomposition;
    procedure NMineralization;
    procedure UpdateCAndNPools;
  end;
  TSpecies = class(TObject)
    Organ: array[1..4] of TOrgan;
    CBiomass, NBiomass, CDMLvms, NDMLvms, CDMAcro, NDMAcro, CDMCato, NDMCato: real;
    LeafArea, LIntFr, Cover, PotNUpt, PotGr, ActGr, ActNUpt, NReall, NLeft: real;
    NMinLvms, NMinAcro, NMinCato, CDecLvms, CDecAcro, CDecCato, PotHGr: real;
    NImmLvms, NImmAcro, NImmCato: real;
    CLitPr, NLitPr, CTransfAcro, NTransfAcro, CTransfCato, NTransfCato: real;
    YrPotGr, YrActGr, YrPotNUpt, YrActNUpt, YrCLitPr, YrNLitPr, YrWGrF, YrTGrF, YrTWGrF: real;
    SLA, KExt, CropFc: real;
    MaxGr, TMinGr, TOpt1Gr, TOpt2Gr, TMaxGr, WLMin, WLOpt1, WLOpt2, WLMax, Beta: real;
    NConcMin, NConcMax: real;
    Evap, Transp, WkEvap, WkTransp, WEvF, WTrF, CO2TrF: real;
    function  CO2GrF:real;
    function  WGrF:real;
    function  TGrF:real;
    procedure SumOrgans;
    procedure PotentialGrowth;
    procedure ActualGrowthAndNUptake;
    procedure Allocation;
  end;
var
  Species: array[1..5] of TSpecies;
  Year, Month: integer;
  CO2, NDep: real;
  Temp: real;
  CO2ref, FixDepthLcnp, FixDepthTcnp, MinDepthLvms, MaxDepthLvms, MaxDepthAcro: real;
  TDecParLvms, TDecParAcro, TDecParCato, TOptDec, decparam1above, decparam2above, decparam1below, decparam2below: real;
  CritNCLvms, CritNCACro, CritNCCato, MicrEffLvms, MicrEffAcro, MicrEffCato: real;
  WLevel, AvgWLMax, SphHGr, SphHGrBERI, YrSphHGr: real;
  LAvFrtcnp, LAvFrlcnp, LAvFrlvms: real;
  NAvaillvms, NAvailacro, NAvailcato, NDrain, WkNDrain, YrNDrain: real;
  DepthTcnp, DepthLcnp, DepthLvms, DepthAcro, DepthCato: real;
  HeightTcnp, HeightLcnp, HeightLvms, HeightAcro, HeightCato: real;
  TotCBiomass, TotNBiomass, TotCDMLvms, TotNDMLvms, TotCDMAcro, TotNDMAcro, TotCDMCato, TotNDMCato: real;
  PeatLIntFr, MossActNUpt, MossNLeft, MossCover: real;
  NInoAcro, NInoCato, NAcccato, TotNMinLvms, TotNMinAcro, TotNMinCato, TotalN: real;
  TotCDecLvms, TotCDecAcro, TotCDecCato, TotActGr, TotActNUpt, TotNLeft, TotalC: real;
  TotCLitPr, TotNLitPr, TotCTransfAcro, TotNTransfAcro, TotCTransfCato, TotNTransfCato: real;
  YrTotNMinLvms, YrTotNMinAcro, YrTotNMinCato, YrTotCDecLvms, YrTotCDecAcro, YrTotCDecCato, YrTotActGr: real;
  YrTotActNUpt, YrTotCLitPr, YrTotNLitPr, YrTotCTransfCato, YrTotNTransfCato: real;
  YrETRef, YrET, YrEvap, YrTransp, YrDrain, YrPrec: real;

procedure CreatePlants;
procedure CalcPlant;
procedure CalcDepthAndHeight;
procedure CalcCover;
procedure CheckTotalN;
procedure CheckTotalC;
procedure LightInterception;
procedure PotentialNUptake;
procedure MossGrowth;
procedure AdditionalMossLitterProduction;
procedure AdditionalVascLitterProduction;
procedure TransferFromLvmsToAcro;
procedure TransferFromAcroToCato;
procedure SumSpecies;
procedure CalcNAvail;
procedure SumForYearTotal;
procedure UpdateNIno;

implementation

procedure CreatePlants;
var spc, org: word;
begin
  for spc := gram to eric do
  begin
    Species[spc]:= TSpecies.Create;
    with Species[spc] do
    begin
      for org:= leaf to root do
      begin
        Organ[org]:= TOrgan.Create;
      end;
    end;
  end;
  for spc:= humm to holl do
  begin
    Species[spc]:= TSpecies.Create;
    with Species[spc] do
    begin
      Organ[shoot]:= TOrgan.Create;
    end;
  end;
end;

procedure CalcPlant;
var
  spc, org: word;
begin
  for spc:= gram to holl do with Species[spc] do
  begin
    for org := leaf to shoot do if Organ[org] <> nil then with Organ[org] do
    begin
      LitterProduction;
      Decomposition;
      NMineralization;
    end;
    SumOrgans;
  end;
  SumSpecies;
  CalcNAvail;
  LightInterception;
  PotentialNUptake;
  for spc:= gram to holl do with Species[spc] do
  begin
    PotentialGrowth;
    ActualGrowthAndNUptake;
    Allocation;
  end;
  MossGrowth;
  AdditionalMossLitterProduction;
  AdditionalVascLitterProduction;
  TransferFromLvmsToAcro;
  TransferFromAcroToCato;
  for spc:= 1 to 5 do with Species[spc] do
  begin
    for org := 1 to 4 do if Organ[org] <> nil then with Organ[org] do
    begin
      UpdateCAndNPools;
    end;
    SumOrgans;
  end;
  SumSpecies;
  UpdateNIno;
  CalcDepthAndHeight;
  CalcCover;
  SumForYearTotal;
  CheckTotalN;
  CheckTotalC;
end;

procedure UpdateNIno;
begin
  NInoAcro := MossNLeft*TimeStep;
 {als niet opgenomen N niet meer beschikbaar is voor gram, in historische runs}
  NInoCato := Species[eric].NLeft * TimeStep;
  NAcccato := NAcccato + Species[gram].NLeft * TimeStep;
 {als niet opgenomen N beschikbaar blijft voor gram, in BERI runs}
//  NInoCato := (Species[gram].NLeft+Species[eric].NLeft)*TimeStep;
//  NAccCato := 0;
end;

procedure CalcNAvail;
begin
  NAvaillvms := MossCover * NDep + TotNMinLvms - NDrain;
  NAvailacro := (1-MossCover) * NDep + NInoAcro + TotNMinAcro;
  NAvailcato := NInoCato + TotNMinCato;
end;

procedure LightInterception;
var spc: word;
begin
  with Species[gram] do
  begin
    LAvFrtcnp := 1;
    LeafArea := MAX(Organ[leaf].CBiomass * SLA, MinLeafArea);
    LIntFr := LAvFrtcnp * (1 - EXP(-KExt * LeafArea));
    LAvFrlcnp := LAvFrtcnp - LIntFr;
  end;
  with Species[eric] do
  begin
    LeafArea := MAX(Organ[leaf].CBiomass * SLA, MinLeafArea);
    LIntFr := LAvFrlcnp * (1 - EXP(-KExt * LeafArea));
    LAvFrlvms := LAvFrlcnp - LIntFr;
  end;
  for spc := humm to holl do with Species[spc] do
  begin
    LIntFr := LAvFrlvms * Cover;
  end;
  PeatLIntFr := (1 - MossCover) * LAvFrlvms;
end;

procedure PotentialNUptake;
var spc: word;
begin
  with Species[gram] do
  begin
    PotNUpt := MAX(0,NAvailcato);
  end;
  with Species[eric] do
  begin
    PotNUpt := MAX(0,NAvailacro);
  end;
  for spc := humm to holl do with Species[spc] do
  begin
    PotNUpt := MAX(0,NAvaillvms*Cover/MossCover);
  end;
end;

procedure MossGrowth;
var spc: word;
  SumCovTHGr, SumCovTHGrBERI, PotHGrBERI, SumCover: real;
begin
  SumCovTHGr := 0;
  SumCovTHGrBERI := 0;
  SumCover := 0;
  for spc := humm to holl do with Species[spc] do
  begin
    PotHGr := (ActGr-Organ[shoot].CLPAcro)/Cover/Organ[shoot].BDLvms;
    PotHGrBERI := ActGr/Cover/Organ[shoot].BDLvms;
    SumCovTHGr := SumCovTHGr + PotHGr * Cover;
    SumCovTHGrBERI := SumCovTHGrBERI + PotHGrBERI * Cover;
    SumCover := SumCover + Cover;
  end;
  SphHGr := SumCovTHGr/SumCover;
  SphHGrBERI := SumCovTHGrBERI/SumCover;
end;

procedure AdditionalMossLitterProduction;
var spc: word;
  PotDepthlvms: real;
begin
  PotDepthlvms := Depthlvms + SphHGr;
  if PotDepthlvms > MaxDepthlvms then
  for spc := humm to holl do with Species[spc].Organ[shoot] do
  begin
    PotCBiomass := CBiomass + (Growth - CLPAcro) * TimeStep;
    PotNBiomass := NBiomass + (NUptake - NLPAcro) * TimeStep;
    CLPAcro := CLPAcro + ((PotDepthlvms-MaxDepthlvms)/PotDepthlvms)*PotCBiomass/TimeStep;
    NLPAcro := NLPAcro + ((PotDepthlvms-MaxDepthlvms)/PotDepthlvms)*PotNBiomass/TimeStep;
  end;
end;

procedure AdditionalVascLitterProduction;
var CLPAddLvms, NLPAddLvms: real;
begin
  Depthlcnp := FixDepthlcnp;
  if SphHGr > 0 then
  with Species[eric].Organ[leaf] do
  begin
    PotCBiomass := CBiomass - CLPLvms * TimeStep;
    PotNBiomass := NBiomass - NLPLvms * TimeStep;
    CLPAddLvms := (((SphHGr*TimeStep)/Depthlcnp)*PotCBiomass)/TimeStep;
    NLPAddLvms := (((SphHGr*TimeStep)/Depthlcnp)*PotNBiomass)/TimeStep;
    CLPLvms := CLPLvms + CLPAddLvms;
    NLPLvms := NLPLvms + NLPAddLvms;
  end;
end;

procedure TransferFromLvmsToAcro;
var
  MossCBiomass, MossNBiomass, MossCLPAcro, MossNLPAcro: real;
  spc: word;
begin
  MossCLPAcro := 0; MossCBiomass := 0;
  MossNLPAcro := 0; MossNBiomass := 0;
  for spc := humm to holl do with Species[spc].Organ[shoot] do
  begin
    MossCLPAcro := MossCLPAcro + CLPAcro;
    MossCBiomass := MossCBiomass + CBiomass;
    MossNLPAcro := MossNLPAcro + NLPAcro;
    MossNBiomass := MossNBiomass + NBiomass;
  end;
  for spc := gram to eric do with Species[spc].Organ[leaf] do
  begin
    CTransfAcro := MossCLPAcro / MossCBiomass * CDMLvms;
    NTransfAcro := MossNLPAcro / MossNBiomass * NDMLvms;
  end;
end;

procedure TransferFromAcroToCato;
var spc, org: word;
  PotDepthAcro: real;
begin
{first calculate potential acrotelm depth,
 than everything in excess of maximum acrotelm depth goes to catotelm}
  MaxDepthAcro := MAX(0,AvgWLMax - DepthLvms);
  PotDepthAcro := 0;
  for spc := gram to holl do with Species[spc] do
  begin
    for org := leaf to shoot do if Organ[org] <> nil then with Organ[org] do
    begin
      PotCDMAcro := CDMAcro + (CLPAcro - CDecAcro) * TimeStep;
      PotNDMAcro := NDMAcro + (NLPAcro - NMinAcro) * TimeStep;
      PotDepthAcro := PotDepthAcro + PotCDMAcro / BDAcro;
    end;
  end;
  for spc := gram to holl do with Species[spc] do
  begin
    for org := leaf to shoot do if Organ[org] <> nil then with Organ[org] do
      if PotDepthAcro > MaxDepthAcro then
      begin
        CTransfCato := (PotDepthAcro-MaxDepthAcro)/PotDepthAcro*PotCDMAcro;
        NTransfCato := (PotDepthAcro-MaxDepthAcro)/PotDepthAcro*PotNDMAcro;
      end
      else
      begin
        CTransfCato := 0; NTransfCato := 0;
      end;
  end;
end;

procedure SumSpecies;
var spc: word;
begin
  TotCBiomass := 0;  TotNBiomass := 0;
  TotCDMLvms := 0;   TotNDMLvms := 0;
  TotCDMAcro := 0;   TotNDMAcro := 0;
  TotCDMCato := 0;   TotNDMCato := 0;
  TotNMinLvms := 0; TotNMinAcro := 0;  TotNMinCato := 0;
  TotCDecLvms := 0; TotCDecAcro := 0;  TotCDecCato := 0;
  TotActGr := 0; TotActNUpt := 0; TotNLeft := 0;
  TotCLitPr := 0; TotNLitPr := 0;
  TotCTransfCato := 0; TotNTransfCato := 0;
  MossActNUpt := 0; MossNLeft := 0; MossCover := 0;
  for spc := gram to holl do with Species[spc] do
  begin
    TotCBiomass := TotCBiomass + CBiomass;
    TotNBiomass := TotNBiomass + NBiomass;
    TotCDMLvms := TotCDMLvms + CDMLvms;
    TotNDMLvms := TotNDMLvms + NDMLvms;
    TotCDMAcro := TotCDMAcro + CDMAcro;
    TotNDMAcro := TotNDMAcro + NDMAcro;
    TotCDMCato := TotCDMCato + CDMCato;
    TotNDMCato := TotNDMCato + NDMCato;
    TotNMinLvms := TotNMinLvms + NMinLvms;
    TotNMinAcro := TotNMinAcro + NMinAcro;
    TotNMinCato := TotNMinCato + NMinCato;
    TotCDecLvms := TotCDecLvms + CDecLvms;
    TotCDecAcro := TotCDecAcro + CDecAcro;
    TotCDecCato := TotCDecCato + CDecCato;
    TotActGr := TotActGr + ActGr;
    TotActNUpt := TotActNUpt + ActNUpt;
    TotNLEft := TotNLeft + NLeft;
    TotCLitPr := TotCLitPr + CLitPr;
    TotNLitPr := TotNLitPr + NLitPr;
    TotCTransfCato := TotCTransfCato + CTransfCato;
    TotNTransfCato := TotNTransfCato + NTransfCato;
  end;
  for spc := humm to holl do with Species[spc] do
  begin
    MossActNUpt := MossActNUpt + ActNUpt;
    MossNLeft := MossNLeft + NLeft;
    MossCover := MossCover + Cover;
  end;
end;

procedure CalcDepthAndHeight;
var spc, org: word;
  SumDepthLvms : real;
begin
  DepthCato := 0;
  DepthAcro := 0;
  SumDepthLvms := 0;
  for spc := gram to holl do with Species[spc] do
  begin
    for org := leaf to shoot do if Organ[org] <> nil then with Organ[org] do
    begin
      DepthCato := DepthCato + CDMCato / BDCato;
      DepthAcro := DepthAcro + CDMAcro / BDAcro;
    end;
  end;
  for spc := humm to holl do with Species[spc] do
  begin
    SumDepthLvms := SumDepthLvms + CBiomass / Organ[shoot].BDLvms;
  end;
  DepthLvms := MAX(SumDepthLvms, MinDepthLvms);
//  DepthLvms := SumDepthLvms;
  DepthLcnp := FixDepthLcnp;
  DepthTcnp := FixDepthTcnp;
  HeightCato := DepthCato;
  HeightAcro := HeightCato + DepthAcro;
  HeightLvms := HeightAcro + DepthLvms;
  HeightLcnp := HeightLvms + DepthLcnp;
  HeightTcnp := HeightLcnp + DepthTcnp;
end;

procedure CalcCover;
var spc: word;
begin
  for spc := humm to holl do with Species[spc] do
  begin
    If DepthLvms > 0 then
    Cover := MAX(CBiomass / DepthLvms / Organ[shoot].BDLvms, MinCover)
    else Cover := MinCover;
  end;
end;

procedure SumForYearTotal;
var spc: word;
begin
  if Month = 1 then
  begin
    for spc := gram to holl do with Species[spc] do
    begin
      YrPotGr := PotGr; YrActGr := ActGr;
      YrPotNUpt := PotNUpt; YrActNUpt := ActNUpt;
      YrCLitPr := CLitPr; YrNLitPr := NLitPr;
      YrWGrF := WGrF; YrTGrF := TGrF; YrTWGrF := TGrF * WGrF;
    end;
    YrTotNMinLvms:= TotNMinLvms; YrTotNMinAcro:=TotNMinAcro; YrTotNMinCato:=TotNMinCato;
    YrTotCDecLvms:= TotCDecLvms; YrTotCDecAcro:=TotCDecAcro; YrTotCDecCato:=TotCDecCato;
    YrTotActGr := TotActGr; YrTotActNUpt := TotActNUpt;
    YrTotCLitPr := TotCLitPr; YrTotNLitPr := TotNLitPr;
    YrTotCTransfCato := TotCTransfCato; YrTotNTransfCato := TotNTransfCato;
    YrSphHGr := SphHGr;
    YrNDrain:= NDrain;
  end
  else
  begin
    for spc := gram to holl do with Species[spc] do
    begin
      YrPotGr := YrPotGr + PotGr;
      YrActGr := YrActGr + ActGr;
      YrPotNUpt := YrPotNUpt + PotNUpt;
      YrActNUpt := YrActNUpt + ActNUpt;
      YrCLitPr := YrCLitPr + CLitPr;
      YrNLitPr := YrNLitPr + NLitPr;
      YrWGrF := YrWGrF + WGrF; YrTGrF := YrTGrF + TGrF;
      YrTWGrF := YrTWGrF + TGrF * WGrF;
    end;
    YrTotNMinLvms := YrTotNMinLvms + TotNMinLvms;
    YrTotNMinAcro := YrTotNMinAcro + TotNMinAcro;
    YrTotNMinCato := YrTotNMinCato + TotNMinCato;
    YrTotCDecLvms := YrTotCDecLvms + TotCDecLvms;
    YrTotCDecAcro := YrTotCDecAcro + TotCDecAcro;
    YrTotCDecCato := YrTotCDecCato + TotCDecCato;
    YrTotActGr := YrTotActGr + TotActGr;
    YrTotActNUpt := YrTotActNUpt + TotActNUpt;
    YrTotCLitPr := YrTotCLitPr + TotCLitPr;
    YrTotNLitPr := YrTotNLitPr + TotNLitPr;
    YrTotCTransfCato := YrTotCTransfCato + TotCTransfCato;
    YrTotNTransfCato := YrTotNTransfCato + TotNTransfCato;
    YrSphHGr := YrSphHGr + SphHGr;
    YrNDrain := YrNDrain + NDrain;
  end;
end;

procedure CheckTotalN;
var
  OldTotalN, NewTotalN: real;
begin
  OldTotalN := TotalN;
//  NewTotalN := TotNBiomass+TotNDMAcro+TotNDMCato+NAccCato+NAvailAcro+NAvailCato;
  NewTotalN := TotNBiomass+TotNDMLvms+TotNDMAcro+TotNDMCato+NInoAcro+NInoCato+NAccCato;
  if ABS((NewTotalN - OldTotalN) - (Ndep - NDrain)) > 0.01 then
//  writeln('Something is wrong with N-balans!');
//  showmessage('Something is wrong with N-balans!');
  TotalN := NewTotalN;
end;

procedure CheckTotalC;
var
  OldTotalC, NewTotalC: real;
begin
  OldTotalC := TotalC;
  NewTotalC := TotCBiomass+TotCDMLvms+TotCDMAcro+TotCDMCato;
  if ABS((NewTotalC-OldTotalC)-(TotActGr-TotCDecLvms-TotCDecAcro-TotCDecCato))> 0.01 then
//  writeln('Something is wrong with N-balans!');
//  showmessage('Something is wrong with C-balans!');
  TotalC := NewTotalC;
end;

procedure TSpecies.SumOrgans;
var
  SumCBiomass, SumNBiomass, SumCDMLvms, SumNDMLvms: real;
  SumCDMAcro, SumNDMAcro, SumCDMCato, SumNDMCato: real;
  SumNMinLvms, SumNMinAcro, SumNMinCato: real;
  SumNImmLvms, SumNImmAcro, SumNImmCato: real;
  SumCDecLvms, SumCDecAcro, SumCDecCato: real;
  SumCLP, SumNLP, SumNReall, SumCTransfCato, SumNTransfCato: real;
  org: word;
begin
  SumCBiomass := 0;  SumNBiomass := 0;
  SumCDMLvms := 0;   SumNDMLvms := 0;
  SumCDMAcro := 0;   SumNDMAcro := 0;
  SumCDMCato := 0;   SumNDMCato := 0;
  SumNMinLvms := 0; SumNMinAcro := 0; SumNMinCato := 0;
  SumNImmLvms := 0; SumNImmAcro := 0; SumNImmCato := 0;
  SumCDecLvms := 0; SumCDecAcro := 0; SumCDecCato := 0;
  SumCLP := 0; SumNLP := 0; SumNReall := 0;
  SumCTransfCato := 0; SumNTransfCato := 0;
  for org := 1 to 4 do if Organ[org] <> nil then with Organ[org] do
  begin
    SumCBiomass := SumCBiomass + CBiomass;
    SumNBiomass := SumNBiomass + NBiomass;
    SumCDMLvms := SumCDMLvms + CDMLvms;
    SumNDMLvms := SumNDMLvms + NDMLvms;
    SumCDMAcro := SumCDMAcro + CDMAcro;
    SumNDMAcro := SumNDMAcro + NDMAcro;
    SumCDMCato := SumCDMCato + CDMCato;
    SumNDMCato := SumNDMCato + NDMCato;
    SumNMinLvms := SumNMinLvms + NMinLvms;
    SumNMinAcro := SumNMinAcro + NMinAcro;
    SumNMinCato := SumNMinCato + NMinCato;
    SumNImmLvms := SumNImmLvms + NImmLvms;
    SumNImmAcro := SumNImmAcro + NImmAcro;
    SumNImmCato := SumNImmCato + NImmCato;
    SumCDecLvms := SumCDecLvms + CDecLvms;
    SumCDecAcro := SumCDecAcro + CDecAcro;
    SumCDecCato := SumCDecCato + CDecCato;
    SumCLP := SumCLP + CLPLvms + CLPAcro + CLPCato;
    SumNLP := SumNLP + NLPLvms + NLPAcro + NLPCato;
    SumNReall := SumNReall + NReall;
    SumCTransfCato := SumCTransfCato + CTransfCato;
    SumNTransfCato := SumNTransfCato + NTransfCato;
  end;
  CBiomass := SumCBiomass;  NBiomass := SumNBiomass;
  CDMLvms := SumCDMLvms;    NDMLvms := SumNDMLvms;
  CDMAcro := SumCDMAcro;    NDMAcro := SumNDMAcro;
  CDMCato := SumCDMCato;    NDMCato := SumNDMCato;
  NMinLvms := SumNMinLvms; NMinAcro := SumNMinAcro; NMinCato := SumNMinCato;
  NImmLvms := SumNImmLvms; NImmAcro := SumNImmAcro; NImmCato := SumNImmCato;
  CDecLvms := SumCDecLvms; CDecAcro := SumCDecAcro; CDecCato := SumCDecCato;
  CLitPr := SumCLP; NLitPr := SumNLP; NReall := SumNReall;
  CTransfCato := SumCTransfCato; NTransfCato := SumNTransfCato;
end;

function TSpecies.CO2GrF:real;
begin
  Result:= (1 + Beta*LN(CO2/CO2ref));
end;

function TSpecies.TGrF: real;
begin
  if Temp < TMinGr then Result:= 0
  else if Temp < TOpt1Gr then Result:= (Temp-TMinGr)/(TOpt1Gr-TminGr)
  else if Temp < TOpt2Gr then Result:= 1
  else if Temp < TMaxGr then Result:= (TmaxGr-Temp)/(TmaxGr-TOpt2Gr)
  else Result := 0
end;

function TSpecies.WGrF: real;
begin
  if WLevel < WLMin then Result:= 0
  else if WLevel < WLOpt1 then Result:= (WLevel-WLMin)/(WLOpt1-WLMin)
  else if WLevel < WLOpt2 then Result:= 1
  else if WLevel < WLMax then Result:= (WLMax-WLevel)/(WLMax-WLOpt2)
  else Result := 0
end;

procedure TSpecies.PotentialGrowth;
begin
  PotGr:= LIntFr * MaxGr * CO2GrF * TGrF * WGrF;
end;

procedure TSpecies.ActualGrowthAndNUptake;
begin
  if PotNUpt < NConcMin * PotGr then
//  if (PotNUpt + NReall) < NConcMin * PotGr then
  begin
    ActGr := PotNUpt / NConcMin;
//    ActGr := (PotNUpt + NReall) / NConcMin;
    ActNUpt := PotNUpt;
  end
  else if PotNUpt < NConcMax * PotGr then
//  else if (PotNUpt + NReall) < NConcMax * PotGr then
  begin
    ActGr:= PotGr;
    ActNUpt := PotNUpt;
  end
  else
  begin
    ActGr := PotGr;
    ActNUpt := PotGr * NConcMax;
//    ActNUpt := MAX(0, PotGr * NConcMax - NReall);
  end;
  NLeft := PotNUpt - ActNUpt;
end;

procedure TSpecies.Allocation;
var org: word;
begin
  for org := 1 to 4 do if Organ[org] <> nil then
  begin
  Organ[org].Growth:= Organ[org].CAllocFr * ActGr;
  Organ[org].NUptake := Organ[org].NAllocFr * ActNUpt;
  end;
end;

procedure TOrgan.LitterProduction;
begin
  CLPLvms := MortFrLvms * CBiomass;
  NLPLvms := (1-ReallFr) * MortFrLvms * NBiomass;
  CLPAcro := MortFrAcro * CBiomass;
  NLPAcro := (1-ReallFr) * MortFrAcro * NBiomass;
  CLPCato := MortFrCato * CBiomass;
  NLPCato := (1-ReallFr) * MortFrCato * NBiomass;
  NReall := (1-ReallFr) * (MortFrAcro + MortFrCato) * NBiomass;
end;

procedure TOrgan.Decomposition;
begin

  CDecLvms := CDMLvms*DecParLvms*EXP(decparam1above+decparam2above*Temp*(1-0.5*Temp/TOptDec));
  CDecAcro := CDMAcro*DecParAcro*EXP(decparam1above+decparam2above*Temp*(1-0.5*Temp/TOptDec));
 CDecCato := CDMCato*DecParCato*EXP(decparam1below+decparam2below*Temp*(1-0.5*Temp/TOptDec));
//  CDecLvms := CDMLvms*DecParLvms*EXP(-3.764+0.204*Temp*(1-0.5*Temp/36.9));
//  CDecAcro := CDMAcro*DecParAcro*EXP(-3.764+0.204*Temp*(1-0.5*Temp/36.9));
//  CDecCato := CDMCato*DecParCato*EXP(-1.882+0.102*Temp*(1-0.5*Temp/36.9));

end;

procedure TOrgan.NMineralization;
begin
  if CDMLvms > 0 then
  NMinLvms := (NDMLvms/CDMLvms-CritNCLvms)*CDecLvms/(1-MicrEffLvms)
  else NMinLvms := 0;
  if CDMAcro > 0 then
  NMinAcro := (NDMAcro/CDMAcro-CritNCAcro)*CDecAcro/(1-MicrEffAcro)
  else NMinAcro := 0;
  if CDMCAto >0 then
  NMinCato := (NDMCato/CDMCato-CritNCCato)*CDecCato/(1-MicrEffCato)
  else NMinCato := 0;
  if NMinLvms < 0 then
  begin
    NImmLvms := MIN(-NMinLvms, NDep);
    NDep := NDep - NImmLvms;
    NMinLvms := 0;
  end
  else NImmLvms := 0;
  if NMinAcro < 0 then
  begin
    NImmAcro := MIN(-NMinAcro, NInoAcro);
    NInoAcro := NInoAcro - NImmAcro;
    NMinAcro := 0;
  end
  else NImmAcro := 0;
  if NMinCato <0 then
  begin
    NImmCato := MIN(-NMinCato, NInoCato);
    NInoCato := NInoCato - NImmCato;
    NMinCato := 0;
  end
  else NImmCato := 0;
end;

procedure TOrgan.UpdateCAndNPools;
begin
  CBiomass:=CBiomass + (Growth-CLPLvms-CLPAcro-CLPCato) * TimeStep;
  NBiomass:=NBiomass + (NUptake-NLPLvms-NLPAcro-NLPCato) * TimeStep;
  CDMLvms:=CDMLvms + (CLPLvms-CDecLvms-CTransfAcro) * TimeStep;
  NDMLvms:=NDMLvms + (NLPLvms+NImmLvms-NMinLvms-NTransfAcro) * TimeStep;
  CDMAcro:=CDMAcro + (CLPAcro-CDecAcro+CTransfAcro-CTransfCato) * TimeStep;
  NDMAcro:=NDMAcro+(NLPAcro+NImmAcro-NMinAcro+NTransfAcro-NTransfCato)*TimeStep;
  CDMCato:=CDMCato + (CLPCato-CDecCato+CTransfCato) * TimeStep;
  NDMCato:=NDMCato + (NLPCato+NImmCato-NminCato+NTransfCato) * TimeStep;
end;

end.
