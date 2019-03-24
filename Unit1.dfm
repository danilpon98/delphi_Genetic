object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 531
  ClientWidth = 808
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
    Left = 8
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
    Left = 8
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
    Left = 83
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
    Left = 136
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
    Left = 189
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
    Left = 8
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
  object Button1: TButton
    Left = 8
    Top = 264
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
    Left = 472
    Top = 0
    Width = 336
    Height = 531
    Align = alRight
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 0
    Width = 473
    Height = 33
    Align = alCustom
    TabOrder = 2
  end
  object UpDown1: TUpDown
    Left = 169
    Top = 95
    Width = 16
    Height = 21
    Associate = Edit1
    Position = 20
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 127
    Top = 95
    Width = 42
    Height = 21
    TabOrder = 4
    Text = '20'
  end
  object Edit2: TEdit
    Left = 91
    Top = 55
    Width = 41
    Height = 21
    TabOrder = 5
    Text = '0'
  end
  object Edit3: TEdit
    Left = 144
    Top = 55
    Width = 41
    Height = 21
    TabOrder = 6
    Text = '8'
  end
  object UpDown2: TUpDown
    Left = 169
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
    Left = 127
    Top = 129
    Width = 42
    Height = 21
    TabOrder = 8
    Text = '18'
  end
end
