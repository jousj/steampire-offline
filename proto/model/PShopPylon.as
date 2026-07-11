package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopPylon implements IClientPacket
   {
      
      public var sp_kind:String;
      
      public var sp_level:uint;
      
      public var sp_radius:uint;
      
      public function PShopPylon()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:uint) : PShopPylon
      {
         var _loc4_:PShopPylon = new PShopPylon();
         _loc4_.sp_kind = param1;
         _loc4_.sp_level = param2;
         _loc4_.sp_radius = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PShopPylon
      {
         var _loc2_:PShopPylon = new PShopPylon();
         _loc2_.sp_kind = param1.readUTF();
         _loc2_.sp_level = param1.readUnsignedInt();
         _loc2_.sp_radius = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.sp_kind);
         param1.writeInt(this.sp_level);
         param1.writeByte(this.sp_radius);
      }
   }
}

