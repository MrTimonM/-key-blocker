# WKL-100 custom RGB: verified

The owner confirmed Y/U/I/O are red and G/F/V/B are green after the controlled USB update. Full 512-byte readback matched the desired region; settings and the base keymap were unchanged.

Custom mode is settings byte 10 = 19. Custom colors reside at CODE AC00. The 378-byte color payload consists of three 126-byte planes: red at offset 0, green at 126, blue at 252. Key positions for this experiment came from this keyboard's recovered base map: Y=38, U=44, I=50, O=56, G=33, F=27, V=28, B=34. These positions and channel order are now physically confirmed for those keys.

Write: feature report 9, report-inclusive header `09 06 00 00 01 00 7A 01`, followed by 378 color bytes and 134 zero padding bytes. Firmware handler 7393 writes AC00-AD79 and preserves AD7A-ADFF from the existing device region. A800 is the effect palette, not the per-key custom table.

Full runtime readback was recovered without ISP or reconnecting. Command 85 with page byte 68 sets the CODE pointer to AC00 through eight-bit arithmetic wrapping (handler 6C52). Header: `09 85 00 00 01 68 FF 00`. Read 255 data bytes, then issue two continuation queries `09 83 04 00 01 00 FF 00`. Selector 4 leaves the CODE pointer unchanged (handler 6C1C). Each 255-byte transfer advances the saved pointer by 248 bytes; its last seven-byte packet does not advance it (9EBC). Check the seven-byte overlap before combining data. The resulting 512-byte live region initially matched the prior ISP dump exactly. The same continuation method also retrieved the full base map for the unchanged-map check.

Artifacts: custom-eight-keys-backup.bin, custom-eight-keys-desired.bin, custom-eight-keys-readback.bin, custom-eight-keys-apply.json. The controlled apply/restore tool is set_custom_eight_keys.py. `restore` returns the backed-up custom colors while leaving the current settings intact; it requires custom mode 19 and the expected eight key mappings.

No ISP entry, firmware-image write, reboot, USB reconnect, keymap update, or settings update was used. Only eight bytes needed changing for this particular baseline; all 512 region bytes were compared after the write.
