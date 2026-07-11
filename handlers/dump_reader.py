"""
много вайбкода
"""

import struct, sys, os, re, math, random, datetime
from typing import Optional

# ══════════════════════════════════════════════════════════════
#  READER  (точная копия AS3 IDataInput, Endian.LITTLE_ENDIAN)
#  Исключение: readUTF — длина Big-Endian (стандарт Java/Flash AMF)
# ══════════════════════════════════════════════════════════════

class Reader:
    def __init__(self, data: bytes, pos: int = 0):
        self._d   = data
        self._pos = pos

    @property
    def pos(self) -> int:
        return self._pos

    @property
    def remaining(self) -> int:
        return len(self._d) - self._pos

    def _read(self, n: int) -> bytes:
        if self._pos + n > len(self._d):
            raise EOFError(f"Need {n} bytes, have {self.remaining} (pos=0x{self._pos:X})")
        b = self._d[self._pos : self._pos + n]
        self._pos += n
        return b

    def u8(self)  -> int:   return struct.unpack('<B', self._read(1))[0]
    def bool_(self) -> bool: return self.u8() != 0
    def i16(self) -> int:   return struct.unpack('<h', self._read(2))[0]
    def u16(self) -> int:   return struct.unpack('<H', self._read(2))[0]
    def i32(self) -> int:   return struct.unpack('<i', self._read(4))[0]
    def u32(self) -> int:   return struct.unpack('<I', self._read(4))[0]
    def f64(self) -> float: return struct.unpack('<d', self._read(8))[0]

    def utf(self) -> str:
        # Flash ByteArray с Endian.LITTLE_ENDIAN — readUTF тоже LE!
        n = struct.unpack('<H', self._read(2))[0]
        return self._read(n).decode('utf-8', errors='replace')

    def array(self, n: int, reader_fn):
        return [reader_fn(self) for _ in range(n)]

    def opt_utf_array(self) -> list:
        return [self.utf() for _ in range(self.u16())]

    def opt(self, reader_fn):
        """Паттерн: if(readByte==1) read else null"""
        if self.u8() == 1:
            return reader_fn(self)
        return None


# ══════════════════════════════════════════════════════════════
#  ПРИМИТИВНЫЕ СТРУКТУРЫ
# ══════════════════════════════════════════════════════════════

def read_position(r: Reader) -> dict:
    """Position.read: readShort x + readShort y"""
    return {'x': r.i16(), 'y': r.i16()}

def read_kind_count(r: Reader) -> dict:
    """PKindCount: readUTF kind + readUnsignedInt count"""
    return {'kind': r.utf(), 'count': r.u32()}

def read_units_level(r: Reader) -> dict:
    """PUnitsLevel: readUTF kind + readInt level"""
    return {'kind': r.utf(), 'level': r.i32()}

def read_hero(r: Reader) -> dict:
    """PHero: UTF kind, uint stamina, double last_reg, uint×4 mods"""
    return {
        'kind':              r.utf(),
        'stamina':           r.u32(),
        'last_reg_time':     r.f64(),
        'stamina_mod_level': r.u32(),
        'armor_mod_level':   r.u32(),
        'damage_mod_level':  r.u32(),
        'recover_mod_level': r.u32(),
    }

def read_user_clan(r: Reader) -> dict:
    """PUserClan"""
    d = {
        'clan_id':          r.utf(),
        'name':             r.utf(),
        'icon':             r.utf(),
        'level':            r.i32(),
        'role':             r.u8(),   # PRole.variance
        'clan_calls_time':  r.f64(),
        'donate_oil':       r.f64(),
        'donate_crystal':   r.f64(),
        'units_can_buy':    r.opt_utf_array(),
        'donate_mithril':   r.f64(),
    }
    return d

def read_clan_points(r: Reader) -> dict:
    """PUsersClanPoints: int season_num + int points"""
    return {'season_num': r.i32(), 'points': r.i32()}

def read_pcost(r: Reader) -> dict:
    """PCost: 1 byte variance + conditional value"""
    v = r.u8()
    if v == 10:                         # UNKNOWN — нет payload
        return {'type': v, 'value': None}
    val = r.u32() if v <= 5 else r.i32()
    return {'type': v, 'value': val}

COST_NAMES = {0:'gold',1:'crystal',2:'oil',3:'exp',4:'hglory',5:'call',
              6:'red_ore',7:'green_ore',8:'blue_ore',9:'mithril',10:'?',
              11:'trophy',12:'blueprint',13:'jglory',14:'rar_dragon',
              15:'clan_points',16:'ruby'}

