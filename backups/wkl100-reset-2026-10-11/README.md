# Keyboard investigation backup — 11 October 2026

This backup preserves the keyboard investigation before the owner's Windows reset.

- `investigation/`: all 215 files from `Documents/K81-USB-Debug`, including USB logs, scripts, firmware dumps, extracted maps, settings/RGB backups, disassembly, findings, references and screenshots. Generated Python caches are excluded.
- `leobog-installed.zip`: every file from the installed LEOBOG K81 application (146 files).
- `jedel-installed.zip.partNNN`: every file from the installed JEDEL Driver application (178 files), compressed and split to fit GitHub's file limit.
- `MANIFEST.json`: exact original source-file hashes, archive hashes and backup-file hashes.
- The RGB web app is at the repository's `rgb-editor/`; its launcher is `Start-RGB-Editor.cmd`.
- Complete 65536-byte main-controller firmware dumps are also directly available at `../../findings/wkl100-258a-019d/firmware/`.

## Restore after Windows reset

Download or clone the entire repository, rather than just this document:

```powershell
git clone https://github.com/MrTimonM/-key-blocker.git
cd ./-key-blocker
powershell -NoProfile -ExecutionPolicy Bypass -File ./backups/wkl100-reset-2026-10-11/Restore-Vendor-Archives.ps1
```

Alternatively, use GitHub's **Code → Download ZIP**, extract it, and run the restore script from that extracted repository.

The script verifies every backup file, rejoins archive parts, verifies complete archive hashes, and extracts the two vendor application folders under `restored-vendor-apps/` beside this backup. It does not install or run vendor software, touch USB, or change the keyboard.

Copy `investigation/` to `Documents/K81-USB-Debug` if you want the former workspace path. For Python analysis tools, install Python and the packages `hidapi`, `pefile`, `capstone`, and `frida`. For the RGB editor, install Node.js, run `Start-RGB-Editor.cmd`, and open http://127.0.0.1:8766 in Chrome or Edge. See the individual tool documentation before running a device test.

These are installed application files, not original installers or a Windows system backup. Application dependencies, Windows startup configuration and Interception drivers must be restored using the repository's setup instructions where applicable.

## Investigation state

Device: JEDEL WKL-100, USB 258A:019D, vendor collection FF02:02, feature report 9 (519 data bytes / 520 including ID). PCB marking supplied by owner: K81 BYK916+8805 V1 20240514.

Physically verified: own-device base remap 8→9; Fn+8→9; Custom RGB Y/U/I/O red and G/F/V/B green; brightness changes; preset colors; apparent animation speed changes; LCD clock setting; two-character macro playback. Temporary mapping/macro/Fn experiments were restored. Exact single-press macro repeat behavior remains unconfirmed.

Custom LCD images remain unresolved: command 0C's tested candidate RGB565 transfer was acknowledged, but the default GIF did not change. Fresh readbacks confirmed settings, base map and Custom RGB unchanged. A live-time getter is not established. See `LCD-IMAGE-FINDINGS.md` in the investigation and published findings.

The firmware files are logical ISP-view dumps of the main controller, not a dump of the LCD companion or a verified flash-ready recovery image. Preserve the original `20261007-202027` pair; later dumps represent a different state. Do not treat an archive's existence as validation of firmware flashing.

A prior USB reconnect left typing unavailable until a Windows restart; investigation attributes this to the installed Interception input-filter setup, with incomplete causal proof. Runtime operations and later readbacks worked. Experimental scripts are preserved as evidence, not automatically run by restoration.

## Final owner-requested change

After the complete backup was uploaded, the physical left bracket `[` was changed to the unbound action in base slot 68. Two full readbacks confirm only byte 275 changed; Fn, settings and Custom RGB match their backups. The owner reported apparent success (�i guess now ok�). [Details and undo instructions](investigation/LEFT-BRACKET-DISABLE.md). The original base map and both apply/restore scripts are included in this updated backup.
