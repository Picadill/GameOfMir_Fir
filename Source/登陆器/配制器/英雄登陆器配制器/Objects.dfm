object ObjectsDlg: TObjectsDlg
  Left = 1168
  Top = 333
  Width = 254
  Height = 569
  BorderStyle = bsSizeToolWin
  Caption = 'Objectinspector'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ScreenSnap = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object JvInspector: TJvInspector
    Left = 0
    Top = 0
    Width = 246
    Height = 535
    Align = alClient
    Divider = 120
    ItemHeight = 16
    OnDataValueChanged = JvInspectorDataValueChanged
  end
end
