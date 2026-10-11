// Device connect / save / reset flow. Owns the WebHID lifecycle and the
// localStorage cache that stands in for live flash readback (which is
// blocked because the keymap lives in MOVC-only CODE space — see
// firmware-c/docs/open-questions.md #2).

import { FACTORY_DEFAULTS } from './keymap-defaults.js';
import {
  buildPayload, sendKeymap,
  requestKeyboard, findGrantedKeyboard,
} from './protocol.js';
import {
  state, LAYERS, LAST_SAVED_KEY,
  cloneLayer, loadFactoryIntoState, isDirty,
} from './state.js';
import { $, setStatus } from './dom-utils.js';
import { renderKeyboard } from './render-keyboard.js';
import { renderEditor } from './render-editor.js';

export async function connect() {
  setStatus('Solicitando permissão…');
  let dev;
  try {
    dev = await requestKeyboard();
  } catch (e) {
    setStatus(`Erro no seletor: ${e.message}`, 'error');
    return;
  }
  if (!dev) { setStatus('Nenhum dispositivo selecionado', 'error'); return; }
  await openDevice(dev);
}

export async function autoconnect() {
  if (!('hid' in navigator)) {
    setStatus('WebHID não suportado. Use Chrome ou Edge.', 'error');
    return;
  }
  const dev = await findGrantedKeyboard();
  if (dev) await openDevice(dev);
}

async function openDevice(dev) {
  state.device = dev;
  try {
    if (!dev.opened) await dev.open();
  } catch (e) {
    setStatus(`Falha ao abrir: ${e.message}`, 'error');
    state.device = null;
    return;
  }
  // The device reports itself as "StarTec MKGP98 Keyboard" but the consumer
  // brand on the box is "SuperFrame Phantom" — surface the brand name only.
  setStatus('Conectado. Lendo configuração do teclado…', 'connected');
  $('#connect-btn').textContent = 'Reconectar';
  state.selectedIdx = null;
  // No live flash readback. Reason: this firmware reads the keymap via
  // MOVC (CODE space), not MOVX (XDATA), so GET_FEATURE Report 9 — which
  // streams XDATA — has no path to the keymap regions. See
  // firmware-c/docs/open-questions.md #2.
  //
  // Best we can do without readback: prefer the locally-cached "last saved
  // keymap" (we wrote it, so we know what's on the device) and fall back
  // to factory if there's no cache yet. Either way we show a banner
  // explaining the limitation.
  const cached = loadCachedKeymap();
  const banner = $('#readback-banner');
  if (cached) {
    state.factory.base = cloneLayer(cached.base);
    state.factory.fn   = cloneLayer(cached.fn);
    state.current.base = cloneLayer(state.factory.base);
    state.current.fn   = cloneLayer(state.factory.fn);
    if (banner) {
      banner.hidden = false;
      banner.classList.add('cached');
      banner.classList.remove('factory');
    }
  } else {
    loadFactoryIntoState();
    if (banner) {
      banner.hidden = false;
      banner.classList.add('factory');
      banner.classList.remove('cached');
    }
  }
  setStatus('Conectado: Teclado SuperFrame Phantom', 'connected');
  renderKeyboard();
  renderEditor();
}

function loadCachedKeymap() {
  try {
    const raw = localStorage.getItem(LAST_SAVED_KEY);
    if (!raw) return null;
    const obj = JSON.parse(raw);
    if (!Array.isArray(obj.base) || !Array.isArray(obj.fn)) return null;
    if (obj.base.length !== 113 || obj.fn.length !== 113) return null;
    return obj;
  } catch (e) {
    return null;
  }
}

function saveCachedKeymap(base, fn) {
  try {
    localStorage.setItem(LAST_SAVED_KEY, JSON.stringify({ base, fn, savedAt: Date.now() }));
  } catch (e) {
    // localStorage might be disabled / full — non-fatal.
  }
}

export async function save() {
  if (!state.device) return;
  const saveBtn = $('#save-btn');
  saveBtn.disabled = true;
  setStatus('Salvando…');
  try {
    for (const layer of LAYERS) {
      // Skip layers with no changes.
      const dirty = state.current[layer.id].some((a, i) => {
        const f = state.factory[layer.id][i];
        return a[0] !== f[0] || a[1] !== f[1] || a[2] !== f[2] || a[3] !== f[3];
      });
      if (!dirty) continue;
      const payload = buildPayload(layer.ring2, state.current[layer.id]);
      await sendKeymap(state.device, payload);
      // Brief pause between writes — flash erase+program takes a few ms and
      // setting up two writes back-to-back can collide on the radio-reinit
      // cookie path. Empirically 100 ms is plenty.
      await new Promise(r => setTimeout(r, 100));
    }
    // After a successful save the new state IS the new "factory" baseline
    // for revert purposes — accept the change and clear dirty tracking.
    state.factory.base = cloneLayer(state.current.base);
    state.factory.fn   = cloneLayer(state.current.fn);
    // Persist what we just wrote, so reconnects can use it as the working
    // baseline (we have no live readback — see openDevice for context).
    saveCachedKeymap(state.factory.base, state.factory.fn);
    const banner = $('#readback-banner');
    if (banner) {
      banner.hidden = false;
      banner.classList.add('cached');
      banner.classList.remove('factory');
    }
    setStatus('Salvo.', 'connected');
    renderKeyboard();
    renderEditor();
  } catch (e) {
    console.error(e);
    setStatus(`Falha ao salvar: ${e.message}`, 'error');
  } finally {
    saveBtn.disabled = !isDirty();
  }
}

export function resetToFactory() {
  if (!state.current.base) return;
  if (!confirm('Descartar todas as alterações não salvas e recarregar os padrões de fábrica?')) return;
  // Reload from the bundled FACTORY_DEFAULTS — this discards both the
  // user's pending edits AND any prior saves we'd accepted as the new
  // baseline during this session.
  state.factory.base = cloneLayer(FACTORY_DEFAULTS.base);
  state.factory.fn   = cloneLayer(FACTORY_DEFAULTS.fn);
  state.current.base = cloneLayer(state.factory.base);
  state.current.fn   = cloneLayer(state.factory.fn);
  renderKeyboard();
  renderEditor();
  setStatus('Restaurado para padrão de fábrica.', 'connected');
}
