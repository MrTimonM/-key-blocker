# WKL-100 USB/HID investigation

## Latest result: actual device keymap recovered

**Final result:** own-device keymap recovered, 8 -> 9 physically validated with
X and C unchanged, and the original base map restored. Normal typing returned
after a Windows restart. The temporary loss of typing is consistent with the
installed Interception filter's documented reconnect-ID exhaustion bug; the
device was present in Windows but absent from Interception's available slots.
The successful second test used application-mode readback and no reconnect.

The notes below are chronological. Statements in older sections that no keymap
backup exists are superseded by this result.

On 2026-10-07, the owner approved the standard ISP enable/unlock command after
its possible flash side effect was explained. We recovered two identical
65536-byte ISP-view dumps from this WKL-100. SHA-256:
`f9a7e1b1abf47c1a9b8b545eae1a0467c5f8086f05d28fb6bf1ee096eac37a64`.
The 4096-byte bootloader MD5 is `3e0ebd0c440af5236d7ff8872343f85d`, matching
the known SH68F90/BYK916 bootloader. The keyboard rebooted into its normal
258A:019D identity, and its RGB settings still match the previous baseline.

The missing step in the first ISP attempt was runtime command
`05 75 00 00 00 00`, which switches to the bootloader identity 0603:1020.
Its report-5 collection is 6 bytes; its report-6 collection is 2050 bytes.
Without command 55, different requested addresses returned the same bootloader
page. These responses were not valid reads of the requested addresses.
After the approved `05 55 00 00 00 00`, address-select command
`05 52 <address-low> <address-high> 00 00` and GET_FEATURE(6,2050) returned
`06 72` followed by 2048 bytes of the selected flash page. Finally
`05 5A 00 00 00 00` rebooted the keyboard. No ISP erase or image/page-write
commands were sent. The unlock may program the application-enable opcode;
this dump procedure is therefore not described as strictly read-only.

These dumps are the bootloader's logical ISP view, not a byte-for-byte raw
physical flash image: the bootloader remaps reset-vector bytes and masks
its relocated enable vector. This distinction does not affect the extracted
keymap regions.

| Region | Address | Size |
| --- | --- | --- |
| Current base | BC00 | 512 bytes |
| Alternate base bank | BE00 | 512 bytes |
| Factory base templates | C000, C200 | 512 bytes each |
| Current Fn | C400 | 512 bytes |
| Alternate Fn bank | C600 | 512 bytes |
| Factory Fn templates | C800, CA00 | 512 bytes each |
| Additional layers/banks | CC00, CE00, D400, D600 | 512 bytes each |

All four current base/Fn banks matched their corresponding factory templates
in the initial dump. The firmware's factory-copy code at 0C09 onward reads
CODE C000/C200 and writes sectors 5E/5F; its layer-zero writer at 9646 writes
exactly 512 bytes to sector 5E (BC00). The dispatcher at 7C01 selects that
writer for layer zero. These addresses refer to this device's dumped image,
not the Phantom firmware. See `wkl100-keymap-firmware-evidence.asm`.

The base region is retained as all 512 bytes, decoded as 128 four-byte entries.
We do not impose the Phantom editor's 113-slot/padding assumptions. Raw zero
entries and unknown internal actions are preserved; a label is not authority
to overwrite them. Physical positions must be validated independently from
stored output action labels. The old K81 application's listed indexes differ
for function/navigation keys and are not a trustworthy complete physical map.

The own-device base map differs from the borrowed Phantom layer at 32 slots.
For example, own slot 16 holds X (`00 00 00 1B`), whereas Phantom holds Z.
Own slot 49 holds 8 (`00 00 00 25`), slot 55 holds 9, slot 59 holds
the Fn internal action (`0D 00 00 00`), and slot 74 holds the right-bracket
output (`00 00 00 30`). Only the top-row 8 physical slot had prior remap-test
confirmation; action decoding alone is not physical-key verification.

