"""
! много вайбкода !
handlers/p2_1.py  —  Packet_0002_01 → Packet_0002_02

variance=0  GET_LOCATION       → своя карта (HOME)
variance=1  ENTER_STORM        → заглушка (шторм не реализован)
variance=2  GET_TARGET         → поиск бота по уровню игрока
variance=3  CHECK_FINISH_WAR   → заглушка
variance=4  WATCH_STORM        → заглушка
variance=5  TERRITORY_INFO     → заглушка
variance=6  TO_TERRITORY_STORM → заглушка

─── Файлы ботов ────────────────────────────────────────────────────────────────
Хранятся в  bots/pool/
Формат имени: bot_lv<NN>_custom_<NN>.json   (уровень читается из поля "level" в JSON)
              bot_lv021_custom_01.json
              bot_lv050_custom_03.json
              и т.д. — любые имена оканчивающиеся на .json, кроме history.json

─── Матчмейкинг ────────────────────────────────────────────────────────────────
1. Определяем брекет игрока (22 группы).
2. Среди ботов брекета выбираем тех у кого кулдаун истёк (30 мин).
3. Если в брекете никого — расширяем поиск на соседние брекеты (+1/-1, +2/-2 …)
4. Если вообще все боты на кулдауне — берём ближайшего игнорируя кулдаун.
5. Среди кандидатов — случайный выбор (равновероятный внутри брекета).

─── Кулдаун ────────────────────────────────────────────────────────────────────
30 минут. Записывается в bots/history.json при начале каждого боя.
может быть потом реворк под онлайн когда игруля закроется
"""

import struct, os, sys, json, time, random, uuid, re

# ── Конфиг боевой системы ─────────────────────────────────────────────────────
_BATTLE_CFG_PATH = os.path.join(
    os.path.abspath(os.path.join(os.path.dirname(__file__), '..')),
    'battle_config.json'
)
_BATTLE_CFG: dict = {}

def _get_battle_cfg() -> dict:
    """Загружает battle_config.json (кешируется до перезапуска сервера)."""
    global _BATTLE_CFG
    if _BATTLE_CFG:
        return _BATTLE_CFG
    try:
        with open(_BATTLE_CFG_PATH, 'r', encoding='utf-8') as f:
            _BATTLE_CFG = json.load(f)
    except Exception as e:
        print(f'  [2x1] WARNING: battle_config.json: {e}')
        _BATTLE_CFG = {}
    return _BATTLE_CFG

PROTOCOL_VERSION = 77
COOLDOWN_SEC     = 1800   # 30 минут

BASE_DIR     = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
BOTS_DIR     = os.path.join(BASE_DIR, 'bots', 'pool')
HISTORY_PATH = os.path.join(BASE_DIR, 'bots', 'history.json')
DUMPS_DIR    = os.path.join(BASE_DIR, 'dumps')

if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

import state as _state

# ── Packet_0002_02 variance ───────────────────────────────────────────────────
RESP_LOCATION = 0
RESP_FIGHT    = 2
RESP_UNKNOWN  = 5

# PFightRequestResult variance
FIGHT_OK       = 0
FIGHT_NO_TARGET = 2

# Packet_0002_01 variance
REQ_GET_LOCATION = 0
REQ_GET_TARGET   = 2

# ── Брекеты (22 группы) ───────────────────────────────────────────────────────
BRACKETS = [
    (1,   10),
    (11,  20),
    (21,  25),
    (26,  30),
    (31,  35),
    (36,  40),
    (41,  45),
    (46,  50),
    (51,  55),
    (56,  60),
    (61,  65),
    (66,  70),
    (71,  75),
    (76,  80),
    (81,  85),
    (86,  90),
    (91,  95),
    (96,  100),
    (101, 103),
    (104, 106),
    (107, 109),
    (110, 110),
]

def _bracket_idx(level: int) -> int:
    """Возвращает индекс брекета для данного уровня."""
    for i, (lo, hi) in enumerate(BRACKETS):
        if lo <= level <= hi:
            return i
    return len(BRACKETS) - 1


# ── История боёв ──────────────────────────────────────────────────────────────

