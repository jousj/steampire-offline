package logic.training.firstsession
{
   import game.quest.QuestButton;
   import game.quest.QuestOneDialog;
   import logic.ErrorLogic;
   import logic.quests.QuestTrain;
   import logic.training.BlackoutClickStep;
   import model.CommonEvent;
   import model.ui.VOCallback;
   import ui.vbase.VButton;
   
   public class HardRewardTrain extends QuestTrain
   {
      
      protected var isShowListener:Boolean;
      
      public function HardRewardTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         if(item.isComplete)
         {
            this.checkQuestDialog();
         }
      }
      
      protected function checkQuestDialog(param1:QuestOneDialog = null) : Boolean
      {
         var bt:VButton = null;
         var errorLog:String = null;
         var qbt:QuestButton = null;
         var dialog:QuestOneDialog = param1;
         if(!dialog)
         {
            dialog = Facade.mainMediator.searchDialog(QuestOneDialog);
         }
         if(dialog)
         {
            Facade.changeUserStage("home3_qm2_click");
            try
            {
               bt = dialog.renderer.rewardBt;
               assignStep(new BlackoutClickStep(bt,270,{
                  "left":-4,
                  "vCenter":0
               },new VOCallback(this.rewardComplete)));
            }
            catch(e:Error)
            {
               ErrorLogic.sendError("SMTH BAD ON 1 BRANCH " + dialog.renderer.cacheItem.kind + " " + item.kind);
               throw e;
            }
            return true;
         }
         if(!this.isShowListener)
         {
            this.isShowListener = true;
            if(item.isHidden)
            {
               errorLog = "HIDDEN ITEM FOUND";
            }
            try
            {
               qbt = Facade.myMediator.myPanel.questBtPanel.getButton(item.kind);
               assignStep(new BlackoutClickStep(qbt,NaN,null));
               qbt.loopClip();
            }
            catch(e:Error)
            {
               ErrorLogic.sendError("SMTH BAD ON 2 BRANCH");
               throw e;
            }
            Facade.addListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         }
         return false;
      }
      
      private function rewardComplete() : void
      {
         Facade.changeUserStage("home3_qm2_reward_click");
      }
      
      protected function onShowDialog(param1:CommonEvent) : void
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

