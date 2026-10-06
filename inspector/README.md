# Key Lab: read-only WebHID inspector

Start here before attempting a firmware remap. This tool never sends output reports, feature reports, resets, or flash-write commands. Version 2 inspects browser-provided descriptors after device selection. It never opens or closes a HID interface and never subscribes to input reports. This change follows a keyboard-wide input failure reported while connecting with version 1; the exact cause is not confirmed. It does not probe feature reports or claim to read the keyboard's stored keymap.

## Run locally

Install Node.js if needed, then double-click `Start-Inspector.cmd` in the repository root, or run `node inspector/server.js` from that root. Open **http://127.0.0.1:8765** in desktop Chrome or Edge. No npm dependencies are needed. The server binds only to this computer's loopback interface and serves a fixed list of inspector files. Stop it with Ctrl+C.

1. Connect the mechanical keyboard in USB/wired mode. Close Phantom Editor so it is not holding the same interface.
2. Click **Inspect descriptors** and choose the external keyboard. The chooser filters for VID `258A`, PID `019D` but does not require a particular usage page, so we can inspect all accessible interfaces returned by the browser.
3. Read the report table. The important hypothesis to check is whether a vendor collection on usage page `FF02` exposes Feature Report `09` with a 519-byte data length. Matching that format is not proof of compatible firmware.
4. Enter a physical label such as `key immediately right of P`. Click the capture pad, then press that physical key once. Repeat with the keys whose output changed in Phantom Editor. Tab leaves the pad.
5. To observe the faulty `[` key itself, exit the Windows bracket blocker first. Keep the session short and restart the blocker afterward. Browser event capture only runs while the pad has focus; other fields are not logged.
6. Add notes about the actual physical key and resulting output, then **Export JSON**. The capture pad works without selecting a WebHID device at all. Share that file for analysis.

The JSON contains descriptor snapshots, the latest 500 key events, totals, and notes. Schema version 2 marks the mode as `descriptor-only`; `inputReports` stays empty. Device names and observed key contents are included; use test keys only. Nothing is sent to a backend or retained in localStorage. Refreshing the page clears the session.

## What the data means

- **DOM key / code:** OS/browser-translated events, not raw switch indices. The browser does not identify which physical keyboard produced them. A firmware-remapped key can change both these values. Fn often produces no DOM event.
- **Raw input reports:** Disabled in version 2. No input-report listener is registered. Normal keyboard collections are also protected by WebHID.
- **Descriptor snapshots:** Parsed WebHID collections, not original binary USB descriptors. Report sizes are computed from exposed fields, grouped by type and report ID, and exclude the report-ID byte. The session-interface label is assigned by this app, not the hardware USB interface number.
- **Feature Report 9:** Its presence shows an available report definition, not what every command does or where firmware stores the keymap. This inspector does not request or write it.

## Research checkpoint

The reference [Phantom Editor protocol](https://sfphantom.notjustanna.net/protocol.js) uses the same VID/PID observed here, vendor usage page `FF02`, Feature Report 9, and a 519-byte write payload. Its [device flow](https://sfphantom.notjustanna.net/device-io.js) uses cached or bundled defaults instead of reading back the current keymap. Its [layout](https://sfphantom.notjustanna.net/keyboard-layout.js) describes Phantom-specific firmware indices. Those indices must not be assumed to be this keyboard's indices. Some protocol comments contradict each other about WIN/iOS banks, so bank selection also needs empirical validation.

Next steps after collecting evidence:

1. Compare the actual descriptors against the reference protocol.
2. Record the existing physical-to-output map, focusing first on keys changed by the prior save.
3. Establish a recoverable baseline for this exact keyboard; a DOM key log alone cannot recover its firmware keymap.
4. If raw command capture is needed, use USBPcap/Wireshark on the correct USB device. The inspector cannot observe reports another website sends. Capture a separately planned, controlled change only after resolving backup/recovery; do not click Save merely to generate traffic.
5. Verify action encoding and physical-slot mapping before implementing a write interface. Full-layer writes based on another model's defaults can change unrelated keys.
6. Test any eventual saved mapping with the Windows blocker stopped, browser closed, and keyboard power-cycled, on both USB and Bluetooth and another host.

Reference: [Chrome WebHID documentation](https://developer.chrome.com/docs/capabilities/hid).

## Tests

After updating, close the old inspector tab and reopen the page; look for **Descriptor-only · v2**. An old tab can still be running version 1. If the keyboard is already unresponsive, closing the page may not restore it; reboot as previously needed. Descriptor-only selection still needs real-device validation.

Run `node --test inspector/model.test.js` from the repository root. These cover DataView offsets, nested descriptor aggregation, and bounded buffers for stuck-key input. Browser/device permission and actual keyboard behavior still require a physical session.
