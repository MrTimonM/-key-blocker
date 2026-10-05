# External keyboard bracket blocker

Blocks a faulty physical `[` key on the configured external keyboard over **Bluetooth or USB**, while leaving the laptop keyboard and devices with different hardware identifiers alone.

This repository preserves the working setup for a keyboard identified by its owner as **Jedel WKL 100**. It is a Windows workaround, not a hardware repair or firmware update. The identifiers below were captured from this particular setup; they are not a claim that every WKL 100 uses these identifiers.

## What it does

- Blocks scan code **26** (decimal), including press and release. On the tested layout this also blocks `{`, because Shift uses the same physical key.
- Runs in the background, even when the external keyboard is disconnected.
- Checks once per second for the configured Bluetooth and USB interfaces and updates subscriptions when the driver reports a changed connection.
- Can launch automatically **after you sign in** to your Windows account. It does not protect the pre-login password screen.
- Matches hardware handles instead of temporary device numbers. The observed IDs 3, 8, and 10 are deliberately not hard-coded.
- Makes no system-wide key remap and writes no keystroke log. Normal AutoHotkey line tracing is disabled.

Connection detection can take about one second; unwanted input can get through before the subscription is established. The script cannot fix limitations of the Interception driver.

## Restore after reinstalling Windows

These instructions target **64-bit Windows 10**, the system used for this setup. Compatibility with other Windows versions has not been verified here. Internet access and administrator access for the driver installation are required.

### 1. Download this repository and AutoHotkey

