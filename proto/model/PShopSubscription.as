package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopSubscription implements IClientPacket
   {
      
      public var id:int;
      
      public var duration_days:int;
      
      public var vk_price:Number;
      
      public var offer_kind:String;
      
      public function PShopSubscription()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:Number, param4:String) : PShopSubscription
      {
         var _loc5_:PShopSubscription = new PShopSubscription();
         _loc5_.id = param1;
         _loc5_.duration_days = param2;
         _loc5_.vk_price = param3;
         _loc5_.offer_kind = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PShopSubscription
      {
         var _loc2_:PShopSubscription = new PShopSubscription();
         _loc2_.id = param1.readInt();
         _loc2_.duration_days = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.vk_price = param1.readInt();
         }
         else
         {
            _loc2_.vk_price = NaN;
         }
         _loc2_.offer_kind = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.id);
         param1.writeInt(this.duration_days);
         if(!isNaN(this.vk_price))
         {
            param1.writeByte(1);
            param1.writeInt(this.vk_price);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeUTF(this.offer_kind);
      }
   }
}

