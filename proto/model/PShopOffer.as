package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopOffer implements IClientPacket
   {
      
      public var offer_kind:String;
      
      public var offer_goods:Array;
      
      public var offer_duration:Number;
      
      public var offer_social_price:Number;
      
      public var offer_gold_price:uint;
      
      public var offer_type:String;
      
      public var offer_sale1:uint;
      
      public var offer_sale2:uint;
      
      public var offer_icon:String;
      
      public var offer_is_autoview:Boolean;
      
      public var caption:String;
      
      public function PShopOffer()
      {
         super();
      }
      
      public static function create(param1:String, param2:Array, param3:Number, param4:Number, param5:uint, param6:String, param7:uint, param8:uint, param9:String, param10:Boolean) : PShopOffer
      {
         var _loc11_:PShopOffer = new PShopOffer();
         _loc11_.offer_kind = param1;
         _loc11_.offer_goods = param2;
         _loc11_.offer_duration = param3;
         _loc11_.offer_social_price = param4;
         _loc11_.offer_gold_price = param5;
         _loc11_.offer_type = param6;
         _loc11_.offer_sale1 = param7;
         _loc11_.offer_sale2 = param8;
         _loc11_.offer_icon = param9;
         _loc11_.offer_is_autoview = param10;
         return _loc11_;
      }
      
      public static function read(param1:IDataInput) : PShopOffer
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PShopOffer = new PShopOffer();
         _loc2_.offer_kind = param1.readUTF();
         _loc2_.offer_goods = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.offer_goods.length)
         {
            _loc2_.offer_goods[_loc3_] = _loc4_ = POfferGoods.read(param1);
            _loc3_++;
         }
         _loc2_.offer_duration = param1.readDouble();
         _loc2_.offer_social_price = param1.readDouble();
         _loc2_.offer_gold_price = param1.readUnsignedInt();
         _loc2_.offer_type = param1.readUTF();
         _loc2_.offer_sale1 = param1.readUnsignedInt();
         _loc2_.offer_sale2 = param1.readUnsignedInt();
         _loc2_.offer_icon = param1.readUTF();
         _loc2_.offer_is_autoview = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.offer_kind);
         if(this.offer_goods == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.offer_goods.length);
            _loc2_ = 0;
            while(_loc2_ < this.offer_goods.length)
            {
               this.offer_goods[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeDouble(this.offer_duration);
         param1.writeDouble(this.offer_social_price);
         param1.writeInt(this.offer_gold_price);
         param1.writeUTF(this.offer_type);
         param1.writeInt(this.offer_sale1);
         param1.writeInt(this.offer_sale2);
         param1.writeUTF(this.offer_icon);
         param1.writeBoolean(this.offer_is_autoview);
      }
   }
}

