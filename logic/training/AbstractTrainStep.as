package logic.training
{
   public class AbstractTrainStep
   {
      
      public var endFunc:Function;
      
      public function AbstractTrainStep()
      {
         super();
      }
      
      public function run() : void
      {
      }
      
      public function dispose() : void
      {
      }
      
      protected function end(... rest) : void
      {
         if(this.endFunc != null)
         {
            this.endFunc();
         }
      }
   }
}

