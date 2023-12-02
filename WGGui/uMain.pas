unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList, sSkinManager, sSkinProvider, Vcl.Menus, Vcl.ExtCtrls, System.Actions, Vcl.ActnList,
  uBaseFrame,uFrmSearch,
  uFrmList, Vcl.WinXCtrls, sPanel;

type
  TfMain = class(TForm)
    ImageList1: TImageList;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    W1: TMenuItem;
    N3: TMenuItem;
    L1: TMenuItem;
    List1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    ActionList1: TActionList;
    pnlMain: TPanel;
    actQuit: TAction;
    actListPackages: TAction;
    S1: TMenuItem;
    N4: TMenuItem;
    actConfigGui: TAction;
    mnuConfigurtion: TMenuItem;
    Configuration1: TMenuItem;
    actShowGui: TAction;
    pnlStatus: TPanel;
    AI1: TActivityIndicator;
    Panel1: TPanel;
    actSearch: TAction;
    procedure actQuitExecute(Sender: TObject);
    procedure actListPackagesExecute(Sender: TObject);
    procedure actShowGuiExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
  private
    { Private declarations }
  public
   aFrame: TBaseFrame;
   procedure ActivitySet(bActive: Boolean);
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.actListPackagesExecute(Sender: TObject);
begin
  ActivitySet(True);
  if aFrame <> Nil then
    aFrame.Free;

  aFrame := TfrmList.Create(pnlMain);
  aFrame.Parent := pnlMain;
  aFrame.Align := alClient;
  aFrame.ActivitySet := ActivitySet;

  TfrmList(aFrame).Init;
end;

procedure TfMain.ActivitySet(bActive: Boolean);
begin
    AI1.Animate := bActive;
end;

procedure TfMain.actQuitExecute(Sender: TObject);
begin
   Close;
end;

procedure TfMain.actSearchExecute(Sender: TObject);
begin
   ActivitySet(True);
  if aFrame <> Nil then
    aFrame.Free;

  aFrame := TfrmSearch.Create(pnlMain);
  aFrame.Parent := pnlMain;
  aFrame.Align := alClient;
  aFrame.ActivitySet := ActivitySet;

  TfrmSearch(aFrame).Init;
end;

procedure TfMain.actShowGuiExecute(Sender: TObject);
begin
      Show;
end;

end.
