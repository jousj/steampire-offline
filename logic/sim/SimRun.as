package logic.sim
{
   import engine.Position;
   import flash.geom.Point;
   import model.ui.VOBattleItem;
   import proto.model.PKindCount;
   import proto.model.PShopSpell;
   import proto.model.PShopUnit;
   
   public class SimRun
   {
      
      public var deathSoldierDp:Array;
      
      public function SimRun()
      {
         super();
      }
      
      public function activateUnit(param1:SimUnitT, param2:SimGroup = null, param3:int = 0) : void
      {
      }
      
      public function deactivateUnit(param1:int) : void
      {
      }
      
      public function unitPrepareMove(param1:int, param2:Point, param3:int, param4:Boolean) : void
      {
      }
      
      public function unitMove(param1:int, param2:Point) : void
      {
      }
      
      public function unitPrepareAttack(param1:int, param2:SimBoardObj, param3:int) : void
      {
      }
      
      public function unitFireAttack(param1:SimUnitT, param2:Point, param3:int, param4:SimBoardObj) : void
      {
      }
      
      public function applyDamage(param1:SimBoardObj, param2:int, param3:int, param4:SimUnitT = null) : void
      {
      }
      
      public function stand(param1:int) : void
      {
      }
      
      public function unitDeath(param1:SimUnitT) : void
      {
         if(Boolean(this.deathSoldierDp) && Boolean(param1.is_attacker) && param1.user_num < 2)
         {
            this.addDeathSoldier(param1.shop);
         }
      }
      
      public function addDeathSoldier(param1:PShopUnit) : void
      {
         var _loc2_:VOBattleItem = null;
         for each(_loc2_ in this.deathSoldierDp)
         {
            if(_loc2_.shop == param1)
            {
               ++_loc2_.count;
               return;
            }
         }
         _loc2_ = new VOBattleItem();
         _loc2_.shop = param1;
         _loc2_.count = 1;
         this.deathSoldierDp.push(_loc2_);
      }
      
      public function cannonPrepareAttack(param1:int, param2:Point, param3:int, param4:int) : void
      {
      }
      
      public function cannonFireAttack(param1:int, param2:Point, param3:int, param4:int) : void
      {
      }
      
      public function attention(param1:int) : void
      {
      }
      
      public function drawVector(param1:Position, param2:Position, param3:Boolean, param4:uint) : void
      {
      }
      
      public function activateSpell(param1:PShopSpell, param2:Point, param3:int) : void
      {
      }
      
      public function calcDeathSoldier(param1:Array, param2:Array) : void
      {
         var _loc3_:PKindCount = null;
         var _loc4_:uint = 0;
         var _loc5_:PShopUnit = null;
         var _loc6_:VOBattleItem = null;
         var _loc7_:VOBattleItem = null;
         this.deathSoldierDp.length = 0;
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_.count;
            _loc5_ = null;
            for each(_loc6_ in param2)
            {
               if(_loc6_.shop.su_kind == _loc3_.kind)
               {
                  _loc5_ = _loc6_.shop;
                  _loc4_ -= _loc6_.count;
                  break;
               }
            }
            if(_loc4_ > 0)
            {
               _loc7_ = new VOBattleItem();
               _loc7_.count = _loc4_;
               _loc7_.shop = _loc5_ ? _loc5_ : Facade.manualProxy.getSoldierShop(_loc3_.kind);
               this.deathSoldierDp.push(_loc7_);
            }
         }
      }
      
      public function changePower(param1:int, param2:int, param3:int = 0, param4:Boolean = false) : void
      {
      }
      
      public function cannonDisable(param1:int, param2:Boolean) : void
      {
      }
   }
}

