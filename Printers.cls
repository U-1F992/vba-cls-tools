VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Printers"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

''' �v�����^�ꗗ���擾���郂�W���[��
''' <example>
'''
''' �錾��
''' <code>
''' Dim clsPrinters As New Printers
''' </code>
'''
''' ���p�\�ȃv�����^�̈ꗗ��For���[�v�ŕ\�������
''' <code>
''' Dim i As Long
''' For i = 0 To clsPrinters.Length - 1
'''     Debug.Print clsPrinters.Items(i)
''' Next i
''' </code>
''' </example>

''' <summary>
''' �v�����^���ꗗ���i�[����z��
''' </summary>
Private prtList() As String

''' <summary>
''' �v�����^�����擾����
''' </summary>
''' <param name="index">�v�f 0~(Length - 1)</param>
Public Property Get Items(ByVal index As Long) As String
    If LBound(prtList) > index Or UBound(prtList) < index Then
        Err.Raise 1024, "Printers.Items", "�C���f�b�N�X���L���͈͂ɂ���܂���B"
    Else
        Items = prtList(index)
    End If
End Property

''' <summary>
''' Items�v���p�e�B�̗v�f��
''' </summary>
Public Property Get Length() As Long
    Length = UBound(prtList) + 1
End Property

Private Sub Class_Initialize()
    Refresh
End Sub

''' <summary>
''' �v�����^���ꗗ���č\�z����
''' </summary>
Public Sub Refresh()
    ReDim prtList(0)
    Dim flag As Boolean: flag = False
    
    Dim objShell As Object: Set objShell = CreateObject("Shell.Application")
    Const ssfPRINTERS = 4
    
    Dim obj As Object
    For Each obj In objShell.Namespace(ssfPRINTERS).Items
    
        If flag = False Then ' �Y����0�ɒǉ�����
            flag = True
        Else
            ReDim Preserve prtList(UBound(prtList) + 1)
        End If
        
        prtList(UBound(prtList)) = obj.Name
        
    Next obj
    
    Set objShell = Nothing
    
End Sub

''' <summary>
''' �g�ݍ��݃_�C�A���O��\������
''' </summary>
Public Sub ShowDialog()
    Application.Dialogs(xlDialogPrinterSetup).Show
End Sub