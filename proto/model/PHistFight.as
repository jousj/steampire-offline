package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PHistFight implements IClientPacket
   {
      
      public var phf_id:String;
      
      public var phf_time:Number;
      
      public var phf_name:String;
      
      public var phf_level:int;
      
      public var phf_ratio:int;
      
      public var phf_steal_res:Array;
      
      public var phf_change_ratio:int;
      
      public var phf_is_win:Boolean;
      
      public var phf_percentage:int;
      
      public var phf_units_in_fight:Array;
      
      public var phf_unit_died:Array;
      
      public var phf_revenge:Boolean;
      
      public var phf_has_replay:Boolean;
      
      public var phf_units_levels:Array;
      
      public var phf_read:Boolean;
      
      public var phf_clan:PPhfClan;
      
      public var phf_spells:Array;
      
      public var phf_uid:String;
      
      public var phf_snetwork:String;
      
      public var phf_scouting:Boolean;
      
      public var phf_avatar:String;
      
      public function PHistFight()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number, param3:String, param4:int, param5:int, param6:Array, param7:int, param8:Boolean, param9:int, param10:Array, param11:Array, param12:Boolean, param13:Boolean, param14:Array, param15:Boolean, param16:PPhfClan, param17:Array, param18:String, param19:String, param20:Boolean, param21:String) : PHistFight
      {
         var _loc22_:PHistFight = new PHistFight();
         _loc22_.phf_id = param1;
         _loc22_.phf_time = param2;
         _loc22_.phf_name = param3;
         _loc22_.phf_level = param4;
         _loc22_.phf_ratio = param5;
         _loc22_.phf_steal_res = param6;
         _loc22_.phf_change_ratio = param7;
         _loc22_.phf_is_win = param8;
         _loc22_.phf_percentage = param9;
         _loc22_.phf_units_in_fight = param10;
         _loc22_.phf_unit_died = param11;
         _loc22_.phf_revenge = param12;
         _loc22_.phf_has_replay = param13;
         _loc22_.phf_units_levels = param14;
         _loc22_.phf_read = param15;
         _loc22_.phf_clan = param16;
         _loc22_.phf_spells = param17;
         _loc22_.phf_uid = param18;
         _loc22_.phf_snetwork = param19;
         _loc22_.phf_scouting = param20;
         _loc22_.phf_avatar = param21;
         return _loc22_;
      }
      
      public static function read(param1:IDataInput) : PHistFight
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PHistFight = new PHistFight();
         _loc2_.phf_id = param1.readUTF();
         _loc2_.phf_time = param1.readDouble();
         _loc2_.phf_name = param1.readUTF();
         _loc2_.phf_level = param1.readInt();
         _loc2_.phf_ratio = param1.readInt();
         _loc2_.phf_steal_res = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.phf_steal_res.length)
         {
            _loc2_.phf_steal_res[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.phf_change_ratio = param1.readInt();
         _loc2_.phf_is_win = param1.readBoolean();
         _loc2_.phf_percentage = param1.readInt();
         _loc2_.phf_units_in_fight = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.phf_units_in_fight.length)
         {
            _loc2_.phf_units_in_fight[_loc3_] = _loc4_ = PKindCount.read(param1);
            _loc3_++;
         }
         _loc2_.phf_unit_died = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.phf_unit_died.length)
         {
            _loc2_.phf_unit_died[_loc3_] = _loc4_ = PKindCount.read(param1);
            _loc3_++;
         }
         _loc2_.phf_revenge = param1.readBoolean();
         _loc2_.phf_has_replay = param1.readBoolean();
         _loc2_.phf_units_levels = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.phf_units_levels.length)
         {
            _loc2_.phf_units_levels[_loc3_] = _loc4_ = PUnitsLevel.read(param1);
            _loc3_++;
         }
         _loc2_.phf_read = param1.readBoolean();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.phf_clan = PPhfClan.read(param1);
         }
         else
         {
            _loc2_.phf_clan = null;
         }
         _loc2_.phf_spells = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.phf_spells.length)
         {
            _loc2_.phf_spells[_loc3_] = _loc4_ = PKindCount.read(param1);
            _loc3_++;
         }
         _loc2_.phf_uid = param1.readUTF();
         _loc2_.phf_snetwork = param1.readUTF();
         _loc2_.phf_scouting = param1.readBoolean();
         _loc2_.phf_avatar = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.phf_id);
         param1.writeDouble(this.phf_time);
         param1.writeUTF(this.phf_name);
         param1.writeInt(this.phf_level);
         param1.writeInt(this.phf_ratio);
         if(this.phf_steal_res == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.phf_steal_res.length);
            _loc2_ = 0;
            while(_loc2_ < this.phf_steal_res.length)
            {
               this.phf_steal_res[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.phf_change_ratio);
         param1.writeBoolean(this.phf_is_win);
         param1.writeInt(this.phf_percentage);
         if(this.phf_units_in_fight == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.phf_units_in_fight.length);
            _loc2_ = 0;
            while(_loc2_ < this.phf_units_in_fight.length)
            {
               this.phf_units_in_fight[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.phf_unit_died == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.phf_unit_died.length);
            _loc2_ = 0;
            while(_loc2_ < this.phf_unit_died.length)
            {
               this.phf_unit_died[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeBoolean(this.phf_revenge);
         param1.writeBoolean(this.phf_has_replay);
         if(this.phf_units_levels == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.phf_units_levels.length);
            _loc2_ = 0;
            while(_loc2_ < this.phf_units_levels.length)
            {
               this.phf_units_levels[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeBoolean(this.phf_read);
         if(this.phf_clan != null)
         {
            param1.writeByte(1);
            this.phf_clan.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.phf_spells == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.phf_spells.length);
            _loc2_ = 0;
            while(_loc2_ < this.phf_spells.length)
            {
               this.phf_spells[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeUTF(this.phf_uid);
         param1.writeUTF(this.phf_snetwork);
         param1.writeBoolean(this.phf_scouting);
         param1.writeUTF(this.phf_avatar);
      }
   }
}

