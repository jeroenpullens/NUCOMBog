program modelMEE;

uses
  SysUtils,
  maincl in 'maincl.pas',
  water in 'water.pas',
  readwrite in 'readwrite.pas',
  plant in 'plant.pas';

begin
  ModelDir:=ExtractFileDir(Paramstr(0));
  ReadInOutFiles;
  Start;
  WriteInOutFiles;
end.
