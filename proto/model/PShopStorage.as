package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopStorage implements IClientPacket
   {
      
      public var ss_kind:String;
      
      public var ss_level:uint;
      
      public var ss_capacity:PCost;
      
      public function PShopStorage()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:PCost) : PShopStorage
      {
         var _loc4_:PShopStorage = new PShopStorage();
         _loc4_.ss_kind = param1;
         _loc4_.ss_level = param2;
         _loc4_.ss_capacity = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PShopStorage
      {
         var _loc2_:PShopStorage = new PShopStorage();
         _loc2_.ss_kind = param1.readUTF();
         _loc2_.ss_level = param1.readUnsignedInt();
         _loc2_.ss_capacity = PCost.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.ss_kind);
         param1.writeInt(this.ss_level);
         this.ss_capacity.write(param1);
      }
   }
}

