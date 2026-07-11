"""
handlers/p10_5.py  —  Packet_0010_05 → Packet_0010_06

Клиент отправляет id соперника (fight_id из 10x4 ИЛИ uid игрока в режиме getFriendMap)
и флаг is_mission.

Реальный сервер:
  - Если id = fight_id из 10x4: возвращает обновлённый PTargetInfo (на случай изменений)
  - Если id = user_id (getFriendMap): ищет базу этого игрока, возвращает PTargetInfo

Для нас единственный игрок — всегда возвращаем НАШ PTargetInfo.

Packet_0010_06.as:
  if (readUnsignedByte() == 1) { value = PTargetInfo.read(...) }
  else                         { value = null }  ← это ЛОМАЕТ игру!
"""
import struct, os, sys

PROTOCOL_VERSION = 77
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if BASE_DIR not in sys.path: sys.path.insert(0, BASE_DIR)
import state as _state

def _parse_10x5(body: bytes):
    try:
        pos = 8
        n   = struct.unpack('<H', body[pos:pos+2])[0]; pos += 2
        req_id     = body[pos:pos+n].decode('utf-8', errors='replace'); pos += n
        is_mission = bool(body[pos]) if pos < len(body) else False
        return req_id, is_mission
    except Exception as e:
        return f'parse_err:{e}', False

def handle(body: bytes) -> bytes:
    req_id, is_mission = _parse_10x5(body)
    short = req_id[:8] + '...' if len(req_id) > 8 else req_id
    print(f'  [10x5] id={short} mission={is_mission}')

    player = _state.load_player()
    base   = _state.load_base(player)

    # Убираем мусор от предыдущих сессий
    player.pop('_active_fight_id', None)

    # Используем переданный id как fight_id в ответе
    # (если это user_id — всё равно нормально, игра просто начнёт бой)
    ti = _state.build_target_info_bytes(player, base, fight_id=req_id)

    # has_value = 1 → PTargetInfo следует
    payload = struct.pack('<B', 1) + ti

    header = struct.pack('<HBBI', 16, 6, PROTOCOL_VERSION, len(payload))
    resp = header + payload
    print(f'  [10x5] → 10x6 {len(resp)} байт (PTargetInfo OK)')
    return resp