def read_phero_upgrade_kind(r: Reader) -> int:
    return r.u8()

def read_quest_target(r: Reader) -> dict:
    """PQuestTarget: 1 byte variance; if 0 → readUnsignedInt progress"""
    v = r.u8()
    val = r.u32() if v == 0 else None
    return {'state': 'open' if v == 0 else 'done', 'progress': val}

def read_quest(r: Reader) -> dict:
    """PQuest: UTF name + byte N + N×PQuestTarget"""
    n = r.utf()
    cnt = r.u8()
    return {'name': n, 'targets': [read_quest_target(r) for _ in range(cnt)]}

def read_ext_mission(r: Reader) -> dict:
    return {'kind': r.utf(), 'last_time': r.f64(), 'next_mission': r.utf()}

def read_str_str(r: Reader) -> dict:
    return {'key': r.utf(), 'value': r.utf()}

def read_hist_fight(r: Reader) -> dict:
    """PHistFight — полный"""
    d = {
        'id':          r.utf(),
        'time':        r.f64(),
        'name':        r.utf(),
        'level':       r.i32(),
        'ratio':       r.i32(),
        'steal_res':   [read_pcost(r) for _ in range(r.u16())],
        'change_ratio':r.i32(),
        'is_win':      r.bool_(),
        'percentage':  r.i32(),
        'units_in':    [read_kind_count(r) for _ in range(r.u16())],
        'units_died':  [read_kind_count(r) for _ in range(r.u16())],
        'revenge':     r.bool_(),
        'has_replay':  r.bool_(),
        'units_levels':[read_units_level(r) for _ in range(r.u16())],
        'read':        r.bool_(),
    }
    # opt PPhfClan
    if r.u8() == 1:
        d['clan'] = {'icon': r.utf(), 'name': r.utf()}
    else:
        d['clan'] = None
    d['spells']    = [read_kind_count(r) for _ in range(r.u16())]
    d['uid']       = r.utf()
    d['snetwork']  = r.utf()
    d['scouting']  = r.bool_()
    d['avatar']    = r.utf()
    return d

def read_settings_game(r: Reader) -> dict:
    """PSettingsGame: B B bool I bool"""
    return {
        'sound':          r.u8(),
        'music':          r.u8(),
        'low_quality':    r.bool_(),
        'scale':          r.u32(),
        'in_game_alerts': r.bool_(),
    }

def read_raid_cooldown(r: Reader) -> dict:
    return {'kind': r.utf(), 'end_time': r.f64()}

def read_ask_data(r: Reader) -> dict:
    v = r.u8()
    val = r.u32() if v in (0, 1) else None
    names = {0:'speed_up',1:'research',2:'crystal',3:'oil',4:'call',5:'?'}
    return {'type': names.get(v,'?'), 'value': val}

def read_ask_value(r: Reader) -> dict:
    v = r.u8()
    if v == 0:   val = r.f64()
    elif v == 1: val = r.i32()
    else:        val = None
    return {'type': {0:'time',1:'count',2:'?'}.get(v,'?'), 'value': val}

def read_pask(r: Reader) -> dict:
    return {
        'user_id':   r.utf(),
        'user_name': r.utf(),
        'level':     r.u32(),
        'time':      r.f64(),
        'ask_data':  read_ask_data(r),
        'is_help':   r.bool_(),
        'ask_value': read_ask_value(r),
    }

def read_offer(r: Reader) -> dict:
    return {'kind': r.utf(), 'start_time': r.f64(), 'is_gold': r.bool_()}

def read_jaina_event(r: Reader) -> dict:
    return {
        'mission':          r.i32(),
        'finished':         r.bool_(),
        'alive_objs':       r.i32(),
        'stamina_koef':     r.f64(),
    }

def read_adventure(r: Reader) -> dict:
    return {'event_id': r.i32(), 'current_mission': r.i32(), 'level': r.i32()}

def read_current_adventure(r: Reader) -> dict:
    d = {'event_id': r.i32(), 'start_time': r.f64()}
    d['alive_objs'] = r.i32() if r.u8() == 1 else None
    d['mission_num'] = r.i32()
    d['adventure_level'] = r.i32()
    d['jaina_finished'] = r.bool_()
    return d

def read_subscription(r: Reader) -> dict:
    return {'id': r.i32(), 'start_time': r.f64(),
            'subscription_id': r.i32(), 'canceled': r.bool_()}


# ══════════════════════════════════════════════════════════════
#  PUSERBASE + PUSER
# ══════════════════════════════════════════════════════════════

