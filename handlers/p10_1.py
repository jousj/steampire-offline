"""
! есть вайбкод !
handlers/p10_1.py — обработчик Packet_0010_01 / ответ Packet_0010_02

Честная экономика:
  - BUY_OBJECT / UPGRADE: проверяем баланс, вычитаем ресурсы, ставим in_progress + finish_time
  - SPEED_UP_*: вычитаем ресурсы, мгновенно завершаем (игрок сам заплатил)
  - UA_BUY_RESOURCES_PACK (action 20): начисляем ресурсы за кристаллы/mithril

Входящий пакет (family=16, subfamily=1):
  [8]  заголовок
  [2]  u16 action_count
  [N]  PUaPacket: double ua_time + PUserAction
  [1]  bool fetch_events (игнорируем)

Ответ (family=16, subfamily=2):
  [8]  заголовок
  [1]  variance=0 (OK)
  [2]  u16 event_count
  [N]  PUserEvent: 1 byte variant + i32 delta
  [8]  double server_time
"""

import struct
import time
import os
import sys

PROTOCOL_VERSION = 77
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

import state as _state

# ── Константы variance ────────────────────────────────────────────────────────

# PCost.variance
PCOST_GOLD    = 0
PCOST_CRYSTAL = 1
PCOST_OIL     = 2
PCOST_EXP     = 3
PCOST_HGLORY  = 4
PCOST_CALL    = 5
PCOST_MITHRIL = 9

# PUserEvent.variance (что клиент показывает на экране)
EV_GOLD    = 0
EV_CRYSTAL = 1
EV_OIL     = 2
EV_EXP     = 3

# PObjectId.variance
OBJ_BUILDING = 0
OBJ_CANNON   = 1
OBJ_FENCE    = 2
OBJ_DECOR    = 3
OBJ_GARBAGE  = 4

# PCommandKind.variance
CMD_UNIT    = 0
CMD_SPELL   = 1
CMD_FINISH  = 2
CMD_MESSAGE = 3
CMD_BUY_POW = 4

# PUserAction.variance
UA_BUY_OBJECT            = 0
UA_SPEED_UP_BUILDING     = 1
UA_SPEED_UP_CANNON       = 2
UA_UPGRADE               = 3
UA_MOVE                  = 4
UA_MAKE_UNIT             = 5
UA_COLLECT_RESOURCE      = 6
UA_START_STUDY           = 7
UA_SPEED_UP_STUDY        = 8
UA_REMOVE_GARBAGE        = 9
UA_SPEED_UP_GARBAGE      = 10
UA_FIGHT_ADD_COMMAND     = 11
UA_SET_GUARD_CONFIG      = 12
UA_CHARGE_GUARD          = 13
UA_DELETE_OBJECT         = 14
UA_USER_COMPLETE_QUEST   = 15
UA_EXECUTE_QUEST_TARGET  = 16
UA_BUY_RESOURCE_BY_GOLD  = 17
UA_READ_STORY            = 18
UA_BUY_SHIELD            = 19
UA_BUY_RESOURCES_PACK    = 20
UA_SPEED_UP_HERO         = 21
UA_READ_FIGHT_HIST       = 22
UA_CANCEL_BUILDING       = 23
UA_CANCEL_CANNON         = 24
UA_CANCEL_STUDY          = 25
UA_CANCEL_REMOVE_GARBAGE = 26
UA_UPGRADE_HERO          = 27
UA_REMOVE_UNIT           = 28
UA_BUY_CALLS             = 29
UA_READ_NEWS             = 30
UA_SELL_DECOR            = 31
UA_COLLECT_CLAN_CALLS    = 32
UA_CLAN_CALL_REQUEST     = 33
UA_SET_SPELLS            = 34
UA_CONVERT_ORE           = 35
UA_SPEED_UP_RAID         = 36
UA_REMOVE_SHOP_UNWATCHED = 37
UA_ENABLE_SHIELD_GEN     = 38
UA_BUY_UNITS_PACK        = 39
UA_SET_CUSTOM_DATA       = 40

ACTION_NAMES = {
    0:'BUY_OBJECT', 1:'SPEED_UP_BUILDING', 2:'SPEED_UP_CANNON',
    3:'UPGRADE', 4:'MOVE', 5:'MAKE_UNIT', 6:'COLLECT_RESOURCE',
    7:'START_STUDY', 8:'SPEED_UP_STUDY', 9:'REMOVE_GARBAGE',
    10:'SPEED_UP_GARBAGE', 11:'FIGHT_ADD_COMMAND', 12:'SET_GUARD_CONFIG',
    13:'CHARGE_GUARD', 14:'DELETE_OBJECT', 15:'USER_COMPLETE_QUEST',
    16:'EXECUTE_QUEST_TARGET', 17:'BUY_RESOURCE_BY_GOLD', 18:'READ_STORY',
    19:'BUY_SHIELD', 20:'BUY_RESOURCES_PACK', 21:'SPEED_UP_HERO',
    22:'READ_FIGHT_HIST', 23:'CANCEL_BUILDING', 24:'CANCEL_CANNON',
    25:'CANCEL_STUDY', 26:'CANCEL_REMOVE_GARBAGE', 27:'UPGRADE_HERO',
    28:'REMOVE_UNIT', 29:'BUY_CALLS', 30:'READ_NEWS', 31:'SELL_DECOR',
    32:'COLLECT_CLAN_CALLS', 33:'CLAN_CALL_REQUEST', 34:'SET_SPELLS',
    35:'CONVERT_ORE', 36:'SPEED_UP_RAID', 37:'REMOVE_SHOP_UNWATCHED',
    38:'ENABLE_SHIELD_GEN', 39:'BUY_UNITS_PACK', 40:'SET_CUSTOM_DATA',
}

OBJTYPES = {0:'building', 1:'cannon', 2:'fence', 3:'decor', 4:'garbage'}

