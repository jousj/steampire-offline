package model.vo
{
   import flash.utils.Dictionary;
   import model.ui.VOBattleItem;
   import proto.model.PHero;
   import proto.model.PUserBase;
   
   public class VORaidMember
   {
      
      public const soldierDp:Array = [];
      
      public var soldierLevelHash:Dictionary;
      
      public var id:String;
      
      public var ub:PUserBase;
      
      public var num:uint;
      
      public var soldierCount:int;
      
      public var soldierBattleCount:int;
      
      public var dropCapacity:int;
      
      public var maxCapacity:int;
      
      public var spellCount:int;
      
      public var heroList:Array;
      
      public var losing:Boolean;
      
      public var sim:Boolean;
      
      public var isBot:Boolean;
      
      public function VORaidMember(param1:Boolean = true)
      {
         super();
         if(param1)
         {
            this.soldierLevelHash = new Dictionary();
         }
      }
      
      public function heroByKind(param1:String) : PHero
      {
         var _loc2_:PHero = null;
         for each(_loc2_ in this.heroList)
         {
            if(_loc2_.hero_kind == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get capacity() : uint
      {
         var _loc2_:VOBattleItem = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.soldierDp)
         {
            if(_loc2_.shop)
            {
               _loc1_ += _loc2_.shop.su_hspace * _loc2_.count;
            }
         }
         return _loc1_;
      }
      
      public function isBotFinish() : Boolean
      {
         return this.isBot && !this.sim && this.soldierCount == 0;
      }
      
      public function assign(param1:PUserBase, param2:uint) : void
      {
         this.ub = param1;
         this.id = param1.user_id;
         this.num = param2;
         this.isBot = this.id.indexOf("vk_bot") == 0;
         if(param1.exp < 0)
         {
            this.losing = true;
         }
      }
      
      public function addSoldierItem(param1:String, param2:uint, param3:uint) : void
      {
         var _loc4_:VOBattleItem = new VOBattleItem();
         _loc4_.shop = Facade.manualProxy.getSoldierShop(param1,param2);
         _loc4_.count = param3;
         this.maxCapacity += _loc4_.shop.su_hspace * param3;
         this.soldierDp.push(_loc4_);
      }
   }
}

