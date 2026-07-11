package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopLibrary implements IClientPacket
   {
      
      public var sl_level:uint;
      
      public var sl_start_power:uint;
      
      public var sl_book_size:uint;
      
      public function PShopLibrary()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint) : PShopLibrary
      {
         var _loc4_:PShopLibrary = new PShopLibrary();
         _loc4_.sl_level = param1;
         _loc4_.sl_start_power = param2;
         _loc4_.sl_book_size = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PShopLibrary
      {
         var _loc2_:PShopLibrary = new PShopLibrary();
         _loc2_.sl_level = param1.readUnsignedInt();
         _loc2_.sl_start_power = param1.readUnsignedInt();
         _loc2_.sl_book_size = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.sl_level);
         param1.writeInt(this.sl_start_power);
         param1.writeByte(this.sl_book_size);
      }
   }
}

