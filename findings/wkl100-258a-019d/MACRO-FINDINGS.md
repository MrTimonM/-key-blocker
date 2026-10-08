# WKL-100 macro storage investigation

Status: runtime backup verified; mode-1 two-character playback physically confirmed; original map and pages restored.

## Storage and backup

Command 85 selects a CODE page at DC00 + 512*page. Pages 0..7 cover DC00..EBFF (4096 bytes). The same three-read continuation and seven-byte overlap validation used for the keymap reconstructs each full page.

`read_macro_pages.py` read all eight pages twice through the application-mode FF02:02 interface. Both copies match each other and the original firmware's DC00..EBFF. Backup SHA256: ad7facb2586fc6e966c004d7d1d16b024f5805ff7cb47c7a85dabd8b48892ca7. Every byte is 00 or FF; this does not independently establish valid macro directory entries.

The first attempt encountered a HID transfer failure while selecting page 4. A separate settings query worked immediately, and one repeat of the read-only backup succeeded. No reboot/reconnect or configuration write was needed.

## Writer

Runtime command 05 dispatches to firmware 9108. It adds 6E to the page selector and accepts sector IDs 6E..75, corresponding to eight 512-byte pages. The writer erases and writes a selected page. The controlled test invoked this writer only for pages 0 and 1, with original page backups and exact full-page readback.

## Directory and event decoding

Playback routine 4139 uses an index in XDATA 0BAC. The directory starts at DC00 with four bytes per entry:

- Bytes 0/1 form a little-endian offset relative to DC00.
- Bytes 2/3 form a little-endian byte count.
- At the resulting data pointer, the first byte gives a prefix length. Playback skips that length plus one and subtracts it from the remaining byte count. The prefix's purpose is not yet established.
- Routine 4221 consumes four-byte events: byte 0 is flags/type, bytes 1/2 form a big-endian delay, byte 3 is the action value.
- Flags masked with 70 select an action class. Class 00 builds an ordinary key action; class 10 builds a modifier bit from the action value's low nibble. Bit 7 branches between two handlers (69CD and 563A), apparently release and press; those labels still require end-to-end validation.

The candidate trigger encoding is described below; physical validation failed for the initial candidate. Preserve all eight pages and unrelated key actions before any future controlled macro experiment.

## Controlled two-character test

Firmware 1902 selects action type 03 as macro playback. Bytes 1, 2 and 3 are copied into playback state 0BA9 (mode), 0BAA/0BAB (repeat count) and 0BAC (directory index). The test action `03 00 01 00` selects macro index 0 with mode 0 and count 1.

`test_macro_12.py` saves the live 512-byte base map and macro pages 0/1, plus settings and Custom colors. It changes only top-row 8 slot 49 to the macro action. The first directory entry is `00 02 11 00`: offset 0200, length 0011. Page 1 begins with zero prefix length and four events:

`00 00 32 1E 80 00 32 1E 00 00 32 1F 80 00 32 1F`

These are intended to press/release HID 1, then press/release HID 2, using delay value 50. All written pages and the full base map matched readback; settings and Custom colors remained unchanged. No Fn-region write, ISP entry, reconnect or firmware-image write was used. The owner reported X/C normal but no output from the top-row 8 key. This is a failed physical playback test, despite exact storage readback; the trigger/event format is not validated. Original base and both pages were restored and read back exactly. The restore operation sends the exact saved base and both macro pages, verifying each.

Timing units, bounds, other repeat modes and other action classes remain unverified.

## Cause of the first failed test

The scheduler at D2E0 dispatches on mode byte 0BA9. Mode 1 reaches playback routine 4139; modes 2/3/4 force count 1 and also reach playback. Mode 0 falls through without calling playback. This directly explains why candidate action `03 00 01 00` produced no output despite correct storage readback.

A second test uses `03 01 01 00`, leaving the macro directory and events unchanged. This mode-1 test has separate v2 backups and evidence. The owner reported successful output: "yeah, it did , 121212". Macro playback is physically confirmed; single-press repetition semantics require clarification. The original keymap and pages were then restored, each with exact readback.
