# JEDEL WKL-100 USB and keymap findings

Research date: **2026-10-07**, Asia/Dhaka. These results come from the owner's
connected keyboard, not another model's factory map.

**Result:** the keyboard's base and Fn maps were recovered from two identical
64 KB ISP-view dumps. An isolated **8 → 9** remap was physically confirmed,
with **X and C unchanged**. The original base map was restored after the test.
RGB effect control was also confirmed by readback and visible lighting changes.

The [older inspector research](../../inspector/PROTOCOL-FINDINGS.md) remains a
historical record. Its missing-backup conclusion is superseded by this recovery.
Disabling a bracket key has **not** been tested. Stored output actions alone
do not verify every physical switch's firmware slot.

## Device identity

| Field | Observed value |
| --- | --- |
| Consumer model | JEDEL WKL-100, 81-key compact keyboard with LCD and knob |
| USB product/manufacturer | WKL-100 / SINO WEALTH |
| VID:PID | `258A:019D` |
| Device release | `1008` |
| Control collection | Interface 1, usage page `FF02`, usage `02` |
| Control feature report | ID 9; 520 bytes including ID, 519 excluding ID |
| PCB marking supplied by owner | `K81 BYK916+8805 V1 20240514` |

The installed JEDEL 3.0.2 app instead registers JEDELWKL100 as `3151:5002` and
uses a different 64-byte protocol. That app's commands were not sent to this
keyboard. The LEOBOG K81 app normally selects `258A:010C` / `3554:FA09`;
its matching report-9 backend was useful for static protocol analysis.

## Recovered maps

| Region | Address | Size |
| --- | --- | --- |
| Base | `BC00` | 512 bytes |
| Alternate base bank | `BE00` | 512 bytes |
| Factory base templates | `C000`, `C200` | 512 bytes each |
| Fn | `C400` | 512 bytes |
| Alternate Fn bank | `C600` | 512 bytes |
| Factory Fn templates | `C800`, `CA00` | 512 bytes each |
| Additional layers/banks | `CC00`, `CE00`, `D400`, `D600` | 512 bytes each |

All four current base/Fn banks matched their factory templates in the original
dump. The complete regions are preserved, including zero bytes and internal
actions. The CSV files decode the regions into 128 four-byte entries; this is
not a claim that the board has 128 physical switches.

- [All banks and decoded actions](keymaps/wkl100-keymap.json)
- [Base slot table](keymaps/wkl100-base-slots.csv)
- [Fn slot table](keymaps/wkl100-fn-slots.csv)
- [Original base region](keymaps/wkl100-base-512.bin)
- [Original Fn region](keymaps/wkl100-fn-512.bin)
- [Own-firmware evidence](evidence/wkl100-keymap-firmware-evidence.asm)

| Base slot | Stored action | Four bytes |
| --- | --- | --- |
| 16 | X | `00 00 00 1B` |
| 22 | C | `00 00 00 06` |
| 49 | 8 | `00 00 00 25` |
| 55 | 9 | `00 00 00 26` |
| 59 | Fn internal action | `0D 00 00 00` |
| 74 | Right-bracket output | `00 00 00 30` |

The top-row 8 slot was physically validated by the remap test. A decoded
right-bracket action does not, by itself, prove the faulty physical key's slot.
The old K81 application's listed indexes disagree for some function/navigation
keys and must not be treated as this keyboard's full physical map.

The borrowed SuperFrame Phantom base map differed at **32 slots** and had
previously changed other keys. [The comparison](evidence/wkl100-vs-phantom-map-diff.json)
shows why matching VID/PID and report sizes were insufficient.

## USB commands and verification

See [PROTOCOL.md](PROTOCOL.md) for exact framing, readback limits, and the ISP
sequence. These are HID feature-report captures and firmware analysis, not a
USBPcap/Wireshark bus capture.

**Keymap read:** application-mode opcode `83` returns a verified **255-byte
prefix** from the selected region. It needs no bootloader transition or unlock.
Both base and Fn prefixes matched the complete ISP backup. Full 512-byte runtime
readback has not been verified.

**Keymap write:** report 9, opcode `03`, layer 0, followed by the keyboard's own
complete 512-byte base region. The 8 → 9 test changed only region offset 199,
report offset 207, from `25` to `26`. Two post-write full dumps matched and
differed from the original image at **only `BCC7`**. A later test without USB
reconnects was physically confirmed: 8 typed 9 while X and C stayed normal.
The original map was then restored and its base/Fn prefixes verified.

**RGB:** settings opcode `84` reads 128 bytes. Settings offset 10 is the effect
selector; effect 3 → 11 was verified by exact readback and visible lighting.
The other 127 bytes were preserved, then the original effect was restored.

**LCD:** no validated clock getter or framebuffer reader was found. Clock-setting
code in the vendor applications is not evidence that the displayed time can be
read. No clock-setting command was tested on this keyboard.

Evidence:

- [Dump hashes and provenance](evidence/firmware-dump-manifest.json)
- [Full-image one-byte remap comparison](evidence/own-map-remap-flash-verification.json)
- [Application-mode and physical remap verification](evidence/runtime-remap-readback.json)
- [Original-map restoration](evidence/own-map-remap-restore.json)
- [Runtime read validation](evidence/runtime-read-validation.json)
- [RGB effect comparison](evidence/rgb-effect3-diff.json)
- [Typing recovery](evidence/typing-recovery.json)

Full firmware dumps and the vendor executables remain in the owner's local
archive. This folder publishes their hashes, extracted keymap regions, and
analysis evidence, rather than distributing a firmware image for flashing.

## Interception reconnect failure

During repeated ISP/USB transitions, Windows stopped receiving keyboard input,
although the knob and Fn reset still worked. Both Windows keyboard nodes were
present and OK, but the WKL-100 was absent from Interception's available device
table. A **Windows restart restored typing**; power-cycling or factory-resetting
the keyboard alone did not.

This is consistent with [AutoHotInterception's documented reconnect-ID bug](https://github.com/evilC/AutoHotInterception#known-issues):
keyboard IDs can exceed its limit of 10 after reconnects, stopping input until
Windows restarts. The internal counter was not directly measured. The successful
second remap used runtime readback and no reconnects.

The local ISP scripts now refuse bootloader transitions when that filter is
installed. Further ISP work should use a host without the filter. The runtime
prefix reader included here does not enter ISP or write configuration.

## Reproduce the read-only prefix query

With this investigated keyboard connected in wired mode, install Python's
`hidapi` package and run:

```powershell
python tools/read_runtime_keymap.py
python tools/read_runtime_keymap.py --layer 1
```

The tool selects only `258A:019D`, `FF02:02`, closes its handle in `finally`,
and checks the expected header and response length. It writes its query evidence
beside the script. It does not provide full-layer backup or a write button.

## Primary references

- [sinowisp ISP entry and device selection](https://github.com/carlossless/sinowisp/blob/master/src/device_selector.rs)
- [sinowisp ISP commands and unlock side effect](https://github.com/carlossless/sinowisp/blob/master/src/isp_device.rs)
- [sinowisp hardware/bootloader table](https://github.com/carlossless/sinowisp)
- [Phantom editor protocol](https://github.com/NotJustAnna/sfphantom/blob/main/protocol.js)
- [Phantom editor's readback limitation](https://github.com/NotJustAnna/sfphantom/blob/main/device-io.js)
- [Jeff Tranter's 8051 instruction table used for offline listings](https://github.com/jefftranter/udis/blob/master/8051.py)

Related keyboards and published tools are references, not proof of identical
firmware or permission to flash their images onto this board.
