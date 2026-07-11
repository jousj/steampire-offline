package logic.quests
{
   import engine.units.Build;
   import game.barrack.BarrackBuyRenderer;
   import game.guard.GuardDialog;
   import logic.UnitFactory;
   import logic.training.AbstractTrain;
   import logic.training.DownStep;
   import ui.vbase.VEvent;
   
   public class GuardHelpTrain extends AbstractTrain
   {
      
      private var build:Build;
      
      private var dialog:GuardDialog;
      
      public function GuardHelpTrain(param1:Build)
      {
         super();
         this.build = param1;
      }
      
      override public function run() : void
      {
         UnitFactory.buildLogic.goInsideBuild(this.build);
         this.dialog = Facade.mainMediator.searchDialog(GuardDialog) as GuardDialog;
         if(this.dialog)
         {
            this.dialog.addListener(VEvent.CHANGE,this.onChange);
            this.dialog.addListener(VEvent.CLOSE_DIALOG,this.onClose);
            this.onChange(null);
         }
         else
         {
            this.dispose();
         }
      }
      
      private function onChange(param1:VEvent) : void
      {
         var _loc2_:BarrackBuyRenderer = null;
         for each(_loc2_ in this.dialog.buyGrid.renderList)
         {
            if(_loc2_.checkBuyBt())
            {
               assignStep(new DownStep(_loc2_.buyBt,135,{
                  "right":25,
                  "bottom":35
               }));
               return;
            }
         }
         if(!this.dialog.addBt.disabled)
         {
            assignStep(new DownStep(this.dialog.addBt,-90,{
               "left":5,
               "vCenter":0
            }));
         }
      }
      
      private function onClose(param1:VEvent) : void
      {
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.build = null;
         this.dialog = null;
         super.dispose();
      }
   }
}

