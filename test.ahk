#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Recommended for catching common errors.
#SingleInstance, force

; https://www.autohotkey.com/docs/Objects.htm#Custom_Objects

class flaskObject {
    duration := 4.0
    usableAt := A_TickCount
    hotkey := "a"
    enabled := true
    group := ""
    inGroup := false
    isUsable() {
        if (this.enabled && (this.usableAt < A_TickCount) && !this.inGroup) {
            return true
        }
        return false
    }
    use(){
        Send, % this.hotkey
        this.usableAt := A_TickCount + (this.duration*1000)
        ; MsgBox, % A_TickCount "," this.usableAt
    }
    ; create a group when a shared box is clicked
    ; grey out all other shared boxes when this happens
}

; ### globals ###
global settingsFile := "testsettings.ini"
global flasks := []
global JITTER := 0
global POLLING_RATE := 1000/60 ; sleep this amount between cycles. Determines how often we check that a flask is ready to be pressed. Higher number should improve performance.
global NUM_FLASKS := 0
global runscript := 0

if (FileExist(settingsFile)) {
    loadAll()
} else {
    resetSettings()
}
Gosub, pressFlasks

pressFlasks:
    for i, flask in flasks {
        if (flask.isUsable() && runscript) {
            flask.use()
        }
	}
    Sleep, POLLING_RATE
	Goto, pressFlasks
Return


; ### FUNCTIONS ###

resetSettings(){
    flasks := []
    flasks[1] := new flaskObject
    flasks[1].hotkey := "1"
    flasks[2] := new flaskObject
    flasks[2].hotkey := "2"
    flasks[3] := new flaskObject
    flasks[3].hotkey := "3"
    flasks[4] := new flaskObject
    flasks[4].hotkey := "4"
    flasks[5] := new flaskObject
    flasks[5].hotkey := "5"
    NUM_FLASKS := 5
    saveAll()
    Return
}

saveAll(){
    saveGlobals()
    For i, flask in flasks {
        saveFlask(i)
    }
    Return
}

loadAll(){
    loadGlobals()
    Loop, %NUM_FLASKS% {
        loadFlask(A_Index)
    }
}

saveGlobals(){
    IniWrite, %JITTER%, %settingsFile%, GLOBALS, JITTER
    IniWrite, %POLLING_RATE%, %settingsFile%, GLOBALS, POLLING_RATE
    IniWrite, %NUM_FLASKS%, %settingsFile%, GLOBALS, NUM_FLASKS
}

loadGlobals(){
    IniRead, JITTER, %settingsFile%, GLOBALS, JITTER
    IniRead, POLLING_RATE, %settingsFile%, GLOBALS, POLLING_RATE
    IniRead, NUM_FLASKS, %settingsFile%, GLOBALS, NUM_FLASKS
}

saveFlask(i){
    IniWrite, % flasks[i].duration, %settingsFile%, % "FLASK" i, % "FLASK_" i "_DURATION"
    IniWrite, % flasks[i].hotkey, %settingsFile%, % "FLASK" i, % "FLASK_" i "_HOTKEY"
    IniWrite, % flasks[i].enabled, %settingsFile%, % "FLASK" i, % "FLASK_" i "_ENABLED"
    IniWrite, % flasks[i].group, %settingsFile%, % "FLASK" i, % "FLASK_" i "_GROUP"
    IniWrite, % flasks[i].inGroup, %settingsFile%, % "FLASK" i, % "FLASK_" i "_IN_GROUP"
    Return
}

loadFlask(i){
    IniRead, temp_duration, %settingsFile%, % "FLASK" i, % "FLASK_" i "_DURATION"
    IniRead, temp_hotkey, %settingsFile%, % "FLASK" i, % "FLASK_" i "_HOTKEY"
    IniRead, temp_enabled, %settingsFile%, % "FLASK" i, % "FLASK_" i "_ENABLED"
    IniRead, temp_group, %settingsFile%, % "FLASK" i, % "FLASK_" i "_GROUP"
    IniRead, temp_inGroup, %settingsFile%, % "FLASK" i, % "FLASK_" i "_IN_GROUP"
    flasks[i] := new flaskObject
    flasks[i].duration := temp_duration
    flasks[i].hotkey := temp_hotkey
    flasks[i].enabled := temp_enabled
    flasks[i].group := temp_group
    flasks[i].inGroup := temp_inGroup
    Return
}


; test:
;     MsgBox % flasks.Length()
    

;     Loop flasks.Length() {
;         MsgBox % flasks[A_Index].duration
;     }
;     MsgBox % flask1.duration " " flask1.key " " flask1.usableAt " " flask1.enabled
;     MsgBox % flask2.duration " " flask2.key " " flask2.usableAt " " flask2.enabled
; Return



; ### HOTKEYS ###
~^s::
    Reload
Return

+Space::
    ; MsgBox, %runscript%
    runscript := !runscript
    ; MsgBox, %runscript%
Return

^Space::
    saveAll()
Return

^+Space::
    For i, flask in flasks {
        if (flask.isUsable()){
            flask.use()
        }
    }
Return
