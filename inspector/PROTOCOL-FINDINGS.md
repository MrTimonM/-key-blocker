# WKL-100 investigation: disable physical right bracket

**Historical record:** the missing-keymap-backup conclusion below was superseded by the [2026-10-07 device recovery and validated remap](../findings/wkl100-258a-019d/README.md). The inspector itself remains unchanged; bracket disabling has not been tested.

Research date: 2026-10-06. No keyboard writes were performed during this investigation.

## Evidence from the owner's descriptor export

- Product name: `WKL-100`; USB VID/PID `258A:019D`.
- Vendor collection: usage page `FF02`, usage `02`.
- Feature report 9: 519 bytes (8 bits x 519), excluding report ID.
- Input report 9: 7 bytes. This is a separate report type, not a 512-byte keymap readback.
- Other exposed feature reports: report 5 (5 bytes), report 6 (1031 bytes), both on page `FF00`. Size alone does not establish their purpose. Neither was read or written.
- Captured DOM events include `BracketRight` / `]`. Physical labels were empty and the Windows `[` blocker was active. These events do not establish a firmware slot.
- Owner reports Phantom Editor changed multiple mappings, and Fn + Esc restored the original layout. That is evidence of a working recovery for that prior operation, not proof that arbitrary firmware writes are recoverable.

## What the reference editor actually implements

Sources:

- https://github.com/NotJustAnna/sfphantom/blob/main/key-picker.js
- https://github.com/NotJustAnna/sfphantom/blob/main/protocol.js
- https://github.com/NotJustAnna/sfphantom/blob/main/device-io.js
- https://github.com/NotJustAnna/sfphantom/blob/main/keymap-defaults.js
- https://github.com/NotJustAnna/sfphantom/blob/main/keyboard-layout.js
- https://github.com/NotJustAnna/sfphantom/blob/main/README.md

### Candidate disabled action

The reference picker implements `unbound` as `[0, 0, 0, 0]`. Its ordinary HID-key action is `[0, 0, 0, usage]`. Thus `00 00 00 00` is supported by the editor as an unbound action. This has **not** been experimentally verified on the WKL-100, including any Fn-layer fallback behavior.

Some internal actions are displayed as None but retain nonzero bytes. Do not zero an entry merely because its visible label says None. Fn and reset actions are explicitly locked by the reference editor.

### Write structure

One call sends Feature Report 9 with 519 data bytes:

| Data offset | Meaning in the reference implementation |
| --- | --- |
| 0 | `03`: keymap write command |
| 1 | Region/layer selector; editor uses 0 for Base, 1 for Fn |
| 2–6 | Five zero padding bytes |
| 7–518 | Entire 512-byte region |

The reference builder fills the region with 113 four-byte action entries and zero padding. Slot `i` begins at data offset `7 + 4*i`. The report ID is passed separately to WebHID. There is **no single-key patch command in this implementation**. This does not prove no such command exists in the firmware.

The builder's 113-slot count and padding reflect Phantom firmware. They must not be imposed on the WKL-100 without validation. Even identical report sizes do not establish identical region contents.

### Physical slot versus output code

Phantom's bundled Base slot 74 contains `00 00 00 30`. Slot 75 contains `00 00 00 31`. Its visible labels are Brazilian ABNT2, so the apparent bracket legends cannot be copied directly into a US-layout experiment. Neither slot is established as the physical right bracket on this WKL-100. Windows scan codes, DOM codes, HID usages, and firmware matrix indices are distinct identifiers.

### Readback and preservation

The reference README explicitly says it does not have real flash readback. `device-io.js` loads browser-cached values or bundled Phantom defaults. Its comments explain that the known report-9 read path exposes XDATA while the keymap is stored in CODE space. That explanation is an upstream claim about Phantom, not a measured WKL-100 memory map.

The public GitHub repository contains only the web editor. The referenced `firmware-c/docs/open-questions.md`, `docs/action-bytes.md`, firmware C sources, and technical editor are not in its published tree. Their contents have not been verified. Some protocol comments also contradict each other about WIN/iOS banks; the README and later comments say the writable regions apply to WIN. WKL-100 bank behavior remains unknown.

## Result and next evidence needed

We have a concrete candidate disabled action and a matching report format, but not the WKL-100 region bytes or a verified physical-slot map. Therefore the current inspector remains descriptor-only, with no write button.

To preserve the rest of the layout, obtain either:

1. An authentic WKL-100 firmware/configuration image from which its factory map and matrix can be verified; or
2. A verified device readback/backup method; or
3. A separately planned reconstruction experiment with explicit acknowledgment that the whole layer may change, preserving the correct Fn/reset behavior. A normal key-capture export alone cannot reconstruct hidden actions or matrix indices.

Do not flash Phantom firmware onto this keyboard. Do not send report 6 simply because it is large. Do not present a Phantom-default layer with one slot zeroed as a WKL-100 single-key edit.

Once a trustworthy region and slot are available, construct an offline before/after diff that changes only that four-byte slot while preserving every other region byte. Then perform one controlled save and test with the Windows blocker stopped, browser closed, keyboard power-cycled, and on USB/Bluetooth and another host. Fn + Esc remains the owner's documented recovery for keymap changes.
