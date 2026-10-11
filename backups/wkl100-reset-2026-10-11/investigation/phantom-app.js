// Phantom Editor — entry point. Wires DOM events to the device-io flow
// and kicks off the first render. All real work lives in:
//   state.js         — shared editor state + dirty tracking
//   render-keyboard  — SVG keyboard render
//   render-editor    — right-pane layer tabs + picker
//   device-io        — WebHID connect / save / reset
//   dom-utils        — $, svgEl, escapeHtml, setStatus

import { KEYBOARD_W, KEYBOARD_H } from './keyboard-layout.js';
import { state } from './state.js';
import { $, setStatus } from './dom-utils.js';
import { renderKeyboard } from './render-keyboard.js';
import { renderEditor } from './render-editor.js';
import { connect, autoconnect, save, resetToFactory } from './device-io.js';

function init() {
  // Keyboard size flows from a single source — keyboard-layout.js exports
  // KEYBOARD_W / KEYBOARD_H. We mirror them as CSS custom props (used by
  // .keyboard's max-width / aspect-ratio) AND set the SVG viewBox to match,
  // so the layout module is the only place that defines the dimensions.
  document.documentElement.style.setProperty('--kb-w', KEYBOARD_W);
  document.documentElement.style.setProperty('--kb-h', KEYBOARD_H);
  $('#keyboard').setAttribute('viewBox', `0 0 ${KEYBOARD_W} ${KEYBOARD_H}`);

  $('#connect-btn').addEventListener('click', connect);
  $('#save-btn').addEventListener('click', save);
  $('#reset-btn').addEventListener('click', resetToFactory);

  if ('hid' in navigator) {
    navigator.hid.addEventListener('disconnect', e => {
      if (state.device === e.device) {
        state.device = null;
        setStatus('Desconectado', 'error');
        renderKeyboard();
      }
    });
  }

  renderKeyboard();
  renderEditor();
  autoconnect();
}

init();
