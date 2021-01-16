; V1.0.0 
; The MIT License
; Copyright © 2020 Logan McGhee
; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
; The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
; THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Recommended for catching common errors.
#SingleInstance, force

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

ToggleHotkey= +Space

global jitterValue
global Flask1Dur
global Flask2Dur
global Flask3Dur
global Flask4Dur
global Flask5Dur
global Flask1Active
global Flask2Active
global Flask3Active
global Flask4Active
global Flask5Active
global Share12
global Share13
global Share23
global Share14
global Share24
global Share34
global Share15
global Share25
global Share35
global Share45



; ========
; Load Settings
; ========
IniRead, jitterValue, Flask.ini, App Settings, jitterValue, 25
IniRead, Flask1Dur, Flask.ini, App Settings, Flask1Dur, 4.00
IniRead, Flask2Dur, Flask.ini, App Settings, Flask2Dur, 4.00
IniRead, Flask3Dur, Flask.ini, App Settings, Flask3Dur, 4.00
IniRead, Flask4Dur, Flask.ini, App Settings, Flask4Dur, 4.00
IniRead, Flask5Dur, Flask.ini, App Settings, Flask5Dur, 4.00
IniRead, Flask1Active, Flask.ini, App Settings, Flask1Active, 4.00
IniRead, Flask2Active, Flask.ini, App Settings, Flask2Active, 4.00
IniRead, Flask3Active, Flask.ini, App Settings, Flask3Active, 4.00
IniRead, Flask4Active, Flask.ini, App Settings, Flask4Active, 4.00
IniRead, Flask5Active, Flask.ini, App Settings, Flask5Active, 4.00
; IniRead, ToggleHotkey, Flask.ini, App Settings, ToggleHotkey, +Space

IniRead, Share12, Flask.ini, App Settings, Share12, 0
IniRead, Share13, Flask.ini, App Settings, Share13, 0
IniRead, Share23, Flask.ini, App Settings, Share23, 0
IniRead, Share14, Flask.ini, App Settings, Share14, 0
IniRead, Share24, Flask.ini, App Settings, Share24, 0
IniRead, Share34, Flask.ini, App Settings, Share34, 0
IniRead, Share15, Flask.ini, App Settings, Share15, 0
IniRead, Share25, Flask.ini, App Settings, Share25, 0
IniRead, Share35, Flask.ini, App Settings, Share35, 0
IniRead, Share45, Flask.ini, App Settings, Share45, 0

; ========
; End Load Settings
; ========


; ========
; Define Sizes
; ========


; TODO: Define & replace column and row values

column1 := 10
column2 := 35
column3 := 47
column4 := 110
column5 := 135
column6 := 160
column7 := 185
column8 := 210

row1 := 50 ;% " y"row1
row2 := 80 ;% " y"row2
row3 := 110 ;% " y"row3
row4 := 140 ;% " y"row4
row5 := 170 ;% " y"row5

width := 220
height := 325
middle := width/2
baseSpeedMS := 100

runscript := 0

pot1 := {active:false, forceUnactive:false, keys:[1], duration:[Flask1Dur], nextUse: A_TickCount, lastUsed:1}
pot2 := {active:false, forceUnactive:false, keys:[2], duration:[Flask2Dur], nextUse: A_TickCount, lastUsed:1}
pot3 := {active:false, forceUnactive:false, keys:[3], duration:[Flask3Dur], nextUse: A_TickCount, lastUsed:1}
pot4 := {active:false, forceUnactive:false, keys:[4], duration:[Flask4Dur], nextUse: A_TickCount, lastUsed:1}
pot5 := {active:false, forceUnactive:false, keys:[5], duration:[Flask5Dur], nextUse: A_TickCount, lastUsed:1}

#IfWinActive Path of Exile ahk_class POEWindowClass
Hotkey,%ToggleHotkey%,ToggleButt

gui, +AlwaysOnTop ; +ToolWindow

resetButtonWidth := 60
gui, add, button, % "x"width/4-(resetButtonWidth/2) " y"height-30 " w"resetButtonWidth  " gReset", Reset

gui, font, underline
gui, add, text, % " x"column4 " y"10, Shared CD
gui, font


