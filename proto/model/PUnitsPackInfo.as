package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_i;
   
   public class PUnitsPackInfo implements IClientPacket
   {
      
      public var up_num:int;
      
      public var up_units:Array;
      
      public var up_price:PCost;
      
      public function PUnitsPackInfo()
      {
         super();
      }
      
      public static function create(param1:int, param2:Array, param3:PCost) : PUnitsPackInfo
      {
         var _loc4_:PUnitsPackInfo = new PUnitsPackInfo();
         _loc4_.up_num = param1;
         _loc4_.up_units = param2;
         _loc4_.up_price = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PUnitsPackInfo
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PUnitsPackInfo = new PUnitsPackInfo();
         _loc2_.up_num = param1.readInt();
         _loc2_.up_units = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.up_units.length)
         {
            _loc2_.up_units[_loc3_] = _loc4_ = str_i.read(param1);
            _loc3_++;
         }
         _loc2_.up_price = PCost.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.up_num);
         if(this.up_units == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.up_units.length);
            _loc2_ = 0;
            while(_loc2_ < this.up_units.length)
            {
               this.up_units[_loc2_].write(param1);
               _loc2_++;
            }
         }
         this.up_price.write(param1);
      }
   }
}

