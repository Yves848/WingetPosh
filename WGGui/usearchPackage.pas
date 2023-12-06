unit usearchPackage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, AdvUtil, Vcl.StdCtrls, Vcl.Grids, AdvObj, BaseGrid, AdvGrid;

type
  TfSearchPackage = class(TForm)
    pnlSearch: TPanel;
    AdvStringGrid1: TAdvStringGrid;
    Edit1: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSearchPackage: TfSearchPackage;

implementation

{$R *.dfm}

end.
