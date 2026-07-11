package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopCamp implements IClientPacket
   {
      
      public var sca_level:uint;
      
      public var sca_capacity:uint;
      
      public function PShopCamp()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint) : PShopCamp
      {
         var _loc3_:PShopCamp = new PShopCamp();
         _loc3_.sca_level = param1;
         _loc3_.sca_capacity = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PShopCamp
      {
         var _loc2_:PShopCamp = new PShopCamp();
         _loc2_.sca_level = param1.readUnsignedByte();
         _loc2_.sca_capacity = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.sca_level);
         param1.writeInt(this.sca_capacity);
      }
   }
}

