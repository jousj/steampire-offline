"""
bootstrap_player.py — Полный bootstrap игрока.

Читает dumps/2x1_1 и извлекает ВСЕ поля PUser включая:
  - Профиль, ресурсы, войска, уровни исследований, герои, клан
  - quests[], quests_closed[], win_missions[] — КРИТИЧНО для level > 1
  - fight_hist[], stories[], ext_missions[]
  - Настройки, заклинания, custom data

Сохраняет в player_state.json.
"""

import struct, json, os, sys, time as _time

BASE_DIR    = os.path.abspath(os.path.dirname(__file__))
DUMP_PATH   = os.path.join(BASE_DIR, 'dumps', '2x1_1')
PLAYER_JSON = os.path.join(BASE_DIR, 'player_state.json')


class Reader:
    def __init__(self, data: bytes, pos: int = 0):
        self._d = data; self._p = pos

    @property
    def pos(self): return self._p

    def _r(self, n):
        if self._p + n > len(self._d):
            raise EOFError(f'Need {n} @ 0x{self._p:X} (have {len(self._d)-self._p})')
        b = self._d[self._p:self._p+n]; self._p += n; return b

    def u8(self):    return struct.unpack('<B', self._r(1))[0]
    def bool_(self): return self.u8() != 0
    def u16(self):   return struct.unpack('<H', self._r(2))[0]
    def i32(self):   return struct.unpack('<i', self._r(4))[0]
    def u32(self):   return struct.unpack('<I', self._r(4))[0]
    def f64(self):   return struct.unpack('<d', self._r(8))[0]
    def utf(self):
        n = self.u16()
        return self._r(n).decode('utf-8', errors='replace')


def _read_pcost(r):
    """PCost: u8 variance + value"""
    v = r.u8()
    if v <= 5:    val = r.u32()
    elif v == 10: val = None
    else:         val = r.i32()
    return {'v': v, 'val': val}


def _read_histfight(r):
    """PHistFight: полная структура по AS3"""
    hid  = r.utf(); ht = r.f64(); hnm = r.utf()
    hlv  = r.i32(); hrat = r.i32()
    steal = [_read_pcost(r) for _ in range(r.u16())]
    chrat = r.i32(); iswn = r.bool_(); pct = r.i32()
    uif   = [{'kind': r.utf(), 'count': r.u32()} for _ in range(r.u16())]
    ud    = [{'kind': r.utf(), 'count': r.u32()} for _ in range(r.u16())]
    rev   = r.bool_(); hrep = r.bool_()
    ul    = [{'kind': r.utf(), 'level': r.i32()} for _ in range(r.u16())]
    rd    = r.bool_()
    clan  = None
    if r.u8() == 1:
        clan = {'icon': r.utf(), 'name': r.utf()}
    spells = [{'kind': r.utf(), 'count': r.u32()} for _ in range(r.u16())]
    uid   = r.utf(); snet = r.utf(); sco = r.bool_(); av = r.utf()
    return {'id': hid, 'time': ht, 'name': hnm, 'level': hlv, 'ratio': hrat,
            'steal_res': steal, 'change_ratio': chrat, 'is_win': iswn,
            'percentage': pct, 'units_in_fight': uif, 'unit_died': ud,
            'revenge': rev, 'has_replay': hrep, 'units_levels': ul,
            'read': rd, 'clan': clan, 'spells': spells,
            'uid': uid, 'snetwork': snet, 'scouting': sco, 'avatar': av}


def _skip_pask(r):
    """PAsk: пропустить (сложная структура, в runtime не нужна)"""
    r.utf(); r.utf(); r.u32(); r.f64()
    v = r.u8()
    if v == 0:   r.utf(); r.u8(); struct.unpack('<h', r._r(2)); struct.unpack('<h', r._r(2))
    elif v == 1: r.utf(); r.u8()
    elif v == 2: r.utf(); r.u32()
    elif v == 3: pass
    else: raise ValueError(f'Unknown PAskData variant {v}')
    r.bool_()
    r.utf(); r.u32()


