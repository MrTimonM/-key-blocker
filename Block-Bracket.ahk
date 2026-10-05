#Requires AutoHotkey v2.0
#SingleInstance Force
#Include Lib\AutoHotInterception.ahk
ListLines(false)

; Only the exact keyboard interfaces verified in Monitor are eligible.
Targets := Map(
    "hid\{00001812-0000-1000-8000-00805f9b34fb}_dev_vid&02046d_pid&b35a_rev&0011&col02", "Bluetooth",
    "hid\vid_258a&pid_019d&rev_1008&mi_00", "USB"
)
AHI := AutoHotInterception()
Active := Map()

if A_Args.Length && A_Args[1] = "--check" {
    found := FindTargets()
    for id, target in found
        FileAppend("Matched " target.Mode " keyboard ID " id "; scan code 26.`n", "*")
    if !found.Count
        FileAppend("No matching external keyboard currently visible; normal mode will wait for it.`n", "*")
    FileAppend("Configuration loaded successfully. Check mode did not block any keys.`n", "*")
    ExitApp()
}

Persistent
OnExit(Cleanup)
RefreshTargets()
SetTimer(RefreshTargets, 1000)

FindTargets() {
    global AHI, Targets
    found := Map()
    counts := Map()
    for id, device in AHI.GetDeviceList() {
        handle := StrLower(device.Handle)
        if !device.IsMouse && Targets.Has(handle) {
            found[id] := {Handle: handle, Mode: Targets[handle]}
            counts[handle] := counts.Has(handle) ? counts[handle] + 1 : 1
        }
    }
    ; Do not guess if multiple devices report the same handle.
    ambiguous := []
    for id, target in found
        if counts[target.Handle] != 1
            ambiguous.Push(id)
    for id in ambiguous
        found.Delete(id)
    return found
}

RefreshTargets() {
    global AHI, Active
    Critical
    try {
        found := FindTargets()
        stale := []
        for id, target in Active
            if !found.Has(id) || found[id].Handle != target.Handle
                stale.Push(id)
        for id in stale {
            AHI.UnsubscribeKey(id, 26)
            Active.Delete(id)
        }
        for id, target in found {
            if !Active.Has(id) {
                AHI.SubscribeKey(id, 26, true, IgnoreBracket)
                Active[id] := target
            }
        }
        modes := ""
        for id, target in Active
            modes .= (modes = "" ? "" : " + ") target.Mode
        A_IconTip := Active.Count ? "Mechanical keyboard: [ blocked (" modes ")" : "Bracket blocker: waiting for Bluetooth / USB keyboard"
    } catch {
        A_IconTip := "Bracket blocker: device check failed; retrying"
    }
}

IgnoreBracket(state) {
    ; Discard both press and release, including Shift+[ on this physical key.
}

Cleanup(*) {
    global AHI, Active
    SetTimer(RefreshTargets, 0)
    for id, target in Active {
        try AHI.UnsubscribeKey(id, 26)
    }
}
