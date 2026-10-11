// Hand-coded SuperFrame Phantom layout — 19.5 × 6.25 keyboard units.
//
// Per the layout brief: most keys are 1×1 (square). Function row sits above
// a 0.25u gap; rows 2-6 are flush vertically. Numpad sits to the right of
// the alpha block and aligns to the 19.5u right edge.
//
// Each cap declares its firmware idx directly (the index used by the
// keymap region's 4-byte action slot, 0..112). A few entries pass `null`
// for purely cosmetic decorations like the ⚡ knob — those render but
// aren't editable.
//
// Firmware idx layout (19 cols × 6 rows, column-major scan):
//   col 0  ESC,`,Tab,CapsLk,LShift,LCtrl
//   col 1  F1,1,Q,A,\|(NonUS),LGUI
//   col 2  F2,2,W,S,Z,LAlt
//   col 3  F3,3,E,D,X,—
//   col 4  F4,4,R,F,C,—
//   col 5  F5,5,T,G,V,Space
//   col 6  F6,6,Y,H,B,—
//   col 7  F7,7,U,J,N,—
//   col 8  F8,8,I,K,M,RAlt
//   col 9  F9,9,O,L,",",Fn
//   col 10 F10,0,P,Ç,".",RCtrl
//   col 11 F11,-,´`(HID 0x2F),~^(HID 0x34),/?(HID 0x87),—
//   col 12 F12,=,[{ª(HID 0x30),]}º(HID 0x31),—,—
//   col 13 Del,Bksp,—,Enter,RShift,Left
//   col 14 —,—,—,—,Up,Down
//   col 15 Ins,Num,NP7,NP4,NP1,Right
//   col 16 End,NP/,NP8,NP5,NP2,NP0
//   col 17 —,NP*,NP9,NP6,NP3,NP.
//   col 18 —,NP-,NP+,—,NP-Enter
// (PT-BR ABNT2 HID quirks called out on cols 11/12 because the keycap
//  legends only make sense once you know which HID code each emits.)
//
// ISO-Enter (main alpha Enter) is rendered as one L-shaped key — see the
// `path` on the cap in row 3.

// Helper: build one cap. Each shorthand cap is 1×1 by default.
//   shape : 'rect'   → simple rectangle (default), uses w × h with rounded corners
//           'path'   → custom SVG path (see `path` field), useful for the
//                      L-shaped ISO Enter
//           'circle' → centered circle for cosmetic decorations like the knob
//   path  : SVG path commands in keyboard-units, relative to (x, y).
//           Only used when shape === 'path'. The bounding box is still
//           (w, h) so the renderer knows how big the cap is for hit-testing
//           and label positioning.
const c = (idx, x, y, label, opts = {}) => ({
  idx: idx == null ? -1 : idx,
  x, y,
  w: opts.w ?? 1,
  h: opts.h ?? 1,
  label,
  cosmetic: idx == null,            // unmapped, render but disable edit
  shape: opts.shape || 'rect',
  path: opts.path || null,
});

// ────────────────────────────────────────────────────────────────────────
// Row 1 — function row (y = 0)
//   ESC  ( gap )  F1 F2 F3 F4  ( gap )  F5..F8  ( gap )  F9..F12
//   ( gap )  Del  ( gap )  Ins  End  ( gap )  ⚡ knob (cosmetic)
const row1 = [
  c(  0,  0,    0, 'ESC'),
  c(  6,  1.25, 0, 'F1'),  c( 12, 2.25, 0, 'F2'),  c( 18, 3.25, 0, 'F3'),  c( 24, 4.25, 0, 'F4'),
  c( 30,  5.5,  0, 'F5'),  c( 36, 6.5,  0, 'F6'),  c( 42, 7.5,  0, 'F7'),  c( 48, 8.5,  0, 'F8'),
  c( 54,  9.75, 0, 'F9'),  c( 60,10.75, 0, 'F10'), c( 66,11.75, 0, 'F11'), c( 72,12.75, 0, 'F12'),
  c( 78, 14,    0, 'Del'),
  c( 90, 15.5,  0, 'Ins'), c( 96, 16.5, 0, 'End'),
  c(null, 18.5, 0, '⚡', { shape: 'circle' }),                  // cosmetic knob
];

