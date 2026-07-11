package engine.spell
{
   import engine.display.AnimClip;
   import engine.display.Animation;
   import engine.signal.Signal;
   import engine.signal.Tween;
   import engine.units.RadiusUnit;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class RAASpell extends AnimClip
   {
      
      protected var animHash:Object;
      
      protected var sprite:Sprite;
      
      protected var signal:Signal;
      
      protected var duration:Number;
      
      protected var tween:Tween;
      
      public function RAASpell(param1:String, param2:Point, param3:Number, param4:uint = 0, param5:uint = 0, param6:Boolean = false)
      {
         var _loc7_:Shape = null;
         super();
         this.animHash = resourceProxy.animHash[param1];
         animation = this.animHash ? this.animHash["start"] : null;
         if(!animation)
         {
            return;
         }
         isSimulate = true;
         this.duration = param3;
         if(param4 > 0)
         {
            this.sprite = new Sprite();
            this.sprite.x = param2.x;
            this.sprite.y = param2.y;
            _loc7_ = new Shape();
            _loc7_.scaleY = 0.7071;
            RadiusUnit.drawRadius(_loc7_.graphics,3,param4,param5);
            if(param6)
            {
               Facade.board.tilePanel.addChild(this.sprite);
            }
            else
            {
               Facade.board.effectPanel.addChild(this.sprite);
            }
            this.sprite.addChild(_loc7_);
            this.sprite.addChild(this);
         }
         else
         {
            x = param2.x;
            y = param2.y;
            if(param6)
            {
               Facade.board.tilePanel.addChild(this);
            }
            else
            {
               Facade.board.effectPanel.addChild(this);
            }
         }
         endHandler = this.step1;
         play(animation);
      }
      
      protected function step1() : void
      {
         animation = this.animHash["repeat"];
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
      
      protected function step2() : void
      {
         this.tween = new Tween(this.sprite ? this.sprite : this,this.onTween);
         this.tween.play(["alpha",1,0],1);
      }
      
      protected function onTween(param1:Tween) : void
      {
         param1 = null;
         this.clear();
      }
      
      override public function clear() : void
      {
         if(this.tween)
         {
            this.tween.stop();
         }
         if(this.signal)
         {
            this.signal.stop();
         }
         if(Boolean(this.sprite) && Boolean(this.sprite.parent))
         {
            this.sprite.parent.removeChild(this.sprite);
         }
         super.clear();
      }
   }
}

