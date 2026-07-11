package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopPowerPoint implements IClientPacket
   {
      
      public var power_count:int;
      
      public var power_price:PCost;
      
      public function PShopPowerPoint()
      {
         super();
      }
      
      public static function create(param1:int, param2:PCost) : PShopPowerPoint
      {
         var _loc3_:PShopPowerPoint = new PShopPowerPoint();
         _loc3_.power_count = param1;
         _loc3_.power_price = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PShopPowerPoint
      {
         var _loc2_:PShopPowerPoint = new PShopPowerPoint();
         _loc2_.power_count = param1.readInt();
         _loc2_.power_price = PCost.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.power_count);
         this.power_price.write(param1);
      }
   }
}