def _load_history() -> dict:
    if os.path.exists(HISTORY_PATH):
        try:
            with open(HISTORY_PATH, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception:
            pass
    return {}


def _save_history(h: dict) -> None:
    os.makedirs(os.path.dirname(HISTORY_PATH), exist_ok=True)
    tmp = HISTORY_PATH + '.tmp'
    with open(tmp, 'w', encoding='utf-8') as f:
        json.dump(h, f, ensure_ascii=False, indent=2)
    os.replace(tmp, HISTORY_PATH)


def _record_fight(bot_id: str, fight_id: str) -> None:
    """Записывает время начала боя и fight_id — чтобы p20_9 мог найти бота по итогам."""
    h = _load_history()
    entry = h.setdefault(bot_id, {})
    entry['last_fight_time'] = time.time()
    entry['last_fight_id']   = fight_id
    _save_history(h)


# ── Загрузка ботов из bots/pool/ ─────────────────────────────────────────────

def _load_bots() -> list[tuple[str, dict]]:
    """
    Загружает всех ботов из bots/pool/*.json.
    Возвращает список (bot_id, data).
    bot_id — имя файла без .json
    """
    result = []
    if not os.path.isdir(BOTS_DIR):
        return result
    for fname in sorted(os.listdir(BOTS_DIR)):
        if not fname.endswith('.json') or fname == 'history.json':
            continue
        path   = os.path.join(BOTS_DIR, fname)
        bot_id = fname[:-5]
        try:
            with open(path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            data.pop('_comment', None)
            result.append((bot_id, data))
        except Exception as e:
            print(f'  [2x1] WARNING: не удалось загрузить {fname}: {e}')
    return result


# ── Матчмейкинг ───────────────────────────────────────────────────────────────

def _pick_bot(player_level: int) -> tuple[str | None, dict | None]:
    """
    Алгоритм подбора бота:

    1. Загружаем всех ботов. Если ботов нет — None.
    2. Помечаем у каждого кулдаун (прошло < 30 мин с последнего боя).
    3. Находим брекет игрока.
    4. Ищем ботов внутри брекета без кулдауна → берём случайного.
    5. Если в брекете нет свежих — расширяем поиск на соседние брекеты
       по одному в каждую сторону (±1, ±2, …) пока не найдём кого-то.
    6. Если все боты на кулдауне — берём ближайшего по уровню игнорируя кулдаун.
    """
    all_bots = _load_bots()
    if not all_bots:
        return None, None

    history = _load_history()
    now     = time.time()

    def on_cooldown(bid: str) -> bool:
        last = history.get(bid, {}).get('last_fight_time', 0)
        return (now - last) < COOLDOWN_SEC

    # Группируем ботов по индексу брекета
    by_bracket: dict[int, list] = {}
    for bid, bd in all_bots:
        lv  = int(bd.get('level', 1))
        idx = _bracket_idx(lv)
        by_bracket.setdefault(idx, []).append((bid, bd))

    player_bracket = _bracket_idx(player_level)

    # Шаг 4-5: расширяем поиск от брекета игрока наружу
    max_radius = len(BRACKETS)
    for radius in range(max_radius + 1):
        candidates = []
        for delta in ([0] if radius == 0 else [radius, -radius]):
            idx = player_bracket + delta
            if 0 <= idx < len(BRACKETS):
                fresh = [(bid, bd) for bid, bd in by_bracket.get(idx, [])
                         if not on_cooldown(bid)]
                candidates.extend(fresh)
        if candidates:
            return random.choice(candidates)

    # Шаг 6: все на кулдауне — берём ближайшего по уровню
    print('  [2x1] все боты на кулдауне, игнорируем кулдаун')
    closest = min(all_bots, key=lambda x: abs(int(x[1].get('level', 1)) - player_level))
    return closest


# ── Построение ответов ────────────────────────────────────────────────────────

def _build_fight_response(bot: dict, fight_id: str, attacker: dict) -> bytes:
    """
    2x2: variant=FIGHT + PFightRequestResult(FIGHT) + PTargetInfo.

    bot      — данные ЦЕЛИ (база бота: карта, ресурсы, профиль)
    attacker — данные АТАКУЮЩЕГО игрока (войска, уровни юнитов, золото)
    """
    ti       = _state.build_target_info_bytes(bot, bot,
                                               fight_id=fight_id,
                                               attacker=attacker)
    payload  = struct.pack('<B', RESP_FIGHT) + struct.pack('<B', FIGHT_OK) + ti
    return struct.pack('<HBBI', 2, 2, PROTOCOL_VERSION, len(payload)) + payload


def _build_no_target() -> bytes:
    """2x2: variant=FIGHT + PFightRequestResult(NO_TARGET)."""
    payload = struct.pack('<B', RESP_FIGHT) + struct.pack('<B', FIGHT_NO_TARGET)
    return struct.pack('<HBBI', 2, 2, PROTOCOL_VERSION, len(payload)) + payload


def _build_unknown() -> bytes:
    payload = struct.pack('<B', RESP_UNKNOWN)
    return struct.pack('<HBBI', 2, 2, PROTOCOL_VERSION, len(payload)) + payload


# ── Своя карта (variance=0) ───────────────────────────────────────────────────

def _handle_get_location() -> bytes:
    dump_path = os.path.join(DUMPS_DIR, '2x1_1')
    if not os.path.exists(dump_path):
        print('  [2x1] CRITICAL: нет дампа 2x1_1!')
        return struct.pack('<HBBI', 2, 2, PROTOCOL_VERSION, 1) + struct.pack('<B', RESP_UNKNOWN)

    with open(dump_path, 'rb') as f:
        dump = f.read()

    with _state.acquire_state_lock():
        player = _state.load_player()
        base   = _state.load_base(player)

    try:
        resp = _state.patch_2x2(dump, player, base)
    except Exception as e:
        import traceback
        print(f'  [2x1] patch_2x2 error: {e}')
        traceback.print_exc()
        return dump

    print(f'  [2x1] -> 2x2 {len(resp)}b | '
          f'lv={player.get("level")} '
          f'gold={player.get("gold",0):,} '
          f'crystal={player.get("crystal",0):,} '
          f'oil={player.get("oil",0):,} | '
          f'buildings={len(base.get("buildings",[]))} '
          f'cannons={len(base.get("cannons",[]))}')
    return resp


# ── Главный обработчик ────────────────────────────────────────────────────────

def handle(body: bytes) -> bytes:
    variance = body[8] if len(body) > 8 else 0
    print(f'  [2x1] variance={variance}', end='')

    # ── variance=0: GET_LOCATION — загружаем свою карту ───────────────────────
    if variance == REQ_GET_LOCATION:
        print()
        return _handle_get_location()

    # ── variance=2: GET_TARGET — ищем бота ────────────────────────────────────
    if variance == REQ_GET_TARGET:
        fk2_var  = body[9] if len(body) > 9 else 0
        fk2_name = {0:'USER', 1:'USER_WAR', 2:'REVENGE', 3:'USER_WAR_TARGET'}.get(fk2_var, str(fk2_var))
        print(f'  PFightKind2={fk2_name}')

        # Загружаем игрока — нужен уровень и для вычета кристаллов за поиск
        try:
            with _state.acquire_state_lock():
                _search_player = _state.load_player()

            player_level    = int(_search_player.get('level', 1))

            # Стоимость поиска из battle_config.json
            cfg          = _get_battle_cfg()
            search_cost  = int(cfg.get('search', {}).get('crystal_cost', 50))
            if search_cost > 0:
                cur_crystal = int(_search_player.get('crystal', 0))
                if cur_crystal >= search_cost:
                    _search_player['crystal'] = cur_crystal - search_cost
                    with _state.acquire_state_lock():
                        _state.save_player(_search_player)
                    print(f'  [2x1] поиск: -{search_cost} crystal (было {cur_crystal:,})')
                else:
                    print(f'  [2x1] поиск: нет кристаллов ({cur_crystal} < {search_cost})')
        except Exception as e:
            print(f'  [2x1] ошибка загрузки игрока: {e}')
            player_level = 1

        player_bracket_lo, player_bracket_hi = BRACKETS[_bracket_idx(player_level)]

        # Подбираем бота
        bot_id, bot = _pick_bot(player_level)
        if bot is None:
            print(f'  [2x1] GET_TARGET: ботов нет в {BOTS_DIR}/')
            return _build_no_target()

        fight_id = str(uuid.uuid4())

        try:
            # Передаём реального игрока как атакующего —
            # именно его войска/уровни юнитов должны быть в PAttackerInfo
            resp = _build_fight_response(bot, fight_id, attacker=_search_player)
        except Exception as e:
            import traceback
            print(f'  [2x1] GET_TARGET: ошибка сборки PTargetInfo: {e}')
            traceback.print_exc()
            return _build_no_target()

        # Записываем в историю и в player_state (чтобы p10_24 знал с кем бой)
        _record_fight(bot_id, fight_id)
        with _state.acquire_state_lock():
            _fp = _state.load_player()
            _fp['_active_fight_id']     = fight_id
            _fp['_active_fight_bot_lv'] = int(bot.get('level', 1))
            _state.save_player(_fp)

        bot_lv   = bot.get('level', '?')
        bot_name = bot.get('name', '?')
        print(f'  [2x1] → БОЙ  бот=[{bot_id}]  "{bot_name}"  lv{bot_lv}'
              f'  (игрок lv{player_level} брекет {player_bracket_lo}-{player_bracket_hi})'
              f'  fight_id={fight_id[:8]}...  ответ={len(resp)}б')
        return resp

    # ── Остальные variance: заглушки ─────────────────────────────────────────
    stubs = {
        1: 'ENTER_STORM',
        3: 'CHECK_FINISH_WAR',
        4: 'WATCH_STORM',
        5: 'TERRITORY_INFO',
        6: 'TO_TERRITORY_STORM',
    }
    print(f'  → {stubs.get(variance, f"UNKNOWN_{variance}")} — заглушка')
    return _build_unknown()