The previously authorized 8 -> 9 test was repeated using this device's own
512-byte BC00 region. The offline diff changed only region offset 199,
full report offset 207, from 25 to 26. A second pair of complete ISP dumps
matched each other and differed from the original 65536-byte dump at
**only address BCC7**. Every other byte, including all Fn banks and factory
templates, was unchanged. The owner then reported that no keys typed, with RGB
still on. Therefore this experiment is **not physically validated**. The exact
captured original base region was sent back, and the settings interface still
responded with the previous baseline. The owner was asked to power-cycle in
wired mode. Typing recovery is pending. Windows reports both WKL HID Keyboard
Device nodes as present and OK, and no debugging Python/OemDrv processes remain
open. Those were the observations before host recovery. The subsequent Windows
restart restored typing. See the completed recovery and second test below.

### Completed host recovery and application-mode readback

The running `Block-Bracket.ahk` uses AutoHotInterception; the keyboard class
UpperFilters registry entry includes its `keyboard` filter. The diagnostic
Interception hardware-ID table showed the laptop and NACODEX keyboard but no
WKL-100, despite both WKL keyboard nodes being present and OK in Windows.
AutoHotInterception documents that USB reconnects increment its IDs, and
keyboards cease functioning when their IDs exceed 10 until Windows restarts.
The owner restarted Windows and confirmed typing returned. This is strong
evidence for that host-driver problem rather than a damaged keymap; we did not
measure the driver's internal counter directly. The knob and Fn reset worked
throughout. Diagnostic evidence: `typing-recovery.json` and
`interception-device-table.json`. Upstream:
https://github.com/evilC/AutoHotInterception#known-issues

Offline analysis of this keyboard's firmware additionally recovered a valid
**application-mode keymap read**, which the borrowed editor did not implement:

`09 83 <layer> 00 01 00 FF 00` plus 512 zero bytes; then GET_FEATURE(9,520).

This returned a matching 8-byte header plus 255 bytes from BC00 for layer 0,
or C400 for layer 1. Both matched the original ISP dump's corresponding
prefixes exactly. The command selects the CODE-space pointer at firmware
6C1C onward; the transfer routine reads CODE with MOVC at B773. This disproves
a blanket assumption that GET_FEATURE 9 can only expose XDATA on this WKL.
The firmware path examined sets an 8-bit response count. Only 255-byte prefix
readback was experimentally verified; do not claim this query reads all 512.
The complete regions remain backed up from the approved ISP dump.

The 8 -> 9 test was repeated with no ISP transition or USB reconnect. Runtime
prefix readback matched the intended map and differed only at offset 199;
the Fn prefix was unchanged. The owner confirmed **8 types 9; X and C are
normal**. The original captured 512-byte base region was then restored, and
both base and Fn prefixes matched the original dump. This is the completed
physical validation. See `runtime-remap-readback.json` and
`own-map-remap-restore.json`.

Both ISP scripts now refuse bootloader transitions when the Interception
keyboard filter is installed. Ordinary runtime settings/keymap queries and
the controlled test do not cause the USB reconnect that triggers this bug.

Artifacts: `wkl100-keymap.json`, `wkl100-base-slots.csv`,
`wkl100-fn-slots.csv`, `wkl100-*-512.bin`,
`wkl100-vs-phantom-map-diff.json`, `own-map-remap-flash-verification.json`,
`own-map-8-to-9-report.bin`, and `own-map-restore-report.bin`.
The restore report contains this keyboard's captured original bytes.
General remapping remains disabled in the older RGB CLI; the validated
controlled test lives in `test_own_map_8_to_9.py`, with runtime prefix checks.

Investigated on 2026-10-07 (Asia/Dhaka). Target supplied by the user: WKL-100, USB 258A:019D, usage page FF02, usage 02.

## Confirmed on the connected keyboard

- Manufacturer: SINO WEALTH; product: WKL-100; release_number: 0x1008.
- Control collection: HID#VID_258A&PID_019D&MI_01&Col07; interface number 1.
- Usage page 0xFF02, usage 0x0002.
- Feature report ID 0x09; Windows FeatureReportByteLength = 520 (0x208), including the report ID.
- InputReportByteLength = 8; OutputReportByteLength = 0 on this collection. The feature-report API is the control transport investigated here.
- Successfully submitted the settings-read request below and received a matching 136-byte response: 8 header bytes and 128 settings bytes. A repeated read returned the same settings. No configuration-write, reset, or firmware-update command was executed.

