# WKL-100 LCD clock: firmware analysis

Offline analysis followed by one application-mode LCD synchronization test. No firmware-image or keymap writes were performed.

## Result

The date/time **setting route** is identified. The decoded time-setting packet has now been physically confirmed on this WKL-100. The LCD's **currently displayed time has not been retrieved over USB**. A flash image contains code and persistent data, not a snapshot of a running clock or the LCD pixels.

## Host payload

LEOBOG OemDrv.exe calls Windows GetLocalTime at VA 0x45BF69 and passes an 11-byte payload to its feature-message writer at VA 0x45C017 with command 0x0B. Payload values are ordinary binary integers, not ASCII or packed BCD, according to the host instructions.

| Payload index | Meaning |
| --- | --- |
| 0 | Windows master volume percentage (scalar multiplied by 100) |
| 1 | CPU utilization percentage |
| 2 | Physical memory load percentage |
| 3 | Year low byte |
| 4 | Year high byte |
| 5 | Month |
| 6 | Day of month |
| 7 | Hour (Windows 0-23) |
| 8 | Minute |
| 9 | Second |
| 10 | Windows weekday (Sunday=0) |

The backend constructs an eight-byte header, including report ID. Thus payload hour/minute/second would occupy report-inclusive offsets 15/16/17; WebHID data offsets 14/15/16, where the report ID is passed separately. This layout is decoded from the OEM executable; it was physically validated by setting this keyboard's clock on 2026-10-08. The executable supports multiple variants, so the call-site match alone is insufficient proof of end-to-end compatibility.

## Matching handler in this keyboard's own firmware

- 0x7BB5 reads the USB command from XDATA 0x08FB, subtracts 3, and uses the jump table at 0x7BD1. Commands 0x0B, 0x0C, and 0x0D all branch to 0x7C72.
- 0x7C72 sets bit 0 of XDATA 0x0F1D and marks pending transfer state. It does not parse or store individual time fields here.
- Scheduler 0x05FA tests that same flag. At 0x061C it passes the USB buffer at XDATA 0x08FA to 0xBAB1 with length 0x0208 (520 bytes).
- 0xBAB1 prefixes that buffer with bytes 50 81 02 08 at XDATA 0x08F6 and configures the serial transmit buffer.
- 0xD2AE loads the next byte, and 0xD2B1 writes it to SFR 0xAA. Receive routine 0x9825 reads the same SFR and collects response bytes.

This is strong evidence that the main keyboard controller relays clock/configuration data to a companion controller. The board marking '+8805' is a candidate for that companion, but the actual receiving chip and its clock implementation are not established by these instructions.

## Readback limit

The traced application-mode feature-read handler at 0x6BC3 selects CODE-space regions for commands 0x82, 0x83, 0x84, 0x85 and 0x8A. That handler does not expose a live hour/minute/second value. This does not rule out an untraced getter elsewhere, another HID interface, or a companion-specific transaction. Serial receive code exists, but no clock response format has been identified.

The recovered ISP dump is the main controller's logical CODE-space view. It is not a companion firmware dump or XDATA/RAM snapshot. A reliable displayed-time getter therefore remains unresolved; report sizes or stale request payloads must not be interpreted as live LCD time.

## Evidence

- `lcd-clock-firmware-evidence.asm`: exact relevant ranges from the owner's firmware.
- `lcd-clock-oem-evidence.asm`: host clock-packing and report-header instructions.
- Firmware SHA256: `f9a7e1b1abf47c1a9b8b545eae1a0467c5f8086f05d28fb6bf1ee096eac37a64`.

## Additional host decoding, 2026-10-08

The first three fields are host statistics rather than unidentified configuration flags. Function 466850 activates IAudioEndpointVolume (IID 5CDF2C82-841E-4546-9722-0CF74078229A), calls its GetMasterVolumeLevelScalar vtable slot, and multiplies the returned float by 100. The output is placed in payload byte 0. Microsoft documents the scalar's range as 0..1: https://learn.microsoft.com/en-us/windows/win32/api/endpointvolume/nf-endpointvolume-iaudioendpointvolume-getmastervolumelevelscalar . This identifies the host source; the actual companion display treatment remains untested.

Functions 466680/466790 supply payload byte 1; the latter's embedded PDH paths are `\\Processor Information(_Total)\\% Processor Utility` and `\\Processor Information(_Total)\\% Processor Time`, with PdhCalculateCounterFromRawValue and a 100-percent cap. GlobalMemoryStatusEx at import 5BD2F8 fills MEMORYSTATUSEX, whose dwMemoryLoad at offset 4 supplies payload byte 2. These assignments are supported by `lcd-clock-host-stats-evidence.asm` and PE import/string inspection.

Next useful evidence is a controlled clock synchronization and the companion serial reply path. One clock-setting packet was sent on 2026-10-08: `09 0B 00 00 01 00 0B 00`, followed by `00 00 49 EA 07 0A 08 0F 33 1E 04` and 501 padding bytes. The owner confirmed the display changed from 19:12 to approximately 15:51 and typing remained normal. Full settings, base keymap and Custom table readbacks matched their pre-test values. See `lcd-clock-sync-test.json` and `test_lcd_clock_sync.py`. Volume/CPU fields were zero placeholders; memory load was Windows-reported 73%. A successful setting packet does not establish any live clock getter.
