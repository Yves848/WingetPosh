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
    object sButton1: TsButton
      Left = 24
      Top = 368
      Width = 75
      Height = 25
      Caption = 'sButton1'
      TabOrder = 0
      Visible = False
      OnClick = sButton1Click
    end
    object Memo1: TsMemo
      Left = 24
      Top = 416
      Width = 977
      Height = 217
      Lines.Strings = (
        'Memo1')
      TabOrder = 1
      Text = 'Memo1'
    end
    object Button1: TButton
      Left = 120
      Top = 368
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 2
    end
  end
  object sFrameAdapter1: TsFrameAdapter
    Left = 904
    Top = 144
  end
  object DosCommand1: TDosCommand
    InputToOutput = False
    MaxTimeAfterBeginning = 0
    MaxTimeAfterLastOutput = 10
    OnNewLine = DosCommand1NewLine
    OnTerminated = DosCommand1Terminated
    Left = 904
    Top = 72
  end
end
