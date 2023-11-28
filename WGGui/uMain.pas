unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList, sSkinManager, sSkinProvider, Vcl.Menus, Vcl.ExtCtrls, System.Actions, Vcl.ActnList,
  uBaseFrame,
  uFrmList;

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
    sSkinProvider1: TsSkinProvider;
    sSkinManager1: TsSkinManager;
    ActionList1: TActionList;
    pnlMain: TPanel;
    actQuit: TAction;
    actListPackages: TAction;
    S1: TMenuItem;
    N4: TMenuItem;
    procedure actQuitExecute(Sender: TObject);
    procedure actListPackagesExecute(Sender: TObject);
  private
    { Private declarations }
  public
   aFrame: TBaseFrame;
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.actListPackagesExecute(Sender: TObject);
begin
  //ActivitySet(True);
  if aFrame <> Nil then
    aFrame.Free;

  aFrame := TfrmList.Create(pnlMain);
  aFrame.Parent := pnlMain;
  aFrame.Align := alClient;

  Show;
  TfrmList(aFrame).Init;
end;

procedure TfMain.actQuitExecute(Sender: TObject);
begin
  Close;
end;

end.