// ────────────────────────────────────────────────────────────────────────
// Row 2 — number row (y = 1.25)
//   '"  1 2 3 4 5 6 7 8 9 0  -_  =+   ( all 1×1 )   Backspace 2u
//   ( gap )  Num  /  *  -
const row2 = [
  c(  1,  0,    1.25, "' \""),                                  // ABNT2 apóstrofo / aspas
  c(  7,  1,    1.25, '1'),  c( 13, 2, 1.25, '2'),  c( 19, 3, 1.25, '3'),  c( 25, 4, 1.25, '4'),
  c( 31,  5,    1.25, '5'),  c( 37, 6, 1.25, '6'),  c( 43, 7, 1.25, '7'),  c( 49, 8, 1.25, '8'),
  c( 55,  9,    1.25, '9'),  c( 61,10, 1.25, '0'),
  c( 67, 11,    1.25, '- _'), c( 73, 12, 1.25, '= +'),
  c( 79, 13,    1.25, 'Backspace', { w: 2 }),                   // Backspace 2u
  c( 91, 15.5,  1.25, 'Num'),                                    // NumLock
  c( 97, 16.5,  1.25, '/'),
  c(103, 17.5,  1.25, '*'),
  c(109, 18.5,  1.25, '-'),
];

// ────────────────────────────────────────────────────────────────────────
// Row 3 — qwerty row (y = 2.25)
//   Tab 1.5u   Q W E R T Y U I O P  ´`  [{ª   ISO-Enter top 1.5u
//   ( gap )    7 8 9   + (1u × 2u)
const row3 = [
  c(  2,  0,    2.25, 'Tab', { w: 1.5 }),
  c(  8,  1.5,  2.25, 'Q'),  c( 14, 2.5, 2.25, 'W'),  c( 20, 3.5, 2.25, 'E'),  c( 26, 4.5, 2.25, 'R'),
  c( 32,  5.5,  2.25, 'T'),  c( 38, 6.5, 2.25, 'Y'),  c( 44, 7.5, 2.25, 'U'),  c( 50, 8.5, 2.25, 'I'),
  c( 56,  9.5,  2.25, 'O'),  c( 62,10.5, 2.25, 'P'),
  c( 68, 11.5,  2.25, '´ `'),                                    // dead-key acute/grave (ABNT2 HID 0x2F)
  c( 74, 12.5,  2.25, '[ { ª'),                                  // ABNT2 HID 0x30
  // ISO Enter is one L-shaped key spanning rows 3 and 4. Bounding box is
  // 1.5u × 2u; the path traces the L: full-width top, narrower bottom (the
  // bottom is 1.25u wide, offset 0.25u to the right of the top), with the
  // step's inner corner at (0.25u, 1u).
  c( 81, 13.5,  2.25, '↵', {
    w: 1.5, h: 2,
    shape: 'path',
    path: 'M 0.12 0 H 1.38 A 0.12 0.12 0 0 1 1.5 0.12 V 1.88 A 0.12 0.12 0 0 1 1.38 2 H 0.395 A 0.12 0.12 0 0 1 0.275 1.88 V 0.935 H 0.12 A 0.12 0.12 0 0 1 0 0.815 V 0.12 A 0.12 0.12 0 0 1 0.12 0 Z',
  }),
  c( 92, 15.5,  2.25, '7'),
  c( 98, 16.5,  2.25, '8'),
  c(104, 17.5,  2.25, '9'),
  c(110, 18.5,  2.25, '+', { h: 2 }),                            // numpad + spans rows 3-4
];