Gui, add, checkbox, % "vFlask1Active gconfigureFlasks x"column1 " y"row1 " w"15 " h"15 " Checked"Flask1Active
gui, add, checkbox, % "vFlask2Active gconfigureFlasks x"column1 " y"row2 " w"15 " h"15 " Checked"Flask2Active
gui, add, checkbox, % "vFlask3Active gconfigureFlasks x"column1 " y"row3 " w"15 " h"15 " Checked"Flask3Active
gui, add, checkbox, % "vFlask4Active gconfigureFlasks x"column1 " y"row4 " w"15 " h"15 " Checked"Flask4Active
gui, add, checkbox, % "vFlask5Active gconfigureFlasks x"column1 " y"row5 " w"15 " h"15 " Checked"Flask5Active


; ========
; Flask Numbering
; ========

gui, add, text, % " x"column4 " y"row1-20, 2
gui, add, text, % " x"column5 " y"row1-20, 3
gui, add, text, % " x"column6 " y"row1-20, 4 
gui, add, text, % " x"column7 " y"row1-20, 5
; gui, add, text, % " x"column8 " y"row1-20, 1

; ========
; In-game flask buttons
; ========

gui, add, text, % " x"column2 " y"row1, 1
gui, add, text, % " x"column2 " y"row2, 2
gui, add, text, % " x"column2 " y"row3, 3 
gui, add, text, % " x"column2 " y"row4, 4
gui, add, text, % " x"column2 " y"row5, 5



; ========
; Flask Timers
; ========

gui, add, edit, % " x"column3 " y"row1-4 " w"50 " vFlask1Dur gAutoSaveLabel", %Flask1Dur%
gui, add, edit, % " x"column3 " y"row2-4 " w"50 " vFlask2Dur gAutoSaveLabel", %Flask2Dur%
gui, add, edit, % " x"column3 " y"row3-4 " w"50 " vFlask3Dur gAutoSaveLabel", %Flask3Dur%
gui, add, edit, % " x"column3 " y"row4-4 " w"50 " vFlask4Dur gAutoSaveLabel", %Flask4Dur%
gui, add, edit, % " x"column3 " y"row5-4 " w"50 " vFlask5Dur gAutoSaveLabel", %Flask5Dur%


; ========
; Checkboxes
; ========

gui, add, checkbox, % " x"column4 " y"row1 " w"15 " h"15 " vShare12 gconfigureFlasks Checked" Share12

gui, add, checkbox, % " x"column5 " y"row1 " w"15 " h"15 " vShare13 gconfigureFlasks Checked" Share13
gui, add, checkbox, % " x"column5 " y"row2 " w"15 " h"15 " vShare23 gconfigureFlasks Checked" Share23

gui, add, checkbox, % " x"column6 " y"row1 " w"15 " h"15 " vShare14 gconfigureFlasks Checked" Share14
gui, add, checkbox, % " x"column6 " y"row2 " w"15 " h"15 " vShare24 gconfigureFlasks Checked" Share24
gui, add, checkbox, % " x"column6 " y"row3 " w"15 " h"15 " vShare34 gconfigureFlasks Checked" Share34

gui, add, checkbox, % " x"column7 " y"row1 " w"15 " h"15 " vShare15 gconfigureFlasks Checked" Share15
gui, add, checkbox, % " x"column7 " y"row2 " w"15 " h"15 " vShare25 gconfigureFlasks Checked" Share25
gui, add, checkbox, % " x"column7 " y"row3 " w"15 " h"15 " vShare35 gconfigureFlasks Checked" Share35
gui, add, checkbox, % " x"column7 " y"row4 " w"15 " h"15 " vShare45 gconfigureFlasks Checked" Share45


; ========
; Toggle Button
; ========

gui, add, text, x15 y200 , Toggle Hotkey:
gui, add, button, x100 y198 w100 h20 gChangeHotkey vToggleHotkeyButtonText, %ToggleHotkey%


; ========
; Jitter Slider Button
; ========

TxtPreset := "Jitter: "
TxtMS := "ms"
; Gui, New, , Slider
gui, add, text, x35 y230 vjitterDisplay, %TxtPreset%%jitterValue%%TxtMS%
gui, Add, Slider, x30 y250 gSliderUpdate vjitterValue ToolTip Range0-50, %jitterValue%
loadButtonWidth := 80
gui, add, button, % "x"width*3/4-(loadButtonWidth/2) " y"height-30 " Default" " w"loadButtonWidth " gGetFlaskCoordinates", Load Flasks


