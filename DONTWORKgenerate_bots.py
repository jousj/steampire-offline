"""
generate_bots.py — генератор ботов для всех брекетов.
Запуск: python3 generate_bots.py
Выход: bots/pool/bot_lv<NN>_<N>.json

Все настройки вынесены в блок CONFIG в начале файла.
"""

import json, os, random

# ============================================================================
#  КОНФИГУРАЦИЯ — меняйте здесь всё, что нужно
# ============================================================================

CONFIG = {
    # ---- Общие параметры -------------------------------------------------
    "BOTS_DIR": "bots/pool",          # папка для сохранения ботов
    "HISTORY_PATH": "bots/history.json", # файл истории боёв
    "LEVEL_TABLE_FALLBACK_MAX": 115,   # максимальный уровень для fallback таблицы exp

    # ---- Брекеты и количество ботов --------------------------------------
    # Каждый элемент: (мин_уровень, макс_уровень)
    "BRACKETS": [
        (1, 10), (11, 20), (21, 25), (26, 30), (31, 35), (36, 40),
        (41, 45), (46, 50), (51, 55), (56, 60), (61, 65), (66, 70),
        (71, 75), (76, 80), (81, 85), (86, 90), (91, 95), (96, 100),
        (101, 103), (104, 106), (107, 109), (110, 110),
    ],
    "BOTS_PER_BRACKET": 50,            # сколько ботов генерировать на один брекет

    # ---- Имена и титулы --------------------------------------------------
    "FIRST_NAMES": [
        'Иван', 'Мария', 'Дмитрий', 'Анна', 'Алексей', 'Екатерина',
        'Сергей', 'Ольга', 'Андрей', 'Наталья', 'Владимир', 'Татьяна',
        'Михаил', 'Елена', 'Николай', 'Светлана', 'Павел', 'Ирина',
        'Александр', 'Юлия', 'Пётр', 'Людмила', 'Борис', 'Галина',
        'Константин', 'Вера', 'Виктор', 'Надежда', 'Василий', 'Любовь',
        'Григорий', 'Софья', 'Евгений', 'Анастасия', 'Фёдор', 'Дарья',
        'Илья', 'Полина', 'Артём', 'Алиса',
    ],
    "FEMALE_NAMES": {  # множество женских имён
        'Мария', 'Анна', 'Екатерина', 'Ольга', 'Наталья', 'Татьяна', 'Елена',
        'Светлана', 'Ирина', 'Юлия', 'Людмила', 'Галина', 'Вера', 'Надежда',
        'Любовь', 'Софья', 'Анастасия', 'Дарья', 'Полина', 'Алиса'
    },
    "LAST_NAMES_MALE": [
        'Иванов', 'Петров', 'Сидоров', 'Смирнов', 'Кузнецов', 'Попов',
        'Васильев', 'Михайлов', 'Фёдоров', 'Морозов', 'Волков', 'Зайцев',
        'Соколов', 'Лебедев', 'Козлов', 'Новиков', 'Медведев', 'Воробьёв',
        'Титов', 'Соловьёв', 'Крылов', 'Баранов', 'Ершов', 'Щукин',
        'Умнов', 'Мудров', 'Добромыслов', 'Тихомиров', 'Благонравов', 'Милославский',
        'Довлатов', 'Ломоносов', 'Академиков', 'Философов', 'Гуманитарцев', 'Космицин',
        'Звездинский', 'Побединский', 'Честнов', 'Справедливов', 'Гордый', 'Разумовский',
        'Берёзкин', 'Дубов', 'Клёнов', 'Соснин', 'Рябинин', 'Цветков',
        'Розов', 'Лилов', 'Янтарёв', 'Небосводов', 'Ветров', 'Зорькин',
        'Луговой', 'Полевой', 'Лесной', 'Горский', 'Речной', 'Озёрский',
        'Болконский', 'Облонский', 'Шереметев', 'Волконский', 'Трубецкой', 'Голицын',
        'Ордынцев', 'Пожарский', 'Ростовцев', 'Курагин', 'Безухов', 'Мышкин',
        'Добряков', 'Злых', 'Тихий', 'Быстров', 'Смехов', 'Плаксин',
        'Молчунов', 'Шумов', 'Громов', 'Ласков', 'Кислых', 'Сладков'
    ],
    "LAST_NAMES_FEMALE": [
        'Иванова', 'Петрова', 'Сидорова', 'Смирнова', 'Кузнецова', 'Попова',
        'Васильева', 'Михайлова', 'Фёдорова', 'Морозова', 'Волкова', 'Зайцева',
        'Соколова', 'Лебедева', 'Козлова', 'Новикова', 'Медведева', 'Воробьёва',
        'Титова', 'Соловьёва', 'Крылова', 'Баранова', 'Ершова', 'Щукина',
        'Умнова', 'Мудрова', 'Добромыслова', 'Тихомирова', 'Благонравова', 'Милославская',
        'Довлатова', 'Ломоносова', 'Академикова', 'Философова', 'Гуманитарцева', 'Космицина',
        'Звездинская', 'Побединская', 'Честнова', 'Справедливова', 'Гордая', 'Разумовская',
        'Берёзкина', 'Дубова', 'Клёнова', 'Соснина', 'Рябинина', 'Цветкова',
        'Розова', 'Лилова', 'Янтарёва', 'Небосводова', 'Ветрова', 'Зорькина',
        'Луговая', 'Полевая', 'Лесная', 'Горская', 'Речная', 'Озёрская',
        'Болконская', 'Облонская', 'Шереметева', 'Волконская', 'Трубецкая', 'Голицына',
        'Ордынцева', 'Пожарская', 'Ростовцева', 'Курагина', 'Безухова', 'Мышкина',
        'Добрякова', 'Злых', 'Тихая', 'Быстрова', 'Смехова', 'Плаксина',
        'Молчунова', 'Шумова', 'Громова', 'Ласкова', 'Кислых', 'Сладкова'
    ],
    "TITLES_LOW": ['', '', '', '', ''],   # титулы для уровней < 70
    "TITLES_HIGH": ['', '', '', '', ''],  # титулы для уровней >= 70
    "TITLE_LEVEL_THRESHOLD": 70,          # уровень, после которого даются высокие титулы

    # ---- Пушки ------------------------------------------------------------
    # Список (мин_уровень_бота, вид_пушки)
    "CANNON_UNLOCK": [
        (1, 'cn_ballista'), (1, 'cn_steam_tower'), (5, 'cn_flamethrower'),
        (8, 'cn_mortar'), (10, 'cn_freezing_tower'), (15, 'cn_air'),
        (20, 'cn_dwarf_tower'), (25, 'cn_tesla_coil'), (30, 'cn_magnetic_tower'),
        (35, 'cn_cannon'), (45, 'cn_gauss_cannon'),
    ],
    # Формула количества пушек: clamp( A + bot_lv // B, мин, макс )
    "CANNON_COUNT_A": 1,
    "CANNON_COUNT_B": 5,
    "CANNON_COUNT_MIN": 1,
    # Уровень пушек: bot_lv * scale, зажатый в [1, max_lv]
    "CANNON_LEVEL_SCALE": 0.22,
    "CANNON_LEVEL_MAX": 40,
    "CANNON_LEVEL_RANDOM": (-2, 2),      # случайное отклонение уровня

    # ---- Юниты ------------------------------------------------------------
    # Список (мин_уровень_бота, id_юнита, базовый_уровень)
    "UNIT_UNLOCK": [
        (1, 'un_warrior', 1), (1, 'un_sniper', 1), (1, 'un_dragon', 1),
        (5, 'un_motocycle', 1), (10, 'un_troll', 1), (15, 'un_swarm', 1),
        (20, 'un_fairy', 1), (25, 'un_healer', 1), (30, 'un_dwarf', 1),
        (35, 'un_golem', 1), (40, 'un_disinfector', 1), (50, 'un_tank', 1),
        (15, 'un_warrior_elite', 1), (20, 'un_sniper_elite', 1),
        (25, 'un_motocycle_elite', 1), (35, 'un_troll_elite', 1),
    ],
    "UNIT_LEVEL_STEP": 15,               # каждые N уровней бота +1 к уровню юнита
    "UNIT_LEVEL_MAX": 10,                # максимальный уровень юнита

    # ---- Здания -----------------------------------------------------------
    # Ратуша: level = bot_lv // DIV + ADD, зажато в [1, MAX]
    "TH_LEVEL_DIV": 10,
    "TH_LEVEL_ADD": 1,
    "TH_LEVEL_MAX": 12,

    # Строители: количество = clamp(1 + bot_lv // DIV, 1, MAX)
    "BUILDERS_DIV": 20,
    "BUILDERS_MAX": 5,
    "BUILDER_POSITIONS": [(9,9), (39,9), (9,39), (39,39), (24,6)],

    # Казарма: scale и max_lv для bld_level
    "BARRACKS_SCALE": 0.10,
    "BARRACKS_MAX_LV": 11,

    # Лагеря: количество = clamp(1 + bot_lv // DIV, 1, MAX), уровень = bld_level(scale, max_lv)
    "CAMPS_COUNT_DIV": 15,
    "CAMPS_MAX_COUNT": 4,
    "CAMPS_LEVEL_SCALE": 0.20,
    "CAMPS_LEVEL_MAX": 40,
    "CAMPS_LEVEL_RANDOM": (-1, 1),

    # Шахты нефти и кристаллов: количество = clamp(1 + bot_lv // DIV, 1, MAX)
    "MINE_COUNT_DIV": 10,
    "MINE_MAX_COUNT": 8,
    "MINE_LEVEL_SCALE": 0.25,
    "MINE_LEVEL_MAX": 40,
    "MINE_LEVEL_RANDOM": (0, 2),

    # Хранилища: количество = clamp(1 + bot_lv // DIV, 1, MAX)
    "STORAGE_COUNT_DIV": 20,
    "STORAGE_MAX_COUNT": 4,
    "STORAGE_LEVEL_SCALE": 0.20,
    "STORAGE_LEVEL_MAX": 40,
    "STORAGE_LEVEL_RANDOM": (0, 1),

    # Академия: минимальный уровень бота для появления, scale, max_lv
    "ACADEMY_MIN_LV": 5,
    "ACADEMY_LEVEL_SCALE": 0.08,
    "ACADEMY_LEVEL_MAX": 12,

    # Центр исследований: минимальный уровень, scale, max_lv
    "RESEARCH_CENTER_MIN_LV": 15,
    "RESEARCH_CENTER_LEVEL_SCALE": 0.06,
    "RESEARCH_CENTER_LEVEL_MAX": 10,

    # Мастерская героя: минимальный уровень, scale, max_lv
    "HERO_WORKSHOP_MIN_LV": 20,
    "HERO_WORKSHOP_LEVEL_SCALE": 0.06,
    "HERO_WORKSHOP_LEVEL_MAX": 10,

    # Библиотека: минимальный уровень, scale, max_lv
    "LIBRARY_MIN_LV": 30,
    "LIBRARY_LEVEL_SCALE": 0.06,
    "LIBRARY_LEVEL_MAX": 12,

    # Портал: минимальный уровень
    "PORTAL_MIN_LV": 20,

    # Сторожевые башни: минимальный уровень, количество = clamp(bot_lv // DIV, 1, MAX)
    "GUARD_TOWER_MIN_LV": 25,
    "GUARD_TOWER_COUNT_DIV": 20,
    "GUARD_TOWER_MAX_COUNT": 4,
    "GUARD_TOWER_LEVEL_SCALE": 0.07,
    "GUARD_TOWER_LEVEL_MAX": 13,

    # Электростанции: количество = clamp(bot_lv // DIV, 1, MAX)
    "POWER_PLANT_COUNT_DIV": 8,
    "POWER_PLANT_MAX_COUNT": 8,
    "POWER_PLANT_LEVEL_SCALE": 0.22,
    "POWER_PLANT_LEVEL_MAX": 40,
    "POWER_PLANT_LEVEL_RANDOM": (0, 2),

    # Заборы: минимальный уровень, типы (wood/stone), уровень = bld_level(scale, max_lv)
    "FENCE_MIN_LV": 15,
    "FENCE_WOOD_MAX_LV": 40,    # до какого уровня бота деревянные, выше — каменные
    "FENCE_LEVEL_SCALE": 0.10,
    "FENCE_LEVEL_MAX": 10,

    # ---- Ресурсы ----------------------------------------------------------
    "RESOURCE_FACTOR_POWER": 1.8,          # степень для factor = bot_lv ** POWER
    "RESOURCE_CRYSTAL_MULT": 80,
    "RESOURCE_OIL_MULT": 75,
    "RESOURCE_GOLD_MULT": 1.5,
    "RESOURCE_MITHRIL_MULT": 150,
    "RESOURCE_MITHRIL_MIN_LV": 20,
    "RESOURCE_RANDOM_CRYSTAL": (0.8, 2.0), # (мин, макс) для uniform
    "RESOURCE_RANDOM_OIL": (0.8, 2.0),
    "RESOURCE_RANDOM_GOLD": (0.8, 1.2),
    "RESOURCE_RANDOM_MITHRIL": (0.7, 1.3),
    "RESOURCE_HGLORY_MULT": 10,
    "RESOURCE_HGLORY_RANDOM": (0.5, 1.5),
    "RESOURCE_MAX": 999_999_999,           # максимальное значение каждого ресурса

    # ---- Прочее -----------------------------------------------------------
    "RATIO_BASE": 200,                     # ratio = BASE + bot_lv * STEP
    "RATIO_STEP": 18,
    "RATIO_MIN": 100,
    "RATIO_MAX": 5000,

    # ---- Планировка базы (координаты) ------------------------------------
    # Можно менять, но осторожно — должны быть уникальные позиции
    "RING_POSITIONS": {
        'th': [(24, 24)],
        'econ': [(18,18), (30,18), (18,30), (30,30), (24,15), (24,33), (15,24), (33,24),
                 (18,24), (30,24), (24,18), (24,30)],
        'prod': [(12,12), (36,12), (12,36), (36,36), (12,18), (36,18), (12,30), (36,30),
                 (18,12), (30,12), (18,36), (30,36)],
        'outer': [(9,9), (39,9), (9,39), (39,39), (9,18), (39,18), (9,30), (39,30),
                  (18,9), (30,9), (18,39), (30,39)],
        'cannon_inner': [(21,21), (27,21), (21,27), (27,27), (18,21), (30,21), (21,18), (21,30),
                         (27,18), (27,30), (18,27), (30,27)],
        'cannon_outer': [(15,15), (33,15), (15,33), (33,33), (15,21), (33,21), (15,27), (33,27),
                         (21,15), (21,33), (27,15), (27,33)],
        'cannon_edge': [(12,15), (36,15), (12,21), (36,21), (12,27), (36,27), (12,33), (36,33),
                        (15,12), (21,12), (27,12), (33,12), (15,36), (21,36), (27,36), (33,36)],
    },
}

