#cs
	Tổng Hợp Các Hàm Click Ẩn + Send Ẩn By tackesaomai
					--------------
   _MouseClick_Hy($handle, $tdx, $tdy, $button = "Left", $click = 1)
   _MouseClickPlus($Hand, $X = "", $Y = "", $Button = "left", $Clicks = 1)
   _MouseClick_Sai($GameHandle, $x=0, $y=0, $button = "left")
   _MouseeClick_VL($hwnd, $x, $y, $type = 'left')
   _MouseClick_WinAPI($hwnd, $x=0, $y=0, $button='Left Click')
					--------------
#ce
;~ GLOBAL Const $TAGPOINT 					= "struct;long X;long Y;endstruct"
;~ Global 		 $Struct 					= DllStructCreate($tagPoint)
Global Const $Hy_MOUSEMOVE              = 0x200
Global Const $Hy_LBUTTONDOWN            = 0x201
Global Const $Hy_LBUTTONUP              = 0x202
Global Const $Hy_MBUTTONDOWN            = 0x207
Global Const $Hy_MBUTTONUP              = 0x208
Global Const $Hy_RBUTTONDOWN            = 0x204
Global Const $Hy_RBUTTONUP              = 0x205
Global Const $Hy_NCLBUTTONDOWN          = 0xA1
Global Const $Hy_LBUTTONDBLCLK          = 0x203
Global Const $Hy_MBUTTONDBLCLK          = 0x209
Global Const $Hy_RBUTTONDBLCLK          = 0x206
Global Const $Hy_LBUTTON                = 0x1
Global Const $Hy_MBUTTON                = 0x10
Global Const $Hy_RBUTTON                = 0x2
Global Const $Hy_SETREDRAW              = 0xB
Global Const $Hy_ERASEBKGND             = 0x14
Const $Hy_CONTROL 						= 0x8
;~ Func _WinAPI_PostMessage($hWnd, $iMsg, $iwParam, $ilParam)
;~ 	Local $aResult = DllCall("user32.dll", "bool", "PostMessage", "hwnd", $hWnd, "uint", $iMsg, "wparam", $iwParam, "lparam", $ilParam)
;~ 	If @error Then Return SetError(@error, @extended, False)
;~ 	Return $aResult[0]
;~ EndFunc   ;==>_WinAPI_PostMessage



;==========================================================

;==========================================================

;==========================================================
;			MouseClick_Hy($handle, $x, $y)
;==========================================================
Func _MouseClick_Sakura($handle, $tdx, $tdy, $button = "Left", $click = 1)
	$tdx2 = MouseGetPos(0)
    $tdy2 = MouseGetPos(1)
    Local $tpoint = DllStructCreate("int X;int Y")
    DllStructSetData($tpoint, "X", $tdx)
    DllStructSetData($tpoint, "Y", $tdy)
    Local $pPoint = DllStructGetPtr($tPoint)
    DllCall("user32.dll", "bool", "ClientToScreen", "hwnd", $handle, "ptr", $pPoint)
    $tdx = DllStructGetData($tpoint, "X")
    $tdy = DllStructGetData($tpoint, "Y")
    $tpoint=0;~ free $tpoint
    $pPoint=0;~ free $pPoint
	DllCall("user32.dll", "long", "SetCursorPos", "long", $tdx, "long", $tdy)
	For $k = 1 To $click
		MouseClick($button, $tdx, $tdy)
	Next
	DllCall("user32.dll", "long", "SetCursorPos", "long", $tdx2, "long", $tdy2)
EndFunc


;==========================================================
; MouseClick_Sai($GameHandle, $x=0, $y=0, $button = "left")
;==========================================================
Func _MouseClick_Sai($GameHandle, $x=0, $y=0, $button = "left", $click = 1)
    Local $Compile = 0
    If Not $x Then $x = Random(100,650,1)
    If Not $y Then $y = Random(100,500,1)
    $button = StringLower($button)
    Switch $button
        Case "left"
            Local $Down = 0x0201
            Local $Up = 0x0202
        Case "right"
            Local $Down = 0x0204
            Local $Up = 0x0205
	EndSwitch
	For $k = 1 To $click
		DllCall("user32.dll", "int", "SendMessage", "hwnd", $GameHandle, "int", $Down, "int", $Compile, "int", FMakeLong($x,$y))
		DllCall("user32.dll", "int", "SendMessage", "hwnd", $GameHandle, "int", $Up, "int", $Compile, "int", FMakeLong($x,$y))
	Next
EndFunc

Func FMakeLong($LoWord,$HiWord)
    Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc


