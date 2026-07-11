package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.clan.PBase;
   import proto.tuples.i_i;
   
   public class PStorm implements IClientPacket
   {
      
      public var storm_um:PUm;
      
      public var storm_oil:int;
      
      public var storm_crystal:int;
      
      public var storm_attacker:PAttackerInfo;
      
      public var storm_fight_time:uint;
      
      public var storm_server_time:Number;
      
      public var storm_commands:Array;
      
      public var storm_tclan_base:PBase;
      
      public var storm_obj_stamina:Array;
      
      public var storm_members:Array;
      
      public var storm_has_free_worker:Boolean;
      
      public var storm_my_oil:int;
      
      public var storm_my_crystal:int;
      
      public var storm_my_gold:int;
      
      public var storm_my_hspace:int;
      
      public var storm_my_full_hspace:int;
      
      public var storm_my_capacity_oil:uint;
      
      public var storm_my_capacity_crystal:uint;
      
      public var storm_territory:PStormTerritory;
      
      public var storm_tunits_levels:Array;
      
      public var storm_end_time:Number;
      
      public var storm_fight_id:String;
      
      public var storm_my_calls:int;
      
      public function PStorm()
      {
         super();
      }
      
      public static function create(param1:PUm, param2:int, param3:int, param4:PAttackerInfo, param5:uint, param6:Number, param7:Array, param8:PBase, param9:Array, param10:Array, param11:Boolean, param12:int, param13:int, param14:int, param15:int, param16:int, param17:uint, param18:uint, param19:PStormTerritory, param20:Array, param21:Number, param22:String, param23:int) : PStorm
      {
         var _loc24_:PStorm = new PStorm();
         _loc24_.storm_um = param1;
         _loc24_.storm_oil = param2;
         _loc24_.storm_crystal = param3;
         _loc24_.storm_attacker = param4;
         _loc24_.storm_fight_time = param5;
         _loc24_.storm_server_time = param6;
         _loc24_.storm_commands = param7;
         _loc24_.storm_tclan_base = param8;
         _loc24_.storm_obj_stamina = param9;
         _loc24_.storm_members = param10;
         _loc24_.storm_has_free_worker = param11;
         _loc24_.storm_my_oil = param12;
         _loc24_.storm_my_crystal = param13;
         _loc24_.storm_my_gold = param14;
         _loc24_.storm_my_hspace = param15;
         _loc24_.storm_my_full_hspace = param16;
         _loc24_.storm_my_capacity_oil = param17;
         _loc24_.storm_my_capacity_crystal = param18;
         _loc24_.storm_territory = param19;
         _loc24_.storm_tunits_levels = param20;
         _loc24_.storm_end_time = param21;
         _loc24_.storm_fight_id = param22;
         _loc24_.storm_my_calls = param23;
         return _loc24_;
      }
      
      public static function read(param1:IDataInput) : PStorm
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PStorm = new PStorm();
         _loc2_.storm_um = PUm.read(param1);
         _loc2_.storm_oil = param1.readInt();
         _loc2_.storm_crystal = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.storm_attacker = PAttackerInfo.read(param1);
         }
         else
         {
            _loc2_.storm_attacker = null;
         }
         _loc2_.storm_fight_time = param1.readUnsignedInt();
         _loc2_.storm_server_time = param1.readDouble();
         _loc2_.storm_commands = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.storm_commands.length)
         {
            _loc2_.storm_commands[_loc3_] = _loc4_ = PCommand.read(param1);
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.storm_tclan_base = PBase.read(param1);
         }
         else
         {
            _loc2_.storm_tclan_base = null;
         }
         _loc2_.storm_obj_stamina = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.storm_obj_stamina.length)
         {
            _loc2_.storm_obj_stamina[_loc3_] = _loc4_ = i_i.read(param1);
            _loc3_++;
         }
         _loc2_.storm_members = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.storm_members.length)
         {
            _loc2_.storm_members[_loc3_] = _loc4_ = PUserBase.read(param1);
            _loc3_++;
         }
         _loc2_.storm_has_free_worker = param1.readBoolean();
         _loc2_.storm_my_oil = param1.readInt();
         _loc2_.storm_my_crystal = param1.readInt();
         _loc2_.storm_my_gold = param1.readInt();
         _loc2_.storm_my_hspace = param1.readInt();
         _loc2_.storm_my_full_hspace = param1.readInt();
         _loc2_.storm_my_capacity_oil = param1.readUnsignedInt();
         _loc2_.storm_my_capacity_crystal = param1.readUnsignedInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.storm_territory = PStormTerritory.read(param1);
         }
         else
         {
            _loc2_.storm_territory = null;
         }
         _loc2_.storm_tunits_levels = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.storm_tunits_levels.length)
         {
            _loc2_.storm_tunits_levels[_loc3_] = _loc4_ = PUnitsLevel.read(param1);
            _loc3_++;
         }
         _loc2_.storm_end_time = param1.readDouble();
         _loc2_.storm_fight_id = param1.readUTF();
         _loc2_.storm_my_calls = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         this.storm_um.write(param1);
         param1.writeInt(this.storm_oil);
         param1.writeInt(this.storm_crystal);
         if(this.storm_attacker != null)
         {
            param1.writeByte(1);
            this.storm_attacker.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.storm_fight_time);
         param1.writeDouble(this.storm_server_time);
         if(this.storm_commands == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.storm_commands.length);
            _loc2_ = 0;
            while(_loc2_ < this.storm_commands.length)
            {
               this.storm_commands[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.storm_tclan_base != null)
         {
            param1.writeByte(1);
            this.storm_tclan_base.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.storm_obj_stamina == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.storm_obj_stamina.length);
            _loc2_ = 0;
            while(_loc2_ < this.storm_obj_stamina.length)
            {
               this.storm_obj_stamina[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.storm_members == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.storm_members.length);
            _loc2_ = 0;
            while(_loc2_ < this.storm_members.length)
            {
               this.storm_members[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeBoolean(this.storm_has_free_worker);
         param1.writeInt(this.storm_my_oil);
         param1.writeInt(this.storm_my_crystal);
         param1.writeInt(this.storm_my_gold);
         param1.writeInt(this.storm_my_hspace);
         param1.writeInt(this.storm_my_full_hspace);
         param1.writeInt(this.storm_my_capacity_oil);
         param1.writeInt(this.storm_my_capacity_crystal);
         if(this.storm_territory != null)
         {
            param1.writeByte(1);
            this.storm_territory.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.storm_tunits_levels == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.storm_tunits_levels.length);
            _loc2_ = 0;
            while(_loc2_ < this.storm_tunits_levels.length)
            {
               this.storm_tunits_levels[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeDouble(this.storm_end_time);
         param1.writeUTF(this.storm_fight_id);
         param1.writeInt(this.storm_my_calls);
      }
   }
}

