// USB SET_REPORT FEATURE 9 keymap-write protocol over WebHID.
//
// Wire format (verified empirically working 2026-05-01; see
// firmware-c/notes/webhid_write_debug.md for the full derivation):
//
//   SET_REPORT, type=Feature, ReportID=9, Interface=1.
//   The Linux HID stack prepends the report ID byte (0x09) to our payload,
//   so the actual SETUP wLength on the wire is 520. The USB controller
//   delivers all 520 bytes (including the leading 0x09) to the EP0 FIFO,
//   and the firmware drains them into XB(0x08FC..0x0AFB) = ring[0..519]:
//
//     ring[0]      : 0x09 (the OS-prepended report ID; firmware ignores it
//                    for dispatch but the IN status echo reflects it back)
//     ring[1]      : 0x03                -> state-3 dispatch in func_7bcd
//                                          (read as XB(0x08FD))
//     ring[2]      : SLOTS[slot].ring2   -> selects slot_d/a/b/c flash writer
//                                          (read as XB(0x08FE))
//     ring[3..7]   : header padding (zero)
//     ring[8..519] : 512 bytes of keymap region content (read by the flash
//                    writer at offset 8 from the ring base)
//
//   The 519-byte buffer we hand to sendFeatureReport must be:
//     payload[0]    : 0x03   (state index — lands at ring[1] = XB(0x08FD))
//     payload[1]    : ring2  (sub-state — lands at ring[2] = XB(0x08FE))
//     payload[2..6] : 5 bytes of header padding
//     payload[7..518]: 512 bytes of keymap region (lands at ring[8..519])
//
// The previously-attempted 0x13-frame format (sub_type, sum8 checksum, 37
// segments, etc.) is the *wireless UART* protocol used between the BK3632
// dongle and the keyboard's BK3632 receiver. It is NOT the USB EP0 protocol
// and explained why earlier write attempts landed in the firmware staging
// buffer but never reached flash.
//
// WIN keymap regions (0xBE00 / 0xC600 / 0xCE00 / 0xD600) are not reachable
// from any external host protocol — only `func_14ba` writes them, and it's
// only invoked via the in-firmware factory-restore key-combo or a reset
// path. The keyboard's WIN/iOS slide switch selects which (factory-fixed)
// WIN regions or which (host-writable) iOS regions the runtime reads.

export const VENDOR_ID = 0x258a;
export const PRODUCT_ID = 0x019d;
export const REPORT_ID = 9;
// Vendor-defined HID Usage Page hosting Report 9. Filtering by this page is
// REQUIRED to bypass Chrome's keyboard HID blocklist on the device's other
// (standard-keyboard) collections.
export const VENDOR_USAGE_PAGE = 0xff02;
export const VENDOR_USAGE = 0x02;

export const REGION_BYTES = 512;
// Header bytes inside our 519-byte payload: state(1) + sub-state(1) + pad(5).
// The OS-prepended report ID adds an implicit 8th byte ahead of these on the
// wire — together those 8 bytes (1 report ID + 7 in-payload header) become
// ring[0..7]; the keymap region occupies ring[8..519] = 512 bytes.
export const HEADER_BYTES = 7;
export const REPORT_LEN_DECLARED = 519;
export const PAYLOAD_BYTES = REPORT_LEN_DECLARED;          // = HEADER_BYTES + REGION_BYTES

// XB(0x08FD) value that triggers the state-3 dispatcher in func_7bcd.
const STATE_KEYMAP_WRITE = 0x03;

// `ring2` is the byte at offset 2 of the payload (= XB(0x08FE)). It selects
// which of the four state-3 sub-handlers fires, which fixes the flash sector
// the write lands in:
//   ring2=0 -> func_94e8, sector 0x5E, flash 0xBC00 (layer 0 = factory Base)
//   ring2=1 -> func_9939, sector 0x62, flash 0xC400 (layer 1 = factory Fn)
//   ring2=2 -> func_99d3, sector 0x66, flash 0xCC00 (layer 2 = factory empty)
//   ring2=3 -> func_9588, sector 0x6A, flash 0xD400 (layer 3 = factory empty)
//
// All four are read by the keypress dispatcher (func_2bb8 / func_1bde set
// XB(0x0ED2) = layer index, then call func_435d to load from flash). Phantom
// Editor only writes ring2=0 (Base) and ring2=1 (Fn) — see LAYERS in app.js.
//
// **WIN vs iOS** — these four flash sectors are read by the runtime when the
// WIN/iOS slide switch is on **WIN** (verified empirically 2026-05-01:
// writing ring2=0 = 0xBC00 surfaced for a key press with the slide on WIN).
// On iOS the dispatcher reads from a parallel set at 0xBE00/0xC6/0xCE/0xD6
// which is NOT addressable from this protocol.

