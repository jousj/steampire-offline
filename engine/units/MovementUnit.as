package engine.units
{
   import engine.Isometric;
   import engine.data.MapCell;
   import engine.data.MoveData;
   import engine.display.AnimClip;
   import engine.display.Animation;
   import engine.signal.Signal;
   import flash.geom.Point;
   
   public class MovementUnit extends Unit
   {
      
      public static const WALK_HASH:Object = {
         "un_motocycle":0.03,
         "un_swarm":0.03,
         "un_builder":[0.03,0.2]
      };
      
      private const startPoint:Point = new Point();
      
      private const w_Point:Point = new Point();
      
      private const posPoint:Point = new Point();
      
      private const signal:Signal;
      
      private var screen_dx:Number;
      
      private var screen_dy:Number;
      
      private var world_dx:Number;
      
      private var world_dy:Number;
      
      private var to_inner_x:Number;
      
      private var to_inner_y:Number;
      
      private var isBreak:Boolean;
      
      private var walkFrameIndex:uint;
      
      private var shadowDirection:uint = 1000;
      
      protected var walkTime:Number;
      
      protected var walkDiagTime:Number;
      
      protected var walkAir:Boolean;
      
      public var preset_inner_x:Number;
      
      public var preset_inner_y:Number;
      
      public var isAllowPhantom:Boolean;
      
      public var isPhantom:Boolean;
      
      public var isIgnoreFence:Boolean;
      
      public function MovementUnit()
      {
         this.signal = new Signal(this.walkHandler);
         super();
         this.to_inner_x = this.preset_inner_x = this.to_inner_y = this.preset_inner_y = POS_WORLD_SIZE / 2;
      }
      
      public function setInnerPos(param1:Number, param2:Number) : void
      {
         this.preset_inner_x = this.to_inner_x = POS_WORLD_SIZE * param1;
         this.preset_inner_y = this.to_inner_y = POS_WORLD_SIZE * param2;
      }
      
      protected function calcMoveData(param1:String, param2:Number) : void
      {
         var _loc4_:Object = null;
         var _loc3_:Animation = animHash["walk"];
         if(!_loc3_)
         {
            throw new Error("не определена анимация перемещения для " + param1);
         }
         if(WALK_HASH.hasOwnProperty(param1))
         {
            _loc4_ = WALK_HASH[param1];
            if(_loc4_ is Array)
            {
               this.signal.delay = _loc4_[0];
               param2 = Number(_loc4_[1]);
            }
            else
            {
               this.signal.delay = Number(_loc4_);
            }
         }
         else
         {
            this.signal.delay = 0.05;
         }
         if(param2 <= 0)
         {
            param2 = 1;
         }
         this.walkTime = param2;
         this.walkDiagTime = param2 * DIAG_K;
      }
      
      override public function updateZSize() : void
      {
         z_x = POS_WORLD_SIZE * b_x + this.to_inner_x;
         z_y = POS_WORLD_SIZE * b_y + this.to_inner_y;
         z_m = z_x + z_y;
      }
      
      public function startWalk(param1:Number, param2:MapCell, param3:Boolean) : void
      {
         var _loc4_:Boolean = false;
         var _loc9_:Animation = null;
         var _loc5_:int = param2.x;
         var _loc6_:int = param2.y;
         if(b_x == _loc5_)
         {
            direction = b_y < _loc6_ ? LEFT_DOWN : RIGHT_UP;
         }
         else if(b_y == _loc6_)
         {
            direction = b_x > _loc5_ ? LEFT_UP : RIGHT_DOWN;
         }
         else
         {
            _loc4_ = true;
            if(_loc5_ > b_x && _loc6_ < b_y)
            {
               direction = H_RIGHT;
            }
            else if(_loc5_ < b_x && _loc6_ > b_y)
            {
               direction = H_LEFT;
            }
            else if(_loc5_ > b_x)
            {
               direction = V_DOWN;
            }
            else
            {
               direction = V_UP;
            }
         }
         this.startPoint.x = display.x;
         this.startPoint.y = display.y;
         this.w_Point.x = z_x;
         this.w_Point.y = z_y;
         this.to_inner_x = this.preset_inner_x;
         this.to_inner_y = this.preset_inner_y;
         var _loc7_:Number = POS_WORLD_SIZE * _loc5_;
         var _loc8_:Number = POS_WORLD_SIZE * _loc6_;
         if(!this.walkAir && param2.walkType > 0 && param2.walkType != 511)
         {
            if(!this.isIgnoreFence || param3 || !(param2.unit is Fence))
            {
               this.searchInnerPos(param2.walkType,_loc7_,_loc8_);
            }
         }
         Isometric.worldToScreen(_loc7_ + this.to_inner_x,_loc8_ + this.to_inner_y,this.posPoint);
         this.screen_dx = this.posPoint.x - this.startPoint.x;
         this.screen_dy = this.posPoint.y - this.startPoint.y;
         this.world_dx = _loc7_ + this.to_inner_x - this.w_Point.x;
         this.world_dy = _loc8_ + this.to_inner_y - this.w_Point.y;
         _loc7_ = Math.sqrt(this.world_dx * this.world_dx + this.world_dy * this.world_dy) / (_loc4_ ? POS_WORLD_DIAG : POS_WORLD_SIZE);
         if(this.signal.handler == this.moveHandler)
         {
            param1 *= _loc7_;
         }
         else
         {
            this.isBreak = _loc7_ < 1;
            if(this.isBreak)
            {
               param1 *= _loc7_;
            }
         }
         if(this.signal.delay > param1)
         {
            this.signal.stop();
            this.signal.duration = param1;
            this.signal.tail = 0;
            this.signal.handler();
         }
         else
         {
            _loc4_ = animClip.isFlip;
            _loc9_ = super.changeAnimation(this.isPhantom ? "phantom" : "walk");
            if(animClip.animation != _loc9_)
            {
               animClip.play(_loc9_,true,this.walkFrameIndex);
               this.syncShadow();
            }
            else if(_loc4_ != animClip.isFlip)
            {
               syncIconPos(_loc9_);
               animClip.forceUpdate();
               this.syncShadow();
            }
            this.signal.run(param1,0,true,true);
         }
      }
      
      public function correctInnerPos(param1:MapCell) : void
      {
         if(!this.walkAir && param1.walkType > 0 && param1.walkType != 511)
         {
            this.searchInnerPos(param1.walkType,POS_WORLD_SIZE * param1.x,POS_WORLD_SIZE * param1.y);
         }
      }
      
      private function searchInnerPos(param1:uint, param2:Number, param3:Number) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         if((param1 & 0x10) == 0)
         {
            _loc6_ = 16;
            if(this.preset_inner_x > POS_WORLD_TWO_THIRD)
            {
               _loc6_ <<= 3;
            }
            else if(this.preset_inner_y < POS_WORLD_ONE_THIRD)
            {
               _loc6_ >>= 3;
            }
            if(this.preset_inner_x > POS_WORLD_TWO_THIRD)
            {
               _loc6_ <<= 1;
            }
            else if(this.preset_inner_y < POS_WORLD_ONE_THIRD)
            {
               _loc6_ >>= 1;
            }
            if((param1 & _loc6_) == 0)
            {
               return;
            }
            _loc7_ = param2 + this.to_inner_x;
            _loc8_ = param3 + this.to_inner_y;
         }
         else
         {
            _loc7_ = z_x;
            _loc8_ = z_y;
         }
         var _loc4_:Number = 1000000;
         _loc6_ = 1;
         var _loc5_:Number = POS_WORLD_ONE_SIXTH;
         while(_loc5_ <= POS_WORLD_SIZE)
         {
            _loc9_ = POS_WORLD_ONE_SIXTH;
            while(_loc9_ <= POS_WORLD_SIZE)
            {
               if((param1 & _loc6_) == 0)
               {
                  _loc10_ = param2 + _loc9_ - _loc7_;
                  if(_loc10_ < 0)
                  {
                     _loc10_ *= -1;
                  }
                  _loc11_ = param3 + _loc5_ - _loc8_;
                  if(_loc11_ < 0)
                  {
                     _loc11_ *= -1;
                  }
                  _loc10_ += _loc11_;
                  if(_loc10_ < _loc4_)
                  {
                     _loc4_ = _loc10_;
                     this.to_inner_x = _loc9_;
                     this.to_inner_y = _loc5_;
                  }
               }
               _loc6_ <<= 1;
               _loc9_ += POS_WORLD_ONE_THIRD;
            }
            _loc5_ += POS_WORLD_ONE_THIRD;
         }
      }
      
      override protected function changeAnimation(param1:Object) : Animation
      {
         this.signal.stop();
         if(this.shadowDirection != direction)
         {
            this.syncShadow();
         }
         return super.changeAnimation(param1);
      }
      
      override public function setGeometry(param1:int, param2:int, param3:Boolean) : void
      {
         if(!param3)
         {
            this.signal.stop();
         }
         super.setGeometry(param1,param2,param3);
      }
      
      override public function syncPosition() : void
      {
         this.signal.stop();
         this.updateZSize();
         board.isNeedZSort = true;
         Isometric.worldToScreen(z_x,z_y,this.posPoint);
         display.setPos(this.posPoint.x,this.posPoint.y);
         testViewRect();
      }
      
      private function walkHandler() : void
      {
         var _loc1_:Number = this.signal.passedRate;
         if(_loc1_ < 1)
         {
            display.setPos(this.startPoint.x + this.screen_dx * _loc1_,this.startPoint.y + this.screen_dy * _loc1_);
            z_x = this.w_Point.x + this.world_dx * _loc1_;
            z_y = this.w_Point.y + this.world_dy * _loc1_;
            z_m = z_x + z_y;
         }
         else
         {
            this.walkFrameIndex = animClip.getNextFrameIndex();
            if(this.isBreak)
            {
               stand();
            }
         }
      }
      
      public function useWalkPath() : void
      {
         this.isBreak = false;
         this.signal.handler = this.moveHandler;
      }
      
      private function moveHandler() : void
      {
         this.walkHandler();
         if(this.signal.tail == 0)
         {
            this.onWalkPath(true);
         }
      }
      
      public function startWalkPath(param1:int, param2:int, param3:Function = null, param4:Boolean = false) : void
      {
         var _loc5_:MoveData = new MoveData();
         _loc5_.endHandler = param3;
         _loc5_.isThisArg = param4;
         Facade.map.findPath(c_x,c_y,param1,param2,_loc5_.pathList,this.walkAir);
         this.signal.data = _loc5_;
         this.onWalkPath(false);
      }
      
      public function startWalkPathEx(param1:MoveData) : void
      {
         this.signal.data = param1;
         this.onWalkPath(false);
      }
      
      public function stopWalk() : void
      {
         this.signal.stop();
         this.signal.data = null;
      }
      
      private function onWalkPath(param1:Boolean) : void
      {
         var _loc3_:MapCell = null;
         var _loc2_:Vector.<MapCell> = (this.signal.data as MoveData).pathList;
         if(param1)
         {
            _loc3_ = _loc2_.shift();
            super.setGeometry(_loc3_.x,_loc3_.y,true);
         }
         if(_loc2_.length > 0)
         {
            _loc3_ = _loc2_[0];
            this.startWalk(c_x == _loc3_.x || c_y == _loc3_.y ? this.walkTime : this.walkDiagTime,_loc3_,_loc2_.length == 1);
         }
         else
         {
            this.signal.stop();
            this.endWalkPath();
         }
      }
      
      private function endWalkPath() : void
      {
         var _loc1_:MoveData = this.signal.data as MoveData;
         if(_loc1_)
         {
            this.signal.data = null;
            if(_loc1_.endHandler != null)
            {
               if(_loc1_.isThisArg)
               {
                  _loc1_.endHandler(this);
               }
               else
               {
                  _loc1_.endHandler();
               }
            }
         }
      }
      
      private function syncShadow() : void
      {
         this.shadowDirection = direction;
         var _loc1_:AnimClip = getShadow();
         _loc1_.isFlip = (this.shadowDirection & FLIP_VALUE) != 0;
         _loc1_.play(animHash["shadow" + getAnimSufix()] as Animation,true);
      }
      
      override public function dispose() : void
      {
         this.signal.stop();
         super.dispose();
      }
   }
}

