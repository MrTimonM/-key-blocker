# JEDEL Driver reverse-engineering findings

These findings are from a read-only inspection of the installed Electron application at:

`C:\Users\Mahedi\AppData\Local\Programs\JEDEL Driver`

## Why the installed app does not detect this keyboard

The application contains a WKL100 model entry named `JEDELWKL100`, but that entry is registered for:

| Field | App's WKL100 entry | This keyboard |
|---|---:|---:|
| USB VID | `0x3151` | `0x258A` |
| USB PID | `0x5002` | `0x019D` |

The values in the app are decimal `12625` and `20482`. The values for this keyboard come from the descriptor export (`9610` and `413`). This is a device/firmware identity mismatch, so the app's model whitelist will reject the keyboard even though the product name is WKL-100.

The installed package is JEDEL Driver `3.0.2`. It also contains `iot_driver.exe` and expects a local IOT service on `127.0.0.1:3814`; the “plugin version too low” message refers to that bridge, not proof that the keyboard firmware can be updated by this app.

## Protocol present in the app

The WKL100 implementation inherits the `CommonKBYC3123`/`CommonKBRY5088` protocol. It uses 64-byte feature messages and a Bit7 checksum. The relevant commands are:

- `0x8A` (`GET_KEYMATRIX`): reads eight 64-byte chunks, producing a 512-byte matrix.
- `0x0A` (`SET_KEYMATRIX`): writes a matrix; the app has both a bulk writer and a single-key writer.
- `0x90` (`GET_FN`) and `0x10` (`SET_FN`): reads/writes Fn-layer data.

The app's single-key writer places the matrix slot index in byte 2 and the four-byte encoded action in bytes 8–11. The exact layer/profile byte and checksum framing still need to be validated against this keyboard's own firmware. The installed app's `0x3151:0x5002` protocol must not be assumed compatible with `0x258A:0x019D` until a read-only probe succeeds.

## Safe next step

Do not send the app's write commands to this keyboard. First add a descriptor/interface selector and a read-only capture mode to the inspector, then compare the keyboard's feature-report sizes and responses with the JEDEL protocol. The previous inspector version opened the wrong HID interface and temporarily stopped normal typing, so all future probing must have an explicit close/recovery path and must never issue `SET_*` commands.

The current WebHID descriptor shows a vendor collection with a 519-byte feature report, which differs from the app's 64-byte feature-message path. That is another reason to treat the two protocols as unconfirmed until captured safely.
