"""
bootstrap_base.py
Запустить ОДИН РАЗ: извлекает ТОЛЬКО начальное состояние базы
из дампа dumps/2x1_1 и сохраняет в base_state.json.
(Профиль игрока не затрагивается, чтобы не затирать player_state.json).
"""

import struct
import json
import os
import sys

BASE_DIR   = os.path.abspath(os.path.dirname(__file__))
DUMPS_DIR  = os.path.join(BASE_DIR, 'dumps')
DUMP_2X2   = os.path.join(DUMPS_DIR, '2x1_1')
BASE_JSON  = os.path.join(BASE_DIR, 'base_state.json')


# ── Reader ────────────────────────────────────────────────────────────────────

class Reader:
    def __init__(self, data: bytes, pos: int = 0):
        self._d = data
        self._p = pos

    @property
    def pos(self) -> int:
        return self._p

    def _r(self, n: int) -> bytes:
        if self._p + n > len(self._d):
            raise EOFError(f'Need {n} @ 0x{self._p:X}, have {len(self._d)-self._p}')
        b = self._d[self._p:self._p + n]
        self._p += n
        return b

    def u8(self)  -> int:   return struct.unpack('<B', self._r(1))[0]
    def bool_(self) -> bool: return self.u8() != 0
    def i16(self) -> int:   return struct.unpack('<h', self._r(2))[0]
    def u16(self) -> int:   return struct.unpack('<H', self._r(2))[0]
    def i32(self) -> int:   return struct.unpack('<i', self._r(4))[0]
    def u32(self) -> int:   return struct.unpack('<I', self._r(4))[0]
    def f64(self) -> float: return struct.unpack('<d', self._r(8))[0]
    def utf(self) -> str:
        n = struct.unpack('<H', self._r(2))[0]   # LE length
        return self._r(n).decode('utf-8', errors='replace')


# ── Пропуск полного PUser ─────────────────────────────────────────────────────

