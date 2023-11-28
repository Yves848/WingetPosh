program WGGui;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fMain},
  uConsts in 'uConsts.pas';

{$R *.res}

begin
   Application.Initialize;

  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm :=  False;
  Application.CreateForm(TfMain, fMain);
  fMain.Onshow := Nil;


  Application.Run;

end.
