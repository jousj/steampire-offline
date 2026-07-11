import struct
import time

PROTOCOL_VERSION = 77

def handle(data):
    offset = 0
    # Парсим входящий пакет (как у тебя)
    var_from = data[offset]
    offset += 1
    val_from = None
    if var_from == 0:
        val_from = struct.unpack_from('>d', data, offset)[0]
        offset += 8
    elif var_from == 1:
        val_from = struct.unpack_from('>i', data, offset)[0]
        offset += 4
        
    var_place = data[offset]
    offset += 1
    val_place = None
    if var_place in [3, 4]:
        str_len = struct.unpack_from('>H', data, offset)[0]
        offset += 2
        val_place = data[offset:offset + str_len].decode('utf-8')
        offset += str_len
        
    print(f"[!] Пакет 80x1: From(var={var_from}, val={val_from}), Place(var={var_place}, val={val_place})")
    
    # -------- ФОРМИРУЕМ ОТВЕТ ----------
    
    # PRaidEvents: re_ev_id (4 байта int) + массив событий
    re_ev_id = struct.pack('<i', 0)           # 0 = нет новых событий
    re_evs_count = struct.pack('<H', 0)       # пустой массив
    
    # server_time (8 байт double)
    server_time = struct.pack('<d', time.time())
    
    # Собираем данные для POkUserAction (как в 10x1)
    events_data = re_ev_id + re_evs_count
    ok_data = events_data + server_time
    
    # variance = 0 (OK)
    variance = struct.pack('<B', 0)
    
    # Полные данные пакета
    payload = variance + ok_data
    
    # Заголовок: family=80, subfamily=2, version, length
    header = struct.pack('<HBBI', 80, 2, PROTOCOL_VERSION, len(payload))
    
    return header + payload