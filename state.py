import struct
import json
import os
import time
import re
import threading
import tempfile

# ── Глобальный мьютекс для атомарных JSON-операций ──────────────────────────
# ThreadingTCPServer порождает новый поток на каждый запрос.
# Без лока два одновременных MOVE делают:
#   Поток A: load_base()  → читает JSON (объект X в позиции 5,5)
#   Поток B: load_base()  → читает тот же JSON
#   Поток A: save_base()  → пишет X в позиции 10,10
#   Поток B: save_base()  → перезаписывает, X снова в 5,5 — изменение потеряно!
# RLock (реентерабельный) позволяет одному потоку захватить лок дважды.
_STATE_LOCK = threading.RLock()


class acquire_state_lock:
    """
    Контекстный менеджер для атомарного цикла load → modify → save.
    Весь блок выполняется под одним локом — никакой другой поток не может
    прочитать или записать JSON пока идёт обработка.

    Использование:
        with acquire_state_lock():
            player = load_player()
            base   = load_base()
            ...изменить...
            save_player(player)
            save_base(base)
    """
    def __enter__(self):
        _STATE_LOCK.acquire()
        return self

    def __exit__(self, *_):
        _STATE_LOCK.release()

BASE_DIR    = os.path.abspath(os.path.dirname(__file__))
PLAYER_JSON = os.path.join(BASE_DIR, 'player_state.json')
BASE_JSON   = os.path.join(BASE_DIR, 'base_state.json')
DUMPS_DIR   = os.path.join(BASE_DIR, 'dumps')
LEVEL_CONFIG_PATH = os.path.join(BASE_DIR, 'level_config.json')

# ── Таблица уровней (извлечена из 5x1 PDict) ─────────────────────────────────
# Формат: [{'id': N, 'req': exp_required, 'max_ratio': N}, ...]
# _LEVELS[i] — данные для уровня i+1 (индекс с нуля)
_LEVELS: list = []

