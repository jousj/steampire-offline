package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_i;
   
   public class PClanTownhallUnlock implements IClientPacket
   {
      
      public var ctu_level:uint;
      
      public var ctu_unlocks:Array;
      
      public var ctu_donate_min_gold:int;
      
      public var ctu_donate_min_oil:int;
      
      public var ctu_donate_min_crystal:int;
      
      public var ctu_donate_cooldown:Number;
      
      public var ctu_ratio_per_hspace:Number;
      
      public var ctu_ratio_per_worker:int;
      
      public var ctu_donate_min_mithril:int;
      
      public var ctu_capital_resources:Array;
      
      public function PClanTownhallUnlock()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Array, param3:int, param4:int, param5:int, param6:Number, param7:Number, param8:int, param9:int, param10:Array) : PClanTownhallUnlock
      {
         var _loc11_:PClanTownhallUnlock = new PClanTownhallUnlock();
         _loc11_.ctu_level = param1;
         _loc11_.ctu_unlocks = param2;
         _loc11_.ctu_donate_min_gold = param3;
         _loc11_.ctu_donate_min_oil = param4;
         _loc11_.ctu_donate_min_crystal = param5;
         _loc11_.ctu_donate_cooldown = param6;
         _loc11_.ctu_ratio_per_hspace = param7;
         _loc11_.ctu_ratio_per_worker = param8;
         _loc11_.ctu_donate_min_mithril = param9;
         _loc11_.ctu_capital_resources = param10;
         return _loc11_;
      }
      
      public static function read(param1:IDataInput) : PClanTownhallUnlock
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PClanTownhallUnlock = new PClanTownhallUnlock();
         _loc2_.ctu_level = param1.readUnsignedByte();
         _loc2_.ctu_unlocks = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ctu_unlocks.length)
         {
            _loc2_.ctu_unlocks[_loc3_] = _loc4_ = str_i.read(param1);
            _loc3_++;
         }
         _loc2_.ctu_donate_min_gold = param1.readInt();
         _loc2_.ctu_donate_min_oil = param1.readInt();
         _loc2_.ctu_donate_min_crystal = param1.readInt();
         _loc2_.ctu_donate_cooldown = param1.readDouble();
         _loc2_.ctu_ratio_per_hspace = param1.readDouble();
         _loc2_.ctu_ratio_per_worker = param1.readInt();
         _loc2_.ctu_donate_min_mithril = param1.readInt();
         _loc2_.ctu_capital_resources = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ctu_capital_resources.length)
         {
            _loc2_.ctu_capital_resources[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeByte(this.ctu_level);
         if(this.ctu_unlocks == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ctu_unlocks.length);
            _loc2_ = 0;
            while(_loc2_ < this.ctu_unlocks.length)
            {
               this.ctu_unlocks[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.ctu_donate_min_gold);
         param1.writeInt(this.ctu_donate_min_oil);
         param1.writeInt(this.ctu_donate_min_crystal);
         param1.writeDouble(this.ctu_donate_cooldown);
         param1.writeDouble(this.ctu_ratio_per_hspace);
         param1.writeInt(this.ctu_ratio_per_worker);
         param1.writeInt(this.ctu_donate_min_mithril);
         if(this.ctu_capital_resources == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ctu_capital_resources.length);
            _loc2_ = 0;
            while(_loc2_ < this.ctu_capital_resources.length)
            {
               this.ctu_capital_resources[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

