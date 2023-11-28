program WGGui;

uses
  Vcl.Forms,
  uOldMain in 'uOldMain.pas' {fOldMain},
  uConsts in 'uConsts.pas',
  uMain in 'uMain.pas' {fMain},
  uBaseFrame in 'uBaseFrame.pas' {BaseFrame: TFrame},
  uFrmList in 'uFrmList.pas' {FrmList: TFrame},
  uFrmSearch in 'uFrmSearch.pas' {frmSearch: TFrame},
  uFrmConfig in 'uFrmConfig.pas' {frmConfig: TFrame};

{$R *.res}

begin
   Application.Initialize;

  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm :=  False;
  Application.CreateForm(TfMain, fMain);
  fMain.Onshow := Nil;


  Application.Run;

end.
