package engine.display
{
   import engine.data.LinkedList;
   import engine.signal.Signal;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import logic.CoreLogic;
   import model.ResourceProxy;
   import ui.vbase.VEvent;
   
   public class AnimClip extends Sprite
   {
      
      public static var resourceProxy:ResourceProxy;
      
      public static var playList:LinkedList;
      
      public var animation:Animation;
      
      public var endHandler:Function;
      
      public var isFlip:Boolean;
      
      protected var frameIndex:uint;
      
      protected var frameEnd:uint;
      
      protected var libStatus:uint;
      
      protected var isPause:Boolean;
      
      protected var isReverse:Boolean;
      
      protected var isSimulate:Boolean;
      
      private const signal:Signal = new Signal();
      
      public function AnimClip()
      {
         super();
         mouseEnabled = mouseChildren = false;
         this.signal.endTime = Number.MAX_VALUE;
      }
      
      public function forceUpdate() : void
      {
         if(this.libStatus == 1 && this.isSimulate && Boolean(this.animation))
         {
            if(this.animation.frameNum == 1)
            {
               resourceProxy.createFrame(this,this.animation.frame,this.isFlip,true);
            }
            else
            {
               resourceProxy.createFrame(this,this.animation.frames[this.frameIndex],this.isFlip,true);
            }
         }
      }
      
      public function setSimulate(param1:Boolean) : void
      {
         if(param1 != this.isSimulate)
         {
            this.isSimulate = param1;
            if(param1)
            {
               if(this.animation)
               {
                  if(this.signal.handler == this.startPlayDelay || this.signal.handler == this.endFrame)
                  {
                     this.runSignal(false);
                  }
                  else
                  {
                     this.applyAnimation();
                  }
               }
            }
            else
            {
               this.signal.stopWithoutHandler();
            }
         }
      }
      
      public function getNextFrameIndex() : uint
      {
         var _loc1_:uint = 0;
         if(this.animation)
         {
            _loc1_ = this.frameIndex + 1;
            return _loc1_ >= this.animation.frameNum ? 0 : _loc1_;
         }
         return 0;
      }
      
      private function assignAnimation(param1:Animation, param2:uint, param3:uint = 10000) : void
      {
         var _loc4_:uint = param1.frameNum;
         if(param2 >= _loc4_)
         {
            param2 = 0;
         }
         if(this.animation != param1)
         {
            if(this.libStatus == 2 && this.animation.lib != param1.lib)
            {
               this.libStatus = 0;
               resourceProxy.setLoadLibListener(this.animation,this.onLibLoaded,false);
            }
            if(this.libStatus != 2)
            {
               this.libStatus = param1.lib.loadMode == Library.FULL ? 1 : 0;
            }
            this.animation = param1;
         }
         this.frameIndex = param2;
         if(param3 != 10000)
         {
            this.frameEnd = param3 >= _loc4_ ? uint(_loc4_ - 1) : param3;
         }
         else
         {
            this.frameEnd = param2 > 0 ? uint(param2 - 1) : uint(_loc4_ - 1);
         }
      }
      
      public function go(param1:Animation = null, param2:uint = 0) : void
      {
         if(param1)
         {
            this.assignAnimation(param1,param2);
            this.signal.handler = null;
            this.applyAnimation();
         }
      }
      
      public function go_to(param1:uint) : void
      {
         if(Boolean(this.animation) && param1 < this.animation.frameNum)
         {
            this.signal.handler = null;
            this.frameIndex = param1;
            this.applyAnimation();
         }
      }
      
      public function range(param1:Animation, param2:uint, param3:uint, param4:Boolean = false) : void
      {
         if(param1)
         {
            this.assignAnimation(param1,param2,param3);
            this.isReverse = param4;
            this.signal.handler = this.nextFrame;
            this.applyAnimation();
         }
      }
      
      public function play(param1:Animation = null, param2:Boolean = false, param3:uint = 0) : void
      {
         if(param1)
         {
            this.assignAnimation(param1,param3);
            this.isReverse = false;
            this.signal.handler = param2 ? this.nextLoopFrame : this.nextFrame;
            this.applyAnimation();
         }
      }
      
      public function playDelay(param1:Animation, param2:Number, param3:Boolean = false, param4:uint = 0) : void
      {
         if(param1)
         {
            this.assignAnimation(param1,param4);
            if(this.libStatus == 2)
            {
               this.libStatus = 0;
               resourceProxy.setLoadLibListener(this.animation,this.onLibLoaded,false);
            }
            this.isReverse = false;
            this.signal.data = param3;
            this.signal.delay = param2;
            this.signal.handler = this.startPlayDelay;
            this.runSignal();
         }
      }
      
      private function startPlayDelay() : void
      {
         this.signal.handler = this.signal.data ? this.nextLoopFrame : this.nextFrame;
         this.applyAnimation();
      }
      
      private function applyAnimation() : void
      {
         if(!this.isSimulate)
         {
            this.signal.stopWithoutHandler();
            return;
         }
         if(this.libStatus != 1)
         {
            if(this.animation.lib.loadMode == Library.FULL)
            {
               this.libStatus = 1;
            }
            else if(this.libStatus != 2 && this.animation.lib.loadMode != Library.BAD)
            {
               this.libStatus = 2;
               resourceProxy.setLoadLibListener(this.animation,this.onLibLoaded,true);
               resourceProxy.load(this.animation.lib);
            }
         }
         if(this.libStatus == 1)
         {
            if(this.animation.frameNum == 1)
            {
               resourceProxy.createFrame(this,this.animation.frame,this.isFlip,true);
            }
            else
            {
               if(this.isFlip)
               {
                  if(!this.animation.isFlipCache)
                  {
                     this.animation.isFlipCache = true;
                     resourceProxy.cacheFrames(this.animation.frames,this.isFlip);
                  }
               }
               else if(!this.animation.isCache)
               {
                  this.animation.isCache = true;
                  resourceProxy.cacheFrames(this.animation.frames,this.isFlip);
               }
               if(!this.isPause && this.signal.handler != null)
               {
                  this.signal.delay = this.animation.frameDelay;
                  this.runSignal();
                  this.signal.handler();
                  return;
               }
               resourceProxy.createFrame(this,this.animation.frames[this.frameIndex],this.isFlip,true);
            }
         }
         if(this.endHandler != null && this.signal.handler == this.nextFrame && !this.isPause && this.libStatus != 2)
         {
            this.signal.handler = this.endFrame;
            this.signal.delay = this.animation.frameDelay;
            this.runSignal();
         }
         else
         {
            this.signal.stopWithoutHandler();
         }
      }
      
      private function runSignal(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.signal.handlerTime = CoreLogic.getSignalTime(true) + this.signal.delay;
         }
         if(!this.signal.list)
         {
            this.signal.list = playList;
            playList.add(this.signal);
         }
      }
      
      public function stop() : void
      {
         if(this.libStatus == 2)
         {
            this.libStatus = 0;
            resourceProxy.setLoadLibListener(this.animation,this.onLibLoaded,false);
         }
         this.signal.stopWithoutHandler();
         this.signal.handler = null;
      }
      
      public function clear() : void
      {
         this.stop();
         this.animation = null;
         resourceProxy.clearFrame(this);
      }
      
      public function weakClear() : void
      {
         if(this.animation)
         {
            this.stop();
            this.animation = null;
         }
      }
      
      public function set pause(param1:Boolean) : void
      {
         if(param1 != this.isPause)
         {
            this.isPause = param1;
            if(this.isSimulate)
            {
               if(param1)
               {
                  this.signal.stopWithoutHandler();
               }
               else if(this.signal.handler == this.startPlayDelay || this.signal.handler == this.endFrame)
               {
                  this.runSignal(false);
               }
               else if(this.signal.handler != null && this.libStatus == 1)
               {
                  this.applyAnimation();
               }
            }
         }
      }
      
      private function onLibLoaded(param1:VEvent) : void
      {
         resourceProxy.setLoadLibListener(this.animation,this.onLibLoaded,false);
         if(this.animation.lib.loadMode == Library.FULL)
         {
            this.libStatus = 1;
            this.applyAnimation();
         }
         else
         {
            this.libStatus = 0;
            this.signal.handler = null;
         }
      }
      
      protected function nextFrame() : void
      {
         resourceProxy.createFrame(this,this.animation.frames[this.frameIndex],this.isFlip);
         if(this.frameIndex == this.frameEnd)
         {
            this.signal.handler = this.endFrame;
         }
         else if(this.isReverse)
         {
            if(this.frameIndex == 0)
            {
               this.frameIndex = this.frameEnd;
            }
            else
            {
               --this.frameIndex;
            }
         }
         else
         {
            ++this.frameIndex;
            if(this.frameIndex == this.animation.frameNum)
            {
               this.frameIndex = 0;
            }
         }
      }
      
      protected function nextLoopFrame() : void
      {
         resourceProxy.createFrame(this,this.animation.frames[this.frameIndex],this.isFlip);
         if(this.isReverse)
         {
            if(this.frameIndex == 0)
            {
               this.frameIndex = this.frameEnd;
            }
            else
            {
               --this.frameIndex;
            }
         }
         else
         {
            ++this.frameIndex;
            if(this.frameIndex == this.animation.frameNum)
            {
               this.frameIndex = 0;
            }
         }
      }
      
      protected function endFrame() : void
      {
         this.stop();
         if(this.endHandler != null)
         {
            this.endHandler();
         }
      }
      
      public function checkHit(param1:Number, param2:Number) : Boolean
      {
         var _loc4_:RBitmap = null;
         var _loc3_:* = int(numChildren - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = getChildAt(_loc3_) as RBitmap;
            if(param1 >= _loc4_.x && param1 < _loc4_.x + _loc4_.width && param2 >= _loc4_.y && param2 < _loc4_.y + _loc4_.height)
            {
               if((_loc4_.bitmapData.getPixel32(param1 - _loc4_.x,param2 - _loc4_.y) >> 24 & 0xFF) != 0)
               {
                  return true;
               }
            }
            _loc3_--;
         }
         return false;
      }
      
      public function unionViewRect(param1:Rectangle) : void
      {
         var _loc2_:Rectangle = null;
         if(this.animation)
         {
            _loc2_ = this.animation.viewRect;
            if(_loc2_.left < param1.left)
            {
               param1.left = _loc2_.left;
            }
            if(_loc2_.top < param1.top)
            {
               param1.top = _loc2_.top;
            }
            if(_loc2_.right > param1.right)
            {
               param1.right = _loc2_.right;
            }
            if(_loc2_.bottom > param1.bottom)
            {
               param1.bottom = _loc2_.bottom;
            }
         }
      }
      
      public function removeFromParent() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function useCommonTime() : void
      {
         if(this.signal.list == playList)
         {
            playList.remove(this.signal);
            this.signal.run(0,Number.MAX_VALUE);
         }
      }
      
      protected function getPlaySignal() : Signal
      {
         return this.signal;
      }
   }
}

