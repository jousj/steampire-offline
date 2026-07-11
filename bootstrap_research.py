"""
bootstrap_research.py
Запустить ОДИН РАЗ (или при обновлении дампа).

Разбирает dumps/5x1_1 (PDict) и извлекает полный конфиг прокачки юнитов:
  - su_kind        — тип юнита
  - su_level       — уровень прокачки
  - up_price       — стоимость {oil/crystal/mithril: amount}
  - up_time        — время прокачки в секундах
  - model_level    — визуальный уровень (меняет внешний вид юнита)
  - can_buy        — можно ли купить этот юнит

Сохраняет в unit_research_config.json.
Этот файл читается state.py через get_research_cost().

Структуры точно соответствуют PShopUnit.read() / PShopFence.read() из AS3.
"""

import struct
import json
import os
import sys

BASE_DIR  = os.path.abspath(os.path.dirname(__file__))
DUMP_PATH = os.path.join(BASE_DIR, 'dumps', '5x1_1')
OUT_PATH  = os.path.join(BASE_DIR, 'unit_research_config.json')

COST_NAMES = {
    0: 'gold',   1: 'crystal',  2: 'oil',      3: 'exp',
    4: 'hglory', 5: 'call',     6: 'red_ore',  7: 'green_ore',
    8: 'blue_ore', 9: 'mithril', 10: None,
    11: 'trophy', 12: 'blueprint', 13: 'jglory',
    14: 'rar_dragon', 15: 'clan_points', 16: 'ruby',
}


# ─── Reader ──────────────────────────────────────────────────────────────────

class R:
    def __init__(self, d, p=0):
        self._d = d
        self._p = p

    @property
    def pos(self):
        return self._p

    def _r(self, n):
        if self._p + n > len(self._d):
            raise EOFError(f'Need {n} bytes @ 0x{self._p:X} '
                           f'(have {len(self._d) - self._p})')
        b = self._d[self._p:self._p + n]
        self._p += n
        return b

    def u8(self)    -> int:   return struct.unpack('<B', self._r(1))[0]
    def bool_(self) -> bool:  return self.u8() != 0
    def u16(self)   -> int:   return struct.unpack('<H', self._r(2))[0]
    def i32(self)   -> int:   return struct.unpack('<i', self._r(4))[0]
    def u32(self)   -> int:   return struct.unpack('<I', self._r(4))[0]
    def f64(self)   -> float: return struct.unpack('<d', self._r(8))[0]
    def utf(self)   -> str:
        n = self.u16()
        return self._r(n).decode('utf-8', 'replace')


# ─── Примитивные вспомогательные ─────────────────────────────────────────────

def _pcost(r) -> tuple | None:
    v = r.u8()
    if v == 10:
        return None
    val  = r.u32() if v <= 5 else r.i32()
    name = COST_NAMES.get(v)
    return (name, val) if name else None


# ─── Парсеры секций PDict ─────────────────────────────────────────────────────

def _skip_levels(r):
    """PDict.levels[] — массив уровней игрока (fck.py формат)."""
    for _ in range(r.u16()):
        r.u32(); r.u32()
        for _ in range(r.u16()):
            _pcost(r)
        r.u32()


def _skip_building(r):
    """PShopBuilding.read() — skip."""
    r.utf(); r.u32()           # kind, level
    r.u32(); r.u32()           # armor, stamina
    for _ in range(r.u16()):   # sb_price[]
        _pcost(r)
    r.f64()                    # sb_upgrade_time
    r.u8(); r.u8(); r.bool_()  # th_req, btype, can_buy
    for _ in range(r.u16()):   # sb_price_list[]
        for _ in range(r.u16()): _pcost(r)
    for _ in range(r.u16()):   # sb_requirements[]
        v = r.u8()
        if v == 0: r.utf()
    r.i32()                    # sb_model_level


def _skip_cannon(r):
    """PShopCannon.read() — skip."""
    r.utf(); r.u8()            # kind, level
    r.u8(); r.u8()             # target_type_bits, th_req
    r.u32(); r.u32(); r.u32(); r.u32(); r.u32(); r.u32()
    r.f64(); r.u8(); r.u32(); r.u32()
    for _ in range(r.u16()): _pcost(r)     # price[]
    r.f64()                    # upgrade_time
    r.u8(); r.u8(); r.bool_(); r.bool_()
    for _ in range(r.u16()): r.utf()       # info_icons[]
    for _ in range(r.u16()):               # price_list[]
        for _ in range(r.u16()): _pcost(r)
    for _ in range(r.u16()): r.utf()       # requirements[]
    r.f64(); r.i32(); r.bool_()


def _skip_shopfence(r):
    """PShopFence.read() — skip."""
    r.utf(); r.u8()            # kind, level
    r.u32(); r.u32()           # armor, stamina
    _pcost(r)                  # sf_price
    r.u8()                     # sf_townhall_req
    for _ in range(r.u16()): r.utf()       # sf_info_icons[]
    r.bool_()                  # sf_can_buy
    r.i32()                    # sf_model_level


