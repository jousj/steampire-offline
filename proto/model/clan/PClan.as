package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PClanRequest;
   import proto.model.PTerritoryLevel;
   import proto.model.PUnitsLevel;
   
   public class PClan implements IClientPacket
   {
      
      public var base:PBase;
      
      public var members:Array;
      
      public var requests:Array;
      
      public var storage_max_crystal:uint;
      
      public var storage_max_oil:uint;
      
      public var capital_log:Array;
      
      public var townhall_level:uint;
      
      public var clanhall_level:uint;
      
      public var top_place:uint;
      
      public var units_levels:Array;
      
      public var war:PWar;
      
      public var trophy:int;
      
      public var trophy_lat:Number;
      
      public var active_territories:Boolean;
      
      public var premium_icons:Array;
      
      public var last_war_end_time:Number;
      
      public var division_top_place:int;
      
      public var workers_count:int;
      
      public var workers_busy:int;
      
      public var finish_build_time:Number;
      
      public var territories_count:int;
      
      public var clan_comp_place_opt:Number;
      
      public var territories:Array;
      
      public var wins:Array;
      
      public function PClan()
      {
         super();
      }
      
      public static function create(param1:PBase, param2:Array, param3:Array, param4:uint, param5:uint, param6:Array, param7:uint, param8:uint, param9:uint, param10:Array, param11:PWar, param12:int, param13:Number, param14:Boolean, param15:Array, param16:Number, param17:int, param18:int, param19:int, param20:Number, param21:int, param22:Number, param23:Array, param24:Array) : PClan
      {
         var _loc25_:PClan = new PClan();
         _loc25_.base = param1;
         _loc25_.members = param2;
         _loc25_.requests = param3;
         _loc25_.storage_max_crystal = param4;
         _loc25_.storage_max_oil = param5;
         _loc25_.capital_log = param6;
         _loc25_.townhall_level = param7;
         _loc25_.clanhall_level = param8;
         _loc25_.top_place = param9;
         _loc25_.units_levels = param10;
         _loc25_.war = param11;
         _loc25_.trophy = param12;
         _loc25_.trophy_lat = param13;
         _loc25_.active_territories = param14;
         _loc25_.premium_icons = param15;
         _loc25_.last_war_end_time = param16;
         _loc25_.division_top_place = param17;
         _loc25_.workers_count = param18;
         _loc25_.workers_busy = param19;
         _loc25_.finish_build_time = param20;
         _loc25_.territories_count = param21;
         _loc25_.clan_comp_place_opt = param22;
         _loc25_.territories = param23;
         _loc25_.wins = param24;
         return _loc25_;
      }
      
      public static function read(param1:IDataInput) : PClan
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PClan = new PClan();
         _loc2_.base = PBase.read(param1);
         _loc2_.members = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.members.length)
         {
            _loc2_.members[_loc3_] = _loc4_ = PMember.read(param1);
            _loc3_++;
         }
         _loc2_.requests = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.requests.length)
         {
            _loc2_.requests[_loc3_] = _loc4_ = PClanRequest.read(param1);
            _loc3_++;
         }
         _loc2_.storage_max_crystal = param1.readUnsignedInt();
         _loc2_.storage_max_oil = param1.readUnsignedInt();
         _loc2_.capital_log = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.capital_log.length)
         {
            _loc2_.capital_log[_loc3_] = _loc4_ = PCapitalLog.read(param1);
            _loc3_++;
         }
         _loc2_.townhall_level = param1.readUnsignedInt();
         _loc2_.clanhall_level = param1.readUnsignedInt();
         _loc2_.top_place = param1.readUnsignedInt();
         _loc2_.units_levels = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.units_levels.length)
         {
            _loc2_.units_levels[_loc3_] = _loc4_ = PUnitsLevel.read(param1);
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.war = PWar.read(param1);
         }
         else
         {
            _loc2_.war = null;
         }
         _loc2_.trophy = param1.readInt();
         _loc2_.trophy_lat = param1.readDouble();
         _loc2_.active_territories = param1.readBoolean();
         _loc2_.premium_icons = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.premium_icons.length)
         {
            _loc2_.premium_icons[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.last_war_end_time = param1.readDouble();
         }
         else
         {
            _loc2_.last_war_end_time = NaN;
         }
         _loc2_.division_top_place = param1.readInt();
         _loc2_.workers_count = param1.readInt();
         _loc2_.workers_busy = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.finish_build_time = param1.readDouble();
         }
         else
         {
            _loc2_.finish_build_time = NaN;
         }
         _loc2_.territories_count = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.clan_comp_place_opt = param1.readInt();
         }
         else
         {
            _loc2_.clan_comp_place_opt = NaN;
         }
         _loc2_.territories = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.territories.length)
         {
            _loc2_.territories[_loc3_] = _loc4_ = PTerritoryLevel.read(param1);
            _loc3_++;
         }
         _loc2_.wins = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.wins.length)
         {
            _loc2_.wins[_loc3_] = _loc4_ = param1.readInt();
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         this.base.write(param1);
         if(this.members == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.members.length);
            _loc2_ = 0;
            while(_loc2_ < this.members.length)
            {
               this.members[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.requests == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.requests.length);
            _loc2_ = 0;
            while(_loc2_ < this.requests.length)
            {
               this.requests[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.storage_max_crystal);
         param1.writeInt(this.storage_max_oil);
         if(this.capital_log == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.capital_log.length);
            _loc2_ = 0;
            while(_loc2_ < this.capital_log.length)
            {
               this.capital_log[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.townhall_level);
         param1.writeInt(this.clanhall_level);
         param1.writeInt(this.top_place);
         if(this.units_levels == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.units_levels.length);
            _loc2_ = 0;
            while(_loc2_ < this.units_levels.length)
            {
               this.units_levels[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.war != null)
         {
            param1.writeByte(1);
            this.war.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.trophy);
         param1.writeDouble(this.trophy_lat);
         param1.writeBoolean(this.active_territories);
         if(this.premium_icons == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.premium_icons.length);
            _loc2_ = 0;
            while(_loc2_ < this.premium_icons.length)
            {
               param1.writeUTF(this.premium_icons[_loc2_]);
               _loc2_++;
            }
         }
         if(!isNaN(this.last_war_end_time))
         {
            param1.writeByte(1);
            param1.writeDouble(this.last_war_end_time);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.division_top_place);
         param1.writeInt(this.workers_count);
         param1.writeInt(this.workers_busy);
         if(!isNaN(this.finish_build_time))
         {
            param1.writeByte(1);
            param1.writeDouble(this.finish_build_time);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.territories_count);
         if(!isNaN(this.clan_comp_place_opt))
         {
            param1.writeByte(1);
            param1.writeInt(this.clan_comp_place_opt);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.territories == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.territories.length);
            _loc2_ = 0;
            while(_loc2_ < this.territories.length)
            {
               this.territories[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.wins == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.wins.length);
            _loc2_ = 0;
            while(_loc2_ < this.wins.length)
            {
               param1.writeInt(this.wins[_loc2_]);
               _loc2_++;
            }
         }
      }
   }
}

