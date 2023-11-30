unit uFrmList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.JSON, System.JSON.Readers,
  System.JSON.Types,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBaseFrame, sFrameAdapter, DosCommand,
  Vcl.StdCtrls, sLabel, Vcl.ExtCtrls, sPanel, SynEdit, uConsts, uDM, sButton,
  sMemo,
  Vcl.ComCtrls, sListView, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid;

type
  TFrmList = class(TBaseFrame)
    sFrameAdapter1: TsFrameAdapter;
    DosCommand1: TDosCommand;
    sPanel1: TsPanel;
    sButton1: TsButton;
    sPanel2: TsPanel;
    sg1: TAdvStringGrid;
    procedure sButton1Click(Sender: TObject);
  private
    { Private declarations }
    ls: TStringList;
    Sr: TStringReader;
    Reader: TJsonTextReader;
    procedure terminated(Sender: TObject);
  public
    { Public declarations }
    procedure init;
  end;

var
  FrmList: TFrmList;

implementation

{$R *.dfm}
{ TFrmList }

procedure TFrmList.init;
begin
  DosCommand1.OnCharDecoding := DM.CharDecoding;
  DosCommand1.CommandLine := sList;
  DosCommand1.OnTerminated := terminated;
  DosCommand1.Execute

end;

procedure TFrmList.sButton1Click(Sender: TObject);
begin
  // SynEdit1.Lines.Assign(ls);
  // Sr := TStringReader.Create(ls.text);
  // Reader := TJsonTextReader.Create(Sr);
  // while Reader.read do
  // case Reader.TokenType of
  // TJsonToken.startobject:
  // Memo1.Lines.Add('(StartObject) ' + '- Token Path : ' + Reader.Path);
  // TJsonToken.StartArray:
  // Memo1.Lines.Add('(StartArray) ' + '- Token Path : ' + Reader.Path );
  // TJsonToken.PropertyName:
  // Memo1.Lines.Add('PropertyName : ' + Reader.Value.ToString + '- Token Path : ' + Reader.Path );
  // TJsonToken.String:
  // Memo1.Lines.Add('String Value : ' + Reader.Value.ToString + '- Token Path : ' + Reader.Path);
  // TJsonToken.Integer:
  // Memo1.Lines.Add('Integer Value : ' + Reader.Value.ToString + '- Token Path : ' + Reader.Path);
  // TJsonToken.Float:
  // Memo1.Lines.Add('Float Value : ' + Reader.Value.ToString + '- Token Path : ' + Reader.Path);
  // TJsonToken.Boolean:
  // Memo1.Lines.Add('Boolean Value : ' + Reader.Value.ToString + '- Token Path : ' + Reader.Path);
  // TJsonToken.Null:
  // Memo1.Lines.Add('Null Value : ' + Reader.Value.ToString + '- Token Path : ' + Reader.Path);
  // TJsonToken.EndArray:
  // Memo1.Lines.Add('(EndArray) ' + '- Token Path : ' + Reader.Path);
  // TJsonToken.EndObject:
  // Memo1.Lines.Add('(EndObject) ' + '- Token Path : ' + Reader.Path);
  // end;
end;

procedure TFrmList.terminated(Sender: TObject);
var
    V: TJsonValue;
    O, E, P: TJsonObject;
    A: TJsonArray;
    s : String;
    aItem: TListItem;
begin
    //listView1.Items.BeginUpdate;

    //listView1.Clear;
    V := TJSONObject.ParseJSONValue(Doscommand1.Lines.text);
//    if not Assigned(V) then
//      Memo1.Lines.Assign(Doscommand1.OutputLines);
    try
      //Memo1.Clear;
      O := V as TJSONObject;
      A := O.GetValue<TJsonArray>('packages');

      for var I := 0 to A.Count - 1 do
      begin
        E := A.Items[I] as TJsonObject; // Element
//        aItem := listView1.Items.Add;
//        aItem.Caption := E.GetValue<string>('Name');
//        aItem.SubItems.Add(E.GetValue<string>('Id'));
//        aItem.SubItems.Add(E.GetValue<string>('Version'));
//        aItem.SubItems.Add(E.GetValue<string>('Available'));
//        aItem.SubItems.Add(E.GetValue<string>('Source'));
//        s := 'Package : ';
//        E := A.Items[I] as TJsonObject; // Element
//        s := s + E.GetValue<string>('Name');
//        s := s + ' Id: ' + E.GetValue<string>('Id') + '  ' + 'Version: ' +  E.GetValue<string>('Version')+' Available : '+E.GetValue<string>('Available');
//        memo1.Lines.Add(s);
          sg1.Cells[0,I+1] :=  E.GetValue<string>('Name');
          sg1.Cells[1,I+1] :=  E.GetValue<string>('Id');
          sg1.Cells[2,I+1] :=  E.GetValue<string>('Version');
          sg1.Cells[3,I+1] :=  E.GetValue<string>('Available');
          sg1.Cells[4,I+1] :=  E.GetValue<string>('Source');
      end;
    finally
      V.Free;
    end;
    ActivitySet(False);
    //listView1.Items.EndUpdate;
    Application.MainForm.Show;
end;

end.
