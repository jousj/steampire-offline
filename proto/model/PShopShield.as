package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopShield implements IClientPacket
   {
      
      public var sh_kind:String;
      
      public var sh_price:PCost;
      
      public var sh_duration:Number;
      
      public function PShopShield()
      {
         super();
      }
      
      public static function create(param1:String, param2:PCost, param3:Number) : PShopShield
      {
         var _loc4_:PShopShield = new PShopShield();
         _loc4_.sh_kind = param1;
         _loc4_.sh_price = param2;
         _loc4_.sh_duration = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PShopShield
      {
         var _loc2_:PShopShield = new PShopShield();
         _loc2_.sh_kind = param1.readUTF();
         _loc2_.sh_price = PCost.read(param1);
         _loc2_.sh_duration = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.sh_kind);
         this.sh_price.write(param1);
         param1.writeDouble(this.sh_duration);
      }
   }
}