# Spec type для нового здания (используется при BUY_OBJECT)
BUILDING_SPEC_TYPES = {
    'bl_town_hall': 'townhall', 'bl_builder': 'worker',
    'bl_barracks': 'barrack', 'bl_camp': 'camp',
    'bl_oil_tower': 'resource', 'bl_crystal_mine': 'resource',
    'bl_power_plant': 'pylon',    'bl_ruby_mine': 'resource',
    'bl_oil_storage': 'storage', 'bl_crystal_storage': 'storage',
    'bl_pylon': 'pylon', 'bl_academy': 'research', 'bl_library': 'library',
    'bl_clan_center': 'clan_center', 'bl_hero_workshop': 'hero',
    'bl_hero_jaina_workshop': 'hero', 'bl_guard_tower': 'guard',
    'bl_scouting_hh': 'scouting', 'bl_portal': 'raid',
    'bl_shield_generator': 'shield', 'bl_research_center': 'research',
    'bl_mint_yard': 'resource',   # PBtype=4 RESOURCE (подтверждено из дампа 5x1_1)
}

# Пакеты ресурсов за донат (UA_BUY_RESOURCES_PACK)
# Формат: {pack_kind: {resource: amount, ..., 'cost_resource': 'mithril', 'cost_amount': N}}
RESOURCES_PACK = {
    'so_rp_gold_1':    {'gold': 500000,   'cost_resource': 'mithril', 'cost_amount': 30},
    'so_rp_gold_2':    {'gold': 1500000,  'cost_resource': 'mithril', 'cost_amount': 80},
    'so_rp_gold_3':    {'gold': 5000000,  'cost_resource': 'mithril', 'cost_amount': 200},
    'so_rp_crystal_1': {'crystal': 25000, 'cost_resource': 'mithril', 'cost_amount': 30},
    'so_rp_crystal_2': {'crystal': 75000, 'cost_resource': 'mithril', 'cost_amount': 80},
    'so_rp_crystal_3': {'crystal': 250000,'cost_resource': 'mithril', 'cost_amount': 200},
    'so_rp_oil_1':     {'oil': 5000,      'cost_resource': 'mithril', 'cost_amount': 30},
    'so_rp_oil_2':     {'oil': 15000,     'cost_resource': 'mithril', 'cost_amount': 80},
    'so_rp_oil_3':     {'oil': 50000,     'cost_resource': 'mithril', 'cost_amount': 200},
    'so_rp_all_1':     {'gold': 200000, 'crystal': 10000, 'oil': 2000,
                        'cost_resource': 'mithril', 'cost_amount': 50},
    'so_rp_all_2':     {'gold': 750000, 'crystal': 37500, 'oil': 7500,
                        'cost_resource': 'mithril', 'cost_amount': 150},
    'so_rp_all_3':     {'gold': 2500000, 'crystal': 125000, 'oil': 25000,
                        'cost_resource': 'mithril', 'cost_amount': 400},
}

# Ресурсные события для каждого resource-ключа
_EV_FOR_KEY = {'gold': EV_GOLD, 'crystal': EV_CRYSTAL, 'oil': EV_OIL, 'exp': EV_EXP}


# ── Reader ────────────────────────────────────────────────────────────────────

class Reader:
    def __init__(self, data: bytes, offset: int = 0):
        self._buf = data
        self._pos = offset

    @property
    def pos(self) -> int: return self._pos

    @property
    def remaining(self) -> int: return len(self._buf) - self._pos

    def _read(self, n: int) -> bytes:
        if self._pos + n > len(self._buf):
            raise EOFError(f'нужно {n} байт, есть {self.remaining} (pos=0x{self._pos:X})')
        chunk = self._buf[self._pos:self._pos + n]
        self._pos += n
        return chunk

    def u8(self)    -> int:   return struct.unpack('<B', self._read(1))[0]
    def bool_(self) -> bool:  return self.u8() != 0
    def i16(self)   -> int:   return struct.unpack('<h', self._read(2))[0]
    def u16(self)   -> int:   return struct.unpack('<H', self._read(2))[0]
    def i32(self)   -> int:   return struct.unpack('<i', self._read(4))[0]
    def u32(self)   -> int:   return struct.unpack('<I', self._read(4))[0]
    def f64(self)   -> float: return struct.unpack('<d', self._read(8))[0]
    def utf(self)   -> str:
        n = struct.unpack('<H', self._read(2))[0]
        return self._read(n).decode('utf-8', errors='replace')


# ── Структурные парсеры ───────────────────────────────────────────────────────

def _pos(r)    -> dict: return {'x': r.i16(), 'y': r.i16()}
def _pcost(r)  -> dict:
    v = r.u8()
    if v == 10: return {'variance': v, 'value': None}
    return {'variance': v, 'value': r.u32() if v <= 5 else r.i32()}
def _objid(r)  -> dict:
    v = r.u8()
    return {'variance': v, 'value': None if v == OBJ_GARBAGE + 2 else r.u32()}
def _su(r)     -> dict: return {'su_obj_id': r.u32(), 'su_cost': _pcost(r)}
def _board(r)  -> dict: return {'bo_type': r.u8(), 'bo_kind': r.utf(), 'bo_pos': _pos(r)}
def _move(r)   -> dict: return {'move_id': _objid(r), 'move_pos': _pos(r)}
def _unit(r)   -> dict: return {'mu_kind': r.utf(), 'mu_count': r.u32()}
def _study(r)  -> dict: return {'ss_building_id': r.u32(), 'ss_unit_kind': r.utf()}
def _kc(r)     -> dict: return {'kind': r.utf(), 'count': r.u32()}
def _guard(r)  -> dict:
    bid = r.u32()
    return {'gc_building_id': bid, 'gc_units': [_kc(r) for _ in range(r.u16())]}
def _charge(r) -> dict:
    return {'cg_building_id': r.u32(), 'cg_is_charge': r.bool_(), 'cg_count': r.u8()}
def _eqt(r)    -> dict: return {'eqt_quest_name': r.utf(), 'eqt_target_num': r.u8()}
def _uhero(r)  -> dict: return {'uh_hero_kind': r.utf(), 'uh_upgrade_kind': r.u8()}