The observation is an actual exchange with the hardware through HIDAPI. It is not a USBPcap/Wireshark capture. USBPcap and Wireshark were not found at their standard installation locations.

## Packet format recovered from the executable

The FF02:02 backend at preferred-image address 0x480400 builds 520-byte feature reports, containing an 8-byte header and up to 512 data bytes:

| Byte offset | Meaning |
|---|---|
| 0 | HID report ID = 09 |
| 1 | command/opcode |
| 2 | command-specific selector supplied by the caller |
| 3 | zero |
| 4 | total packet count |
| 5 | packet index, starting at zero |
| 6-7 | data length, little endian |
| 8 onward | data, then zero padding to 520 bytes |

The executable chunks transfers into at most 512 data bytes per packet. It retries failed SET_FEATURE calls up to three times. Some read routines issue SET_FEATURE to select a query, pause, then GET_FEATURE to retrieve the answer. A SET_FEATURE call therefore does not necessarily mean a persistent configuration write.

## Hardware-verified settings query

Send with HidD_SetFeature / HIDAPI send_feature_report:

    09 84 00 00 01 00 80 00 [512 zero bytes]

Then retrieve with HidD_GetFeature / HIDAPI get_feature_report(9, 520). The actual returned length here was 136 bytes. The response header was:

    09 84 00 00 01 00 80 00

The 128 data bytes start:

    00 03 03 00 00 00 13 04 0B 00 04 20 01 01 00 04

They end with 5A A5. The meaning of individual settings bytes, including that trailing marker, is not yet established for the WKL-100.

Raw request and response: read-settings.json. Raw response: settings-response.bin. Settings only: settings.bin. The reusable read_settings.py validates the response header and length.

## Control command candidates recovered statically

These are paths in the supplied OEM executable, not hardware-validated WKL-100 write commands:

| Opcode | Executable path / evidence | Status |
|---|---|---|
| 84 | Read 128-byte settings, 0x480620 | Verified on WKL-100 |
| 04 | Write 128-byte settings, 0x481875 calls 0x480400 | Static only; individual WKL-100 fields unknown |
| 08 | General data write, 0x480970 calls 0x480400 | Static only; mapping semantics/model compatibility unverified |
| 88 | General data read, 0x4807A0 | Experimental 512-byte request echoed the header but returned only 126 bytes with USB descriptor-like content; do not treat this as a verified keymap read |
| 05 | Macro-data path, 0x4817A7 calls 0x480400 | Static only; WKL-100 macro support/layout unverified |

For example, the static 128-byte settings-write candidate is:

    09 04 00 00 01 00 80 00 [128 settings bytes] [384 zero bytes]

This candidate was not sent. The K81 G5 LED path (0x47F090, 0x47F74C) changes bytes in a 128-byte settings block before issuing command 04 through another backend. That is evidence that this executable uses settings writes for LED controls on supported models; it does not establish those byte offsets for the WKL-100 FF02:02 backend.

## Why the installed K81 software does not control this device

C:\Program Files (x86)\LEOBOG\K81\Dev\kb\KB.ini specifies:

    VID=0x258A
    PID=0x010C
    VID_Wireless=0x3554
    PID_Wireless=0xFA09
    Fw=24

The connected keyboard is 258A:019D. Additionally, the Fw=24 backend at 0x47D4B0 selects an FF00:01 collection with 520-byte feature reports. This WKL-100's FF00:01 collections instead expose report 05 with length 6 and report 06 with length 1032. Its FF02:02 collection exposes report 09 with length 520.

The executable contains a separate matching FF02:02 collection selector at 0x4802A0. The factory selects that backend for internal Fw value 25 (0x19), as seen at 0x40B4D9 through 0x40B4F3. This establishes structural transport compatibility, not compatibility of the complete K81 key layout, macro storage or settings model. Changing only the PID is insufficient to make the current K81 configuration match this collection.

