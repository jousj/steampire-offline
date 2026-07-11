package engine.units
{
   import engine.data.LinkedItem;
   import engine.display.AnimClip;
   import engine.display.AnimDisplay;
   import engine.display.Animation;
   import flash.geom.Rectangle;
   
   public class AnimObject extends LinkedItem
   {
      
      public static const RIGHT_DOWN:uint = 1;
      
      public static const RIGHT_UP:uint = 2;
      
      public static const LEFT_DOWN:uint = 4;
      
      public static const LEFT_UP:uint = 8;
      
      public static const H_LEFT:uint = 16;
      
      public static const H_RIGHT:uint = 32;
      
      public static const V_UP:uint = 64;
      
      public static const V_DOWN:uint = 128;
      
      public static const viewPort:Rectangle = new Rectangle();
      
      protected static const FLIP_VALUE:uint = LEFT_DOWN | RIGHT_UP | H_RIGHT;
      
      public const display:AnimDisplay = new AnimDisplay();
      
      public const animClip:AnimClip = new AnimClip();
      
      public var kind:String;
      
      public var size:uint;
      
      public var iconX:int;
      
      public var iconY:int;
      
      public var direction:uint = 1;
      
      protected var animHash:Object;
      
      private var useViewTest:Boolean = true;
      
      public function AnimObject()
      {
         super();
         this.display.animObj = this;
         this.display.add(this.animClip);
      }
      
      public function applyKind(param1:String, param2:uint = 1, param3:String = null) : void
      {
         if(!param1)
         {
            throw new Error("Unit: not null kind");
         }
         if(!param3)
         {
            param3 = param1;
         }
         this.animHash = AnimClip.resourceProxy.animHash[param3];
         if(!this.animHash)
         {
            throw new Error("Unit: bad anim kind " + param3);
         }
         this.kind = param1;
         this.size = this.animHash["_SIZE_"];
         this.direction = param2;
      }
      
      public function dispose() : void
      {
         this.display.dispose();
      }
      
      public function getAnimSufix() : String
      {
         if(this.direction == RIGHT_DOWN || this.direction == LEFT_DOWN)
         {
            return "";
         }
         if(this.direction == LEFT_UP || this.direction == RIGHT_UP)
         {
            return "_lu";
         }
         if(this.direction == H_LEFT || this.direction == H_RIGHT)
         {
            return "_hl";
         }
         if(this.direction == V_DOWN)
         {
            return "_vd";
         }
         if(this.direction == V_UP)
         {
            return "_vu";
         }
         return "";
      }
      
      protected function changeAnimation(param1:Object) : Animation
      {
         var _loc2_:Animation = null;
         this.animClip.isFlip = (this.direction & FLIP_VALUE) != 0;
         if(param1 is String)
         {
            _loc2_ = this.animHash[String(param1) + this.getAnimSufix()] as Animation;
         }
         else
         {
            _loc2_ = param1 as Animation;
         }
         if(this.animClip.animation != _loc2_)
         {
            if(_loc2_)
            {
               this.display.changeViewRect(_loc2_.viewRect);
            }
            else
            {
               this.animClip.stop();
               this.animClip.animation = null;
               this.display.changeViewRect(null);
            }
            this.syncIconPos(_loc2_);
         }
         return _loc2_;
      }
      
      public function getAnimation(param1:String, param2:Boolean = true) : Animation
      {
         if(param2)
         {
            param1 += this.getAnimSufix();
         }
         return this.animHash[param1] as Animation;
      }
      
      public function playAnim(param1:Object, param2:Boolean = false, param3:uint = 0) : void
      {
         this.animClip.play(this.changeAnimation(param1),param2,param3);
      }
      
      public function goAnim(param1:Object, param2:uint = 0) : void
      {
         this.animClip.go(this.changeAnimation(param1),param2);
      }
      
      protected function syncIconPos(param1:Animation) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.testViewRect();
         if(param1)
         {
            _loc2_ = this.animClip.isFlip ? int(-param1.iconX) : param1.iconX;
            _loc3_ = param1.iconY;
            if(_loc2_ != this.iconX || _loc3_ != this.iconY)
            {
               this.iconX = _loc2_;
               this.iconY = _loc3_;
               return true;
            }
            return false;
         }
         return false;
      }
      
      public function stand() : void
      {
         this.playAnim("stand",true);
      }
      
      public function testViewRect() : void
      {
         var _loc3_:Number = NaN;
         if(!this.useViewTest)
         {
            return;
         }
         var _loc1_:Boolean = true;
         var _loc2_:Rectangle = this.display.viewRect;
         if(Boolean(_loc2_) && Boolean(_loc2_.width > 0) && _loc2_.height > 0)
         {
            _loc3_ = this.display.y;
            if(_loc3_ + _loc2_.bottom <= viewPort.top || _loc3_ + _loc2_.top >= viewPort.bottom)
            {
               _loc1_ = false;
            }
            else
            {
               _loc3_ = this.display.x;
               if(this.animClip.isFlip)
               {
                  if(_loc3_ - _loc2_.left <= viewPort.left || _loc3_ - _loc2_.right >= viewPort.right)
                  {
                     _loc1_ = false;
                  }
               }
               else if(_loc3_ + _loc2_.right <= viewPort.left || _loc3_ + _loc2_.left >= viewPort.right)
               {
                  _loc1_ = false;
               }
            }
         }
         else
         {
            _loc1_ = viewPort.contains(this.display.x,this.display.y);
         }
         if(_loc1_ != this.display.visible)
         {
            this.changeDisplayVisible(_loc1_);
         }
      }
      
      protected function changeDisplayVisible(param1:Boolean) : void
      {
         this.display.visible = param1;
      }
      
      public function toString() : String
      {
         return this.kind + "," + (this.animClip.animation ? this.animClip.animation.name : "-");
      }
      
      public function configViewRect(param1:Boolean, param2:Boolean = true) : void
      {
         if(this.useViewTest != param1)
         {
            this.useViewTest = param1;
            if(param1)
            {
               this.testViewRect();
            }
            else if(param2 != this.display.visible)
            {
               this.changeDisplayVisible(param2);
            }
         }
      }
      
      public function checkHit(param1:Number, param2:Number) : Boolean
      {
         return this.animClip.checkHit(param1,param2);
      }
      
      public function setShadow(param1:String, param2:uint = 0) : void
      {
         var _loc3_:Animation = this.animHash[param1 + "_sh"];
         if(_loc3_)
         {
            this.getShadow().go(_loc3_,param2);
         }
         else
         {
            this.removeShadow();
         }
      }
      
      public function getShadow() : AnimClip
      {
         var _loc1_:AnimClip = this.display.getClip("shadow");
         if(!_loc1_)
         {
            _loc1_ = new AnimClip();
            _loc1_.name = "shadow";
            this.display.add(_loc1_,AnimDisplay.INSIDE,0);
         }
         return _loc1_;
      }
      
      public function removeShadow() : void
      {
         this.display.removeByName("shadow");
      }
   }
}