def skip_puser(r: Reader) -> tuple:
    """Пропускает PUser, возвращает (gold, crystal, oil, exp)."""
    # PUserBase
    r.utf()   # user_id
    r.utf()   # name
    r.utf()   # avatar
    r.utf()   # profile_url
    r.u16()   # level
    r.utf()   # sex
    exp = r.i32()
    r.utf()   # avatar_small
    r.utf()   # avatar_big
    r.u32()   # ratio
    for _ in range(r.u16()): r.utf(); r.u32()          # units[]
    for _ in range(r.u16()): r.utf(); r.i32()          # units_levels[]
    for _ in range(r.u16()):                            # heroes[]
        r.utf(); r.u32(); r.f64(); r.u32(); r.u32(); r.u32(); r.u32()
    if r.u8() == 1:                                     # opt clan
        r.utf(); r.utf(); r.utf(); r.i32(); r.u8()
        r.f64(); r.f64(); r.f64()
        for _ in range(r.u16()): r.utf()                # units_can_buy[]
        r.f64()
    r.u32()   # th_level
    r.utf()   # account_id
    r.utf()   # snetwork
    r.f64()   # scouting
    if r.u8() == 1: r.i32(); r.i32()                    # opt clan_points
    # PUser fields
    gold    = r.u32()
    crystal = r.u32()
    oil     = r.u32()
    r.u32()  # hglory
    for _ in range(r.u16()):                            # quests[]
        r.utf()
        for _ in range(r.u8()):
            v = r.u8()
            if v == 0: r.u32()
    for _ in range(r.u16()): r.utf()                    # quests_closed[]
    r.utf()                                             # stage
    for _ in range(r.u16()): r.utf()                    # win_missions[]
    for _ in range(r.u16()): r.utf(); r.f64(); r.utf() # ext_missions[]
    r.bool_()                                           # admin_units_mode
    for _ in range(r.u16()): r.utf(); r.utf()          # stories[]
    for _ in range(r.u16()):                            # fight_hist[]
        r.utf(); r.f64(); r.utf(); r.i32(); r.i32()
        for _ in range(r.u16()):
            v = r.u8()
            if v <= 5: r.u32()
            elif v == 10: pass
            else: r.i32()
        r.i32(); r.bool_(); r.i32()
        for _ in range(r.u16()): r.utf(); r.u32()
        for _ in range(r.u16()): r.utf(); r.u32()
        r.bool_(); r.bool_()
        for _ in range(r.u16()): r.utf(); r.i32()
        r.bool_()
        if r.u8() == 1: r.utf(); r.utf()               # opt phf_clan
        for _ in range(r.u16()): r.utf(); r.u32()
        r.utf(); r.utf(); r.bool_(); r.utf()
    r.f64()   # call_lat
    r.u32()   # call
    r.u32()   # facts
    r.u8(); r.u8(); r.bool_(); r.u32(); r.bool_()      # settings_game
    r.utf()   # last_readed_news
    r.i32()   # clan_calls
    r.f64()   # clan_calls_time
    r.f64()   # read_chat_time
    r.i32(); r.i32(); r.i32()                          # red_ore green_ore blue_ore
    for _ in range(r.u16()): r.utf(); r.f64()          # raid_cooldowns[]
    for _ in range(r.u16()):                            # requests[]
        r.utf(); r.utf(); r.u32(); r.f64()
        v = r.u8()
        if v in (0, 1): r.u32()
        r.bool_()
        av = r.u8()
        if av == 0: r.f64()
        elif av == 1: r.i32()
    r.u8()                                              # group_id
    for _ in range(r.u16()): r.utf()                    # request_list[]
    r.f64()                                             # request_time
    for _ in range(r.u16()): r.utf(); r.f64(); r.bool_() # offers[]
    for _ in range(r.u16()): r.utf()                    # shop_unwatched[]
    for _ in range(r.u16()): r.utf(); r.u32()          # last_units[]
    mithril   = r.i32()
    blueprint = r.i32()
    for _ in range(r.u16()): r.i32()                    # divisions_reward[]
    for _ in range(r.u16()): r.utf()                    # spells[]
    for _ in range(r.u16()): r.utf(); r.utf()          # client_custom_data[]
    for _ in range(r.u16()):                            # jaina_events[]
        r.i32(); r.i32(); r.bool_(); r.i32(); r.f64()
    r.i32()   # jglory
    r.i32()   # rar_dragon
    for _ in range(r.u16()): r.i32(); r.i32(); r.i32() # adventures[]
    if r.u8() == 1:                                     # opt current_adventure
        r.i32(); r.f64()
        if r.u8() == 1: r.i32()
        r.i32(); r.i32(); r.bool_()
    if r.u8() == 1: r.i32(); r.f64(); r.i32(); r.bool_() # opt subscription
    r.i32()   # ruby
    return gold, crystal, oil, exp, mithril


# ── Чтение PCost ──────────────────────────────────────────────────────────────

def read_pcost(r: Reader) -> dict:
    v = r.u8()
    if v == 10:
        return {'type': v, 'value': None}
    val = r.u32() if v <= 5 else r.i32()
    return {'type': v, 'value': val}


# ── Чтение PUm ────────────────────────────────────────────────────────────────