def _skip_pask_safe(r):
    """Безопасная версия _skip_pask с поддержкой i16 через структуру"""
    r.utf(); r.utf(); r.u32(); r.f64()
    v = r.u8()
    if v == 0:   r.utf(); r.u8(); r._r(2); r._r(2)  # utf + u8 + i16 + i16
    elif v == 1: r.utf(); r.u8()
    elif v == 2: r.utf(); r.u32()
    elif v == 3: pass
    else: raise ValueError(f'Unknown PAskData variant {v}')
    r.bool_()
    r.utf(); r.u32()


def parse_userbase(r):
    uid         = r.utf()
    name        = r.utf()
    avatar      = r.utf()
    profile_url = r.utf()
    level       = r.u16()
    sex         = r.utf()
    exp         = r.i32()
    avatar_small= r.utf()
    avatar_big  = r.utf()
    ratio       = r.u32()

    troops = {}
    for _ in range(r.u16()):
        k = r.utf(); c = r.u32()
        if c > 0: troops[k] = c

    unit_levels = {}
    for _ in range(r.u16()):
        k = r.utf(); lv = r.i32()
        unit_levels[k] = lv

    heroes = []
    for _ in range(r.u16()):
        hk=r.utf(); hlv=r.u32(); htm=r.f64()
        u1=r.u32(); u2=r.u32(); u3=r.u32(); u4=r.u32()
        heroes.append({'kind': hk, 'level': hlv, 'time': htm,
                        'u1': u1, 'u2': u2, 'u3': u3, 'u4': u4})

    clan = None
    if r.u8() == 1:
        cid=r.utf(); cnm=r.utf(); emb=r.utf(); cpts=r.i32(); crl=r.u8()
        d1=r.f64(); d2=r.f64(); d3=r.f64()
        ucb=[r.utf() for _ in range(r.u16())]
        d4=r.f64()
        clan = {'id': cid, 'name': cnm, 'emblem': emb, 'points': cpts, 'role': crl,
                'd1': d1, 'd2': d2, 'd3': d3, 'units_can_buy': ucb, 'd4': d4}

    th_level   = r.u32()
    account_id = r.utf()
    snetwork   = r.utf()
    scouting   = r.f64()

    clan_points = None
    if r.u8() == 1:
        clan_points = [r.i32(), r.i32()]

    return {
        'user_id': uid, 'name': name, 'avatar': avatar,
        'profile_url': profile_url, 'level': level, 'sex': sex,
        '_exp': exp, 'avatar_small': avatar_small, 'avatar_big': avatar_big,
        'ratio': ratio, 'troops': troops, 'unit_levels': unit_levels,
        'heroes': heroes, 'clan': clan, 'th_level': th_level,
        'account_id': account_id, 'snetwork': snetwork,
        'scouting': scouting, 'clan_points': clan_points,
    }


