VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} PrintSelector 
   Caption         =   "PrintSelector"
   ClientHeight    =   3615
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   7680
   OleObjectBlob   =   "PrintSelector.frx":0000
   ShowModal       =   0   'False
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "PrintSelector"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private clsPrinters As New Printers
''' ���[�U�[�t�H�[���S�� _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

Private Sub UserForm_Initialize()
    Refresh
    txtCopy.Value = "1"
End Sub

Private Sub Refresh()
    '���[�N�V�[�g�ꗗ�̍Ď擾
    cmbWorkbook.Clear
    Dim i As Long
    For i = 1 To Application.Workbooks.Count
        cmbWorkbook.AddItem Application.Workbooks(i).Name
    Next i
    
    '�v�����^�ꗗ�̍Ď擾
    cmbPrinter.Clear
    For i = 0 To clsPrinters.Length - 1
        cmbPrinter.AddItem clsPrinters.Items(i)
    Next i
    cmbPrinter.ForeColor = RGB(0, 0, 0)
    btnPrinterConfig.Enabled = False
    btnSave.Enabled = False
    btnRestore.Enabled = False
    
End Sub

Private Sub btnRefresh_Click()
    Refresh
End Sub

Private Sub btnPrint_Click()
    '�v���`�F�b�N
    If Not lstWorksheet_IsValid Then
        MsgBox "���[�N�V�[�g�̑I�����s���ł��B"
        GoTo Dispose
    ElseIf Not cmbPrinter_IsValid Then
        MsgBox "�v�����^�̑I�����s���ł��B"
        GoTo Dispose
    ElseIf Not txtCopy_IsValid Then
        MsgBox "�������s���ł��B"
        GoTo Dispose
    End If
    
    '���[�N�V�[�g���̈ꗗ�����
    Dim arr() As String
    Dim i As Long, j As Long: j = 0
    For i = 0 To lstWorksheet.ListCount - 1
        If lstWorksheet.Selected(i) = True Then
            ReDim Preserve arr(j)
            arr(j) = Application.Workbooks(cmbWorkbook.Value).Worksheets(lstWorksheet.List(i)).Name
            j = j + 1
        End If
    Next i
    
    Application.Workbooks(cmbWorkbook.Value).Worksheets(arr).PrintOut _
        Copies:=txtCopy.Value, _
        Preview:=False, _
        ActivePrinter:=cmbPrinter.Name, _
        Collate:=True
    
Dispose:
End Sub

Private Sub btnCancel_Click()
    Unload Me
End Sub

''' Workbook/Worksheet�I�� _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

Private Sub cmbWorkbook_Change()
    
    '���[�N�V�[�g�ꗗ���Ď擾
    lstWorksheet.Clear
    
    If cmbWorkbook.Value = "" Then
        Exit Sub
    End If
    
    If WorkbookExists(cmbWorkbook.Value) Then
        '���[�N�u�b�N�����݂���ꍇ
        cmbWorkbook.ForeColor = RGB(0, 0, 0)
    
        Dim wbCurrent As Workbook: Set wbCurrent = Application.Workbooks(cmbWorkbook.Value)
        Dim i As Long
        For i = 1 To wbCurrent.Worksheets.Count
            lstWorksheet.AddItem wbCurrent.Worksheets(i).Name
        Next i
        
    Else
        '���[�N�u�b�N�����݂��Ȃ��ꍇ
        cmbWorkbook.ForeColor = RGB(255, 0, 0)
    End If
End Sub

Private Sub lstWorksheet_Change()

    If lstWorksheet_IsValid Then
        lstWorksheet.ForeColor = RGB(0, 0, 0)
    Else
        lstWorksheet.ForeColor = RGB(255, 0, 0)
    End If
    
End Sub

Private Function lstWorksheet_IsValid() As Boolean
    
    lstWorksheet_IsValid = False
    
    Dim i As Long
    For i = 0 To lstWorksheet.ListCount - 1
        If lstWorksheet.Selected(i) = True Then
            If WorksheetExists(Application.Workbooks(cmbWorkbook.Value), lstWorksheet.List(i)) = True Then
                '1�ȏ�̃��[�N�V�[�g�����݂���
                lstWorksheet_IsValid = True
            Else
                '1�ł����݂��Ȃ����[�N�V�[�g�������Ă͂Ȃ�Ȃ�
                lstWorksheet_IsValid = False
                Exit Function
            End If
        End If
    Next i
    
    '1���I������Ă��Ȃ��ꍇ��False�Ń��[�v�𔲂���
End Function

Public Function WorksheetExists(ByVal wb As Workbook, ByVal strWorksheetName As String) As Boolean
    Dim i As Long
    For i = 1 To wb.Worksheets.Count
        If Worksheets(i).Name = strWorksheetName Then
            WorksheetExists = True
            Exit Function
        End If
    Next i
    WorksheetExists = False
End Function

Public Function WorkbookExists(ByVal strWorkbookName As String) As Boolean
    Dim i As Long
    For i = 1 To Application.Workbooks.Count
        If Application.Workbooks(i).Name = strWorkbookName Then
            WorkbookExists = True
            Exit Function
        End If
    Next i
    WorkbookExists = False
End Function

''' �v�����^�ݒ� _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

Private Sub cmbPrinter_Change()
    If cmbPrinter_IsValid Then
        cmbPrinter.ForeColor = RGB(0, 0, 0)
        btnPrinterConfig.Enabled = True
        btnSave.Enabled = True
        btnRestore.Enabled = True
    Else
        cmbPrinter.ForeColor = RGB(255, 0, 0)
        btnPrinterConfig.Enabled = False
        btnSave.Enabled = False
        btnRestore.Enabled = False
    End If
End Sub

Private Sub btnPrinterConfig_Click()
    If cmbPrinter_IsValid Then clsPrinters.ShowSetting cmbPrinter.Value
End Sub

Private Sub btnSave_Click()
    If cmbPrinter_IsValid Then clsPrinters.SaveSetting cmbPrinter.Value
End Sub

Private Sub btnRestore_Click()
    If cmbPrinter_IsValid Then clsPrinters.RestoreSetting cmbPrinter.Value
End Sub

Private Sub txtCopy_Change()
    If txtCopy_IsValid() Then
        txtCopy.ForeColor = RGB(0, 0, 0)
    Else
        txtCopy.ForeColor = RGB(255, 0, 0)
    End If
End Sub

Private Sub spnCopy_SpinDown()
    If txtCopy_IsValid() Then
        If CLng(txtCopy.Value) > 1 Then txtCopy.Value = CLng(txtCopy.Value) - 1
    End If
End Sub

Private Sub spnCopy_SpinUp()
    If txtCopy_IsValid() Then
        txtCopy.Value = CLng(txtCopy.Value) + 1
    End If
End Sub

Private Function txtCopy_IsValid() As Boolean
    If txtCopy.Value <> "" Then
        If IsNumeric(txtCopy.Value) = True Then
            If txtCopy.Value <> "0" Then
                txtCopy_IsValid = True
                Exit Function
            End If
        End If
    End If
    
    txtCopy_IsValid = False
    
End Function

Private Function cmbPrinter_IsValid() As Boolean
    If cmbPrinter.Value <> "" Then
        If clsPrinters.PrinterExists(cmbPrinter.Value) = True Then
            cmbPrinter_IsValid = True
            Exit Function
        End If
    End If
    
    cmbPrinter_IsValid = False
    
End Function