def read_pum(r: Reader) -> dict:
    init_time = r.f64()
    obj_id    = r.u32()
    buildings = []
    cannons   = []
    fences    = []
    decors    = []
    garbages  = []

    # buildings
    for _ in range(r.u16()):
        b = {}
        b['id']    = r.u32()
        b['kind']  = r.utf()
        b['level'] = r.u16()    # u16 для зданий!
        b['x']     = r.i16()
        b['y']     = r.i16()
        vs = r.u8()
        b['state'] = 'in_progress' if vs == 1 else 'finished'
        b['finish_time'] = r.f64() if vs == 1 else None
        # PBuildingSpec
        sv = r.u8()
        SPEC_NAMES = {0:'townhall',1:'worker',2:'barrack',3:'camp',
                      4:'resource',5:'storage',6:'pylon',7:'research',
                      8:'clan_center',9:'hero',10:'guard',11:'raid',
                      12:'library',13:'shield',14:'scouting',15:'unknown'}
        spec = {'type': SPEC_NAMES.get(sv, f'spec_{sv}')}
        if sv == 4:   # RESOURCE: double + uint
            spec['last_apply_time'] = r.f64()
            spec['done_count']      = r.u32()
        elif sv == 7: # RESEARCH: opt PResearch
            if r.u8() == 1:
                spec['unit_kind']   = r.utf()
                spec['start_time']  = r.f64()
        elif sv == 8: # CLAN_CENTER
            if r.u8() == 1:
                spec['lat'] = r.f64()
            else:
                spec['lat'] = None
            spec['resources'] = [read_pcost(r) for _ in range(r.u16())]
        elif sv == 10: # GUARD
            spec['config'] = [{'kind': r.utf(), 'count': r.u32()} for _ in range(r.u16())]
            spec['count']  = r.u8()
        elif sv == 13: # SHIELD
            spec['shield_time'] = r.f64()
        b['spec'] = spec
        buildings.append(b)

    # cannons
    for _ in range(r.u16()):
        c = {}
        c['id']    = r.u32()
        c['kind']  = r.utf()
        c['level'] = r.u8()     # u8 для пушек!
        c['x']     = r.i16()
        c['y']     = r.i16()
        vs = r.u8()
        c['state'] = 'in_progress' if vs == 1 else 'finished'
        c['finish_time'] = r.f64() if vs == 1 else None
        cannons.append(c)

    # fences
    for _ in range(r.u16()):
        f = {}
        f['id']    = r.u32()
        f['kind']  = r.utf()
        f['level'] = r.u8()
        f['x']     = r.i16()
        f['y']     = r.i16()
        fences.append(f)

    # decors
    for _ in range(r.u16()):
        d = {}
        d['id']   = r.u32()
        d['kind'] = r.utf()
        d['x']    = r.i16()
        d['y']    = r.i16()
        decors.append(d)

    # garbages
    for _ in range(r.u16()):
        g = {}
        g['id']   = r.u32()
        g['kind'] = r.utf()
        g['x']    = r.i16()
        g['y']    = r.i16()
        if r.u8() == 1:
            g['removing']     = True
            g['start_remove'] = r.f64()
        else:
            g['removing']     = False
            g['start_remove'] = None
        g['prize'] = read_pcost(r)
        garbages.append(g)

    return {
        'init_time':          init_time,
        'object_id_counter':  obj_id,
        'buildings':          buildings,
        'cannons':            cannons,
        'fences':             fences,
        'decors':             decors,
        'garbages':           garbages,
    }


# ── Главная функция ───────────────────────────────────────────────────────────

def main():
    if not os.path.exists(DUMP_2X2):
        print(f'[bootstrap] Дамп не найден: {DUMP_2X2}')
        sys.exit(1)

    if os.path.exists(BASE_JSON):
        ans = input('[bootstrap] JSON базы уже существует. Перезаписать? (y/N): ').strip().lower()
        if ans != 'y':
            print('[bootstrap] Отменено.')
            sys.exit(0)

    with open(DUMP_2X2, 'rb') as f:
        data = f.read()

    print(f'[bootstrap] Читаю {os.path.basename(DUMP_2X2)} ({len(data):,} байт)...')

    r = Reader(data, 9)   # 8 заголовок + 1 variance(LOCATION=0)

    # PGetLocationAnswer = PUser + PLocation
    # Пропускаем PUser, нам нужны только данные базы (PUm)
    skip_puser(r)

    loc_v = r.u8()
    if loc_v != 1:
        print(f'[bootstrap] Ожидалась HOME(1), получен variant={loc_v}')
        sys.exit(1)

    pum = read_pum(r)

    # Собираем base_state.json
    base_state = {
        'object_id_counter': pum['object_id_counter'],
        'buildings':  pum['buildings'],
        'cannons':    pum['cannons'],
        'fences':     pum['fences'],
        'decors':     pum['decors'],
        'garbages':   pum['garbages'],
    }

    with open(BASE_JSON, 'w', encoding='utf-8') as f:
        json.dump(base_state, f, indent=2, ensure_ascii=False)

    print(f'[bootstrap] Записан {BASE_JSON}')
    print(f'  зданий={len(pum["buildings"])} пушек={len(pum["cannons"])} '
          f'заборов={len(pum["fences"])} мусора={len(pum["garbages"])}')
    print('[bootstrap] Готово. Теперь server.py использует этот JSON для базы.')


if __name__ == '__main__':
    main()