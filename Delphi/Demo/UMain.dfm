object Form9: TForm9
  Left = 0
  Top = 0
  Caption = 'Form9'
  ClientHeight = 434
  ClientWidth = 641
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    641
    434)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 625
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      
        '["MSTE0101",59,"CRC2CFCF8AC",1,"Person",6,"name","firstName","bi' +
        'rthday","maried-to","father","mother",22,3,50,4,0,5,"D'
      
        'urand",1,5,"Y\"ves",2,6,-1222131600,3,50,4,0,9,2,1,5,"Claire",2,' +
        '6,-1185667200,3,9,1,9,5,50,5,0,9,2,1,5,"Lou",2,6,-42621'
      '48'
      '00,4,9,1,5,9,5]')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo2: TMemo
    Left = 8
    Top = 119
    Width = 625
    Height = 306
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Memo2')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Button2: TButton
    Left = 558
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 216
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 4
    OnClick = Button3Click
  end
end