1. On [this repository](https://github.com/MrTimonM/-key-blocker), choose **Code → Download ZIP** and extract it.
2. Install **AutoHotkey v2**, using the official [AutoHotkey download page](https://www.autohotkey.com/). Use the default installation path. The original setup used v2.0.29, 64-bit. AutoHotkey v1 will not run this script.
3. Open the extracted repository folder in Explorer, type `powershell` in the address bar, and press Enter. This opens PowerShell in that folder.

### 2. Prepare the blocker and dependencies

Run in that PowerShell window:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Setup.ps1
```

The policy override applies to this command only. Setup downloads two pinned official release archives, checks their SHA-256 hashes, and assembles the runtime here:

```text
%LOCALAPPDATA%\KeyboardBracketBlocker\
  Block-Bracket.ahk
  Monitor.ahk
  AutoHotInterception-LICENSE.txt
  Lib\
    AutoHotInterception.ahk
    AutoHotInterception.dll
    CLR.ahk
    x64\interception.dll
    x86\interception.dll
  Driver\
    install-interception.exe
    licenses\...
```

Setup does **not** install the driver, restart Windows, start blocking keys, or enable startup. It leaves the downloaded ZIPs in a temporary folder whose location it prints. Keep copies if you want an offline backup.

### 3. Install the Interception driver and restart

Open **Windows PowerShell as administrator** using your normal Windows account, then run:

```powershell
& "$env:LOCALAPPDATA\KeyboardBracketBlocker\Driver\install-interception.exe" /install
```

Read the installer's result and **restart Windows after a successful installation**. If you elevated using a different administrator account, use the full path to the original user's runtime folder instead of that account's `$env:LOCALAPPDATA`.

### 4. Connect the keyboard and verify detection

Reconnect/pair Bluetooth or select wired mode and connect a USB **data** cable. In a normal PowerShell window run:

```powershell
& "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe" /ErrorStdOut "$env:LOCALAPPDATA\KeyboardBracketBlocker\Block-Bracket.ahk" --check
```

`--check` prints matching interfaces without blocking any keys. If it prints no match while the keyboard is connected, follow **Identify the keyboard again** below. Exit any already-running copy before checking: the script uses `#SingleInstance Force`, so checking the same installed file replaces that running copy. Start it again after the check.

### 5. Start and test the blocker

Double-click **Start-Blocker.cmd** from the downloaded repository. Alternatively, run:

```powershell
& "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe" "$env:LOCALAPPDATA\KeyboardBracketBlocker\Block-Bracket.ahk"
```

In Notepad, verify:

1. The external keyboard's unwanted `[` stops; its other keys still work.
2. `[` still works on the laptop keyboard.
3. Switching between Bluetooth and USB still blocks the faulty key after detection. Allow about a second.
4. Hover over the green **H** tray icon: it shows the active connection(s), waiting, or a device-check error. Windows may hide it under the tray's up arrow.

Close Monitor and any old Bluetooth-only or USB-only blocker before running the combined script. Avoid running multiple copies from different folders.

### 6. Enable automatic startup

After the test succeeds, run from the repository's PowerShell window:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Enable-Startup.ps1
```

This creates **Keyboard Bracket Blocker.lnk** in the current user's Startup folder, pointing to the stable runtime folder in Local AppData. You can remove the downloaded repository folder afterward; keep the runtime folder and AutoHotkey installed.

On subsequent restarts, sign in normally. The script starts, waits if the keyboard is absent, and blocks its faulty key when a matching interface appears. Test once after signing out and back in. Re-running the helper updates the same shortcut instead of creating duplicates.

If AutoHotkey is installed somewhere else, supply its full 64-bit executable path:

```powershell
.\Enable-Startup.ps1 -AutoHotkeyPath 'D:\Tools\AutoHotkey\v2\AutoHotkey64.exe'
```

The `.cmd` launchers assume the default AutoHotkey and runtime installation locations.

## Saved device configuration

The `Targets` map near the top of `Block-Bracket.ahk` contains:

| Connection | Exact matching handle, compared without case |
| --- | --- |
| Bluetooth | `HID\{00001812-0000-1000-8000-00805f9b34fb}_Dev_VID&02046d_PID&b35a_REV&0011&Col02` |
| USB | `HID\VID_258A&PID_019D&REV_1008&MI_00` |

Bluetooth reported VID/PID `0x0000, 0x0000`; the USB interface reported `0x258A, 0x019D`. **Do not match Bluetooth by VID/PID 0/0**: the laptop also reported 0/0. USB exposed more than one keyboard interface with the same VID/PID, so its exact interface handle is used too.

Handles here identify hardware/interface types, not necessarily a unique physical unit. Another keyboard exposing an identical handle can also match. If multiple keyboard interfaces have the same target handle simultaneously, this script skips that ambiguous handle rather than choosing one. Unrelated keyboards with different handles are not selected.

### Identify the keyboard again

Do this if the saved handles no longer match after reinstallation, pairing, firmware changes, or replacing the keyboard:

1. Exit the blocker using its tray icon → **Exit**.
2. Run **Open-Monitor.cmd**. This opens the upstream AutoHotInterception Monitor.
3. Select **one keyboard checkbox at a time**, then press a working key on the external keyboard. Find the entry showing its events.
4. Press the faulty key and verify its **Code**. This setup uses **26 decimal**, equivalent to hexadecimal `0x1A`.
5. Copy the entry's **Handle** using the associated Copy button. Do not substitute the temporary numeric ID.
6. Repeat with the other connection mode. For USB testing, disable the keyboard's Bluetooth connection and use wired mode.
7. Edit the matching string(s) in the installed `%LOCALAPPDATA%\KeyboardBracketBlocker\Block-Bracket.ahk`. Keep the existing quotes and map structure. Use lowercase for strings in `Targets`, since the script lowercases detected handles before looking them up.
8. Update the repository copy as well if you want those changes preserved for the next reinstall. Running Setup again overwrites the installed script with the repository copy.
9. Close Monitor, restart the blocker, and repeat the laptop/external keyboard tests.

Do not add the built-in keyboard's handle. In the original setup that was `ACPI\VEN_MSI&DEV_0007`.

## Troubleshooting and limitations

- **Keyboard stops working after repeated reconnects or hibernation:** Interception has a documented device-ID exhaustion issue. Keyboard IDs above 10 can stop working until reboot. Restart Windows. The script cannot repair this driver limitation. See the [upstream known issues](https://github.com/evilC/AutoHotInterception#known-issues).
- **No blocking after changing connections:** Allow a second, check the tray tooltip, then exit and restart the blocker. If still unresolved, reboot and check Monitor. Recovery depends on what the driver exposes; reconnect and resume behavior is not guaranteed.
- **No green H icon:** Check hidden tray icons, then run Start-Blocker.cmd. If startup was disabled in Task Manager, re-enable it there. Check missing dependencies or errors shown by AutoHotkey.
- **Missing DLL:** Re-run Setup and check that DLLs are inside `Lib`, not beside `Block-Bracket.ahk`. Use AutoHotkey v2 64-bit.
- **Driver errors:** Check the administrator install result and reboot. Merely copying the driver installer is not installation. If Windows refuses to load the driver, this setup will not work until that compatibility issue is resolved; do not assume the key is blocked.
- **`--check` says no match:** Check the connection mode and use Monitor to compare the full handle. Pairing alone does not mean the keyboard is currently connected.
- **Unexpected repeated lines in an AutoHotkey window:** Old scripts displayed executed lines for each discarded event. This combined script disables that trace with `ListLines(false)`. The hardware can continue generating input even while Windows applications no longer receive it.
- **It still types before sign-in or briefly during connection:** Startup runs after sign-in and polling is once per second. This is not a boot-time or firmware block.
- **It blocks `{` too:** Expected; this blocks the physical key, including shifted and modified combinations.
- **It does not fix hardware:** Switch, socket, or PCB repair is a separate task.

The upstream driver can block low-level input. Keep the laptop keyboard available and avoid experimenting with broad all-key subscriptions. The blocker here subscribes only to code 26 on explicitly matched keyboard handles.

## Stop, disable startup, or uninstall

To stop blocking now, right-click the script's green **H** tray icon and choose **Exit**. Closing its diagnostic window with X only hides that window.

To disable automatic startup:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Disable-Startup.ps1
```

Or press **Win+R**, enter `shell:startup`, and delete **Keyboard Bracket Blocker**. This does not stop an already-running instance; exit it separately.

To remove the driver too, first exit the blocker and Monitor, then open an administrator PowerShell window and run:

```powershell
& "$env:LOCALAPPDATA\KeyboardBracketBlocker\Driver\install-interception.exe" /uninstall
```

Restart Windows after successful driver removal. You can then delete the runtime folder. Other tools using Interception will also lose their driver; leave it installed if you still use them.

## Offline backup and dependencies

The repository contains the full custom blocker and setup/helper source. It does **not** embed the third-party binaries or an AutoHotkey installer. For an offline reinstall, save this repository ZIP, the AutoHotkey v2 installer, and both exact release archives below on another drive. To assemble the runtime manually, copy the `AHK v2\Lib` directory and `Monitor.ahk` from the AHI archive, place `Common\Lib\AutoHotInterception.dll` in `Lib`, then copy Interception's `library\x86` and `library\x64` DLL folders into `Lib`. Place `Block-Bracket.ahk` beside `Monitor.ahk`. Keep the upstream license files. Install Interception using the archive's `command line installer\install-interception.exe /install` from an administrator terminal, then reboot.

Pinned downloads used by Setup:

| Dependency | Download | SHA-256 |
| --- | --- | --- |
| AutoHotInterception v0.9.2 | [Official ZIP](https://github.com/evilC/AutoHotInterception/releases/download/v0.9.2/AutoHotInterception.zip) | `5E0DD6C69A61FE0E6F040D9FD82D7099022A84A0E6BC3A338666EEB23CA4F0DA` |
| Interception v1.0.1 | [Official ZIP](https://github.com/oblitum/Interception/releases/download/v1.0.1/Interception.zip) | `AD038963D6413055765128B0B931F6E765147C9916DBA79E65D872B261F9AF10` |

Use the GitHub release links above for Interception. AHI's [v0.9.2 release notes](https://github.com/evilC/AutoHotInterception/releases/tag/v0.9.2) explain removal of a compromised old download-domain link.

Upstream projects retain their own licenses: [AutoHotInterception](https://github.com/evilC/AutoHotInterception) (MIT), [Interception](https://github.com/oblitum/Interception) (see its bundled terms), and [AutoHotkey](https://www.autohotkey.com/). Setup preserves the downloaded AHI license and Interception license directory. Review upstream terms for redistribution or commercial use.

## Validation record

- The owner confirmed that the separate Bluetooth and USB blockers made the keyboard usable.
- The combined script successfully matched the live USB interface in `--check` mode.
- The packaging workflow is checked using Windows PowerShell 5.1 in a separate staging folder; driver installation and Windows reinstallation are not repeated as part of packaging.
- Fresh-install behavior, sign-in startup, and all Bluetooth/USB reconnect cases should be verified using the steps above on the restored system.
