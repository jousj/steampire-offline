package logic.units
{
   import engine.units.Garbage;
   import engine.units.Unit;
   import game.board.UnitMenuButton;
   import game.my.MyMediator;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.ShopLogic;
   import proto.game.family_0010.PUserAction;
   import proto.model.PShopGarbage;
   import ui.vbase.VComponent;
   
   public class GarbageLogic extends AbstractLogic
   {
      
      public function GarbageLogic()
      {
         super();
      }
      
      override public function getMenu(param1:Unit, param2:Vector.<VComponent>) : void
      {
         var _loc4_:UnitMenuButton = null;
         var _loc3_:Garbage = param1 as Garbage;
         if(_loc3_.cleaning)
         {
            _loc4_ = MyMediator.cancelBt;
            _loc4_.changeHandler(ShopLogic.showCancelDialog,ActionLogic.CLEANUP_GARBAGE);
            param2.push(_loc4_);
            _loc4_ = MyMediator.speedupBt;
            _loc4_.trackSpeedup(CoreLogic.getActionTimeLeft(ActionLogic.CLEANUP_GARBAGE,_loc3_.id));
            _loc4_.handler = this.startSpeedup;
            param2.push(_loc4_);
         }
         else
         {
            _loc4_ = MyMediator.commonBt;
            _loc4_.change("GarbageIcon",true,Lang.getString("garbageBt"),this.startCleanup);
            _loc4_.applyPrice(_loc3_.shop.sg_remove_price);
            param2.push(_loc4_);
         }
      }
      
      public function startCleanup(param1:Garbage, param2:Boolean = true) : void
      {
         var _loc4_:PShopGarbage = param1.shop;
         var _loc5_:Boolean = _loc4_.sg_remove_time > 0;
         if(ShopLogic.checkCostAndWorker(_loc4_.sg_remove_price,this.startCleanup,arguments,_loc5_))
         {
            ShopLogic.applyCost(_loc4_.sg_remove_price,true);
            if(_loc5_)
            {
               ActionLogic.addCleanupGarbage(param1,CoreLogic.serverTime);
               boardMediator.syncSelected(param1);
            }
            else
            {
               ActionLogic.cleanupGarbage(param1);
            }
            if(param2)
            {
               ActionLogic.request(PUserAction.REMOVE_GARBAGE,param1.id);
            }
         }
      }
      
      private function startSpeedup(param1:Garbage) : void
      {
         ShopLogic.showActionSpeedupDialog(param1,ActionLogic.CLEANUP_GARBAGE);
      }
   }
}

