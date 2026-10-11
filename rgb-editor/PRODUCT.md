# WKL-100 Color Studio

## Platform
Web, desktop Chrome or Edge, wired USB through WebHID. Localhost server.

## Stack
Plain HTML/CSS/JavaScript and dependency-free Node server, matching the repository's existing inspector.

## Product truth
The owner wants an independent color choice for every key and detection of the current lighting preset, with a Custom option. Multi-selection is only a shortcut; colors remain independent. Hardware identity is 258A:019D WKL-100. Protocol was recovered from the owner's firmware, with effect switching and eight per-key colors physically verified. Preset names for other effects are unverified and must not be invented.

## Constraints
Preserve other color slots and metadata, settings, and keymaps. Back up before writes and verify device readback. No ISP, firmware flashing, resets, or keymap writes. No cloud service or external dependency. A browser session with the real keyboard still needs validation.
