package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopClanhall implements IClientPacket
   {
      
      public var scl_level:uint;
      
      public var scl_capacity:uint;
      
      public function PShopClanhall()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint) : PShopClanhall
      {
         var _loc3_:PShopClanhall = new PShopClanhall();
         _loc3_.scl_level = param1;
         _loc3_.scl_capacity = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PShopClanhall
      {
         var _loc2_:PShopClanhall = new PShopClanhall();
         _loc2_.scl_level = param1.readUnsignedInt();
         _loc2_.scl_capacity = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.scl_level);
         param1.writeInt(this.scl_capacity);
      }
   }
}