def read_user_base(r: Reader) -> dict:
    """PUserBase — полный"""
    d = {
        'user_id':     r.utf(),
        'name':        r.utf(),
        'avatar':      r.utf(),
        'profile_url': r.utf(),
        'level':       r.u16(),
        'sex':         r.utf(),
        'exp':         r.i32(),
        'avatar_small':r.utf(),
        'avatar_big':  r.utf(),
        'ratio':       r.u32(),
        'units':       [read_kind_count(r)  for _ in range(r.u16())],
        'units_levels':[read_units_level(r) for _ in range(r.u16())],
        'heroes':      [read_hero(r)        for _ in range(r.u16())],
    }
    # opt clan
    d['clan'] = read_user_clan(r) if r.u8() == 1 else None
    d['th_level']   = r.u32()
    d['account_id'] = r.utf()
    d['snetwork']   = r.utf()
    d['scouting']   = r.f64()
    # opt clan_points
    d['clan_points'] = read_clan_points(r) if r.u8() == 1 else None
    return d

def read_puser(r: Reader) -> dict:
    """PUser — полный, один к одному с AS3"""
    base = read_user_base(r)
    d = {
        'base':          base,
        'gold':          r.u32(),
        'crystal':       r.u32(),
        'oil':           r.u32(),
        'hglory':        r.u32(),
        'quests':       [read_quest(r)       for _ in range(r.u16())],
        'quests_closed': r.opt_utf_array(),
        'stage':         r.utf(),
        'win_missions':  r.opt_utf_array(),
        'ext_missions': [read_ext_mission(r) for _ in range(r.u16())],
        'admin_units_mode': r.bool_(),
        'stories':      [read_str_str(r)    for _ in range(r.u16())],
        'fight_hist':   [read_hist_fight(r) for _ in range(r.u16())],
        'call_lat':      r.f64(),
        'call':          r.u32(),
        'facts':         r.u32(),
        'settings_game': read_settings_game(r),
        'last_readed_news': r.utf(),
        'clan_calls':    r.i32(),
        'clan_calls_time':r.f64(),
        'read_chat_time':r.f64(),
        'red_ore':       r.i32(),
        'green_ore':     r.i32(),
        'blue_ore':      r.i32(),
        'raid_cooldowns':[read_raid_cooldown(r) for _ in range(r.u16())],
        'requests':     [read_pask(r)        for _ in range(r.u16())],
        'group_id':      r.u8(),
        'request_list':  r.opt_utf_array(),
        'request_time':  r.f64(),
        'offers':       [read_offer(r)       for _ in range(r.u16())],
        'shop_unwatched':r.opt_utf_array(),
        'last_units':   [read_kind_count(r)  for _ in range(r.u16())],
        'mithril':       r.i32(),
        'blue_print':    r.i32(),
        'divisions_reward': [r.i32()         for _ in range(r.u16())],
        'spells':        r.opt_utf_array(),
        'client_custom_data': [read_str_str(r) for _ in range(r.u16())],
        'jaina_events': [{'id': r.i32(), 'ev': read_jaina_event(r)}
                         for _ in range(r.u16())],
        'jglory':        r.i32(),
        'rar_dragon':    r.i32(),
        'adventures':   [read_adventure(r)   for _ in range(r.u16())],
    }
    d['current_adventure'] = r.opt(read_current_adventure)
    d['subscription']      = r.opt(read_subscription)
    d['ruby']              = r.i32()
    return d


# ══════════════════════════════════════════════════════════════
#  КАРТА БАЗЫ — PUm  (из Packet_0002_02 вариант HOME)
# ══════════════════════════════════════════════════════════════

def read_build_state(r: Reader) -> dict:
    """PBuildState: byte variance; if 1 (IN_PROGRESS) → double finish_time"""
    v = r.u8()
    finish = r.f64() if v == 1 else None
    return {'state': {0:'finished',1:'in_progress',2:'?'}.get(v,'?'),
            'finish_time': finish}