/**
 * Build the 519-byte SET_REPORT payload for one keymap-region write,
 * straight from the 113-action layer array.
 *
 * What the firmware sees in the ring buffer (with the OS-prepended 0x09):
 *   ring[0]      = 0x09        (report ID, OS-prepended)
 *   ring[1]      = 0x03        (state-3 dispatch — XB(0x08FD))
 *   ring[2]      = ring2       (sub-state — XB(0x08FE))
 *   ring[3..7]   = padding
 *   ring[8..519] = 512 bytes of keymap region (read by the flash writer)
 *
 * What sendFeatureReport actually transmits as the 519-byte data argument:
 *   payload[0]     = 0x03                 -> ring[1]
 *   payload[1]     = ring2                -> ring[2]
 *   payload[2..6]  = 5 bytes of zero pad  -> ring[3..7]
 *   payload[7..458]= 113 × 4 action bytes -> ring[8..459]
 *   payload[459..518] stays zero          -> ring[460..519]
 */
export function buildPayload(ring2, actions) {
  if (actions.length !== 113) {
    throw new Error(`expected 113 actions, got ${actions.length}`);
  }
  const buf = new Uint8Array(PAYLOAD_BYTES);
  buf[0] = STATE_KEYMAP_WRITE;
  buf[1] = ring2 & 0xff;
  // bytes 2..6 stay zero
  for (let i = 0; i < 113; i++) {
    const a = actions[i];
    buf[HEADER_BYTES + i*4 + 0] = a[0] & 0xff;
    buf[HEADER_BYTES + i*4 + 1] = a[1] & 0xff;
    buf[HEADER_BYTES + i*4 + 2] = a[2] & 0xff;
    buf[HEADER_BYTES + i*4 + 3] = a[3] & 0xff;
  }
  // tail bytes (payload[459..518]) stay zero — firmware leaves them unused;
  // factory ROM is also padded zero in that range.
  return buf;
}

/**
 * Send a keymap payload as one SET_REPORT FEATURE 9 control transfer.
 * Payload length must be exactly REPORT_LEN_DECLARED (519) — Chrome's
 * WebHID enforces the HID descriptor's declared report size and rejects
 * any other length (verified empirically in earlier debug session: 740 B
 * was rejected as oversize; 20 B as undersize).
 */
export async function sendKeymap(device, payload, onProgress) {
  if (!device.opened) await device.open();
  if (payload.length !== REPORT_LEN_DECLARED) {
    throw new Error(`payload must be ${REPORT_LEN_DECLARED} bytes, got ${payload.length}`);
  }
  if (onProgress) onProgress({ phase: 'sending', bytes: payload.length });
  await device.sendFeatureReport(REPORT_ID, payload);
  if (onProgress) onProgress({ phase: 'done', bytes: payload.length });
}

/** Request a connected keyboard via the WebHID picker. */
export async function requestKeyboard() {
  const filters = [
    { vendorId: VENDOR_ID, productId: PRODUCT_ID, usagePage: VENDOR_USAGE_PAGE, usage: VENDOR_USAGE },
    { vendorId: VENDOR_ID, productId: PRODUCT_ID, usagePage: VENDOR_USAGE_PAGE },
  ];
  const devices = await navigator.hid.requestDevice({ filters });
  if (!devices.length) return null;
  for (const d of devices) {
    if (deviceHasReport9Feature(d)) return d;
  }
  return devices[0];
}

export function deviceHasReport9Feature(device) {
  for (const c of device.collections || []) {
    for (const f of c.featureReports || []) {
      if (f.reportId === REPORT_ID) return true;
    }
    for (const child of c.children || []) {
      for (const f of child.featureReports || []) {
        if (f.reportId === REPORT_ID) return true;
      }
    }
  }
  return false;
}

/** Find an already-permitted device. Useful on page reload. */
export async function findGrantedKeyboard() {
  const ds = await navigator.hid.getDevices();
  for (const d of ds) {
    if (d.vendorId === VENDOR_ID && d.productId === PRODUCT_ID && deviceHasReport9Feature(d)) {
      return d;
    }
  }
  for (const d of ds) {
    if (deviceHasReport9Feature(d)) return d;
  }
  return null;
}
