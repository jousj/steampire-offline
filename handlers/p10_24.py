"""
handlers/p10_24.py — Packet_0010_24 (PvP finish) → Packet_0010_02 (OK)

Клиент шлёт family=16 sub=36 (0x24) в двух случаях:
  1. Нормальное завершение — перед endWaitResult, после которого придёт 20x9
  2. Сдача — endWaitResult НЕ вызывается, 20x9 НЕ придёт НИКОГДА

Как отличить:
  - В player_state при начале боя (p2_1) пишем _active_fight_id
  - Если при 10x24 _active_fight_id есть — это сдача, снимаем рейтинг немедленно
  - 20x9 если всё же придёт (нормальное завершение) — проверит _surrender_rated
"""
import struct, time, os, sys, json

PROTOCOL_VERSION = 77
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
CFG_PATH = os.path.join(BASE_DIR, 'battle_config.json')

if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

import state as _state


def _cfg() -> dict:
    try:
        with open(CFG_PATH) as f: return json.load(f)
    except Exception: return {}


def _ok_10x2() -> bytes:
    payload  = struct.pack('<B', 0)
    payload += struct.pack('<H', 0)
    payload += struct.pack('<d', time.time())
    return struct.pack('<HBBI', 16, 2, PROTOCOL_VERSION, len(payload)) + payload


def handle(body: bytes) -> bytes:
    print('  [10x24] PvP финиш')

    with _state.acquire_state_lock():
        player   = _state.load_player()
        fight_id = player.pop('_active_fight_id', None)
        bot_lv   = int(player.pop('_active_fight_bot_lv', player.get('level', 1)))

        if fight_id:
            # _active_fight_id есть — сдача, 20x9 не придёт
            cfg      = _cfg()
            r        = cfg.get('ratio', {})
            dec_base = float(r.get('dec_base', 15))
            max_loss = int(r.get('max_loss',   50))

            old_ratio       = int(player.get('ratio', 1000))
            loss            = min(max_loss, round(dec_base))
            player['ratio'] = max(0, old_ratio - loss)
            # Флаг: если 20x9 всё же придёт — не трогать рейтинг повторно
            player['_surrender_rated'] = True

            print(f'  [10x24] СДАЧА: рейтинг {old_ratio} -{loss} → {player["ratio"]}'
                  f'  (бот lv{bot_lv})')
        else:
            # _active_fight_id уже очищен или не было — нормальный финиш
            # Рейтинг посчитает 20x9
            print('  [10x24] нормальный финиш, рейтинг ждём в 20x9')

        _state.save_player(player)

    return _ok_10x2()