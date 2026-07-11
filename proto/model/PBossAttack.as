package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PBossAttack implements IClientPacket
   {
      
      public var ba_fight_time:uint;
      
      public var ba_fight_commands:Array;
      
      public var ba_um:PUm;
      
      public var ba_fight_id:String;
      
      public var ba_time_now:Number;
      
      public var ba_units_levels:Array;
      
      public var ba_ruby:int;
      
      public var ba_th_diff_k:Number;
      
      public var ba_storage_fight_k:Number;
      
      public function PBossAttack()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Array, param3:PUm, param4:String, param5:Number, param6:Array, param7:int, param8:Number, param9:Number) : PBossAttack
      {
         var _loc10_:PBossAttack = new PBossAttack();
         _loc10_.ba_fight_time = param1;
         _loc10_.ba_fight_commands = param2;
         _loc10_.ba_um = param3;
         _loc10_.ba_fight_id = param4;
         _loc10_.ba_time_now = param5;
         _loc10_.ba_units_levels = param6;
         _loc10_.ba_ruby = param7;
         _loc10_.ba_th_diff_k = param8;
         _loc10_.ba_storage_fight_k = param9;
         return _loc10_;
      }
      
      public static function read(param1:IDataInput) : PBossAttack
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PBossAttack = new PBossAttack();
         _loc2_.ba_fight_time = param1.readUnsignedInt();
         _loc2_.ba_fight_commands = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ba_fight_commands.length)
         {
            _loc2_.ba_fight_commands[_loc3_] = _loc4_ = PCommand.read(param1);
            _loc3_++;
         }
         _loc2_.ba_um = PUm.read(param1);
         _loc2_.ba_fight_id = param1.readUTF();
         _loc2_.ba_time_now = param1.readDouble();
         _loc2_.ba_units_levels = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ba_units_levels.length)
         {
            _loc2_.ba_units_levels[_loc3_] = _loc4_ = PUnitsLevel.read(param1);
            _loc3_++;
         }
         _loc2_.ba_ruby = param1.readInt();
         _loc2_.ba_th_diff_k = param1.readDouble();
         _loc2_.ba_storage_fight_k = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.ba_fight_time);
         if(this.ba_fight_commands == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ba_fight_commands.length);
            _loc2_ = 0;
            while(_loc2_ < this.ba_fight_commands.length)
            {
               this.ba_fight_commands[_loc2_].write(param1);
               _loc2_++;
            }
         }
         this.ba_um.write(param1);
         param1.writeUTF(this.ba_fight_id);
         param1.writeDouble(this.ba_time_now);
         if(this.ba_units_levels == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ba_units_levels.length);
            _loc2_ = 0;
            while(_loc2_ < this.ba_units_levels.length)
            {
               this.ba_units_levels[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.ba_ruby);
         param1.writeDouble(this.ba_th_diff_k);
         param1.writeDouble(this.ba_storage_fight_k);
      }
   }
}