def read_building_spec(r: Reader) -> dict:
    """PBuildingSpec: byte variance + conditional payload"""
    v = r.u8()
    spec_types = {
        0:'townhall', 1:'worker', 2:'barrack', 3:'camp',
        4:'resource', 5:'storage', 6:'pylon', 7:'research',
        8:'clan_center', 9:'hero', 10:'guard', 11:'raid',
        12:'library', 13:'shield', 14:'scouting', 15:'?'
    }
    d = {'type': spec_types.get(v, f'spec_{v}')}

    if v == 4:    # RESOURCE: PResource (double last_apply + uint done_count)
        d['last_apply_time'] = r.f64()
        d['done_count']      = r.u32()
    elif v == 7:  # RESEARCH: opt PResearch
        if r.u8() == 1:
            d['unit_kind']   = r.utf()
            d['start_time']  = r.f64()
    elif v == 8:  # CLAN_CENTER: PClanCenter
        d['lat'] = r.f64() if r.u8() == 1 else None
        d['resources'] = [read_pcost(r) for _ in range(r.u16())]
    elif v == 10: # GUARD: PGuard
        d['config'] = [read_kind_count(r) for _ in range(r.u16())]
        d['count']  = r.u8()
    elif v == 13: # SHIELD: double
        d['shield_time'] = r.f64()
    # остальные: нет payload
    return d

def read_building(r: Reader) -> dict:
    """PBuilding: uint id + UTF kind + ushort level + Position + PBuildState + PBuildingSpec"""
    return {
        'id':     r.u32(),
        'kind':   r.utf(),
        'level':  r.u16(),
        'pos':    read_position(r),
        'state':  read_build_state(r),
        'spec':   read_building_spec(r),
    }

def read_cannon(r: Reader) -> dict:
    """PCannon: uint id + UTF kind + byte level + Position + PBuildState"""
    return {
        'id':    r.u32(),
        'kind':  r.utf(),
        'level': r.u8(),
        'pos':   read_position(r),
        'state': read_build_state(r),
    }

def read_fence(r: Reader) -> dict:
    """PFence: uint id + UTF kind + byte level + Position"""
    return {'id': r.u32(), 'kind': r.utf(), 'level': r.u8(), 'pos': read_position(r)}

def read_decor(r: Reader) -> dict:
    """PDecor: uint id + UTF kind + Position"""
    return {'id': r.u32(), 'kind': r.utf(), 'pos': read_position(r)}

def read_garbage(r: Reader) -> dict:
    """PGarbage: uint id + UTF kind + Position + opt double start_remove + PCost prize"""
    d = {'id': r.u32(), 'kind': r.utf(), 'pos': read_position(r)}
    d['start_remove'] = r.f64() if r.u8() == 1 else None
    d['prize'] = read_pcost(r)
    return d

def read_pum(r: Reader) -> dict:
    """PUm — карта базы со всеми объектами"""
    return {
        'init_time':  r.f64(),
        'object_id':  r.u32(),
        'buildings': [read_building(r) for _ in range(r.u16())],
        'cannons':   [read_cannon(r)   for _ in range(r.u16())],
        'fences':    [read_fence(r)    for _ in range(r.u16())],
        'decors':    [read_decor(r)    for _ in range(r.u16())],
        'garbages':  [read_garbage(r)  for _ in range(r.u16())],
    }


# ══════════════════════════════════════════════════════════════
#  ДЕТЕКТОР ТИПА ПАКЕТА + ТОЧКА ВХОДА ДЛЯ КАЖДОГО ФОРМАТА
# ══════════════════════════════════════════════════════════════

def detect_packet(data: bytes) -> str:
    """Читает заголовок и возвращает 'packet_5x2', 'packet_2x2', или 'unknown'"""
    if len(data) < 8:
        return 'unknown'
    family, sub, ver, _ = struct.unpack('<HBBI', data[:8])
    if family == 5  and sub == 2: return 'packet_5x2'
    if family == 2  and sub == 2: return 'packet_2x2'
    return 'unknown'

def find_puser_in_5x2(data: bytes) -> Optional[int]:
    """
    В 5x2 пакете PUser идёт ПОСЛЕ огромного PDict (600 КБ).
    PDict.write() не реализован, поэтому пропарсить его нельзя.
    Вместо этого ищем начало PUserBase по характерному паттерну:
      PUser начинается с PUserBase, который начинается с readUTF(user_id).
      user_id — UUID строка: 36 символов, паттерн [0-9a-f-]{36}
      в бинарном виде: [00 24] + 36 байт ASCII
    Берём ПОСЛЕДНЕЕ вхождение — оно и есть PUser (после PDict).
    """
    # $ = $ — спецсимвол regex; ищем UUID без prefix-байта
    uuid_re = re.compile(
        b'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
    )
    matches = list(uuid_re.finditer(data))
    if not matches:
        return None
    # Последнее вхождение — PUser.base.user_id (после PDict)
    # readUTF = 2 байта LE-length + строка → start = pos(UUID) - 2
    return matches[0].start() - 2  # user_id ПЕРВЫЙ UUID в обоих форматах