def parse_puser_fields(r, base):
    gold    = r.u32()
    crystal = r.u32()
    oil     = r.u32()
    hglory  = r.u32()

    # ── quests[] — ОБЯЗАТЕЛЬНО: определяет состояние quest-системы ───────────
    # Flash инициализирует квесты по этим данным.
    # quests=0 при level > 1 = Error #1009 (null reference в quest-системе)
    quests = []
    for _ in range(r.u16()):
        qn = r.utf()
        targets = []
        for _ in range(r.u8()):   # u8 count, не u16!
            v = r.u8()
            val = r.u32() if v == 0 else None   # QTOPEN=0 имеет u32, QTDONE=1 нет
            targets.append({'v': v, 'val': val})
        quests.append({'name': qn, 'targets': targets})

    # ── quests_closed[] ───────────────────────────────────────────────────────
    quests_closed = [r.utf() for _ in range(r.u16())]

    stage = r.utf()

    # ── win_missions[] — пройденные миссии ───────────────────────────────────
    win_missions = [r.utf() for _ in range(r.u16())]

    # ── ext_missions[] — PExtMission: utf kind + f64 last_time + utf next ────
    ext_missions = []
    for _ in range(r.u16()):
        ek=r.utf(); et=r.f64(); en=r.utf()
        ext_missions.append({'kind': ek, 'last_time': et, 'next': en})

    r.bool_()  # admin_units_mode

    # ── stories[] — str_str: utf + utf ───────────────────────────────────────
    stories = []
    for _ in range(r.u16()):
        stories.append({'k': r.utf(), 'v': r.utf()})

    # ── fight_hist[] — PHistFight (полная структура) ──────────────────────────
    fight_hist = [_read_histfight(r) for _ in range(r.u16())]

    call_lat = r.f64(); call = r.u32(); facts = r.u32()

    sg_sound=r.u8(); sg_music=r.u8(); sg_lq=r.bool_()
    sg_scale=r.u32(); sg_alerts=r.bool_()
    settings = {'sg_sound': sg_sound, 'sg_music': sg_music,
                'sg_low_quality': sg_lq, 'sg_scale': sg_scale,
                'sg_in_game_alerts': sg_alerts}

    lrn = r.utf()
    clan_calls=r.i32(); clan_calls_time=r.f64(); read_chat_time=r.f64()

    r.i32(); r.i32(); r.i32()  # red/green/blue_ore

    for _ in range(r.u16()): r.utf(); r.f64()   # raid_cooldowns[]
    for _ in range(r.u16()): _skip_pask_safe(r)  # requests[]

    group_id = r.u8()

    for _ in range(r.u16()): r.utf()  # request_list[]
    r.f64()                            # request_time

    for _ in range(r.u16()): r.utf(); r.f64(); r.bool_()  # offers[]
    for _ in range(r.u16()): r.utf()                       # shop_unwatched[]
    for _ in range(r.u16()): r.utf(); r.u32()              # last_units[]

    mithril=r.i32(); blueprint=r.i32()

    for _ in range(r.u16()): r.i32()  # divisions_reward[]

    spells = [r.utf() for _ in range(r.u16())]

    custom = {}
    for _ in range(r.u16()):
        k=r.utf(); v=r.utf(); custom[k]=v

    # jaina_events[] — i_PJainaEvent: i32 + (i32 + bool + i32 + f64)
    for _ in range(r.u16()):
        r.i32(); r.i32(); r.bool_(); r.i32(); r.f64()

    jglory=r.i32(); rar_dragon=r.i32()

    for _ in range(r.u16()): r.i32(); r.i32(); r.i32()  # adventures[]

    if r.u8() == 1:   # opt current_adventure
        r.i32(); r.f64()
        if r.u8() == 1: r.i32()
        r.i32(); r.i32(); r.bool_()

    if r.u8() == 1:   # opt subscription: i32 + f64 + i32 + bool
        r.i32(); r.f64(); r.i32(); r.bool_()

    ruby = r.i32()

    base.update({
        'gold': gold, 'crystal': crystal, 'oil': oil, 'hglory': hglory,
        'mithril': mithril, 'blue_print': blueprint, 'ruby': ruby,
        'jglory': jglory, 'rar_dragon': rar_dragon,
        'call': call, 'facts': facts, 'stage': stage,
        'quests': quests,
        'quests_closed': quests_closed,
        'win_missions': win_missions,
        'ext_missions': ext_missions,
        'stories': stories,
        'fight_hist': fight_hist,
        'spells': spells, 'custom': custom, 'settings': settings,
        'last_readed_news': lrn,
        'clan_calls': clan_calls, 'clan_calls_time': clan_calls_time,
        'read_chat_time': read_chat_time, 'group_id': group_id,
        'exp': base.get('_exp', 0),
    })
    base.pop('_exp', None)
    return base


