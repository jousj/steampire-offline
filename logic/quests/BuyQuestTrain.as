package logic.quests
{
   import engine.Position;
   import logic.training.BuyTrain;
   import logic.training.GetPrizeTrain;
   
   public class BuyQuestTrain extends QuestTrain
   {
      
      public var position:Position = new Position(28,25);
      
      public function BuyQuestTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         if(item.isComplete)
         {
            if(step != 2)
            {
               wait(1,this.assignPrizeTrain);
            }
         }
         else if(step != 1)
         {
            assignTrain(new BuyTrain(item.target.qti_kind,this.position,item.kind),1);
         }
      }
      
      private function assignPrizeTrain() : void
      {
         Facade.boardMediator.resetMoved();
         assignTrain(new GetPrizeTrain(item.kind),2);
      }
   }
}