def parse_5x2(data: bytes) -> dict:
    """Парсит Packet_0005_02: пропускает PDict, читает PUser"""
    puser_start = find_puser_in_5x2(data)
    if puser_start is None:
        raise ValueError("Не удалось найти PUser в дампе 5x2")

    r = Reader(data, puser_start)
    user = read_puser(r)
    return {
        'packet_type': '5x2 (словарь + профиль)',
        'puser_offset': puser_start,
        'bytes_consumed_for_puser': r.pos - puser_start,
        'user': user,
    }

def parse_2x2(data: bytes) -> dict:
    """Парсит Packet_0002_02: заголовок → variance → PGetLocationAnswer"""
    r = Reader(data, 8)   # пропускаем 8-байтный заголовок

    variance = r.u8()
    variant_names = {0:'LOCATION',1:'STORM',2:'FIGHT',3:'TERRITORY_INFO',
                     4:'CLAN_TERRITORIES_ATTACK',5:'UNKNOWN'}

    result = {
        'packet_type': '2x2 (карта)',
        'response_variant': variant_names.get(variance, f'?{variance}'),
        'variant_id': variance,
    }

    if variance == 0:  # LOCATION — единственный интересный для нас вариант
        # PGetLocationAnswer = PUser + PLocation
        user  = read_puser(r)

        # PLocation: byte variance + payload
        loc_v = r.u8()
        loc_names = {0:'ATTACKED',1:'HOME',2:'GROUP',3:'BATTLE',
                     4:'STORM',5:'SIMULATION',6:'BOSS',7:'UNKNOWN'}
        result['location_variant'] = loc_names.get(loc_v, f'?{loc_v}')
        result['user'] = user

        if loc_v == 1:  # HOME → PHome = PUm + dt + shield? + clan? + requests[]
            um   = read_pum(r)
            dt   = r.f64()
            shield = r.f64() if r.u8() == 1 else None
            result['map']    = um
            result['dt']     = dt
            result['shield'] = shield
            # Не читаем clan и requests — они сложные и нам не нужны для отчёта
        else:
            result['note'] = f'Локация {result["location_variant"]} — не HOME, карта не парсится'
    else:
        result['note'] = f'Вариант {result["response_variant"]} — не LOCATION'

    return result


# ══════════════════════════════════════════════════════════════
#  КРАСИВЫЙ ВЫВОД
# ══════════════════════════════════════════════════════════════

W = 72   # ширина блока

def line(char='─'):       return char * W
def title(s):             return f"┌{'─'*(W-2)}┐\n│  {s:<{W-4}}│\n└{'─'*(W-2)}┘"
def section(s):           return f"\n╔{'═'*(W-2)}╗\n║  {s:<{W-4}}║\n╚{'═'*(W-2)}╝"
def sub(s):               return f"\n  ┌─ {s}"
def row(k, v, indent=4):  return f"{'':>{indent}}{k:<28} {v}"
def ts(f: float) -> str:
    if math.isnan(f) or f == 0: return '—'
    try: return datetime.datetime.fromtimestamp(f).strftime('%Y-%m-%d %H:%M:%S')
    except: return f'{f:.0f}'

ROLE_NAMES = {0:'Основатель',1:'Зам. основателя',2:'Старейшина',3:'Солдат',
              4:'Новичок',5:'Архитектор',6:'Ветеран',7:'Казначей',
              8:'Воевода',9:'—'}

BTYPE_EMOJI = {
    'bl_town_hall':'🏰','bl_barracks':'⚔️','bl_camp':'🏕️',
    'bl_oil_tower':'🛢️','bl_crystal_mine':'💎','bl_power_plant':'⚡',
    'bl_oil_storage':'🪣','bl_crystal_storage':'📦',
    'bl_library':'📚','bl_hero_workshop':'🦸','bl_portal':'🌀',
    'bl_clan_center':'🏛️','bl_guard_tower':'🗼','bl_scouting_hh':'🔭',
}
CANNON_EMOJI = {
    'cn_steam_tower':'💨','cn_ballista':'🏹','cn_flamethrower':'🔥',
    'cn_freezing_tower':'❄️',
}

def fmt_cost(c: dict) -> str:
    name = COST_NAMES.get(c['type'], f'res{c["type"]}')
    return f"{c['value']:,} {name}" if c['value'] is not None else name

def fmt_units(units: list) -> str:
    if not units: return '—'
    return '  '.join(f"{u['kind'].replace('un_','').replace('sp_','')}×{u['count']}"
                     for u in units if u['count'] > 0)

