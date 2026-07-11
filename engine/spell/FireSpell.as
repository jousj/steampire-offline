package engine.spell
{
   import engine.display.AnimClip;
   import engine.display.Animation;
   import engine.display.EffectClip;
   import engine.signal.Tween;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class FireSpell extends AnimClip
   {
      
      private var earthClip:AnimClip;
      
      private var tween:Tween;
      
      private var boomAnimation:Animation;
      
      public function FireSpell(param1:Point)
      {
         var _loc4_:EffectClip = null;
         super();
         animation = resourceProxy.getAnimation("sp_fireball","start_a1");
         if(!animation)
         {
            return;
         }
         this.boomAnimation = resourceProxy.getAnimation("cn_mortar","boom");
         if(this.boomAnimation)
         {
            resourceProxy.load(this.boomAnimation.lib);
         }
         isSimulate = true;
         this.earthClip = new AnimClip();
         this.earthClip.animation = resourceProxy.getAnimation("sp_fireball","start_a2");
         this.earthClip.setSimulate(true);
         this.x = this.earthClip.x = param1.x;
         this.y = this.earthClip.y = param1.y;
         var _loc2_:Sprite = Facade.board.effectPanel;
         var _loc3_:int = 1;
         while(_loc3_ <= 2)
         {
            _loc4_ = EffectClip.create();
            _loc2_.addChild(_loc4_);
            if(_loc3_ == 1)
            {
               _loc4_.x = x + 15;
               _loc4_.y = y - 10;
               _loc4_.playDelay(animation,0.3);
            }
            else
            {
               _loc4_.x = x - 25;
               _loc4_.y = y + 25;
               _loc4_.playDelay(animation,0.5);
            }
            _loc3_++;
         }
         _loc2_.addChild(this);
         _loc2_.addChild(this.earthClip);
         endHandler = this.step1;
         play(animation);
         this.earthClip.play(this.earthClip.animation);
      }
      
      private function step1() : void
      {
         if(this.boomAnimation)
         {
            endHandler = this.step2;
            play(this.boomAnimation);
         }
         else
         {
            this.step2();
         }
      }
      
      private function step2() : void
      {
         removeFromParent();
         this.tween = new Tween(this.earthClip,this.onTween);
         this.tween.play(["alpha",1,0],3);
      }
      
      private function onTween(param1:Tween) : void
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
         if(this.earthClip)
         {
            this.earthClip.removeFromParent();
            this.earthClip.clear();
         }
         removeFromParent();
         super.clear();
      }
   }
}