def main():
    if not os.path.exists(DUMP_PATH):
        print(f'[bootstrap_player] Дамп не найден: {DUMP_PATH}')
        default = {
            'user_id': 'local-player', 'name': 'Player',
            'avatar': '', 'profile_url': '', 'avatar_small': '', 'avatar_big': '',
            'level': 1, 'exp': 0, 'ratio': 1000, 'sex': 'm',
            'troops': {}, 'unit_levels': {}, 'heroes': [],
            'clan': None, 'clan_points': None,
            'th_level': 1, 'account_id': 'local', 'snetwork': 'local', 'scouting': 0.0,
            'gold': 999_999_999, 'crystal': 100_000, 'oil': 50_000,
            'mithril': 0, 'hglory': 0, 'ruby': 0, 'blue_print': 0,
            'jglory': 0, 'rar_dragon': 0, 'call': 5, 'facts': 0,
            'stage': 'home4_hero_click',
            'quests': [], 'quests_closed': [], 'win_missions': [],
            'ext_missions': [], 'stories': [], 'fight_hist': [],
            'spells': [], 'custom': {},
            'settings': {'sg_sound': 0, 'sg_music': 0, 'sg_low_quality': False,
                         'sg_scale': 75, 'sg_in_game_alerts': True},
            'last_readed_news': '', 'clan_calls': 0,
            'clan_calls_time': 0.0, 'read_chat_time': 0.0, 'group_id': 0,
        }
        with open(PLAYER_JSON, 'w', encoding='utf-8') as f:
            json.dump(default, f, indent=2, ensure_ascii=False)
        print(f'[bootstrap_player] Создан {PLAYER_JSON}')
        return

    if os.path.exists(PLAYER_JSON):
        ans = input('[bootstrap_player] player_state.json уже существует. Перезаписать? (y/N): ').strip().lower()
        if ans != 'y':
            print('[bootstrap_player] Отменено.')
            sys.exit(0)

    with open(DUMP_PATH, 'rb') as f:
        data = f.read()
    print(f'[bootstrap_player] Читаю {os.path.basename(DUMP_PATH)} ({len(data):,} байт)...')

    r = Reader(data, 9)
    try:
        profile = parse_userbase(r)
        player  = parse_puser_fields(r, profile)
    except EOFError as e:
        print(f'[bootstrap_player] Ошибка: {e}'); sys.exit(1)

    player['gold'] = 999_999_999
    player['crystal'] = 1_000
    player['oil'] = 500

    with open(PLAYER_JSON, 'w', encoding='utf-8') as f:
        json.dump(player, f, indent=2, ensure_ascii=False)

    print()
    print('╔══════════════════════════════════════════════════════════════╗')
    print('║  bootstrap_player: результат                                 ║')
    print('╚══════════════════════════════════════════════════════════════╝')
    print(f'    Ник:          {player.get("name")!r}')
    print(f'    Уровень:      {player.get("level")} (exp={player.get("exp")})')
    print(f'    Аккаунт:      {player.get("account_id")} [{player.get("snetwork")}]')
    print(f'    TH:           {player.get("th_level")}')
    print(f'    Gold:         {player.get("gold"):,}')
    print(f'    Войска:       {player.get("troops")}')
    print(f'    unit_levels:  {len(player.get("unit_levels",{}))} видов')
    print(f'    Герои:        {len(player.get("heroes",[]))}')
    print(f'    Квесты:       {len(player.get("quests",[]))} активных, '
          f'{len(player.get("quests_closed",[]))} закрытых')
    print(f'    win_missions: {player.get("win_missions",[])}')
    print(f'    fight_hist:   {len(player.get("fight_hist",[]))} боёв')
    clan = player.get('clan')
    if clan:
        print(f'    Клан:         {clan.get("name")!r} role={clan.get("role")}')
    print()
    print(f'[bootstrap_player] Записан → {PLAYER_JSON}')


if __name__ == '__main__':
    main()