package engine.units
{
   import engine.data.CannonEnv;
   import engine.display.AnimClip;
   import engine.display.AnimDisplay;
   import engine.display.Animation;
   import engine.signal.Tween;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import model.ResourceProxy;
   import proto.model.PShopCannon;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   import utils.CommonUtils;
   
   public class Cannon extends RadiusUnit
   {
      
      public static const ENV_HASH:Object = {
         "cn_air":new CannonEnv(false,0,new <uint>[82,0,82,0,88,0],Rocket.BOOM,true),
         "cn_ballista":new CannonEnv(true,2,new <uint>[75,0,77,0,78,0,80,0,79,0,85,0,86,0,84,0,84,0,84,0],Rocket.AUDIO_HIT),
         "cn_cannon":new CannonEnv(true,1,new <uint>[61,37,60,40,63,44,63,45,64,49,64,50,75,52,76,54,78,52,80,52,78,52],Rocket.BOOM,true),
         "cn_flamethrower":new CannonEnv(false,0,new <uint>[109,0],Rocket.BOOM,true),
         "cn_freezing_tower":new CannonEnv(false,0,new <uint>[108,0],Rocket.BOOM,true),
         "cn_gauss_cannon":new CannonEnv(true,1,new <uint>[62,33,62,37,64,48,64,55,65,56,66,57,66,62],Rocket.BOOM,true),
         "cn_mortar":new CannonEnv(true,1,new <uint>[69,12,69,12,69,12,71,12,71,12,75,12,75,12],Rocket.BOOM | Rocket.TRACK | Rocket.AUDIO_HIT,true),
         "cn_steam_tower":new CannonEnv(true,1,new <uint>[56,33,57,38,57,38,57,38,60,53,60,54,61,61],Rocket.BOOM | Rocket.PRE_ROTATE),
         "cn_tesla_coil":new CannonEnv(false,0,new <uint>[106,0,114,0,116,0,116,0,116,0,119,0,123,0,124,0],Rocket.BOOM | Rocket.PRE_ROTATE | Rocket.MASK),
         "cn_dwarf_tower":new CannonEnv(false,2,new <uint>[111,0],Rocket.SKIP),
         "cn_magnetic_tower":new CannonEnv(false,0,new <uint>[90,0,90,0,90,0,98,0,98,0,98,0,102,0,104,0,112,0],Rocket.BOOM | Rocket.SKIP,true)
      };
      
      public var shop:PShopCannon;
      
      public var isPylon:Boolean = true;
      
      public var env:CannonEnv;
      
      public var barrelY:Number;
      
      public var barrelRadius:Number;
      
      public var skipPylonAnim:Boolean;
      
      public var barrelPoint:Point;
      
      private var angle:Number = 0;
      
      private var rotateIndex:uint;
      
      private var matrix:Matrix = new Matrix();
      
      private var isBadMatrix:Boolean = true;
      
      private var reboundTween:Tween;
      
      private var standAnimation:Animation;
      
      private var attackAnimation:Animation;
      
      private var isNoPylonStatus:Boolean;
      
      public function Cannon(param1:PShopCannon, param2:uint)
      {
         super();
         applyKind(param1.sc_kind);
         this.updateMax = param2;
         this.env = ENV_HASH[param1.sc_kind] as CannonEnv;
         if(!this.env)
         {
            throw new Error("don\'t cannonEnv " + param1.sc_kind);
         }
         if(this.env.isRotate)
         {
            this.rotateIndex = CommonUtils.getRangeRandom(0,23);
         }
         this.assignShop(param1);
         animClip.endHandler = this.onAnimEnd;
      }
      
      public static function init(param1:Array) : void
      {
         var _loc3_:PShopCannon = null;
         var _loc4_:CannonEnv = null;
         var _loc5_:Animation = null;
         var _loc2_:ResourceProxy = AnimClip.resourceProxy;
         for each(_loc3_ in param1)
         {
            if(_loc3_.sc_attack_time > 0)
            {
               _loc4_ = ENV_HASH[_loc3_.sc_kind];
               if((Boolean(_loc4_)) && _loc4_.isRotate)
               {
                  _loc5_ = _loc2_.getAnimation(_loc3_.sc_kind,"level" + _loc3_.sc_model_level);
                  if((Boolean(_loc5_)) && _loc5_.frameNum == 24)
                  {
                     _loc5_.frameDelay = _loc3_.sc_attack_time / 23000;
                  }
               }
            }
         }
      }
      
      private function onAnimEnd() : void
      {
         if(animClip.animation == this.attackAnimation)
         {
            this.stand();
         }
      }
      
      public function assignShop(param1:PShopCannon) : void
      {
         animClip.weakClear();
         this.shop = param1;
         level = param1.sc_level;
         stamina = param1.sc_stamina;
         armor = param1.sc_armor;
         var _loc2_:uint = uint(param1.sc_model_level - 1 << 1);
         if(_loc2_ >= this.env.barrelList.length)
         {
            _loc2_ = this.env.barrelList.length - 2;
         }
         this.barrelY = this.env.barrelList[_loc2_];
         this.barrelRadius = this.env.barrelList[_loc2_ + 1];
         this.standAnimation = animHash["level" + param1.sc_model_level] as Animation;
         if(this.env.attackType == 2)
         {
            this.attackAnimation = animHash[this.standAnimation.name + "_attack"];
         }
         boomList = boomHash[kind + this.standAnimation.name];
      }
      
      public function setPylon(param1:Boolean) : void
      {
         if(this.isPylon != param1)
         {
            this.isPylon = param1;
            if(animClip.animation)
            {
               Facade.audioProxy.play("disconnect_gun");
               this.stand();
            }
         }
      }
      
      override public function stand() : void
      {
         if(!this.isPylon != this.isNoPylonStatus)
         {
            this.isNoPylonStatus = !this.isPylon;
            if(this.isPylon)
            {
               setStatus(null);
            }
            else
            {
               setStatus(SkinManager.getEmbed("NoPylonStatus",VSkin.CACHE_AS_BITMAP));
            }
         }
         var _loc1_:Boolean = !animClip.animation;
         var _loc2_:Boolean = this.isNoPylonStatus && !this.skipPylonAnim && updateLevel == 0;
         if(this.env.isRotate)
         {
            this.setBaseVisible(!_loc2_,_loc1_);
         }
         if(_loc2_)
         {
            goAnim(this.standAnimation.name + "_break");
            if(!animClip.animation)
            {
               _loc2_ = false;
            }
         }
         if(!_loc2_)
         {
            changeAnimation(this.standAnimation);
            if(this.env.isRotate)
            {
               animClip.go(this.standAnimation,this.rotateIndex);
            }
            else
            {
               animClip.play(this.standAnimation,true);
            }
         }
         if(_loc1_)
         {
            if(updateLevel > 0)
            {
               scaffolding(true);
            }
            changeTile(this.standAnimation.name,"tl_cannon");
            setShadow(this.standAnimation.name);
         }
      }
      
      private function setBaseVisible(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:AnimClip = display.getClip("base");
         if(param1)
         {
            if(_loc3_)
            {
               _loc3_.visible = true;
            }
            else
            {
               _loc3_ = display.addNew("base",AnimDisplay.SCENE,0);
            }
         }
         else if(_loc3_)
         {
            _loc3_.visible = false;
         }
         if(Boolean(_loc3_) && (param2 || param1 && !_loc3_.animation))
         {
            _loc3_.go(animHash[this.standAnimation.name + "_b"]);
         }
      }
      
      override public function toString() : String
      {
         return kind + "," + level + "[" + id + "]";
      }
      
      public function motionAngle(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
      {
         param1 += this.angle;
         if(param1 >= 360)
         {
            param1 %= 360;
         }
         else if(param1 < 0)
         {
            param1 = 360 - -param1 % 360;
         }
         this.rotate(param1,param3,param2);
      }
      
      public function rotate(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(!param2)
         {
            param1 = param1 <= 315 ? param1 + 45 : param1 - 315;
         }
         if(param1 < 0 || param1 > 360)
         {
            throw new Error("bad cannon rotate angle=" + param1);
         }
         if(param1 > 0)
         {
            param1 = param1 > 7.5 ? param1 - 7.5 : 360 - param1;
         }
         this.angle = param1;
         if(!this.env.isRotate || !this.standAnimation)
         {
            return;
         }
         changeAnimation(this.standAnimation);
         var _loc4_:uint = 24 - uint(param1 / 15) - 1;
         if(_loc4_ != this.rotateIndex)
         {
            this.isBadMatrix = true;
            if(display.visible && !param3)
            {
               if(_loc4_ > this.rotateIndex)
               {
                  _loc5_ = _loc4_ - this.rotateIndex;
                  _loc6_ = 24 - _loc5_;
               }
               else
               {
                  _loc6_ = this.rotateIndex - _loc4_;
                  _loc5_ = 24 - _loc6_;
               }
               animClip.range(this.standAnimation,this.rotateIndex,_loc4_,_loc6_ < _loc5_);
               this.rotateIndex = _loc4_;
               return;
            }
            this.rotateIndex = _loc4_;
         }
         animClip.go(this.standAnimation,_loc4_);
      }
      
      private function calcMatrix() : void
      {
         this.isBadMatrix = false;
         this.matrix.identity();
         this.matrix.rotate(Math.ceil(this.angle / 15) * 15 * 0.017453292);
         this.matrix.scale(1,0.7071);
      }
      
      public function calcBarrelPoint() : void
      {
         if(this.barrelRadius > 0)
         {
            if(this.isBadMatrix)
            {
               this.calcMatrix();
               if(!this.barrelPoint)
               {
                  this.barrelPoint = new Point();
               }
               else
               {
                  this.barrelPoint.x = 0;
               }
               this.barrelPoint.y = -this.barrelRadius;
               this.barrelPoint = this.matrix.transformPoint(this.barrelPoint);
               this.barrelPoint.y -= this.barrelY;
            }
         }
         else if(!this.barrelPoint)
         {
            this.barrelPoint = new Point(0,-this.barrelY);
         }
      }
      
      override public function dispose() : void
      {
         if(this.reboundTween)
         {
            this.reboundTween.stop();
            this.reboundTween = null;
         }
         super.dispose();
      }
      
      private function reboundEffect() : void
      {
         var _loc1_:Point = this.matrix.transformPoint(new Point(0,-8));
         if(this.reboundTween)
         {
            this.reboundTween.step = 0;
            this.reboundTween.stop();
         }
         else
         {
            this.reboundTween = new Tween(animClip,this.reboundHandler,true);
         }
         this.reboundTween.data = _loc1_;
         this.reboundTween.play(["x",0,-_loc1_.x,"y",0,-_loc1_.y],0.1,null,30);
      }
      
      private function reboundHandler(param1:Tween) : void
      {
         var _loc3_:Point = null;
         var _loc2_:Array = param1.propertyList;
         _loc2_[1] = animClip.x;
         _loc2_[4] = animClip.y;
         if(param1.step == 1)
         {
            _loc3_ = param1.data;
            _loc2_[2] = _loc3_.x / 2;
            _loc2_[5] = _loc3_.y / 2;
            param1.data = null;
            param1.duration = 0.15;
            param1.repeat();
         }
         else if(param1.step == 2)
         {
            _loc2_[2] = 0;
            _loc2_[5] = 0;
            param1.duration = 0.1;
            param1.repeat();
         }
         else
         {
            this.reboundTween = null;
         }
      }
      
      public function playAttack() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.env.attackType == 1)
         {
            this.reboundEffect();
         }
         else if(this.env.attackType == 2)
         {
            if(this.attackAnimation)
            {
               changeAnimation(this.attackAnimation);
               _loc1_ = this.attackAnimation.frameNum / 22;
               _loc2_ = (24 - uint(this.angle / 15) - 1) * _loc1_;
               if(_loc1_ == 1)
               {
                  animClip.go(this.attackAnimation,_loc2_);
               }
               else
               {
                  animClip.range(this.attackAnimation,_loc2_,_loc2_ + _loc1_ - 1);
               }
            }
         }
         if(this.env.isBarrelEffect)
         {
            this.barrelEffect();
         }
      }
      
      private function barrelEffect() : void
      {
         var _loc1_:AnimClip = display.getClip("effect");
         if(!_loc1_)
         {
            _loc1_ = new AnimClip();
            _loc1_.name = "effect";
            display.add(_loc1_,AnimDisplay.INSIDE);
            _loc1_.endHandler = this.endBarralEffect;
         }
         this.calcBarrelPoint();
         _loc1_.x = this.barrelPoint.x;
         _loc1_.y = this.barrelPoint.y;
         _loc1_.play(animHash["barrel"]);
      }
      
      private function endBarralEffect() : void
      {
         display.getClip("effect").clear();
      }
      
      public function stopAttack() : void
      {
         var _loc1_:AnimClip = null;
         if(this.env.attackType == 1)
         {
            if(this.reboundTween)
            {
               this.reboundTween.stop();
               animClip.x = animClip.y = 0;
            }
         }
         else if(this.env.attackType == 2)
         {
            this.onAnimEnd();
         }
         if(this.env.isBarrelEffect)
         {
            _loc1_ = display.getClip("effect");
            if(_loc1_)
            {
               _loc1_.clear();
            }
         }
      }
   }
}

