package engine.display
{
   import engine.signal.Signal;
   
   public class RepeatClip extends AnimClip
   {
      
      private var signal:Signal;
      
      private var index:uint;
      
      private var pauseTime:Number;
      
      private var loopCount:uint;
      
      private var curCount:uint;
      
      public function RepeatClip(param1:Number, param2:uint)
      {
         super();
         this.signal = getPlaySignal();
         this.pauseTime = param1;
         this.loopCount = param2 > 0 ? param2 : 1;
      }
      
      override public function play(param1:Animation = null, param2:Boolean = false, param3:uint = 0) : void
      {
         this.index = param3;
         super.play(param1,param2,param3);
      }
      
      override protected function nextLoopFrame() : void
      {
         super.nextLoopFrame();
         if(frameIndex == 0)
         {
            ++this.curCount;
            if(this.curCount == this.loopCount)
            {
               visible = false;
               this.curCount = 0;
               this.signal.handler = this.onVisible;
               this.signal.handlerTime += this.pauseTime;
            }
         }
      }
      
      private function onVisible() : void
      {
         visible = true;
         this.signal.handler = this.nextLoopFrame;
         super.nextLoopFrame();
      }
   }
}

