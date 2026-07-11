"""
handlers/p10_d.py — Packet_0010_0D (перестройка базы) → Packet_0010_02 (OK)

Клиент шлёт family=16 sub=13 (0x0D) когда игрок выходит из режима редактора
с изменениями. Содержит массив PMove — новые позиции всех объектов базы.

PMove:
  PObjectId: u8 variance (0=bld,1=cannon,2=fence,3=decor,4=garbage) + u32 obj_id
  Position:  i16 x + i16 y

Сервер применяет все перемещения к base_state.json и возвращает 10x2 OK.
"""

import struct, os, sys, time

PROTOCOL_VERSION = 77
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

import state as _state

# PObjectId.variance → ключ в base_state
_CAT = {0: 'buildings', 1: 'cannons', 2: 'fences', 3: 'decors', 4: 'garbages'}


def _parse_moves(body: bytes) -> list:
    """Парсит тело 10x0D: u16 count + PMove[]."""
    moves = []
    try:
        pos = 8  # пропускаем заголовок
        count = struct.unpack_from('<H', body, pos)[0]; pos += 2
        for _ in range(count):
            var = body[pos]; pos += 1
            if var <= 4:  # известный тип
                obj_id = struct.unpack_from('<I', body, pos)[0]; pos += 4
                x = struct.unpack_from('<h', body, pos)[0]; pos += 2
                y = struct.unpack_from('<h', body, pos)[0]; pos += 2
                moves.append({'var': var, 'id': obj_id, 'x': x, 'y': y})
            else:
                # UNIT(5) или UNKNOWN(6) — нет u32 id, пропускаем Position
                pos += 4  # Position (i16 x + i16 y)
    except Exception as e:
        print(f'  [10xD] parse error: {e}')
    return moves


def _ok_10x2() -> bytes:
    payload  = struct.pack('<B', 0)           # variant=0 OK
    payload += struct.pack('<H', 0)           # 0 events
    payload += struct.pack('<d', time.time())
    return struct.pack('<HBBI', 16, 2, PROTOCOL_VERSION, len(payload)) + payload


def handle(body: bytes) -> bytes:
    moves = _parse_moves(body)
    print(f'  [10xD] перестройка базы: {len(moves)} перемещений')

    if not moves:
        return _ok_10x2()

    with _state.acquire_state_lock():
        player = _state.load_player()
        base   = _state.load_base(player)

        # Строим индексы: {cat: {id: obj}} для быстрого поиска
        idx = {}
        for cat in _CAT.values():
            idx[cat] = {o['id']: o for o in base.get(cat, [])}

        moved    = 0
        blocked  = 0
        occupied = set()  # позиции которые уже заняты ПОСЛЕ перестройки

        # Сначала собираем все NEW позиции чтобы проверять коллизии
        new_positions = {}  # obj_id → (x, y)
        for m in moves:
            new_positions[m['id']] = (m['x'], m['y'])

        # Проверяем коллизии между перемещаемыми объектами
        seen = {}
        for oid, pos in new_positions.items():
            if pos in seen:
                print(f'  [10xD] коллизия в перестройке: '
                      f'id={oid} и id={seen[pos]} на {pos}')
            seen[pos] = oid

        for m in moves:
            cat = _CAT.get(m['var'])
            if cat is None:
                continue
            obj = idx[cat].get(m['id'])
            if obj is None:
                print(f'  [10xD] объект id={m["id"]} ({cat}) не найден')
                continue
            old_pos = (obj.get('x'), obj.get('y'))
            obj['x'] = m['x']
            obj['y'] = m['y']
            if old_pos != (m['x'], m['y']):
                moved += 1

        _state.save_base(base)

    print(f'  [10xD] применено {moved} перемещений')
    return _ok_10x2()