Instrumenting an unmodified original-driver startup for 10 seconds produced 13 HID opens and 13 capability queries, but zero feature-report transfers. The supplied executable and its installation configuration were not edited.

## USB-level interpretation

Based on the HID specification, report 09 feature traffic on interface 1 is expected to use endpoint-zero class requests:

| Request | bmRequestType | bRequest | wValue | wIndex |
|---|---|---|---|---|
| SET_REPORT (feature) | 21 | 09 | 0309 | 0001 |
| GET_REPORT (feature) | A1 | 01 | 0309 | 0001 |

These setup fields are inferred from the HID specification and the observed interface/report ID; they were not measured in a bus capture. The API buffer size was 520; exact USB setup wLength and completion lengths require a bus capture.

References: https://www.usb.org/sites/default/files/hid1_11.pdf and https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/hidsdi/nf-hidsdi-hidd_getfeature

## Reproduce and capture

The tools are in C:\Users\Mahedi\Documents\K81-USB-Debug. Python packages pefile, capstone and frida were installed for this investigation; hid was already installed.

Read settings:

    python C:\Users\Mahedi\Documents\K81-USB-Debug\read_settings.py

Capture original OEM process calls for 120 seconds, leaving the app open afterward:

    python C:\Users\Mahedi\Documents\K81-USB-Debug\capture.py --seconds 120

Capture an existing OEM-driver process:

    python C:\Users\Mahedi\Documents\K81-USB-Debug\capture.py --pid PROCESS_ID --seconds 120

capture.js uses Frida Interceptor to log CreateFile paths, HID capabilities, HidD_SetFeature, HidD_GetFeature, HidD_SetOutputReport and debug output. It observes API calls without replacing them. This is useful with a vendor app that actually recognizes this keyboard. It does not log ordinary keyboard input reports. When attaching to an existing process, handles opened before attachment may lack a recorded device path.

For GET_FEATURE logs, the after field is the entire caller-provided buffer; Windows HidD_GetFeature returns a boolean, so that logger cannot report a USB short-transfer length. The direct HIDAPI settings reader records the returned report length.

Original-startup trace: original-startup.jsonl. Device descriptors/capabilities: device-caps.json. Static analysis: static-analysis.json and disassembly.txt. Experimental general-data query: read-data.json (not a validated keymap).

Analyzed executable: 32-bit PE, preferred base 0x400000.
SHA-256: 61ba19d230c7b54b487b06fd3fa857b554ea645f507542a0d96f1b6478aef076.
Static addresses in this report are for this build at its preferred image base; account for relocation when debugging.
Frida API reference: https://frida.re/docs/javascript-api/


## Follow-up: hardware key remapping validated

The user authorized a top-row 8 -> 9 test and confirmed that pressing physical 8 now types 9. Applied to WKL-100 using report 09, opcode 03, base-layer selector 00. This supersedes the unverified K81 opcode 08 candidate as the tested remapping path on this device.

Actual report: 520 bytes, header `09 03 00 00 00 00 00 00`, followed by a 512-byte base layer. The layer contains 113 four-byte actions and padding. Physical 8 is slot 49; its normal action `00 00 00 25` became `00 00 00 26`. The modified byte is report offset 207 (zero based). This write does not use the packet-count/length header fields inferred for the K81 backend; the matching firmware uses a state/sub-state dispatch format.

The base map was taken from the matching VID/PID project's reference defaults, not read from the user's keyboard. The user stated they can factory-reset the keyboard and authorized the remap test. The Fn layer was not written. Exact model equivalence and other keys' behavior have not been comprehensively tested.

Sources: https://sfphantom.notjustanna.net/protocol.js and https://sfphantom.notjustanna.net/keymap-defaults.js, project https://github.com/notjustanna/sfphantom.

Files: `remap-test.json`, `remap-8-to-9-report.bin`, `reference-base-layer.bin`, `active-base-layer.bin`, `restore-reference-base-report.bin`, and `wkl_control.py`. The reference restore packet is a factory-map fallback, not a backup of prior custom mappings.