def _read_shopunit(r) -> dict:
    """
    PShopUnit.read() — точно по AS3.
    PRequirement = utf req_building_kind + u8 req_building_level (одиночная структура, не массив!)
    PCannonTargetType = u8
    PUnitProirityType = u8
    """
    kind  = r.utf()
    level = r.u8()
    r.u8()          # su_radius
    r.u32()         # su_damage
    r.u32()         # su_stamina
    r.u32()         # su_armor
    r.f64()         # su_penetration
    r.bool_()       # su_is_air
    r.bool_()       # su_is_healer
    r.bool_()       # su_is_kamikaze
    r.u32()         # su_move_delay
    r.u8()          # su_priority_type (u8)
    r.f64()         # su_priority_factor
    r.u32()         # su_attack_time
    r.u32()         # su_attack_delay
    r.u32()         # su_bullet_speed
    if r.u8() == 1: # opt su_aoe_radius
        r.i32()
    _pcost(r)       # su_price

    r.u8()          # su_hspace

    # su_upgrade_price[] — стоимость прокачки
    up_price_raw = [_pcost(r) for _ in range(r.u16())]
    up_time = r.f64()   # su_upgrade_time (секунды)

    # PRequirement (одна запись, не массив)
    r.utf(); r.u8()     # req_building_kind, req_building_level

    can_buy  = r.bool_()   # su_can_buy
    r.u8()               # su_target_type (u8)

    for _ in range(r.u16()): r.utf()         # su_info_icons[]
    model_lv = r.u8()    # su_model_level
    r.bool_()            # su_is_hero
    for _ in range(r.u16()): r.u8()          # su_attacked_by[] (u8 each)
    r.bool_()            # su_is_clan
    r.i32()              # su_max_cure_stamina
    r.i32()              # su_eff

    if r.u8() == 1:      # opt su_event_requirement (PBuildRequierement: utf + u32)
        r.utf(); r.u32()

    r.i32()              # su_power_points

    up_price = {p[0]: p[1] for p in up_price_raw if p}
    return {
        'kind':        kind,
        'level':       level,
        'up_price':    up_price,
        'up_time':     int(up_time),
        'model_level': model_lv,
        'can_buy':     can_buy,
    }


# ─── Главная функция ──────────────────────────────────────────────────────────

def main():
    if not os.path.exists(DUMP_PATH):
        print(f'[bootstrap_research] Дамп не найден: {DUMP_PATH}')
        sys.exit(1)

    with open(DUMP_PATH, 'rb') as f:
        data = f.read()

    print(f'[bootstrap_research] Читаю {os.path.basename(DUMP_PATH)} ({len(data):,} байт)...')

    r = R(data, 8)   # skip 8-byte header

    _skip_levels(r)
    print(f'  После levels[]:    {r.pos:,}')

    cnt = r.u16()
    for _ in range(cnt): _skip_building(r)
    print(f'  После buildings[{cnt}]: {r.pos:,}')

    cnt = r.u16()
    for _ in range(cnt): _skip_cannon(r)
    print(f'  После cannons[{cnt}]:  {r.pos:,}')

    cnt = r.u16()
    for _ in range(cnt): _skip_shopfence(r)
    print(f'  После fences[{cnt}]:   {r.pos:,}')

    un_cnt = r.u16()
    print(f'  units_info count:  {un_cnt}')

    unit_config = {}   # {kind: {level_str: {up_price, up_time, model_level, can_buy}}}
    parsed = 0
    errors = 0

    for i in range(un_cnt):
        try:
            u = _read_shopunit(r)
            k  = u['kind']
            lv = str(u['level'])
            unit_config.setdefault(k, {})[lv] = {
                'up_price':    u['up_price'],
                'up_time':     u['up_time'],
                'model_level': u['model_level'],
                'can_buy':     u['can_buy'],
            }
            parsed += 1
        except EOFError as e:
            errors += 1
            if errors <= 3:
                print(f'  [!] EOF при юните {i}: {e}')
            # Клановые юниты в конце могут отличаться структурой — не фатально

    print(f'  Разобрано: {parsed} записей, ошибок: {errors}')
    print(f'  Уникальных видов юнитов: {len(unit_config)}')

    # Сортируем уровни как int
    sorted_config = {}
    for kind in sorted(unit_config):
        sorted_config[kind] = {
            lv: unit_config[kind][lv]
            for lv in sorted(unit_config[kind], key=int)
        }

    # Выводим таблицу прокачки
    print('\n  ┌─ КОНФИГ ИССЛЕДОВАНИЙ (время прокачки) ─────────────')
    research_kinds = [k for k, v in sorted_config.items()
                      if any(d['up_time'] > 0 for d in v.values())]
    for kind in research_kinds:
        levels = sorted_config[kind]
        lv_nums  = [int(l) for l in levels]
        first    = levels[str(min(lv_nums))]
        last     = levels[str(max(lv_nums))]
        t1 = first['up_time']
        tN = last['up_time']
        h1, m1 = t1 // 3600, (t1 % 3600) // 60
        hN, mN = tN // 3600, (tN % 3600) // 60
        price_str = ', '.join(f'{v} {k}' for k, v in first['up_price'].items())
        print(f'    {kind:<30} lv1={h1}h{m1:02}m  lv{max(lv_nums)}={hN}h{mN:02}m  '
              f'start_price=[{price_str}]')
    print('  └─────────────────────────────────────────────────────')

    with open(OUT_PATH, 'w', encoding='utf-8') as f:
        json.dump(sorted_config, f, ensure_ascii=False, indent=2)

    print(f'\n[bootstrap_research] Готово → {OUT_PATH}')
    print(f'  {len(sorted_config)} видов юнитов, '
          f'{len(research_kinds)} с данными исследований')


if __name__ == '__main__':
    main()