package logic.quests
{
   import game.quest.QuestButton;
   import game.quest.QuestOneDialog;
   import logic.training.DownStep;
   import model.CommonEvent;
   import ui.vbase.VButton;
   
   public class HelpQuestTrain extends QuestTrain
   {
      
      private var isShowListener:Boolean;
      
      public function HelpQuestTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc1_:QuestButton = null;
         if(item.isComplete)
         {
            if(step != 2)
            {
               step = 2;
               this.checkQuestDialog();
            }
         }
         else if(step != 1)
         {
            step = 1;
            if(!this.checkQuestDialog())
            {
               _loc1_ = Facade.myMediator.myPanel.questBtPanel.getButton(item.kind);
               if(_loc1_)
               {
                  _loc1_.removeClip();
                  assignStep(new DownStep(_loc1_,90,{
                     "vCenter":0,
                     "right":-2
                  }));
               }
            }
         }
      }
      
      private function checkQuestDialog(param1:QuestOneDialog = null) : Boolean
      {
         var _loc2_:VButton = null;
         if(!param1)
         {
            param1 = Facade.mainMediator.searchDialog(QuestOneDialog);
         }
         if(param1)
         {
            _loc2_ = step == 2 ? param1.renderer.rewardBt : param1.renderer.helpBt;
            if(_loc2_)
            {
               assignStep(new DownStep(_loc2_,270,{
                  "left":-4,
                  "vCenter":0
               }));
            }
            return true;
         }
         if(!this.isShowListener)
         {
            this.isShowListener = true;
            Facade.addListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         }
         return false;
      }
      
      private function onShowDialog(param1:CommonEvent) : void
      {
         var _loc2_:QuestOneDialog = param1.data as QuestOneDialog;
         if(_loc2_)
         {
            this.checkQuestDialog(_loc2_);
         }
      }
      
      override public function dispose() : void
      {
         if(this.isShowListener)
         {
            Facade.removeListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         }
         super.dispose();
      }
   }
}

