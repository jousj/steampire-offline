package logic.quests
{
   import engine.units.Unit;
   import game.my.MyMediator;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.ShopLogic;
   import logic.training.ClickStep;
   import model.CommonEvent;
   
   public class PlacedQuestTrain extends HelpQuestTrain
   {
      
      private var isNewListener:Boolean;
      
      public function PlacedQuestTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         if(!item.isComplete && step != 1)
         {
            if(!this.isNewListener)
            {
               this.isNewListener = true;
               Facade.addListener(CommonEvent.NEW_UNIT,this.onNewUnit);
            }
         }
         super.run();
      }
      
      private function onNewUnit(param1:CommonEvent) : void
      {
         var _loc2_:Unit = null;
         if(param1.data)
         {
            _loc2_ = Facade.boardMediator.getSelected();
            if(Boolean(_loc2_) && _loc2_.kind == item.target.qti_kind)
            {
               Facade.changeUserStage(item.kind + "_placed");
               Facade.boardMediator.smoothMoveBoard(_loc2_.t_x,_loc2_.t_y);
               if(MyMediator.speedupBt.parent)
               {
                  if(ShopLogic.getSpeedupGold(CoreLogic.getActionTimeLeft(ActionLogic.FINISH_CONSTRUCTION,_loc2_.id)) == 0)
                  {
                     assignStep(new ClickStep(MyMediator.speedupBt,90,{
                        "right":2,
                        "vCenter":0
                     }));
                  }
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.isNewListener)
         {
            Facade.removeListener(CommonEvent.NEW_UNIT,this.onNewUnit);
         }
         super.dispose();
      }
   }
}

