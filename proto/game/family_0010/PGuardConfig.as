package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PKindCount;
   
   public class PGuardConfig implements IClientPacket
   {
      
      public var gc_building_id:uint;
      
      public var gc_units:Array;
      
      public function PGuardConfig()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Array) : PGuardConfig
      {
         var _loc3_:PGuardConfig = new PGuardConfig();
         _loc3_.gc_building_id = param1;
         _loc3_.gc_units = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PGuardConfig
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PGuardConfig = new PGuardConfig();
         _loc2_.gc_building_id = param1.readUnsignedInt();
         _loc2_.gc_units = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.gc_units.length)
         {
            _loc2_.gc_units[_loc3_] = _loc4_ = PKindCount.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.gc_building_id);
         if(this.gc_units == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.gc_units.length);
            _loc2_ = 0;
            while(_loc2_ < this.gc_units.length)
            {
               this.gc_units[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

