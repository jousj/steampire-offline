package logic.quests
{
   import logic.training.AbstractTrain;
   import model.vo.VOQuest;
   
   public class QuestTrain extends AbstractTrain
   {
      
      public var item:VOQuest;
      
      protected var step:uint;
      
      protected var train:AbstractTrain;
      
      public function QuestTrain()
      {
         super();
      }
      
      protected function assignTrain(param1:AbstractTrain, param2:uint = 0) : void
      {
         clearStep();
         if(this.train)
         {
            this.train.dispose();
         }
         this.step = param2;
         this.train = param1;
         param1.run();
      }
      
      protected function clearTrain() : void
      {
         if(this.train)
         {
            this.train.dispose();
            this.train = null;
         }
      }
      
      override public function dispose() : void
      {
         this.clearTrain();
         super.dispose();
      }
   }
}

