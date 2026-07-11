package engine.units
{
   import engine.display.AnimClip;
   import engine.display.Animation;
   import engine.display.EffectClip;
   import engine.signal.Signal;
   import engine.signal.Tween;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   
   public class Rocket extends AnimClip
   {
      
      private static var cacheHead:Rocket;
      
      public static const BOOM:uint = 1;
      
      public static const PRE_ROTATE:uint = 2;
      
      public static const TRACK:uint = 4;
      
      public static const AUDIO_HIT:uint = 8;
      
      public static const MASK:uint = 16;
      
      public static const SKIP:uint = 32;
      
      private static const blurFilter:Array = [new BlurFilter(2,2)];
      
      public var target:Unit;
      
      public var targetIconFactor:Number = 1;
      
      private var distanceX:Number;
      
      private var distanceY:Number;
      
      private var startX:Number;
      
      private var startY:Number;
      
      private var flightH:Number;
      
      private var isParabola:Boolean;
      
      private var startAngle:Number;
      
      private var centerAngle:Number;
      
      private var startDelta:Number;
      
      private var centerDelta:Number;
      
      private var mode:uint;
      
      private var isTrack:Boolean;
      
      private var trackAnimation:Animation;
      
      private var trackTime:Number;
      
      private var koef:Number;
      
      private var newX:Number;
      
      private var newY:Number;
      
      private var maskShape:Shape;
      
      private var link:Rocket;
      
      private var animHash:Object;
      
      private var isFilter:Boolean;
      
      private var areaShape:Shape;
      
      private const signal:Signal;
      
      public function Rocket()
      {
         this.signal = new Signal(this.onSignal);
         super();
         this.signal.delay = 0.03;
      }
      
      public static function clear() : void
      {
         var _loc1_:Rocket = null;
         while(cacheHead)
         {
            _loc1_ = cacheHead;
            cacheHead = _loc1_.link;
            _loc1_.link = null;
         }
      }
      
      public static function create(param1:String, param2:uint) : Rocket
      {
         var _loc3_:Rocket = null;
         if(cacheHead)
         {
            _loc3_ = cacheHead;
            cacheHead = _loc3_.link;
            _loc3_.link = null;
         }
         else
         {
            _loc3_ = new Rocket();
            _loc3_.isSimulate = true;
         }
         _loc3_.animHash = resourceProxy.animHash[param1];
         _loc3_.isTrack = (param2 & TRACK) != 0;
         if(_loc3_.isTrack)
         {
            _loc3_.trackAnimation = resourceProxy.getAnimation(param1,"track");
            if(!_loc3_.trackAnimation)
            {
               _loc3_.isTrack = false;
            }
         }
         _loc3_.mode = param2;
         Facade.board.effectPanel.addChild(_loc3_);
         return _loc3_;
      }
      
      public function flight(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number = 0) : void
      {
         play(this.animHash["core"],true);
         if(!this.isFilter && Facade.isNormalQuality)
         {
            this.isFilter = true;
            filters = blurFilter;
         }
         this.startX = x = param1;
         this.startY = y = param2;
         this.distanceX = param3 - param1;
         this.distanceY = param4 - param2;
         if(param6 > 0)
         {
            this.isParabola = true;
            this.flightH = Math.sqrt(this.distanceX * this.distanceX + this.distanceY * this.distanceY) * param6;
            this.newX = param1 + this.distanceX / 2;
            this.newY = param2 + this.distanceY / 2 - this.flightH * 2;
            this.centerDelta = 180 / Math.PI;
            this.startAngle = 90 + Math.atan((this.newY - param2) / (this.newX - param1)) * this.centerDelta;
            this.centerAngle = 90 + Math.atan(this.distanceY / this.distanceX) * this.centerDelta;
            this.koef = 90 + Math.atan((param4 - this.newY) / (param3 - this.newX)) * this.centerDelta;
            if(param3 < param1)
            {
               this.startAngle += 180;
               this.centerAngle += 180;
               this.koef += 180;
            }
            this.startDelta = this.centerAngle - this.startAngle;
            this.centerDelta = this.koef - this.centerAngle;
            rotation = this.startAngle;
         }
         else
         {
            this.isParabola = false;
            if((this.mode & PRE_ROTATE) != 0)
            {
               rotation = (param3 < param1 ? 270 : 90) + Math.atan(this.distanceY / this.distanceX) * 180 / Math.PI;
            }
         }
         this.signal.run(param5,0,false,true);
         if(this.isTrack)
         {
            this.trackTime = this.signal.handlerTime;
         }
      }
      
      private function onSignal() : void
      {
         this.koef = this.signal.passedRate;
         if(this.target)
         {
            this.newX = this.startX + (this.target.display.x - this.startX) * this.koef;
            this.newY = this.startY + (this.target.display.y + this.target.iconY * this.targetIconFactor - this.startY) * this.koef;
         }
         else
         {
            this.newX = this.startX + this.distanceX * this.koef;
            this.newY = this.startY + this.distanceY * this.koef;
         }
         if(this.isParabola)
         {
            this.koef *= 2;
            if(this.koef <= 1)
            {
               rotation = this.startAngle + this.startDelta * this.koef;
            }
            else
            {
               rotation = this.centerAngle + this.centerDelta * (this.koef - 1);
            }
            this.koef = 1 - this.koef;
            this.newY -= (1 - this.koef * this.koef) * this.flightH;
         }
         x = this.newX;
         y = this.newY;
         if(this.signal.tail == 0)
         {
            if((this.mode & BOOM) != 0 && Facade.isNormalQuality)
            {
               this.useBoomEffect();
            }
            else
            {
               this.end();
               if((this.mode & AUDIO_HIT) != 0)
               {
                  Facade.audioProxy.play("cn_ballista_hit");
               }
            }
         }
         else if(this.isTrack)
         {
            if(this.signal.handlerTime > this.trackTime)
            {
               this.useTrackEffect(this.newX,this.newY);
               this.trackTime = this.signal.handlerTime + 0.2;
            }
         }
      }
      
      private function useBoomEffect() : void
      {
         var _loc1_:Animation = this.animHash["boom"];
         if(_loc1_)
         {
            resourceProxy.clearFrame(this);
            rotation = 0;
            endHandler = this.end;
            play(_loc1_);
            if((this.mode & AUDIO_HIT) != 0)
            {
               Facade.audioProxy.play("cn_mortar_hit");
            }
            else
            {
               Facade.audioProxy.play("explosion");
            }
            if(this.areaShape)
            {
               Tween.createRef(this.areaShape).play(["alpha",1,0],0.6);
            }
         }
         else
         {
            this.end();
         }
      }
      
      public function end() : void
      {
         this.clear();
         this.link = cacheHead;
         cacheHead = this;
      }
      
      override public function clear() : void
      {
         this.target = null;
         endHandler = null;
         stop();
         this.signal.stopWithoutHandler();
         if(parent)
         {
            parent.removeChild(this);
         }
         if(mask)
         {
            if(this.maskShape.parent)
            {
               this.maskShape.parent.removeChild(this.maskShape);
            }
            mask = null;
            this.signal.handler = this.onSignal;
         }
         if(this.areaShape)
         {
            Tween.stopRef(this.areaShape);
            this.areaShape.parent.removeChild(this.areaShape);
            this.areaShape = null;
         }
      }
      
      private function useTrackEffect(param1:Number, param2:Number) : void
      {
         var _loc3_:EffectClip = null;
         _loc3_ = EffectClip.create();
         _loc3_.x = param1;
         _loc3_.y = param2;
         parent.addChildAt(_loc3_,0);
         _loc3_.play(this.trackAnimation);
      }
      
      public function radiant(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc6_:Animation = null;
         var _loc7_:EffectClip = null;
         play(this.animHash["core"],true);
         if(this.isFilter)
         {
            this.isFilter = false;
            filters = null;
         }
         this.distanceX = param3 - param1;
         this.distanceY = param4 - param2;
         if(!this.maskShape)
         {
            this.maskShape = new Shape();
         }
         this.maskShape.graphics.clear();
         this.maskShape.graphics.beginFill(0,0.4);
         this.maskShape.graphics.drawCircle(Math.round(this.distanceX / 2),Math.round(this.distanceY / 2),Math.sqrt(this.distanceX * this.distanceX + this.distanceY * this.distanceY) / 2);
         this.maskShape.x = x = param1;
         this.maskShape.y = y = param2;
         mask = this.maskShape;
         if((this.mode & PRE_ROTATE) != 0)
         {
            rotation = (param3 < param1 ? 90 : 270) + Math.atan(this.distanceY / this.distanceX) * 180 / Math.PI;
         }
         parent.addChild(this.maskShape);
         this.signal.handler = this.end;
         this.signal.delayCall(param5,true);
         if((this.mode & BOOM) != 0)
         {
            _loc6_ = this.animHash["boom"];
            if(_loc6_)
            {
               _loc7_ = EffectClip.create();
               _loc7_.x = param3;
               _loc7_.y = param4;
               parent.addChild(_loc7_);
               _loc7_.play(_loc6_);
            }
         }
      }
      
      public function assignArea(param1:Sprite, param2:Number, param3:Number, param4:uint) : void
      {
         this.areaShape = new Shape();
         this.areaShape.scaleY = 0.7071;
         this.areaShape.x = param2;
         this.areaShape.y = param3;
         param1.addChild(this.areaShape);
         RadiusUnit.drawRadius(this.areaShape.graphics,1,param4,0);
         Tween.createRef(this.areaShape).play(["alpha",0,1],0.9);
      }
   }
}

