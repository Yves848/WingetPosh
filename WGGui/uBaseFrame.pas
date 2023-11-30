unit uBaseFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  tActivitySet = procedure (bActive: Boolean) of Object;
  TBaseFrame = class(TFrame)
  private
    { Private declarations }
  public
    { Public declarations }
    ActivitySet : tActivitySet;
  end;

implementation

{$R *.dfm}

end.