def render_user(u: dict, lines: list, title_str: str):
    b = u['base']
    lines.append(section(title_str))

    # ── ПРОФИЛЬ
    lines.append(sub('ПРОФИЛЬ'))
    lines.append(row('Ник',          b['name']))
    lines.append(row('ID',           b['user_id']))
    lines.append(row('Аккаунт',      b['account_id']))
    lines.append(row('Соцсеть',      b['snetwork']))
    lines.append(row('Уровень',      f"{b['level']}  (exp: {b['exp']:,})"))
    lines.append(row('Замок',        f"TH lv.{b['th_level']}"))
    lines.append(row('Стадия',       u['stage']))

    # ── РЕСУРСЫ
    lines.append(sub('РЕСУРСЫ'))
    lines.append(row('Золото (рубины)',   f"{u['gold']:>10,}   ◆ рубины: {u['ruby']:,}"))
    lines.append(row('Кристаллы',        f"{u['crystal']:>10,}"))
    lines.append(row('Нефть',            f"{u['oil']:>10,}"))
    lines.append(row('Слава',            f"{u['hglory']:>10,}"))
    lines.append(row('Митрил',           f"{u['mithril']:>10,}"))
    lines.append(row('Чертежи',          f"{u['blue_print']:>10,}"))
    lines.append(row('Красная руда',     f"{u['red_ore']:>10,}"))
    lines.append(row('Зелёная руда',     f"{u['green_ore']:>10,}"))
    lines.append(row('Синяя руда',       f"{u['blue_ore']:>10,}"))

    # ── КЛАН
    if b['clan']:
        c = b['clan']
        lines.append(sub('КЛАН'))
        lines.append(row('Название',  c['name']))
        lines.append(row('ID',        c['clan_id']))
        lines.append(row('Уровень',   str(c['level'])))
        lines.append(row('Роль',      ROLE_NAMES.get(c['role'], str(c['role']))))
        lines.append(row('Донат нефти',    f"{c['donate_oil']:,.0f}"))
        lines.append(row('Донат кристаллов', f"{c['donate_crystal']:,.0f}"))
    else:
        lines.append(row('Клан', '—  (без клана)'))

    # ── ВОЙСКА
    lines.append(sub('ВОЙСКА В КАЗАРМЕ'))
    unit_str = fmt_units(b['units'])
    # Разбиваем на строки по 60 символов
    while unit_str:
        lines.append(f"    {unit_str[:64]}")
        unit_str = unit_str[64:]

    # ── УРОВНИ ВОЙСК
    if b['units_levels']:
        lines.append(sub('УРОВНИ ЮНИТОВ/ЗАКЛИНАНИЙ'))
        for ul in sorted(b['units_levels'], key=lambda x: x['kind']):
            lines.append(row(ul['kind'].replace('un_','').replace('sp_',''),
                             f"lv.{ul['level']}", 6))

    # ── ГЕРОИ
    if b['heroes']:
        lines.append(sub('ГЕРОИ'))
        for h in b['heroes']:
            lines.append(row(h['kind'].replace('un_hero','герой').replace('_',' '),
                             f"hp:{h['stamina']:,}  last_reg:{ts(h['last_reg_time'])}", 6))

    # ── ПОСЛЕДНИЕ ЮНИТЫ В АРМИИ
    if u['last_units']:
        lines.append(sub('ПОСЛЕДНЯЯ АРМИЯ'))
        lines.append(f"    {fmt_units(u['last_units'])}")

    # ── ЗАКЛИНАНИЯ ЭКИПИРОВКИ
    if u['spells']:
        lines.append(sub('ЗАКЛИНАНИЯ'))
        lines.append(f"    {', '.join(u['spells'])}")

    # ── ИСТОРИЯ БОЁВ
    if u['fight_hist']:
        lines.append(sub(f'ИСТОРИЯ БОЁВ ({len(u["fight_hist"])} записей)'))
        for fh in u['fight_hist'][:10]:
            res = '✅ победа' if fh['is_win'] else '❌ поражение'
            stolen = ', '.join(fmt_cost(c) for c in fh['steal_res']) or '0'
            lines.append(f"    {ts(fh['time'])}  {res}  {fh['percentage']}%"
                         f"  vs {fh['name']} lv.{fh['level']}")
            lines.append(f"         украдено: {stolen}")
        if len(u['fight_hist']) > 10:
            lines.append(f"    ... ещё {len(u['fight_hist'])-10} боёв")

    # ── КВЕСТЫ
    active = [q for q in u['quests'] if any(t['state']=='open' for t in q['targets'])]
    if active:
        lines.append(sub(f'АКТИВНЫЕ КВЕСТЫ ({len(active)})'))
        for q in active[:8]:
            prog = [f"{t['progress']}" for t in q['targets'] if t['state']=='open' and t['progress'] is not None]
            lines.append(row(q['name'], '  '.join(prog) or '…', 6))

    # ── НАСТРОЙКИ
    sg = u['settings_game']
    lines.append(sub('НАСТРОЙКИ'))
    lines.append(row('Масштаб',    f"{sg['scale']}%"))
    lines.append(row('Звук',       str(sg['sound'])))
    lines.append(row('Музыка',     str(sg['music'])))
    lines.append(row('Низк. кач.', str(sg['low_quality'])))

    # ── ПРОЧЕЕ
    lines.append(sub('ПРОЧЕЕ'))
    lines.append(row('Вызовы (call)',   f"{u['call']}"))
    lines.append(row('Клан. вызовы',    f"{u['clan_calls']}"))
    lines.append(row('Клан. вызов time', ts(u['clan_calls_time'])))
    lines.append(row('Откатов рейдов',  str(len(u['raid_cooldowns']))))
    if u['raid_cooldowns']:
        for rc in u['raid_cooldowns']:
            lines.append(row(f"  {rc['kind']}", ts(rc['end_time']), 6))
    lines.append(row('Запросов помощи', str(len(u['requests']))))
    if u['client_custom_data']:
        lines.append(sub('CUSTOM DATA'))
        for kv in u['client_custom_data']:
            lines.append(row(kv['key'], kv['value'], 6))