; ========
; Show gui
; ========

gui, show, x451 y212 w%width% h%height%, Flasks


Gosub, configureFlasks
Gosub, pressFlasks
return
; End of starting runtime



pressFlasks:
    pots := [pot1, pot2, pot3, pot4, pot5]
    
	if(runscript){
        for i, p in pots
        {
            ; MsgBox, hello
            ; MsgBox, % p.active
            ; MsgBox, % p.forceUnactive
            if(p.active && !p.forceUnactive) {
                ; MsgBox, % p.nextUse " " A_TickCount
                if(p.nextUse < A_TickCount){
                    
                    myKey := p.keys[p.lastUsed]
                    ; MsgBox, % myKey
                    SendInput, %myKey%
                    Random, sleeperOffset, 0, jitterValue
                    p.nextUse := (A_TickCount + p.duration[p.lastUsed]*1000 - sleeperOffset)
                    ; MsgBox, % p.lastUsed " " p.keys.MaxIndex()
                    p.lastUsed := Mod(p.lastUsed + 1, p.keys.MaxIndex()+1)
                    ; MsgBox, % p.lastUsed
                    if (p.lastUsed == 0){
                        p.lastUsed := 1
                    }
                }
            }
        }
	}
	; Sleep, 50
	Goto, pressFlasks
	return


; ^Space::
;     Reload
; return

Reset:
    Flask1Dur := 4.00
    Flask2Dur := 4.00
    Flask3Dur := 4.00
    Flask4Dur := 4.00
    Flask5Dur := 4.00
    jitterValue := 25
    AutoSave()
    Reload
return

ChangeHotkey:
    return

ToggleButt: 
    runscript := !runscript
    ; MsgBox, %runscript%
    ; MsgBox, Toggle pressed
    ; ToggleHotkey = F2
    ; GuiControl, , ToggleHotkeyButtonText, %ToggleHotkey%
    return

SliderUpdate:
    GuiControl, , jitterDisplay, %TxtPreset%%jitterValue%%TxtMS%
    return

AutoSaveLabel:
    Gui, Submit, NoHide
    AutoSave()
    return

AutoSave(){
    ; WinGetPos, [X, Y, Width, Height, WinTitle, WinText, ExcludeTitle, ExcludeText]
    IniWrite, %jitterValue%, Flask.ini, App Settings, jitterValue
    IniWrite, %Flask1Dur%, Flask.ini, App Settings, Flask1Dur
    IniWrite, %Flask2Dur%, Flask.ini, App Settings, Flask2Dur
    IniWrite, %Flask3Dur%, Flask.ini, App Settings, Flask3Dur
    IniWrite, %Flask4Dur%, Flask.ini, App Settings, Flask4Dur
    IniWrite, %Flask5Dur%, Flask.ini, App Settings, Flask5Dur
    IniWrite, %Flask1Active%, Flask.ini, App Settings, Flask1Active
    IniWrite, %Flask2Active%, Flask.ini, App Settings, Flask2Active
    IniWrite, %Flask3Active%, Flask.ini, App Settings, Flask3Active
    IniWrite, %Flask4Active%, Flask.ini, App Settings, Flask4Active
    IniWrite, %Flask5Active%, Flask.ini, App Settings, Flask5Active
    ; IniWrite, %ToggleHotkey%, Flask.ini, App Settings, ToggleHotkey
    ; MsgBox, %Share12%
    IniWrite, %Share12%, Flask.ini, App Settings, Share12
    IniWrite, %Share13%, Flask.ini, App Settings, Share13
    IniWrite, %Share23%, Flask.ini, App Settings, Share23
    IniWrite, %Share14%, Flask.ini, App Settings, Share14
    IniWrite, %Share24%, Flask.ini, App Settings, Share24
    IniWrite, %Share34%, Flask.ini, App Settings, Share34
    IniWrite, %Share15%, Flask.ini, App Settings, Share15
    IniWrite, %Share25%, Flask.ini, App Settings, Share25
    IniWrite, %Share35%, Flask.ini, App Settings, Share35
    IniWrite, %Share45%, Flask.ini, App Settings, Share45

    return
}


