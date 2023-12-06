unit uFrmSearch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,system.JSON,uconsts,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBaseFrame, Vcl.ExtCtrls, AdvUtil, Vcl.StdCtrls, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, udm, DosCommand;

type
  TfrmSearch = class(TBaseFrame)
    sg1: TAdvStringGrid;
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    DosCommand1: TDosCommand;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure init;
    procedure terminated(Sender: TObject);
  end;

var
  frmSearch: TfrmSearch;

implementation

{$R *.dfm}

{ TfrmSearch }

procedure TfrmSearch.Button1Click(Sender: TObject);
begin
  inherited;
  DosCommand1.CommandLine := format(sSearch,[Edit1.Text]);
  DosCommand1.OnTerminated := terminated;
  ActivitySet(true);
  DosCommand1.Execute;
end;

procedure TfrmSearch.init;
begin
    Application.MainForm.Show;
    DosCommand1.OnCharDecoding := dm.CharDecoding;
end;

procedure TfrmSearch.terminated(Sender: TObject);
var
    V: TJsonValue;
    O, E, P: TJsonObject;
    A: TJsonArray;
    s : String;
    //aItem: TListItem;
    iRow : Integer;
begin
    //listView1.Items.BeginUpdate;

    //listView1.Clear;
    while(DosCommand1.IsRunning) do begin
      Application.ProcessMessages;
    end;
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
          sg1.AddCheckBox(0,iRow,TCheckBoxState.cbChecked);
          sg1.Cells[1,iRow] :=  E.GetValue<string>('Name');
          sg1.Cells[2,iRow] :=  E.GetValue<string>('Id');
          sg1.Cells[3,iRow] :=  E.GetValue<string>('Version');
          sg1.Cells[4,iRow] :=  E.GetValue<string>('Moniker');
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
