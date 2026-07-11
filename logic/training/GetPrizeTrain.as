package logic.training
{
   import game.quest.QuestButton;
   import game.quest.QuestOneDialog;
   
   public class GetPrizeTrain extends AbstractTrain
   {
      
      private var kind:String;
      
      public function GetPrizeTrain(param1:String)
      {
         super();
         this.kind = param1;
      }
      
      override public function run() : void
      {
         var _loc1_:QuestButton = Facade.myMediator.myPanel.questBtPanel.getButton(this.kind);
         if(_loc1_)
         {
            assignStep(new BlackoutClickStep(_loc1_,NaN,null),this.onQuestDialog);
         }
      }
      
      private function onQuestDialog() : void
      {
         Facade.changeUserStage(this.kind + "_quest_dialog");
         var _loc1_:QuestOneDialog = Facade.mainMediator.searchDialog(QuestOneDialog);
         if(_loc1_.renderer.rewardBt)
         {
            assignStep(new BlackoutClickStep(_loc1_.renderer.rewardBt,270,{
               "left":-4,
               "vCenter":0
            }),dispose);
         }
      }
   }
}

