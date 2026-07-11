package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopCall implements IClientPacket
   {
      
      public var call_num:int;
      
      public var call_effect:PCallEffect;
      
      public var call_price:PCost;
      
      public function PShopCall()
      {
         super();
      }
      
      public static function create(param1:int, param2:PCallEffect, param3:PCost) : PShopCall
      {
         var _loc4_:PShopCall = new PShopCall();
         _loc4_.call_num = param1;
         _loc4_.call_effect = param2;
         _loc4_.call_price = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PShopCall
      {
         var _loc2_:PShopCall = new PShopCall();
         _loc2_.call_num = param1.readInt();
         _loc2_.call_effect = PCallEffect.read(param1);
         _loc2_.call_price = PCost.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.call_num);
         this.call_effect.write(param1);
         this.call_price.write(param1);
      }
   }
}

