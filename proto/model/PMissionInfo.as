package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_Position;
   
   public class PMissionInfo implements IClientPacket
   {
      
      public var mi_kind:String;
      
      public var mi_is_lock:Boolean;
      
      public var mi_min_level:uint;
      
      public var mi_max_level:uint;
      
      public var mi_hglory:uint;
      
      public var mi_members_count:uint;
      
      public var mi_win:Array;
      
      public var mi_win_prize:PTargetInfoWinPrize;
      
      public var mi_resources:Array;
      
      public var mi_raid_quest:String;
      
      public var mi_average_hspace:int;
      
      public var mi_cooldown:Number;
      
      public var mi_tunits:Array;
      
      public var mi_jglory:int;
      
      public var mi_init_obj_cnt:int;
      
      public var mi_rar_dragon:int;
      
      public var mi_mithril:int;
      
      public function PMissionInfo()
      {
         super();
      }
      
      public static function create(param1:String, param2:Boolean, param3:uint, param4:uint, param5:uint, param6:uint, param7:Array, param8:PTargetInfoWinPrize, param9:Array, param10:String, param11:int, param12:Number, param13:Array, param14:int, param15:int, param16:int, param17:int) : PMissionInfo
      {
         var _loc18_:PMissionInfo = new PMissionInfo();
         _loc18_.mi_kind = param1;
         _loc18_.mi_is_lock = param2;
         _loc18_.mi_min_level = param3;
         _loc18_.mi_max_level = param4;
         _loc18_.mi_hglory = param5;
         _loc18_.mi_members_count = param6;
         _loc18_.mi_win = param7;
         _loc18_.mi_win_prize = param8;
         _loc18_.mi_resources = param9;
         _loc18_.mi_raid_quest = param10;
         _loc18_.mi_average_hspace = param11;
         _loc18_.mi_cooldown = param12;
         _loc18_.mi_tunits = param13;
         _loc18_.mi_jglory = param14;
         _loc18_.mi_init_obj_cnt = param15;
         _loc18_.mi_rar_dragon = param16;
         _loc18_.mi_mithril = param17;
         return _loc18_;
      }
      
      public static function read(param1:IDataInput) : PMissionInfo
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PMissionInfo = new PMissionInfo();
         _loc2_.mi_kind = param1.readUTF();
         _loc2_.mi_is_lock = param1.readBoolean();
         _loc2_.mi_min_level = param1.readUnsignedInt();
         _loc2_.mi_max_level = param1.readUnsignedInt();
         _loc2_.mi_hglory = param1.readUnsignedInt();
         _loc2_.mi_members_count = param1.readUnsignedByte();
         _loc2_.mi_win = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.mi_win.length)
         {
            _loc2_.mi_win[_loc3_] = _loc4_ = PMissionWin.read(param1);
            _loc3_++;
         }
         _loc2_.mi_win_prize = PTargetInfoWinPrize.read(param1);
         _loc2_.mi_resources = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.mi_resources.length)
         {
            _loc2_.mi_resources[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.mi_raid_quest = param1.readUTF();
         }
         else
         {
            _loc2_.mi_raid_quest = null;
         }
         _loc2_.mi_average_hspace = param1.readInt();
         _loc2_.mi_cooldown = param1.readDouble();
         _loc2_.mi_tunits = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.mi_tunits.length)
         {
            _loc2_.mi_tunits[_loc3_] = _loc4_ = str_Position.read(param1);
            _loc3_++;
         }
         _loc2_.mi_jglory = param1.readInt();
         _loc2_.mi_init_obj_cnt = param1.readInt();
         _loc2_.mi_rar_dragon = param1.readInt();
         _loc2_.mi_mithril = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.mi_kind);
         param1.writeBoolean(this.mi_is_lock);
         param1.writeInt(this.mi_min_level);
         param1.writeInt(this.mi_max_level);
         param1.writeInt(this.mi_hglory);
         param1.writeByte(this.mi_members_count);
         if(this.mi_win == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.mi_win.length);
            _loc2_ = 0;
            while(_loc2_ < this.mi_win.length)
            {
               this.mi_win[_loc2_].write(param1);
               _loc2_++;
            }
         }
         this.mi_win_prize.write(param1);
         if(this.mi_resources == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.mi_resources.length);
            _loc2_ = 0;
            while(_loc2_ < this.mi_resources.length)
            {
               this.mi_resources[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.mi_raid_quest != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.mi_raid_quest);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.mi_average_hspace);
         param1.writeDouble(this.mi_cooldown);
         if(this.mi_tunits == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.mi_tunits.length);
            _loc2_ = 0;
            while(_loc2_ < this.mi_tunits.length)
            {
               this.mi_tunits[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.mi_jglory);
         param1.writeInt(this.mi_init_obj_cnt);
         param1.writeInt(this.mi_rar_dragon);
         param1.writeInt(this.mi_mithril);
      }
   }
}

