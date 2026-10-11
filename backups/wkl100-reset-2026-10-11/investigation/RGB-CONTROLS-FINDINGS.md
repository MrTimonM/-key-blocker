# WKL-100 RGB controls, 2026-10-08

Decoded from this keyboard's own firmware and tested over its FF02:02 runtime interface. No ISP entry, firmware image write, USB reconnect, or keymap write was used.

## Settings and controls

Settings occupy 128 bytes at CODE A400. Report 9 command 84 reads them; command 04 writes them. All offsets below refer to the settings payload, excluding the report header.

| Field | Encoding | Evidence |
| --- | --- | --- |
| Effect | Byte 10 | Modes 3, 11 and Custom 19 physically observed |
| Per-effect brightness | Byte `56 + 2*effect`, low seven bits | Firmware 629E; Custom raw 20 to 4 visibly dimmer, typing normal |
| Per-effect speed | Byte `57 + 2*effect`, high nibble | Firmware 638D; effect 3 speeds 1 and 5 tested twice, owner reports apparent success |
| Per-effect color selection | Byte `57 + 2*effect`, low nibble | Firmware 5D49; mode 1 indices 0/red, 1/green, 7/multicolor physically confirmed |
| Brightness byte high bit | Loaded into internal bit 3E | Meaning/effect-specific behavior not yet physically validated |

Brightness is quantized by firmware to 0, 4, 8, 12, 16, 20. These correspond to six steps from off through full brightness; arbitrary values between thresholds do not yield continuous adjustment. Preserve bit 7 when editing brightness.

Speed is loaded into XDATA 04F3. Firmware computes a 16-bit interval as `150 - 20*speed`; levels 1 and 5 produce 130 and 50 respectively. Units have not been established. Only levels 1 and 5 were tested. Do not expose the entire nibble range as validated speeds.

Indices 0 through 6 select RGB triplets from `A800 + 21*effect + 3*index`. The original mode-1 palette is red, green, blue, yellow, magenta, cyan, white. Index 7 takes a separate spatial-color lookup path at 5CA9. No palette-flash write was performed.

## Effect range

Dispatcher 8942 accepts IDs 0 through 19. IDs 0 and 1 share renderer D93C; 18 branches straight to cleanup without a renderer; 19 calls Custom renderer 8B9B. Other effect names remain unverified on this device. The installed K81 application's Custom ID 21 must not be copied into this keyboard's catalog.

`rgb-own-firmware-catalog.json` records all 20 dispatcher entries without inventing visual names.

## Restoration and verification

Brightness, speed and palette experiments each saved the original settings. Original settings were restored and read back exactly. The palette test also read all 512 bytes of the Custom region and base map before and after, confirming both unchanged. User confirmed red → green → multicolor and normal typing.

The speed owner's reply was qualitative: “i think alll working good as you wrote”. This supports apparent visual success, not a measured animation period. Palette reply: “all working good as expected and you said”.

Evidence: `rgb-brightness-test.json`, `rgb-speed-test.json`, `rgb-palette-test.json`, their settings backups, and `rgb-controls-firmware-evidence.asm`. Raw USB operations are in `control-history.jsonl`.

## Remaining work

Visual names for all animated effects, effect-specific direction/flags, arbitrary preset-palette editing, volatile/direct lighting command 08, and wireless behavior remain unresolved or untested. Per-key Custom writes and readback were established separately in CUSTOM-RGB-FINDINGS.md.
