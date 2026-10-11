# WKL-100 Color Studio

A local WebHID app for the owner's **WKL-100, USB 258A:019D**. Read the current effect and stored custom colors, pick a different color for each physical key, and save in Custom mode. Ctrl/Command-click selects several keys; each key still keeps an independent color. Hex input, quick swatches, import/export, backup download, and verified restore are included.

Run `node rgb-editor/server.js` from the repository root, or double-click `Start-RGB-Editor.cmd`. Open **http://127.0.0.1:8766** in desktop Chrome or Edge. No npm dependencies are needed. Connect the keyboard in wired mode, close other keyboard-control apps, then click **Connect keyboard** and select WKL-100.

The page reads the actual settings and custom table; its diagram shows saved custom colors, not a capture of an animated preset. Current presets are shown by their actual firmware ID. Names for unverified presets aren't guessed. Choose **Custom · your colors** and **Save to keyboard** to activate the edited colors. Preview mode sends no USB traffic and clearly labels its example colors.

Every save re-reads the device, rejects stale lighting, persists a local backup before writing, updates only the 378 color bytes and the effect field needed for Custom, and verifies the entire custom region, settings, and unchanged base map. A failed verification attempts to restore the previous lighting. **Restore backup** restores the saved color table and effect while preserving other current settings; the state before restore becomes the new backup. Importing a backup into the editor imports visible key colors only; it doesn't issue a device write.

The device selector validates product name, VID/PID, vendor collection FF02:02, and report 9's 519-byte descriptor. It opens only that vendor interface and closes it on explicit disconnect or page exit. No ISP entry, reset, reconnect, keymap write, or firmware image write is implemented. Stop the app with Ctrl+C in its server window.

Protocol details and experimental evidence are in `../findings/wkl100-258a-019d/CUSTOM-RGB-FINDINGS.md`. The red/green/blue plane format and eight Y/U/I/O/G/F/V/B positions were physically verified. Other legends use the owner's recovered factory matrix; physical testing of every key remains outstanding. Fn and other internal actions are never modified.

WebHID sends report ID separately from the report body; see the [official Chrome WebHID documentation](https://developer.chrome.com/docs/capabilities/hid). Settings byte 10 identifies the current mode, with 19 being Custom. Custom colors occupy AC00–AD79 in three 126-byte planes. Report 9 command 06 writes those bytes and preserves the remaining sector metadata. The firmware's continuation-read behavior is used to recover a complete 512-byte region, with overlap checks and two matching reads before an update.

Run `node --test rgb-editor/protocol.test.js` for protocol and failure-recovery tests. `browser-test.mjs` exercises the UI against a simulated WebHID device; it never opens real hardware. Browser permission and an actual WebHID save still need validation in a real browser session with the keyboard.