// ────────────────────────────────────────────────────────────────────────
// Row 4 — home row (y = 3.25)
//   CapsLk 1.75u   A S D F G H J K L  Çç  ~^  ]}º   ISO-Enter bottom 1.25u
//   ( gap )        4 5 6  ( + continues from row 3 )
const row4 = [
  c(  3,  0,    3.25, 'Caps Lock', { w: 1.75 }),
  c(  9,  1.75, 3.25, 'A'),  c( 15, 2.75, 3.25, 'S'),  c( 21, 3.75, 3.25, 'D'),  c( 27, 4.75, 3.25, 'F'),
  c( 33,  5.75, 3.25, 'G'),  c( 39, 6.75, 3.25, 'H'),  c( 45, 7.75, 3.25, 'J'),  c( 51, 8.75, 3.25, 'K'),
  c( 57,  9.75, 3.25, 'L'),
  c( 63, 10.75, 3.25, 'Ç'),
  c( 69, 11.75, 3.25, '~ ^'),                                    // ABNT2 HID 0x34
  c( 75, 12.75, 3.25, '] } º'),                                  // ABNT2 HID 0x31
  // ISO Enter (fwidx 81) is declared in row 3 as a single L-shaped key.
  c( 93, 15.5,  3.25, '4'),
  c( 99, 16.5,  3.25, '5'),
  c(105, 17.5,  3.25, '6'),
];

// ────────────────────────────────────────────────────────────────────────
// Row 5 — shift row (y = 4.25)
//   LShift 1.25u   \|°  Z X C V B N M  ,<  .>  /?°   RShift 1.75u
//   ( gap )  Up arrow  ( gap )   1 2 3   Numpad-Enter top (1×2u)
const row5 = [
  c(  4,  0,    4.25, '⇧', { w: 1.25 }),                         // LShift
  c( 10,  1.25, 4.25, '\\ |'),                                   // NonUS \ (HID 0x64) — ABNT2 não imprime ° aqui
  c( 16,  2.25, 4.25, 'Z'),  c( 22, 3.25, 4.25, 'X'),  c( 28, 4.25, 4.25, 'C'),
  c( 34,  5.25, 4.25, 'V'),  c( 40, 6.25, 4.25, 'B'),  c( 46, 7.25, 4.25, 'N'),
  c( 52,  8.25, 4.25, 'M'),
  c( 58,  9.25, 4.25, ', <'),
  c( 64, 10.25, 4.25, '. >'),
  c( 70, 11.25, 4.25, '/ ? °'),                                  // ABNT2 slash (HID 0x87)
  c( 82, 12.25, 4.25, '⇧', { w: 1.75 }),                         // RShift
  c( 88, 14.25, 4.5,  '↑'),                                      // Up
  c( 94, 15.5,  4.25, '1'),
  c(100, 16.5,  4.25, '2'),
  c(106, 17.5,  4.25, '3'),
  c(112, 18.5,  4.25, '↵', { h: 2 }),                            // numpad Enter spans rows 5-6
];

// ────────────────────────────────────────────────────────────────────────
// Row 6 — bottom row (y = 5.25)
//   Ctrl 1.25u   Win 1.25u   Alt 1.25u   Space 6.25u   AltGr  Fn  Ctrl
//   ( gap )      Left  Down  Right       ( gap )       0  .   ( Enter continues )
const row6 = [
  c(  5,  0,    5.25, 'Ctrl', { w: 1.25 }),                      // LCtrl
  c( 11,  1.25, 5.25, 'Win',  { w: 1.25 }),                      // LGUI / Win
  c( 17,  2.5,  5.25, 'Alt',  { w: 1.25 }),                      // LAlt
  c( 35,  3.75, 5.25, 'Espaço', { w: 6.25 }),
  c( 53, 10,    5.25, 'AltGr'),                                  // RAlt
  c( 59, 11,    5.25, 'Fn'),                                     // Fn
  c( 65, 12,    5.25, 'Ctrl'),                                   // RCtrl
  c( 83, 13.25, 5.5,  '←'),                                      // Left
  c( 89, 14.25, 5.5,  '↓'),                                      // Down
  c( 95, 15.25, 5.5,  '→'),                                      // Right
  c(101, 16.5,  5.25, '0'),                                      // numpad 0
  c(107, 17.5,  5.25, '.'),                                      // numpad .
  // (numpad Enter continues from row 5 — no separate cap on row 6)
];

export const KEYBOARD_KEYS = [
  ...row1, ...row2, ...row3, ...row4, ...row5, ...row6,
];

// Rendered viewBox dimensions. Content bounds are 19.5 × 6.25, but the
// viewBox keeps an extra 0.25u of breathing room at the bottom so cap
// strokes/shadows don't clip against the SVG edge.
export const KEYBOARD_W = 19.5;
export const KEYBOARD_H = 6.5;
