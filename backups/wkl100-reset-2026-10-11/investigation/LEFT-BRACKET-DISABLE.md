# Left bracket disabled â€” 11 October 2026

Owner request: set the mechanical keyboard's `[` key to do nothing, after the full GitHub backup.

Applied to the connected WKL-100, 258A:019D, FF02:02, using its own current runtime map.
Own factory slot 68 contains HID action `00 00 00 2F` (left bracket). The controlled
edit changes that action to `00 00 00 00`, the candidate unbound action.
Only payload byte 275 changes, from 2F to 00; every other byte in the 512-byte base
region is preserved. Two complete base readbacks match. Full Fn, settings and
Custom RGB readbacks match their pre-write values. No ISP, reboot, reconnect,
Fn-layer write, settings write or RGB write was performed.

The first two attempts failed during prerequisite queries, before any map write.
After the owner closed the editor and woke the keyboard, the controlled operation
completed successfully. This does not establish the cause of those read failures.

Successful evidence: `disable-left-bracket-20261011-165131.json` and its six binary
snapshots. The before-map SHA-256 is
`d483f0f3df8c978c12e84009c5b8d51522c134661a12e4b29a82d03ec94a24ff`.

The owner replied “i guess now ok”, a qualitative success observation. The owner was asked to test `[` and
Shift+`[` (normally `{`), plus P and `]` as unaffected neighboring controls.
Fn-layer behavior and power-cycle persistence have not been tested for this edit.

To undo this exact operation after restoring the investigation folder:

```powershell
python restore_left_bracket.py
```

The restore tool selects the latest successful disable record and restores its
exact original map only if the current map still equals the recorded disabled
map. It refuses to overwrite later edits. The original backup is never replaced
with Phantom or another keyboard's defaults.
