unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,System.Generics.Collections,
  System.Classes, Vcl.Graphics, uConsts, System.JSON,System.StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  sSkinManager, sSkinProvider, Vcl.Menus, Vcl.ExtCtrls, System.Actions,
  Vcl.ActnList,
  uBaseFrame, uFrmSearch, usearchPackage, uDM,
  uFrmList, Vcl.WinXCtrls, sPanel, DosCommand, Vcl.StdCtrls,
  System.Notification, ufrmsplash, AdvSysKeyboardHook, AdvListEditor;

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
    DosCUpdates: TDosCommand;
    Memo1: TMemo;
    NotificationCenter1: TNotificationCenter;
    DosCommand1: TDosCommand;
    Panel2: TPanel;
    lblSearch: TLabel;
    eSearch: TAdvListEditor;
    Button1: TButton;
    procedure actQuitExecute(Sender: TObject);
    procedure actListPackagesExecute(Sender: TObject);
    procedure actShowGuiExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure AdvSysKeyboardHook1KeyDown(Sender: TObject; Key: Word;
      Shift: TShiftState; var Allow: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    bCanClose: Boolean;
    procedure popup(nb: integer);
  public
    aFrame: TBaseFrame;
    procedure ActivitySet(bActive: Boolean);
    procedure terminateUpdate(Sender: TObject);
    procedure displaySplash;
    procedure terminatedList(Sender: TObject);
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.actListPackagesExecute(Sender: TObject);
begin
  ActivitySet(True);
  DosCommand1.OnCharDecoding := DM.CharDecoding;
  DosCommand1.CommandLine := sList;
  DosCommand1.OnTerminated := terminatedList;
  DosCommand1.Execute;
end;

procedure TfMain.ActivitySet(bActive: Boolean);
begin
  AI1.Animate := bActive;
end;

procedure TfMain.actQuitExecute(Sender: TObject);
begin
  bCanClose := True;
  Close;
end;

procedure TfMain.actSearchExecute(Sender: TObject);
begin
  // ActivitySet(True);
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

procedure TfMain.AdvSysKeyboardHook1KeyDown(Sender: TObject; Key: Word;
  Shift: TShiftState; var Allow: Boolean);
begin
  showmessage(inttostr(Key));
end;

procedure TfMain.Button1Click(Sender: TObject);
var
  i : Integer;
  sSearch : tlist<String>;
begin
if aFrame <> Nil then
    aFrame.Free;

  aFrame := TfrmSearch.Create(pnlMain);
  aFrame.Parent := pnlMain;
  aFrame.Align := alClient;
  i := 0;
  sSearch := tlist<string>.Create;
  while i <= eSearch.Values.Count-1 do
  begin
      ssearch.Add(eSearch.Values[i].DisplayText);
      inc(i);
  end;

  TfrmSearch(aFrame).sSearch := String.join(',',sSearch.ToArray);
  aFrame.ActivitySet := ActivitySet;

  TfrmSearch(aFrame).Init;
end;

procedure TfMain.displaySplash;
begin
  if aFrame <> Nil then
    aFrame.Free;

  aFrame := TfrmSplash.Create(pnlMain);
  aFrame.Parent := pnlMain;
  aFrame.Align := alClient;
  aFrame.ActivitySet := ActivitySet;

end;

procedure TfMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  hide;
  CanClose := bCanClose;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  displaySplash;
  bCanClose := False;
  DosCUpdates.CommandLine := sUpdate;
  DosCUpdates.OnCharDecoding := DM.CharDecoding;
  DosCUpdates.OnTerminated := terminateUpdate;
  DosCUpdates.Execute;

end;

procedure TfMain.popup(nb: integer);
var
  MyNotification: TNotification;
begin
  MyNotification := NotificationCenter1.CreateNotification;
  // Creates the notification
  try
    MyNotification.Name := 'Winget Helper Notification';
    // Defines the name of the notification.
    MyNotification.Title := 'Winget Helper';
    // Defines the name that appears when the notification is presented.
    MyNotification.AlertBody := Format('New Upgrades availables (%d)', [nb]);
    // Defines the body of the notification that appears below the title.
    MyNotification.EnableSound := True;

    NotificationCenter1.PresentNotification(MyNotification);
    // Presents the notification on the screen.
  finally
    MyNotification.Free; // Frees the variable
  end;
end;

procedure TfMain.terminatedList(Sender: TObject);
begin
  if aFrame <> Nil then
    aFrame.Free;

  aFrame := TfrmList.Create(pnlMain);
  aFrame.Parent := pnlMain;
  aFrame.Align := alClient;
  aFrame.ActivitySet := ActivitySet;
  TfrmList(aFrame).JSON := DosCommand1.Lines.Text;
  TfrmList(aFrame).Init;
end;

procedure TfMain.terminateUpdate(Sender: TObject);
var
  V: TJsonValue;
  O, E, P: TJsonObject;
  A: TJsonArray;
  s: String;

  iRow: integer;
begin
  V := TJsonObject.ParseJSONValue(DosCUpdates.Lines.Text);

  O := V as TJsonObject;
  A := O.GetValue<TJsonArray>('packages');

  popup(A.Count);
  actListPackagesExecute(Sender);
end;

end.
