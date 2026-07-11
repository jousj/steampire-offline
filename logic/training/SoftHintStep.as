package logic.training
{
   import engine.signal.Signal;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import ui.vbase.VComponent;
   
   public class SoftHintStep extends AbstractTrainStep
   {
      
      private var startDelay:Number;
      
      private var memy:int = 0;
      
      private var repeat:uint = 0;
      
      private var filter:ColorMatrixFilter;
      
      private var signal:Signal = new Signal();
      
      private var target:VComponent;
      
      private var onlyControl:Boolean;
      
      private var isTargetListener:Boolean;
      
      public function SoftHintStep(param1:VComponent, param2:Number = 2, param3:Boolean = false)
      {
         super();
         this.startDelay = param2;
         this.target = param1;
         this.onlyControl = param3;
         param1.addListener(MouseEvent.CLICK,end);
         if(!param3)
         {
            param1.addListener(MouseEvent.MOUSE_OVER,this.onOver);
            param1.addListener(MouseEvent.MOUSE_OUT,this.onOut);
         }
         this.setTargetListener(true);
      }
      
      private function setTargetListener(param1:Boolean) : void
      {
         if(param1 != this.isTargetListener)
         {
            this.isTargetListener = param1;
            if(param1)
            {
               this.target.addListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
            }
            else
            {
               this.target.removeListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
            }
         }
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         this.dispose();
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.signal.handler = this.onSignal1;
         this.signal.delayCall(1);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this.signal.stopWithoutHandler();
         this.target.y = this.memy;
         this.target.filters = null;
         this.repeat = 0;
      }
      
      override public function run() : void
      {
         if(!this.onlyControl)
         {
            this.signal.handler = this.onSignal1;
            this.signal.delayCall(this.startDelay);
         }
      }
      
      private function onSignal1() : void
      {
         this.signal.stopWithoutHandler();
         this.signal.handler = this.onSignal2;
         this.signal.data = this.memy = this.target.y;
         this.signal.run(0.15);
      }
      
      private function onSignal2() : void
      {
         var _loc1_:Number = this.signal.data - 10;
         this.target.y = this.signal.passedRate * (_loc1_ - this.signal.data) + this.signal.data;
         this.getFilter(28 * this.signal.passedRate,1 + 0.28 * this.signal.passedRate);
         this.target.filters = [this.filter];
         if(this.signal.tail == 0)
         {
            this.signal.data = this.target.y;
            this.signal.handler = this.onSignal3;
            this.signal.run(0.15);
         }
      }
      
      private function onSignal3() : void
      {
         var _loc1_:Number = this.signal.data + 10;
         this.target.y = this.signal.passedRate * (_loc1_ - this.signal.data) + this.signal.data;
         this.getFilter(28 * (1 - this.signal.passedRate),1.28 - 0.28 * this.signal.passedRate);
         this.target.filters = [this.filter];
         if(this.signal.tail == 0)
         {
            ++this.repeat;
            if(this.repeat > 1)
            {
               this.repeat = 0;
               this.signal.handler = this.onSignal1;
               this.signal.delayCall(0.5);
            }
            else
            {
               this.onSignal1();
            }
         }
      }
      
      private function getFilter(param1:Number, param2:Number) : void
      {
         if(!this.filter)
         {
            this.filter = new ColorMatrixFilter();
         }
         this.filter.matrix = [param2,0,0,0,param1,0,param2,0,0,param1,0,0,param2,0,param1,0,0,0,1,0];
      }
      
      override public function dispose() : void
      {
         this.target.removeListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.target.removeListener(MouseEvent.CLICK,end);
         if(!this.onlyControl)
         {
            this.target.removeListener(MouseEvent.MOUSE_OVER,this.onOver);
            this.target.removeListener(MouseEvent.MOUSE_OUT,this.onOut);
         }
         if(this.signal)
         {
            this.signal.stopWithoutHandler();
            this.signal = null;
         }
         this.target.y = this.memy;
         this.target.filters = null;
      }
   }
}

