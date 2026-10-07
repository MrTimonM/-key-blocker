# Verified WKL-100 feature-report protocol

All offsets below include the leading report ID unless explicitly labeled as
region/settings offsets. HIDAPI includes the ID; WebHID takes it separately.
These commands were investigated on one WKL-100 `258A:019D` / release `1008`.

## Application mode: report 9, FF02:02

Every request below is 520 bytes: the shown eight-byte header plus 512 bytes.
Query requests use zero-filled trailing data.

| Operation | Header | Returned or written data |
| --- | --- | --- |
| Read settings | `09 84 00 00 01 00 80 00` | 128 settings bytes after matching header; 136 bytes total |
| Read map prefix | `09 83 LL 00 01 00 FF 00` | 255 map bytes after matching header; 263 bytes total |
| Write base map | `09 03 00 00 00 00 00 00` | Entire captured 512-byte base region |
| Write settings | `09 04 00 00 01 00 80 00` | Own live 128 settings bytes, then 384 zero padding bytes |

For reads, call `send_feature_report(request)`, wait about 50 ms, then
`get_feature_report(9,520)`. Check the returned header and actual byte count.
HidD_GetFeature's boolean return does not establish the USB short-transfer
length; HIDAPI's returned data length was recorded for these experiments.

For opcode `83`, `LL=0` selects BC00, `1` selects C400, `2` selects CC00,
and `3` selects D400 in the examined firmware path. Base and Fn queries were
experimentally validated. The count in this path is eight bits; only 255-byte
prefix readback was tested, not a complete 512-byte region.

Own-firmware evidence: the CODE pointer selection is at 6C1C onward, and MOVC
at B773 supplies bytes to the USB transfer. Therefore this device has a CODE
read path; another editor's XDATA-only limitation must not be imposed on it.

### Isolated 8 → 9 write

Normal stored action: `00 00 00 25`; replacement: `00 00 00 26`.
Slot 49 starts at region offset 196. Only offset **199**, report offset **207**,
changes. The packet still writes all 512 region bytes, preserving the other
511 bytes. It is not a firmware single-key patch command.

The own-firmware dispatcher at 7C01 selects writer 9646 for layer zero.
That writer programs 512 bytes into sector 5E, address BC00. Factory-copy
code at 0C09 reads C000/C200 and restores sectors 5E/5F.

All other slots, unknown actions, Fn actions, alternate banks, and templates
were preserved. The full-image comparison changed only BCC7. The original
region was restored after physical validation.

### RGB effect write

Read the device's own 128 settings bytes first. Change only **settings offset
10**, report offset **18**, then use opcode `04`. Compare all 128 readback bytes.
Effects **3** and **11** were physically verified. The original live block was
restored. Do not substitute another keyboard's settings or infer meanings for
the other bytes from their size alone.

## ISP recovery: separate USB identity

This procedure was separately approved by the owner after the unlock's possible
flash side effect was explained. It is not strictly read-only. It must not be
repeated on this Windows host while the Interception filter is installed.

1. On runtime FF00 report-5 collection, send `05 75 00 00 00 00` to enter ISP.
2. Discover the newly enumerated `0603:1020` bootloader, product `Gaming KB`.
   On Windows, select its separate report-5 and report-6 collections by their
   descriptors: six-byte command report and 2050-byte transfer report.
3. Send `05 55 00 00 00 00` to enable/unlock reading. Upstream documents that
   this may program an LJMP opcode `02` at firmware-size minus five, EFFB here.
4. For each page, send `05 52 AL AH 00 00`, with little-endian read address.
   GET_FEATURE(6,2050) returns `06 72` plus 2048 bytes.
5. Read 0000–FFFF twice and compare the complete results, including the known
   4096-byte bootloader hash. Different pages must not all be identical.
6. In `finally`, attempt `05 5A 00 00 00 00` to reboot and close both handles.

Without the ISP transition, the original runtime report-6 probe returned no
data. In ISP without unlock, different requested addresses returned an identical
bootloader page. Neither result was a valid keymap backup.

No ISP erase (`05 45`), write-address (`05 57`), or page-write (`06 77`) was sent.
The images are **logical ISP views**: reset-vector bytes are redirected and the
relocated enable vector is masked. They are not verbatim physical flash images.
This distinction does not affect BC00/C400 map extraction.

## Limits

- No bracket-disable test or validated zero-action/Fn fallback behavior.
- No complete physical matrix mapping beyond the tested 8 slot.
- No full 512-byte application-mode readback verified.
- No validated LCD clock getter or framebuffer read.
- No evidence that matching VID/PID makes another model's map or firmware safe.
