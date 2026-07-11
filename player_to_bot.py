"""
player_to_bot.py — конвертер реального игрока в бота.

Использование:
  python3 player_to_bot.py                          # берёт player_state.json + base_state.json
  python3 player_to_bot.py my_player.json my_base.json   # свои файлы
  python3 player_to_bot.py --name "Барон Дракен"    # переопределить имя

Результат сохраняется в bots/pool/bot_lv<NN>_custom_<NN>.json
Можно запускать несколько раз с разными state-файлами.
"""

import json, os, sys, re

BASE_DIR  = os.path.abspath(os.path.dirname(__file__))
BOTS_DIR  = os.path.join(BASE_DIR, 'bots', 'pool')
os.makedirs(BOTS_DIR, exist_ok=True)

# ── Таблица брекетов ──────────────────────────────────────────────────────────
BRACKETS = [
    (1,10),(11,20),(21,25),(26,30),(31,35),(36,40),
    (41,45),(46,50),(51,55),(56,60),(61,65),(66,70),
    (71,75),(76,80),(81,85),(86,90),(91,95),(96,100),
    (101,103),(104,106),(107,109),(110,110),
]

def bracket_for(level: int) -> int:
    for i, (lo, hi) in enumerate(BRACKETS):
        if lo <= level <= hi:
            return i
    return len(BRACKETS) - 1


def _next_custom_idx(level: int) -> int:
    """Ищет следующий свободный номер для custom бота данного уровня."""
    pattern = re.compile(rf'bot_lv{level:03d}_custom_(\d+)\.json')
    existing = []
    if os.path.isdir(BOTS_DIR):
        for fname in os.listdir(BOTS_DIR):
            m = pattern.match(fname)
            if m:
                existing.append(int(m.group(1)))
    return max(existing, default=0) + 1


def convert(player_path: str, base_path: str, custom_name: str | None = None) -> str:
    """
    Читает player_state.json + base_state.json и создаёт бота.
    Возвращает путь к созданному файлу.
    """
    with open(player_path, 'r', encoding='utf-8') as f:
        player = json.load(f)
    with open(base_path, 'r', encoding='utf-8') as f:
        base = json.load(f)

    level = int(player.get('level', 1))
    name  = custom_name or player.get('name', f'Игрок lv{level}')

    # Генерируем уникальный bot_id
    idx    = _next_custom_idx(level)
    bot_id = f'bot-custom-lv{level:03d}-{idx:02d}'

    # Собираем бота из данных игрока
    bot = {
        # Профиль
        'user_id':     bot_id,
        'name':        name,
        'avatar':      '',
        'avatar_small':'',
        'avatar_big':  '',
        'profile_url': '',
        'level':       level,
        'th_level':    int(player.get('th_level', 1)),
        'sex':         player.get('sex', 'm'),
        'exp':         int(player.get('exp', 0)),
        'ratio':       int(player.get('ratio', 1000)),
        'account_id':  'bot',
        'snetwork':    'bot',
        'scouting':    0.0,
        'clan':        None,
        'clan_points': None,
        'heroes':      [],
        'troops':      {},   # Войска сброшены — бот не атакует
        'unit_levels': dict(player.get('unit_levels', {})),
        # Ресурсы (берём от игрока, это будет лут)
        'gold':     int(player.get('gold',     0)),
        'crystal':  int(player.get('crystal',  0)),
        'oil':      int(player.get('oil',      0)),
        'mithril':  int(player.get('mithril',  0)),
        'hglory':   int(player.get('hglory',   0)),
        'ruby':     int(player.get('ruby',     0)),
        'blue_print':int(player.get('blue_print',0)),
        'jglory':   int(player.get('jglory',   0)),
        'rar_dragon':int(player.get('rar_dragon',0)),
        # База — берём как есть
        'buildings':         base.get('buildings', []),
        'cannons':           base.get('cannons', []),
        'fences':            base.get('fences', []),
        'decors':            base.get('decors', []),
        'garbages':          base.get('garbages', []),
        'object_id_counter': base.get('object_id_counter', 47),
    }

    fname = f'bot_lv{level:03d}_custom_{idx:02d}.json'
    path  = os.path.join(BOTS_DIR, fname)
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(bot, f, ensure_ascii=False, indent=2)

    return path


def main():
    args = sys.argv[1:]

    custom_name  = None
    player_path  = os.path.join(BASE_DIR, 'player_state.json')
    base_path    = os.path.join(BASE_DIR, 'base_state.json')

    i = 0
    while i < len(args):
        if args[i] == '--name' and i + 1 < len(args):
            custom_name = args[i + 1]; i += 2
        elif not args[i].startswith('--') and os.path.exists(args[i]):
            if player_path == os.path.join(BASE_DIR, 'player_state.json'):
                player_path = args[i]
            else:
                base_path = args[i]
            i += 1
        else:
            print(f'Неизвестный аргумент: {args[i]}')
            i += 1

    if not os.path.exists(player_path):
        print(f'Файл не найден: {player_path}')
        sys.exit(1)
    if not os.path.exists(base_path):
        print(f'Файл не найден: {base_path}')
        sys.exit(1)

    path = convert(player_path, base_path, custom_name)

    with open(path) as f:
        bot = json.load(f)

    print(f'\nГотово!')
    print(f'  Файл:    {path}')
    print(f'  Имя:     {bot["name"]}')
    print(f'  Уровень: {bot["level"]}')
    print(f'  Ресурсы: crystal={bot["crystal"]:,}  oil={bot["oil"]:,}  gold={bot["gold"]:,}')
    print(f'  Зданий:  {len(bot["buildings"])}   Пушек: {len(bot["cannons"])}')
    print(f'  Брекет:  {BRACKETS[bracket_for(bot["level"])]}')


if __name__ == '__main__':
    main()