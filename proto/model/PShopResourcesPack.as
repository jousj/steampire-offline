package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopResourcesPack implements IClientPacket
   {
      
      public var rs_kind:String;
      
      public var rs_percentage:uint;
      
      public var rs_type:PCostt;
      
      public function PShopResourcesPack()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:PCostt) : PShopResourcesPack
      {
         var _loc4_:PShopResourcesPack = new PShopResourcesPack();
         _loc4_.rs_kind = param1;
         _loc4_.rs_percentage = param2;
         _loc4_.rs_type = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PShopResourcesPack
      {
         var _loc2_:PShopResourcesPack = new PShopResourcesPack();
         _loc2_.rs_kind = param1.readUTF();
         _loc2_.rs_percentage = param1.readUnsignedByte();
         _loc2_.rs_type = PCostt.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.rs_kind);
         param1.writeByte(this.rs_percentage);
         this.rs_type.write(param1);
      }
   }
}

