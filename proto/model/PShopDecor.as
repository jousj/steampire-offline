package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopDecor implements IClientPacket
   {
      
      public var sd_kind:String;
      
      public var sd_price:PCost;
      
      public var sd_sell_price:PCost;
      
      public var sd_order:int;
      
      public var sd_can_buy:Boolean;
      
      public function PShopDecor()
      {
         super();
      }
      
      public static function create(param1:String, param2:PCost, param3:PCost, param4:int, param5:Boolean) : PShopDecor
      {
         var _loc6_:PShopDecor = new PShopDecor();
         _loc6_.sd_kind = param1;
         _loc6_.sd_price = param2;
         _loc6_.sd_sell_price = param3;
         _loc6_.sd_order = param4;
         _loc6_.sd_can_buy = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PShopDecor
      {
         var _loc2_:PShopDecor = new PShopDecor();
         _loc2_.sd_kind = param1.readUTF();
         _loc2_.sd_price = PCost.read(param1);
         _loc2_.sd_sell_price = PCost.read(param1);
         _loc2_.sd_order = param1.readInt();
         _loc2_.sd_can_buy = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.sd_kind);
         this.sd_price.write(param1);
         this.sd_sell_price.write(param1);
         param1.writeInt(this.sd_order);
         param1.writeBoolean(this.sd_can_buy);
      }
   }
}

