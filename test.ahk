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


flasks[1] := new flaskObject
flasks[2] := new flaskObject
flasks[3] := new flaskObject

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

saveAll(){
    saveGlobals()

    For i, flask in flasks {
        saveFlask(i)
    }
    
    Return
}

saveGlobals(){
    IniWrite, % JITTER, %settingsFile%, GLOBALS, JITTER
    IniWrite, %POLLING_RATE%, %settingsFile%, GLOBALS, POLLING_RATE
    IniWrite, %NUM_FLASKS%, %settingsFile%, GLOBALS, NUM_FLASKS
    ; IniWrite, %JITTER%, %settingsFile%, GLOBALS, JITTER


}

saveFlask(i){
    IniWrite, % flasks[i].duration, %settingsFile%, % "FLASK" i, % "FLASK_" i "_DURATION"
    IniWrite, % flasks[i].hotkey, %settingsFile%, % "FLASK" i, % "FLASK_" i "_HOTKEY"
    IniWrite, % flasks[i].duration, %settingsFile%, % "FLASK" i, % "FLASK_" i "_DURATION"
    IniWrite, % flasks[i].duration, %settingsFile%, % "FLASK" i, % "FLASK_" i "_DURATION"
    Return
}


test:
    MsgBox % flasks.Length()
    

    Loop flasks.Length() {
        MsgBox % flasks[A_Index].duration
    }
    MsgBox % flask1.duration " " flask1.key " " flask1.usableAt " " flask1.enabled
    MsgBox % flask2.duration " " flask2.key " " flask2.usableAt " " flask2.enabled
Return




~^s::
    Reload
Return


pressFlasks:
    for i, flask in flasks {
        ; MsgBox, hello
        ; MsgBox, % p.active
        ; MsgBox, % p.forceUnactive
        if (flask.isUsable && runscript) {

        }
        if (flask.active && !flask.forceUnactive && runscript) {
            ; MsgBox, % flask.nextUse " " A_TickCount
            if (flask.usableAt < A_TickCount){
                
                myKey := flask.keys[flask.lastUsed]
                ; MsgBox, % myKey
                SendInput, %myKey%
                Random, sleeperOffset, 0, JITTERValue
                flask.usableAt := (A_TickCount + flask.duration[flask.lastUsed]*1000 - sleeperOffset)
                ; MsgBox, % flask.lastUsed " " flask.keys.MaxIndex()
                flask.lastUsed := Mod(flask.lastUsed + 1, flask.keys.MaxIndex()+1)
                ; MsgBox, % flask.lastUsed
                if (flask.lastUsed == 0){
                    flask.lastUsed := 1
                }
            }
        }
	}
    Sleep, %POLLING_RATE%
	Goto, pressFlasks
return