;===========================================================
;    MouseClickPlus($Window, $Button = "left", $X = "", $Y = "", $Clicks = 1)
;===========================================================
Func _MouseClickPlus($Hand, $X = "", $Y = "", $Button = "left", $Clicks = 1)
	Local $MK_LBUTTON = 0x0001
	Local $WM_LBUTTONDOWN = 0x0201
	Local $WM_LBUTTONUP = 0x0202
	Local $MK_RBUTTON = 0x0002
	Local $WM_RBUTTONDOWN = 0x0204
	Local $WM_RBUTTONUP = 0x0205
	Local $WM_MOUSEMOVE = 0x0200
	Local $i = 0
	Select
		Case $Button = "left"
			$Button = $MK_LBUTTON
			$ButtonDown = $WM_LBUTTONDOWN
			$ButtonUp = $WM_LBUTTONUP
		Case $Button = "right"
			$Button = $MK_RBUTTON
			$ButtonDown = $WM_RBUTTONDOWN
			$ButtonUp = $WM_RBUTTONUP
	EndSelect
	If $X = "" OR $Y = "" Then
		$MouseCoord = MouseGetPos()
		$X = $MouseCoord[0]
		$Y = $MouseCoord[1]
	EndIf
	For $i = 1 to $Clicks
		DllCall("user32.dll", "int", "SendMessage", "hwnd", $Hand, "int", $WM_MOUSEMOVE, "int", 0, "long", _MakeLong($X, $Y))
		DllCall("user32.dll", "int", "SendMessage", "hwnd", $Hand, "int", $ButtonDown, "int", $Button, "long", _MakeLong($X, $Y))
		DllCall("user32.dll", "int", "SendMessage", "hwnd", $Hand, "int", $ButtonUp, "int", $Button, "long", _MakeLong($X, $Y))
	Next
EndFunc

Func _MakeLong($LoWord,$HiWord)
	Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc



;===========================================================
;		MoveClick_VL($hwnd, $x, $y, $type = 'left')
;===========================================================
Func SetCursorPos($arg1,$arg2)
	DllCall("user32.dll", "long", "SetCursorPos", "long", $arg1, "long", $arg2)
EndFunc
Func PostMessage($Arg00, $Arg01, $Arg02, $Arg03)
	DllCall("user32.dll", "lresult", "PostMessageA", "hwnd", $Arg00, "uint", $Arg01, "wparam", $Arg02, "lparam", $Arg03)
EndFunc

Func _MouseeClick_VL($Lchwnd, $x, $y, $type = 'left', $click = 1)
    $x2 = MouseGetPos(0)
    $y2 = MouseGetPos(1)
    DllStructSetData($Struct, "x", $x)
    DllStructSetData($Struct, "y", $y)
	DllCall('user32.dll', "bool", "ClientToScreen", "hwnd", $lchwnd, "struct*", $Struct)
    $x1=DllStructGetData($Struct,"x")
    $y1=DllStructGetData($Struct,"y")
    SetCursorPos($x1,$y1)
    $pt = $X + $Y * 0x10000
    PostMessage($LcHwnd, $Sakura_MOUSEMOVE, 0, $pt)
	For $k = 1 To $click
		Switch $type
			Case 'left'
				PostMessage($LcHwnd, $Sakura_LBUTTONDOWN, $Sakura_LBUTTON, $pt)
				PostMessage($LCHwnd, $Sakura_LBUTTONUP, $Sakura_LBUTTON, $pt)
			Case 'right'
				PostMessage($LcHwnd, $Sakura_RBUTTONDOWN, $Sakura_RBUTTON, $pt)
				PostMessage($LcHwnd, $Sakura_RBUTTONUP, $Sakura_RBUTTON, $pt)
			Case 'control'
				PostMessage($LcHwnd, $Sakura_RBUTTONDOWN, $Sakura_CONTROL, $pt)
				PostMessage($LcHwnd, $Sakura_RBUTTONUP, $Sakura_CONTROL, $pt)
		EndSwitch
	Next
    SetCursorPos($x2,$y2)
EndFunc


;============================================================
;  MoveClick_WinAPI($hwnd, $x=0, $y=0, $button='Left Click')
;============================================================
 Func _MouseClick_WinAPI($hwnd, $x=0, $y=0, $button='Left', $click = 1)
	$lParam = ($y * 65536) + ($x)
	For $k = 1 To $click
		Switch $button
			Case $button='Left'
				_WinAPI_PostMessage($hwnd, $Sakura_LBUTTONDOWN, $Sakura_LBUTTON,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_LBUTTONUP, 0,$lParam)
			Case $button='Left Double'
				_WinAPI_PostMessage($hwnd, $Sakura_LBUTTONDOWN, $Sakura_LBUTTON,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_LBUTTONUP, 0,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_LBUTTONDBLCLK, $Sakura_LBUTTON,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_LBUTTONUP, 0,$lParam)
			Case $button='Middle'
				_WinAPI_PostMessage($hwnd, $Sakura_MBUTTONDOWN, $Sakura_MBUTTON,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_MBUTTONUP, 0,$lParam)
			Case $button='Middle Double'
				_WinAPI_PostMessage($hwnd, $Sakura_MBUTTONDOWN, $Sakura_MBUTTON,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_MBUTTONUP, 0,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_MBUTTONDBLCLK, $Sakura_MBUTTON,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_MBUTTONUP, 0,$lParam)
			Case $button='Right'
				_WinAPI_PostMessage($hwnd, $Sakura_RBUTTONDOWN, $Sakura_RBUTTON,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_RBUTTONUP, 0,$lParam)
			Case $button='Right Double'
				_WinAPI_PostMessage($hwnd, $Sakura_RBUTTONDOWN, $Sakura_RBUTTON,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_RBUTTONUP, 0,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_RBUTTONDBLCLK, $Sakura_RBUTTON,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_RBUTTONUP, 0,$lParam)
			Case $button='Move'
				_WinAPI_PostMessage($hwnd, $Sakura_MOUSEMOVE, 0,$lParam)
				_WinAPI_PostMessage($hwnd, $Sakura_MOUSEMOVE, 0,$lParam)
		EndSwitch
	Next
EndFunc