# ============================================================================
#  КОД ГЕНЕРАЦИИ (не требует изменений, всё берёт из CONFIG)
# ============================================================================

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
BOTS_DIR = os.path.join(BASE_DIR, CONFIG["BOTS_DIR"])
os.makedirs(BOTS_DIR, exist_ok=True)

def clamp(val, lo, hi):
    return max(lo, min(hi, val))

def bld_level(bot_lv, scale, max_lv):
    return clamp(round(bot_lv * scale), 1, max_lv)

def load_level_table():
    path = os.path.join(BASE_DIR, 'level_config.json')
    if os.path.exists(path):
        with open(path) as f:
            return json.load(f)
    # fallback
    return [{'id': i+1, 'req': i*(i+1)*75//2} for i in range(CONFIG["LEVEL_TABLE_FALLBACK_MAX"])]

LEVEL_TABLE = load_level_table()

def level_to_exp(level):
    idx = max(0, min(level-1, len(LEVEL_TABLE)-1))
    return LEVEL_TABLE[idx]['req']

def make_name(level, seed):
    rng = random.Random(seed)
    fn = rng.choice(CONFIG["FIRST_NAMES"])
    if fn in CONFIG["FEMALE_NAMES"]:
        ln = rng.choice(CONFIG["LAST_NAMES_FEMALE"])
    else:
        ln = rng.choice(CONFIG["LAST_NAMES_MALE"])
    if level >= CONFIG["TITLE_LEVEL_THRESHOLD"]:
        title = rng.choice(CONFIG["TITLES_HIGH"])
    else:
        title = rng.choice(CONFIG["TITLES_LOW"])
    return f'{title}{fn} {ln}'.strip()

def available_cannons(bot_lv):
    return [k for min_lv, k in CONFIG["CANNON_UNLOCK"] if bot_lv >= min_lv]

def make_unit_levels(bot_lv):
    ul = {}
    for min_lv, kind, base_lv in CONFIG["UNIT_UNLOCK"]:
        if bot_lv >= min_lv:
            research_lv = base_lv + (bot_lv - min_lv) // CONFIG["UNIT_LEVEL_STEP"]
            ul[kind] = clamp(research_lv, base_lv, CONFIG["UNIT_LEVEL_MAX"])
    return ul

def generate_base(bot_lv, seed):
    rng = random.Random(seed)
    objs = {'buildings': [], 'cannons': [], 'fences': [], 'decors': [], 'garbages': []}
    oid = 1
    rings = CONFIG["RING_POSITIONS"]

    def add_bld(kind, level, x, y, spec):
        nonlocal oid
        objs['buildings'].append({'id': oid, 'kind': kind, 'level': level,
                                  'x': x, 'y': y, 'state': 'finished', 'finish_time': None, 'spec': spec})
        oid += 1
    def add_cn(kind, level, x, y):
        nonlocal oid
        objs['cannons'].append({'id': oid, 'kind': kind, 'level': level,
                                'x': x, 'y': y, 'state': 'finished', 'finish_time': None})
        oid += 1
    def add_fence(kind, level, x, y):
        nonlocal oid
        objs['fences'].append({'id': oid, 'kind': kind, 'level': level, 'x': x, 'y': y})
        oid += 1

    econ = list(rings['econ'])
    prod = list(rings['prod'])
    outer = list(rings['outer'])
    ci = list(rings['cannon_inner'])
    co = list(rings['cannon_outer'])
    ce = list(rings['cannon_edge'])

    # Ратуша
    th_lv = clamp(bot_lv // CONFIG["TH_LEVEL_DIV"] + CONFIG["TH_LEVEL_ADD"], 1, CONFIG["TH_LEVEL_MAX"])
    add_bld('bl_town_hall', th_lv, 24, 24, {'type': 'townhall'})

    # Строители
    n_builders = clamp(1 + bot_lv // CONFIG["BUILDERS_DIV"], 1, CONFIG["BUILDERS_MAX"])
    for i in range(n_builders):
        x, y = CONFIG["BUILDER_POSITIONS"][i]
        add_bld('bl_builder', 1, x, y, {'type': 'worker'})

    # Казарма
    bar_lv = bld_level(bot_lv, CONFIG["BARRACKS_SCALE"], CONFIG["BARRACKS_MAX_LV"])
    add_bld('bl_barracks', bar_lv, *econ.pop(0), {'type': 'barrack'})

    # Лагеря
    n_camps = clamp(1 + bot_lv // CONFIG["CAMPS_COUNT_DIV"], 1, CONFIG["CAMPS_MAX_COUNT"])
    camp_lv = bld_level(bot_lv, CONFIG["CAMPS_LEVEL_SCALE"], CONFIG["CAMPS_LEVEL_MAX"])
    for _ in range(n_camps):
        if econ:
            lv = camp_lv + rng.randint(*CONFIG["CAMPS_LEVEL_RANDOM"])
            add_bld('bl_camp', lv, *econ.pop(0), {'type': 'camp'})

    # Шахты нефти
    n_oil = clamp(1 + bot_lv // CONFIG["MINE_COUNT_DIV"], 1, CONFIG["MINE_MAX_COUNT"])
    oil_lv = bld_level(bot_lv, CONFIG["MINE_LEVEL_SCALE"], CONFIG["MINE_LEVEL_MAX"])
    for _ in range(n_oil):
        pos = econ.pop(0) if econ else prod.pop(0) if prod else outer.pop(0)
        lv = oil_lv + rng.randint(*CONFIG["MINE_LEVEL_RANDOM"])
        add_bld('bl_oil_tower', lv, *pos, {'type': 'resource', 'last_apply_time': 0, 'done_count': 0})

    # Шахты кристаллов
    n_crys = clamp(1 + bot_lv // CONFIG["MINE_COUNT_DIV"], 1, CONFIG["MINE_MAX_COUNT"])
    crys_lv = bld_level(bot_lv, CONFIG["MINE_LEVEL_SCALE"], CONFIG["MINE_LEVEL_MAX"])
    for _ in range(n_crys):
        pos = econ.pop(0) if econ else prod.pop(0) if prod else outer.pop(0)
        lv = crys_lv + rng.randint(*CONFIG["MINE_LEVEL_RANDOM"])
        add_bld('bl_crystal_mine', lv, *pos, {'type': 'resource', 'last_apply_time': 0, 'done_count': 0})

    # Хранилища нефти
    n_oils = clamp(1 + bot_lv // CONFIG["STORAGE_COUNT_DIV"], 1, CONFIG["STORAGE_MAX_COUNT"])
    oils_lv = bld_level(bot_lv, CONFIG["STORAGE_LEVEL_SCALE"], CONFIG["STORAGE_LEVEL_MAX"])
    for _ in range(n_oils):
        pos = prod.pop(0) if prod else outer.pop(0)
        lv = oils_lv + rng.randint(*CONFIG["STORAGE_LEVEL_RANDOM"])
        add_bld('bl_oil_storage', lv, *pos, {'type': 'storage'})

    # Хранилища кристаллов
    n_crys_s = clamp(1 + bot_lv // CONFIG["STORAGE_COUNT_DIV"], 1, CONFIG["STORAGE_MAX_COUNT"])
    for _ in range(n_crys_s):
        pos = prod.pop(0) if prod else outer.pop(0)
        lv = oils_lv + rng.randint(*CONFIG["STORAGE_LEVEL_RANDOM"])
        add_bld('bl_crystal_storage', lv, *pos, {'type': 'storage'})

    # Академия
    if bot_lv >= CONFIG["ACADEMY_MIN_LV"]:
        acad_lv = bld_level(bot_lv, CONFIG["ACADEMY_LEVEL_SCALE"], CONFIG["ACADEMY_LEVEL_MAX"])
        pos = prod.pop(0) if prod else outer.pop(0)
        add_bld('bl_academy', acad_lv, *pos, {'type': 'research'})

    # Центр исследований
    if bot_lv >= CONFIG["RESEARCH_CENTER_MIN_LV"]:
        rc_lv = bld_level(bot_lv, CONFIG["RESEARCH_CENTER_LEVEL_SCALE"], CONFIG["RESEARCH_CENTER_LEVEL_MAX"])
        pos = prod.pop(0) if prod else outer.pop(0)
        add_bld('bl_research_center', rc_lv, *pos, {'type': 'research'})

    # Мастерская героя
    if bot_lv >= CONFIG["HERO_WORKSHOP_MIN_LV"]:
        hw_lv = bld_level(bot_lv, CONFIG["HERO_WORKSHOP_LEVEL_SCALE"], CONFIG["HERO_WORKSHOP_LEVEL_MAX"])
        pos = outer.pop(0) if outer else (6, 24)
        add_bld('bl_hero_workshop', hw_lv, *pos, {'type': 'hero'})

    # Библиотека
    if bot_lv >= CONFIG["LIBRARY_MIN_LV"]:
        lib_lv = bld_level(bot_lv, CONFIG["LIBRARY_LEVEL_SCALE"], CONFIG["LIBRARY_LEVEL_MAX"])
        pos = outer.pop(0) if outer else (42, 24)
        add_bld('bl_library', lib_lv, *pos, {'type': 'library'})

    # Портал
    if bot_lv >= CONFIG["PORTAL_MIN_LV"]:
        pos = outer.pop(0) if outer else (24, 42)
        add_bld('bl_portal', 1, *pos, {'type': 'raid'})

    # Сторожевые башни
    if bot_lv >= CONFIG["GUARD_TOWER_MIN_LV"]:
        n_gt = clamp(bot_lv // CONFIG["GUARD_TOWER_COUNT_DIV"], 1, CONFIG["GUARD_TOWER_MAX_COUNT"])
        gt_lv = bld_level(bot_lv, CONFIG["GUARD_TOWER_LEVEL_SCALE"], CONFIG["GUARD_TOWER_LEVEL_MAX"])
        for _ in range(n_gt):
            pos = outer.pop(0) if outer else (9, 24)
            add_bld('bl_guard_tower', gt_lv, *pos, {'type': 'guard', 'config': [], 'count': 0})

    # Скаутинг
    pos = outer.pop(0) if outer else (42, 42)
    add_bld('bl_scouting_hh', 1, *pos, {'type': 'scouting'})

    # Электростанции
    n_pp = clamp(bot_lv // CONFIG["POWER_PLANT_COUNT_DIV"], 1, CONFIG["POWER_PLANT_MAX_COUNT"])
    pp_lv = bld_level(bot_lv, CONFIG["POWER_PLANT_LEVEL_SCALE"], CONFIG["POWER_PLANT_LEVEL_MAX"])
    for _ in range(n_pp):
        pos = econ.pop(0) if econ else prod.pop(0) if prod else outer.pop(0) if outer else (6, 6)
        lv = pp_lv + rng.randint(*CONFIG["POWER_PLANT_LEVEL_RANDOM"])
        add_bld('bl_power_plant', lv, *pos, {'type': 'resource', 'last_apply_time': 0, 'done_count': 0})

    # Пушки
    av_cannons = available_cannons(bot_lv)
    total_slots = len(ci) + len(co) + len(ce)
    n_cannons = clamp(CONFIG["CANNON_COUNT_A"] + bot_lv // CONFIG["CANNON_COUNT_B"],
                      1, total_slots)
    cn_lv_base = bld_level(bot_lv, CONFIG["CANNON_LEVEL_SCALE"], CONFIG["CANNON_LEVEL_MAX"])
    cannon_slots = ci + co + ce
    for i in range(min(n_cannons, total_slots)):
        kind = av_cannons[i % len(av_cannons)]
        lv = clamp(cn_lv_base + rng.randint(*CONFIG["CANNON_LEVEL_RANDOM"]), 1, CONFIG["CANNON_LEVEL_MAX"])
        add_cn(kind, lv, *cannon_slots[i])

    # Заборы
    if bot_lv >= CONFIG["FENCE_MIN_LV"]:
        fn_kind = 'fn_stone' if bot_lv >= CONFIG["FENCE_WOOD_MAX_LV"] else 'fn_wood'
        fn_lv = bld_level(bot_lv, CONFIG["FENCE_LEVEL_SCALE"], CONFIG["FENCE_LEVEL_MAX"])
        fence_ring = (
            [(x, 15) for x in range(15, 34, 3)] +
            [(x, 33) for x in range(15, 34, 3)] +
            [(15, y) for y in range(18, 33, 3)] +
            [(33, y) for y in range(18, 33, 3)]
        )
        for x, y in fence_ring:
            add_fence(fn_kind, fn_lv, x, y)

    objs['object_id_counter'] = oid - 1
    return objs

def calc_resources(bot_lv, seed):
    rng = random.Random(seed + 1000)
    factor = bot_lv ** CONFIG["RESOURCE_FACTOR_POWER"]
    crystal = int(factor * CONFIG["RESOURCE_CRYSTAL_MULT"] * rng.uniform(*CONFIG["RESOURCE_RANDOM_CRYSTAL"]))
    oil = int(factor * CONFIG["RESOURCE_OIL_MULT"] * rng.uniform(*CONFIG["RESOURCE_RANDOM_OIL"]))
    gold = int(factor * CONFIG["RESOURCE_GOLD_MULT"] * rng.uniform(*CONFIG["RESOURCE_RANDOM_GOLD"]))
    if bot_lv >= CONFIG["RESOURCE_MITHRIL_MIN_LV"]:
        mithril = int(bot_lv * CONFIG["RESOURCE_MITHRIL_MULT"] * rng.uniform(*CONFIG["RESOURCE_RANDOM_MITHRIL"]))
    else:
        mithril = 0
    return {
        'gold': min(gold, CONFIG["RESOURCE_MAX"]),
        'crystal': min(crystal, CONFIG["RESOURCE_MAX"]),
        'oil': min(oil, CONFIG["RESOURCE_MAX"]),
        'mithril': min(mithril, CONFIG["RESOURCE_MAX"]),
        'hglory': int(bot_lv * CONFIG["RESOURCE_HGLORY_MULT"] * rng.uniform(*CONFIG["RESOURCE_HGLORY_RANDOM"])),
        'ruby': 0,
    }

def make_bot(bot_lv, bracket_idx, bot_idx):
    seed = bracket_idx * 100 + bot_idx
    name = make_name(bot_lv, seed)
    bot_id = f'bot-{bot_lv:03d}-{bracket_idx:02d}-{bot_idx}'
    exp = level_to_exp(bot_lv)
    th_lv = clamp(bot_lv // CONFIG["TH_LEVEL_DIV"] + CONFIG["TH_LEVEL_ADD"], 1, CONFIG["TH_LEVEL_MAX"])
    base = generate_base(bot_lv, seed)
    resources = calc_resources(bot_lv, seed)
    ul = make_unit_levels(bot_lv)
    return {
        'user_id': bot_id, 'name': name, 'avatar': '', 'avatar_small': '', 'avatar_big': '',
        'profile_url': '', 'level': bot_lv, 'th_level': th_lv, 'sex': 'm', 'exp': exp,
        'ratio': clamp(CONFIG["RATIO_BASE"] + bot_lv * CONFIG["RATIO_STEP"], CONFIG["RATIO_MIN"], CONFIG["RATIO_MAX"]),
        'account_id': 'bot', 'snetwork': 'bot', 'scouting': 0.0, 'clan': None, 'clan_points': None,
        'heroes': [], 'troops': {}, 'unit_levels': ul, **resources,
        'blue_print': 0, 'jglory': 0, 'rar_dragon': 0, **base,
    }

def main():
    generated = 0
    for b_idx, (lv_min, lv_max) in enumerate(CONFIG["BRACKETS"]):
        spread = max(lv_max - lv_min, 0)
        steps = CONFIG["BOTS_PER_BRACKET"] - 1 if spread > 0 else 0
        for i in range(CONFIG["BOTS_PER_BRACKET"]):
            if steps > 0:
                bot_lv = lv_min + round(i * spread / steps)
            else:
                bot_lv = lv_min
            bot = make_bot(bot_lv, b_idx, i)
            fname = f'bot_lv{bot_lv:03d}_{i+1:02d}.json'
            path = os.path.join(BOTS_DIR, fname)
            with open(path, 'w', encoding='utf-8') as f:
                json.dump(bot, f, ensure_ascii=False, indent=2)
            generated += 1
            print(f'  [{generated:3d}] {fname}  "{bot["name"]}"  lv{bot_lv}'
                  f'  crystal={bot["crystal"]:,}  oil={bot["oil"]:,}'
                  f'  зданий={len(bot["buildings"])}  пушек={len(bot["cannons"])}')
    history_path = os.path.join(BASE_DIR, CONFIG["HISTORY_PATH"])
    if not os.path.exists(history_path):
        with open(history_path, 'w') as f:
            json.dump({}, f)
    print(f'\nГотово! Сгенерировано {generated} ботов → {BOTS_DIR}/')

if __name__ == '__main__':
    main()