def _load_levels() -> list:
    global _LEVELS
    if _LEVELS:
        return _LEVELS
    try:
        with open(LEVEL_CONFIG_PATH, 'r', encoding='utf-8') as f:
            _LEVELS = json.load(f)
    except Exception as e:
        print(f'[state] WARNING: level_config.json не найден: {e}')
        # Аппроксимация на случай отсутствия файла
        _LEVELS = [{'id': i+1, 'req': i*(i+1)*75//2, 'max_ratio': (i+1)*100}
                   for i in range(115)]
    return _LEVELS

def exp_to_level(exp: int) -> int:
    """Вычисляет уровень игрока по опыту (как делает клиент)."""
    levels = _load_levels()
    level = 1
    for entry in levels:
        if exp >= entry['req']:
            level = entry['id']
        else:
            break
    return level

def level_to_exp(level: int) -> int:
    """Минимальный опыт для достижения уровня."""
    levels = _load_levels()
    idx = level - 1
    if 0 <= idx < len(levels):
        return levels[idx]['req']
    return 0

# ── PCost.variance ────────────────────────────────────────────────────────────
PCOST_GOLD    = 0
PCOST_CRYSTAL = 1
PCOST_OIL     = 2
PCOST_EXP     = 3
PCOST_HGLORY  = 4
PCOST_CALL    = 5
PCOST_MITHRIL = 9

RESOURCE_KEYS = {
    'gold': 'gold', 'crystal': 'crystal', 'oil': 'oil',
    'hglory': 'hglory', 'mithril': 'mithril', 'ruby': 'ruby',
    'blueprint': 'blue_print',
}

# Тип ресурса добываемого ресурса (для COLLECT_RESOURCE)
BUILDING_RESOURCE_TYPE = {
    # bl_power_plant — тип PYLON (sv=6), не RESOURCE, не добывает ресурс напрямую
    'bl_oil_tower':    PCOST_OIL,
    'bl_crystal_mine': PCOST_CRYSTAL,
    'bl_ruby_mine':    PCOST_GOLD,   # ruby отдельно, но API возвращает как gold-event
    'bl_mint_yard':    PCOST_GOLD,   # монетный двор: PBtype=RESOURCE → производит золото
}

# Сгенерировано автоматически из dumps/5x1_1 (PDict)
# Формат: {kind: {level: {'costs': {resource: amount}, 'time_sec': N}}}
BUILDING_CONFIG = {
    'bl_academy': {
        1: {'costs': {'oil': 150}, 'time_sec': 900},
        2: {'costs': {'oil': 1000}, 'time_sec': 5400},
        3: {'costs': {'oil': 5000}, 'time_sec': 36000},
        4: {'costs': {'oil': 25000}, 'time_sec': 57600},
        5: {'costs': {'oil': 75000}, 'time_sec': 86400},
        6: {'costs': {'oil': 100000}, 'time_sec': 172800},
        7: {'costs': {'oil': 150000}, 'time_sec': 345600},
        8: {'costs': {'oil': 275000}, 'time_sec': 518400},
        9: {'costs': {'oil': 500000}, 'time_sec': 691200},
        10: {'costs': {'oil': 1200000, 'mithril': 8000}, 'time_sec': 777600},
        11: {'costs': {'oil': 1850000, 'mithril': 20000}, 'time_sec': 864000},
        12: {'costs': {'oil': 2250000, 'mithril': 30000}, 'time_sec': 864000},
    },
    'bl_barracks': {
        1: {'costs': {'oil': 50}, 'time_sec': 0},
        2: {'costs': {'oil': 150}, 'time_sec': 900},
        3: {'costs': {'oil': 3000}, 'time_sec': 7200},
        4: {'costs': {'oil': 17500}, 'time_sec': 18000},
        5: {'costs': {'oil': 50000}, 'time_sec': 43200},
        6: {'costs': {'oil': 75000}, 'time_sec': 64800},
        7: {'costs': {'oil': 150000}, 'time_sec': 86400},
        8: {'costs': {'oil': 300000}, 'time_sec': 216000},
        9: {'costs': {'oil': 450000}, 'time_sec': 345600},
        10: {'costs': {'oil': 1150000, 'mithril': 10000}, 'time_sec': 518400},
        11: {'costs': {'oil': 1650000}, 'time_sec': 518400},
    },
    'bl_builder': {
        1: {'costs': {'gold': 25}, 'time_sec': 0},
    },
    'bl_camp': {
        1: {'costs': {'oil': 100}, 'time_sec': 0},
        2: {'costs': {'oil': 250}, 'time_sec': 60},
        3: {'costs': {'oil': 1000}, 'time_sec': 1800},
        4: {'costs': {'oil': 35000}, 'time_sec': 43200},
        5: {'costs': {'oil': 100000}, 'time_sec': 129600},
        6: {'costs': {'oil': 150000}, 'time_sec': 259200},
        7: {'costs': {'oil': 300000}, 'time_sec': 518400},
        8: {'costs': {'oil': 600000}, 'time_sec': 691200},
        9: {'costs': {'oil': 900000}, 'time_sec': 864000},
        10: {'costs': {'mithril': 1000}, 'time_sec': 1036800},
        11: {'costs': {'mithril': 1000}, 'time_sec': 1040400},
        12: {'costs': {'mithril': 2000}, 'time_sec': 1044000},
        13: {'costs': {'mithril': 2000}, 'time_sec': 1047600},
        14: {'costs': {'mithril': 3000}, 'time_sec': 1051200},
        15: {'costs': {'mithril': 4000}, 'time_sec': 1054800},
        16: {'costs': {'mithril': 5000}, 'time_sec': 1058400},
        17: {'costs': {'mithril': 6000}, 'time_sec': 1062000},
        18: {'costs': {'mithril': 7000}, 'time_sec': 1065600},
        19: {'costs': {'mithril': 8000}, 'time_sec': 1069200},
        20: {'costs': {'mithril': 9000}, 'time_sec': 1072800},
        21: {'costs': {'mithril': 10000}, 'time_sec': 1076400},
        22: {'costs': {'mithril': 11000}, 'time_sec': 1080000},
        23: {'costs': {'mithril': 12000}, 'time_sec': 1083600},
        24: {'costs': {'mithril': 13000}, 'time_sec': 1087200},
        25: {'costs': {'mithril': 14000}, 'time_sec': 1090800},
        26: {'costs': {'mithril': 15000}, 'time_sec': 1094400},
        27: {'costs': {'mithril': 16000}, 'time_sec': 1098000},
        28: {'costs': {'mithril': 17000}, 'time_sec': 1101600},
        29: {'costs': {'mithril': 18000}, 'time_sec': 1105200},
        30: {'costs': {'mithril': 19000}, 'time_sec': 1108800},
        31: {'costs': {'mithril': 20000}, 'time_sec': 1112400},
        32: {'costs': {'mithril': 21000}, 'time_sec': 1116000},
        33: {'costs': {'mithril': 22000}, 'time_sec': 1119600},
        34: {'costs': {'mithril': 23000}, 'time_sec': 1123200},
        35: {'costs': {'mithril': 24000}, 'time_sec': 1126800},
        36: {'costs': {'mithril': 25000}, 'time_sec': 1130400},
        37: {'costs': {'mithril': 26000}, 'time_sec': 1134000},
        38: {'costs': {'mithril': 27000}, 'time_sec': 1137600},
        39: {'costs': {'mithril': 28000}, 'time_sec': 1141200},
        40: {'costs': {'mithril': 29000}, 'time_sec': 1144800},
    },
    'bl_clan_center': {
        1: {'costs': {'crystal': 100}, 'time_sec': 300},
        2: {'costs': {'crystal': 20000}, 'time_sec': 14400},
        3: {'costs': {'crystal': 65000}, 'time_sec': 72000},
        4: {'costs': {'crystal': 150000}, 'time_sec': 144000},
        5: {'costs': {'crystal': 300000}, 'time_sec': 259200},
        6: {'costs': {'crystal': 450000}, 'time_sec': 432000},
        7: {'costs': {'crystal': 550000}, 'time_sec': 604800},
        8: {'costs': {'crystal': 600000}, 'time_sec': 691200},
        9: {'costs': {'crystal': 900000}, 'time_sec': 864000},
        10: {'costs': {'crystal': 900000}, 'time_sec': 1036800},
    },
    'bl_crystal_mine': {
        1: {'costs': {'oil': 50}, 'time_sec': 60},
        2: {'costs': {'oil': 100}, 'time_sec': 300},
        3: {'costs': {'oil': 250}, 'time_sec': 900},
        4: {'costs': {'oil': 500}, 'time_sec': 3600},
        5: {'costs': {'oil': 1500}, 'time_sec': 10800},
        6: {'costs': {'oil': 3000}, 'time_sec': 43200},
        7: {'costs': {'oil': 5500}, 'time_sec': 86400},
        8: {'costs': {'oil': 8500}, 'time_sec': 172800},
        9: {'costs': {'oil': 17500}, 'time_sec': 259200},
        10: {'costs': {'oil': 35000}, 'time_sec': 345600},
        11: {'costs': {'oil': 250000}, 'time_sec': 432000},
        12: {'costs': {'oil': 265000, 'mithril': 250}, 'time_sec': 435600},
        13: {'costs': {'oil': 280000, 'mithril': 500}, 'time_sec': 439200},
        14: {'costs': {'oil': 295000, 'mithril': 750}, 'time_sec': 442800},
        15: {'costs': {'oil': 310000, 'mithril': 1000}, 'time_sec': 446400},
        16: {'costs': {'oil': 325000, 'mithril': 1250}, 'time_sec': 450000},
        17: {'costs': {'oil': 340000, 'mithril': 1500}, 'time_sec': 453600},
        18: {'costs': {'oil': 355000, 'mithril': 1750}, 'time_sec': 457200},
        19: {'costs': {'oil': 370000, 'mithril': 2000}, 'time_sec': 460800},
        20: {'costs': {'oil': 385000, 'mithril': 2500}, 'time_sec': 464400},
        21: {'costs': {'oil': 400000, 'mithril': 3000}, 'time_sec': 468000},
        22: {'costs': {'oil': 415000, 'mithril': 3500}, 'time_sec': 471600},
        23: {'costs': {'oil': 430000, 'mithril': 4000}, 'time_sec': 475200},
        24: {'costs': {'oil': 445000, 'mithril': 4500}, 'time_sec': 478800},
        25: {'costs': {'oil': 460000, 'mithril': 5000}, 'time_sec': 482400},
        26: {'costs': {'oil': 475000, 'mithril': 5500}, 'time_sec': 486000},
        27: {'costs': {'oil': 490000, 'mithril': 6000}, 'time_sec': 489600},
        28: {'costs': {'oil': 505000, 'mithril': 6500}, 'time_sec': 493200},
        29: {'costs': {'oil': 520000, 'mithril': 7000}, 'time_sec': 496800},
        30: {'costs': {'oil': 535000, 'mithril': 7500}, 'time_sec': 500400},
        31: {'costs': {'oil': 550000, 'mithril': 8000}, 'time_sec': 504000},
        32: {'costs': {'oil': 565000, 'mithril': 8500}, 'time_sec': 507600},
        33: {'costs': {'oil': 580000, 'mithril': 9000}, 'time_sec': 511200},
        34: {'costs': {'oil': 595000, 'mithril': 9500}, 'time_sec': 514800},
        35: {'costs': {'oil': 610000, 'mithril': 10000}, 'time_sec': 518400},
        36: {'costs': {'oil': 625000, 'mithril': 11000}, 'time_sec': 522000},
        37: {'costs': {'oil': 640000, 'mithril': 12000}, 'time_sec': 525600},
        38: {'costs': {'oil': 655000, 'mithril': 13000}, 'time_sec': 529200},
        39: {'costs': {'oil': 670000, 'mithril': 14000}, 'time_sec': 532800},
        40: {'costs': {'oil': 685000, 'mithril': 15000}, 'time_sec': 536400},
    },
    'bl_crystal_storage': {
        1: {'costs': {'oil': 50}, 'time_sec': 300},
        2: {'costs': {'oil': 150}, 'time_sec': 900},
        3: {'costs': {'oil': 350}, 'time_sec': 1800},
        4: {'costs': {'oil': 750}, 'time_sec': 3600},
        5: {'costs': {'oil': 1250}, 'time_sec': 7200},
        6: {'costs': {'oil': 2500}, 'time_sec': 10800},
        7: {'costs': {'oil': 5000}, 'time_sec': 21600},
        8: {'costs': {'oil': 12500}, 'time_sec': 43200},
        9: {'costs': {'oil': 25000}, 'time_sec': 86400},
        10: {'costs': {'oil': 50000}, 'time_sec': 172800},
        11: {'costs': {'mithril': 1000}, 'time_sec': 230400},
        12: {'costs': {'mithril': 1000}, 'time_sec': 234000},
        13: {'costs': {'mithril': 1000}, 'time_sec': 237600},
        14: {'costs': {'mithril': 1000}, 'time_sec': 241200},
        15: {'costs': {'mithril': 1000}, 'time_sec': 244800},
        16: {'costs': {'mithril': 1000}, 'time_sec': 248400},
        17: {'costs': {'mithril': 1000}, 'time_sec': 252000},
        18: {'costs': {'mithril': 1000}, 'time_sec': 255600},
        19: {'costs': {'mithril': 1000}, 'time_sec': 259200},
        20: {'costs': {'mithril': 1000}, 'time_sec': 262800},
        21: {'costs': {'mithril': 1000}, 'time_sec': 266400},
        22: {'costs': {'mithril': 1000}, 'time_sec': 270000},
        23: {'costs': {'mithril': 1000}, 'time_sec': 273600},
        24: {'costs': {'mithril': 1000}, 'time_sec': 277200},
        25: {'costs': {'mithril': 1000}, 'time_sec': 280800},
        26: {'costs': {'mithril': 1000}, 'time_sec': 284400},
        27: {'costs': {'mithril': 1000}, 'time_sec': 288000},
        28: {'costs': {'mithril': 1000}, 'time_sec': 291600},
        29: {'costs': {'mithril': 1000}, 'time_sec': 295200},
        30: {'costs': {'mithril': 1500}, 'time_sec': 298800},
        31: {'costs': {'mithril': 2000}, 'time_sec': 302400},
        32: {'costs': {'mithril': 2500}, 'time_sec': 306000},
        33: {'costs': {'mithril': 3000}, 'time_sec': 309600},
        34: {'costs': {'mithril': 3500}, 'time_sec': 313200},
        35: {'costs': {'mithril': 4000}, 'time_sec': 316800},
        36: {'costs': {'mithril': 4500}, 'time_sec': 320400},
        37: {'costs': {'mithril': 5000}, 'time_sec': 324000},
        38: {'costs': {'mithril': 5500}, 'time_sec': 327600},
        39: {'costs': {'mithril': 6000}, 'time_sec': 331200},
        40: {'costs': {'mithril': 7000}, 'time_sec': 334800},
    },
    'bl_guard_tower': {
        1: {'costs': {'oil': 100}, 'time_sec': 300},
        2: {'costs': {'oil': 2500}, 'time_sec': 3600},
        3: {'costs': {'oil': 10000}, 'time_sec': 43200},
        4: {'costs': {'oil': 25000}, 'time_sec': 86400},
        5: {'costs': {'oil': 75000}, 'time_sec': 259200},
        6: {'costs': {'oil': 125000}, 'time_sec': 345600},
        7: {'costs': {'oil': 250000}, 'time_sec': 432000},
        8: {'costs': {'oil': 375000}, 'time_sec': 518400},
        9: {'costs': {'oil': 750000}, 'time_sec': 604800},
        10: {'costs': {'oil': 1200000}, 'time_sec': 705600},
        11: {'costs': {'oil': 2300000, 'mithril': 6000}, 'time_sec': 864000},
        12: {'costs': {'oil': 2500000, 'mithril': 9000}, 'time_sec': 1036800},
        13: {'costs': {'oil': 3000000, 'mithril': 12000}, 'time_sec': 1209600},
    },
    'bl_hero_jaina_workshop': {
        1: {'costs': {'crystal': 100}, 'time_sec': 0},
    },
    'bl_hero_workshop': {
        1: {'costs': {'hglory': 100}, 'time_sec': 0},
        2: {'costs': {'hglory': 200}, 'time_sec': 7200},
        3: {'costs': {'hglory': 450}, 'time_sec': 36000},
        4: {'costs': {'hglory': 1250}, 'time_sec': 57600},
        5: {'costs': {'hglory': 2500}, 'time_sec': 86400},
        6: {'costs': {'hglory': 4250}, 'time_sec': 172800},
        7: {'costs': {'hglory': 6500}, 'time_sec': 345600},
        8: {'costs': {'hglory': 9000}, 'time_sec': 432000},
        9: {'costs': {'hglory': 11750}, 'time_sec': 518400},
        10: {'costs': {'hglory': 22500}, 'time_sec': 604800},
    },
    'bl_library': {
        1: {'costs': {'oil': 50}, 'time_sec': 1},
        2: {'costs': {'oil': 1000}, 'time_sec': 64800},
        3: {'costs': {'oil': 10000}, 'time_sec': 86400},
        4: {'costs': {'oil': 100000}, 'time_sec': 108000},
        5: {'costs': {'oil': 200000}, 'time_sec': 144000},
        6: {'costs': {'oil': 275000}, 'time_sec': 172800},
        7: {'costs': {'oil': 500000, 'mithril': 4500}, 'time_sec': 345600},
        8: {'costs': {'oil': 1000000, 'mithril': 10000}, 'time_sec': 604800},
        9: {'costs': {'oil': 1500000, 'mithril': 15000}, 'time_sec': 864000},
        10: {'costs': {'oil': 2000000, 'mithril': 25000}, 'time_sec': 1036800},
        11: {'costs': {'oil': 2400000, 'mithril': 30000}, 'time_sec': 1209600},
        12: {'costs': {'gold': 20}, 'time_sec': 518400},
    },
    'bl_mint_yard': {
        1: {'costs': {'gold': 300}, 'time_sec': 0},
        2: {'costs': {'gold': 305}, 'time_sec': 0},
        3: {'costs': {'gold': 310}, 'time_sec': 0},
        4: {'costs': {'gold': 315}, 'time_sec': 0},
        5: {'costs': {'gold': 320}, 'time_sec': 0},
        6: {'costs': {'gold': 325}, 'time_sec': 0},
        7: {'costs': {'gold': 330}, 'time_sec': 0},
        8: {'costs': {'gold': 335}, 'time_sec': 0},
        9: {'costs': {'gold': 340}, 'time_sec': 0},
        10: {'costs': {'gold': 345}, 'time_sec': 0},
        11: {'costs': {'gold': 350}, 'time_sec': 0},
        12: {'costs': {'gold': 355}, 'time_sec': 0},
        13: {'costs': {'gold': 360}, 'time_sec': 0},
        14: {'costs': {'gold': 365}, 'time_sec': 0},
        15: {'costs': {'gold': 370}, 'time_sec': 0},
        16: {'costs': {'gold': 375}, 'time_sec': 0},
        17: {'costs': {'gold': 380}, 'time_sec': 0},
        18: {'costs': {'gold': 385}, 'time_sec': 0},
        19: {'costs': {'gold': 390}, 'time_sec': 0},
        20: {'costs': {'gold': 395}, 'time_sec': 0},
        21: {'costs': {'gold': 400}, 'time_sec': 0},
        22: {'costs': {'gold': 405}, 'time_sec': 0},
        23: {'costs': {'gold': 410}, 'time_sec': 0},
        24: {'costs': {'gold': 415}, 'time_sec': 0},
        25: {'costs': {'gold': 420}, 'time_sec': 0},
        26: {'costs': {'gold': 425}, 'time_sec': 0},
        27: {'costs': {'gold': 430}, 'time_sec': 0},
        28: {'costs': {'gold': 435}, 'time_sec': 0},
        29: {'costs': {'gold': 440}, 'time_sec': 0},
        30: {'costs': {'gold': 450}, 'time_sec': 0},
        31: {'costs': {'gold': 460}, 'time_sec': 0},
        32: {'costs': {'gold': 470}, 'time_sec': 0},
        33: {'costs': {'gold': 480}, 'time_sec': 0},
        34: {'costs': {'gold': 490}, 'time_sec': 0},
        35: {'costs': {'gold': 500}, 'time_sec': 0},
        36: {'costs': {'gold': 510}, 'time_sec': 0},
        37: {'costs': {'gold': 520}, 'time_sec': 0},
        38: {'costs': {'gold': 530}, 'time_sec': 0},
        39: {'costs': {'gold': 540}, 'time_sec': 0},
        40: {'costs': {'gold': 550}, 'time_sec': 0},
        41: {'costs': {'gold': 560}, 'time_sec': 0},
        42: {'costs': {'gold': 570}, 'time_sec': 0},
        43: {'costs': {'gold': 580}, 'time_sec': 0},
        44: {'costs': {'gold': 590}, 'time_sec': 0},
        45: {'costs': {'gold': 600}, 'time_sec': 0},
        46: {'costs': {'gold': 610}, 'time_sec': 0},
        47: {'costs': {'gold': 620}, 'time_sec': 0},
        48: {'costs': {'gold': 630}, 'time_sec': 0},
        49: {'costs': {'gold': 640}, 'time_sec': 0},
        50: {'costs': {'gold': 650}, 'time_sec': 0},
        51: {'costs': {'gold': 660}, 'time_sec': 0},
        52: {'costs': {'gold': 670}, 'time_sec': 0},
        53: {'costs': {'gold': 680}, 'time_sec': 0},
        54: {'costs': {'gold': 690}, 'time_sec': 0},
        55: {'costs': {'gold': 700}, 'time_sec': 0},
        56: {'costs': {'gold': 710}, 'time_sec': 0},
        57: {'costs': {'gold': 720}, 'time_sec': 0},
        58: {'costs': {'gold': 730}, 'time_sec': 0},
        59: {'costs': {'gold': 740}, 'time_sec': 0},
        60: {'costs': {'gold': 750}, 'time_sec': 0},
        61: {'costs': {'gold': 760}, 'time_sec': 0},
        62: {'costs': {'gold': 770}, 'time_sec': 0},
        63: {'costs': {'gold': 780}, 'time_sec': 0},
        64: {'costs': {'gold': 790}, 'time_sec': 0},
        65: {'costs': {'gold': 800}, 'time_sec': 0},
        66: {'costs': {'gold': 810}, 'time_sec': 0},
        67: {'costs': {'gold': 820}, 'time_sec': 0},
        68: {'costs': {'gold': 830}, 'time_sec': 0},
        69: {'costs': {'gold': 840}, 'time_sec': 0},
        70: {'costs': {'gold': 850}, 'time_sec': 0},
        71: {'costs': {'gold': 860}, 'time_sec': 0},
        72: {'costs': {'gold': 870}, 'time_sec': 0},
        73: {'costs': {'gold': 880}, 'time_sec': 0},
        74: {'costs': {'gold': 890}, 'time_sec': 0},
        75: {'costs': {'gold': 900}, 'time_sec': 0},
        76: {'costs': {'gold': 910}, 'time_sec': 0},
        77: {'costs': {'gold': 920}, 'time_sec': 0},
        78: {'costs': {'gold': 930}, 'time_sec': 0},
        79: {'costs': {'gold': 940}, 'time_sec': 0},
        80: {'costs': {'gold': 950}, 'time_sec': 0},
        81: {'costs': {'gold': 960}, 'time_sec': 0},
        82: {'costs': {'gold': 970}, 'time_sec': 0},
        83: {'costs': {'gold': 980}, 'time_sec': 0},
        84: {'costs': {'gold': 990}, 'time_sec': 0},
        85: {'costs': {'gold': 1000}, 'time_sec': 0},
        86: {'costs': {'gold': 1010}, 'time_sec': 0},
        87: {'costs': {'gold': 1020}, 'time_sec': 0},
        88: {'costs': {'gold': 1030}, 'time_sec': 0},
        89: {'costs': {'gold': 1040}, 'time_sec': 0},
        90: {'costs': {'gold': 1050}, 'time_sec': 0},
        91: {'costs': {'gold': 1060}, 'time_sec': 0},
        92: {'costs': {'gold': 1070}, 'time_sec': 0},
        93: {'costs': {'gold': 1080}, 'time_sec': 0},
        94: {'costs': {'gold': 1090}, 'time_sec': 0},
        95: {'costs': {'gold': 1100}, 'time_sec': 0},
        96: {'costs': {'gold': 1110}, 'time_sec': 0},
        97: {'costs': {'gold': 1120}, 'time_sec': 0},
        98: {'costs': {'gold': 1130}, 'time_sec': 0},
        99: {'costs': {'gold': 1140}, 'time_sec': 0},
        100: {'costs': {'gold': 1150}, 'time_sec': 0},
        101: {'costs': {'gold': 1160}, 'time_sec': 0},
        102: {'costs': {'gold': 1170}, 'time_sec': 0},
        103: {'costs': {'gold': 1180}, 'time_sec': 0},
        104: {'costs': {'gold': 1190}, 'time_sec': 0},
        105: {'costs': {'gold': 1200}, 'time_sec': 0},
        106: {'costs': {'gold': 1210}, 'time_sec': 0},
        107: {'costs': {'gold': 1220}, 'time_sec': 0},
        108: {'costs': {'gold': 1230}, 'time_sec': 0},
        109: {'costs': {'gold': 1240}, 'time_sec': 0},
        110: {'costs': {'gold': 1250}, 'time_sec': 0},
        111: {'costs': {'gold': 1260}, 'time_sec': 0},
        112: {'costs': {'gold': 1270}, 'time_sec': 0},
        113: {'costs': {'gold': 1280}, 'time_sec': 0},
        114: {'costs': {'gold': 1290}, 'time_sec': 0},
        115: {'costs': {'gold': 1300}, 'time_sec': 0},
        116: {'costs': {'gold': 1310}, 'time_sec': 0},
        117: {'costs': {'gold': 1320}, 'time_sec': 0},
        118: {'costs': {'gold': 1330}, 'time_sec': 0},
        119: {'costs': {'gold': 1340}, 'time_sec': 0},
        120: {'costs': {'gold': 1350}, 'time_sec': 0},
        121: {'costs': {'gold': 1360}, 'time_sec': 0},
        122: {'costs': {'gold': 1370}, 'time_sec': 0},
        123: {'costs': {'gold': 1380}, 'time_sec': 0},
        124: {'costs': {'gold': 1390}, 'time_sec': 0},
        125: {'costs': {'gold': 1400}, 'time_sec': 0},
        126: {'costs': {'gold': 1410}, 'time_sec': 0},
        127: {'costs': {'gold': 1420}, 'time_sec': 0},
        128: {'costs': {'gold': 1430}, 'time_sec': 0},
        129: {'costs': {'gold': 1440}, 'time_sec': 0},
        130: {'costs': {'gold': 1450}, 'time_sec': 0},
        131: {'costs': {'gold': 1460}, 'time_sec': 0},
        132: {'costs': {'gold': 1470}, 'time_sec': 0},
        133: {'costs': {'gold': 1480}, 'time_sec': 0},
        134: {'costs': {'gold': 1490}, 'time_sec': 0},
        135: {'costs': {'gold': 1500}, 'time_sec': 0},
        136: {'costs': {'gold': 1510}, 'time_sec': 0},
        137: {'costs': {'gold': 1520}, 'time_sec': 0},
        138: {'costs': {'gold': 1530}, 'time_sec': 0},
        139: {'costs': {'gold': 1540}, 'time_sec': 0},
        140: {'costs': {'gold': 1550}, 'time_sec': 0},
        141: {'costs': {'gold': 1560}, 'time_sec': 0},
        142: {'costs': {'gold': 1570}, 'time_sec': 0},
        143: {'costs': {'gold': 1580}, 'time_sec': 0},
        144: {'costs': {'gold': 1590}, 'time_sec': 0},
        145: {'costs': {'gold': 1600}, 'time_sec': 0},
        146: {'costs': {'gold': 1610}, 'time_sec': 0},
        147: {'costs': {'gold': 1620}, 'time_sec': 0},
        148: {'costs': {'gold': 1630}, 'time_sec': 0},
        149: {'costs': {'gold': 1640}, 'time_sec': 0},
        150: {'costs': {'gold': 1650}, 'time_sec': 0},
        151: {'costs': {'gold': 1660}, 'time_sec': 0},
        152: {'costs': {'gold': 1670}, 'time_sec': 0},
        153: {'costs': {'gold': 1680}, 'time_sec': 0},
        154: {'costs': {'gold': 1690}, 'time_sec': 0},
        155: {'costs': {'gold': 1700}, 'time_sec': 0},
        156: {'costs': {'gold': 1710}, 'time_sec': 0},
        157: {'costs': {'gold': 1720}, 'time_sec': 0},
        158: {'costs': {'gold': 1730}, 'time_sec': 0},
        159: {'costs': {'gold': 1740}, 'time_sec': 0},
        160: {'costs': {'gold': 1750}, 'time_sec': 0},
        161: {'costs': {'gold': 1760}, 'time_sec': 0},
        162: {'costs': {'gold': 1770}, 'time_sec': 0},
        163: {'costs': {'gold': 1780}, 'time_sec': 0},
        164: {'costs': {'gold': 1790}, 'time_sec': 0},
        165: {'costs': {'gold': 1800}, 'time_sec': 0},
        166: {'costs': {'gold': 1810}, 'time_sec': 0},
        167: {'costs': {'gold': 1820}, 'time_sec': 0},
        168: {'costs': {'gold': 1830}, 'time_sec': 0},
        169: {'costs': {'gold': 1840}, 'time_sec': 0},
        170: {'costs': {'gold': 1850}, 'time_sec': 0},
        171: {'costs': {'gold': 1860}, 'time_sec': 0},
        172: {'costs': {'gold': 1870}, 'time_sec': 0},
        173: {'costs': {'gold': 1880}, 'time_sec': 0},
        174: {'costs': {'gold': 1890}, 'time_sec': 0},
        175: {'costs': {'gold': 1900}, 'time_sec': 0},
        176: {'costs': {'gold': 1910}, 'time_sec': 0},
        177: {'costs': {'gold': 1920}, 'time_sec': 0},
        178: {'costs': {'gold': 1930}, 'time_sec': 0},
        179: {'costs': {'gold': 1940}, 'time_sec': 0},
        180: {'costs': {'gold': 1950}, 'time_sec': 0},
        181: {'costs': {'gold': 1960}, 'time_sec': 0},
        182: {'costs': {'gold': 1970}, 'time_sec': 0},
        183: {'costs': {'gold': 1980}, 'time_sec': 0},
        184: {'costs': {'gold': 1990}, 'time_sec': 0},
        185: {'costs': {'gold': 2000}, 'time_sec': 0},
        186: {'costs': {'gold': 2010}, 'time_sec': 0},
        187: {'costs': {'gold': 2020}, 'time_sec': 0},
        188: {'costs': {'gold': 2030}, 'time_sec': 0},
        189: {'costs': {'gold': 2040}, 'time_sec': 0},
        190: {'costs': {'gold': 2050}, 'time_sec': 0},
        191: {'costs': {'gold': 2060}, 'time_sec': 0},
        192: {'costs': {'gold': 2070}, 'time_sec': 0},
        193: {'costs': {'gold': 2080}, 'time_sec': 0},
        194: {'costs': {'gold': 2090}, 'time_sec': 0},
        195: {'costs': {'gold': 2100}, 'time_sec': 0},
        196: {'costs': {'gold': 2110}, 'time_sec': 0},
        197: {'costs': {'gold': 2120}, 'time_sec': 0},
        198: {'costs': {'gold': 2130}, 'time_sec': 0},
        199: {'costs': {'gold': 2140}, 'time_sec': 0},
        200: {'costs': {'gold': 2150}, 'time_sec': 0},
        201: {'costs': {'gold': 2160}, 'time_sec': 0},
        202: {'costs': {'gold': 2170}, 'time_sec': 0},
        203: {'costs': {'gold': 2180}, 'time_sec': 0},
        204: {'costs': {'gold': 2190}, 'time_sec': 0},
        205: {'costs': {'gold': 2200}, 'time_sec': 0},
        206: {'costs': {'gold': 2210}, 'time_sec': 0},
        207: {'costs': {'gold': 2220}, 'time_sec': 0},
        208: {'costs': {'gold': 2230}, 'time_sec': 0},
        209: {'costs': {'gold': 2240}, 'time_sec': 0},
        210: {'costs': {'gold': 2250}, 'time_sec': 0},
        211: {'costs': {'gold': 2260}, 'time_sec': 0},
        212: {'costs': {'gold': 2270}, 'time_sec': 0},
        213: {'costs': {'gold': 2280}, 'time_sec': 0},
        214: {'costs': {'gold': 2290}, 'time_sec': 0},
        215: {'costs': {'gold': 2300}, 'time_sec': 0},
        216: {'costs': {'gold': 2310}, 'time_sec': 0},
        217: {'costs': {'gold': 2320}, 'time_sec': 0},
        218: {'costs': {'gold': 2330}, 'time_sec': 0},
        219: {'costs': {'gold': 2340}, 'time_sec': 0},
        220: {'costs': {'gold': 2350}, 'time_sec': 0},
        221: {'costs': {'gold': 2360}, 'time_sec': 0},
        222: {'costs': {'gold': 2370}, 'time_sec': 0},
        223: {'costs': {'gold': 2380}, 'time_sec': 0},
        224: {'costs': {'gold': 2390}, 'time_sec': 0},
        225: {'costs': {'gold': 2400}, 'time_sec': 0},
        226: {'costs': {'gold': 2410}, 'time_sec': 0},
        227: {'costs': {'gold': 2420}, 'time_sec': 0},
        228: {'costs': {'gold': 2430}, 'time_sec': 0},
        229: {'costs': {'gold': 2440}, 'time_sec': 0},
        230: {'costs': {'gold': 2450}, 'time_sec': 0},
        231: {'costs': {'gold': 2460}, 'time_sec': 0},
        232: {'costs': {'gold': 2470}, 'time_sec': 0},
        233: {'costs': {'gold': 2480}, 'time_sec': 0},
        234: {'costs': {'gold': 2490}, 'time_sec': 0},
        235: {'costs': {'gold': 2500}, 'time_sec': 0},
        236: {'costs': {'gold': 2510}, 'time_sec': 0},
        237: {'costs': {'gold': 2520}, 'time_sec': 0},
        238: {'costs': {'gold': 2530}, 'time_sec': 0},
        239: {'costs': {'gold': 2540}, 'time_sec': 0},
        240: {'costs': {'gold': 2550}, 'time_sec': 0},
        241: {'costs': {'gold': 2560}, 'time_sec': 0},
        242: {'costs': {'gold': 2570}, 'time_sec': 0},
        243: {'costs': {'gold': 2580}, 'time_sec': 0},
        244: {'costs': {'gold': 2590}, 'time_sec': 0},
        245: {'costs': {'gold': 2600}, 'time_sec': 0},
        246: {'costs': {'gold': 2610}, 'time_sec': 0},
        247: {'costs': {'gold': 2620}, 'time_sec': 0},
        248: {'costs': {'gold': 2630}, 'time_sec': 0},
        249: {'costs': {'gold': 2640}, 'time_sec': 0},
        250: {'costs': {'gold': 2650}, 'time_sec': 0},
        251: {'costs': {'gold': 2660}, 'time_sec': 0},
        252: {'costs': {'gold': 2670}, 'time_sec': 0},
        253: {'costs': {'gold': 2680}, 'time_sec': 0},
        254: {'costs': {'gold': 2690}, 'time_sec': 0},
        255: {'costs': {'gold': 2700}, 'time_sec': 0},
        256: {'costs': {'gold': 2710}, 'time_sec': 0},
        257: {'costs': {'gold': 2720}, 'time_sec': 0},
        258: {'costs': {'gold': 2730}, 'time_sec': 0},
        259: {'costs': {'gold': 2740}, 'time_sec': 0},
        260: {'costs': {'gold': 2750}, 'time_sec': 0},
        261: {'costs': {'gold': 2760}, 'time_sec': 0},
        262: {'costs': {'gold': 2770}, 'time_sec': 0},
        263: {'costs': {'gold': 2780}, 'time_sec': 0},
        264: {'costs': {'gold': 2790}, 'time_sec': 0},
        265: {'costs': {'gold': 2800}, 'time_sec': 0},
        266: {'costs': {'gold': 2810}, 'time_sec': 0},
        267: {'costs': {'gold': 2820}, 'time_sec': 0},
        268: {'costs': {'gold': 2830}, 'time_sec': 0},
        269: {'costs': {'gold': 2840}, 'time_sec': 0},
        270: {'costs': {'gold': 2850}, 'time_sec': 0},
        271: {'costs': {'gold': 2860}, 'time_sec': 0},
        272: {'costs': {'gold': 2870}, 'time_sec': 0},
        273: {'costs': {'gold': 2880}, 'time_sec': 0},
        274: {'costs': {'gold': 2890}, 'time_sec': 0},
        275: {'costs': {'gold': 2900}, 'time_sec': 0},
        276: {'costs': {'gold': 2910}, 'time_sec': 0},
        277: {'costs': {'gold': 2920}, 'time_sec': 0},
        278: {'costs': {'gold': 2930}, 'time_sec': 0},
        279: {'costs': {'gold': 2940}, 'time_sec': 0},
        280: {'costs': {'gold': 2950}, 'time_sec': 0},
        281: {'costs': {'gold': 2960}, 'time_sec': 0},
        282: {'costs': {'gold': 2970}, 'time_sec': 0},
        283: {'costs': {'gold': 2980}, 'time_sec': 0},
        284: {'costs': {'gold': 2990}, 'time_sec': 0},
        285: {'costs': {'gold': 3000}, 'time_sec': 0},
        286: {'costs': {'gold': 3010}, 'time_sec': 0},
        287: {'costs': {'gold': 3020}, 'time_sec': 0},
        288: {'costs': {'gold': 3030}, 'time_sec': 0},
        289: {'costs': {'gold': 3040}, 'time_sec': 0},
        290: {'costs': {'gold': 3050}, 'time_sec': 0},
        291: {'costs': {'gold': 3060}, 'time_sec': 0},
        292: {'costs': {'gold': 3070}, 'time_sec': 0},
        293: {'costs': {'gold': 3080}, 'time_sec': 0},
        294: {'costs': {'gold': 3090}, 'time_sec': 0},
        295: {'costs': {'gold': 3100}, 'time_sec': 0},
        296: {'costs': {'gold': 3110}, 'time_sec': 0},
        297: {'costs': {'gold': 3120}, 'time_sec': 0},
        298: {'costs': {'gold': 3130}, 'time_sec': 0},
        299: {'costs': {'gold': 3140}, 'time_sec': 0},
        300: {'costs': {'gold': 3150}, 'time_sec': 0},
        301: {'costs': {'gold': 3160}, 'time_sec': 0},
        302: {'costs': {'gold': 3170}, 'time_sec': 0},
        303: {'costs': {'gold': 3180}, 'time_sec': 0},
        304: {'costs': {'gold': 3190}, 'time_sec': 0},
        305: {'costs': {'gold': 3200}, 'time_sec': 0},
        306: {'costs': {'gold': 3210}, 'time_sec': 0},
        307: {'costs': {'gold': 3220}, 'time_sec': 0},
        308: {'costs': {'gold': 3230}, 'time_sec': 0},
        309: {'costs': {'gold': 3240}, 'time_sec': 0},
        310: {'costs': {'gold': 3250}, 'time_sec': 0},
        311: {'costs': {'gold': 3260}, 'time_sec': 0},
        312: {'costs': {'gold': 3270}, 'time_sec': 0},
        313: {'costs': {'gold': 3280}, 'time_sec': 0},
        314: {'costs': {'gold': 3290}, 'time_sec': 0},
        315: {'costs': {'gold': 3300}, 'time_sec': 0},
        316: {'costs': {'gold': 3310}, 'time_sec': 0},
        317: {'costs': {'gold': 3320}, 'time_sec': 0},
        318: {'costs': {'gold': 3330}, 'time_sec': 0},
        319: {'costs': {'gold': 3340}, 'time_sec': 0},
        320: {'costs': {'gold': 3350}, 'time_sec': 0},
        321: {'costs': {'gold': 3360}, 'time_sec': 0},
        322: {'costs': {'gold': 3370}, 'time_sec': 0},
        323: {'costs': {'gold': 3380}, 'time_sec': 0},
        324: {'costs': {'gold': 3390}, 'time_sec': 0},
        325: {'costs': {'gold': 3400}, 'time_sec': 0},
        326: {'costs': {'gold': 3410}, 'time_sec': 0},
        327: {'costs': {'gold': 3420}, 'time_sec': 0},
        328: {'costs': {'gold': 3430}, 'time_sec': 0},
        329: {'costs': {'gold': 3440}, 'time_sec': 0},
        330: {'costs': {'gold': 3450}, 'time_sec': 0},
        331: {'costs': {'gold': 3460}, 'time_sec': 0},
        332: {'costs': {'gold': 3470}, 'time_sec': 0},
        333: {'costs': {'gold': 3480}, 'time_sec': 0},
        334: {'costs': {'gold': 3490}, 'time_sec': 0},
        335: {'costs': {'gold': 3500}, 'time_sec': 0},
        336: {'costs': {'gold': 3510}, 'time_sec': 0},
        337: {'costs': {'gold': 3520}, 'time_sec': 0},
        338: {'costs': {'gold': 3530}, 'time_sec': 0},
        339: {'costs': {'gold': 3540}, 'time_sec': 0},
        340: {'costs': {'gold': 3550}, 'time_sec': 0},
        341: {'costs': {'gold': 3560}, 'time_sec': 0},
        342: {'costs': {'gold': 3570}, 'time_sec': 0},
        343: {'costs': {'gold': 3580}, 'time_sec': 0},
        344: {'costs': {'gold': 3590}, 'time_sec': 0},
        345: {'costs': {'gold': 3600}, 'time_sec': 0},
        346: {'costs': {'gold': 3610}, 'time_sec': 0},
        347: {'costs': {'gold': 3620}, 'time_sec': 0},
        348: {'costs': {'gold': 3630}, 'time_sec': 0},
        349: {'costs': {'gold': 3640}, 'time_sec': 0},
        350: {'costs': {'gold': 3650}, 'time_sec': 0},
        351: {'costs': {'gold': 3660}, 'time_sec': 0},
        352: {'costs': {'gold': 3670}, 'time_sec': 0},
        353: {'costs': {'gold': 3680}, 'time_sec': 0},
        354: {'costs': {'gold': 3690}, 'time_sec': 0},
        355: {'costs': {'gold': 3700}, 'time_sec': 0},
        356: {'costs': {'gold': 3710}, 'time_sec': 0},
        357: {'costs': {'gold': 3720}, 'time_sec': 0},
        358: {'costs': {'gold': 3730}, 'time_sec': 0},
        359: {'costs': {'gold': 3740}, 'time_sec': 0},
        360: {'costs': {'gold': 3750}, 'time_sec': 0},
        361: {'costs': {'gold': 3760}, 'time_sec': 0},
        362: {'costs': {'gold': 3770}, 'time_sec': 0},
        363: {'costs': {'gold': 3780}, 'time_sec': 0},
        364: {'costs': {'gold': 3790}, 'time_sec': 0},
        365: {'costs': {'gold': 3800}, 'time_sec': 0},
        366: {'costs': {'gold': 3810}, 'time_sec': 0},
        367: {'costs': {'gold': 3820}, 'time_sec': 0},
        368: {'costs': {'gold': 3830}, 'time_sec': 0},
        369: {'costs': {'gold': 3840}, 'time_sec': 0},
        370: {'costs': {'gold': 3850}, 'time_sec': 0},
        371: {'costs': {'gold': 3860}, 'time_sec': 0},
        372: {'costs': {'gold': 3870}, 'time_sec': 0},
        373: {'costs': {'gold': 3880}, 'time_sec': 0},
        374: {'costs': {'gold': 3890}, 'time_sec': 0},
        375: {'costs': {'gold': 3900}, 'time_sec': 0},
        376: {'costs': {'gold': 3910}, 'time_sec': 0},
        377: {'costs': {'gold': 3920}, 'time_sec': 0},
        378: {'costs': {'gold': 3930}, 'time_sec': 0},
        379: {'costs': {'gold': 3940}, 'time_sec': 0},
        380: {'costs': {'gold': 3950}, 'time_sec': 0},
        381: {'costs': {'gold': 3960}, 'time_sec': 0},
        382: {'costs': {'gold': 3970}, 'time_sec': 0},
        383: {'costs': {'gold': 3980}, 'time_sec': 0},
        384: {'costs': {'gold': 3990}, 'time_sec': 0},
        385: {'costs': {'gold': 4000}, 'time_sec': 0},
        386: {'costs': {'gold': 4010}, 'time_sec': 0},
        387: {'costs': {'gold': 4020}, 'time_sec': 0},
        388: {'costs': {'gold': 4030}, 'time_sec': 0},
        389: {'costs': {'gold': 4040}, 'time_sec': 0},
        390: {'costs': {'gold': 4050}, 'time_sec': 0},
        391: {'costs': {'gold': 4060}, 'time_sec': 0},
        392: {'costs': {'gold': 4070}, 'time_sec': 0},
        393: {'costs': {'gold': 4080}, 'time_sec': 0},
        394: {'costs': {'gold': 4090}, 'time_sec': 0},
        395: {'costs': {'gold': 4100}, 'time_sec': 0},
        396: {'costs': {'gold': 4110}, 'time_sec': 0},
        397: {'costs': {'gold': 4120}, 'time_sec': 0},
        398: {'costs': {'gold': 4130}, 'time_sec': 0},
        399: {'costs': {'gold': 4140}, 'time_sec': 0},
        400: {'costs': {'gold': 4150}, 'time_sec': 0},
        401: {'costs': {'gold': 4160}, 'time_sec': 0},
        402: {'costs': {'gold': 4170}, 'time_sec': 0},
        403: {'costs': {'gold': 4180}, 'time_sec': 0},
        404: {'costs': {'gold': 4190}, 'time_sec': 0},
        405: {'costs': {'gold': 4200}, 'time_sec': 0},
        406: {'costs': {'gold': 4210}, 'time_sec': 0},
        407: {'costs': {'gold': 4220}, 'time_sec': 0},
        408: {'costs': {'gold': 4230}, 'time_sec': 0},
        409: {'costs': {'gold': 4240}, 'time_sec': 0},
        410: {'costs': {'gold': 4250}, 'time_sec': 0},
        411: {'costs': {'gold': 4260}, 'time_sec': 0},
        412: {'costs': {'gold': 4270}, 'time_sec': 0},
        413: {'costs': {'gold': 4280}, 'time_sec': 0},
        414: {'costs': {'gold': 4290}, 'time_sec': 0},
        415: {'costs': {'gold': 4300}, 'time_sec': 0},
        416: {'costs': {'gold': 4310}, 'time_sec': 0},
        417: {'costs': {'gold': 4320}, 'time_sec': 0},
        418: {'costs': {'gold': 4330}, 'time_sec': 0},
        419: {'costs': {'gold': 4340}, 'time_sec': 0},
        420: {'costs': {'gold': 4350}, 'time_sec': 0},
        421: {'costs': {'gold': 4360}, 'time_sec': 0},
        422: {'costs': {'gold': 4370}, 'time_sec': 0},
        423: {'costs': {'gold': 4380}, 'time_sec': 0},
        424: {'costs': {'gold': 4390}, 'time_sec': 0},
        425: {'costs': {'gold': 4400}, 'time_sec': 0},
        426: {'costs': {'gold': 4410}, 'time_sec': 0},
        427: {'costs': {'gold': 4420}, 'time_sec': 0},
        428: {'costs': {'gold': 4430}, 'time_sec': 0},
        429: {'costs': {'gold': 4440}, 'time_sec': 0},
        430: {'costs': {'gold': 4450}, 'time_sec': 0},
        431: {'costs': {'gold': 4460}, 'time_sec': 0},
        432: {'costs': {'gold': 4470}, 'time_sec': 0},
        433: {'costs': {'gold': 4480}, 'time_sec': 0},
        434: {'costs': {'gold': 4490}, 'time_sec': 0},
        435: {'costs': {'gold': 4500}, 'time_sec': 0},
        436: {'costs': {'gold': 4510}, 'time_sec': 0},
        437: {'costs': {'gold': 4520}, 'time_sec': 0},
        438: {'costs': {'gold': 4530}, 'time_sec': 0},
        439: {'costs': {'gold': 4540}, 'time_sec': 0},
        440: {'costs': {'gold': 4550}, 'time_sec': 0},
        441: {'costs': {'gold': 4560}, 'time_sec': 0},
        442: {'costs': {'gold': 4570}, 'time_sec': 0},
        443: {'costs': {'gold': 4580}, 'time_sec': 0},
        444: {'costs': {'gold': 4590}, 'time_sec': 0},
        445: {'costs': {'gold': 4600}, 'time_sec': 0},
        446: {'costs': {'gold': 4610}, 'time_sec': 0},
        447: {'costs': {'gold': 4620}, 'time_sec': 0},
        448: {'costs': {'gold': 4630}, 'time_sec': 0},
        449: {'costs': {'gold': 4640}, 'time_sec': 0},
        450: {'costs': {'gold': 4650}, 'time_sec': 0},
        451: {'costs': {'gold': 4660}, 'time_sec': 0},
        452: {'costs': {'gold': 4670}, 'time_sec': 0},
        453: {'costs': {'gold': 4680}, 'time_sec': 0},
        454: {'costs': {'gold': 4690}, 'time_sec': 0},
        455: {'costs': {'gold': 4700}, 'time_sec': 0},
        456: {'costs': {'gold': 4710}, 'time_sec': 0},
        457: {'costs': {'gold': 4720}, 'time_sec': 0},
        458: {'costs': {'gold': 4730}, 'time_sec': 0},
        459: {'costs': {'gold': 4740}, 'time_sec': 0},
        460: {'costs': {'gold': 4750}, 'time_sec': 0},
        461: {'costs': {'gold': 4760}, 'time_sec': 0},
        462: {'costs': {'gold': 4770}, 'time_sec': 0},
        463: {'costs': {'gold': 4780}, 'time_sec': 0},
        464: {'costs': {'gold': 4790}, 'time_sec': 0},
        465: {'costs': {'gold': 4800}, 'time_sec': 0},
        466: {'costs': {'gold': 4810}, 'time_sec': 0},
        467: {'costs': {'gold': 4820}, 'time_sec': 0},
        468: {'costs': {'gold': 4830}, 'time_sec': 0},
        469: {'costs': {'gold': 4840}, 'time_sec': 0},
        470: {'costs': {'gold': 4850}, 'time_sec': 0},
        471: {'costs': {'gold': 4860}, 'time_sec': 0},
        472: {'costs': {'gold': 4870}, 'time_sec': 0},
        473: {'costs': {'gold': 4880}, 'time_sec': 0},
        474: {'costs': {'gold': 4890}, 'time_sec': 0},
        475: {'costs': {'gold': 4900}, 'time_sec': 0},
        476: {'costs': {'gold': 4910}, 'time_sec': 0},
        477: {'costs': {'gold': 4920}, 'time_sec': 0},
        478: {'costs': {'gold': 4930}, 'time_sec': 0},
        479: {'costs': {'gold': 4940}, 'time_sec': 0},
        480: {'costs': {'gold': 4950}, 'time_sec': 0},
        481: {'costs': {'gold': 4960}, 'time_sec': 0},
        482: {'costs': {'gold': 4970}, 'time_sec': 0},
        483: {'costs': {'gold': 4980}, 'time_sec': 0},
        484: {'costs': {'gold': 4990}, 'time_sec': 0},
        485: {'costs': {'gold': 5000}, 'time_sec': 0},
        486: {'costs': {'gold': 5010}, 'time_sec': 0},
        487: {'costs': {'gold': 5020}, 'time_sec': 0},
        488: {'costs': {'gold': 5030}, 'time_sec': 0},
        489: {'costs': {'gold': 5040}, 'time_sec': 0},
        490: {'costs': {'gold': 5050}, 'time_sec': 0},
        491: {'costs': {'gold': 5060}, 'time_sec': 0},
        492: {'costs': {'gold': 5070}, 'time_sec': 0},
        493: {'costs': {'gold': 5080}, 'time_sec': 0},
        494: {'costs': {'gold': 5090}, 'time_sec': 0},
        495: {'costs': {'gold': 5100}, 'time_sec': 0},
        496: {'costs': {'gold': 5110}, 'time_sec': 0},
        497: {'costs': {'gold': 5120}, 'time_sec': 0},
        498: {'costs': {'gold': 5130}, 'time_sec': 0},
        499: {'costs': {'gold': 5140}, 'time_sec': 0},
        500: {'costs': {'gold': 5150}, 'time_sec': 0},
    },
    'bl_oil_storage': {
        1: {'costs': {'crystal': 50}, 'time_sec': 300},
        2: {'costs': {'crystal': 150}, 'time_sec': 900},
        3: {'costs': {'crystal': 350}, 'time_sec': 1800},
        4: {'costs': {'crystal': 750}, 'time_sec': 3600},
        5: {'costs': {'crystal': 1250}, 'time_sec': 7200},
        6: {'costs': {'crystal': 2500}, 'time_sec': 10800},
        7: {'costs': {'crystal': 5000}, 'time_sec': 21600},
        8: {'costs': {'crystal': 12500}, 'time_sec': 43200},
        9: {'costs': {'crystal': 25000}, 'time_sec': 86400},
        10: {'costs': {'crystal': 50000}, 'time_sec': 172800},
        11: {'costs': {'mithril': 1000}, 'time_sec': 230400},
        12: {'costs': {'mithril': 1000}, 'time_sec': 234000},
        13: {'costs': {'mithril': 1000}, 'time_sec': 237600},
        14: {'costs': {'mithril': 1000}, 'time_sec': 241200},
        15: {'costs': {'mithril': 1000}, 'time_sec': 244800},
        16: {'costs': {'mithril': 1000}, 'time_sec': 248400},
        17: {'costs': {'mithril': 1000}, 'time_sec': 252000},
        18: {'costs': {'mithril': 1000}, 'time_sec': 255600},
        19: {'costs': {'mithril': 1000}, 'time_sec': 259200},
        20: {'costs': {'mithril': 1000}, 'time_sec': 262800},
        21: {'costs': {'mithril': 1000}, 'time_sec': 266400},
        22: {'costs': {'mithril': 1000}, 'time_sec': 270000},
        23: {'costs': {'mithril': 1000}, 'time_sec': 273600},
        24: {'costs': {'mithril': 1000}, 'time_sec': 277200},
        25: {'costs': {'mithril': 1000}, 'time_sec': 280800},
        26: {'costs': {'mithril': 1000}, 'time_sec': 284400},
        27: {'costs': {'mithril': 1000}, 'time_sec': 288000},
        28: {'costs': {'mithril': 1000}, 'time_sec': 291600},
        29: {'costs': {'mithril': 1000}, 'time_sec': 295200},
        30: {'costs': {'mithril': 1500}, 'time_sec': 298800},
        31: {'costs': {'mithril': 2000}, 'time_sec': 302400},
        32: {'costs': {'mithril': 2500}, 'time_sec': 306000},
        33: {'costs': {'mithril': 3000}, 'time_sec': 309600},
        34: {'costs': {'mithril': 3500}, 'time_sec': 313200},
        35: {'costs': {'mithril': 4000}, 'time_sec': 316800},
        36: {'costs': {'mithril': 4500}, 'time_sec': 320400},
        37: {'costs': {'mithril': 5000}, 'time_sec': 324000},
        38: {'costs': {'mithril': 5500}, 'time_sec': 327600},
        39: {'costs': {'mithril': 6000}, 'time_sec': 331200},
        40: {'costs': {'mithril': 7000}, 'time_sec': 334800},
    },
    'bl_oil_tower': {
        1: {'costs': {'crystal': 50}, 'time_sec': 60},
        2: {'costs': {'crystal': 100}, 'time_sec': 300},
        3: {'costs': {'crystal': 250}, 'time_sec': 900},
        4: {'costs': {'crystal': 500}, 'time_sec': 3600},
        5: {'costs': {'crystal': 1500}, 'time_sec': 10800},
        6: {'costs': {'crystal': 3000}, 'time_sec': 43200},
        7: {'costs': {'crystal': 5500}, 'time_sec': 86400},
        8: {'costs': {'crystal': 8500}, 'time_sec': 172800},
        9: {'costs': {'crystal': 17500}, 'time_sec': 259200},
        10: {'costs': {'crystal': 35000}, 'time_sec': 345600},
        11: {'costs': {'crystal': 250000}, 'time_sec': 432000},
        12: {'costs': {'crystal': 265000, 'mithril': 250}, 'time_sec': 435600},
        13: {'costs': {'crystal': 280000, 'mithril': 500}, 'time_sec': 439200},
        14: {'costs': {'crystal': 295000, 'mithril': 750}, 'time_sec': 442800},
        15: {'costs': {'crystal': 310000, 'mithril': 1000}, 'time_sec': 446400},
        16: {'costs': {'crystal': 325000, 'mithril': 1250}, 'time_sec': 450000},
        17: {'costs': {'crystal': 340000, 'mithril': 1500}, 'time_sec': 453600},
        18: {'costs': {'crystal': 355000, 'mithril': 1750}, 'time_sec': 457200},
        19: {'costs': {'crystal': 370000, 'mithril': 2000}, 'time_sec': 460800},
        20: {'costs': {'crystal': 385000, 'mithril': 2500}, 'time_sec': 464400},
        21: {'costs': {'crystal': 400000, 'mithril': 3000}, 'time_sec': 468000},
        22: {'costs': {'crystal': 415000, 'mithril': 3500}, 'time_sec': 471600},
        23: {'costs': {'crystal': 430000, 'mithril': 4000}, 'time_sec': 475200},
        24: {'costs': {'crystal': 445000, 'mithril': 4500}, 'time_sec': 478800},
        25: {'costs': {'crystal': 460000, 'mithril': 5000}, 'time_sec': 482400},
        26: {'costs': {'crystal': 475000, 'mithril': 5500}, 'time_sec': 486000},
        27: {'costs': {'crystal': 490000, 'mithril': 6000}, 'time_sec': 489600},
        28: {'costs': {'crystal': 505000, 'mithril': 6500}, 'time_sec': 493200},
        29: {'costs': {'crystal': 520000, 'mithril': 7000}, 'time_sec': 496800},
        30: {'costs': {'crystal': 535000, 'mithril': 7500}, 'time_sec': 500400},
        31: {'costs': {'crystal': 550000, 'mithril': 8000}, 'time_sec': 504000},
        32: {'costs': {'crystal': 565000, 'mithril': 8500}, 'time_sec': 507600},
        33: {'costs': {'crystal': 580000, 'mithril': 9000}, 'time_sec': 511200},
        34: {'costs': {'crystal': 595000, 'mithril': 9500}, 'time_sec': 514800},
        35: {'costs': {'crystal': 610000, 'mithril': 10000}, 'time_sec': 518400},
        36: {'costs': {'crystal': 625000, 'mithril': 11000}, 'time_sec': 522000},
        37: {'costs': {'crystal': 640000, 'mithril': 12000}, 'time_sec': 525600},
        38: {'costs': {'crystal': 655000, 'mithril': 13000}, 'time_sec': 529200},
        39: {'costs': {'crystal': 670000, 'mithril': 14000}, 'time_sec': 532800},
        40: {'costs': {'crystal': 685000, 'mithril': 15000}, 'time_sec': 536400},
    },
    'bl_portal': {
        1: {'costs': {'crystal': 100}, 'time_sec': 1},
        2: {'costs': {'oil': 1800000, 'mithril': 8000}, 'time_sec': 345600},
    },
    'bl_power_plant': {
        1: {'costs': {'oil': 50}, 'time_sec': 300},
        2: {'costs': {'oil': 125}, 'time_sec': 600},
        3: {'costs': {'oil': 500}, 'time_sec': 900},
        4: {'costs': {'oil': 1000}, 'time_sec': 1200},
        5: {'costs': {'oil': 2500}, 'time_sec': 1800},
        6: {'costs': {'oil': 5000}, 'time_sec': 2700},
        7: {'costs': {'oil': 15000}, 'time_sec': 3600},
        8: {'costs': {'oil': 35000}, 'time_sec': 5400},
        9: {'costs': {'oil': 72500}, 'time_sec': 7200},
        10: {'costs': {'oil': 100000}, 'time_sec': 9000},
        11: {'costs': {'oil': 125000}, 'time_sec': 10800},
        12: {'costs': {'oil': 150000}, 'time_sec': 21600},
        13: {'costs': {'oil': 175000}, 'time_sec': 28800},
        14: {'costs': {'oil': 250000}, 'time_sec': 36000},
        15: {'costs': {'oil': 425000}, 'time_sec': 50400},
        16: {'costs': {'oil': 460000, 'mithril': 500}, 'time_sec': 64800},
        17: {'costs': {'oil': 495000, 'mithril': 500}, 'time_sec': 68400},
        18: {'costs': {'oil': 530000, 'mithril': 500}, 'time_sec': 72000},
        19: {'costs': {'oil': 565000, 'mithril': 500}, 'time_sec': 75600},
        20: {'costs': {'oil': 600000, 'mithril': 500}, 'time_sec': 79200},
        21: {'costs': {'oil': 635000, 'mithril': 500}, 'time_sec': 82800},
        22: {'costs': {'oil': 670000, 'mithril': 500}, 'time_sec': 86400},
        23: {'costs': {'oil': 705000, 'mithril': 500}, 'time_sec': 90000},
        24: {'costs': {'oil': 740000, 'mithril': 500}, 'time_sec': 93600},
        25: {'costs': {'oil': 775000, 'mithril': 500}, 'time_sec': 97200},
        26: {'costs': {'oil': 810000, 'mithril': 500}, 'time_sec': 100800},
        27: {'costs': {'oil': 845000, 'mithril': 500}, 'time_sec': 104400},
        28: {'costs': {'oil': 880000, 'mithril': 500}, 'time_sec': 108000},
        29: {'costs': {'oil': 915000, 'mithril': 500}, 'time_sec': 111600},
        30: {'costs': {'oil': 950000, 'mithril': 500}, 'time_sec': 115200},
        31: {'costs': {'oil': 985000, 'mithril': 500}, 'time_sec': 118800},
        32: {'costs': {'oil': 1020000, 'mithril': 500}, 'time_sec': 122400},
        33: {'costs': {'oil': 1055000, 'mithril': 500}, 'time_sec': 126000},
        34: {'costs': {'oil': 1090000, 'mithril': 500}, 'time_sec': 129600},
        35: {'costs': {'oil': 1125000, 'mithril': 500}, 'time_sec': 133200},
        36: {'costs': {'oil': 1160000, 'mithril': 500}, 'time_sec': 136800},
        37: {'costs': {'oil': 1195000, 'mithril': 500}, 'time_sec': 140400},
        38: {'costs': {'oil': 1230000, 'mithril': 500}, 'time_sec': 144000},
        39: {'costs': {'oil': 1265000, 'mithril': 500}, 'time_sec': 147600},
        40: {'costs': {'oil': 1300000, 'mithril': 500}, 'time_sec': 151200},
    },
    'bl_research_center': {
        1: {'costs': {'gold': 20}, 'time_sec': 300},
        2: {'costs': {'gold': 20}, 'time_sec': 300},
        3: {'costs': {'gold': 20}, 'time_sec': 300},
        4: {'costs': {'gold': 20}, 'time_sec': 300},
        5: {'costs': {'gold': 20}, 'time_sec': 300},
        6: {'costs': {'gold': 20}, 'time_sec': 300},
        7: {'costs': {'gold': 20}, 'time_sec': 300},
        8: {'costs': {'gold': 20}, 'time_sec': 300},
        9: {'costs': {'gold': 20}, 'time_sec': 300},
        10: {'costs': {'gold': 20}, 'time_sec': 300},
    },
    'bl_ruby_mine': {
        1: {'costs': {'oil': 2500}, 'time_sec': 300},
        2: {'costs': {'oil': 30000}, 'time_sec': 43200},
        3: {'costs': {'oil': 95000}, 'time_sec': 86400},
        4: {'costs': {'oil': 320000}, 'time_sec': 172800},
        5: {'costs': {'oil': 530000}, 'time_sec': 259200},
        6: {'costs': {'oil': 810000}, 'time_sec': 388800},
        7: {'costs': {'oil': 1200000, 'mithril': 5000}, 'time_sec': 518400},
        8: {'costs': {'oil': 1600000, 'mithril': 15000}, 'time_sec': 691200},
        9: {'costs': {'oil': 2100000, 'mithril': 25000}, 'time_sec': 864000},
    },
    'bl_scouting_hh': {
        1: {'costs': {'oil': 2500}, 'time_sec': 900},
    },
    'bl_shield_generator': {
        1: {'costs': {'crystal': 12500}, 'time_sec': 72000},
        2: {'costs': {'gold': 500}, 'time_sec': 0},
    },
    'bl_town_hall': {
        1: {'costs': {'crystal': 100}, 'time_sec': 0},
        2: {'costs': {'crystal': 100}, 'time_sec': 60},
        3: {'costs': {'crystal': 1000}, 'time_sec': 1800},
        4: {'costs': {'crystal': 8500}, 'time_sec': 64800},
        5: {'costs': {'crystal': 82500}, 'time_sec': 129600},
        6: {'costs': {'crystal': 175000}, 'time_sec': 259200},
        7: {'costs': {'crystal': 285000}, 'time_sec': 432000},
        8: {'costs': {'crystal': 450000}, 'time_sec': 518400},
        9: {'costs': {'crystal': 750000}, 'time_sec': 691200},
        10: {'costs': {'crystal': 1000000}, 'time_sec': 777600},
        11: {'costs': {'crystal': 1200000}, 'time_sec': 864000},
        12: {'costs': {'crystal': 2000000, 'mithril': 30000}, 'time_sec': 936000},
    },
    # ── ПУШКИ ─────────────────────────────────────────────────────────────────
    'cn_air': {
        1: {'costs': {'crystal': 3000}, 'time_sec': 3000},
        2: {'costs': {'crystal': 9000}, 'time_sec': 57600},
        3: {'costs': {'crystal': 18000}, 'time_sec': 129600},
        4: {'costs': {'crystal': 36000}, 'time_sec': 259200},
        5: {'costs': {'crystal': 72000}, 'time_sec': 345600},
        6: {'costs': {'crystal': 144000}, 'time_sec': 432000},
        7: {'costs': {'crystal': 288000}, 'time_sec': 518400},
        8: {'costs': {'crystal': 576000}, 'time_sec': 604800},
        9: {'costs': {'crystal': 625000, 'mithril': 1000}, 'time_sec': 608400},
        10: {'costs': {'crystal': 675000, 'mithril': 1000}, 'time_sec': 612000},
        11: {'costs': {'crystal': 725000, 'mithril': 1000}, 'time_sec': 615600},
        12: {'costs': {'crystal': 775000, 'mithril': 1000}, 'time_sec': 619200},
        13: {'costs': {'crystal': 825000, 'mithril': 2000}, 'time_sec': 622800},
        14: {'costs': {'crystal': 875000, 'mithril': 2000}, 'time_sec': 626400},
        15: {'costs': {'crystal': 925000, 'mithril': 2000}, 'time_sec': 630000},
        16: {'costs': {'crystal': 975000, 'mithril': 2000}, 'time_sec': 633600},
        17: {'costs': {'crystal': 1025000, 'mithril': 5000}, 'time_sec': 637200},
        18: {'costs': {'crystal': 1075000, 'mithril': 5000}, 'time_sec': 640800},
        19: {'costs': {'crystal': 1125000, 'mithril': 5000}, 'time_sec': 644400},
        20: {'costs': {'crystal': 1175000, 'mithril': 5000}, 'time_sec': 648000},
        21: {'costs': {'crystal': 1225000, 'mithril': 10000}, 'time_sec': 651600},
        22: {'costs': {'crystal': 1275000, 'mithril': 10000}, 'time_sec': 655200},
        23: {'costs': {'crystal': 1325000, 'mithril': 10000}, 'time_sec': 658800},
        24: {'costs': {'crystal': 1375000, 'mithril': 10000}, 'time_sec': 662400},
        25: {'costs': {'crystal': 1425000, 'mithril': 15000}, 'time_sec': 666000},
        26: {'costs': {'crystal': 1475000, 'mithril': 15000}, 'time_sec': 669600},
        27: {'costs': {'crystal': 1525000, 'mithril': 15000}, 'time_sec': 673200},
        28: {'costs': {'crystal': 1575000, 'mithril': 15000}, 'time_sec': 676800},
        29: {'costs': {'crystal': 1625000, 'mithril': 20000}, 'time_sec': 680400},
        30: {'costs': {'crystal': 1675000, 'mithril': 20000}, 'time_sec': 684000},
        31: {'costs': {'crystal': 1725000, 'mithril': 20000}, 'time_sec': 687600},
        32: {'costs': {'crystal': 1775000, 'mithril': 20000}, 'time_sec': 691200},
        33: {'costs': {'crystal': 1825000, 'mithril': 25000}, 'time_sec': 694800},
        34: {'costs': {'crystal': 1875000, 'mithril': 25000}, 'time_sec': 698400},
        35: {'costs': {'crystal': 1925000, 'mithril': 25000}, 'time_sec': 702000},
        36: {'costs': {'crystal': 1975000, 'mithril': 25000}, 'time_sec': 705600},
        37: {'costs': {'crystal': 2025000, 'mithril': 30000}, 'time_sec': 709200},
        38: {'costs': {'crystal': 2075000, 'mithril': 30000}, 'time_sec': 712800},
        39: {'costs': {'crystal': 2125000, 'mithril': 30000}, 'time_sec': 716400},
        40: {'costs': {'crystal': 2175000, 'mithril': 30000}, 'time_sec': 720000},
    },
    'cn_ballista': {
        1: {'costs': {'crystal': 35}, 'time_sec': 60},
        2: {'costs': {'crystal': 100}, 'time_sec': 600},
        3: {'costs': {'crystal': 350}, 'time_sec': 3000},
        4: {'costs': {'crystal': 3500}, 'time_sec': 9000},
        5: {'costs': {'crystal': 9500}, 'time_sec': 27000},
        6: {'costs': {'crystal': 34500}, 'time_sec': 54000},
        7: {'costs': {'crystal': 65000}, 'time_sec': 108000},
        8: {'costs': {'crystal': 96000}, 'time_sec': 216000},
        9: {'costs': {'crystal': 192000}, 'time_sec': 324000},
        10: {'costs': {'crystal': 364000}, 'time_sec': 486000},
        11: {'costs': {'crystal': 768000}, 'time_sec': 540000},
        12: {'costs': {'crystal': 815000, 'mithril': 500}, 'time_sec': 543600},
        13: {'costs': {'crystal': 865000, 'mithril': 1000}, 'time_sec': 547200},
        14: {'costs': {'crystal': 900000, 'mithril': 1000}, 'time_sec': 550800},
        15: {'costs': {'crystal': 950000, 'mithril': 1000}, 'time_sec': 554400},
        16: {'costs': {'crystal': 1000000, 'mithril': 1000}, 'time_sec': 558000},
        17: {'costs': {'crystal': 1050000, 'mithril': 2000}, 'time_sec': 561600},
        18: {'costs': {'crystal': 1100000, 'mithril': 2000}, 'time_sec': 565200},
        19: {'costs': {'crystal': 1150000, 'mithril': 2000}, 'time_sec': 568800},
        20: {'costs': {'crystal': 1200000, 'mithril': 2000}, 'time_sec': 572400},
        21: {'costs': {'crystal': 1250000, 'mithril': 5000}, 'time_sec': 576000},
        22: {'costs': {'crystal': 1300000, 'mithril': 5000}, 'time_sec': 579600},
        23: {'costs': {'crystal': 1350000, 'mithril': 5000}, 'time_sec': 583200},
        24: {'costs': {'crystal': 1400000, 'mithril': 5000}, 'time_sec': 586800},
        25: {'costs': {'crystal': 1450000, 'mithril': 10000}, 'time_sec': 590400},
        26: {'costs': {'crystal': 1500000, 'mithril': 10000}, 'time_sec': 594000},
        27: {'costs': {'crystal': 1550000, 'mithril': 10000}, 'time_sec': 597600},
        28: {'costs': {'crystal': 1600000, 'mithril': 10000}, 'time_sec': 601200},
        29: {'costs': {'crystal': 1650000, 'mithril': 15000}, 'time_sec': 604800},
        30: {'costs': {'crystal': 1700000, 'mithril': 15000}, 'time_sec': 608400},
        31: {'costs': {'crystal': 1750000, 'mithril': 15000}, 'time_sec': 612000},
        32: {'costs': {'crystal': 1800000, 'mithril': 15000}, 'time_sec': 615600},
        33: {'costs': {'crystal': 1850000, 'mithril': 20000}, 'time_sec': 619200},
        34: {'costs': {'crystal': 1900000, 'mithril': 20000}, 'time_sec': 622800},
        35: {'costs': {'crystal': 1950000, 'mithril': 20000}, 'time_sec': 626400},
        36: {'costs': {'crystal': 2000000, 'mithril': 20000}, 'time_sec': 630000},
        37: {'costs': {'crystal': 2050000, 'mithril': 30000}, 'time_sec': 633600},
        38: {'costs': {'crystal': 2100000, 'mithril': 30000}, 'time_sec': 637200},
        39: {'costs': {'crystal': 2150000, 'mithril': 30000}, 'time_sec': 640800},
        40: {'costs': {'crystal': 2200000, 'mithril': 30000}, 'time_sec': 644400},
    },
    'cn_cannon': {
        1: {'costs': {'crystal': 4000}, 'time_sec': 3600},
        2: {'costs': {'crystal': 8000}, 'time_sec': 10800},
        3: {'costs': {'crystal': 16000}, 'time_sec': 32400},
        4: {'costs': {'crystal': 32000}, 'time_sec': 64800},
        5: {'costs': {'crystal': 64000}, 'time_sec': 86400},
        6: {'costs': {'crystal': 125000}, 'time_sec': 172800},
        7: {'costs': {'crystal': 250000}, 'time_sec': 259200},
        8: {'costs': {'crystal': 315000}, 'time_sec': 432000},
        9: {'costs': {'crystal': 450000}, 'time_sec': 518400},
        10: {'costs': {'crystal': 600000}, 'time_sec': 604800},
        11: {'costs': {'crystal': 775000}, 'time_sec': 691200},
        12: {'costs': {'crystal': 825000, 'mithril': 1000}, 'time_sec': 694800},
        13: {'costs': {'crystal': 875000, 'mithril': 2000}, 'time_sec': 698400},
        14: {'costs': {'crystal': 925000, 'mithril': 2000}, 'time_sec': 702000},
        15: {'costs': {'crystal': 975000, 'mithril': 2000}, 'time_sec': 705600},
        16: {'costs': {'crystal': 1025000, 'mithril': 2000}, 'time_sec': 709200},
        17: {'costs': {'crystal': 1075000, 'mithril': 5000}, 'time_sec': 712800},
        18: {'costs': {'crystal': 1125000, 'mithril': 5000}, 'time_sec': 716400},
        19: {'costs': {'crystal': 1175000, 'mithril': 5000}, 'time_sec': 720000},
        20: {'costs': {'crystal': 1225000, 'mithril': 5000}, 'time_sec': 723600},
        21: {'costs': {'crystal': 1275000, 'mithril': 10000}, 'time_sec': 727200},
        22: {'costs': {'crystal': 1325000, 'mithril': 10000}, 'time_sec': 730800},
        23: {'costs': {'crystal': 1375000, 'mithril': 10000}, 'time_sec': 734400},
        24: {'costs': {'crystal': 1425000, 'mithril': 10000}, 'time_sec': 738000},
        25: {'costs': {'crystal': 1475000, 'mithril': 15000}, 'time_sec': 741600},
        26: {'costs': {'crystal': 1525000, 'mithril': 15000}, 'time_sec': 745200},
        27: {'costs': {'crystal': 1575000, 'mithril': 15000}, 'time_sec': 748800},
        28: {'costs': {'crystal': 1625000, 'mithril': 15000}, 'time_sec': 752400},
        29: {'costs': {'crystal': 1675000, 'mithril': 20000}, 'time_sec': 756000},
        30: {'costs': {'crystal': 1725000, 'mithril': 20000}, 'time_sec': 759600},
        31: {'costs': {'crystal': 1775000, 'mithril': 20000}, 'time_sec': 763200},
        32: {'costs': {'crystal': 1825000, 'mithril': 20000}, 'time_sec': 766800},
        33: {'costs': {'crystal': 1875000, 'mithril': 25000}, 'time_sec': 770400},
        34: {'costs': {'crystal': 1925000, 'mithril': 25000}, 'time_sec': 774000},
        35: {'costs': {'crystal': 1975000, 'mithril': 25000}, 'time_sec': 777600},
        36: {'costs': {'crystal': 2025000, 'mithril': 25000}, 'time_sec': 781200},
        37: {'costs': {'crystal': 2075000, 'mithril': 30000}, 'time_sec': 784800},
        38: {'costs': {'crystal': 2125000, 'mithril': 30000}, 'time_sec': 788400},
        39: {'costs': {'crystal': 2175000, 'mithril': 30000}, 'time_sec': 792000},
        40: {'costs': {'crystal': 2225000, 'mithril': 30000}, 'time_sec': 795600},
    },
    'cn_dwarf_tower': {
        1: {'costs': {'crystal': 100000}, 'time_sec': 172800},
        2: {'costs': {'crystal': 225000}, 'time_sec': 259200},
        3: {'costs': {'crystal': 350000}, 'time_sec': 345600},
        4: {'costs': {'crystal': 525000}, 'time_sec': 518400},
        5: {'costs': {'crystal': 700000}, 'time_sec': 691200},
        6: {'costs': {'crystal': 1150000}, 'time_sec': 864000},
        7: {'costs': {'crystal': 1225000, 'mithril': 1000}, 'time_sec': 867600},
        8: {'costs': {'crystal': 1300000, 'mithril': 1000}, 'time_sec': 871200},
        9: {'costs': {'crystal': 1375000, 'mithril': 1000}, 'time_sec': 874800},
        10: {'costs': {'crystal': 1450000, 'mithril': 1000}, 'time_sec': 878400},
        11: {'costs': {'crystal': 1525000, 'mithril': 2000}, 'time_sec': 882000},
        12: {'costs': {'crystal': 1600000, 'mithril': 2000}, 'time_sec': 885600},
        13: {'costs': {'crystal': 1675000, 'mithril': 2000}, 'time_sec': 889200},
        14: {'costs': {'crystal': 1750000, 'mithril': 2000}, 'time_sec': 892800},
        15: {'costs': {'crystal': 1825000, 'mithril': 5000}, 'time_sec': 896400},
        16: {'costs': {'crystal': 1900000, 'mithril': 5000}, 'time_sec': 900000},
        17: {'costs': {'crystal': 1975000, 'mithril': 5000}, 'time_sec': 903600},
        18: {'costs': {'crystal': 2050000, 'mithril': 5000}, 'time_sec': 907200},
        19: {'costs': {'crystal': 2125000, 'mithril': 10000}, 'time_sec': 910800},
        20: {'costs': {'crystal': 2200000, 'mithril': 10000}, 'time_sec': 914400},
        21: {'costs': {'crystal': 2275000, 'mithril': 10000}, 'time_sec': 918000},
        22: {'costs': {'crystal': 2350000, 'mithril': 10000}, 'time_sec': 921600},
        23: {'costs': {'crystal': 2425000, 'mithril': 15000}, 'time_sec': 925200},
        24: {'costs': {'crystal': 2500000, 'mithril': 15000}, 'time_sec': 928800},
        25: {'costs': {'crystal': 2575000, 'mithril': 15000}, 'time_sec': 932400},
        26: {'costs': {'crystal': 2650000, 'mithril': 15000}, 'time_sec': 936000},
        27: {'costs': {'crystal': 2725000, 'mithril': 20000}, 'time_sec': 939600},
        28: {'costs': {'crystal': 2800000, 'mithril': 20000}, 'time_sec': 943200},
        29: {'costs': {'crystal': 2875000, 'mithril': 20000}, 'time_sec': 946800},
        30: {'costs': {'crystal': 2950000, 'mithril': 20000}, 'time_sec': 950400},
        31: {'costs': {'crystal': 3025000, 'mithril': 25000}, 'time_sec': 954000},
        32: {'costs': {'crystal': 3100000, 'mithril': 25000}, 'time_sec': 957600},
        33: {'costs': {'crystal': 3175000, 'mithril': 25000}, 'time_sec': 961200},
        34: {'costs': {'crystal': 3250000, 'mithril': 25000}, 'time_sec': 964800},
        35: {'costs': {'crystal': 3325000, 'mithril': 30000}, 'time_sec': 968400},
        36: {'costs': {'crystal': 3400000, 'mithril': 30000}, 'time_sec': 972000},
        37: {'costs': {'crystal': 3475000, 'mithril': 30000}, 'time_sec': 975600},
        38: {'costs': {'crystal': 3550000, 'mithril': 30000}, 'time_sec': 979200},
        39: {'costs': {'crystal': 3600000, 'mithril': 30000}, 'time_sec': 982800},
        40: {'costs': {'crystal': 3600000, 'mithril': 30000}, 'time_sec': 986400},
    },
    'cn_flamethrower': {
        1: {'costs': {'crystal': 4500}, 'time_sec': 21600},
        2: {'costs': {'crystal': 25000}, 'time_sec': 64800},
        3: {'costs': {'crystal': 57500}, 'time_sec': 129600},
        4: {'costs': {'crystal': 145000}, 'time_sec': 259200},
        5: {'costs': {'crystal': 225000}, 'time_sec': 432000},
        6: {'costs': {'crystal': 325000}, 'time_sec': 691200},
        7: {'costs': {'crystal': 525000}, 'time_sec': 777600},
        8: {'costs': {'crystal': 950000}, 'time_sec': 864000},
        9: {'costs': {'crystal': 1000000, 'mithril': 1000}, 'time_sec': 867600},
        10: {'costs': {'crystal': 1100000, 'mithril': 1000}, 'time_sec': 871200},
        11: {'costs': {'crystal': 1150000, 'mithril': 1000}, 'time_sec': 874800},
        12: {'costs': {'crystal': 1200000, 'mithril': 2000}, 'time_sec': 878400},
        13: {'costs': {'crystal': 1250000, 'mithril': 2000}, 'time_sec': 882000},
        14: {'costs': {'crystal': 1300000, 'mithril': 2000}, 'time_sec': 885600},
        15: {'costs': {'crystal': 1350000, 'mithril': 2000}, 'time_sec': 889200},
        16: {'costs': {'crystal': 1400000, 'mithril': 5000}, 'time_sec': 892800},
        17: {'costs': {'crystal': 1450000, 'mithril': 5000}, 'time_sec': 896400},
        18: {'costs': {'crystal': 1500000, 'mithril': 5000}, 'time_sec': 900000},
        19: {'costs': {'crystal': 1550000, 'mithril': 5000}, 'time_sec': 903600},
        20: {'costs': {'crystal': 1600000, 'mithril': 10000}, 'time_sec': 907200},
        21: {'costs': {'crystal': 1650000, 'mithril': 10000}, 'time_sec': 910800},
        22: {'costs': {'crystal': 1700000, 'mithril': 10000}, 'time_sec': 914400},
        23: {'costs': {'crystal': 1750000, 'mithril': 10000}, 'time_sec': 918000},
        24: {'costs': {'crystal': 1800000, 'mithril': 15000}, 'time_sec': 921600},
        25: {'costs': {'crystal': 1850000, 'mithril': 15000}, 'time_sec': 925200},
        26: {'costs': {'crystal': 1900000, 'mithril': 15000}, 'time_sec': 928800},
        27: {'costs': {'crystal': 1950000, 'mithril': 15000}, 'time_sec': 932400},
        28: {'costs': {'crystal': 2000000, 'mithril': 20000}, 'time_sec': 936000},
        29: {'costs': {'crystal': 2050000, 'mithril': 20000}, 'time_sec': 939600},
        30: {'costs': {'crystal': 2100000, 'mithril': 20000}, 'time_sec': 943200},
        31: {'costs': {'crystal': 2150000, 'mithril': 20000}, 'time_sec': 946800},
        32: {'costs': {'crystal': 2200000, 'mithril': 25000}, 'time_sec': 950400},
        33: {'costs': {'crystal': 2250000, 'mithril': 25000}, 'time_sec': 954000},
        34: {'costs': {'crystal': 2300000, 'mithril': 25000}, 'time_sec': 957600},
        35: {'costs': {'crystal': 2350000, 'mithril': 25000}, 'time_sec': 961200},
        36: {'costs': {'crystal': 2400000, 'mithril': 30000}, 'time_sec': 964800},
        37: {'costs': {'crystal': 2450000, 'mithril': 30000}, 'time_sec': 968400},
        38: {'costs': {'crystal': 2500000, 'mithril': 30000}, 'time_sec': 972000},
        39: {'costs': {'crystal': 2550000, 'mithril': 30000}, 'time_sec': 975600},
        40: {'costs': {'crystal': 2600000, 'mithril': 30000}, 'time_sec': 979200},
    },
    'cn_freezing_tower': {
        1: {'costs': {'crystal': 3500}, 'time_sec': 14400},
        2: {'costs': {'crystal': 18000}, 'time_sec': 43200},
        3: {'costs': {'crystal': 42500}, 'time_sec': 129600},
        4: {'costs': {'crystal': 95000}, 'time_sec': 259200},
        5: {'costs': {'crystal': 182500}, 'time_sec': 432000},
        6: {'costs': {'crystal': 275000}, 'time_sec': 518400},
        7: {'costs': {'crystal': 500000}, 'time_sec': 691200},
        8: {'costs': {'crystal': 900000}, 'time_sec': 864000},
        9: {'costs': {'crystal': 950000, 'mithril': 1000}, 'time_sec': 867600},
        10: {'costs': {'crystal': 1000000, 'mithril': 1000}, 'time_sec': 871200},
        11: {'costs': {'crystal': 1050000, 'mithril': 1000}, 'time_sec': 874800},
        12: {'costs': {'crystal': 1100000, 'mithril': 2000}, 'time_sec': 878400},
        13: {'costs': {'crystal': 1150000, 'mithril': 2000}, 'time_sec': 882000},
        14: {'costs': {'crystal': 1200000, 'mithril': 2000}, 'time_sec': 885600},
        15: {'costs': {'crystal': 1250000, 'mithril': 2000}, 'time_sec': 889200},
        16: {'costs': {'crystal': 1300000, 'mithril': 5000}, 'time_sec': 892800},
        17: {'costs': {'crystal': 1350000, 'mithril': 5000}, 'time_sec': 896400},
        18: {'costs': {'crystal': 1400000, 'mithril': 5000}, 'time_sec': 900000},
        19: {'costs': {'crystal': 1450000, 'mithril': 5000}, 'time_sec': 903600},
        20: {'costs': {'crystal': 1500000, 'mithril': 10000}, 'time_sec': 907200},
        21: {'costs': {'crystal': 1550000, 'mithril': 10000}, 'time_sec': 910800},
        22: {'costs': {'crystal': 1600000, 'mithril': 10000}, 'time_sec': 914400},
        23: {'costs': {'crystal': 1650000, 'mithril': 10000}, 'time_sec': 918000},
        24: {'costs': {'crystal': 1700000, 'mithril': 15000}, 'time_sec': 921600},
        25: {'costs': {'crystal': 1750000, 'mithril': 15000}, 'time_sec': 925200},
        26: {'costs': {'crystal': 1800000, 'mithril': 15000}, 'time_sec': 928800},
        27: {'costs': {'crystal': 1850000, 'mithril': 15000}, 'time_sec': 932400},
        28: {'costs': {'crystal': 1900000, 'mithril': 20000}, 'time_sec': 936000},
        29: {'costs': {'crystal': 1950000, 'mithril': 20000}, 'time_sec': 939600},
        30: {'costs': {'crystal': 2000000, 'mithril': 20000}, 'time_sec': 943200},
        31: {'costs': {'crystal': 2050000, 'mithril': 20000}, 'time_sec': 946800},
        32: {'costs': {'crystal': 2100000, 'mithril': 25000}, 'time_sec': 950400},
        33: {'costs': {'crystal': 2150000, 'mithril': 25000}, 'time_sec': 954000},
        34: {'costs': {'crystal': 2200000, 'mithril': 25000}, 'time_sec': 957600},
        35: {'costs': {'crystal': 2250000, 'mithril': 25000}, 'time_sec': 961200},
        36: {'costs': {'crystal': 2300000, 'mithril': 30000}, 'time_sec': 964800},
        37: {'costs': {'crystal': 2350000, 'mithril': 30000}, 'time_sec': 968400},
        38: {'costs': {'crystal': 2400000, 'mithril': 30000}, 'time_sec': 972000},
        39: {'costs': {'crystal': 2450000, 'mithril': 30000}, 'time_sec': 975600},
        40: {'costs': {'crystal': 2500000, 'mithril': 30000}, 'time_sec': 979200},
    },
    'cn_gauss_cannon': {
        1: {'costs': {'crystal': 125000}, 'time_sec': 86400},
        2: {'costs': {'crystal': 250000}, 'time_sec': 172800},
        3: {'costs': {'crystal': 350000}, 'time_sec': 345600},
        4: {'costs': {'crystal': 450000}, 'time_sec': 518400},
        5: {'costs': {'crystal': 625000}, 'time_sec': 691200},
        6: {'costs': {'crystal': 775000}, 'time_sec': 864000},
        7: {'costs': {'crystal': 825000, 'mithril': 1000}, 'time_sec': 867600},
        8: {'costs': {'crystal': 875000, 'mithril': 1000}, 'time_sec': 871200},
        9: {'costs': {'crystal': 925000, 'mithril': 1000}, 'time_sec': 874800},
        10: {'costs': {'crystal': 975000, 'mithril': 1000}, 'time_sec': 878400},
        11: {'costs': {'crystal': 1025000, 'mithril': 2000}, 'time_sec': 882000},
        12: {'costs': {'crystal': 1075000, 'mithril': 2000}, 'time_sec': 885600},
        13: {'costs': {'crystal': 1125000, 'mithril': 2000}, 'time_sec': 889200},
        14: {'costs': {'crystal': 1175000, 'mithril': 2000}, 'time_sec': 892800},
        15: {'costs': {'crystal': 1225000, 'mithril': 5000}, 'time_sec': 896400},
        16: {'costs': {'crystal': 1275000, 'mithril': 5000}, 'time_sec': 900000},
        17: {'costs': {'crystal': 1325000, 'mithril': 5000}, 'time_sec': 903600},
        18: {'costs': {'crystal': 1375000, 'mithril': 5000}, 'time_sec': 907200},
        19: {'costs': {'crystal': 1425000, 'mithril': 10000}, 'time_sec': 910800},
        20: {'costs': {'crystal': 1475000, 'mithril': 10000}, 'time_sec': 914400},
        21: {'costs': {'crystal': 1525000, 'mithril': 10000}, 'time_sec': 918000},
        22: {'costs': {'crystal': 1575000, 'mithril': 10000}, 'time_sec': 921600},
        23: {'costs': {'crystal': 1625000, 'mithril': 15000}, 'time_sec': 925200},
        24: {'costs': {'crystal': 1675000, 'mithril': 15000}, 'time_sec': 928800},
        25: {'costs': {'crystal': 1725000, 'mithril': 15000}, 'time_sec': 932400},
        26: {'costs': {'crystal': 1775000, 'mithril': 15000}, 'time_sec': 936000},
        27: {'costs': {'crystal': 1825000, 'mithril': 20000}, 'time_sec': 939600},
        28: {'costs': {'crystal': 1875000, 'mithril': 20000}, 'time_sec': 943200},
        29: {'costs': {'crystal': 1925000, 'mithril': 20000}, 'time_sec': 946800},
        30: {'costs': {'crystal': 1975000, 'mithril': 20000}, 'time_sec': 950400},
        31: {'costs': {'crystal': 2025000, 'mithril': 25000}, 'time_sec': 954000},
        32: {'costs': {'crystal': 2075000, 'mithril': 25000}, 'time_sec': 957600},
        33: {'costs': {'crystal': 2125000, 'mithril': 25000}, 'time_sec': 961200},
        34: {'costs': {'crystal': 2175000, 'mithril': 25000}, 'time_sec': 964800},
        35: {'costs': {'crystal': 2225000, 'mithril': 30000}, 'time_sec': 968400},
        36: {'costs': {'crystal': 2275000, 'mithril': 30000}, 'time_sec': 972000},
        37: {'costs': {'crystal': 2325000, 'mithril': 30000}, 'time_sec': 975600},
        38: {'costs': {'crystal': 2375000, 'mithril': 30000}, 'time_sec': 979200},
        39: {'costs': {'crystal': 2425000, 'mithril': 30000}, 'time_sec': 982800},
        40: {'costs': {'crystal': 2475000, 'mithril': 30000}, 'time_sec': 986400},
    },
    'cn_magnetic_tower': {
        1: {'costs': {'crystal': 125000}, 'time_sec': 86400},
        2: {'costs': {'crystal': 250000}, 'time_sec': 172800},
        3: {'costs': {'crystal': 350000}, 'time_sec': 345600},
        4: {'costs': {'crystal': 450000}, 'time_sec': 518400},
        5: {'costs': {'crystal': 625000}, 'time_sec': 691200},
        6: {'costs': {'crystal': 775000}, 'time_sec': 864000},
        7: {'costs': {'crystal': 825000, 'mithril': 1000}, 'time_sec': 867600},
        8: {'costs': {'crystal': 875000, 'mithril': 1000}, 'time_sec': 871200},
        9: {'costs': {'crystal': 925000, 'mithril': 1000}, 'time_sec': 874800},
        10: {'costs': {'crystal': 975000, 'mithril': 1000}, 'time_sec': 878400},
        11: {'costs': {'crystal': 1025000, 'mithril': 2000}, 'time_sec': 882000},
        12: {'costs': {'crystal': 1075000, 'mithril': 2000}, 'time_sec': 885600},
        13: {'costs': {'crystal': 1125000, 'mithril': 2000}, 'time_sec': 889200},
        14: {'costs': {'crystal': 1175000, 'mithril': 2000}, 'time_sec': 892800},
        15: {'costs': {'crystal': 1225000, 'mithril': 5000}, 'time_sec': 896400},
        16: {'costs': {'crystal': 1275000, 'mithril': 5000}, 'time_sec': 900000},
        17: {'costs': {'crystal': 1325000, 'mithril': 5000}, 'time_sec': 903600},
        18: {'costs': {'crystal': 1375000, 'mithril': 5000}, 'time_sec': 907200},
        19: {'costs': {'crystal': 1425000, 'mithril': 10000}, 'time_sec': 910800},
        20: {'costs': {'crystal': 1475000, 'mithril': 10000}, 'time_sec': 914400},
        21: {'costs': {'crystal': 1525000, 'mithril': 10000}, 'time_sec': 918000},
        22: {'costs': {'crystal': 1575000, 'mithril': 10000}, 'time_sec': 921600},
        23: {'costs': {'crystal': 1625000, 'mithril': 15000}, 'time_sec': 925200},
        24: {'costs': {'crystal': 1675000, 'mithril': 15000}, 'time_sec': 928800},
        25: {'costs': {'crystal': 1725000, 'mithril': 15000}, 'time_sec': 932400},
        26: {'costs': {'crystal': 1775000, 'mithril': 15000}, 'time_sec': 936000},
        27: {'costs': {'crystal': 1825000, 'mithril': 20000}, 'time_sec': 939600},
        28: {'costs': {'crystal': 1875000, 'mithril': 20000}, 'time_sec': 943200},
        29: {'costs': {'crystal': 1925000, 'mithril': 20000}, 'time_sec': 946800},
        30: {'costs': {'crystal': 1975000, 'mithril': 20000}, 'time_sec': 950400},
        31: {'costs': {'crystal': 2025000, 'mithril': 25000}, 'time_sec': 954000},
        32: {'costs': {'crystal': 2075000, 'mithril': 25000}, 'time_sec': 957600},
        33: {'costs': {'crystal': 2125000, 'mithril': 25000}, 'time_sec': 961200},
        34: {'costs': {'crystal': 2175000, 'mithril': 25000}, 'time_sec': 964800},
        35: {'costs': {'crystal': 2225000, 'mithril': 30000}, 'time_sec': 968400},
        36: {'costs': {'crystal': 2275000, 'mithril': 30000}, 'time_sec': 972000},
        37: {'costs': {'crystal': 2325000, 'mithril': 30000}, 'time_sec': 975600},
        38: {'costs': {'crystal': 2375000, 'mithril': 30000}, 'time_sec': 979200},
        39: {'costs': {'crystal': 2425000, 'mithril': 30000}, 'time_sec': 982800},
        40: {'costs': {'crystal': 2475000, 'mithril': 30000}, 'time_sec': 986400},
    },
    'cn_mortar': {
        1: {'costs': {'crystal': 15000}, 'time_sec': 28800},
        2: {'costs': {'crystal': 30000}, 'time_sec': 64800},
        3: {'costs': {'crystal': 60000}, 'time_sec': 129600},
        4: {'costs': {'crystal': 150000}, 'time_sec': 259200},
        5: {'costs': {'crystal': 300000}, 'time_sec': 432000},
        6: {'costs': {'crystal': 565000}, 'time_sec': 518400},
        7: {'costs': {'crystal': 700000}, 'time_sec': 691200},
        8: {'costs': {'crystal': 1125000}, 'time_sec': 864000},
        9: {'costs': {'crystal': 1200000, 'mithril': 2000}, 'time_sec': 867600},
        10: {'costs': {'crystal': 1275000, 'mithril': 2000}, 'time_sec': 871200},
        11: {'costs': {'crystal': 1350000, 'mithril': 2000}, 'time_sec': 874800},
        12: {'costs': {'crystal': 1425000, 'mithril': 2000}, 'time_sec': 878400},
        13: {'costs': {'crystal': 1500000, 'mithril': 5000}, 'time_sec': 882000},
        14: {'costs': {'crystal': 1575000, 'mithril': 5000}, 'time_sec': 885600},
        15: {'costs': {'crystal': 1650000, 'mithril': 5000}, 'time_sec': 889200},
        16: {'costs': {'crystal': 1725000, 'mithril': 5000}, 'time_sec': 892800},
        17: {'costs': {'crystal': 1800000, 'mithril': 10000}, 'time_sec': 896400},
        18: {'costs': {'crystal': 1875000, 'mithril': 10000}, 'time_sec': 900000},
        19: {'costs': {'crystal': 1950000, 'mithril': 10000}, 'time_sec': 903600},
        20: {'costs': {'crystal': 2025000, 'mithril': 10000}, 'time_sec': 907200},
        21: {'costs': {'crystal': 2100000, 'mithril': 15000}, 'time_sec': 910800},
        22: {'costs': {'crystal': 2175000, 'mithril': 15000}, 'time_sec': 914400},
        23: {'costs': {'crystal': 2250000, 'mithril': 15000}, 'time_sec': 918000},
        24: {'costs': {'crystal': 2325000, 'mithril': 15000}, 'time_sec': 921600},
        25: {'costs': {'crystal': 2400000, 'mithril': 20000}, 'time_sec': 925200},
        26: {'costs': {'crystal': 2475000, 'mithril': 20000}, 'time_sec': 928800},
        27: {'costs': {'crystal': 2550000, 'mithril': 20000}, 'time_sec': 932400},
        28: {'costs': {'crystal': 2625000, 'mithril': 20000}, 'time_sec': 936000},
        29: {'costs': {'crystal': 2700000, 'mithril': 25000}, 'time_sec': 939600},
        30: {'costs': {'crystal': 2775000, 'mithril': 25000}, 'time_sec': 943200},
        31: {'costs': {'crystal': 2850000, 'mithril': 25000}, 'time_sec': 946800},
        32: {'costs': {'crystal': 2925000, 'mithril': 25000}, 'time_sec': 950400},
        33: {'costs': {'crystal': 3000000, 'mithril': 25000}, 'time_sec': 954000},
        34: {'costs': {'crystal': 3075000, 'mithril': 25000}, 'time_sec': 957600},
        35: {'costs': {'crystal': 3150000, 'mithril': 30000}, 'time_sec': 961200},
        36: {'costs': {'crystal': 3225000, 'mithril': 30000}, 'time_sec': 964800},
        37: {'costs': {'crystal': 3300000, 'mithril': 30000}, 'time_sec': 968400},
        38: {'costs': {'crystal': 3375000, 'mithril': 30000}, 'time_sec': 972000},
        39: {'costs': {'crystal': 3450000, 'mithril': 30000}, 'time_sec': 975600},
        40: {'costs': {'crystal': 3525000, 'mithril': 30000}, 'time_sec': 979200},
    },
    'cn_steam_tower': {
        1: {'costs': {'crystal': 150}, 'time_sec': 60},
        2: {'costs': {'crystal': 4500}, 'time_sec': 7200},
        3: {'costs': {'crystal': 45000}, 'time_sec': 57600},
        4: {'costs': {'crystal': 135000}, 'time_sec': 172800},
        5: {'costs': {'crystal': 300000}, 'time_sec': 518400},
        6: {'costs': {'crystal': 800000}, 'time_sec': 1036800},
        7: {'costs': {'crystal': 900000, 'mithril': 1000}, 'time_sec': 1040400},
        8: {'costs': {'crystal': 1000000, 'mithril': 1000}, 'time_sec': 1044000},
        9: {'costs': {'crystal': 1100000, 'mithril': 1000}, 'time_sec': 1047600},
        10: {'costs': {'crystal': 1200000, 'mithril': 2000}, 'time_sec': 1051200},
        11: {'costs': {'crystal': 1300000, 'mithril': 2000}, 'time_sec': 1054800},
        12: {'costs': {'crystal': 1400000, 'mithril': 2000}, 'time_sec': 1058400},
        13: {'costs': {'crystal': 1500000, 'mithril': 2000}, 'time_sec': 1062000},
        14: {'costs': {'crystal': 1600000, 'mithril': 5000}, 'time_sec': 1065600},
        15: {'costs': {'crystal': 1700000, 'mithril': 5000}, 'time_sec': 1069200},
        16: {'costs': {'crystal': 1800000, 'mithril': 5000}, 'time_sec': 1072800},
        17: {'costs': {'crystal': 1900000, 'mithril': 5000}, 'time_sec': 1076400},
        18: {'costs': {'crystal': 2000000, 'mithril': 10000}, 'time_sec': 1080000},
        19: {'costs': {'crystal': 2100000, 'mithril': 10000}, 'time_sec': 1083600},
        20: {'costs': {'crystal': 2200000, 'mithril': 10000}, 'time_sec': 1087200},
        21: {'costs': {'crystal': 2300000, 'mithril': 10000}, 'time_sec': 1090800},
        22: {'costs': {'crystal': 2400000, 'mithril': 15000}, 'time_sec': 1094400},
        23: {'costs': {'crystal': 2500000, 'mithril': 15000}, 'time_sec': 1098000},
        24: {'costs': {'crystal': 2600000, 'mithril': 15000}, 'time_sec': 1101600},
        25: {'costs': {'crystal': 2700000, 'mithril': 15000}, 'time_sec': 1105200},
        26: {'costs': {'crystal': 2800000, 'mithril': 20000}, 'time_sec': 1108800},
        27: {'costs': {'crystal': 2900000, 'mithril': 20000}, 'time_sec': 1112400},
        28: {'costs': {'crystal': 3000000, 'mithril': 20000}, 'time_sec': 1116000},
        29: {'costs': {'crystal': 3100000, 'mithril': 20000}, 'time_sec': 1119600},
        30: {'costs': {'crystal': 3200000, 'mithril': 25000}, 'time_sec': 1123200},
        31: {'costs': {'crystal': 3300000, 'mithril': 25000}, 'time_sec': 1126800},
        32: {'costs': {'crystal': 3400000, 'mithril': 25000}, 'time_sec': 1130400},
        33: {'costs': {'crystal': 3500000, 'mithril': 25000}, 'time_sec': 1134000},
        34: {'costs': {'crystal': 3600000, 'mithril': 30000}, 'time_sec': 1137600},
        35: {'costs': {'crystal': 3600000, 'mithril': 30000}, 'time_sec': 1141200},
        36: {'costs': {'crystal': 3600000, 'mithril': 30000}, 'time_sec': 1144800},
        37: {'costs': {'crystal': 3600000, 'mithril': 30000}, 'time_sec': 1148400},
        38: {'costs': {'crystal': 3600000, 'mithril': 30000}, 'time_sec': 1152000},
        39: {'costs': {'crystal': 3600000, 'mithril': 30000}, 'time_sec': 1155600},
        40: {'costs': {'crystal': 3600000, 'mithril': 30000}, 'time_sec': 1159200},
    },
    'cn_tesla_coil': {
        1: {'costs': {'crystal': 100000}, 'time_sec': 86400},
        2: {'costs': {'crystal': 150000}, 'time_sec': 172800},
        3: {'costs': {'crystal': 200000}, 'time_sec': 345600},
        4: {'costs': {'crystal': 300000}, 'time_sec': 518400},
        5: {'costs': {'crystal': 450000}, 'time_sec': 691200},
        6: {'costs': {'crystal': 600000}, 'time_sec': 864000},
        7: {'costs': {'crystal': 925000}, 'time_sec': 950400},
        8: {'costs': {'crystal': 1150000}, 'time_sec': 1036800},
        9: {'costs': {'crystal': 1225000}, 'time_sec': 1040400},
        10: {'costs': {'crystal': 1300000}, 'time_sec': 1044000},
        11: {'costs': {'crystal': 1375000}, 'time_sec': 1047600},
        12: {'costs': {'crystal': 1450000}, 'time_sec': 1051200},
        13: {'costs': {'crystal': 1525000}, 'time_sec': 1054800},
        14: {'costs': {'crystal': 1600000}, 'time_sec': 1058400},
        15: {'costs': {'crystal': 1675000}, 'time_sec': 1062000},
        16: {'costs': {'crystal': 1750000, 'mithril': 2000}, 'time_sec': 1065600},
        17: {'costs': {'crystal': 1825000, 'mithril': 5000}, 'time_sec': 1069200},
        18: {'costs': {'crystal': 1900000, 'mithril': 10000}, 'time_sec': 1072800},
        19: {'costs': {'crystal': 1975000, 'mithril': 10000}, 'time_sec': 1076400},
        20: {'costs': {'crystal': 2050000, 'mithril': 10000}, 'time_sec': 1080000},
        21: {'costs': {'crystal': 2125000, 'mithril': 10000}, 'time_sec': 1083600},
        22: {'costs': {'crystal': 2200000, 'mithril': 15000}, 'time_sec': 1087200},
        23: {'costs': {'crystal': 2275000, 'mithril': 15000}, 'time_sec': 1090800},
        24: {'costs': {'crystal': 2350000, 'mithril': 15000}, 'time_sec': 1094400},
        25: {'costs': {'crystal': 2425000, 'mithril': 15000}, 'time_sec': 1098000},
        26: {'costs': {'crystal': 2500000, 'mithril': 20000}, 'time_sec': 1101600},
        27: {'costs': {'crystal': 2575000, 'mithril': 20000}, 'time_sec': 1105200},
        28: {'costs': {'crystal': 2650000, 'mithril': 20000}, 'time_sec': 1108800},
        29: {'costs': {'crystal': 2725000, 'mithril': 20000}, 'time_sec': 1112400},
        30: {'costs': {'crystal': 2800000, 'mithril': 25000}, 'time_sec': 1116000},
        31: {'costs': {'crystal': 2875000, 'mithril': 25000}, 'time_sec': 1119600},
        32: {'costs': {'crystal': 2950000, 'mithril': 25000}, 'time_sec': 1123200},
        33: {'costs': {'crystal': 3025000, 'mithril': 25000}, 'time_sec': 1126800},
        34: {'costs': {'crystal': 3100000, 'mithril': 30000}, 'time_sec': 1130400},
        35: {'costs': {'crystal': 3175000, 'mithril': 30000}, 'time_sec': 1134000},
        36: {'costs': {'crystal': 3250000, 'mithril': 30000}, 'time_sec': 1137600},
        37: {'costs': {'crystal': 3325000, 'mithril': 30000}, 'time_sec': 1141200},
        38: {'costs': {'crystal': 3400000, 'mithril': 30000}, 'time_sec': 1144800},
        39: {'costs': {'crystal': 3475000, 'mithril': 30000}, 'time_sec': 1148400},
        40: {'costs': {'crystal': 3600000, 'mithril': 30000}, 'time_sec': 1152000},
    },
}


# ── Вспомогательная: получить конфиг стоимости ───────────────────────────────

# ── Unit Research Config ──────────────────────────────────────────────────────
# Ленивая загрузка из unit_research_config.json (генерируется bootstrap_research.py)
# Формат: {unit_kind: {level_str: {'up_price': {...}, 'up_time': N, 'model_level': N}}}

_RESEARCH_CONFIG: dict | None = None
_RESEARCH_CONFIG_PATH = os.path.join(BASE_DIR, 'unit_research_config.json')


def _get_research_config() -> dict:
    """Загружает unit_research_config.json один раз и кеширует."""
    global _RESEARCH_CONFIG
    if _RESEARCH_CONFIG is None:
        if os.path.exists(_RESEARCH_CONFIG_PATH):
            try:
                with open(_RESEARCH_CONFIG_PATH, 'r', encoding='utf-8') as f:
                    _RESEARCH_CONFIG = json.load(f)
                print(f'[state] unit_research_config: {len(_RESEARCH_CONFIG)} видов юнитов')
            except Exception as e:
                print(f'[state] Ошибка чтения unit_research_config.json: {e}')
                _RESEARCH_CONFIG = {}
        else:
            print('[state] unit_research_config.json не найден — запустите bootstrap_research.py')
            _RESEARCH_CONFIG = {}
    return _RESEARCH_CONFIG


def get_research_cost(kind: str, target_level: int) -> dict | None:
    """
    Возвращает {'up_price': {...}, 'up_time': N, 'model_level': N}.
    kind         — тип юнита (un_warrior, un_sniper, ...)
    target_level — целевой уровень ПОСЛЕ прокачки (current_level + 1).
    """
    cfg       = _get_research_config()
    unit_data = cfg.get(kind)
    if unit_data is None:
        return None
    lv_data = unit_data.get(str(target_level))
    if lv_data is None:
        max_lv  = max(int(k) for k in unit_data)
        lv_data = unit_data.get(str(max_lv))
    if lv_data is None:
        return None
    return dict(lv_data)


def update_research_state(base: dict, player: dict) -> list:
    """
    Проверяет все здания академии на завершение исследования.
    Если start_time + up_time <= now — повышает unit_levels[kind]
    и очищает spec академии.

    Возвращает список завершённых (kind, new_level) для логирования.
    Изменяет player['unit_levels'] и base['buildings'] на месте.
    """
    now       = time.time()
    completed = []
    cfg       = _get_research_config()

    for bld in base.get('buildings', []):
        spec = bld.get('spec', {})
        if spec.get('type') != 'research':
            continue
        unit_kind  = spec.get('unit_kind')
        start_time = spec.get('start_time')
        if not unit_kind or start_time is None:
            continue

        # Определяем время прокачки из конфига
        cur_level    = int(player.get('unit_levels', {}).get(unit_kind, 0))
        target_level = cur_level + 1
        research_cfg = get_research_cost(unit_kind, target_level)

        if research_cfg is None:
            # unit_kind не в конфиге (sp_call, sp_fireball и т.д. — заклинания из библиотеки,
            # а не юниты академии). Очищаем spec — иначе Flash крашится Error #2030
            # при попытке читать su_upgrade_time из буфера заклинания.
            print(f'[state] research: unit_kind={unit_kind!r} не в research_config — очищаем spec')
            spec.pop('unit_kind',  None)
            spec.pop('start_time', None)
            spec.pop('up_time',    None)
            continue

        up_time  = research_cfg.get('up_time', 0)
        finish_t = float(start_time) + up_time

        if now >= finish_t:
            # Исследование завершено!
            player.setdefault('unit_levels', {})[unit_kind] = target_level
            overdue = now - finish_t
            print(f'[state] research ✓ {unit_kind} lv{cur_level}→{target_level} '
                  f'(просрочка {overdue:.0f}s)')
            # Очищаем академию полностью (включая up_time — иначе мусор в JSON)
            spec.pop('unit_kind',  None)
            spec.pop('start_time', None)
            spec.pop('up_time',    None)
            completed.append((unit_kind, target_level))

    return completed


def get_build_cost(kind: str, target_level: int) -> dict | None:
    """
    Возвращает {'costs': {'crystal': N, ...}, 'time_sec': N} для объекта
    kind на целевом уровне target_level, или None если не найден.

    kind может содержать суффиксы (cn_cannon89 → ищем cn_cannon).
    """
    # 1. Точное совпадение
    cfg = BUILDING_CONFIG.get(kind)

    # 2. Поиск по базовому имени (убираем цифровые суффиксы)
    if cfg is None:
        base = kind.rstrip('0123456789')
        cfg = BUILDING_CONFIG.get(base)

    # 3. Поиск по префиксу среди ключей конфига
    if cfg is None:
        for key in BUILDING_CONFIG:
            if kind.startswith(key):
                cfg = BUILDING_CONFIG[key]
                break

    if cfg is None:
        return None

    # Уровень не найден — возвращаем максимальный как приближение
    lv_cfg = cfg.get(target_level)
    if lv_cfg is None:
        max_lv = max(cfg.keys())
        lv_cfg = cfg[max_lv]

    return dict(lv_cfg)


def can_afford(player: dict, costs: dict) -> bool:
    """Проверяет, достаточно ли у игрока ресурсов."""
    for res, amount in costs.items():
        key = RESOURCE_KEYS.get(res, res)
        if int(player.get(key, 0)) < amount:
            return False
    return True


def deduct_costs(player: dict, costs: dict) -> dict:
    """Вычитает ресурсы из player. Возвращает dict изменений {resource: delta}."""
    deltas = {}
    for res, amount in costs.items():
        key = RESOURCE_KEYS.get(res, res)
        before = int(player.get(key, 0))
        player[key] = max(0, before - amount)
        deltas[key] = player[key] - before
    return deltas


# ── JSON I/O ──────────────────────────────────────────────────────────────────

DEFAULT_PLAYER = {
    'gold': 999999999, 'crystal': 1000, 'oil': 500, 'exp': 228,
    'mithril': 0, 'hglory': 0, 'ruby': 0, 'blue_print': 0,
    'troops': {}, 'custom': {},
}

DEFAULT_BASE = {
    'object_id_counter': 47,
    'buildings': [], 'cannons': [], 'fences': [], 'decors': [], 'garbages': [],
}


def load_player() -> dict:
    with _STATE_LOCK:
        if os.path.exists(PLAYER_JSON):
            try:
                with open(PLAYER_JSON, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                for k, v in DEFAULT_PLAYER.items():
                    data.setdefault(k, v)
                # Гарантируем что level всегда синхронизирован с exp
                exp            = int(data.get('exp', 0))
                data['level']  = exp_to_level(exp)
                return data
            except Exception as e:
                print(f'[state] Ошибка чтения player_state.json: {e}')
        return dict(DEFAULT_PLAYER)


def save_player(player: dict) -> None:
    """
    Атомарная запись через temp-файл + rename.
    Перед сохранением пересчитывает level из exp, чтобы они всегда совпадали.
    """
    exp = int(player.get('exp', 0))
    computed_level = exp_to_level(exp)
    if player.get('level') != computed_level:
        player['level'] = computed_level
    with _STATE_LOCK:
        _atomic_write(PLAYER_JSON, player)


# ── Heartbeat: офлайн-прогресс ────────────────────────────────────────────────

# ── Разблокировка юнитов по уровню казармы ────────────────────────────────────
# Данные взяты из PShopUnit.req_building_kind / req_building_level дампа 5x1_1.
# Когда казарма (или research_center) достигает нужного уровня — юнит появляется
# в казарме на вкладке найма. Первый уровень юнита (unit_levels = 1) выдаётся
# автоматически; дальнейшая прокачка — через академию.

BARRACK_UNIT_UNLOCK = {
    'bl_barracks': {
        1:  ['un_warrior', 'un_sniper', 'un_dragon'],
        2:  ['un_motocycle'],
        3:  ['un_troll'],
        4:  ['un_swarm'],
        5:  ['un_fairy'],
        6:  ['un_healer'],
        7:  ['un_dwarf'],
        8:  ['un_golem'],
        9:  ['un_disinfector'],
        10: ['un_tank'],
        15: ['un_zombie'],
    },
    'bl_research_center': {
        1: ['un_sniper_elite', 'un_sniper_mithril', 'un_warrior_elite', 'un_warrior_mithril'],
        2: ['un_motocycle_elite', 'un_motocycle_mithril'],
        3: ['un_troll_elite', 'un_troll_mithril'],
        4: ['un_swarm_elite', 'un_swarm_mithril'],
    },
}


def apply_barrack_unlocks(player: dict, building_kind: str, reached_level: int) -> list:
    """
    Вызывается когда здание достигло reached_level (через таймер или мгновенно если time=0).
    Добавляет в player['unit_levels'] юнитов, разблокированных ЭТИМ уровнем.
    Не трогает юнитов которые уже есть (не перезаписывает прогресс академии).
    Возвращает список добавленных видов.
    """
    table = BARRACK_UNIT_UNLOCK.get(building_kind, {})
    units_for_level = table.get(reached_level, [])
    ul = player.setdefault('unit_levels', {})
    unlocked = []
    for kind in units_for_level:
        if int(ul.get(kind, 0)) == 0:
            ul[kind] = 1
            unlocked.append(kind)
            print(f'[state] unlock ✓ {kind} lv1 '
                  f'({building_kind} lv{reached_level} завершена)')
    return unlocked


def sync_barrack_unlocks(base: dict, player: dict) -> list:
    """
    Синхронизирует unit_levels с текущим состоянием всех казарм в базе.
    Вызывается при загрузке базы — гарантирует что после перезагрузки сервера
    все юниты, соответствующие уровням достроенных казарм, присутствуют в unit_levels.
    """
    unlocked = []
    for bld in base.get('buildings', []):
        if bld.get('state') != 'finished':
            continue
        kind = bld.get('kind', '')
        if kind not in BARRACK_UNIT_UNLOCK:
            continue
        table = BARRACK_UNIT_UNLOCK[kind]
        current_level = int(bld.get('level', 1))
        ul = player.setdefault('unit_levels', {})
        # Применяем все уровни от 1 до текущего включительно
        for lv in range(1, current_level + 1):
            for unit_kind in table.get(lv, []):
                if int(ul.get(unit_kind, 0)) == 0:
                    ul[unit_kind] = 1
                    unlocked.append(unit_kind)
                    print(f'[state] sync unlock ✓ {unit_kind} lv1 '
                          f'({kind} lv{current_level} already finished)')
    return unlocked


def update_base_state(base: dict, player: dict | None = None) -> int:
    """
    «Сердце» сервера. Пробегает по всем зданиям и пушкам.
    Если state='in_progress' и time.time() >= finish_time — переводит в 'finished'.
    При завершении казармы/research_center — разблокирует юнитов нового уровня.
    Если здание академии завершило исследование — повышает unit_levels в player.

    Вызывается внутри load_base() автоматически. Это даёт честный офлайн-прогресс:
    игрок выключил сервер на сутки — включил, всё достроилось по системному времени ПК.

    Возвращает количество завершённых объектов.
    """
    now = time.time()
    completed = 0

    for category in ('buildings', 'cannons'):
        for obj in base.get(category, []):
            if obj.get('state') == 'in_progress':
                ft = obj.get('finish_time')
                if ft is not None and now >= float(ft):
                    obj['state']       = 'finished'
                    obj['finish_time'] = None
                    completed += 1
                    overdue = now - float(ft)
                    print(f'[state] heartbeat ✓ {obj.get("kind","?")} id={obj.get("id")} '
                          f'(просрочка {overdue:.0f}s)')
                    # Разблокируем юнитов если казарма/research_center достигла нового уровня
                    if player is not None:
                        apply_barrack_unlocks(
                            player, obj.get('kind', ''), int(obj.get('level', 1)))

    # Проверяем завершение исследований в академии
    if player is not None:
        finished_research = update_research_state(base, player)
        completed += len(finished_research)

    return completed


def load_base(player: dict | None = None) -> dict:
    """
    Загружает base_state.json.
    Если передан player — автоматически завершает in_progress и исследования.
    """
    with _STATE_LOCK:
        if os.path.exists(BASE_JSON):
            try:
                with open(BASE_JSON, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                for k, v in DEFAULT_BASE.items():
                    data.setdefault(k, v)
                # Санитайзер: ресурсные здания без корректного spec→инициализируем
                _RESOURCE_KINDS = {
                    'bl_oil_tower', 'bl_crystal_mine',
                    'bl_ruby_mine', 'bl_mint_yard',
                    # bl_power_plant — PYLON тип, не resource, без done_count
                }
                now_ts = time.time()
                for b in data.get('buildings', []):
                    kind = b.get('kind', '')
                    spec = b.get('spec')
                    if kind in _RESOURCE_KINDS:
                        if spec is None:
                            b['spec'] = {'type': 'resource',
                                         'last_apply_time': now_ts,
                                         'done_count': 0}
                        else:
                            spec.setdefault('type', 'resource')
                            if spec.get('last_apply_time') is None:
                                spec['last_apply_time'] = now_ts
                            if spec.get('done_count') is None:
                                spec['done_count'] = 0
                completed = update_base_state(data, player)
                # Синхронизируем юнитов с уже достроенными казармами
                # (на случай если сервер перезапустили после постройки)
                if player is not None:
                    newly = sync_barrack_unlocks(data, player)
                    if newly:
                        completed += len(newly)
                if completed > 0:
                    _atomic_write(BASE_JSON, data)
                    # Если player изменился от research — сохраняем и его
                    if player is not None:
                        _atomic_write(PLAYER_JSON, player)
                    print(f'[state] load_base: завершено {completed} объектов (офлайн-прогресс)')
                return data
            except Exception as e:
                print(f'[state] Ошибка чтения base_state.json: {e}')
    return dict(DEFAULT_BASE)


def _atomic_write(path: str, data: dict) -> None:
    """
    Атомарная запись: tmp-файл → os.replace().
    На Windows при PermissionError (файл залочен антивирусом/индексатором)
    делает 3 попытки с паузой 50 мс.
    """
    import time as _time
    fd, tmp = None, None
    try:
        fd, tmp = tempfile.mkstemp(dir=BASE_DIR, prefix='.tmp_', suffix='.json')
        with os.fdopen(fd, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        fd = None  # закрыт через fdopen

        # Retry для Windows: os.replace может упасть с PermissionError
        for attempt in range(3):
            try:
                os.replace(tmp, path)
                tmp = None  # успешно заменили
                return
            except PermissionError:
                if attempt < 2:
                    _time.sleep(0.05)
                else:
                    raise
    except Exception as e:
        print(f'[state] ОШИБКА записи {os.path.basename(path)}: {e}')
        # Fallback: прямая запись без атомарности
        try:
            with open(path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f'[state] Fallback запись {os.path.basename(path)}: OK')
        except Exception as e2:
            print(f'[state] Fallback тоже упал: {e2}')
    finally:
        if fd is not None:
            try: os.close(fd)
            except OSError: pass
        if tmp is not None:
            try: os.unlink(tmp)
            except OSError: pass


def save_base(base: dict) -> None:
    n_bld = len(base.get('buildings', []))
    n_cn  = len(base.get('cannons', []))
    with _STATE_LOCK:
        _atomic_write(BASE_JSON, base)
    # Небольшой отладочный вывод для диагностики сохранения
    print(f'[state] save_base: {n_bld} зданий, {n_cn} пушек → {os.path.basename(BASE_JSON)}')


# ── Примитивы записи (LE = AS3 ByteArray Endian.LITTLE_ENDIAN) ───────────────

def w_u8(v: int)    -> bytes: return struct.pack('<B', v & 0xFF)
def w_bool(v: bool) -> bytes: return w_u8(1 if v else 0)
def w_i16(v: int)   -> bytes: return struct.pack('<h', v)
def w_u16(v: int)   -> bytes: return struct.pack('<H', v)
def w_i32(v: int)   -> bytes: return struct.pack('<i', v)
def w_u32(v: int)   -> bytes: return struct.pack('<I', v)
def w_f64(v: float) -> bytes: return struct.pack('<d', v)

def w_utf(s: str) -> bytes:
    b = s.encode('utf-8')
    return struct.pack('<H', len(b)) + b

def w_pcost(c: dict) -> bytes:
    t = c.get('type', 0)
    out = w_u8(t)
    v = c.get('value')
    if t == 10 or v is None:
        return out
    return out + (w_u32(int(v)) if t <= 5 else w_i32(int(v)))

def w_build_state(obj: dict) -> bytes:
    if obj.get('state') == 'in_progress' and obj.get('finish_time'):
        return w_u8(1) + w_f64(float(obj['finish_time']))
    return w_u8(0)


# ── PBuildingSpec ─────────────────────────────────────────────────────────────

SPEC_TYPE_IDS = {
    'townhall': 0, 'worker': 1, 'barrack': 2, 'camp': 3,
    'resource': 4, 'storage': 5, 'pylon': 6, 'research': 7,
    'clan_center': 8, 'hero': 9, 'guard': 10, 'raid': 11,
    'library': 12, 'shield': 13, 'scouting': 14, 'unknown': 15,
}

# Здания которые клиент ожидает как PYLON (sv=6) — у них нет resource shop
# Если в JSON записан неверный тип, принудительно исправляем
_FORCE_PYLON_KINDS: set = {'bl_power_plant'}

def w_building_spec(spec: dict, kind: str = '') -> bytes:
    stype = spec.get('type', 'townhall')
    # Принудительный PYLON для электростанции — resource shop не существует
    if kind in _FORCE_PYLON_KINDS:
        stype = 'pylon'
    sv    = SPEC_TYPE_IDS.get(stype, 0)
    out   = w_u8(sv)

    if sv == 4:   # RESOURCE
        lat = spec.get('last_apply_time')
        out += w_f64(float(lat) if lat is not None else time.time())
        dc  = spec.get('done_count')
        out += w_u32(int(dc) if dc is not None else 0)
    elif sv == 7: # RESEARCH
        uk = spec.get('unit_kind')
        # Защита: sp_* и другие заклинания НЕ могут быть в академии как юниты.
        # Flash вызывает getResearchSoldierShop(kind) — если kind не юнит,
        # возвращает буфер заклинания, чтение из него даёт Error #2030.
        # Только виды из unit_research_config.json допускаются.
        if uk and uk in _get_research_config():
            out += w_u8(1) + w_utf(str(uk)) + w_f64(float(spec.get('start_time', time.time())))
        else:
            if uk:
                print(f'[state] w_building_spec: unit_kind={uk!r} не в research_config → сериализуем как пустую')
            out += w_u8(0)
    elif sv == 8: # CLAN_CENTER
        lat = spec.get('lat')
        out += (w_u8(1) + w_f64(float(lat))) if lat is not None else w_u8(0)
        resources = spec.get('resources', [])
        out += w_u16(len(resources))
        for r in resources:
            out += w_pcost(r)
    elif sv == 10: # GUARD
        cfg = spec.get('config', [])
        out += w_u16(len(cfg))
        for kc in cfg:
            out += w_utf(str(kc['kind'])) + w_u32(int(kc['count']))
        out += w_u8(int(spec.get('count', 0)))
    elif sv == 13: # SHIELD
        out += w_f64(float(spec.get('shield_time', time.time())))

    return out


# ── Сериализаторы объектов карты ──────────────────────────────────────────────

def w_building(b: dict) -> bytes:
    return (w_u32(int(b['id'])) + w_utf(str(b['kind'])) +
            w_u16(int(b['level'])) + w_i16(int(b['x'])) + w_i16(int(b['y'])) +
            w_build_state(b) + w_building_spec(b.get('spec', {'type': 'townhall'}), kind=str(b.get('kind',''))))

def w_cannon(c: dict) -> bytes:
    return (w_u32(int(c['id'])) + w_utf(str(c['kind'])) +
            w_u8(int(c['level'])) + w_i16(int(c['x'])) + w_i16(int(c['y'])) +
            w_build_state(c))

def w_fence(f: dict) -> bytes:
    return (w_u32(int(f['id'])) + w_utf(str(f['kind'])) +
            w_u8(int(f['level'])) + w_i16(int(f['x'])) + w_i16(int(f['y'])))

def w_decor(d: dict) -> bytes:
    return (w_u32(int(d['id'])) + w_utf(str(d['kind'])) +
            w_i16(int(d['x'])) + w_i16(int(d['y'])))

def w_garbage(g: dict) -> bytes:
    out  = w_u32(int(g['id'])) + w_utf(str(g['kind']))
    out += w_i16(int(g['x'])) + w_i16(int(g['y']))
    if g.get('removing') and g.get('start_remove') is not None:
        out += w_u8(1) + w_f64(float(g['start_remove']))
    else:
        out += w_u8(0)
    out += w_pcost(g.get('prize', {'type': PCOST_CALL, 'value': 1}))
    return out


# ── PUm сериализация ──────────────────────────────────────────────────────────

def serialize_pum(base: dict) -> bytes:
    buildings = base.get('buildings', [])
    cannons   = base.get('cannons', [])
    fences    = base.get('fences', [])
    decors    = base.get('decors', [])
    garbages  = base.get('garbages', [])

    out  = w_f64(time.time())
    out += w_u32(int(base.get('object_id_counter', 47)))
    out += w_u16(len(buildings))
    for b in buildings: out += w_building(b)
    out += w_u16(len(cannons))
    for c in cannons:   out += w_cannon(c)
    out += w_u16(len(fences))
    for f in fences:    out += w_fence(f)
    out += w_u16(len(decors))
    for d in decors:    out += w_decor(d)
    out += w_u16(len(garbages))
    for g in garbages: out += w_garbage(g)
    return out



# ── Reader для find_pum_bounds ────────────────────────────────────────────────

class _R:
    def __init__(self, d: bytes, p: int = 0):
        self._d = d; self._p = p
    @property
    def pos(self): return self._p
    def _r(self, n):
        if self._p + n > len(self._d):
            raise EOFError(f'Need {n} @ 0x{self._p:X}')
        b = self._d[self._p:self._p+n]; self._p += n; return b
    def u8(self)     -> int:   return struct.unpack('<B', self._r(1))[0]
    def bool_(self)  -> bool:  return self.u8() != 0
    def i16(self)    -> int:   return struct.unpack('<h', self._r(2))[0]
    def u16(self)    -> int:   return struct.unpack('<H', self._r(2))[0]
    def i32(self)    -> int:   return struct.unpack('<i', self._r(4))[0]
    def u32(self)    -> int:   return struct.unpack('<I', self._r(4))[0]
    def f64(self)    -> float: return struct.unpack('<d', self._r(8))[0]
    def utf(self)    -> str:
        n = struct.unpack('<H', self._r(2))[0]
        return self._r(n).decode('utf-8', errors='replace')
    def _pcost(self):
        v = self.u8()
        if v == 10: return
        if v <= 5: self.u32()
        else: self.i32()


def _skip_puser(r: _R) -> tuple:
    """Пропускает PUser, возвращает (gold_offset, crystal_offset, oil_offset)."""
    r.utf(); r.utf(); r.utf(); r.utf(); r.u16(); r.utf(); r.i32()
    r.utf(); r.utf(); r.u32()
    for _ in range(r.u16()): r.utf(); r.u32()
    for _ in range(r.u16()): r.utf(); r.i32()
    for _ in range(r.u16()):
        r.utf(); r.u32(); r.f64(); r.u32(); r.u32(); r.u32(); r.u32()
    if r.u8() == 1:
        r.utf(); r.utf(); r.utf(); r.i32(); r.u8()
        r.f64(); r.f64(); r.f64()
        for _ in range(r.u16()): r.utf()
        r.f64()
    r.u32(); r.utf(); r.utf(); r.f64()
    if r.u8() == 1: r.i32(); r.i32()
    gold_off    = r.pos;   r.u32()
    crystal_off = r.pos;   r.u32()
    oil_off     = r.pos;   r.u32()
    hglory_off  = r.pos;   r.u32()
    for _ in range(r.u16()):
        r.utf()
        for _ in range(r.u8()):
            v = r.u8()
            if v == 0: r.u32()
    for _ in range(r.u16()): r.utf()
    r.utf()
    for _ in range(r.u16()): r.utf()
    for _ in range(r.u16()): r.utf(); r.f64(); r.utf()
    r.bool_()
    for _ in range(r.u16()): r.utf(); r.utf()
    for _ in range(r.u16()):
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
        if r.u8() == 1: r.utf(); r.utf()
        for _ in range(r.u16()): r.utf(); r.u32()
        r.utf(); r.utf(); r.bool_(); r.utf()
    r.f64(); r.u32(); r.u32()
    r.u8(); r.u8(); r.bool_(); r.u32(); r.bool_()
    r.utf(); r.i32(); r.f64(); r.f64(); r.i32(); r.i32(); r.i32()
    for _ in range(r.u16()): r.utf(); r.f64()
    for _ in range(r.u16()):
        r.utf(); r.utf(); r.u32(); r.f64()
        v = r.u8()
        if v in (0, 1): r.u32()
        r.bool_()
        av = r.u8()
        if av == 0: r.f64()
        elif av == 1: r.i32()
    r.u8()
    for _ in range(r.u16()): r.utf()
    r.f64()
    for _ in range(r.u16()): r.utf(); r.f64(); r.bool_()
    for _ in range(r.u16()): r.utf()
    for _ in range(r.u16()): r.utf(); r.u32()
    mithril_off = r.pos; r.i32()   # mithril
    r.i32()                         # blue_print
    for _ in range(r.u16()): r.i32()
    for _ in range(r.u16()): r.utf()
    for _ in range(r.u16()): r.utf(); r.utf()
    for _ in range(r.u16()): r.i32(); r.i32(); r.bool_(); r.i32(); r.f64()
    r.i32(); r.i32()
    for _ in range(r.u16()): r.i32(); r.i32(); r.i32()
    if r.u8() == 1:
        r.i32(); r.f64()
        if r.u8() == 1: r.i32()
        r.i32(); r.i32(); r.bool_()
    if r.u8() == 1: r.i32(); r.f64(); r.i32(); r.bool_()
    r.i32()
    return gold_off, crystal_off, oil_off, hglory_off, mithril_off


def _skip_pum(r: _R) -> None:
    r.f64(); r.u32()
    for _ in range(r.u16()):
        r.u32(); r.utf(); r.u16(); r.i16(); r.i16()
        vs = r.u8()
        if vs == 1: r.f64()
        sv = r.u8()
        if sv == 4: r.f64(); r.u32()
        elif sv == 7:
            if r.u8() == 1: r.utf(); r.f64()
        elif sv == 8:
            if r.u8() == 1: r.f64()
            for _ in range(r.u16()): r._pcost()
        elif sv == 10:
            for _ in range(r.u16()): r.utf(); r.u32()
            r.u8()
        elif sv == 13: r.f64()
    for _ in range(r.u16()):
        r.u32(); r.utf(); r.u8(); r.i16(); r.i16()
        vs = r.u8()
        if vs == 1: r.f64()
    for _ in range(r.u16()): r.u32(); r.utf(); r.u8(); r.i16(); r.i16()
    for _ in range(r.u16()): r.u32(); r.utf(); r.i16(); r.i16()
    for _ in range(r.u16()):
        r.u32(); r.utf(); r.i16(); r.i16()
        if r.u8() == 1: r.f64()
        r._pcost()


def _build_units_bytes(troops: dict) -> bytes:
    """Строит PKindCount[] байты из словаря войск.
    PKindCount = u16 len + UTF-8 bytes + u32 count."""
    items = [(k, int(v)) for k, v in troops.items() if int(v) > 0]
    out = struct.pack('<H', len(items))
    for kind, count in items:
        b = kind.encode('utf-8')
        out += struct.pack('<H', len(b)) + b + struct.pack('<I', count)
    return out


def _build_unit_levels_bytes(unit_levels: dict) -> bytes:
    """Строит PUnitsLevel[] байты из словаря unit_levels.
    PUnitsLevel = u16 len + UTF-8 bytes + i32 level."""
    items = [(k, int(v)) for k, v in unit_levels.items()]
    out = struct.pack('<H', len(items))
    for kind, level in items:
        b = kind.encode('utf-8')
        out += struct.pack('<H', len(b)) + b + struct.pack('<i', level)
    return out


def _find_th_level_offset(data: bytes, puser_start: int) -> int:
    """
    Находит смещение поля th_level (u32) внутри PUserBase.
    th_level идёт после heroes[] и opt PUserClan, которые переменной длины,
    поэтому этот оффсет нельзя закэшировать — нужно пересчитывать после splice.
    Вызывать на уже пропатченном буфере.
    """
    r = _R(data, puser_start)
    r.utf(); r.utf(); r.utf(); r.utf()  # user_id name avatar profile_url
    r.u16(); r.utf(); r.i32()           # level sex exp
    r.utf(); r.utf(); r.u32()           # avatar_small avatar_big ratio
    for _ in range(r.u16()): r.utf(); r.u32()  # units[]
    for _ in range(r.u16()): r.utf(); r.i32()  # units_levels[]
    for _ in range(r.u16()):                    # heroes[]
        r.utf(); r.u32(); r.f64(); r.u32(); r.u32(); r.u32(); r.u32()
    if r.u8() == 1:                             # opt PUserClan
        r.utf(); r.utf(); r.utf(); r.i32(); r.u8()
        r.f64(); r.f64(); r.f64()
        for _ in range(r.u16()): r.utf()
        r.f64()
    return r.pos   # th_level offset


def _skip_quests_to_stage(data: bytes, puser_start: int) -> tuple:
    """
    Находит диапазон quests_closed[] и смещение поля stage (utf) в PUser.
    PUser layout after PUserBase:
      u32 gold, u32 crystal, u32 oil, u32 hglory
      u16+PQuest[] quests
      u16+utf[] quests_closed   ← нужно
      utf stage                 ← нужно
    Возвращает (qc_start, qc_end, stage_off, stage_end).
    """
    r = _R(data, puser_start)
    # Пропускаем PUserBase
    r.utf(); r.utf(); r.utf(); r.utf()  # user_id name avatar profile_url
    r.u16(); r.utf(); r.i32()           # level sex exp
    r.utf(); r.utf(); r.u32()           # avatar_small avatar_big ratio
    for _ in range(r.u16()): r.utf(); r.u32()  # units[]
    for _ in range(r.u16()): r.utf(); r.i32()  # units_levels[]
    for _ in range(r.u16()):                    # heroes[]
        r.utf(); r.u32(); r.f64(); r.u32(); r.u32(); r.u32(); r.u32()
    if r.u8() == 1:                             # opt PUserClan
        r.utf(); r.utf(); r.utf(); r.i32(); r.u8()
        r.f64(); r.f64(); r.f64()
        for _ in range(r.u16()): r.utf()
        r.f64()
    r.u32()                              # th_level
    r.utf(); r.utf(); r.f64()           # account_id snetwork scouting
    if r.u8() == 1: r.i32(); r.i32()   # opt clan_points
    # PUserBase done — now PUser body
    r.u32(); r.u32(); r.u32(); r.u32()  # gold crystal oil hglory
    # quests[] — пропускаем
    nq = r.u16()
    for _ in range(nq):
        r.utf()          # qname
        for _ in range(r.u8()):  # qtargets (u8 count)
            v = r.u8()
            if v == 0: r.u32()   # QTOPEN has u32 value
            # QTDONE(1) has no value
    # quests_closed[] — нужный диапазон
    qc_start = r.pos
    for _ in range(r.u16()): r.utf()
    qc_end = r.pos
    # stage (utf)
    stage_off = r.pos
    r.utf()
    stage_end = r.pos
    return qc_start, qc_end, stage_off, stage_end


def _build_quests_closed_bytes(quests_closed: list) -> bytes:
    """Сериализует quests_closed[] как u16 count + utf[]."""
    out = struct.pack('<H', len(quests_closed))
    for q in quests_closed:
        b = q.encode('utf-8')
        out += struct.pack('<H', len(b)) + b
    return out


def _build_stage_bytes(stage: str) -> bytes:
    """Сериализует одну UTF строку (stage)."""
    b = stage.encode('utf-8')
    return struct.pack('<H', len(b)) + b


def _find_puser_unit_levels_bounds(data: bytes, puser_start: int) -> tuple:
    """
    Парсит PUser начиная с puser_start.
    Возвращает (ul_start, ul_end) — байтовый диапазон units_levels[] (PUnitsLevel[]).
    units_levels[] идёт сразу после units[] (troops).

    Структура PUser (начало):
      utf  user_id
      utf  name
      utf  avatar
      utf  profile_url
      u16  level
      utf  sex
      i32  exp
      utf  avatar_small
      utf  avatar_big
      u32  ratio
      u16+[utf+u32]  units[]        <- пропускаем
      u16+[utf+i32]  units_levels[] <- нужные границы
    """
    r = _R(data, puser_start)
    # пропускаем заголовочные поля PUser
    r.utf(); r.utf(); r.utf(); r.utf()  # user_id, name, avatar, profile_url
    r.u16(); r.utf(); r.i32()           # level, sex, exp
    r.utf(); r.utf(); r.u32()           # avatar_small, avatar_big, ratio
    # пропускаем units[] (войска)
    for _ in range(r.u16()): r.utf(); r.u32()
    ul_start = r.pos  # начало units_levels[]
    for _ in range(r.u16()): r.utf(); r.i32()
    ul_end   = r.pos  # конец units_levels[]
    return ul_start, ul_end


def _find_userbase_units_bounds(data: bytes, puser_start: int) -> tuple:
    """
    Парсит PUserBase начиная с puser_start.
    Возвращает (level_off, exp_off, ratio_off, units_start, units_end, ul_start, ul_end):
      level_off               — смещение поля level (u16)
      exp_off                 — смещение поля exp (i32)
      ratio_off               — смещение поля ratio (u32)
      units_start..units_end  — диапазон units[]    (PKindCount[],   troops)
      ul_start..ul_end        — диапазон units_levels[] (PUnitsLevel[], research levels)

    level/exp/ratio находятся ДО units[], поэтому их смещения не меняются при splice.
    """
    r = _R(data, puser_start)
    r.utf()   # user_id
    r.utf()   # name
    r.utf()   # avatar
    r.utf()   # profile_url
    level_off = r.pos;  r.u16()   # level
    r.utf()   # sex
    exp_off   = r.pos;  r.i32()   # exp
    r.utf()   # avatar_small
    r.utf()   # avatar_big
    ratio_off = r.pos;  r.u32()   # ratio
    units_start = r.pos
    n = r.u16()
    for _ in range(n):
        r.utf(); r.u32()   # PKindCount
    units_end = r.pos
    ul_start = r.pos
    n = r.u16()
    for _ in range(n):
        r.utf(); r.i32()   # PUnitsLevel
    ul_end = r.pos
    return level_off, exp_off, ratio_off, units_start, units_end, ul_start, ul_end


def find_pum_bounds(dump: bytes) -> tuple:
    r = _R(dump, 9)  # 8 header + 1 variance
    gold_off, crystal_off, oil_off, hglory_off, mithril_off = _skip_puser(r)
    r.u8()  # PLocation.variance
    pum_start = r.pos
    _skip_pum(r)
    pum_end = r.pos
    return pum_start, pum_end, gold_off, crystal_off, oil_off, hglory_off, mithril_off


# ── Патчеры дампов ────────────────────────────────────────────────────────────

def patch_2x2(dump: bytes, player: dict, base: dict) -> bytes:
    """
    Патчит дамп 2x1_1. Порядок патчей строгий — каждый следующий работает
    с буфером после предыдущего splice, чтобы смещения были актуальными.

    1. level, exp, ratio  — фиксированные смещения ДО units[], не сдвигаются
    2. units[] + units_levels[]  — splice, сдвигает всё что после ul_end
    3. th_level           — пересчитываем смещение после splice из шага 2
    4. quests_closed[] + stage — splice, после th_level
    5. PUm                — splice карты базы
    6. gold / crystal / oil — фиксированные смещения в PUser (после PUm-splice)
    7. Обновляем payload length в заголовке
    """
    patched = bytearray(dump)

    # ── 0. Вычисляем уровень из опыта ────────────────────────────────────────
    actual_exp   = int(player.get('exp', 0))
    actual_level = exp_to_level(actual_exp)
    # Синхронизируем player_state если уровень вырос
    if actual_level != int(player.get('level', 1)):
        player['level'] = actual_level
        print(f'[state] patch_2x2: level updated {player.get("level")}→{actual_level} (exp={actual_exp})')

    # ── 1. Патч level (u16) и exp (i32) и ratio (u32) ────────────────────────
    # Эти поля ПЕРЕД units[], смещения стабильны даже после splice
    try:
        level_off, exp_off, ratio_off, units_start, units_end, ul_start, ul_end =             _find_userbase_units_bounds(dump, 9)
        struct.pack_into('<H', patched, level_off,  min(actual_level,                        0xFFFF))
        struct.pack_into('<i', patched, exp_off,    min(actual_exp,                          0x7FFFFFFF))
        struct.pack_into('<I', patched, ratio_off,  min(int(player.get('ratio', 1000)),      0xFFFFFFFF))
    except Exception as e:
        print(f'[state] patch_2x2 level/exp error: {e}')
        level_off, exp_off, ratio_off, units_start, units_end, ul_start, ul_end =             0, 0, 0, 0, 0, 0, 0

    # ── 2. Splice units[] + units_levels[] ───────────────────────────────────
    try:
        new_units = _build_units_bytes(player.get('troops', {}))
        new_ul    = _build_unit_levels_bytes(player.get('unit_levels', {}))
        patched = bytearray(
            bytes(patched)[:units_start] +
            new_units + new_ul +
            bytes(patched)[ul_end:]
        )
        ul_count = len(player.get('unit_levels', {}))
        print(f'[state] patch_2x2: lv={actual_level} exp={actual_exp} | '
              f'unit_levels={ul_count} юнитов')
    except Exception as e:
        print(f'[state] patch_2x2 units/ul error: {e}')

    # ── 3. Патч th_level (u32) ───────────────────────────────────────────────
    # После splice из шага 2 нужно пересчитать смещение
    try:
        th_off = _find_th_level_offset(bytes(patched), 9)
        struct.pack_into('<I', patched, th_off, min(int(player.get('th_level', 1)), 0xFFFFFFFF))
    except Exception as e:
        print(f'[state] patch_2x2 th_level error: {e}')

    # ── 4. Splice quests_closed[] + stage ────────────────────────────────────
    try:
        qc_start, qc_end, stage_off, stage_end = _skip_quests_to_stage(bytes(patched), 9)
        new_qc    = _build_quests_closed_bytes(player.get('quests_closed', []))
        new_stage = _build_stage_bytes(player.get('stage', ''))
        patched = bytearray(
            bytes(patched)[:qc_start] +
            new_qc + new_stage +
            bytes(patched)[stage_end:]
        )
    except Exception as e:
        print(f'[state] patch_2x2 quests_closed/stage error: {e}')

    # ── 5. Патч PUm ──────────────────────────────────────────────────────────
    try:
        pum_start, pum_end, gold_off, crystal_off, oil_off, hglory_off, mithril_off =             find_pum_bounds(bytes(patched))
    except Exception as e:
        print(f'[state] find_pum_bounds error: {e}')
        struct.pack_into('<I', patched, 4, len(patched) - 8)
        return bytes(patched)

    new_pum = serialize_pum(base)
    patched = bytearray(bytes(patched)[:pum_start] + new_pum + bytes(patched)[pum_end:])

    # ── 6. Патч gold / crystal / oil / hglory / mithril ──────────────────────
    struct.pack_into('<I', patched, gold_off,    min(int(player.get('gold',    0)), 0xFFFFFFFF))
    struct.pack_into('<I', patched, crystal_off, min(int(player.get('crystal', 0)), 0xFFFFFFFF))
    struct.pack_into('<I', patched, oil_off,     min(int(player.get('oil',     0)), 0xFFFFFFFF))
    struct.pack_into('<I', patched, hglory_off,  min(int(player.get('hglory',  0)), 0xFFFFFFFF))
    struct.pack_into('<i', patched, mithril_off, min(int(player.get('mithril', 0)), 0x7FFFFFFF))

    # ── 7. Обновляем payload length ───────────────────────────────────────────
    struct.pack_into('<I', patched, 4, len(patched) - 8)

    return bytes(patched)


def patch_5x2(dump: bytes, player: dict) -> bytes:
    """
    Патчит дамп 5x1_1:
      1. units_levels[] (PUnitsLevel[]) — актуальные уровни юнитов из player['unit_levels']
      2. gold / crystal / oil — актуальные ресурсы

    units_levels патчится ПЕРВЫМ, так как меняет размер буфера и сдвигает
    все последующие смещения (gold, crystal, oil).
    """
    uuid_re = re.compile(
        b'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
    )
    matches = list(uuid_re.finditer(dump))
    if not matches:
        print('[state] patch_5x2: UUID не найден')
        return dump

    puser_start = matches[0].start() - 2
    patched = bytearray(dump)

    # ── 1. Заменяем units_levels[] на актуальные данные ──────────────────────
    try:
        ul_start, ul_end = _find_puser_unit_levels_bounds(bytes(patched), puser_start)
        new_ul = _build_unit_levels_bytes(player.get('unit_levels', {}))
        patched = bytearray(bytes(patched)[:ul_start] + new_ul + bytes(patched)[ul_end:])
        ul_count = len(player.get('unit_levels', {}))
        print(f'[state] patch_5x2: unit_levels пропатчено ({ul_count} юнитов)')
    except Exception as e:
        print(f'[state] patch_5x2 unit_levels error: {e}')

    # ── 2. Патчим level / exp / ratio в PUserBase (они ДО units[], стабильны) ─
    try:
        actual_exp_5   = int(player.get('exp', 0))
        actual_level_5 = exp_to_level(actual_exp_5)
        lv5_off, exp5_off, ratio5_off, _, _, _, _ = _find_userbase_units_bounds(bytes(patched), puser_start)
        struct.pack_into('<H', patched, lv5_off,    min(actual_level_5,                    0xFFFF))
        struct.pack_into('<i', patched, exp5_off,   min(actual_exp_5,                      0x7FFFFFFF))
        struct.pack_into('<I', patched, ratio5_off, min(int(player.get('ratio', 1000)),    0xFFFFFFFF))
    except Exception as e:
        print(f'[state] patch_5x2 level/ratio error: {e}')

    # ── 3. Ищем смещения gold/crystal/oil В НОВОМ буфере ────────────────────
    try:
        r = _R(bytes(patched), puser_start)
        gold_off, crystal_off, oil_off, hglory_off, mithril_off = _skip_puser(r)
    except Exception as e:
        print(f'[state] patch_5x2 parse error: {e}')
        return dump  # возвращаем оригинал если не смогли распарсить

    struct.pack_into('<I', patched, gold_off,    min(int(player.get('gold',    0)), 0xFFFFFFFF))
    struct.pack_into('<I', patched, crystal_off, min(int(player.get('crystal', 0)), 0xFFFFFFFF))
    struct.pack_into('<I', patched, oil_off,     min(int(player.get('oil',     0)), 0xFFFFFFFF))
    struct.pack_into('<I', patched, hglory_off,  min(int(player.get('hglory',  0)), 0xFFFFFFFF))
    struct.pack_into('<i', patched, mithril_off, min(int(player.get('mithril', 0)), 0x7FFFFFFF))

    # ── 4. Обновляем payload length в заголовке ──────────────────────────────
    struct.pack_into('<I', patched, 4, len(patched) - 8)

    print(f'[state] patch_5x2: gold={player.get("gold",0):,} crystal={player.get("crystal",0):,} ' +
          f'oil={player.get("oil",0):,}')
    return bytes(patched)


# ── Вспомогательные: вместимость хранилищ ────────────────────────────────────
# Данные на основе PDict storages_info из реального дампа 5x1_1.
# Используются для расчёта amount при покупке паков rs_oil1/2/3, rs_crystal1/2/3.

_OIL_STORAGE_CAP = {
    1: 3_000,   2: 6_000,   3: 10_000,  4: 18_000,  5: 28_000,
    6: 45_000,  7: 75_000,  8: 120_000, 9: 200_000, 10: 350_000,
}
_CRYSTAL_STORAGE_CAP = {
    1: 2_000,   2: 4_500,   3: 8_000,   4: 14_000,  5: 22_000,
    6: 35_000,  7: 55_000,  8: 90_000,  9: 150_000, 10: 250_000,
}

def calc_max_storage(base: dict) -> tuple:
    """
    Вычисляет максимальный объём нефти и кристаллов из построенных зданий.
    Возвращает (oil_max, crystal_max).

    Значения хранилищ берутся из таблиц _OIL_STORAGE_CAP / _CRYSTAL_STORAGE_CAP,
    построенных на основе реального PDict (dumps/5x1_1).
    """
    oil_max     = 2_000    # базовая вместимость (без хранилищ)
    crystal_max = 1_000

    for bld in base.get('buildings', []):
        if bld.get('state') != 'finished':
            continue
        kind = bld.get('kind', '')
        lv   = min(int(bld.get('level', 1)), 10)

        if kind == 'bl_oil_storage':
            oil_max     += _OIL_STORAGE_CAP.get(lv, _OIL_STORAGE_CAP[10])
        elif kind == 'bl_crystal_storage':
            crystal_max += _CRYSTAL_STORAGE_CAP.get(lv, _CRYSTAL_STORAGE_CAP[10])

    return oil_max, crystal_max


# ── serialize_puser: полный PUser из player_state.json ──────────────────────

def serialize_puser(player: dict) -> bytes:
    """
    Строит полный двоичный PUser из player_state.json.
    Точно соответствует PUser.write() + PUserBase.write() из AS3.

    НЕ использует дамп. Является источником истины для всех ответов
    сервера (2x2 getMyMap, 5x2 getDict, 10x6 fight).

    Пустые массивы для: quests, fight_hist, stories, requests, offers —
    клиент их инициализирует самостоятельно по ходу игры.
    """
    out = b''

    # ── PUserBase ─────────────────────────────────────────────────────────────
    out += w_utf(player.get('user_id',     ''))
    out += w_utf(player.get('name',         'Player'))
    out += w_utf(player.get('avatar',       ''))
    out += w_utf(player.get('profile_url',  ''))
    out += w_u16(int(player.get('level',     1)))
    out += w_utf(player.get('sex',           'm'))
    out += w_i32(int(player.get('exp',        0)))
    out += w_utf(player.get('avatar_small',  ''))
    out += w_utf(player.get('avatar_big',    ''))
    out += w_u32(int(player.get('ratio',    1000)))

    # units[] — PKindCount (войска в лагере)
    troops = {k: int(v) for k, v in player.get('troops', {}).items() if int(v) > 0}
    out += w_u16(len(troops))
    for kind, count in troops.items():
        out += w_utf(kind) + w_u32(count)

    # units_levels[] — PUnitsLevel (уровни исследований)
    ul = player.get('unit_levels', {})
    out += w_u16(len(ul))
    for kind, level in ul.items():
        out += w_utf(kind) + w_i32(int(level))

    # heroes[] — PHero: utf kind + u32 level + f64 time + u32*4
    heroes = player.get('heroes', [])
    out += w_u16(len(heroes))
    for h in heroes:
        out += w_utf(str(h['kind']))
        out += w_u32(int(h.get('level', 1)))
        out += w_f64(float(h.get('time', time.time())))
        out += w_u32(int(h.get('u1', 1)))
        out += w_u32(int(h.get('u2', 1)))
        out += w_u32(int(h.get('u3', 2)))
        out += w_u32(int(h.get('u4', 0)))

    # --- Блок PUserClan (заменяет весь старый блок opt PUserClan) ---
    clan = player.get('clan')
    if clan:
        out += w_u8(1)  # Флаг наличия клана
        out += w_utf(str(clan.get('id', '')))
        out += w_utf(str(clan.get('name', '')))
        out += w_utf(str(clan.get('emblem', ''))) # Это uc_icon в AS3
        out += w_i32(int(clan.get('points', 0)))  # uc_level (в игре это очки/уровень)
        
        # PRole: В AS3 это отдельный объект, который читает 1 байт (variance)
        out += w_u8(int(clan.get('role', 0)))     # uc_role (1 байт)
        
        # ВНИМАНИЕ: Порядок Double в PUserClan.as строгий!
        out += w_f64(float(clan.get('d1', 0.0)))  # uc_clan_calls_time
        out += w_f64(float(clan.get('d2', 0.0)))  # uc_donate_oil
        out += w_f64(float(clan.get('d3', 0.0)))  # uc_donate_crystal
        
        # Массив юнитов идет ПОСЛЕ трех Double
        ucb = clan.get('units_can_buy', [])
        out += w_u16(len(ucb))
        for u in ucb:
            out += w_utf(str(u))
            
        # Последний Double
        out += w_f64(float(clan.get('d4', 0.0)))  # uc_donate_mithril
    else:
        out += w_u8(0)

    # --- Конец блока PUserClan ---

    # Дальше идут поля PUserBase, которые следуют сразу за кланом
    out += w_u32(int(player.get('th_level', 1)))
    out += w_utf(player.get('account_id', 'local'))
    out += w_utf(player.get('snetwork', 'local'))
    out += w_f64(float(player.get('scouting', 0.0)))
    # opt clan_points
    cp = player.get('clan_points')
    if cp and len(cp) >= 2:
        out += w_u8(1) + w_i32(int(cp[0])) + w_i32(int(cp[1]))
    else:
        out += w_u8(0)

    # ── PUser (поля после PUserBase) ─────────────────────────────────────────
    out += w_u32(min(int(player.get('gold',    0)), 0xFFFFFFFF))
    out += w_u32(min(int(player.get('crystal', 0)), 0xFFFFFFFF))
    out += w_u32(min(int(player.get('oil',     0)), 0xFFFFFFFF))
    out += w_u32(int(player.get('hglory',      0)))

    # quests[] — PQuest: utf qname + u8 count + [PQuestTarget: u8 var + opt u32]
    # КРИТИЧНО: Flash инициализирует quest-систему по этим данным.
    # При level > 1 с quests=0 → Error #1009 (null reference в quest-системе).
    quests = player.get('quests', [])
    out += w_u16(len(quests))
    for q in quests:
        out += w_utf(q['name'])
        targets = q.get('targets', [])
        out += struct.pack('<B', len(targets))  # u8 count, не u16!
        for t in targets:
            out += w_u8(t['v'])
            if t['v'] == 0:   # QTOPEN — есть u32 прогресс
                out += w_u32(int(t['val']) if t['val'] is not None else 0)
            # QTDONE (v==1) — данных нет

    # quests_closed[]
    qc = player.get('quests_closed', [])
    out += w_u16(len(qc))
    for s in qc:
        out += w_utf(str(s))

    out += w_utf(player.get('stage', 'home4_hero_click'))

    # win_missions[] — список пройденных миссий
    wm = player.get('win_missions', [])
    out += w_u16(len(wm))
    for s in wm:
        out += w_utf(str(s))

    # ext_missions[] — PExtMission: utf kind + f64 last_time + utf next_mission
    em = player.get('ext_missions', [])
    out += w_u16(len(em))
    for e in em:
        out += w_utf(str(e['kind'])) + w_f64(float(e['last_time'])) + w_utf(str(e['next']))

    out += w_bool(False)   # admin_units_mode

    # stories[] — str_str: utf + utf
    stories = player.get('stories', [])
    out += w_u16(len(stories))
    for s in stories:
        out += w_utf(str(s['k'])) + w_utf(str(s['v']))

    # fight_hist[] — обычно пусто (наш дамп содержит 0 боёв)
    out += w_u16(0)

    out += w_f64(0.0)                          # call_lat
    out += w_u32(int(player.get('call',  5))) # call (запасы призыва)
    out += w_u32(int(player.get('facts', 0))) # facts

    # settings_game: u8 sound + u8 music + bool low_q + u32 scale + bool alerts
    s = player.get('settings', {})
    out += w_u8(int(s.get('sg_sound',         0)))
    out += w_u8(int(s.get('sg_music',         0)))
    out += w_bool(bool(s.get('sg_low_quality', False)))
    out += w_u32(int(s.get('sg_scale',        75)))
    out += w_bool(bool(s.get('sg_in_game_alerts', True)))

    out += w_utf(player.get('last_readed_news', ''))

    out += w_i32(int(player.get('clan_calls',      0)))
    out += w_f64(float(player.get('clan_calls_time', 0.0)))
    out += w_f64(float(player.get('read_chat_time',  0.0)))

    out += w_i32(0); out += w_i32(0); out += w_i32(0)  # red/green/blue_ore

    out += w_u16(0)   # raid_cooldowns[]
    out += w_u16(0)   # requests[]

    out += w_u8(int(player.get('group_id', 0)))
    out += w_u16(0)   # request_list[]
    out += w_f64(0.0) # request_time

    out += w_u16(0)   # offers[]
    out += w_u16(0)   # shop_unwatched[]

    # last_units[] — войска для быстрого выбора (берём из troops)
    lu = {k: int(v) for k, v in player.get('troops', {}).items() if int(v) > 0}
    out += w_u16(len(lu))
    for k, v in lu.items():
        out += w_utf(k) + w_u32(v)

    out += w_i32(min(int(player.get('mithril',    0)), 0x7FFFFFFF))
    out += w_i32(min(int(player.get('blue_print', 0)), 0x7FFFFFFF))

    out += w_u16(0)   # divisions_reward[]

    # spells[]
    spells = player.get('spells', [])
    out += w_u16(len(spells))
    for sp in spells: out += w_utf(str(sp))

    # client_custom_data[] — пары {key: value}
    custom = player.get('custom', {})
    out += w_u16(len(custom))
    for k, v in custom.items():
        out += w_utf(str(k)) + w_utf(str(v))

    out += w_u16(0)   # jaina_events[]
    out += w_i32(int(player.get('jglory',     0)))
    out += w_i32(int(player.get('rar_dragon', 0)))
    out += w_u16(0)   # adventures[]
    out += w_u8(0)    # opt current_adventure = absent
    out += w_u8(0)    # opt subscription = absent
    out += w_i32(min(int(player.get('ruby', 0)), 0x7FFFFFFF))

    return out


# ═══════════════════════════════════════════════════════════════════════════════
# Сборка PTargetInfo — общая функция для p10_3 и p10_5
# ═══════════════════════════════════════════════════════════════════════════════

def _w_userbase(player: dict) -> bytes:
    """
    Сериализует PUserBase из player_state.json.
    Эта же структура идёт как «цель» (target) в PTargetInfo.
    Точно соответствует PUserBase.write() в AS3.
    """
    out  = w_utf(player.get('user_id',    'local-0000'))
    out += w_utf(player.get('name',       'Player'))
    out += w_utf(player.get('avatar',     ''))
    out += w_utf(player.get('profile_url',''))
    out += w_u16(int(player.get('level',  1)))
    out += w_utf(player.get('sex',        'm'))
    out += w_i32(int(player.get('exp',    0)))
    out += w_utf(player.get('avatar_small',''))
    out += w_utf(player.get('avatar_big', ''))
    out += w_u32(int(player.get('ratio',  1000)))

    # units[] — PKindCount (войска в лагере)
    troops = player.get('troops', {})
    troops_list = [(k, int(v)) for k, v in troops.items() if int(v) > 0]
    out += w_u16(len(troops_list))
    for kind, count in troops_list:
        out += w_utf(kind) + w_u32(count)

    # units_levels[] — PUnitsLevel
    ul = player.get('unit_levels', {})
    ul_list = list(ul.items())
    out += w_u16(len(ul_list))
    for kind, level in ul_list:
        out += w_utf(kind) + w_i32(int(level))

    # heroes[] — PHero: utf kind + u32 level + f64 time + u32*4
    heroes = player.get('heroes', [])
    out += w_u16(len(heroes))
    for h in heroes:
        out += w_utf(str(h['kind']))
        out += w_u32(int(h.get('level', 1)))
        out += w_f64(float(h.get('time', time.time())))
        out += w_u32(int(h.get('u1', 1)))
        out += w_u32(int(h.get('u2', 1)))
        out += w_u32(int(h.get('u3', 2)))
        out += w_u32(int(h.get('u4', 0)))

    # opt PUserClan
    clan = player.get('clan')
    if clan:
        out += w_u8(1)
        out += w_utf(str(clan.get('id',     '')))
        out += w_utf(str(clan.get('name',   '')))
        out += w_utf(str(clan.get('emblem', '')))
        out += w_i32(int(clan.get('points', 0)))
        out += w_u8(int(clan.get('role',    0)))
        out += w_f64(float(clan.get('d1', 0.0)))
        out += w_f64(float(clan.get('d2', 0.0)))
        out += w_f64(float(clan.get('d3', 0.0)))
        ucb = clan.get('units_can_buy', [])
        out += w_u16(len(ucb))
        for u in ucb:
            out += w_utf(str(u))
        out += w_f64(float(clan.get('d4', 0.0)))
    else:
        out += w_u8(0)

    out += w_u32(int(player.get('th_level',   1)))
    out += w_utf(player.get('account_id',     'local'))
    out += w_utf(player.get('snetwork',       'local'))
    out += w_f64(float(player.get('scouting', 0.0)))

    # opt clan_points
    cp = player.get('clan_points')
    if cp and len(cp) >= 2:
        out += w_u8(1) + w_i32(int(cp[0])) + w_i32(int(cp[1]))
    else:
        out += w_u8(0)

    return out


def _w_attacker_info(player: dict) -> bytes:
    """
    Сериализует PAttackerInfo — данные об атакующем игроке:
    войска, уровни исследований, герои, ресурсы.
    """
    troops      = player.get('troops', {})
    unit_levels = player.get('unit_levels', {})
    heroes      = player.get('heroes', [])
    spells      = player.get('spells', [])

    # ai_units (PKindCount[])
    troops_list = [(k, int(v)) for k, v in troops.items() if int(v) > 0]
    out  = w_u16(len(troops_list))
    for kind, count in troops_list:
        out += w_utf(kind) + w_u32(count)

    # ai_units_levels (PUnitsLevel[])
    ul_list = list(unit_levels.items())
    out += w_u16(len(ul_list))
    for kind, level in ul_list:
        out += w_utf(kind) + w_i32(int(level))

    # ai_heroes (PHero[])
    out += w_u16(len(heroes))
    for h in heroes:
        out += w_utf(str(h['kind']))
        out += w_u32(int(h.get('level', 1)))
        out += w_f64(float(h.get('time', time.time())))
        out += w_u32(int(h.get('u1', 1)))
        out += w_u32(int(h.get('u2', 1)))
        out += w_u32(int(h.get('u3', 2)))
        out += w_u32(int(h.get('u4', 0)))

    # ai_capacity_oil, ai_capacity_crystal, ai_gold
    out += w_u32(100_000)
    out += w_u32(100_000)
    out += w_u32(min(int(player.get('gold', 0)), 0xFFFFFFFF))

    # ai_spells[]
    out += w_u16(len(spells))
    for s in spells:
        out += w_utf(str(s))

    # ai_library_level, ai_calls, ai_townhall_level, ai_ruby
    # ai_calls = "энергия" вызова войск в бою (player['call']).
    # Если 0 — клиент не даст высаживать войска!
    out += w_i32(int(player.get('_library_level', 1)))
    out += w_i32(max(int(player.get('call', 5)), 5))  # минимум 5 чтобы всегда можно было бить
    out += w_i32(int(player.get('th_level', 1)))
    out += w_i32(int(player.get('ruby', 0)))

    return out


def _calc_camp_capacity(base: dict) -> int:
    """Примерная вместимость лагеря по уровням bl_camp."""
    CAP_PER_LEVEL = {1:5, 2:10, 3:15, 4:25, 5:35, 6:50, 7:60, 8:75, 9:90}
    total = 0
    for b in base.get('buildings', []):
        if b.get('kind', '').startswith('bl_camp') and b.get('state') == 'finished':
            lv  = int(b.get('level', 1))
            total += CAP_PER_LEVEL.get(lv, 5)
    return max(total, 20)   # минимум 20


def build_target_info_bytes(player: dict, base: dict,
                            fight_id: str = '',
                            attacker: dict | None = None) -> bytes:
    """
    Строит полный бинарный PTargetInfo.
    Используется в p10_3 (ответ 10x4), p10_5 (ответ 10x6), p2_1 (ответ 2x2 FIGHT).

    player   — данные ЦЕЛИ (база которую атакуют: профиль, карта, ресурсы)
    base     — base_state ЦЕЛИ (serialize_pum)
    attacker — данные АТАКУЮЩЕГО (войска, уровни юнитов, золото).
               Если None — используется player (для p10_3/p10_5 где цель = своя база).
               Для PvP поиска (p2_1) нужно передавать реального игрока-атакующего.

    Структура по PTargetInfo.as:
      PUserBase + PUm + oil + crystal + PFightType +
      inc_ratio + dec_ratio + PAttackerInfo + PShareFight +
      th_diff_k + storage_fight_k + time_now +
      prize[] + camp_capacity + warpoints +
      fight_id + opt_ticket + is_revenge + war_attack
    """
    now      = time.time()
    attacker = attacker if attacker is not None else player

    out  = _w_userbase(player)         # PUserBase — профиль ЦЕЛИ
    out += serialize_pum(base)         # PUm — карта ЦЕЛИ

    # Лут цели: ti_oil и ti_crystal = ПОЛНЫЕ ресурсы базы.
    # Клиент сам умножает на ti_storage_fight_k чтобы получить доступный лут.
    out += w_u32(min(int(player.get('oil',     0)), 0xFFFFFFFF))
    out += w_u32(min(int(player.get('crystal', 0)), 0xFFFFFFFF))

    # PFightType: variant=2 (SINGLE) — нет дополнительных данных
    out += w_u8(2)

    # Коэффициенты рейтинга — берутся из battle_config.json
    # inc_ratio передаётся как базовое значение; финальный расчёт в p20_9.py
    out += w_i32(100)   # ti_inc_ratio (100 = стандарт)
    out += w_i32(100)   # ti_dec_ratio

    out += _w_attacker_info(attacker) # PAttackerInfo — данные АТАКУЮЩЕГО

    # PShareFight = PSign(win) + PSign(lose)
    # PSign = utf sign_key + utf sign
    # Пустые строки — share-кнопки не работают, но бой запускается
    out += w_utf('') + w_utf('')      # win_sign
    out += w_utf('') + w_utf('')      # lose_sign

    # ti_storage_fight_k — доля ресурсов доступная для кражи.
    # Читается из battle_config.json → loot → storage_fight_k (по умолчанию 0.20)
    _bcfg_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'battle_config.json')
    try:
        import json as _json
        with open(_bcfg_path) as _bcfg_f:
            _bcfg = _json.load(_bcfg_f)
        _sfk = float(_bcfg.get('loot', {}).get('storage_fight_k', 0.20))
    except Exception:
        _sfk = 0.20
    out += w_f64(1.0)    # ti_th_diff_k (1.0 = нет разницы по ратуше)
    out += w_f64(_sfk)   # ti_storage_fight_k — доля доступного лута
    out += w_f64(now)    # ti_time_now

    # ti_prize[] — пустой: клиент считает приз сам через FIGHT_CMD_FINISH
    out += w_u16(0)

    out += w_i32(_calc_camp_capacity(base))  # ti_my_camp_capacity
    out += w_i32(0)                          # ti_warpoints

    out += w_utf(fight_id)   # ti_fight_id (может быть пустым)

    # ti_ticket = отсутствует (NaN в AS3)
    out += w_u8(0)

    out += w_bool(False)   # ti_is_revenge
    out += w_bool(False)   # ti_war_attack

    return out