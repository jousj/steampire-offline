package
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class FPSControl
   {
      
      private var isListener:Boolean;
      
      private var fpsLastSecond:int;
      
      private var fpsMetric:int = 0;
      
      private var fpsStartTime:int = 0;
      
      private var fpsCounter:int = 0;
      
      private var stage:Stage;
      
      private var secondControl:int;
      
      private var decFps:Number;
      
      private var incFps:Number;
      
      private var defaultFrameRate:Number;
      
      public function FPSControl()
      {
         super();
      }
      
      public function init(param1:Stage, param2:Number = 4, param3:Number = 2, param4:int = 4) : void
      {
         this.stage = param1;
         this.defaultFrameRate = param1.frameRate;
         this.decFps = param2;
         this.incFps = param3;
         this.secondControl = param4;
      }
      
      public function start() : void
      {
         this.fpsStartTime = getTimer();
         this.fpsCounter = 0;
         this.fpsLastSecond = this.defaultFrameRate;
         this.changeListener(true);
      }
      
      public function stop() : void
      {
         this.changeListener(false);
      }
      
      private function changeListener(param1:Boolean) : void
      {
         if(param1 != this.isListener)
         {
            this.isListener = param1;
            if(param1)
            {
               this.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
            else
            {
               this.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc2_:Number = this.stage.frameRate;
         ++this.fpsCounter;
         if(this.fpsCounter >= _loc2_)
         {
            _loc3_ = getTimer();
            _loc4_ = Math.round(1000 / ((_loc3_ - this.fpsStartTime) / _loc2_));
            if(this.fpsLastSecond < _loc2_ && _loc4_ < _loc2_)
            {
               if(this.fpsMetric < 0)
               {
                  this.fpsMetric = 1;
               }
               else
               {
                  ++this.fpsMetric;
               }
               if(this.fpsMetric > this.secondControl)
               {
                  this.fpsMetric = this.fpsCounter = 0;
                  _loc2_ -= this.decFps;
                  this.stage.frameRate = _loc2_ < 1 ? 1 : _loc2_;
               }
            }
            else if(_loc4_ >= _loc2_ && this.fpsLastSecond >= _loc2_)
            {
               if(this.fpsMetric > 0)
               {
                  this.fpsMetric = -1;
               }
               else
               {
                  --this.fpsMetric;
               }
               if(this.fpsMetric < -this.secondControl)
               {
                  this.fpsMetric = this.fpsCounter = 0;
                  if(_loc2_ < this.defaultFrameRate)
                  {
                     _loc2_ += this.incFps;
                     this.stage.frameRate = _loc2_ > this.defaultFrameRate ? this.defaultFrameRate : _loc2_;
                  }
               }
            }
            this.fpsLastSecond = _loc4_;
            this.fpsCounter = 0;
            this.fpsStartTime = _loc3_;
         }
      }
      
      public function applyFrameRate(param1:Number) : void
      {
         this.stage.frameRate = this.defaultFrameRate = this.fpsLastSecond = param1;
         if(this.isListener)
         {
            this.fpsMetric = this.fpsCounter = 0;
            this.fpsStartTime = getTimer();
         }
      }
   }
}

