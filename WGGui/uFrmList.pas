unit uFrmList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.JSON, System.JSON.Readers,
  System.JSON.Types,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBaseFrame, sFrameAdapter, DosCommand,
  Vcl.StdCtrls, sLabel, Vcl.ExtCtrls, sPanel, SynEdit, uConsts, sButton, uDM,
  sMemo,
  Vcl.ComCtrls, sListView, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid;

type
  TFrmList = class(TBaseFrame)
    DosCommand1: TDosCommand;
    sPanel1: TsPanel;
    sButton1: TsButton;
    sg1: TAdvStringGrid;
    procedure sButton1Click(Sender: TObject);
    procedure sg1GetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure FrameResize(Sender: TObject);
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

procedure TFrmList.FrameResize(Sender: TObject);
begin
  inherited;
   sg1.AutoFitColumns();
end;

procedure TFrmList.init;
begin
  Application.MainForm.Show;
  framePnl.Visible := false;
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

procedure TFrmList.sg1GetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  inherited;
  if arow > 0 then
  
  if aCol = 4 then
  begin
    if sg1.Cells[aCol,aRow] <> '' then begin
      aFont.Color := clRed;
    end;
  end;

end;

procedure TFrmList.terminated(Sender: TObject);
var
    V: TJsonValue;
    O, E, P: TJsonObject;
    A: TJsonArray;
    s : String;
    aItem: TListItem;
    iRow : Integer;
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
      iRow := 1;
      sg1.ColWidths[0] := 25;
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
          if (sg1.Cells[2,iRow] <> '') then
          begin
            sg1.AddRow;
          end;
          iRow := sg1.RowCount -1;
          //g1.AddCheckBox(0,iRow,TCheckBoxState.cbChecked);
          sg1.Cells[1,iRow] :=  E.GetValue<string>('Name');
          sg1.Cells[2,iRow] :=  E.GetValue<string>('Id');
          sg1.Cells[3,iRow] :=  E.GetValue<string>('Version');
          sg1.Cells[4,iRow] :=  E.GetValue<string>('Available');
          sg1.Cells[5,iRow] :=  E.GetValue<string>('Source');
      end;
    finally
      sg1.AutoFitColumns();

      V.Free;
    end;
    ActivitySet(False);
    //listView1.Items.EndUpdate;
end;

end.
