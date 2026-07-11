"""
handlers/p5_7.py — Packet_0005_07 (сохранение настроек игры).

Клиент отправляет PSettingsGame:
  u8   sg_sound         (0-100)
  u8   sg_music         (0-100)
  bool sg_low_quality
  u32  sg_scale         (масштаб × 100: 75 = 75%)
  bool sg_in_game_alerts

Сохраняем в player_state.json['settings'].
Ответ — Packet_0005_08: пустой пакет подтверждения.
"""

import struct
import os
import sys

PROTOCOL_VERSION = 77
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

import state as _state


def _parse_settings(body: bytes) -> dict | None:
    """
    Парсит PSettingsGame из тела пакета (после 8-байтного заголовка).
    PSettingsGame: u8 + u8 + bool(u8) + u32 + bool(u8) = 8 байт минимум.
    """
    if len(body) < 16:   # 8 заголовок + 8 payload
        return None
    try:
        pos = 8
        sg_sound          = body[pos];     pos += 1
        sg_music          = body[pos];     pos += 1
        sg_low_quality    = bool(body[pos]); pos += 1
        sg_scale          = struct.unpack('<I', body[pos:pos+4])[0]; pos += 4
        sg_in_game_alerts = bool(body[pos]) if pos < len(body) else False
        return {
            'sg_sound':          sg_sound,
            'sg_music':          sg_music,
            'sg_low_quality':    sg_low_quality,
            'sg_scale':          sg_scale,
            'sg_in_game_alerts': sg_in_game_alerts,
        }
    except Exception as e:
        print(f'  [5x7] Ошибка парсинга: {e}')
        return None


def handle(body: bytes) -> bytes:
    settings = _parse_settings(body)

    if settings:
        scale_pct = settings['sg_scale']
        print(f'  [5x7] Настройки: sound={settings["sg_sound"]} '
              f'music={settings["sg_music"]} '
              f'lowq={settings["sg_low_quality"]} '
              f'scale={scale_pct}%')

        # Атомарный read-modify-write под локом — не перезатираем остальные данные
        with _state.acquire_state_lock():
            player = _state.load_player()
            player['settings'] = settings
            _state.save_player(player)
    else:
        print('  [5x7] Пакет слишком короткий или повреждён — настройки не сохранены')

    # Packet_0005_08: подтверждение (пустой payload)
    header = struct.pack('<HBBI', 5, 8, PROTOCOL_VERSION, 0)
    return header