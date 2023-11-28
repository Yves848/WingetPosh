inherited FrmList: TFrmList
  Width = 1048
  Height = 672
  ExplicitWidth = 1048
  ExplicitHeight = 672
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 1048
    Height = 672
    Align = alClient
    Caption = 'sPanel1'
    ShowCaption = False
    TabOrder = 0
    object SynEdit1: TSynEdit
      Left = 24
      Top = 24
      Width = 977
      Height = 329
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      Font.Quality = fqClearTypeNatural
      TabOrder = 0
      UseCodeFolding = False
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Consolas'
      Gutter.Font.Style = []
      Gutter.Bands = <
        item
          Kind = gbkMarks
          Width = 13
        end
        item
          Kind = gbkLineNumbers
        end
        item
          Kind = gbkFold
        end
        item
          Kind = gbkTrackChanges
        end
        item
          Kind = gbkMargin
          Width = 3
        end>
      Lines.Strings = (
        'SynEdit1')
      SelectedColor.Alpha = 0.400000005960464500
    end
    object sButton1: TsButton
      Left = 24
      Top = 368
      Width = 75
      Height = 25
      Caption = 'sButton1'
      TabOrder = 1
      OnClick = sButton1Click
    end
    object Memo1: TsMemo
      Left = 24
      Top = 416
      Width = 977
      Height = 217
      Lines.Strings = (
        'Memo1')
      TabOrder = 2
      Text = 'Memo1'
    end
    object Button1: TButton
      Left = 120
      Top = 368
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 3
    end
  end
  object sFrameAdapter1: TsFrameAdapter
    Left = 480
    Top = 296
  end
  object DosCommand1: TDosCommand
    InputToOutput = False
    MaxTimeAfterBeginning = 0
    MaxTimeAfterLastOutput = 10
    OnNewLine = DosCommand1NewLine
    OnTerminated = DosCommand1Terminated
    Left = 456
    Top = 64
  end
end
