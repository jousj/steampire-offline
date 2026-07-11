"""
handlers/p10_3.py  —  Packet_0010_03 (PFightKind) → Packet_0010_04 (PFightRequestResult)

10x4 = PFightRequestResult.variant=0 (FIGHT) + PTargetInfo
"""
import struct, uuid, os, sys

PROTOCOL_VERSION = 77
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if BASE_DIR not in sys.path: sys.path.insert(0, BASE_DIR)
import state as _state

_FIGHT_VARIANTS = {0:'MISSION', 1:'EXT_MISSION', 2:'RAID', 3:'JAINA', 4:'ADVENTURE'}

def _parse_fight_kind(body):
    if len(body) < 9: return 'UNKNOWN', None
    pos = 8; v = body[pos]; pos += 1
    name = _FIGHT_VARIANTS.get(v, f'variant_{v}')
    val = None
    if v in (0, 1, 2) and pos + 2 <= len(body):
        n = struct.unpack('<H', body[pos:pos+2])[0]; pos += 2
        if pos + n <= len(body):
            val = body[pos:pos+n].decode('utf-8', errors='replace')
    return name, val

def handle(body: bytes) -> bytes:
    kind_name, target = _parse_fight_kind(body)
    print(f'  [10x3] PFightKind={kind_name} target={target!r}')

    player = _state.load_player()
    base   = _state.load_base(player)
    fight_id = str(uuid.uuid4())

    troops_s = ', '.join(f'{k}×{v}' for k,v in player.get('troops',{}).items() if int(v)>0) or 'пусто'
    print(f'  [10x3] войска: {troops_s} | fight_id={fight_id[:8]}...')

    ti      = _state.build_target_info_bytes(player, base, fight_id)
    payload = struct.pack('<B', 0) + ti   # PFightRequestResult.variant=0

    header = struct.pack('<HBBI', 16, 4, PROTOCOL_VERSION, len(payload))
    resp = header + payload
    print(f'  [10x3] → 10x4 {len(resp)} байт')
    return resp