def _cmd_kind(r):
    v = r.u8()
    if v == CMD_UNIT:
        kind = r.utf(); p = _pos(r); cnt = r.u16()
        vec = _pos(r) if r.u8() == 1 else None
        value = {'pucm_kind': kind, 'pucm_pos': p, 'pucm_count': cnt, 'pucm_vector': vec}
    elif v == CMD_SPELL:  value = {'pscm_kind': r.utf(), 'pscm_pos': _pos(r)}
    elif v == CMD_FINISH: value = {'pfcm_percentage': r.u32(),
                                    'pfcm_prize': [_pcost(r) for _ in range(r.u16())]}
    elif v == CMD_MESSAGE: value = r.utf()
    elif v == CMD_BUY_POW: value = r.i32()
    else: value = None
    return {'variance': v, 'value': value}

def _pcommand(r):
    return {'cm_kind': _cmd_kind(r), 'cm_time': r.u32(), 'cm_user_id': r.utf()}


def parse_action(r: Reader) -> dict:
    v = r.u8()
    name = ACTION_NAMES.get(v, f'UNKNOWN_{v}')
    try:
        if v == UA_BUY_OBJECT:                value = _board(r)
        elif v in (UA_SPEED_UP_BUILDING, UA_SPEED_UP_CANNON,
                   UA_SPEED_UP_STUDY, UA_SPEED_UP_GARBAGE, UA_SPEED_UP_HERO):
                                               value = _su(r)
        elif v == UA_UPGRADE:                  value = _objid(r)
        elif v == UA_MOVE:                     value = _move(r)
        elif v in (UA_MAKE_UNIT, UA_REMOVE_UNIT): value = _unit(r)
        elif v == UA_COLLECT_RESOURCE:         value = r.u32()
        elif v == UA_START_STUDY:              value = _study(r)
        elif v in (UA_REMOVE_GARBAGE, UA_CANCEL_BUILDING, UA_CANCEL_CANNON,
                   UA_CANCEL_STUDY, UA_CANCEL_REMOVE_GARBAGE): value = r.u32()
        elif v == UA_FIGHT_ADD_COMMAND:        value = _pcommand(r)
        elif v == UA_SET_GUARD_CONFIG:         value = _guard(r)
        elif v == UA_CHARGE_GUARD:             value = _charge(r)
        elif v == UA_DELETE_OBJECT:            value = _objid(r)
        elif v in (UA_USER_COMPLETE_QUEST, UA_READ_STORY, UA_BUY_SHIELD,
                   UA_BUY_RESOURCES_PACK, UA_SPEED_UP_RAID, UA_READ_NEWS):
                                               value = r.utf()
        elif v == UA_EXECUTE_QUEST_TARGET:     value = _eqt(r)
        elif v == UA_BUY_RESOURCE_BY_GOLD:     value = _pcost(r)
        elif v == UA_READ_FIGHT_HIST:          value = None
        elif v == UA_UPGRADE_HERO:             value = _uhero(r)
        elif v in (UA_BUY_CALLS, UA_SELL_DECOR, UA_COLLECT_CLAN_CALLS,
                   UA_ENABLE_SHIELD_GEN, UA_BUY_UNITS_PACK): value = r.u32()
        elif v == UA_CLAN_CALL_REQUEST:        value = None
        elif v in (UA_SET_SPELLS, UA_REMOVE_SHOP_UNWATCHED):
                                               value = [r.utf() for _ in range(r.u16())]
        elif v == UA_CONVERT_ORE:              value = _pcost(r)
        elif v == UA_SET_CUSTOM_DATA:          value = {'field_0': r.utf(), 'field_1': r.utf()}
        else:                                  value = None
    except EOFError as e:
        print(f'    [!] EOFError при парсинге {name}: {e}')
        value = None
    return {'variance': v, 'name': name, 'value': value}


# ── PUserEvent helpers ────────────────────────────────────────────────────────

def ev(variant: int, amount: int) -> bytes:
    """PUserEvent: u8 variant + i32 amount."""
    return struct.pack('<Bi', variant, int(amount))

def ev_for_costs(costs: dict, sign: int = -1) -> list:
    """Генерирует список событий по словарю стоимости. sign=-1 для трат, +1 для начислений."""
    events = []
    for res, amount in costs.items():
        ev_type = _EV_FOR_KEY.get(res)
        if ev_type is not None:
            events.append(ev(ev_type, sign * amount))
    return events


# ── Поиск объектов в базе ─────────────────────────────────────────────────────

def _find(lst: list, obj_id: int) -> dict | None:
    for item in lst:
        if item.get('id') == obj_id:
            return item
    return None

def _remove(lst: list, obj_id: int) -> bool:
    for i, item in enumerate(lst):
        if item.get('id') == obj_id:
            del lst[i]; return True
    return False

def _next_id(base: dict, max_id_ref: list | None = None) -> int:
    """
    Следующий свободный ID.

    object_id_counter ТОЛЬКО РАСТЁТ — никогда не пересчитывается назад.
    Это критично: если объект удалён (CANCEL/DELETE), его ID уже занят навсегда.
    Flash кеширует (id → тип объекта) и не ожидает что один id может
    сменить тип — это вызывает "bad bind".

    При первом запуске базы: берём max(counter, реальный_макс) чтобы
    восстановиться после ручного редактирования JSON.
    """
    stored = int(base.get('object_id_counter', 47))

    # Используем кешированный max_id если передан (оптимизация из _build_base_index)
    if max_id_ref is not None:
        max_id_ref[0] += 1
        new_id = max_id_ref[0]
        base['object_id_counter'] = new_id
        return new_id

    # Первый вызов без индекса — пересчитываем один раз для восстановления
    real_max = stored
    for cat in ('buildings', 'cannons', 'fences', 'decors', 'garbages'):
        for obj in base.get(cat, []):
            if obj.get('id', 0) > real_max:
                real_max = obj['id']

    # ВАЖНО: берём max(stored, real_max) — счётчик никогда не уменьшается
    new_id = max(stored, real_max) + 1
    base['object_id_counter'] = new_id
    return new_id

def _find_obj(base: dict, obj_var: int, obj_id: int) -> dict | None:
    cats = {OBJ_BUILDING: 'buildings', OBJ_CANNON: 'cannons',
            OBJ_FENCE: 'fences', OBJ_DECOR: 'decors', OBJ_GARBAGE: 'garbages'}
    cat = cats.get(obj_var)
    return _find(base.get(cat, []), obj_id) if cat else None

