package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_i;
   
   public class POreSpellCompensation implements IClientPacket
   {
      
      public var red_ore:int;
      
      public var green_ore:int;
      
      public var blue_ore:int;
      
      public var spells:Array;
      
      public var gold:int;
      
      public function POreSpellCompensation()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:int, param4:Array, param5:int) : POreSpellCompensation
      {
         var _loc6_:POreSpellCompensation = new POreSpellCompensation();
         _loc6_.red_ore = param1;
         _loc6_.green_ore = param2;
         _loc6_.blue_ore = param3;
         _loc6_.spells = param4;
         _loc6_.gold = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : POreSpellCompensation
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:POreSpellCompensation = new POreSpellCompensation();
         _loc2_.red_ore = param1.readInt();
         _loc2_.green_ore = param1.readInt();
         _loc2_.blue_ore = param1.readInt();
         _loc2_.spells = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.spells.length)
         {
            _loc2_.spells[_loc3_] = _loc4_ = str_i.read(param1);
            _loc3_++;
         }
         _loc2_.gold = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.red_ore);
         param1.writeInt(this.green_ore);
         param1.writeInt(this.blue_ore);
         if(this.spells == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.spells.length);
            _loc2_ = 0;
            while(_loc2_ < this.spells.length)
            {
               this.spells[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.gold);
      }
   }
}

