# WKL-100 Fn-layer editing

On 2026-10-08, a controlled runtime write changed Fn-layer slot 49 (top-row 8) from `00 00 00 00` to `00 00 00 26`. Only region byte 199 changed. A full 512-byte readback matched the intended region, while the base map and settings remained unchanged.

The owner confirmed: normal 8 typed 8, and Fn + 8 typed 9 (reply: "89 yes, it does"). The original Fn region was restored and read back exactly afterward.

Read header: `09 83 01 00 01 00 FF 00`, followed by the two validated continuation reads. Write header: `09 03 01 00 00 00 00 00`, followed by the entire preserved 512-byte Fn region. Report ID is included here; WebHID passes it separately.

Fn + Esc at slot 0 (`08 FF 00 00`) and Fn at slot 59 (`0D 00 00 00`) were explicitly checked and preserved. Do not reconstruct this layer from visible key labels or another model's defaults.

Evidence: fn8-test-apply.json, fn8-test-restore.json, fn8-test-backup.bin, test_fn8_to9.py. This verifies Windows wired-mode Fn editing; other banks and wireless behavior remain untested.
