program ClientProcessor;

uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  HUtil32 in '..\..\Common\HUtil32.pas',
  EncryptUnit in '..\..\Common\EncryptUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
