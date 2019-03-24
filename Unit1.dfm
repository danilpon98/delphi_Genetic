object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 531
  ClientWidth = 810
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 344
    Top = 96
    Width = 113
    Height = 16
    Caption = #1056#1072#1079#1084#1077#1088' '#1087#1086#1087#1091#1083#1103#1094#1080#1080':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 344
    Top = 56
    Width = 61
    Height = 16
    Caption = #1048#1085#1090#1077#1088#1074#1072#1083':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 419
    Top = 56
    Width = 5
    Height = 16
    Caption = '['
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 472
    Top = 56
    Width = 5
    Height = 16
    Caption = ';'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 525
    Top = 56
    Width = 5
    Height = 16
    Caption = ']'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 344
    Top = 130
    Width = 106
    Height = 16
    Caption = #1063#1080#1089#1083#1086' '#1087#1086#1082#1086#1083#1077#1085#1080#1081':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 8
    Top = 8
    Width = 290
    Height = 32
    Caption = 
      #1055#1086#1080#1089#1082' '#1101#1082#1089#1090#1088#1077#1084#1091#1084#1086#1074' '#1092#1091#1085#1082#1094#1080#1080' '#1084#1085#1086#1075#1080#1093' '#1087#1077#1088#1077#1084#1077#1085#1085#1099#1093' '#1089' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1077#1084' '#1075#1077#1085 +
      #1077#1090#1080#1095#1077#1089#1082#1080#1093' '#1072#1083#1075#1086#1088#1080#1090#1084#1086#1074
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Button1: TButton
    Left = 344
    Top = 168
    Width = 161
    Height = 65
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = -6
    Top = 247
    Width = 340
    Height = 284
    Align = alCustom
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ProgressBar1: TProgressBar
    Left = 336
    Top = 0
    Width = 473
    Height = 33
    Align = alCustom
    TabOrder = 2
  end
  object UpDown1: TUpDown
    Left = 505
    Top = 95
    Width = 16
    Height = 21
    Associate = Edit1
    Position = 20
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 463
    Top = 95
    Width = 42
    Height = 21
    TabOrder = 4
    Text = '20'
  end
  object Edit2: TEdit
    Left = 427
    Top = 55
    Width = 41
    Height = 21
    TabOrder = 5
    Text = '0'
  end
  object Edit3: TEdit
    Left = 480
    Top = 55
    Width = 41
    Height = 21
    TabOrder = 6
    Text = '8'
  end
  object UpDown2: TUpDown
    Left = 505
    Top = 129
    Width = 16
    Height = 21
    Associate = Edit4
    ParentShowHint = False
    Position = 18
    ShowHint = False
    TabOrder = 7
  end
  object Edit4: TEdit
    Left = 463
    Top = 129
    Width = 42
    Height = 21
    TabOrder = 8
    Text = '18'
  end
  object Chart1: TChart
    Left = 336
    Top = 247
    Width = 473
    Height = 284
    LeftWall.Pen.Width = 0
    Legend.ResizeChart = False
    Legend.TextSymbolGap = 0
    Legend.Visible = False
    Title.Font.Height = -13
    Title.Text.Strings = (
      #1043#1088#1072#1092#1080#1082' '#1092#1091#1085#1082#1094#1080#1080)
    LeftAxis.Grid.Width = 0
    LeftAxis.MinorGrid.Width = 0
    RightAxis.Grid.Width = 0
    View3D = False
    Zoom.Pen.Width = 2
    TabOrder = 9
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      20
      15
      20)
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      Brush.BackColor = clDefault
      LinePen.Color = 922746880
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      Data = {
        00130000000000000000C067400000000000E060400000000000E05F40000000
        0000F069400000000000A0644000000000002052C00000000000405F40000000
        0000B06D40000000000050744000000000009070400000000000607340000000
        0000506E4000000000005074400000000000706C400000000000407040000000
        0000E06F400000000000F074400000000000687A400000000000187F40}
      Detail = {0000000000}
    end
    object Series2: TPointSeries
      ClickableLine = False
      Pointer.HorizSize = 3
      Pointer.InflateMargins = True
      Pointer.Style = psCircle
      Pointer.VertSize = 3
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Panel1: TPanel
    Left = 546
    Top = 33
    Width = 2
    Height = 208
    TabOrder = 10
  end
  object Panel2: TPanel
    Left = 336
    Top = 33
    Width = 2
    Height = 208
    TabOrder = 11
  end
end
