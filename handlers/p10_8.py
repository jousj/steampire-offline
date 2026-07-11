"""
handlers/p10_8.py  —  Packet_0010_08 (ping events) → Packet_0010_07

Клиент периодически пингует сервер за игровыми событиями.
Реальный сервер (из примера): 10 00 07 4d 02 00 00 00 00 00
= header(8) + u16(0) = 0 событий.

Packet_0010_07.as: value = Array(readUnsignedShort()) of PUserEvent
"""
import struct

PROTOCOL_VERSION = 77

def handle(body: bytes) -> bytes:
    # Пустой массив PUserEvent
    payload = struct.pack('<H', 0)   # count = 0
    header  = struct.pack('<HBBI', 16, 7, PROTOCOL_VERSION, len(payload))
    return header + payload