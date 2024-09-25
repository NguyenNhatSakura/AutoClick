Func _settextstart()
   If GUICtrlRead($start) = 'Start' Then
	  GUICtrlSetData($start, 'Stop')
	  _hideshutdown($Gui_Disable)
	  _GUICtrlStatusBar_SetText($hStatus, 'Auto Shutdown Is Running Now')
   Else
	  GUICtrlSetData($start, 'Start')
	  _hideshutdown($Gui_Enable)
	  _GUICtrlStatusBar_SetText($hStatus, 'Auto Shutdown Has Stop Working')
   EndIf
EndFunc

Func _hideshutdown($a)
   GUICtrlSetState($shutdown, $a)
   GUICtrlSetState($logoff, $a)
   GUICtrlSetState($standby, $a)
   GUICtrlSetState($msgbox, $a)
   GUICtrlSetState($shutdownluc, $a)
   GUICtrlSetState($shutdownsau, $a)
   GUICtrlSetState($shutdownclose, $a)
   GUICtrlSetState($shutdownopen, $a)
   GUICtrlSetState($gio, $a)
   GUICtrlSetState($phut, $a)
   GUICtrlSetState($inputsau, $a)
EndFunc

Func _gettitle()
   GUICtrlSetData($inputopen, WinGetTitle(''))
   GUICtrlSetData($inputclose, WinGetTitle(''))
EndFunc

Global $demnguoc
Func _Shutdown()
   GUICtrlSetData($inputtimepc, @HOUR&' : '&@MIN&' : '&@SEC)
   If GUICtrlRead($start) = 'Stop' Then
	  Select
		 Case GUICtrlRead($shutdownluc)=1
			If @HOUR >= GUICtrlRead($gio) And @MIN >= GUICtrlRead($phut) Then _startshutdown()
		 Case GUICtrlRead($shutdownsau)=1
			If @MIN <> $demnguoc Then
			   $demnguoc = @MIN
			   GUICtrlSetData($inputsau, GUICtrlRead($inputsau) - 1)
			ElseIf GUICtrlRead($inputsau) <= 0 Then 
			   _startshutdown()
			EndIf
		 Case GUICtrlRead($shutdownopen)=1
			If WinExists(GUICtrlRead($inputopen)) Then _startshutdown()
		 Case GUICtrlRead($shutdownclose)=1
			If WinExists(GUICtrlRead($inputclose)) = False Then _startshutdown()
	  EndSelect
   EndIf
EndFunc

Func _startshutdown()
   Select
	  Case GUICtrlRead($shutdown)=1
		 _settextstart()
;~ 		 MsgBox(0, 'MsgBox', 'Đến Giờ Rồi')
		 Shutdown(1)
	  Case GUICtrlRead($logoff)=1
		 _settextstart()
;~ 		 MsgBox(0, 'MsgBox', 'Đến Giờ Rồi')
		 Shutdown(0)
	  Case GUICtrlRead($standby)=1
		 _settextstart()
;~ 		 MsgBox(0, 'MsgBox', 'Đến Giờ Rồi')
		 Shutdown(32)
	  Case GUICtrlRead($msgbox)=1
		 _settextstart()
		 Beep()
		 MsgBox(0, 'MsgBox', 'Đến giờ rồi')
   EndSelect
   If GUICtrlRead($msgbox) = 1 Then MsgBox(0, 'MsgBox', 'Đến Giờ Rồi')
EndFunc

Func _SuspendThread($NameFunction, $ReturnType = "none", $Params = "")
   Local $Dll = DLlopen("kernel32.dll")
   $HandleThread = DLLCallbackRegister($NameFunction, $ReturnType, $Params)
   DllCall($Dll, "dword", "SuspendThread", "ptr", DllCallbackGetPtr($HandleThread))
   DllClose($dll)
EndFunc

 Func _CreateThread($ThreadName, $ReturnType = "none", $Params = "")
    Local $Dll = DLlopen("kernel32.dll")
    $HandleThread = DLLCallbackRegister($ThreadName, $ReturnType, $Params)
    Dllcall($Dll,"ptr","CreateThread","ptr",0,"int",0 ,"ptr",DllCallbackGetPtr($HandleThread),"ptr",0,"dword", 0,"ptr",0)
    DllClose($dll)
EndFunc

Func _savelist()
   $pathsave = FileSaveDialog('Save List', '', 'Ini File (*.ini)', 16, 'list'&Random(1, 9999, 1)&'.ini')
   For $k = 0 To _GUICtrlListView_GetItemCount($hListView)-1
	  $Item = _GUICtrlListView_GetItemTextArray($hListView, $k)
	  $data = ''
	  For $i = 1 To $Item[0]
        $data &= $Item[$i]&'|'
	  Next
	  IniWrite($pathsave, 'ListClick', $k, $data)
   Next
