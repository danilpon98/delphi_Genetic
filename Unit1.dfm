object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 483
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
    Top = 88
    Width = 113
    Height = 24
    Caption = #1056#1072#1079#1084#1077#1088' '#1087#1086#1087#1091#1083#1103#1094#1080#1080':'
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
    Left = 431
    Top = 0
    Width = 377
    Height = 483
    Align = alRight
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 16
    Width = 417
    Height = 41
    TabOrder = 2
  end
  object UpDown1: TUpDown
    Left = 167
    Top = 87
    Width = 16
    Height = 25
    Associate = Edit1
    Position = 6
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 127
    Top = 87
    Width = 42
    Height = 25
    TabOrder = 4
    Text = '6'
  end
end
