package logic.quests
{
   import game.my.GoDialog;
   import game.portal.PortalDialog;
   import game.portal.PortalRenderer;
   import logic.training.AbstractTrain;
   import logic.training.DownStep;
   import model.CommonEvent;
   import ui.vbase.VButton;
   
   public class RaidHelpTrain extends AbstractTrain
   {
      
      private var kind:String;
      
      public function RaidHelpTrain(param1:String)
      {
         super();
         this.kind = param1;
      }
      
      override public function run() : void
      {
         Facade.addListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         assignStep(new DownStep(Facade.myMediator.myPanel.goBt,-40,{
            "left":5,
            "top":5
         }));
      }
      
      private function onShowDialog(param1:CommonEvent) : void
      {
         var _loc2_:PortalDialog = null;
         var _loc3_:PortalRenderer = null;
         var _loc4_:VButton = null;
         if(param1.data is GoDialog)
         {
            assignStep(new DownStep((param1.data as GoDialog).raidBt,0,{"hCenter":0}));
         }
         else if(param1.data is PortalDialog && Boolean(this.kind))
         {
            Facade.removeListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
            if(!Facade.questProxy.getQuest("tryRaid1"))
            {
               _loc2_ = Facade.mainMediator.searchDialog(PortalDialog);
               for each(_loc3_ in _loc2_.grid.renderList)
               {
                  _loc4_ = _loc3_.getStartButton(this.kind);
                  if(_loc4_)
                  {
                     assignStep(new DownStep(_loc4_,-40,{
                        "left":5,
                        "top":5
                     }));
                     break;
                  }
               }
            }
         }
         else
         {
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         Facade.removeListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         super.dispose();
      }
   }
}