Use `python wkl_control.py remap 8 8` to return physical 8 to its normal action while retaining the other actions in the current saved base-layer file. The remap command uses the reference map to locate physical slots, then changes only that action in the tracked active layer. If a factory reset or another app changes the keyboard externally, the saved active layer no longer reflects the device.

A raw ISP flash-read probe sent only `05 52 00 BC 00 00` and attempted GET_FEATURE report 06. It returned zero bytes; no erase/write/enable-firmware commands were sent. The device continued responding to the validated report-09 settings query afterward. No flash-read backup was obtained.


### Correction: reference-map incompatibility reported

The user then reported that X types C and the keyboard layout changed. The earlier 8->9 physical success verifies a write command but does NOT validate the reference base map for this WKL-100. The source's full reference layer overwrote other actions. Do not use that layer or its restore packet as this keyboard's factory layout. Requested a hardware factory reset; disabled remap and reference restore in wkl_control.py pending a device-specific keymap. No additional mapping writes should use this reference data.


## Follow-up: RGB effect write verified by device readback

After the user factory-reset the keyboard and confirmed 8 and X were normal, the RGB settings baseline had byte 10 = 0x0B. The user selected effect 3 with their keyboard controls; a new settings query showed exactly one change, byte 10 = 0x03. Therefore settings byte 10 is the effect selector on this device.

A USB write set it back to effect 11 (0x0B), preserving all 127 other settings bytes read from this keyboard. Packet: `09 04 00 00 01 00 80 00`, followed by 128 settings bytes, then 384 zero padding bytes. Changed byte is full report offset 18 (zero based). A subsequent `09 84` settings query matched the intended 128-byte block exactly, with only settings offset 10 changed. Physical RGB confirmation was requested; see later notes for the result.

Current CLI supports `rgb-effect 3`, `rgb-effect 11`, and `restore-rgb`. It stores a 128-byte device-read backup before each RGB-effect write and verifies full settings readback. Remapping and reference-map restoration remain disabled because of the physical layout mismatch. `restore-rgb` restores the settings saved before the last `rgb-effect` operation; it does not modify keymap layers.

Files: `rgb-reset-baseline.bin`, `rgb-effect3.bin`, `rgb-effect3-diff.json`, `rgb-write-backup.bin`, `rgb-pending-settings.bin`, `rgb-write-readback.bin`, and `control-history.jsonl`.


### Physical RGB validation complete

The user confirmed the lighting visibly changed from effect 3 to effect 11. `restore-rgb` then restored the original device-read settings block (effect 3) and verified an exact full settings readback. RGB effect control is now validated by both device readback and physical observation. Keymap support is incomplete until the actual model's map is obtained; the user has restored the normal layout with the keyboard's factory reset.


## Model and PCB evidence supplied by the owner

Actual consumer model: JEDEL WKL-100, 81-key compact layout with LCD and knob. PCB marking supplied in prior research: `K81 BYK916+8805 V1 20240514`.

Read-only inspection reconfirmed the installed JEDEL 3.0.2 bundle registers JEDELWKL100 with decimal VID 12625 / PID 20482 (3151:5002) and keyLayout Common81_K81JD, under yc3123_k81jd_soc. Its CommonKBYC3123 class extends CommonKBRY5088. These are separate device identities and transport families from the owner's measured 258A:019D / report-09 520-byte control collection. No JEDEL commands were sent to the keyboard.

The installed LEOBOG K81 KB.ini contains 81 visible key entries plus a hidden wheel entry. Its listed indexes are 8=49, 9=55, X=16, C=22, Fn=59, wheel=84. These were exported for offline comparison to k81-unverified-slot-table.json; they are not proven WKL-100 flash-map slots. The owner's observed X->C mismatch after the Phantom write confirms that the Phantom default layer is unsuitable. The K81 geometry/PCB evidence alone does not establish an authentic complete flash region or hidden actions.

Current result: validated device-specific RGB effect read/write/restore; remapping write dispatch observed but no trustworthy device-specific base-map backup or factory image is available. Remapping remains disabled. RGB uses the device's own live settings and does not depend on these reference keymap files.
