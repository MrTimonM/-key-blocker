# WKL-100: recovered device keymap

**Completed:** 8 -> 9 works on the real keyboard, with X and C unchanged.
The original map was restored after the temporary test. The successful test
used runtime readback and did not enter the bootloader or reconnect USB.

The factory map is recovered from your own JEDEL WKL-100, USB 258A:019D.
Two full 64 KB dumps matched. No firmware image was flashed or erased.
The ISP unlock was separately approved because it can program the enable flag.

The original dumps are:

- `wkl100-isp-view-20261007-202027-pass1.bin`
- `wkl100-isp-view-20261007-202027-pass2.bin`

Both SHA-256:
`f9a7e1b1abf47c1a9b8b545eae1a0467c5f8086f05d28fb6bf1ee096eac37a64`

These are ISP-view images. Their reset-vector representation differs from raw
physical flash; do not feed them to an unrelated flash programmer.

## Readable maps

- `wkl100-keymap.json`: all recovered regions, raw bytes, and decoded actions.
- `wkl100-base-slots.csv`: base slots and stored output actions.
- `wkl100-fn-slots.csv`: Fn slots, including raw internal actions.
- `wkl100-base-512.bin` and `wkl100-fn-512.bin`: complete original regions.
- `wkl100-keymap-firmware-evidence.asm`: own-firmware writer and factory-copy evidence.

The base region is BC00–BDFF; the Fn region is C400–C5FF. Alternate banks and
factory templates are retained separately. A slot's output action is decoded;
that does not by itself prove which physical switch invokes it. The K81 vendor
app's indexes are unsuitable as a complete physical map.

| Base slot | Stored action | Four bytes |
| --- | --- | --- |
| 16 | X | 00 00 00 1B |
| 22 | C | 00 00 00 06 |
| 49 | 8 | 00 00 00 25 |
| 55 | 9 | 00 00 00 26 |
| 59 | Fn | 0D 00 00 00 |
| 74 | Right bracket | 00 00 00 30 |

The borrowed Phantom map differs at 32 slots. Use the recovered device bytes.

## Controlled 8 → 9 test

The report uses `09 03 00 00 00 00 00 00` followed by your entire 512-byte base
region. Only region offset 199 changes, from 25 to 26. This is a whole-region
write with a one-byte edit; the other 511 region bytes are preserved.

Two post-write dumps match and differ from the original at only BCC7. See
`own-map-remap-flash-verification.json`. The first typing test encountered a
Windows input failure after repeated USB reconnects. The installed Interception
driver has a documented reconnect-ID limit; this keyboard disappeared from
its device table while remaining present in Windows. A Windows restart restored
typing. The original region was restored before that restart.

The second 8 -> 9 test used application-mode readback, without USB reconnects.
The owner confirmed 8 types 9 and X/C are normal. The original base region was
then restored and its prefix verified, with the Fn prefix unchanged. See
`runtime-remap-readback.json`, `own-map-remap-restore.json`, and
`typing-recovery.json`.

The exact captured original region is saved in `own-map-remap-before.bin`.
`own-map-restore-report.bin` contains its restore packet. The restore command is:

```powershell
& 'C:\Users\Mahedi\AppData\Local\Programs\Python\Python312\python.exe' 'C:\Users\Mahedi\Documents\K81-USB-Debug\test_own_map_8_to_9.py' restore
```

This is a controlled snapshot-based test. If the keyboard is reset or configured
again, take a fresh dump before preparing another edit; do not treat a saved
snapshot as live readback. All zero entries and unknown actions remain intact.

## Capture procedure

**Do not repeat ISP transitions on this host while its Interception filter is
installed.** Both ISP scripts now refuse that condition. The recorded dumps
are already sufficient for this experiment. Any additional ISP work should
use a host without that filter. Its known issue is documented at:
https://github.com/evilC/AutoHotInterception#known-issues

For a read-only application-mode check, run:

```powershell
& 'C:\Users\Mahedi\AppData\Local\Programs\Python\Python312\python.exe' 'C:\Users\Mahedi\Documents\K81-USB-Debug\read_runtime_keymap.py'
```

It sends query `09 83 00 00 01 00 FF 00` and returns the first 255 base bytes.
`--layer 1` reads the Fn prefix. These are real device reads, but only prefixes;
they are not a substitute for a full backup. No ISP entry/unlock is involved.

`wkl_flash_read.py` selects this keyboard, enters its bootloader, uses the
approved standard enable/unlock, reads all pages twice, compares the copies,
and reboots in a finally block. It has no erase or firmware-write commands.
`--offline-check` opens no USB device and prints the command allowlist.

Upstream protocol source:
https://github.com/carlossless/sinowisp/blob/master/src/device_selector.rs
https://github.com/carlossless/sinowisp/blob/master/src/isp_device.rs

Captured sources, full transfer logs, and all backups are retained in this folder.
