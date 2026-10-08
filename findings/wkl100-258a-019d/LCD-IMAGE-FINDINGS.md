# WKL-100 LCD image investigation

Device: JEDEL WKL-100, USB 258A:019D, vendor collection FF02:02.
Date: 2026-10-08. First-block result: the owner still sees the original GIF.
Full candidate-frame result: original GIF still plays; typing and knob remain normal.

## OEM image encoder and transport

Read-only static analysis of the installed LEOBOG K81 OemDrv.exe found:

- VA 0x4833D0 converts bitmap pixels into row-major, big-endian RGB565.
  Red is `F8 00`, green `07 E0`, blue `00 1F`.
- VA 0x4835D0 uploads frame bitmaps by calling backend 0x480190, which calls
  0x47FE10. Frames are transferred individually; the worker caps its loop at 32.
- 0x47FE10 splits frame data into 4096-byte blocks and 512-byte chunks.
  Feature report 9 contains 520 bytes including the report ID:

| Offset including ID | Meaning |
| --- | --- |
| 0 | Report ID 09 |
| 1 | Image upload command 0C |
| 2 | Frame index |
| 3 | 4096-byte block index |
| 4 | Number of chunks in this block |
| 5 | Chunk index within block |
| 6–7 | Actual chunk length, little-endian |
| 8–519 | Pixel data, padded to 512 bytes |

The OEM uploader pauses 15 ms before reports and reads an eight-byte input
report after each block. Its response framing must not be copied directly:
the inspected K81 expects a block index in response byte 2, whereas this
WKL-100's actual replies have a different structure.

## Measured first-block test

`test_lcd_red_frame.py` sent frame 0, block 0, eight 512-byte chunks of red pixels.
Each header was `09 0C 00 00 08 chunk 00 02`.
All eight packets produced `09 0A 06 01 08 00 00 00` on the vendor input report.
Full base-keymap, custom RGB and settings readbacks matched their pre-test
values exactly. The handle was closed; there was no ISP operation or reconnect.

The main firmware's 0x8276/0x829A response builder emits:
`09 0A 06 status header-byte-4 00 00 00`. Success status is 01.
0xA355 sets success after a serial-transfer completion flag. This acknowledgement
confirms the main-controller transfer path, not correct pixel display, image
storage, dimensions or successful parsing by the LCD companion.

The first block contains 2048 pixels. The script's 128x128 dimensions are a
candidate limit, not measured hardware dimensions. No remaining blocks have
been sent at that stage. The owner reports a roughly square LCD with a GIF menu page.

## Unresolved details

- Actual screen width/height and full-frame completion behavior.
- GIF frame count, delay, active frame selection and any commit command.
- Original image backup/readback. The test replaces image content and cannot
  promise restoration of the former image.
- Live LCD clock retrieval. The observed clock acknowledgement is not a time
  response. Command 0B successfully sets the clock; a getter is not established.
- Firmware for the LCD companion is absent from the recovered main-controller
  image. The main controller relays commands 0B/0C/0D rather than implementing
  their image rendering.

Evidence: `lcd-image-oem-evidence.asm`, `lcd-image-firmware-evidence.asm`,
`lcd-red-blocks-0-1.json`, and `lcd-input-clock-capture.json`.

## Full candidate transfer

The remaining seven blocks were subsequently sent, completing 32768 bytes of
red pixels (a candidate 128x128 frame). All 56 reports received the same
acknowledgement. During subsequent verification, settings and the first base-map
query completed, but the next continuation query returned a short HIDAPI write
(-1). The script closed its handle and stopped. Full post-transfer preservation
is therefore NOT verified for this attempt. The device remains enumerated
under the same VID/PID and vendor collection. No automatic retries, reset or
reconnect were performed. See `lcd-red-blocks-1-7.json`.

## Recovery verification and compatibility limit

A fresh vendor-interface handle successfully read the entire settings, base map
and custom RGB region. All three hashes match the immediate pre-upload hashes
recorded in `lcd-red-blocks-1-7.json`. The earlier failure was transient; its
cause is unknown. An older settings backup differs at byte 51 (01 versus 02),
but the immediate pre-upload comparison matches, so this is not an upload-induced
settings change. The owner confirms typing and the knob are completely normal.
The GIF menu offers no other image or custom/user option.

The image uploader is the G5 keyboard backend at 0x47Dxxx�0x480190. The separate
backend constructor at 0x4801C0 stores internal type 0x8805 and uses vtable
0x5FA03C. It selects the actual FF02:02/520-feature/8-input interface at
0x4802A0. Its image-upload vtable slot +0x34 points to 0x47A170, rather than
0x480190. This is a compatibility gap in the installed OEM application, not
proof that the WKL-100 cannot support custom images. The 0x8805 value is a host
backend identifier; it does not independently identify the LCD companion chip.

The separately installed JEDEL Driver 3.0.2 declares a 128x128, 16-bit screen
for JEDELWKL100, but that model uses VID/PID 3151:5002 and a different 64-byte
protocol. This supports 128x128 only as a candidate for a related variant, not
as a measured resolution or compatible uploader for 258A:019D. Its SETTFTLCDDATA
command is 0x25, with 56-byte chunks, frame count and frame delay metadata; none
of those commands were sent to this keyboard.

**Result:** the red display test did not work. Transport and preservation are
verified; display format, activation, image storage, and a live-time getter are
not. Command 0D is forwarded by the main controller, but its companion-side
meaning remains unknown. Do not label it an activation or erase command, or
send guessed payloads. Next useful evidence is an image-capable driver for the
258A:019D variant, its captured upload, or the actual LCD-companion firmware.
