import http.server
import socketserver
import urllib.parse
import os
import struct
import importlib.util
import json
import traceback
from datetime import datetime

PORT           = 80
BASE_DIR       = os.path.abspath(os.path.dirname(__file__))
DUMPS_DIR      = os.path.join(BASE_DIR, 'dumps')
HANDLERS_DIR   = os.path.join(BASE_DIR, 'handlers')
LOG_FILE       = os.path.join(BASE_DIR, 'game.log')
ERROR_LOG_FILE = os.path.join(BASE_DIR, 'client_errors.log')
PROTOCOL_VERSION = 77

os.makedirs(DUMPS_DIR,    exist_ok=True)
os.makedirs(HANDLERS_DIR, exist_ok=True)

# ── Вспомогательное: Hex Dump ─────────────────────────────────────────────────
def _hex_snippet(data: bytes, max_len: int = 32) -> str:
    """Возвращает строку с hex-представлением первых max_len байт."""
    if not data:
        return "empty"
    snippet = data[:max_len]
    hex_str = " ".join(f"{b:02x}" for b in snippet)
    if len(data) > max_len:
        hex_str += " ..."
    return hex_str

# ── Кеш хендлеров: {handler_name: module} ────────────────────────────────────
_handler_cache: dict = {}

def _load_handler(name: str):
    if name in _handler_cache:
        return _handler_cache[name]

    path = os.path.join(HANDLERS_DIR, f'{name}.py')
    if not os.path.exists(path):
        return None

    try:
        spec   = importlib.util.spec_from_file_location(name, path)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        _handler_cache[name] = module
        print(f'[server] хендлер загружен и закеширован: {name}.py')
        return module
    except Exception as e:
        err_tb = traceback.format_exc()
        print(f'[server] ошибка загрузки хендлера {name}:\n{err_tb}')
        _log('SYS_ERR', 'load', 0, f'Ошибка загрузки {name}:\n{err_tb}')
        return None

def _proto_to_handler_name(proto: str) -> str | None:
    if not proto or 'x' not in proto:
        return None
    parts = proto.split('x', 1)
    return f'p{parts[0]}_{parts[1]}'

def _parse_header(data: bytes):
    if len(data) < 8:
        return None
    family, subfamily, version, length = struct.unpack('<HBBI', data[:8])
    return family, subfamily, version, length

# ── Счётчики дампов ───────────────────────────────────────────────────────────
_dump_counters: dict = {}
_request_counter: int = 0
_ALWAYS_FIRST = {'10x8', '80x1', '60x3b', '60x13', '10x2'}

def _get_dump(proto: str) -> bytes | None:
    if proto in _ALWAYS_FIRST:
        idx = 1
    else:
        idx = _dump_counters.get(proto, 1)

    path = os.path.join(DUMPS_DIR, f'{proto}_{idx}')
    if not os.path.exists(path):
        return None

    with open(path, 'rb') as f:
        data = f.read()

    if proto not in _ALWAYS_FIRST:
        _dump_counters[proto] = idx + 1

    print(f'[server] дамп {proto}_{idx} ({len(data)} байт)')
    return data

def _make_stub(proto: str) -> bytes:
    try:
        fam, sub = proto.split('x', 1)
        f = int(fam, 16) if any(c in fam for c in 'abcdef') else int(fam)
        s = int(sub, 16) if any(c in sub for c in 'abcdef') else int(sub)
    except Exception:
        f, s = 0, 0
    return struct.pack('<HBBI', f, s, PROTOCOL_VERSION, 0)

# ── Логирование ───────────────────────────────────────────────────────────────
def _log(tag: str, proto: str, size: int, info: str = '', details: str = ''):
    ts  = datetime.now().strftime('%H:%M:%S')
    row = f'[{ts}] {tag:<5} | {proto:<8} | {size:>6}b | {info}'
    print(row)
    if details:
        print(details) # Выводим детали в консоль
        
    try:
        with open(LOG_FILE, 'a', encoding='utf-8') as f:
            f.write(row + '\n')
            if details:
                f.write(details + '\n')
    except Exception:
        pass

