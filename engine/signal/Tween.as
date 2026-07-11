package engine.signal
{
   import flash.utils.Dictionary;
   
   public class Tween extends Signal
   {
      
      public var target:Object;
      
      public var propertyList:Array;
      
      public var completeFunc:Function;
      
      public var easy:Function = liner;
      
      public var step:uint;
      
      public var isSimulate:Boolean;
      
      public var playDelay:Number;
      
      private var isUniqueEasy:Boolean;
      
      public function Tween(param1:Object, param2:Function = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(this.onTween);
         this.target = param1;
         this.completeFunc = param2;
         this.isUniqueEasy = param4;
         this.isSimulate = param3;
         this.playDelay = delay = 0.05;
      }
      
      public static function createRef(param1:Object, param2:Function = null, param3:Boolean = false, param4:Boolean = false) : Tween
      {
         var _loc5_:Signal = null;
         if(!refDict)
         {
            refDict = new Dictionary(true);
         }
         else
         {
            _loc5_ = refDict[param1] as Signal;
         }
         if(Boolean(_loc5_) && !(_loc5_ is Tween))
         {
            _loc5_.stop();
            _loc5_ = null;
         }
         if(!_loc5_)
         {
            _loc5_ = new Tween(param1,param2,param3,param4);
            _loc5_.data = param1;
            _loc5_.stopHandler = onRefStop;
            refDict[param1] = _loc5_;
         }
         return _loc5_ as Tween;
      }
      
      public static function stopRef(param1:Object) : void
      {
         Signal.stopRef(param1);
      }
      
      public static function cyclically(param1:Tween) : void
      {
         param1.repeat();
      }
      
      public static function liner(param1:Number) : Number
      {
         return param1;
      }
      
      public static function cubicIn(param1:Number) : Number
      {
         return param1 * param1 * param1;
      }
      
      public static function cubicOut(param1:Number) : Number
      {
         param1 = 1 - param1;
         return 1 - param1 * param1 * param1;
      }
      
      public static function expoIn(param1:Number) : Number
      {
         return Math.pow(2,10 * (param1 - 1)) - 0.001;
      }
      
      public static function expoOut(param1:Number) : Number
      {
         return 1 - Math.pow(2,-10 * param1);
      }
      
      public static function backIn(param1:Number) : Number
      {
         return param1 * param1 * ((1.70158 + 1) * param1 - 1.70158);
      }
      
      public static function backOut(param1:Number) : Number
      {
         param1--;
         return param1 * param1 * ((1.70158 + 1) * param1 + 1.70158) + 1;
      }
      
      public static function elasticOut(param1:Number) : Number
      {
         return Math.pow(2,-10 * param1) * Math.sin((param1 - 0.075) * 20.943951) + 1;
      }
      
      public static function elasticIn(param1:Number) : Number
      {
         param1--;
         return -(Math.pow(2,10 * param1) * Math.sin((param1 - 0.075) * 20.943951));
      }
      
      public static function sineOut(param1:Number) : Number
      {
         return Math.sin(param1 * 1.5707963267948966);
      }
      
      public static function sineIn(param1:Number) : Number
      {
         return -Math.cos(param1 * 1.5707963267948966) + 1;
      }
      
      public static function bounceOut(param1:Number) : Number
      {
         if(param1 < 1 / 2.75)
         {
            return 7.5625 * param1 * param1;
         }
         if(param1 < 2 / 2.75)
         {
            return 7.5625 * (param1 = param1 - 1.5 / 2.75) * param1 + 0.75;
         }
         if(param1 < 2.5 / 2.75)
         {
            return 7.5625 * (param1 = param1 - 2.25 / 2.75) * param1 + 0.9375;
         }
         return 7.5625 * (param1 = param1 - 2.625 / 2.75) * param1 + 0.984375;
      }
      
      public static function bounceIn(param1:Number) : Number
      {
         param1 = 1 - param1;
         if(param1 < 1 / 2.75)
         {
            return 1 - 7.5625 * param1 * param1;
         }
         if(param1 < 2 / 2.75)
         {
            return 1 - (7.5625 * (param1 = param1 - 1.5 / 2.75) * param1 + 0.75);
         }
         if(param1 < 2.5 / 2.75)
         {
            return 1 - (7.5625 * (param1 = param1 - 2.25 / 2.75) * param1 + 0.9375);
         }
         return 1 - (7.5625 * (param1 = param1 - 2.625 / 2.75) * param1 + 0.984375);
      }
      
      public function repeat() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(Boolean(this.propertyList) && duration > 0)
         {
            _loc1_ = this.isUniqueEasy ? 4 : 3;
            _loc2_ = this.propertyList.length - (_loc1_ - 1);
            while(_loc2_ > 0)
            {
               this.target[this.propertyList[_loc2_ - 1]] = this.propertyList[_loc2_];
               _loc2_ -= _loc1_;
            }
            delay = this.playDelay;
            handler = this.onTween;
            run(duration,0,false,this.isSimulate);
         }
      }
      
      public function revert(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if(Boolean(this.propertyList) && duration > 0)
         {
            _loc2_ = this.isUniqueEasy ? 4 : 3;
            _loc3_ = this.propertyList.length - (_loc2_ - 1);
            while(_loc3_ > 0)
            {
               _loc4_ = Number(this.propertyList[_loc3_ + 1]);
               this.propertyList[_loc3_ + 1] = this.propertyList[_loc3_];
               this.propertyList[_loc3_] = _loc4_;
               if(param1)
               {
                  this.target[this.propertyList[_loc3_ - 1]] = _loc4_;
               }
               _loc3_ -= _loc2_;
            }
            delay = this.playDelay;
            handler = this.onTween;
            run(duration,0,false,this.isSimulate);
         }
      }
      
      public function play(param1:Array, param2:Number, param3:Function = null, param4:Number = 0) : void
      {
         if(param3 == null)
         {
            this.easy = param3 = liner;
         }
         else
         {
            this.easy = param3;
         }
         var _loc5_:uint = param1.length;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc6_ + 2 >= _loc5_ || param1[_loc6_ + 2] is String)
            {
               param1.splice(_loc6_ + 1,0,this.target[param1[_loc6_]]);
               _loc5_++;
            }
            else
            {
               this.target[param1[_loc6_]] = param1[_loc6_ + 1];
            }
            _loc6_ += 3;
            if(this.isUniqueEasy)
            {
               if(_loc6_ >= _loc5_ || param1[_loc6_] is String)
               {
                  param1.splice(_loc6_,0,param3);
                  _loc5_++;
               }
               _loc6_++;
            }
         }
         this.propertyList = param1;
         this.duration = param2;
         if(param4 > 0)
         {
            this.delay = this.playDelay = param4;
         }
         else
         {
            this.delay = this.playDelay;
         }
         handler = this.onTween;
         run(param2,0,false,this.isSimulate);
      }
      
      public function applyStartProperties() : void
      {
         var _loc1_:int = this.isUniqueEasy ? 4 : 3;
         var _loc2_:int = this.propertyList.length - (_loc1_ - 1);
         while(_loc2_ > 0)
         {
            if(this.propertyList[_loc2_] != null)
            {
               this.target[this.propertyList[_loc2_ - 1]] = this.propertyList[_loc2_];
            }
            _loc2_ -= _loc1_;
         }
      }
      
      private function onTween() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Number = passedRate;
         if(this.isUniqueEasy)
         {
            _loc2_ = this.propertyList.length - 3;
            while(_loc2_ > 0)
            {
               this.target[this.propertyList[_loc2_ - 1]] = this.propertyList[_loc2_] + (this.propertyList[_loc2_ + 1] - this.propertyList[_loc2_]) * Function(this.propertyList[_loc2_ + 2])(_loc1_);
               _loc2_ -= 4;
            }
         }
         else
         {
            _loc1_ = this.easy(_loc1_);
            _loc2_ = this.propertyList.length - 2;
            while(_loc2_ > 0)
            {
               this.target[this.propertyList[_loc2_ - 1]] = this.propertyList[_loc2_] + (this.propertyList[_loc2_ + 1] - this.propertyList[_loc2_]) * _loc1_;
               _loc2_ -= 3;
            }
         }
         if(tail == 0)
         {
            this.endStep();
         }
      }
      
      public function wait(param1:Number) : void
      {
         handler = this.endStep;
         delayCall(param1,this.isSimulate);
      }
      
      private function endStep() : void
      {
         ++this.step;
         if(this.completeFunc != null)
         {
            this.completeFunc(this);
         }
      }
   }
}

