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
    Panel1: TPanel;
    ckUpdates: TCheckBox;
    Panel2: TPanel;
    btnUpdate: TButton;
    procedure sButton1Click(Sender: TObject);
    procedure sg1GetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure FrameResize(Sender: TObject);
    procedure ckUpdatesClick(Sender: TObject);
    procedure sg1CheckBoxChange(Sender: TObject; ACol, ARow: Integer; State: Boolean);
  private
    { Private declarations }
    ls: TStringList;
    Sr: TStringReader;
    Reader: TJsonTextReader;
    procedure terminated(Sender: TObject);
    function isAnUpdateChecked : Boolean;
  public
    { Public declarations }
    JSON : string;
    procedure init;
  end;

var
  FrmList: TFrmList;

implementation

{$R *.dfm}
{ TFrmList }

procedure TFrmList.ckUpdatesClick(Sender: TObject);
begin
  inherited;
  sg1.FilterActive := ckUpdates.Checked;
end;

procedure TFrmList.FrameResize(Sender: TObject);
begin
  inherited;
   sg1.AutoFitColumns();
end;

procedure TFrmList.init;
begin
  Application.MainForm.Show;
  framePnl.Visible := false;
  terminated(nil);

end;

function TFrmList.isAnUpdateChecked: Boolean;
var
  i : Integer;
  bchecked : boolean;
  b : boolean;
begin
    i := 1;
    bchecked := false;
    while i < sg1.RowCount do
    begin
      if sg1.Cells[4,i] <> '' then
         sg1.GetCheckBoxState(0,i,b);
         bchecked := (bchecked or b);
      inc(i);
    end;
    result := bchecked;
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

procedure TFrmList.sg1CheckBoxChange(Sender: TObject; ACol, ARow: Integer; State: Boolean);
begin
  inherited;
  if sg1.Cells[4,aRow] <> '' then
  begin
    btnUpdate.Visible := isAnUpdateChecked;
  end;
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
    V := TJSONObject.ParseJSONValue(JSON);
//    if not Assigned(V) then
//      Memo1.Lines.Assign(Doscommand1.OutputLines);
    try
      //Memo1.Clear;
      O := V as TJSONObject;
      A := O.GetValue<TJsonArray>('packages');
      iRow := 1;
      sg1.ColWidths[0] := 25;
      sg1.AddCheckBoxColumn(0);
      sg1.AddCheckBox(0,0,false,false);
      sg1.MouseActions.CheckAllCheck := true;
      for var I := 0 to A.Count - 1 do
      begin
          E := A.Items[I] as TJsonObject; // Element
//          aItem := listView1.Items.Add;
//          aItem.Caption := E.GetValue<string>('Name');
//          aItem.SubItems.Add(E.GetValue<string>('Id'));
//          aItem.SubItems.Add(E.GetValue<string>('Version'));
//          try
//          aItem.SubItems.Add(E.GetValue<string>('Available'));
//          except
//             aItem.SubItems.Add('');
//          end;
//          aItem.SubItems.Add(E.GetValue<string>('Source'));
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
          sg1.AddCheckBox(0,iRow,false,false);
          sg1.Cells[1,iRow] :=  E.GetValue<string>('Name');
          sg1.Cells[2,iRow] :=  E.GetValue<string>('Id');
          sg1.Cells[3,iRow] :=  E.GetValue<string>('Version');
          try
              sg1.Cells[4,iRow] := E.GetValue<string>('Available')
          except
            sg1.Cells[4,iRow] :=  '';
          end;
          sg1.Cells[5,iRow] :=  E.GetValue<string>('Source');
          if (sg1.Cells[5,iRow].Trim() = '') then sg1.Cells[5,iRow]:= ' ';
      end;
      sg1.Filter.Clear;
      sg1.Filter.add(4,'! ');
    finally
      sg1.AutoFitColumns();

      V.Free;
    end;
    ActivitySet(False);
//    listView1.Items.EndUpdate;
end;

end.
