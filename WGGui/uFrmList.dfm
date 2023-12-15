inherited FrmList: TFrmList
  Width = 1048
  Height = 672
  OnResize = FrameResize
  ExplicitWidth = 1048
  ExplicitHeight = 672
  object sPanel1: TsPanel [0]
    Left = 185
    Top = 64
    Width = 863
    Height = 608
    Align = alClient
    Caption = 'sPanel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitTop = 33
    ExplicitHeight = 639
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
    object sg1: TAdvStringGrid
      Left = 1
      Top = 1
      Width = 861
      Height = 606
      Align = alClient
      ColCount = 6
      DrawingStyle = gdsClassic
      FixedColor = clWhite
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goRowSelect, goFixedRowDefAlign]
      TabOrder = 1
      OnGetCellColor = sg1GetCellColor
      OnCheckBoxChange = sg1CheckBoxChange
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = 4474440
      ActiveCellFont.Height = -12
      ActiveCellFont.Name = 'Segoe UI'
      ActiveCellFont.Style = [fsBold]
      ActiveCellColor = 11565130
      ActiveCellColorTo = 11565130
      BorderColor = 11250603
      ColumnHeaders.Strings = (
        ''
        'Name'
        'Id'
        'Version'
        'Available'
        'Source')
      ControlLook.FixedGradientFrom = clWhite
      ControlLook.FixedGradientTo = clWhite
      ControlLook.FixedGradientHoverFrom = clGray
      ControlLook.FixedGradientHoverTo = clWhite
      ControlLook.FixedGradientHoverMirrorFrom = clWhite
      ControlLook.FixedGradientHoverMirrorTo = clWhite
      ControlLook.FixedGradientHoverBorder = 11645361
      ControlLook.FixedGradientDownFrom = clWhite
      ControlLook.FixedGradientDownTo = clWhite
      ControlLook.FixedGradientDownMirrorFrom = clWhite
      ControlLook.FixedGradientDownMirrorTo = clWhite
      ControlLook.FixedGradientDownBorder = 11250603
      ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownHeader.Font.Color = clWindowText
      ControlLook.DropDownHeader.Font.Height = -11
      ControlLook.DropDownHeader.Font.Name = 'Segoe UI'
      ControlLook.DropDownHeader.Font.Style = []
      ControlLook.DropDownHeader.Visible = True
      ControlLook.DropDownHeader.Buttons = <>
      ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownFooter.Font.Color = clWindowText
      ControlLook.DropDownFooter.Font.Height = -11
      ControlLook.DropDownFooter.Font.Name = 'Segoe UI'
      ControlLook.DropDownFooter.Font.Style = []
      ControlLook.DropDownFooter.Visible = True
      ControlLook.DropDownFooter.Buttons = <>
      Filter = <
        item
          Column = 4
          Condition = '! '#39'N/A'#39
          CaseSensitive = False
          Operation = foSHORT
          Method = fmExpression
        end>
      FilterDropDown.Font.Charset = DEFAULT_CHARSET
      FilterDropDown.Font.Color = clWindowText
      FilterDropDown.Font.Height = -12
      FilterDropDown.Font.Name = 'Segoe UI'
      FilterDropDown.Font.Style = []
      FilterDropDown.TextChecked = 'Checked'
      FilterDropDown.TextUnChecked = 'Unchecked'
      FilterDropDownClear = '(All)'
      FilterEdit.TypeNames.Strings = (
        'Starts with'
        'Ends with'
        'Contains'
        'Not contains'
        'Equal'
        'Not equal'
        'Larger than'
        'Smaller than'
        'Clear')
      FixedRowHeight = 22
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Segoe UI'
      FixedFont.Style = [fsBold]
      FloatFormat = '%.2f'
      HoverButtons.Buttons = <>
      HTMLSettings.ImageFolder = 'images'
      HTMLSettings.ImageBaseName = 'img'
      Look = glCustom
      PrintSettings.DateFormat = 'dd/mm/yyyy'
      PrintSettings.Font.Charset = DEFAULT_CHARSET
      PrintSettings.Font.Color = clWindowText
      PrintSettings.Font.Height = -12
      PrintSettings.Font.Name = 'Segoe UI'
      PrintSettings.Font.Style = []
      PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
      PrintSettings.FixedFont.Color = clWindowText
      PrintSettings.FixedFont.Height = -12
      PrintSettings.FixedFont.Name = 'Segoe UI'
      PrintSettings.FixedFont.Style = []
      PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
      PrintSettings.HeaderFont.Color = clWindowText
      PrintSettings.HeaderFont.Height = -12
      PrintSettings.HeaderFont.Name = 'Segoe UI'
      PrintSettings.HeaderFont.Style = []
      PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
      PrintSettings.FooterFont.Color = clWindowText
      PrintSettings.FooterFont.Height = -12
      PrintSettings.FooterFont.Name = 'Segoe UI'
      PrintSettings.FooterFont.Style = []
      PrintSettings.PageNumSep = '/'
      SearchFooter.ColorTo = clNone
      SearchFooter.FindNextCaption = 'Find &next'
      SearchFooter.FindPrevCaption = 'Find &previous'
      SearchFooter.Font.Charset = DEFAULT_CHARSET
      SearchFooter.Font.Color = clWindowText
      SearchFooter.Font.Height = -12
      SearchFooter.Font.Name = 'Segoe UI'
      SearchFooter.Font.Style = []
      SearchFooter.HighLightCaption = 'Highlight'
      SearchFooter.HintClose = 'Close'
      SearchFooter.HintFindNext = 'Find next occurrence'
      SearchFooter.HintFindPrev = 'Find previous occurrence'
      SearchFooter.HintHighlight = 'Highlight occurrences'
      SearchFooter.MatchCaseCaption = 'Match case'
      SearchFooter.ResultFormat = '(%d of %d)'
      SelectionColor = 13744549
      SelectionTextColor = clWindowText
      ShowDesignHelper = False
      SortSettings.HeaderColor = clWhite
      SortSettings.HeaderColorTo = clWhite
      SortSettings.HeaderMirrorColor = clWhite
      SortSettings.HeaderMirrorColorTo = clWhite
      Version = '8.6.14.2'
      ExplicitLeft = 6
      ExplicitTop = 6
      ExplicitHeight = 637
      RowHeights = (
        22
        22)
    end
  end
  inherited framePnl: TFlowPanel
    Width = 1048
    Caption = 'Installed Packages'
    TabOrder = 1
    ExplicitWidth = 1048
  end
  object Panel1: TPanel
    Left = 0
    Top = 64
    Width = 185
    Height = 608
    Align = alLeft
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 2
    ExplicitLeft = -5
    ExplicitTop = 39
    ExplicitHeight = 639
    object btnUpdate: TButton
      Left = 1
      Top = 1
      Width = 183
      Height = 64
      Align = alTop
      Caption = 'Update Cheked Packages'
      TabOrder = 0
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 33
    Width = 1048
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 3
    object ckUpdates: TCheckBox
      Left = 8
      Top = 6
      Width = 137
      Height = 17
      Caption = 'Show Only Updates'
      TabOrder = 0
      OnClick = ckUpdatesClick
    end
  end
  object DosCommand1: TDosCommand
    InputToOutput = False
    MaxTimeAfterBeginning = 0
    MaxTimeAfterLastOutput = 10
    Left = 904
    Top = 72
  end
end
