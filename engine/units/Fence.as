package engine.units
{
   import proto.model.PShopFence;
   
   public class Fence extends Unit
   {
      
      public var shop:PShopFence;
      
      private var connectIndex:uint = 4294967295;
      
      public function Fence(param1:PShopFence)
      {
         super();
         applyKind(param1.sf_kind,RIGHT_DOWN,param1.sf_kind);
         this.assignShop(param1);
      }
      
      public function assignShop(param1:PShopFence) : void
      {
         this.shop = param1;
         level = param1.sf_level;
         stamina = param1.sf_stamina;
         armor = param1.sf_armor;
         boomList = boomHash[kind + "level" + level];
      }
      
      public function setConnectIndex(param1:uint) : void
      {
         if(this.connectIndex != param1)
         {
            this.connectIndex = param1;
            this.stand();
         }
      }
      
      override public function stand() : void
      {
         var _loc1_:String = "level" + this.shop.sf_model_level;
         if(this.connectIndex == uint.MAX_VALUE)
         {
            this.connectIndex = 0;
         }
         goAnim(_loc1_,this.connectIndex);
         setShadow(_loc1_,this.connectIndex);
      }
   }
}

