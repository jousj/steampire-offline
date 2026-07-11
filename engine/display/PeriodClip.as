package engine.display
{
   import engine.signal.Signal;
   import engine.units.AnimObject;
   
   public class PeriodClip extends AnimClip
   {
      
      private var endTime:Number = 0;
      
      private var signal:Signal;
      
      private var pauseTime:Number;
      
      private var allTime:Number;
      
      private var useVisible:Boolean;
      
      public function PeriodClip(param1:Boolean, param2:Number, param3:Number)
      {
         super();
         this.signal = getPlaySignal();
         this.useVisible = param1;
         this.pauseTime = param2;
         this.allTime = param2 + param3;
      }
      
      public static function create(param1:AnimObject, param2:String, param3:Boolean = false) : PeriodClip
      {
         var _loc4_:PeriodClip = new PeriodClip(param3,5,5);
         _loc4_.name = param2;
         param1.display.add(_loc4_,AnimDisplay.SCENE,param1.display.getClipIndex(param1.animClip) + 1);
         return _loc4_;
      }
      
      override public function play(param1:Animation = null, param2:Boolean = false, param3:uint = 0) : void
      {
         if(param2)
         {
            this.endTime = 0;
         }
         else if(this.useVisible)
         {
            visible = true;
         }
         super.play(param1,param2,param3);
      }
      
      override protected function nextLoopFrame() : void
      {
         super.nextLoopFrame();
         if(this.signal.handlerTime >= this.endTime)
         {
            if(this.endTime == 0)
            {
               this.endTime = this.signal.handlerTime + Math.random() * this.allTime;
            }
            else
            {
               this.signal.handlerTime += this.pauseTime;
               this.endTime = this.signal.handlerTime + this.allTime;
               if(this.useVisible)
               {
                  visible = false;
                  this.signal.handler = this.onVisible;
               }
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

