package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PAttackerInfo implements IClientPacket
   {
      
      public var ai_units:Array;
      
      public var ai_units_levels:Array;
      
      public var ai_heroes:Array;
      
      public var ai_capacity_oil:uint;
      
      public var ai_capacity_crystal:uint;
      
      public var ai_gold:uint;
      
      public var ai_spells:Array;
      
      public var ai_library_level:int;
      
      public var ai_calls:int;
      
      public var ai_townhall_level:int;
      
      public var ai_ruby:int;
      
      public function PAttackerInfo()
      {
         super();
      }
      
      public static function create(param1:Array, param2:Array, param3:Array, param4:uint, param5:uint, param6:uint, param7:Array, param8:int, param9:int, param10:int, param11:int) : PAttackerInfo
      {
         var _loc12_:PAttackerInfo = new PAttackerInfo();
         _loc12_.ai_units = param1;
         _loc12_.ai_units_levels = param2;
         _loc12_.ai_heroes = param3;
         _loc12_.ai_capacity_oil = param4;
         _loc12_.ai_capacity_crystal = param5;
         _loc12_.ai_gold = param6;
         _loc12_.ai_spells = param7;
         _loc12_.ai_library_level = param8;
         _loc12_.ai_calls = param9;
         _loc12_.ai_townhall_level = param10;
         _loc12_.ai_ruby = param11;
         return _loc12_;
      }
      
      public static function read(param1:IDataInput) : PAttackerInfo
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PAttackerInfo = new PAttackerInfo();
         _loc2_.ai_units = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ai_units.length)
         {
            _loc2_.ai_units[_loc3_] = _loc4_ = PKindCount.read(param1);
            _loc3_++;
         }
         _loc2_.ai_units_levels = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ai_units_levels.length)
         {
            _loc2_.ai_units_levels[_loc3_] = _loc4_ = PUnitsLevel.read(param1);
            _loc3_++;
         }
         _loc2_.ai_heroes = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ai_heroes.length)
         {
            _loc2_.ai_heroes[_loc3_] = _loc4_ = PHero.read(param1);
            _loc3_++;
         }
         _loc2_.ai_capacity_oil = param1.readUnsignedInt();
         _loc2_.ai_capacity_crystal = param1.readUnsignedInt();
         _loc2_.ai_gold = param1.readUnsignedInt();
         _loc2_.ai_spells = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ai_spells.length)
         {
            _loc2_.ai_spells[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.ai_library_level = param1.readInt();
         _loc2_.ai_calls = param1.readInt();
         _loc2_.ai_townhall_level = param1.readInt();
         _loc2_.ai_ruby = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(this.ai_units == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ai_units.length);
            _loc2_ = 0;
            while(_loc2_ < this.ai_units.length)
            {
               this.ai_units[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.ai_units_levels == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ai_units_levels.length);
            _loc2_ = 0;
            while(_loc2_ < this.ai_units_levels.length)
            {
               this.ai_units_levels[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.ai_heroes == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ai_heroes.length);
            _loc2_ = 0;
            while(_loc2_ < this.ai_heroes.length)
            {
               this.ai_heroes[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.ai_capacity_oil);
         param1.writeInt(this.ai_capacity_crystal);
         param1.writeInt(this.ai_gold);
         if(this.ai_spells == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ai_spells.length);
            _loc2_ = 0;
            while(_loc2_ < this.ai_spells.length)
            {
               param1.writeUTF(this.ai_spells[_loc2_]);
               _loc2_++;
            }
         }
         param1.writeInt(this.ai_library_level);
         param1.writeInt(this.ai_calls);
         param1.writeInt(this.ai_townhall_level);
         param1.writeInt(this.ai_ruby);
      }
   }
}