def _is_occupied(base: dict, x: int, y: int, exclude_id: int | None = None) -> dict | None:
    """
    Проверяет, занята ли клетка (x, y).
    Возвращает первый найденный объект на этой позиции, или None если свободно.
    exclude_id — id объекта, который перемещается (не считать его самого занятием).
    """
    for cat in ('buildings', 'cannons', 'fences', 'decors', 'garbages'):
        for obj in base.get(cat, []):
            if obj.get('x') == x and obj.get('y') == y:
                if exclude_id is not None and obj.get('id') == exclude_id:
                    continue
                return obj
    return None


# ── Основная логика обработки действий ───────────────────────────────────────

def process_action(action: dict, player: dict, base: dict) -> list:
    """
    Обрабатывает одно действие. Изменяет player и base на месте.
    Возвращает список байтовых PUserEvent.
    """
    v     = action['variance']
    value = action['value']
    events = []

    # ── BUY_OBJECT (0) ───────────────────────────────────────────────────────
    if v == UA_BUY_OBJECT:
        kind    = value['bo_kind']
        pos     = value['bo_pos']
        bo_type = int(value['bo_type'])
        new_id  = _next_id(base)

        # Получаем реальную стоимость из конфига (level=1 для новой покупки)
        cost_cfg = _state.get_build_cost(kind, target_level=1)

        if cost_cfg and not _state.can_afford(player, cost_cfg['costs']):
            print(f'      → BUY_OBJECT {kind}: недостаточно ресурсов '
                  f'(нужно: {cost_cfg["costs"]}), действие отклонено')
            return []

        # Проверяем, свободна ли целевая клетка
        occupant = _is_occupied(base, pos['x'], pos['y'])
        if occupant is not None:
            print(f'      → BUY_OBJECT {kind}: клетка ({pos["x"]},{pos["y"]}) занята '
                  f'объектом id={occupant.get("id")} kind={occupant.get("kind")}, '
                  f'действие отклонено')
            return []

        # Защита от дублирования (Flash переотправляет пакеты при задержке ответа):
        # если объект того же вида уже есть на этой позиции — это повтор, игнорируем
        all_cat = []
        for cat in ('buildings','cannons','fences','decors'):
            all_cat.extend(base.get(cat, []))
        if any(o.get('kind') == kind and o.get('x') == pos['x'] and o.get('y') == pos['y']
               for o in all_cat):
            print(f'      → BUY_OBJECT {kind}: дубликат запроса (уже есть такой объект '
                  f'на ({pos["x"]},{pos["y"]})), игнорируем')
            return []

        # Вычитаем ресурсы
        if cost_cfg and cost_cfg['costs']:
            deltas = _state.deduct_costs(player, cost_cfg['costs'])
            events.extend(ev_for_costs(cost_cfg['costs'], sign=-1))
            print(f'      → BUY_OBJECT {kind}: вычтено {cost_cfg["costs"]}')

        # Время строительства
        build_time = cost_cfg['time_sec'] if cost_cfg else 0
        now        = time.time()
        if build_time > 0:
            state_val  = 'in_progress'
            finish_t   = now + build_time
        else:
            state_val  = 'finished'
            finish_t   = None

        spec_type = BUILDING_SPEC_TYPES.get(kind, 'townhall')

        if bo_type == 0:   # BUILDING
            obj = {'id': new_id, 'kind': kind, 'level': 1,
                   'x': pos['x'], 'y': pos['y'],
                   'state': state_val, 'finish_time': finish_t,
                   'spec': {'type': spec_type}}
            if spec_type == 'resource':
                obj['spec']['last_apply_time'] = now
                obj['spec']['done_count']      = 0
            base.setdefault('buildings', []).append(obj)

        elif bo_type == 1: # CANNON
            obj = {'id': new_id, 'kind': kind, 'level': 1,
                   'x': pos['x'], 'y': pos['y'],
                   'state': state_val, 'finish_time': finish_t}
            base.setdefault('cannons', []).append(obj)

        elif bo_type == 2: # FENCE
            obj = {'id': new_id, 'kind': kind, 'level': 1,
                   'x': pos['x'], 'y': pos['y']}
            base.setdefault('fences', []).append(obj)

        elif bo_type == 3: # DECOR
            obj = {'id': new_id, 'kind': kind, 'x': pos['x'], 'y': pos['y']}
            base.setdefault('decors', []).append(obj)

        # Начисляем exp: floor(sqrt(build_time)) — формула клиента (calcExp)
        import math as _math
        exp_gain = int(_math.floor(_math.sqrt(build_time))) if build_time > 0 else 1
        player['exp'] = int(player.get('exp', 0)) + exp_gain
        events.append(ev(EV_EXP, exp_gain))

        t_str = f' ({build_time}s +{exp_gain}exp)' if build_time else f' (мгновенно +{exp_gain}exp)'
        print(f'      → BUY_OBJECT {OBJTYPES.get(bo_type,"?")} id={new_id} '
              f'kind={kind} pos=({pos["x"]},{pos["y"]}){t_str}')
        # Если здание мгновенное — сразу разблокируем юнитов.
        if build_time == 0 and bo_type == 0:
            _state.apply_barrack_unlocks(player, kind, 1)

    # ── UPGRADE (3) ──────────────────────────────────────────────────────────
    elif v == UA_UPGRADE:
        obj_var = int(value['variance'])
        obj_id  = value.get('value')
        if obj_id is None:
            return []
        obj_id = int(obj_id)
        target = _find_obj(base, obj_var, obj_id)

        if target is None:
            print(f'      → UPGRADE {OBJTYPES.get(obj_var,"?")} id={obj_id}: не найден')
            return []

        # Защита от двойного апгрейда: если уже строится — отклоняем
        if target.get('state') == 'in_progress':
            print(f'      → UPGRADE {target.get("kind")} id={obj_id}: '
                  f'уже строится (in_progress), отклонено')
            return []

        old_lv     = int(target['level'])
        target_lv  = old_lv + 1
        cost_cfg   = _state.get_build_cost(target['kind'], target_lv)

        if cost_cfg and not _state.can_afford(player, cost_cfg['costs']):
            print(f'      → UPGRADE {target["kind"]} lv{old_lv}→{target_lv}: '
                  f'недостаточно ресурсов ({cost_cfg["costs"]}), отклонено')
            return []

        # Вычитаем ресурсы
        if cost_cfg and cost_cfg['costs']:
            _state.deduct_costs(player, cost_cfg['costs'])
            events.extend(ev_for_costs(cost_cfg['costs'], sign=-1))

        build_time = cost_cfg['time_sec'] if cost_cfg else 0
        target['level'] = target_lv

        # Начисляем exp: floor(sqrt(build_time)) — формула клиента (calcExp)
        import math as _math
        exp_gain = int(_math.floor(_math.sqrt(build_time))) if build_time > 0 else 1
        player['exp'] = int(player.get('exp', 0)) + exp_gain
        events.append(ev(EV_EXP, exp_gain))

        if build_time > 0:
            target['state']       = 'in_progress'
            target['finish_time'] = time.time() + build_time
        else:
            target['state']       = 'finished'
            target['finish_time'] = None
            _state.apply_barrack_unlocks(player, target['kind'], target_lv)

        t_str = f' ({build_time}s +{exp_gain}exp)' if build_time else f' (мгновенно +{exp_gain}exp)'
        print(f'      → UPGRADE {target["kind"]} id={obj_id} '
              f'lv{old_lv}→{target_lv}{t_str} costs={cost_cfg["costs"] if cost_cfg else {}}')

    # ── COLLECT_RESOURCE (6) ─────────────────────────────────────────────────
    elif v == UA_COLLECT_RESOURCE:
        building_id = int(value)
        bld = _find(base.get('buildings', []), building_id)
        if bld:
            kind     = bld.get('kind', '')
            res_type = _state.BUILDING_RESOURCE_TYPE.get(kind, PCOST_OIL)
            spec     = bld.setdefault('spec', {})
            spec['last_apply_time'] = time.time()
            spec['done_count']      = 0
            RES = {PCOST_GOLD: 'gold', PCOST_CRYSTAL: 'crystal', PCOST_OIL: 'oil'}
            EV  = {PCOST_GOLD: EV_GOLD, PCOST_CRYSTAL: EV_CRYSTAL, PCOST_OIL: EV_OIL}
            amount = 500  # клиент считает реальное накопление сам
            key = RES.get(res_type, 'oil')
            player[key] = min(int(player.get(key, 0)) + amount, 999_999_999)
            events.append(ev(EV.get(res_type, EV_OIL), amount))
            print(f'      → COLLECT_RESOURCE id={building_id} kind={kind} +{amount} {key}')
        else:
            print(f'      → COLLECT_RESOURCE id={building_id}: здание не найдено')

    # ── MOVE (4) ─────────────────────────────────────────────────────────────
    elif v == UA_MOVE:
        obj_id  = value['move_id'].get('value')
        obj_var = int(value['move_id']['variance'])
        new_pos = value['move_pos']
        if obj_id is not None:
            target = _find_obj(base, obj_var, int(obj_id))
            if target:
                occupant = _is_occupied(base, new_pos['x'], new_pos['y'], exclude_id=int(obj_id))
                if occupant is not None:
                    # Клиент уже сделал перемещение локально — отклонять нельзя,
                    # иначе при следующем reload получим bad bind (две вещи на одной клетке).
                    # Делаем SWAP: объект который был на целевой клетке занимает
                    # исходную позицию перемещаемого объекта.
                    old_x, old_y = target['x'], target['y']
                    occupant['x'], occupant['y'] = old_x, old_y
                    target['x'], target['y'] = new_pos['x'], new_pos['y']
                    print(f'      → MOVE {OBJTYPES.get(obj_var,"?")} id={obj_id} → ({new_pos["x"]},{new_pos["y"]}) '
                          f'SWAP с id={occupant.get("id")} kind={occupant.get("kind")} → ({old_x},{old_y})')
                else:
                    target['x'], target['y'] = new_pos['x'], new_pos['y']
                    print(f'      → MOVE {OBJTYPES.get(obj_var,"?")} id={obj_id} → ({new_pos["x"]},{new_pos["y"]})')
            else:
                print(f'      → MOVE {OBJTYPES.get(obj_var,"?")} id={obj_id}: объект не найден')

    # ── DELETE_OBJECT (14) ───────────────────────────────────────────────────
    elif v == UA_DELETE_OBJECT:
        obj_var = int(value['variance'])
        obj_id  = value.get('value')
        if obj_id is not None:
            cats = {OBJ_BUILDING:'buildings', OBJ_CANNON:'cannons',
                    OBJ_FENCE:'fences', OBJ_DECOR:'decors'}
            cat = cats.get(obj_var)
            ok = _remove(base.get(cat, []), int(obj_id)) if cat else False
            print(f'      → DELETE {OBJTYPES.get(obj_var,"?")} id={obj_id} {"OK" if ok else "не найден"}')

    # ── REMOVE_GARBAGE (9) ───────────────────────────────────────────────────
    elif v == UA_REMOVE_GARBAGE:
        gid = int(value)
        g = _find(base.get('garbages', []), gid)
        if g:
            g['removing']     = True
            g['start_remove'] = time.time()
            player['exp'] = int(player.get('exp', 0)) + 10
            events.append(ev(EV_EXP, 10))
            print(f'      → REMOVE_GARBAGE id={gid} kind={g.get("kind")} (начата уборка)')

    elif v == UA_CANCEL_REMOVE_GARBAGE:
        gid = int(value)
        g = _find(base.get('garbages', []), gid)
        if g:
            g['removing'] = False; g['start_remove'] = None

    # ── SPEED_UP_* (1,2,8,10,21) ─────────────────────────────────────────────
    elif v in (UA_SPEED_UP_BUILDING, UA_SPEED_UP_CANNON,
               UA_SPEED_UP_STUDY,    UA_SPEED_UP_GARBAGE, UA_SPEED_UP_HERO):
        su       = value
        cost_var = int(su['su_cost']['variance'])
        cost_val = int(su['su_cost'].get('value') or 0)
        RMAP = {PCOST_GOLD:'gold', PCOST_CRYSTAL:'crystal', PCOST_OIL:'oil',
                PCOST_MITHRIL:'mithril'}
        EMAP = {PCOST_GOLD:EV_GOLD, PCOST_CRYSTAL:EV_CRYSTAL, PCOST_OIL:EV_OIL}
        rkey = RMAP.get(cost_var)
        if rkey and cost_val > 0:
            player[rkey] = max(0, int(player.get(rkey, 0)) - cost_val)
            if cost_var in EMAP:
                events.append(ev(EMAP[cost_var], -cost_val))

        obj_id = int(su['su_obj_id'])

        if v == UA_SPEED_UP_BUILDING:
            target = _find(base.get('buildings', []), obj_id)
            if target:
                if target.get('state') != 'in_progress':
                    print(f'      → SPEED_UP_BUILDING id={obj_id}: не строится, пропускаем')
                else:
                    target['state'] = 'finished'; target['finish_time'] = None
                    _state.apply_barrack_unlocks(player, target.get('kind', ''), int(target.get('level', 1)))

        elif v == UA_SPEED_UP_CANNON:
            target = _find(base.get('cannons', []), obj_id)
            if target:
                if target.get('state') == 'in_progress':
                    target['state'] = 'finished'; target['finish_time'] = None

        elif v == UA_SPEED_UP_STUDY:
            # Мгновенно завершаем исследование в академии
            bld = _find(base.get('buildings', []), obj_id)
            if bld:
                spec      = bld.get('spec', {})
                unit_kind = spec.get('unit_kind')
                if unit_kind:
                    cur_level    = int(player.get('unit_levels', {}).get(unit_kind, 0))
                    target_level = cur_level + 1
                    player.setdefault('unit_levels', {})[unit_kind] = target_level
                    print(f'      → SPEED_UP_STUDY: {unit_kind} lv{cur_level}→{target_level} '
                          f'(мгновенно)')
                    spec.pop('unit_kind',  None)
                    spec.pop('start_time', None)
                    spec.pop('up_time',    None)
                else:
                    print(f'      → SPEED_UP_STUDY id={obj_id}: академия пуста')
            else:
                print(f'      → SPEED_UP_STUDY id={obj_id}: здание не найдено')

        elif v == UA_SPEED_UP_GARBAGE:
            _remove(base.get('garbages', []), obj_id)

        print(f'      → {ACTION_NAMES[v]} obj={obj_id} -{cost_val} {rkey or "?"}')

    # ── CANCEL_BUILDING (23) / CANCEL_CANNON (24) ────────────────────────────
    elif v == UA_CANCEL_BUILDING:
        bld = _find(base.get('buildings', []), int(value))
        if bld:
            if bld['level'] > 1: bld['level'] -= 1
            bld['state'] = 'finished'; bld['finish_time'] = None
            print(f'      → CANCEL_BUILDING id={value}')

    elif v == UA_CANCEL_CANNON:
        cn = _find(base.get('cannons', []), int(value))
        if cn:
            if cn['level'] > 1: cn['level'] -= 1
            cn['state'] = 'finished'; cn['finish_time'] = None
            print(f'      → CANCEL_CANNON id={value}')

    # ── MAKE_UNIT (5) / REMOVE_UNIT (28) ────────────────────────────────────
    elif v == UA_MAKE_UNIT:
        kind = value['mu_kind']; count = int(value['mu_count'])
        troops = player.setdefault('troops', {})
        troops[kind] = int(troops.get(kind, 0)) + count
        print(f'      → MAKE_UNIT kind={kind} x{count}')

    elif v == UA_REMOVE_UNIT:
        kind = value['mu_kind']; count = int(value['mu_count'])
        troops = player.setdefault('troops', {})
        troops[kind] = max(0, int(troops.get(kind, 0)) - count)
        print(f'      → REMOVE_UNIT kind={kind} x{count}')

    # ── START_STUDY (7) ──────────────────────────────────────────────────────
    elif v == UA_START_STUDY:
        building_id = int(value['ss_building_id'])
        unit_kind   = value['ss_unit_kind']

        bld = _find(base.get('buildings', []), building_id)
        if bld is None:
            print(f'      → START_STUDY: здание {building_id} не найдено')
            return []

        # Академия должна быть свободна
        spec = bld.setdefault('spec', {})
        if spec.get('unit_kind'):
            print(f'      → START_STUDY: академия {building_id} занята '
                  f'({spec["unit_kind"]}), игнорируем')
            return []

        # Текущий уровень юнита и целевой
        cur_level    = int(player.get('unit_levels', {}).get(unit_kind, 0))
        target_level = cur_level + 1

        # Получаем конфиг прокачки
        research_cfg = _state.get_research_cost(unit_kind, target_level)
        if research_cfg is None:
            print(f'      → START_STUDY {unit_kind}: нет конфига, разрешаем бесплатно')
            up_price = {}
            up_time  = 60
        else:
            up_price = research_cfg.get('up_price', {})
            up_time  = research_cfg.get('up_time', 60)

        # Проверяем баланс
        if up_price and not _state.can_afford(player, up_price):
            print(f'      → START_STUDY {unit_kind} lv{cur_level}→{target_level}: '
                  f'недостаточно ресурсов (нужно {up_price}), отклонено')
            return []

        # Вычитаем стоимость
        if up_price:
            _state.deduct_costs(player, up_price)
            events.extend(ev_for_costs(up_price, sign=-1))

        # Запускаем исследование
        now = time.time()
        spec['unit_kind']   = unit_kind
        spec['start_time']  = now
        spec['up_time']     = up_time      # храним для быстрого SPEED_UP

        h, m = up_time // 3600, (up_time % 3600) // 60
        print(f'      → START_STUDY building={building_id} unit={unit_kind} '
              f'lv{cur_level}→{target_level} время={h}h{m:02}m стоимость={up_price}')

    elif v == UA_CANCEL_STUDY:
        building_id = int(value)
        bld = _find(base.get('buildings', []), building_id)
        if bld:
            spec      = bld.get('spec', {})
            unit_kind = spec.get('unit_kind')
            if unit_kind:
                # Возврат 50% стоимости при отмене (как в оригинале)
                cur_level    = int(player.get('unit_levels', {}).get(unit_kind, 0))
                target_level = cur_level + 1
                research_cfg = _state.get_research_cost(unit_kind, target_level)
                if research_cfg:
                    up_price = research_cfg.get('up_price', {})
                    if up_price:
                        refund = {k: v // 2 for k, v in up_price.items()}
                        _state.deduct_costs.__doc__  # просто чтоб не упасть
                        for res, amount in refund.items():
                            key = _state.RESOURCE_KEYS.get(res, res)
                            player[key] = int(player.get(key, 0)) + amount
                        events.extend(ev_for_costs(refund, sign=+1))
                        print(f'      → CANCEL_STUDY {unit_kind}: возврат 50% = {refund}')
            spec.pop('unit_kind',  None)
            spec.pop('start_time', None)
            spec.pop('up_time',    None)
        print(f'      → CANCEL_STUDY id={building_id}')

    # ── SET_GUARD_CONFIG (12) / CHARGE_GUARD (13) ────────────────────────────
    elif v == UA_SET_GUARD_CONFIG:
        bld = _find(base.get('buildings', []), int(value['gc_building_id']))
        if bld and bld.get('spec', {}).get('type') == 'guard':
            bld['spec']['config'] = [{'kind': u['kind'], 'count': u['count']}
                                      for u in value['gc_units']]
        print(f'      → SET_GUARD_CONFIG id={value["gc_building_id"]}')

    elif v == UA_CHARGE_GUARD:
        bld = _find(base.get('buildings', []), int(value['cg_building_id']))
        if bld and bld.get('spec', {}).get('type') == 'guard':
            bld['spec']['count'] = int(value['cg_count'])
        print(f'      → CHARGE_GUARD id={value["cg_building_id"]}')

    # ── BUY_SHIELD (19) ──────────────────────────────────────────────────────
    elif v == UA_BUY_SHIELD:
        SHIELD_COSTS = {'so_shield_1h': {'crystal': 500}, 'so_shield_8h': {'crystal': 1500},
                        'so_shield_24h': {'crystal': 3000}, 'so_shield_72h': {'crystal': 7000}}
        costs = SHIELD_COSTS.get(value, {'crystal': 2000})
        if _state.can_afford(player, costs):
            _state.deduct_costs(player, costs)
            events.extend(ev_for_costs(costs, sign=-1))
            for bld in base.get('buildings', []):
                if bld.get('spec', {}).get('type') == 'shield':
                    bld['spec']['shield_time'] = time.time() + 86400; break
        print(f'      → BUY_SHIELD kind={value} costs={costs}')

    # ── BUY_RESOURCES_PACK (20) ──────────────────────────────────────────────
    # Два типа паков:
    # 1. so_rp_* — покупаются за mithril (донат-паки)
    # 2. rs_oil1/2/3, rs_crystal1/2/3 — бесплатные паки ресурсов (% от макс. объёма)
    elif v == UA_BUY_RESOURCES_PACK:
        pack_kind = value

        # ── Паки ресурсов по % от максимального объёма хранилища ─────────────
        if pack_kind.startswith(('rs_oil', 'rs_crystal')):
            oil_max, crystal_max = _state.calc_max_storage(base)

            RS_PACKS = {
                # Нефть
                'rs_oil1': {'oil':     int(oil_max * 0.10)},
                'rs_oil2': {'oil':     int(oil_max * 0.50)},
                'rs_oil3': {'oil':     int(oil_max * 1.00)},
                # Кристаллы
                'rs_crystal1': {'crystal': int(crystal_max * 0.10)},
                'rs_crystal2': {'crystal': int(crystal_max * 0.50)},
                'rs_crystal3': {'crystal': int(crystal_max * 1.00)},
            }

            pack = RS_PACKS.get(pack_kind)
            if pack is None:
                print(f'      → BUY_RESOURCES_PACK rs kind={pack_kind}: неизвестный пак')
            else:
                gained = {}
                for res, amount in pack.items():
                    if amount <= 0:
                        continue
                    cap = oil_max if res == 'oil' else crystal_max
                    cur = int(player.get(res, 0))
                    add = min(amount, cap - cur)   # не превышаем максимум
                    if add > 0:
                        player[res] = cur + add
                        gained[res] = add
                        ev_type = _EV_FOR_KEY.get(res)
                        if ev_type is not None:
                            events.append(ev(ev_type, add))
                print(f'      → BUY_RESOURCES_PACK {pack_kind} (бесплатный) '
                      f'+{gained} | oil_max={oil_max:,} crystal_max={crystal_max:,}')

        # ── Донат-паки за mithril (so_rp_*) ──────────────────────────────────
        else:
            pack = RESOURCES_PACK.get(pack_kind)
            if pack is None:
                print(f'      → BUY_RESOURCES_PACK kind={pack_kind}: неизвестный пак')
            else:
                cost_res    = pack['cost_resource']
                cost_amount = pack['cost_amount']
                if int(player.get(cost_res, 0)) < cost_amount:
                    print(f'      → BUY_RESOURCES_PACK kind={pack_kind}: '
                          f'нет {cost_res} ({cost_amount} нужно), отклонено')
                else:
                    player[cost_res] = int(player[cost_res]) - cost_amount
                    gained = {}
                    for res, amount in pack.items():
                        if res in ('cost_resource', 'cost_amount'):
                            continue
                        player[res] = min(int(player.get(res, 0)) + amount, 999_999_999)
                        gained[res] = amount
                        ev_type = _EV_FOR_KEY.get(res)
                        if ev_type is not None:
                            events.append(ev(ev_type, amount))
                    print(f'      → BUY_RESOURCES_PACK kind={pack_kind} '
                          f'-{cost_amount} {cost_res} +{gained}')

    # ── BUY_RESOURCE_BY_GOLD (17) ────────────────────────────────────────────
    elif v == UA_BUY_RESOURCE_BY_GOLD:
        cost_var = int(value['variance'])
        cost_val = int(value.get('value') or 0)
        RMAP = {PCOST_CRYSTAL: 'crystal', PCOST_OIL: 'oil'}
        EMAP = {PCOST_CRYSTAL: EV_CRYSTAL, PCOST_OIL: EV_OIL}
        rkey = RMAP.get(cost_var)
        if rkey and int(player.get('gold', 0)) >= cost_val:
            gained = cost_val * 10
            player[rkey]   = min(int(player.get(rkey, 0)) + gained, 999_999_999)
            player['gold'] = max(0, int(player.get('gold', 0)) - cost_val)
            events.append(ev(EMAP.get(cost_var, EV_OIL), gained))
            events.append(ev(EV_GOLD, -cost_val))
            print(f'      → BUY_RESOURCE_BY_GOLD +{gained} {rkey} -{cost_val} gold')

    # ── SELL_DECOR (31) ──────────────────────────────────────────────────────
    elif v == UA_SELL_DECOR:
        ok = _remove(base.get('decors', []), int(value))
        print(f'      → SELL_DECOR id={value} {"OK" if ok else "не найден"}')

    # ── USER_COMPLETE_QUEST (15) ──────────────────────────────────────────────
    elif v == UA_USER_COMPLETE_QUEST:
        player['exp'] = int(player.get('exp', 0)) + 50
        events.append(ev(EV_EXP, 50))
        print(f'      → USER_COMPLETE_QUEST quest={value}')

    # ── FIGHT_ADD_COMMAND (11) ────────────────────────────────────────────────
    elif v == UA_FIGHT_ADD_COMMAND:
        cmd   = value
        kv    = cmd['cm_kind']['variance']
        if kv == CMD_UNIT:
            uc    = cmd['cm_kind']['value']
            kind  = uc['pucm_kind']
            count = int(uc.get('pucm_count', 1))
            # Записываем высадку в _battle_deployed — реальное списание погибших
            # происходит в p20_9 по итогам боя (только погибшие, выжившие возвращаются).
            deployed = player.setdefault('_battle_deployed', {})
            deployed[kind] = deployed.get(kind, 0) + count
            # Временно вычитаем из troops чтобы не высадить больше чем есть
            troops = player.setdefault('troops', {})
            had    = int(troops.get(kind, 0))
            troops[kind] = max(0, had - count)
            print(f'      → FIGHT_CMD UNIT kind={kind} '
                  f'pos=({uc["pucm_pos"]["x"]},{uc["pucm_pos"]["y"]}) '
                  f'x{count} (высажено всего: {deployed[kind]})')
        elif kv == CMD_SPELL:
            sc = cmd['cm_kind']['value']
            print(f'      → FIGHT_CMD SPELL kind={sc["pscm_kind"]}')

        elif kv == CMD_FINISH:
            fc  = cmd['cm_kind']['value']
            pct = fc.get('pfcm_percentage', 0)

            # pfcm_prize — клиент уже прислал итоговые значения украденного.
            # Он сам посчитал: crystal = ti_crystal * storage_fight_k * % разрушения здания.
            # Нам НЕ надо умножать на pct/100 ещё раз — это было бы двойным умножением.
            RES_KEYS = {0: 'gold', 1: 'crystal', 2: 'oil'}
            EV_KEYS  = {0: EV_GOLD, 1: EV_CRYSTAL, 2: EV_OIL}

            print(f'      → FIGHT_CMD FINISH {pct}%')
            for prize in fc.get('pfcm_prize', []):
                pv  = prize.get('variance')
                val = prize.get('value')
                if pv in RES_KEYS and val is not None:
                    amount = int(val)   # берём как есть — без умножения
                    if amount > 0:
                        key = RES_KEYS[pv]
                        player[key] = min(int(player.get(key, 0)) + amount, 999_999_999)
                        if pv in EV_KEYS:
                            events.append(ev(EV_KEYS[pv], amount))
                        print(f'         +{amount} {key}')
            # НЕ стираем player['troops'] — они уже вычтены в CMD_UNIT при высадке

    # ── SET_CUSTOM_DATA (40) ─────────────────────────────────────────────────
    elif v == UA_SET_CUSTOM_DATA:
        player.setdefault('custom', {})[value['field_0']] = value['field_1']
        print(f'      → SET_CUSTOM_DATA {value["field_0"]}={value["field_1"]}')

    # ── Остальные — просто логируем ───────────────────────────────────────────
    else:
        print(f'      → {ACTION_NAMES.get(v, f"ACTION_{v}")} (без изменений)')

    return events


# ── Ответный пакет 10x2 ───────────────────────────────────────────────────────

def build_response(events: list) -> bytes:
    payload = (
        struct.pack('<B', 0) +
        struct.pack('<H', len(events)) +
        b''.join(events) +
        struct.pack('<d', time.time())
    )
    return struct.pack('<HBBI', 16, 2, PROTOCOL_VERSION, len(payload)) + payload


# ── Точка входа ───────────────────────────────────────────────────────────────

def handle(body: bytes) -> bytes:
    print(f'  [10x1] пакет {len(body)} байт')
    r = Reader(body, offset=8)

    if r.remaining < 2:
        return build_response([])

    action_count = r.u16()
    print(f'  [10x1] {action_count} действий')

    # ── КРИТИЧЕСКИ ВАЖНО: весь цикл load → modify → save под одним локом ─────
    # ThreadingTCPServer даёт каждому запросу отдельный поток.
    # Без acquire_state_lock два одновременных запроса (MOVE + MOVE, BUY + MOVE)
    # оба читают старый base_state.json, каждый вносит своё изменение,
    # и ОДИН перезаписывает изменения ДРУГОГО → объекты наслаиваются.
    all_events = []
    with _state.acquire_state_lock():
        player = _state.load_player()
        # Передаём player в load_base — он сам завершит in_progress и исследования
        base   = _state.load_base(player)

        for i in range(action_count):
            if r.remaining < 1:
                break
            try:
                ua_time = r.f64()
                action  = parse_action(r)
                print(f'    [{i}] t={ua_time:.1f} {action["name"]}')
                all_events.extend(process_action(action, player, base))
            except Exception as e:
                import traceback
                print(f'    [{i}] ОШИБКА: {e}')
                traceback.print_exc()
                break

        _state.save_player(player)
        _state.save_base(base)

    print(f'  [10x1] gold={player["gold"]:,} crystal={player["crystal"]:,} '
          f'oil={player["oil"]:,} mithril={player["mithril"]:,} | '
          f'зданий={len(base.get("buildings",[]))} пушек={len(base.get("cannons",[]))} | '
          f'событий={len(all_events)}')

    return build_response(all_events)