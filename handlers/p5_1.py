"""
лучше не трогать
"""
import struct
import os
import sys

PROTOCOL_VERSION = 77
BASE_DIR  = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
DUMPS_DIR = os.path.join(BASE_DIR, 'dumps')
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

import state as _state


def handle(body: bytes) -> bytes:
    dump_path = os.path.join(DUMPS_DIR, '5x1_1')
    if not os.path.exists(dump_path):
        print('  [CRITICAL] нет дампа 5x1_1! запусти bootstrap_research.py')
        return struct.pack('<HBBI', 5, 2, PROTOCOL_VERSION, 0)

    with open(dump_path, 'rb') as f:
        dump = f.read()

    with _state.acquire_state_lock():
        player = _state.load_player()
        # КРИТИЧЕСКИ ВАЖНО: загружаем базу с передачей player,
        # чтобы синхронизировать unit_levels с уже построенными казармами
        # и завершить офлайн-прогресс.
        base = _state.load_base(player)

    # patch_5x2 патчит:
    #   1. units_levels[] (уровни юнитов) из player["unit_levels"]
    #   2. gold/crystal/oil из player_state.json
    try:
        patched = _state.patch_5x2(dump, player)
    except Exception as e:
        import traceback
        print(f'  [5x1] patch_5x2 error: {e}')
        traceback.print_exc()
        patched = dump

    _, _, _, plen = struct.unpack('<HBBI', patched[:8])
    print(f'  [5x1] -> 5x2 payload={plen:,}b | '
          f'gold={player.get("gold",0):,} '
          f'crystal={player.get("crystal",0):,} '
          f'oil={player.get("oil",0):,}')
    return patched