def render_map(um: dict, lines: list):
    lines.append(section('КАРТА БАЗЫ  (PUm)'))
    lines.append(row('init_time',  ts(um['init_time'])))
    lines.append(row('object_id',  str(um['object_id'])))
    lines.append(row('Зданий',     str(len(um['buildings']))))
    lines.append(row('Пушек/башен',str(len(um['cannons']))))
    lines.append(row('Заборов',    str(len(um['fences']))))
    lines.append(row('Декора',     str(len(um['decors']))))
    lines.append(row('Мусора',     str(len(um['garbages']))))

    # ── ЗДАНИЯ
    lines.append(sub(f'ЗДАНИЯ ({len(um["buildings"])})'))
    for b in um['buildings']:
        emoji  = BTYPE_EMOJI.get(b['kind'], '🏗️')
        state  = '🔨' if b['state']['state'] == 'in_progress' else ''
        spec   = b['spec']
        extra  = ''
        if spec['type'] == 'resource':
            extra = f" [last_apply:{ts(spec.get('last_apply_time',0))} done:{spec.get('done_count',0)}]"
        elif spec['type'] == 'research':
            extra = f" [исследует: {spec.get('unit_kind','?')}]" if spec.get('unit_kind') else ''
        elif spec['type'] == 'shield':
            extra = f" [щит до: {ts(spec.get('shield_time',0))}]"
        elif spec['type'] == 'guard':
            cfg = ', '.join(f"{u['kind']}×{u['count']}" for u in spec.get('config', []))
            extra = f" [охрана: {cfg or 'пусто'} заряд:{spec.get('count',0)}]"

        fin = ''
        if b['state']['state'] == 'in_progress':
            fin = f" → lv.{b['level']}  готово: {ts(b['state']['finish_time'])}"

        lines.append(f"    {emoji} {state} {b['kind']:<28} lv.{b['level']:<3}"
                     f"  pos({b['pos']['x']:>3},{b['pos']['y']:>3})  id={b['id']}{fin}{extra}")

    # ── ПУШКИ/БАШНИ
    if um['cannons']:
        lines.append(sub(f'ПУШКИ / БАШНИ ({len(um["cannons"])})'))
        for c in um['cannons']:
            emoji = CANNON_EMOJI.get(c['kind'], '🔫')
            fin = ''
            if c['state']['state'] == 'in_progress':
                fin = f"  🔨 → lv.{c['level']}  готово: {ts(c['state']['finish_time'])}"
            lines.append(f"    {emoji} {c['kind']:<28} lv.{c['level']:<3}"
                         f"  pos({c['pos']['x']:>3},{c['pos']['y']:>3})  id={c['id']}{fin}")

    # ── ЗАБОРЫ
    if um['fences']:
        lines.append(sub(f'ЗАБОРЫ ({len(um["fences"])})'))
        by_kind: dict = {}
        for f in um['fences']:
            by_kind.setdefault(f['kind'], []).append(f"({f['pos']['x']},{f['pos']['y']})")
        for kind, positions in by_kind.items():
            lines.append(f"    🧱 {kind}  lv.{um['fences'][0]['level']}  × {len(positions)}")

    # ── МУСОР
    if um['garbages']:
        lines.append(sub(f'МУСОР / ДЕРЕВЬЯ ({len(um["garbages"])})'))
        by_kind: dict = {}
        for g in um['garbages']:
            by_kind.setdefault(g['kind'], []).append(g)
        for kind, items in by_kind.items():
            prize = fmt_cost(items[0]['prize']) if items else ''
            lines.append(f"    🌲 {kind}  × {len(items)}  приз за уборку: {prize}")