EndFunc

Func _loadlist()
   $pathopen = FileOpenDialog('Save List', '', 'Ini File (*.ini)')
   For $k = 0 To 9999
	  If IniRead($pathopen, 'ListClick', $k, '') <> '' Then
		 GUICtrlCreateListViewItem(IniRead($pathopen, 'ListClick', $k, ''), $hListView)
		 $Item = _GUICtrlListView_GetItemTextArray($hListView, $k)
		 _GUICtrlListView_SetItem($hListView, WinGetHandle($Item[6]), $k, 4)
	  Else
		 ExitLoop
	  EndIf
   Next
EndFunc

Func _setdelayitem()
   For $k = 0 To _GUICtrlListView_GetItemCount($hListView)-1
	  If _GUICtrlListView_GetItemSelected($hListView, $k) Then
		 _GUICtrlListView_SetItem($hListView, InputBox('Record', 'Delay Time:', 1000, Default, 50, 30), $k, 3)
		 ExitLoop
	  EndIf
   Next
EndFunc

Func _DeleteAllItem()
   _GUICtrlListView_DeleteAllItems($hListView)
EndFunc

Func _record()
	DllStructSetData($Struct,'x',MouseGetPos(0))
	DllStructSetData($Struct,'y',MouseGetPos(1))
	$hwnd= _WinAPI_WindowFromPoint($Struct)
	_WinAPI_ScreenToClient($hwnd,$Struct)
	$x= DllStructGetData($Struct,'x')
	$y= DllStructGetData($Struct,'y')
	$delayrc = InputBox('Record', 'Delay Time:', 1000, Default, 50, 30)
	$mouserc = InputBox('Record', 'Button:'&@CRLF&'Show: left, right, middle, main, menu, primary, secondary'&@CRLF&'Hide_1: Left, Right, Middle or Move'&@CRLF&'Hide_2 And Hide_4: Left, Right'&@CRLF&'Hide_3: Left, Right, Control', 'Left')
	$title = WinGetTitle($hwnd)
	$fullpath = _ProcessGetLocation(WinGetProcess($hwnd))
	GUICtrlCreateListViewItem($x&"|"&$y&'|'&$mouserc&'|'&$delayrc&'|'&$hwnd&'|'&$title&'|'&$fullpath, $hListView)
EndFunc

