package engine.spell
{
   import engine.display.AnimClip;
   import engine.display.Animation;
   import engine.signal.Signal;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class CallSpell extends AnimClip
   {
      
      private const animHash:Object = resourceProxy.animHash["sp_call"];
      
      private var signal:Signal;
      
      private var duration:Number;
      
      public function CallSpell(param1:Point, param2:Number)
      {
         super();
         animation = this.animHash ? this.animHash["start"] : null;
         if(!animation)
         {
            return;
         }
         isSimulate = true;
         this.duration = param2;
         x = param1.x;
         y = param1.y;
         var _loc3_:Sprite = Facade.board.effectPanel;
         var _loc4_:* = int(_loc3_.numChildren - 1);
         while(_loc4_ >= 0)
         {
            if(_loc3_.getChildAt(_loc4_) is CallSpell)
            {
               (_loc3_.getChildAt(_loc4_) as CallSpell).clear();
               break;
            }
            _loc4_--;
         }
         _loc3_.addChild(this);
         endHandler = this.step1;
         play(animation);
      }
      
      private function step1() : void
      {
         animation = this.animHash["repeat_a1"];
         if(animation)
         {
            play(animation,true);
            this.signal = new Signal(this.step2);
            this.signal.delayCall(this.duration,true);
         }
         else
         {
            this.clear();
         }
      }
      
      private function step2() : void
      {
         animation = this.animHash["finish"];
         if(animation)
         {
            endHandler = this.clear;
            play(animation);
         }
         else
         {
            this.clear();
         }
      }
      
      override public function clear() : void
      {
         if(this.signal)
         {
            this.signal.stop();
         }
         removeFromParent();
         super.clear();
      }
   }
}