# ══════════════════════════════════════════════════════════════
#  ГЛАВНАЯ ПРОГРАММА
# ══════════════════════════════════════════════════════════════

def main():
    print()
    print("╔══════════════════════════════════════════════════════════════════════╗")
    print("║         Steampunk / Steampire — читалка бинарных дампов             ║")
    print("║               Поддержка: 5x2 (словарь) и 2x2 (карта)               ║")
    print("╚══════════════════════════════════════════════════════════════════════╝")
    print()

    # ── Запрос пути к файлу
    while True:
        path = input("  Путь к файлу .bin: ").strip().strip('"').strip("'")
        if os.path.isfile(path):
            break
        print(f"  ✗ Файл не найден: {path}")

    print(f"\n  Читаю файл ({os.path.getsize(path):,} байт)...")

    with open(path, 'rb') as f:
        data = f.read()

    ptype = detect_packet(data)
    if ptype == 'unknown':
        # Попробуем определить по размеру и содержимому
        if len(data) >= 8:
            fam, sub_b, ver, ln = struct.unpack('<HBBI', data[:8])
            print(f"  ✗ Неизвестный тип пакета: family={fam} sub={sub_b} ver={ver}")
        else:
            print("  ✗ Файл слишком короткий")
        input("\n  Enter для выхода...")
        return

    print(f"  ✓ Тип: {ptype.upper()}")
    print("  Парсинг...")

    lines = []
    lines.append(f"{'═'*W}")
    lines.append(f"  Steampunk/Steampire dump reader")
    lines.append(f"  Файл:    {os.path.basename(path)}")
    lines.append(f"  Размер:  {len(data):,} байт")
    lines.append(f"  Тип:     {ptype}")
    fam, sub_b, ver, ln = struct.unpack('<HBBI', data[:8])
    lines.append(f"  Заголовок: family={fam} sub={sub_b} ver={ver} payload={ln:,} б")
    lines.append(f"  Дата разбора: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    lines.append(f"{'═'*W}")

    try:
        if ptype == 'packet_5x2':
            result = parse_5x2(data)
            lines.append(f"\n  Начало PUser: байт 0x{result['puser_offset']:X}"
                         f" ({result['puser_offset']:,})")
            lines.append(f"  Размер PUser: {result['bytes_consumed_for_puser']:,} байт")
            render_user(result['user'], lines, 'ПРОФИЛЬ ИГРОКА (из 5x2)')

        elif ptype == 'packet_2x2':
            result = parse_2x2(data)
            lines.append(f"\n  Вариант ответа: {result['response_variant']}")
            if result.get('location_variant'):
                lines.append(f"  Локация: {result['location_variant']}")
            if 'user' in result:
                render_user(result['user'], lines, 'ПРОФИЛЬ ИГРОКА (из 2x2)')
            if 'map' in result:
                render_map(result['map'], lines)
                if result.get('dt'):
                    lines.append(f"\n  {row('dt (серверное время)', ts(result['dt']))}")
                if result.get('shield') is not None:
                    lines.append(f"  {row('Щит до', ts(result['shield']))}")
            if 'note' in result:
                lines.append(f"\n  ⚠ {result['note']}")

    except EOFError as e:
        lines.append(f"\n  ✗ Неожиданный конец данных: {e}")
        lines.append("    Возможно, дамп обрезан или имеет нестандартный формат.")
    except Exception as e:
        import traceback
        lines.append(f"\n  ✗ Ошибка парсинга: {e}")
        lines.append(traceback.format_exc())

    lines.append(f"\n{'═'*W}\n")
    output = '\n'.join(lines)

    # ── Вывод на экран
    print()
    print(output)

    # ── Сохранение в файл
    rand_id = random.randint(1000, 9999)
    out_name = f"result_{rand_id}.txt"
    out_path = os.path.join(os.path.dirname(path), out_name)

    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(output)

    print(f"  ✓ Результат сохранён: {out_path}")
    print()
    input("  Нажмите Enter для выхода... ")

if __name__ == '__main__':
    main()