Func _ProcessGetLocation($iPID)
    Local $aProc = DllCall('kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
    If $aProc[0] = 0 Then Return SetError(1, 0, '')
    Local $vStruct = DllStructCreate('int[1024]')
    DllCall('psapi.dll', 'int', 'EnumProcessModules', 'hwnd', $aProc[0], 'ptr', DllStructGetPtr($vStruct), 'int', DllStructGetSize($vStruct), 'int_ptr', 0)
    Local $aReturn = DllCall('psapi.dll', 'int', 'GetModuleFileNameEx', 'hwnd', $aProc[0], 'int', DllStructGetData($vStruct, 1), 'str', '', 'int', 2048)
    If StringLen($aReturn[3]) = 0 Then Return SetError(2, 0, '')
    Return $aReturn[3]
EndFunc

Global $hotkeystart1 = '', $hotkeystart2 = 'F3'
Func _sethotkeystart()
	HotKeySet($hotkeystart1&'{'&$hotkeystart2&'}')
	$hotkeystart1 = _convertkey(GUICtrlRead($combokeystart1))
	$hotkeystart2 = GUICtrlRead($combokeystart2)
	HotKeySet($hotkeystart1&'{'&$hotkeystart2&'}', '_startclick')
EndFunc

Global $hotkeyrc1 = '', $hotkeyrc2 = 'F4'
Func _sethotkeyrc()
	HotKeySet($hotkeyrc1&'{'&$hotkeyrc2&'}')
	$hotkeyrc1 = _convertkey(GUICtrlRead($combohotkeyrc1))
	$hotkeyrc2 = GUICtrlRead($combohotkeyrc2)
	HotKeySet($hotkeyrc1&'{'&$hotkeyrc2&'}', '_record')
EndFunc

Func _convertkey($key)
	Local $return
	Switch $key
		Case 'Ctrl'
			$return = '^'
		Case 'Shift'
			$return = '+'
		Case 'Ctrl+Alt'
			$return = '^!'
		Case 'None'
			$return = ''
	EndSwitch
	Return $return
EndFunc

Func _startclick()
   $statusclick = Not $statusclick
   $stt = 0
   If $statusclick = True Then 
	  WinSetState ($Form1, "", @SW_DISABLE)
	  _GUICtrlStatusBar_SetText($hStatus, "AutoClick Is Clicking Now")
   Else
	  WinSetState ($Form1, "", @SW_ENABLE)
	  _GUICtrlStatusBar_SetText($hStatus, "AutoClick Has Stop Working")
   EndIf
EndFunc

Global $delayclick, $stt=0
Func _click()
   If GUICtrlRead($smartclick) <> 1 Then
	  If TimerDiff($delayclick) > GUICtrlRead($timedelay) Then 
		 If GUICtrlRead($click) = 'Single' Then
			MouseClick(GUICtrlRead($mouse))
		 Else
			MouseClick(GUICtrlRead($mouse))
			MouseClick(GUICtrlRead($mouse))
		 EndIf
		 $delayclick = TimerInit()
	  EndIf
   Else
	  $Item = _GUICtrlListView_GetItemTextArray($hListView, $stt)
	  If TimerDiff($delayclick) > $Item[4] Then
		 _GUICtrlStatusBar_SetText($hStatus, "Click: "&$Item[1]&' - '&$Item[2]&' | '&$Item[3])
		 Switch GUICtrlRead($typeclick)
			Case 'Show'
			   _MouseClick_Sakura($Item[5], $Item[1], $Item[2], $Item[3])
			Case 'Hide_1'
			   _MouseClick_WinAPI($Item[5], $Item[1], $Item[2], $Item[3])
			Case 'Hide_2'
			   _MouseClick_Sai($Item[5], $Item[1], $Item[2], $Item[3])
			Case 'Hide_3'
			   _MouseeClick_VL($Item[5], $Item[1], $Item[2], $Item[3])
			Case 'Hide_4'
			   _MouseClickPlus($Item[5], $Item[1], $Item[2], $Item[3])
		 EndSwitch
		 If $stt < _GUICtrlListView_GetItemCount($hListView)-1 Then
			$stt += 1
		 Else
			$stt = 0
		 EndIf
		 $delayclick = TimerInit()
	  EndIf
	EndIf
EndFunc

Func _thoat()
;~ 	For $k = 368 To 0 Step -1;368 = 333 + 35
;~ 		WinMove($Form1,'',Default, Default, Default, $k)
;~ 	Next
	Exit
EndFunc

Func _visible($visible)
	If BitAND(WinGetState($visible), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc
 
Func _hide()
	$program= _GUICtrlListBox_GetCurSel($listshow)
	$text= _GUICtrlListBox_GetText($listshow,$program)
	_GUICtrlListBox_DeleteString($listshow,$program)
	_GUICtrlListBox_AddString($listhide,$text)
	WinSetState($text,'',@SW_HIDE)
EndFunc
 
Func _show()
	$program= _GUICtrlListBox_GetCurSel($listhide)
	$text= _GUICtrlListBox_GetText($listhide,$program)
	_GUICtrlListBox_DeleteString($listhide,$program)
	_GUICtrlListBox_AddString($listshow,$text)
	WinSetState($text,'',@SW_SHOW)
EndFunc
 
 Func _bluropt()
	$program= _GUICtrlListBox_GetCurSel($listshow)
	$text= _GUICtrlListBox_GetText($listshow,$program)
	$read= GUICtrlRead($Slider1)
	WinSetTrans($text,'',$read)
EndFunc
 
Func _refesh()
   _GUICtrlListBox_ResetContent($listshow)
	$view= WinList()
	For $i= 1 To $view[0][0]
		If $view[$i][0] <> '' And $view[$i][0]<> 'Program Manager' And _visible($view[$i][1]) Then
			_GUICtrlListBox_AddString($listshow,$view[$i][0])
		EndIf
	Next
EndFunc
 
Func _showgui()
	GUISetState(@SW_SHOW, $FORM1)
	GUISetState(@SW_RESTORE, $FORM1)
	WinSetOnTop($FORM1, "", 1)
 EndFunc
 
Func _minimize()
	GUISetState(@SW_HIDE, $FORM1)
	WinSetOnTop($FORM1, "", 0)
EndFunc

Func _CreateGui()
   #Region ### START Koda GUI section ### Form=d:\autoit\koda\forms\guiautoclick.kxf
   Global $Form1 = GUICreate("Auto Click Sakura", 358, 333, -1, @DesktopHeight/2-166.5)
   GUISetOnEvent($GUI_EVENT_CLOSE, '_thoat')
   GUISetOnEvent($GUI_EVENT_MINIMIZE, '_minimize')
   Global $Tab1 = GUICtrlCreateTab(0, 0, 361, 313)
   Global $TabSheet1 = GUICtrlCreateTabItem("AutoClick")
   Global $setting = GUICtrlCreateGroup("Setting", 8, 24, 345, 281)
   GUICtrlSetBkColor(-1, 0xFFFFFF)
   Global $settingclick = GUICtrlCreateGroup("", 16, 32, 113, 73)
   Global $Label1 = GUICtrlCreateLabel("Mouse", 24, 48, 36, 17)
   Global $mouse = GUICtrlCreateCombo("Left", 64, 48, 57, 25)
   GUICtrlSetData(-1, "Right")
   Global $label2 = GUICtrlCreateLabel("Click", 24, 80, 27, 17)
   Global $click = GUICtrlCreateCombo("Single", 64, 80, 57, 25)
   GUICtrlSetData(-1, "Double")
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   Global $Group1 = GUICtrlCreateGroup("Auto Click Hotkey", 248, 32, 97, 73)
   Global $combokeystart1 = GUICtrlCreateCombo("None", 264, 48, 65, 25)
   GUICtrlSetData(-1, "Ctrl|Ctrl+Alt|Shift")
   GUICtrlSetOnEvent(-1, '_sethotkeystart')
   Global $Label3 = GUICtrlCreateLabel("+", 256, 64, 10, 17)
   Global $Combokeystart2 = GUICtrlCreateCombo("F3", 264, 80, 65, 25)
   GUICtrlSetData(-1, "F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12")
   GUICtrlSetOnEvent(-1, '_sethotkeystart')
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   Global $Group2 = GUICtrlCreateGroup("Click Interval", 136, 32, 105, 73)
   Global $Label4 = GUICtrlCreateLabel("Delay: miniseconds", 144, 48, 95, 17)
   Global $timedelay = GUICtrlCreateInput("10", 152, 72, 73, 21)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   Global $Group3 = GUICtrlCreateGroup("Smart Click", 16, 112, 329, 185)
   Global $smartclick = GUICtrlCreateCheckbox("Smart Click", 24, 128, 73, 17)
   Global $Group4 = GUICtrlCreateGroup("Record Hotkey", 248, 120, 89, 73)
   Global $combohotkeyrc1 = GUICtrlCreateCombo("None", 264, 136, 65, 25)
   GUICtrlSetData(-1, "Ctrl|Ctrl+Alt|Shift")
   GUICtrlSetOnEvent(-1, '_sethotkeyrc')
   Global $Label5 = GUICtrlCreateLabel("+", 256, 152, 10, 17)
   Global $combohotkeyrc2 = GUICtrlCreateCombo("F4", 264, 168, 65, 25)
   GUICtrlSetData(-1, "F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12")
   GUICtrlSetOnEvent(-1, '_sethotkeyrc')
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   Global $hListView = GUICtrlCreateListView("X|Y|Button|Delay|Hwnd|Title|Path", 24, 152, 218, 134)
   Global $clearlistclick = GUICtrlCreateButton("Clear", 248, 224, 91, 17)
   GUICtrlSetOnEvent(-1, '_DeleteAllItem')
   Global $setdelay = GUICtrlCreateButton("Set Delay", 248, 200, 91, 17)
   GUICtrlSetOnEvent(-1, '_setdelayitem')
   Global $savelist = GUICtrlCreateButton("Save List", 248, 248, 91, 17)
   GUICtrlSetOnEvent(-1, '_savelist')
   Global $loadlist = GUICtrlCreateButton("Load List", 248, 272, 91, 17)
   GUICtrlSetOnEvent(-1, '_loadlist')
   Global $Label6 = GUICtrlCreateLabel("Type Click", 112, 128, 54, 17)
   Global $typeclick = GUICtrlCreateCombo("Show", 168, 128, 73, 25)
   GUICtrlSetData(-1, "Hide_1|Hide_2|Hide_3|Hide_4")
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   Global $TabSheet2 = GUICtrlCreateTabItem("AutoShutdown")
   Global $inputtimepc = GUICtrlCreateInput(@HOUR&' : '&@MIN&' : '&@SEC, 96, 48, 169, 32, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
   GUICtrlSetFont(-1, 13, 800, 0, "MS Sans Serif")
   GUICtrlSetColor(-1, 0xFF0000)
   Global $shutdownluc = GUICtrlCreateRadio("Thực hiện vào lúc", 8, 152, 102, 17)
   GUICtrlSetState(-1, 1)
   Global $gio = GUICtrlCreateInput("None", 112, 152, 57, 21)
   GUICtrlCreateUpdown(-1)
   GUICtrlSetLimit(-1, 24, 1)
   Global $Label7 = GUICtrlCreateLabel("Giờ", 176, 152, 20, 17)
   GUICtrlSetBkColor(-1, 0xFFFFFF)
   Global $phut = GUICtrlCreateInput("None", 200, 152, 57, 21, -1)
   GUICtrlCreateUpdown(-1)
   GUICtrlSetLimit(-1, 60, 1)
   Global $Label8 = GUICtrlCreateLabel("Phút", 264, 152, 26, 17)
   GUICtrlSetBkColor(-1, 0xFFFFFF)
   Global $shutdownsau = GUICtrlCreateRadio("Thực hiện sau", 8, 176, 97, 17)
   Global $inputsau = GUICtrlCreateInput("None", 112, 176, 57, 21, -1)
   GUICtrlCreateUpdown(-1)
   GUICtrlSetLimit(-1, 99999, 1)
   Global $shutdownclose = GUICtrlCreateRadio("Thực hiện khi tắt cửa sổ", 8, 200, 137, 17)
   Global $Inputclose = GUICtrlCreateInput("None", 152, 200, 97, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
   Global $Label9 = GUICtrlCreateLabel("Ctrl+F1 để get cửa sổ", 256, 200, 102, 17)
   GUICtrlSetBkColor(-1, 0xFFFFFF)
   Global $shutdownopen = GUICtrlCreateRadio("Thực hiện khi mở cửa sổ", 8, 224, 137, 17)
   Global $inputopen = GUICtrlCreateInput("None", 152, 224, 97, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
   Global $Label10 = GUICtrlCreateLabel("Ctrl+F1 để get cửa sổ", 256, 224, 102, 17)
   GUICtrlSetBkColor(-1, 0xFFFFFF)
   Global $Label11 = GUICtrlCreateLabel("Phút", 176, 176, 25, 17)
   GUICtrlSetBkColor(-1, 0xFFFFFF)
   Global $Group5 = GUICtrlCreateGroup("", 16, 104, 329, 41)
   Global $shutdown = GUICtrlCreateRadio("Shutdown", 24, 120, 73, 17)
   GUICtrlSetState(-1, 1)
   Global $logoff = GUICtrlCreateRadio("Logoff", 112, 120, 49, 17)
   Global $standby = GUICtrlCreateRadio("Standby", 192, 120, 57, 17)
   Global $msgbox = GUICtrlCreateRadio("MsgBox", 272, 120, 65, 17)
   Global $start = GUICtrlCreateButton("Start", 128, 280, 115, 25)
   GUICtrlSetOnEvent(-1, '_settextstart')
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   Global $TabSheet3 = GUICtrlCreateTabItem("HideWindown")
   Global $Listshow = GUICtrlCreateList("", 8, 24, 105, 279)
   Global $Listhide = GUICtrlCreateList("", 248, 24, 105, 279)
   Global $hidewindown = GUICtrlCreateButton("Hide ==>", 120, 128, 123, 17)
   GUICtrlSetOnEvent(-1, '_hide')
   Global $showwindown = GUICtrlCreateButton("<== Show", 120, 152, 123, 17)
   GUICtrlSetOnEvent(-1, '_show')
   Global $Slider1 = GUICtrlCreateSlider(120, 176, 126, 21)
   GUICtrlSetOnEvent(-1, '_bluropt')
   GUICtrlSetLimit(-1, 255, 50)
   GUICtrlSetData(-1, 20)
   GUICtrlSetBkColor(-1, 0xFFFFFF)
   GUICtrlSetData(-1, 255)
   Global $refesh = GUICtrlCreateButton("Refesh", 120, 104, 123, 17)
   GUICtrlSetOnEvent(-1, '_refesh')
   TrayCreateItem("")
   TrayCreateItem("Show")
   TrayItemSetOnEvent(-1, "_ShowGUI")
   TrayCreateItem("Thoát")
   TrayItemSetOnEvent(-1, "_thoat")
   TraySetClick(16)
   TraySetOnEvent(-13, '_showGui')
   GUISetState(@SW_SHOW)
;~    WinSetOnTop($Form1, '', 1)
   ;============RunGui==============
;~    For $k = 0 To 368 Step 1;368 = 333 + 35
;~ 	  WinMove($Form1,'', Default, Default, Default, $k)
;~    Next
   Global $hStatus = _GUICtrlStatusBar_Create($Form1)
   _GUICtrlStatusBar_SetText($hStatus, "AutoClick Has Stop Working")
   ;================================
   #EndRegion ### END Koda GUI section ###
EndFunc
