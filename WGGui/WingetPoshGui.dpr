program WingetPoshGui;

uses
  Vcl.Forms,
  uOldMain in 'uOldMain.pas' {fOldMain},
  uConsts in 'uConsts.pas',
  uMain in 'uMain.pas' {fMain},
  uBaseFrame in 'uBaseFrame.pas' {BaseFrame: TFrame},
  uFrmList in 'uFrmList.pas' {FrmList: TFrame},
  uFrmSearch in 'uFrmSearch.pas' {frmSearch: TFrame},
  uFrmConfig in 'uFrmConfig.pas' {frmConfig: TFrame},
  Vcl.Themes,
  Vcl.Styles,
  uDM in 'uDM.pas' {DM: TDataModule},
  usearchPackage in 'usearchPackage.pas' {fSearchPackage},
  uFrmSplash in 'uFrmSplash.pas' {FrmSplash: TFrame};

{$R *.res}

begin
  Application.Initialize;

  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm :=  true;
  TStyleManager.TrySetStyle('Glow');
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfSearchPackage, fSearchPackage);
  fMain.Onshow := Nil;


  Application.Run;

end.
