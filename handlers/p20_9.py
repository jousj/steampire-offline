"""
тут тоже есть вайбкод
"""

import struct, os, sys, json, time, math

PROTOCOL_VERSION = 77
BASE_DIR     = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
HISTORY_PATH = os.path.join(BASE_DIR, 'bots', 'history.json')
CFG_PATH     = os.path.join(BASE_DIR, 'battle_config.json')

if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

import state as _state


# ── Конфиг ────────────────────────────────────────────────────────────────────

def _cfg() -> dict:
    try:
        with open(CFG_PATH, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception:
        return {}


# ── История ───────────────────────────────────────────────────────────────────

def _load_hist() -> dict:
    try:
        with open(HISTORY_PATH, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception:
        return {}


def _save_hist(h: dict) -> None:
    try:
        os.makedirs(os.path.dirname(HISTORY_PATH), exist_ok=True)
        tmp = HISTORY_PATH + '.tmp'
        with open(tmp, 'w', encoding='utf-8') as f:
            json.dump(h, f, ensure_ascii=False, indent=2)
        os.replace(tmp, HISTORY_PATH)
    except Exception as e:
        print(f'  [20x9] history save error: {e}')


def _bot_level_from_fight(fight_id: str) -> int:
    """Возвращает уровень бота по fight_id из history."""
    if not fight_id:
        return 0
    h = _load_hist()
    for bot_id, entry in h.items():
        if entry.get('last_fight_id') == fight_id:
            pool = os.path.join(BASE_DIR, 'bots', 'pool', bot_id + '.json')
            try:
                with open(pool) as f:
                    return int(json.load(f).get('level', 0))
            except Exception:
                return 0
    return 0


# ── Парсер PClientSimRes ──────────────────────────────────────────────────────

def _parse(body: bytes) -> dict | None:
    try:
        pos = 8

        def u8():
            nonlocal pos
            v = body[pos]; pos += 1; return v

        def u16():
            nonlocal pos
            v = struct.unpack_from('<H', body, pos)[0]; pos += 2; return v

        def i32():
            nonlocal pos
            v = struct.unpack_from('<i', body, pos)[0]; pos += 4; return v

        def u32():
            nonlocal pos
            v = struct.unpack_from('<I', body, pos)[0]; pos += 4; return v

        def utf():
            nonlocal pos
            n = u16()
            s = body[pos:pos+n].decode('utf-8', errors='replace')
            pos += n
            return s

        def i16():
            nonlocal pos
            v = struct.unpack_from('<h', body, pos)[0]; pos += 2; return v

        def skip_pcost():
            nonlocal pos
            v = u8()
            if v == 10:
                return {'variance': 10, 'value': None}
            val = u32() if v <= 5 else i32()
            return {'variance': v, 'value': val}

        def skip_cmd_kind():
            v = u8()
            if v == 0:      # CMD_UNIT
                utf(); i16(); i16(); u16()
                if u8() == 1: i16(); i16()
            elif v == 1:    # CMD_SPELL
                utf(); i16(); i16()
            elif v == 2:    # CMD_FINISH
                u32()
                for _ in range(u16()): skip_pcost()
            elif v == 3:    u8()  # CMD_MESSAGE (упрощённо)
            elif v == 4:    i32() # CMD_BUY_POW

        fight_id = utf()

        n_cmd = u16()
        for _ in range(n_cmd):
            skip_cmd_kind()
            u32()   # cm_time
            utf()   # cm_user_id

        prize = [skip_pcost() for _ in range(u16())]
        percentage = i32()
        is_win     = u8() != 0

        return {'fight_id': fight_id, 'prize': prize,
                'percentage': percentage, 'is_win': is_win}
    except Exception as e:
        print(f'  [20x9] parse error: {e}')
        return None


# ── Расчёт выживших войск ─────────────────────────────────────────────────────

def _calc_survivors(deployed: dict, percentage: int, is_win: bool, cfg: dict) -> dict:
    """
    Возвращает словарь {kind: count} выживших войск.

    battle_config.json → troops:
      win_death_ratio  — доля погибших при 100% разрушении в случае победы  (def 0.6)
      lose_death_ratio — доля погибших при 100% разрушении в случае пораж.  (def 0.3)

    Формула: died = round(deployed * death_ratio * pct/100)
             survived = deployed - died
    """
    t = cfg.get('troops', {})
    win_dr  = float(t.get('win_death_ratio',  0.6))
    lose_dr = float(t.get('lose_death_ratio', 0.3))

    death_ratio = win_dr if is_win else lose_dr
    survivors = {}
    for kind, count in deployed.items():
        died     = round(count * death_ratio * percentage / 100)
        survived = max(0, count - died)
        survivors[kind] = survived
    return survivors


# ── Расчёт рейтинга ───────────────────────────────────────────────────────────

def _calc_ratio_delta(player_lv: int, bot_lv: int,
                      pct: int, is_win: bool, cfg: dict) -> int:
    r = cfg.get('ratio', {})
    inc_base     = float(r.get('inc_base',          30))
    dec_base     = float(r.get('dec_base',          15))
    bonus_10     = float(r.get('level_bonus_per_10', 0.15))
    min_gain     = int(r.get('min_gain',             5))
    max_gain     = int(r.get('max_gain',           200))
    max_loss     = int(r.get('max_loss',            50))

    diff = bot_lv - player_lv  # >0 бот сильнее

    if is_win:
        # Победа: базовый прирост × коэф уровня × % разрушения
        coef = 1.0 + (diff / 10.0) * bonus_10
        coef = max(0.5, coef)
        gain = inc_base * coef * (pct / 100.0)
        return max(min_gain, min(max_gain, round(gain)))
    else:
        # Поражение: фиксированный штраф dec_base (как в оригинале — dec_ratio постоянный)
        # Бонус: если бот намного сильнее — штраф меньше (проиграли достойно)
        coef = max(0.5, 1.0 - (diff / 10.0) * bonus_10 * 0.5)
        loss = dec_base * coef
        return -max(0, min(max_loss, round(loss)))


# ── Главный обработчик ────────────────────────────────────────────────────────

def handle(body: bytes) -> bytes:
    print(f'  [20x9] пакет {len(body)} байт')

    result = _parse(body)
    if result is None:
        return struct.pack('<HBBI', 32, 9, PROTOCOL_VERSION, 0)

    fight_id   = result['fight_id']
    prize      = result['prize']
    percentage = result['percentage']
    is_win     = result['is_win']
    cfg        = _cfg()

    verdict = 'ПОБЕДА' if is_win else 'ПОРАЖЕНИЕ'
    print(f'  [20x9] {verdict} {percentage}%  fight={fight_id[:8]}...')

    with _state.acquire_state_lock():
        player = _state.load_player()
        base   = _state.load_base(player)

        # ── 1. Зачисляем лут с проверкой вместимости хранилищ ────────────────
        oil_max, crystal_max = _state.calc_max_storage(base)
        RES = {1: 'crystal', 2: 'oil', 0: 'gold'}
        gained = {}
        for cost in prize:
            pv  = cost.get('variance')
            val = cost.get('value')
            if pv not in RES or not val or int(val) <= 0:
                continue
            key    = RES[pv]
            amount = int(val)
            cur    = int(player.get(key, 0))

            if key == 'crystal':
                cap = crystal_max
            elif key == 'oil':
                cap = oil_max
            else:
                cap = 999_999_999

            if cur >= cap:
                print(f'  [20x9] {key} хранилище переполнено ({cur:,}/{cap:,}), лут не начислен')
                continue

            add = min(amount, cap - cur)
            player[key] = cur + add
            gained[key] = gained.get(key, 0) + add

        if gained:
            print('  [20x9] лут: ' + '  '.join(f'+{v:,} {k}' for k, v in gained.items()))
        else:
            print('  [20x9] лут: ничего не зачислено')

        # ── 2. Войска: возвращаем выживших, списываем только погибших ─────────
        deployed = player.pop('_battle_deployed', {})
        if deployed:
            survivors = _calc_survivors(deployed, percentage, is_win, cfg)
            troops = player.setdefault('troops', {})
            parts  = []
            for kind, survived in survivors.items():
                sent  = deployed.get(kind, 0)
                died  = sent - survived
                # troops уже уменьшен на sent при CMD_UNIT — добавляем выживших обратно
                troops[kind] = int(troops.get(kind, 0)) + survived
                if died > 0 or survived > 0:
                    parts.append(f'{kind}: -{died} погибло, +{survived} вернулось')
            if parts:
                print('  [20x9] войска: ' + '; '.join(parts))
        else:
            print('  [20x9] войска: нет данных о высадке')

                # ── 3. Рейтинг ────────────────────────────────────────────────────────────────────────
        # Очищаем активный бой
        player.pop('_active_fight_id', None)
        player.pop('_active_fight_bot_lv', None)

        new_ratio = int(player.get('ratio', 1000))

        if player.pop('_surrender_rated', False):
            # Сдача уже обработана в p10_24
            delta = 0
            print('  [20x9] рейтинг: пропускаем (сдача, уже обработана в 10x24)')
        else:
            player_lv = int(player.get('level', 1))
            bot_lv    = _bot_level_from_fight(fight_id) or player_lv
            delta     = _calc_ratio_delta(player_lv, bot_lv, percentage, is_win, cfg)
            old_ratio = new_ratio
            new_ratio = max(0, old_ratio + delta)
            player['ratio'] = new_ratio
            sign = '+' if delta >= 0 else ''
            print(f'  [20x9] рейтинг: {old_ratio} {sign}{delta} → {new_ratio}'
                  f'  (игрок lv{player_lv} vs бот lv{bot_lv})')

        # ── 4. Статистика бота ────────────────────────────────────────────────
        h = _load_hist()
        for bot_id, entry in h.items():
            if entry.get('last_fight_id') == fight_id:
                entry['win' if is_win else 'lose'] = \
                    entry.get('win' if is_win else 'lose', 0) + 1
                entry['last_percentage'] = percentage
                _save_hist(h)
                break

        _state.save_player(player)

    print(f'  [20x9] OK | crystal={player.get("crystal",0):,} '
          f'oil={player.get("oil",0):,} ratio={new_ratio}')
    return struct.pack('<HBBI', 32, 9, PROTOCOL_VERSION, 0)