GetFlaskCoordinates:
    gui, Hide
    MsgBox, Please click your first flask slot, then your last.

    KeyWait, LButton, UpDown
    KeyWait, LButton, Up
    MouseGetPos, mx1, my1

    KeyWait, LButton, UpDown
    KeyWait, LButton, Up
    MouseGetPos, mx2, my2
    
    i := 0
    xSize := (mx2 - mx1)/4
    Loop, 5 {
        ; Clipboard = ""
        BlockInput, On
        BlockInput, MouseMove
        MouseMove, mx1 + (xSize * i) , my1, 0
        Random, sleeperOffset, 0, jitterValue
        Sleep, baseSpeedMS + sleeperOffset
        Send, ^c
        Sleep, baseSpeedMS + sleeperOffset
        copiedText = %Clipboard%
        RegExMatch(copiedText, "Lasts [0-9]+\.[0-9]+", match)
        ; Send, {Click}}
        i++

        if (match){
            if (i == 1){
                Flask1Dur = % SubStr(match, 6)
            } else if (i == 2){
                Flask2Dur = % SubStr(match, 6)
            } else if (i == 3){
                Flask3Dur = % SubStr(match, 6)
            } else if (i == 4){
                Flask4Dur = % SubStr(match, 6)
            } else if (i == 5){
                Flask5Dur = % SubStr(match, 6)
            } 
        }
        BlockInput, MouseMoveOff
        BlockInput, Off
    }

    gui, Show
    AutoSave()
    Reload
return

configureFlasks:
    Gui, Submit, NoHide
    ; MsgBox, hello
    ; reset
    pot1 := {active:false, forceUnactive:false, keys:[1], duration:[Flask1Dur], nextUse: A_TickCount, lastUsed:1}
    pot2 := {active:false, forceUnactive:false, keys:[2], duration:[Flask2Dur], nextUse: A_TickCount, lastUsed:1}
    pot3 := {active:false, forceUnactive:false, keys:[3], duration:[Flask3Dur], nextUse: A_TickCount, lastUsed:1}
    pot4 := {active:false, forceUnactive:false, keys:[4], duration:[Flask4Dur], nextUse: A_TickCount, lastUsed:1}
    pot5 := {active:false, forceUnactive:false, keys:[5], duration:[Flask5Dur], nextUse: A_TickCount, lastUsed:1}

    if(Flask1Active){
        pot1.active := true
    }
    if(Flask2Active){
        pot2.active := true
    }
    if(Flask3Active){
        pot3.active := true
    }
    if(Flask4Active){
        pot4.active := true
    }
    if(Flask5Active){
        pot5.active := true
    }

    ; read some vars
    if (Share12){
        pot1.keys.push(2)
        pot1.duration.push(Flask2Dur) 
        pot2.forceUnactive := true
    }
    if (Share13){
        pot1.keys.push(3)
        pot1.duration.push(Flask3Dur) 
        pot3.forceUnactive := true
    }
    if (Share14){
        pot1.keys.push(4)
        pot1.duration.push(Flask4Dur) 
        pot4.forceUnactive := true
    }
    if (Share15){
        pot1.keys.push(5)
        pot1.duration.push(Flask5Dur) 
        pot5.forceUnactive := true
    }

    if (Share23){
        pot2.keys.push(3)
        pot2.duration.push(Flask3Dur) 
        pot3.forceUnactive := true
    }
    if (Share24){
        pot2.keys.push(4)
        pot2.duration.push(Flask4Dur) 
        pot4.forceUnactive := true
    }
    if (Share25){
        pot2.keys.push(5)
        pot2.duration.push(Flask5Dur) 
        pot5.forceUnactive := true
    }
    
    if (Share34){
        pot3.keys.push(4)
        pot3.duration.push(Flask4Dur) 
        pot4.forceUnactive := true
    }
    if (Share35){
        pot3.keys.push(5)
        pot3.duration.push(Flask5Dur) 
        pot5.forceUnactive := true
    }

    if (Share45){
        pot4.keys.push(5)
        pot4.duration.push(Flask5Dur) 
        pot5.forceUnactive := true
    }
    AutoSave()
return


; ========
; Extra Exit
; ========
~Enter::
~Space::
~Alt::
    runscript=0
return



GuiEscape:
    ExitApp
return