# ── HTTP-обработчик ───────────────────────────────────────────────────────────
class GameHandler(http.server.SimpleHTTPRequestHandler):

    def log_message(self, fmt, *args):
        pass  # отключаем стандартный лог

    def translate_path(self, path):
        clean = urllib.parse.unquote(path.split('?')[0].split('#')[0]).lstrip('/')
        return os.path.join(BASE_DIR, clean or 'index.html')

    def _cors(self):
        self.send_header('Access-Control-Allow-Origin',  '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With')

    def do_OPTIONS(self):
        self.send_response(200)
        self._cors()
        self.end_headers()

    def do_GET(self):
        if self.path.rstrip('/') == '/debug':
            self._serve_debug()
            return

        full = self.translate_path(self.path)
        if os.path.isfile(full):
            size = os.path.getsize(full)
            ext  = os.path.splitext(full)[1].lower()
            ctype = {
                '.html': 'text/html', '.json': 'application/json',
                '.swf':  'application/x-shockwave-flash',
                '.js':   'application/javascript', '.png': 'image/png',
                '.jpg':  'image/jpeg', '.mp3': 'audio/mpeg',
                '.xml':  'application/xml', '.txt': 'text/plain',
            }.get(ext, 'application/octet-stream')

            self.send_response(200)
            self.send_header('Content-Type', ctype)
            self._cors()
            self.end_headers()
            with open(full, 'rb') as f:
                self.wfile.write(f.read())
            _log('GET', ext[1:] or 'file', size, os.path.basename(full))
        else:
            self.send_response(404)
            self._cors()
            self.end_headers()
            _log('GET', '404', 0, self.path)

    def do_POST(self):
        global _request_counter
        _request_counter += 1

        content_len = int(self.headers.get('Content-Length', '0'))
        body        = self.rfile.read(content_len)
        query       = urllib.parse.parse_qs(urllib.parse.urlsplit(self.path).query)
        proto       = query.get('proto', [''])[0].lower().strip()

        # ── Клиентские ошибки ─────────────────────────────────────────────
        if self.path.startswith('/client_errors') or self.path.startswith('/submit'):
            self._handle_client_error(body)
            resp_body = b'{"status":"ok"}'
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(resp_body)))
            self._cors()
            self.end_headers()
            self.wfile.write(resp_body)
            return

        # ── Парсим заголовок ──────────────────────────────────────────────
        hdr = _parse_header(body)
        if hdr:
            family, subfamily, version, _ = hdr
            if not proto:
                proto = f'{family:x}x{subfamily:x}'
        else:
            family = subfamily = 0

        # Детально логируем входящий пакет (HEX)
        hex_in = _hex_snippet(body, max_len=24)
        _log('IN', proto, len(body), 
             f'#{_request_counter}' + (f' ⚠ ver={version}' if hdr and version != PROTOCOL_VERSION else ''),
             details=f'      HEX IN:  {hex_in}')

        # ── Ищем хендлер ──────────────────────────────────────────────────
        response = b''
        handler_name = _proto_to_handler_name(proto)

        if handler_name:
            module = _load_handler(handler_name)
            if module and hasattr(module, 'handle'):
                try:
                    response = module.handle(body)
                    _log('HND', proto, len(response), handler_name)
                except Exception as e:
                    # ПОЛНЫЙ ТРЕЙСБЕК ОШИБКИ В ЛОГ!
                    err_tb = traceback.format_exc()
                    _log('ERR', proto, 0, f'{handler_name} crashed: {e}', details=f'      TRACEBACK:\n{err_tb}')

        # ── Fallback: дамп ────────────────────────────────────────────────
        if not response:
            response = _get_dump(proto)

        # ── Fallback: заглушка ────────────────────────────────────────────
        if not response:
            response = _make_stub(proto)
            _log('STUB', proto, len(response), 'нет хендлера и дампа')

        # ── Проверка размера пакета ───────────────────────────────────────
        if len(response) >= 8:
            declared = struct.unpack('<I', response[4:8])[0]
            actual   = len(response) - 8
            if declared != actual:
                _log('WARN', proto, len(response), f'размер заголовка {declared} ≠ факт {actual}')
            
            # Логируем HEX начала исходящего пакета
            hex_out = _hex_snippet(response, max_len=24)
            _log('OUT', proto, len(response), '', details=f'      HEX OUT: {hex_out}')
        else:
            _log('OUT', proto, len(response), 'Broken payload (too short)')

        self.send_response(200)
        self.send_header('Content-Type', 'application/octet-stream')
        self.send_header('Content-Length', str(len(response)))
        self._cors()
        self.end_headers()
        self.wfile.write(response)

    # ── Клиентские ошибки ─────────────────────────────────────────────────────
    def _handle_client_error(self, body: bytes):
        raw_text = body.decode('utf-8', errors='replace')
        try:
            data = json.loads(raw_text)
            data['_time'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            with open(ERROR_LOG_FILE, 'a', encoding='utf-8') as f:
                f.write(json.dumps(data, ensure_ascii=False) + '\n')
            exc = data.get('exception', '?')
            msg = str(data.get('data', ''))[:100] # Увеличил срез до 100
            _log('ERR', 'client', len(body), f'{exc}: {msg}')
        except Exception as e:
            # ЕСЛИ JSON КРИВОЙ — ЛОГИРУЕМ СЫРОЙ ТЕКСТ
            _log('ERR', 'client', len(body), f'JSON parse error: {e}', details=f'      RAW BODY:\n{raw_text}')
            with open(ERROR_LOG_FILE, 'a', encoding='utf-8') as f:
                f.write(f"--- RAW ERROR AT {datetime.now()} ---\n{raw_text}\n\n")

    # ── Debug-страница ────────────────────────────────────────────────────────
    def _serve_debug(self):
        cached = list(_handler_cache.keys())
        html = f"""<!doctype html>
<html><head><meta charset="utf-8">
<title>Server Debug</title>
<style>body{{font-family:monospace;background:#111;color:#ccc;padding:20px}}
h2{{color:#4af}}table{{border-collapse:collapse;width:100%}}
td,th{{border:1px solid #333;padding:4px 8px;text-align:left}}
th{{background:#1a1a2e;color:#4af}}</style>
</head><body>
<h2>⚙ Steampunk local server</h2>
<p>Запросов обработано: <b>{_request_counter}</b></p>
<p>Кешированные хендлеры ({len(cached)}): <b>{', '.join(cached) or 'нет'}</b></p>
<p>Счётчики дампов: <b>{_dump_counters}</b></p>
<h2>Хендлеры в handlers/</h2><ul>"""
        for f in sorted(os.listdir(HANDLERS_DIR)):
            if f.endswith('.py') and not f.startswith('_'):
                mark = ' ✓ (в кеше)' if f[:-3] in _handler_cache else ''
                html += f'<li>{f}{mark}</li>'
        html += '</ul></body></html>'

        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self._cors()
        self.end_headers()
        self.wfile.write(html.encode('utf-8'))

# ── Точка входа ───────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print('╔══════════════════════════════════════════╗')
    print('║      стимпериум — локальный сервер        ║')
    print('╚══════════════════════════════════════════╝')
    print(f'  Порт:        {PORT}')
    print(f'  Директория:  {BASE_DIR}')
    print(f'  Лог:         {LOG_FILE}')
    print(f'  Debug:       http://localhost:{PORT}/debug')
    print('  Хендлеры кешируются при первом вызове')
    print('─' * 60)

    with socketserver.TCPServer(('', PORT), GameHandler) as httpd:
        httpd.allow_reuse_address = True
        print(f"Сервер запущен на порту {PORT} (Single-threaded)")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print('\nСервер остановлен')