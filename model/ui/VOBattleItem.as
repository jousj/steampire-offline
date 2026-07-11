package model.ui
{
   import proto.model.PShopSpell;
   import proto.model.PShopUnit;
   import proto.model.spell.PCure;
   
   public class VOBattleItem
   {
      
      public var shop:PShopUnit;
      
      public var count:uint;
      
      public var isLock:Boolean;
      
      public var select:uint;
      
      public var spellShop:PShopSpell;
      
      public var waitTime:uint;
      
      public var isWorker:Boolean;
      
      public function VOBattleItem()
      {
         super();
      }
      
      public static function sort(param1:VOBattleItem, param2:VOBattleItem) : Number
      {
         if(Boolean(param1.shop) && Boolean(param2.shop))
         {
            return param1.shop.order - param2.shop.order;
         }
         if(Boolean(param1.spellShop) && Boolean(param2.spellShop))
         {
            return param1.spellShop.order - param2.spellShop.order;
         }
         return param1.shop ? -1 : 1;
      }
      
      public function assignSoldier(param1:PShopUnit, param2:uint) : VOBattleItem
      {
         this.shop = param1;
         this.count = param2;
         return this;
      }
      
      public function assignSpell(param1:PShopSpell, param2:Boolean = false, param3:Boolean = false) : VOBattleItem
      {
         this.spellShop = param1;
         this.count = 1;
         this.isWorker = param2;
         this.isLock = param3;
         return this;
      }
      
      public function get workerDuration() : uint
      {
         var _loc1_:PCure = this.spellShop ? this.spellShop.ssp_effect.value as PCure : null;
         return _loc1_ ? uint(_loc1_.cure_duration * _loc1_.cure_count) : 0;
      }
   }
}

