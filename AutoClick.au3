$listauto = WinList()
For $k = 1 To $listauto[0][0]
	If WinGetTitle($listauto[$k][1]) = 'Auto Click Sakura' Then
		WinSetState('Auto Click Sakura', "", @SW_SHOW)
		WinActivate('Auto Click Sakura')
		_thoat()
	EndIf
Next 

#RequireAdmin
#include <GUIListBox.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WinAPI.au3>
#Include <GuiListView.au3>
#Include <TypeClick.au3>
#Include <_Function.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)
AutoItSetOption("TrayOnEventMode", 1)
AutoItSetOption("TrayMenuMode", 3)
HotKeySet('^{F1}', '_gettitle')
HotKeySet('{F3}', '_startclick')
HotKeySet('{F4}', '_record')
HotKeySet('{Esc}', '_thoat')

_CreateGui()
_refesh()

Global $Struct= DllStructCreate($tagPoint)
Global $statusclick=0

While 1
   _Shutdown()
	If $statusclick = True Then 
		_click()
	EndIf
	Sleep(2)
WEnd