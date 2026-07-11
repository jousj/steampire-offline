package logic.training
{
   import engine.signal.Signal;
   
   public class ZoomStep extends AbstractTrainStep
   {
      
      private const signal:Signal;
      
      private var value:Number;
      
      private var isInc:Boolean;
      
      public function ZoomStep(param1:Number)
      {
         this.signal = new Signal(this.onSignal);
         super();
         if(param1 < 0.2 || param1 > 1)
         {
            throw new Error("bad zoom value " + param1);
         }
         this.value = param1;
         this.signal.delay = 0.02;
      }
      
      private function onSignal() : void
      {
         var _loc1_:Number = Facade.board.scaleX;
         if(this.isInc)
         {
            _loc1_ += 0.025;
            if(_loc1_ > this.value)
            {
               _loc1_ = this.value;
            }
         }
         else
         {
            _loc1_ -= 0.025;
            if(_loc1_ < this.value)
            {
               _loc1_ = this.value;
            }
         }
         Facade.myMediator.changeZoom(_loc1_);
         if(_loc1_ == this.value)
         {
            this.signal.stop();
            end();
         }
      }
      
      override public function run() : void
      {
         var _loc1_:Number = Facade.board.scaleX;
         if(_loc1_ == this.value)
         {
            end();
         }
         else
         {
            this.isInc = this.value > _loc1_;
            this.signal.run(10);
         }
      }
      
      override public function dispose() : void
      {
         this.signal.stop();
         super.dispose();
      }
   }
}

