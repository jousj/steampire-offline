package ui.vbase
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   
   public class VComponent extends Sprite
   {
      
      public static const SKIP_CONTENT_SIZE:uint = 2147483648;
      
      public static const EMPTY:int = int.MAX_VALUE;
      
      protected static const RULED_LAYOUT:uint = 268435456;
      
      public var left:int = 2147483647;
      
      public var right:int = 2147483647;
      
      public var top:int = 2147483647;
      
      public var bottom:int = 2147483647;
      
      public var vCenter:int = 2147483647;
      
      public var hCenter:int = 2147483647;
      
      public var layoutW:int;
      
      public var layoutH:int;
      
      public var maxW:uint;
      
      public var maxH:uint;
      
      public var minW:uint;
      
      public var minH:uint;
      
      public var isGeometryPhase:Boolean;
      
      public var w:uint;
      
      public var h:uint;
      
      public var validContentSize:Boolean;
      
      private var $dispatcher:EventDispatcher = this as EventDispatcher;
      
      private var listenerList:Vector.<VOListener>;
      
      private var isWaitUpdatePhase:Boolean;
      
      protected var updateW:uint = 4294967295;
      
      protected var updateH:uint;
      
      protected var contentW:uint;
      
      protected var contentH:uint;
      
      protected var mode:uint;
      
      public var hint:Object;
      
      public function VComponent()
      {
         super();
      }
      
      public function getHintData() : Object
      {
         if(this.hint is Function)
         {
            return (this.hint as Function)();
         }
         return this.hint;
      }
      
      public function getMode() : uint
      {
         return this.mode;
      }
      
      public function set dispatcher(param1:EventDispatcher) : void
      {
         this.$dispatcher = param1 ? param1 : this;
      }
      
      public function get dispatcher() : EventDispatcher
      {
         return this.$dispatcher == this || !(this.$dispatcher is VComponent) ? this.$dispatcher : (this.$dispatcher as VComponent).dispatcher;
      }
      
      public function addListener(param1:String, param2:Function, param3:EventDispatcher = null, param4:uint = 0, param5:Boolean = false) : void
      {
         if(!this.listenerList)
         {
            this.listenerList = new Vector.<VOListener>();
         }
         if(!param3)
         {
            param3 = this;
         }
         var _loc6_:VOListener = new VOListener();
         _loc6_.dispatcher = param3;
         _loc6_.type = param1;
         _loc6_.handler = param2;
         _loc6_.useCapture = param5;
         this.listenerList.push(_loc6_);
         param3.addEventListener(param1,param2,param5,param4);
      }
      
      public function removeListener(param1:String, param2:Function = null, param3:EventDispatcher = null, param4:Boolean = false) : void
      {
         var _loc6_:VOListener = null;
         if(!this.listenerList)
         {
            return;
         }
         if(!param3)
         {
            param3 = this;
         }
         var _loc5_:* = int(this.listenerList.length - 1);
         while(_loc5_ >= 0)
         {
            _loc6_ = this.listenerList[_loc5_];
            if(_loc6_.dispatcher == param3 && _loc6_.type == param1 && _loc6_.handler == param2 && _loc6_.useCapture == param4)
            {
               param3.removeEventListener(_loc6_.type,_loc6_.handler,_loc6_.useCapture);
               this.listenerList.splice(_loc5_,1);
            }
            _loc5_--;
         }
         if(this.listenerList.length == 0)
         {
            this.listenerList = null;
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(this.isWaitUpdatePhase && param1)
         {
            this.isWaitUpdatePhase = false;
            this.updatePhase();
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:VOListener = null;
         if(this.listenerList)
         {
            for each(_loc1_ in this.listenerList)
            {
               _loc1_.dispatcher.removeEventListener(_loc1_.type,_loc1_.handler,_loc1_.useCapture);
            }
            this.listenerList = null;
         }
         this.childrenDispose(this);
      }
      
      protected function childrenDispose(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:* = int(param1.numChildren - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            if(_loc3_ is VComponent)
            {
               (_loc3_ as VComponent).dispose();
            }
            else if(_loc3_ is DisplayObjectContainer)
            {
               this.childrenDispose(_loc3_ as DisplayObjectContainer);
            }
            _loc2_--;
         }
      }
      
      public function syncLayout() : void
      {
         var _loc1_:VComponent = null;
         if(parent is VComponent)
         {
            _loc1_ = parent as VComponent;
            if(this.isGeometryPhase && _loc1_.isGeometryPhase)
            {
               _loc1_.syncChildLayout(this);
            }
            else
            {
               this.resetValidContentSize(_loc1_);
            }
         }
         else if(this.isGeometryPhase)
         {
            this.geometryPhase();
         }
      }
      
      protected function syncChildLayout(param1:VComponent) : void
      {
         this.validContentSize = false;
         if(this.isDependentSize && (this.mode & RULED_LAYOUT) == 0)
         {
            param1.isGeometryPhase = false;
            if(parent is VComponent)
            {
               (parent as VComponent).syncChildLayout(this);
            }
            else
            {
               this.geometryPhase();
            }
            if(!param1.isGeometryPhase)
            {
               param1.geometryPhase();
            }
         }
         else
         {
            param1.geometryPhase();
         }
      }
      
      protected function syncContentSize(param1:Boolean) : void
      {
         if(param1)
         {
            this.validContentSize = false;
         }
         if(this.isGeometryPhase)
         {
            if(this.isDependentSize)
            {
               this.updateW = uint.MAX_VALUE;
               if((this.mode & RULED_LAYOUT) == 0 && parent is VComponent)
               {
                  (parent as VComponent).syncChildLayout(this);
               }
               else
               {
                  this.geometryPhase();
               }
            }
            else
            {
               this.updatePhase(true);
            }
         }
         else
         {
            this.resetValidContentSize(parent as VComponent);
         }
      }
      
      private function resetValidContentSize(param1:VComponent) : void
      {
         while(param1)
         {
            if(!param1.isDependentSize)
            {
               return;
            }
            param1.validContentSize = false;
            param1 = param1.parent as VComponent;
         }
      }
      
      public function get measuredWidth() : uint
      {
         if(this.layoutW > 0)
         {
            return this.applyRangeW(this.layoutW);
         }
         if(!this.validContentSize)
         {
            this.calcContentSize();
            this.validContentSize = true;
         }
         return this.applyRangeW(this.contentW);
      }
      
      public function get measuredHeight() : uint
      {
         if(this.layoutH > 0)
         {
            return this.applyRangeH(this.layoutH);
         }
         if(!this.validContentSize)
         {
            this.calcContentSize();
            this.validContentSize = true;
         }
         return this.applyRangeH(this.contentH);
      }
      
      public function add(param1:VComponent, param2:Object = null, param3:int = -1) : void
      {
         if(param3 >= 0 && param3 < numChildren)
         {
            addChildAt(param1,param3);
         }
         else
         {
            addChild(param1);
         }
         if(param2)
         {
            param1.assignLayout(param2);
         }
         if(this.isGeometryPhase)
         {
            this.syncChildLayout(param1);
         }
         else
         {
            this.validContentSize = false;
         }
      }
      
      public function addStretch(param1:VComponent, param2:int = -1) : void
      {
         param1.stretch();
         this.add(param1,null,param2);
      }
      
      public function remove(param1:VComponent, param2:Boolean = true) : void
      {
         if(Boolean(param1) && param1.parent == this)
         {
            removeChild(param1);
            if(param2)
            {
               param1.dispose();
            }
            else
            {
               param1.updateW = uint.MAX_VALUE;
               if(param1.isDependentSize)
               {
                  param1.isGeometryPhase = false;
               }
            }
            this.validContentSize = false;
            if(this.isGeometryPhase && this.isDependentSize)
            {
               if(parent is VComponent)
               {
                  (parent as VComponent).syncChildLayout(this);
               }
               else
               {
                  this.geometryPhase();
               }
            }
         }
      }
      
      protected function calcContentSize() : void
      {
         var _loc4_:VComponent = null;
         var _loc5_:uint = 0;
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:* = int(numChildren - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = getChildAt(_loc3_) as VComponent;
            if((Boolean(_loc4_)) && (_loc4_.mode & SKIP_CONTENT_SIZE) == 0)
            {
               _loc5_ = _loc4_.measuredWidth + _loc4_.hPadding;
               if(_loc5_ > _loc1_)
               {
                  _loc1_ = _loc5_;
               }
               _loc5_ = _loc4_.measuredHeight + _loc4_.vPadding;
               if(_loc5_ > _loc2_)
               {
                  _loc2_ = _loc5_;
               }
            }
            _loc3_--;
         }
         this.contentW = _loc1_;
         this.contentH = _loc2_;
      }
      
      public function setGeometrySize(param1:uint, param2:uint, param3:Boolean) : void
      {
         if(param3)
         {
            this.layoutW = param1;
            this.layoutH = param2;
         }
         this.w = param1;
         this.h = param2;
         this.isGeometryPhase = true;
         this.updatePhase();
      }
      
      public function geometryPhase() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.isGeometryPhase = true;
         if(parent is VComponent)
         {
            _loc1_ = (parent as VComponent).w;
            _loc2_ = (parent as VComponent).h;
         }
         if(this.right != EMPTY && this.left != EMPTY)
         {
            this.w = this.applyRangeW(_loc1_ - (this.left + this.right));
         }
         else if(this.layoutW < 0)
         {
            this.w = this.applyRangeW(_loc1_ * (-this.layoutW / 100));
         }
         else
         {
            this.w = this.measuredWidth;
         }
         if(this.hCenter != EMPTY)
         {
            x = (_loc1_ - this.w >> 1) + this.hCenter;
         }
         else if(this.left != EMPTY)
         {
            x = this.left;
         }
         else if(this.right != EMPTY)
         {
            x = _loc1_ - this.w - this.right;
         }
         if(this.bottom != EMPTY && this.top != EMPTY)
         {
            this.h = this.applyRangeH(_loc2_ - (this.top + this.bottom));
         }
         else if(this.layoutH < 0)
         {
            this.h = this.applyRangeH(_loc2_ * (-this.layoutH / 100));
         }
         else
         {
            this.h = this.measuredHeight;
         }
         if(this.vCenter != EMPTY)
         {
            y = (_loc2_ - this.h >> 1) + this.vCenter;
         }
         else if(this.top != EMPTY)
         {
            y = this.top;
         }
         else if(this.bottom != EMPTY)
         {
            y = _loc2_ - this.h - this.bottom;
         }
         this.updatePhase();
      }
      
      public function updatePhase(param1:Boolean = false) : void
      {
         if(this.updateW != this.w || this.updateH != this.h || param1)
         {
            if(visible)
            {
               this.updateW = this.w;
               this.updateH = this.h;
               this.customUpdate();
            }
            else
            {
               this.isWaitUpdatePhase = true;
               if(param1)
               {
                  this.updateW = uint.MAX_VALUE;
               }
            }
         }
      }
      
      protected function customUpdate() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            if(_loc2_ is VComponent)
            {
               (_loc2_ as VComponent).geometryPhase();
            }
            _loc1_++;
         }
      }
      
      public function dispatchVarianceEvent(param1:uint, param2:* = null) : void
      {
         this.dispatcher.dispatchEvent(new VEvent(VEvent.VARIANCE,param2,param1));
      }
      
      public function removeAllChildren(param1:Boolean = true) : void
      {
         var _loc2_:DisplayObject = null;
         while(numChildren > 0)
         {
            _loc2_ = getChildAt(0);
            if(_loc2_ is VComponent)
            {
               this.remove(_loc2_ as VComponent,param1);
            }
            else
            {
               removeChild(_loc2_);
            }
         }
      }
      
      public function removeFromParent(param1:Boolean = true) : void
      {
         if(parent)
         {
            if(parent is VComponent)
            {
               (parent as VComponent).remove(this,false);
            }
            else
            {
               parent.removeChild(this);
            }
         }
         if(param1)
         {
            this.dispose();
         }
      }
      
      public function addFloat(param1:VComponent) : void
      {
         if(!param1.parent)
         {
            this.add(param1);
         }
      }
      
      public function removeFloat(param1:VComponent) : void
      {
         if(Boolean(param1) && param1.parent == this)
         {
            this.remove(param1,false);
         }
      }
      
      public function disposeFloat(param1:VComponent) : Boolean
      {
         if(Boolean(param1) && !param1.parent)
         {
            param1.dispose();
            return true;
         }
         return false;
      }
      
      public function assignLayout(param1:Object = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return;
         }
         for(_loc2_ in param1)
         {
            _loc3_ = int(param1[_loc2_]);
            switch(_loc2_)
            {
               case "left":
                  this.left = _loc3_;
                  break;
               case "top":
                  this.top = _loc3_;
                  break;
               case "right":
                  this.right = _loc3_;
                  break;
               case "bottom":
                  this.bottom = _loc3_;
                  break;
               case "w":
                  this.layoutW = _loc3_;
                  break;
               case "wP":
                  this.layoutW = -_loc3_;
                  break;
               case "h":
                  this.layoutH = _loc3_;
                  break;
               case "hP":
                  this.layoutH = -_loc3_;
                  break;
               case "hCenter":
                  this.hCenter = _loc3_;
                  break;
               case "vCenter":
                  this.vCenter = _loc3_;
                  break;
               case "maxW":
                  this.maxW = _loc3_;
                  break;
               case "minW":
                  this.minW = _loc3_;
                  break;
               case "maxH":
                  this.maxH = _loc3_;
                  break;
               case "minH":
                  this.minH = _loc3_;
            }
         }
      }
      
      public function stretch() : void
      {
         this.layoutW = this.layoutH = -100;
      }
      
      public function setSize(param1:int, param2:int) : void
      {
         this.layoutW = param1;
         this.layoutH = param2;
      }
      
      public function useCenter(param1:int = 0, param2:int = 0) : void
      {
         this.hCenter = param1;
         this.vCenter = param2;
      }
      
      public function setPadding(param1:int) : void
      {
         this.left = this.right = this.top = this.bottom = param1;
      }
      
      public function resetLayout() : void
      {
         this.left = this.right = this.top = this.bottom = this.vCenter = this.hCenter = EMPTY;
         this.maxW = this.maxH = this.minW = this.minH = this.layoutW = this.layoutH = 0;
      }
      
      public function copyLayout(param1:VComponent) : void
      {
         this.left = param1.left;
         this.right = param1.right;
         this.top = param1.top;
         this.bottom = param1.bottom;
         this.vCenter = param1.vCenter;
         this.hCenter = param1.hCenter;
         this.maxW = param1.maxW;
         this.maxH = param1.maxH;
         this.minW = param1.minW;
         this.minH = param1.minH;
         this.layoutW = param1.layoutW;
         this.layoutH = param1.layoutH;
      }
      
      public function applyRangeW(param1:int) : uint
      {
         if(param1 < this.minW)
         {
            return this.minW;
         }
         if(this.maxW > 0)
         {
            if(param1 > this.maxW)
            {
               return this.maxW;
            }
         }
         return param1;
      }
      
      public function applyRangeH(param1:int) : uint
      {
         if(param1 < this.minH)
         {
            return this.minH;
         }
         if(this.maxH > 0)
         {
            if(param1 > this.maxH)
            {
               return this.maxH;
            }
         }
         return param1;
      }
      
      public function get hPadding() : int
      {
         var _loc1_:uint = 0;
         if(this.left != EMPTY && this.left > 0)
         {
            _loc1_ += this.left;
         }
         if(this.right != EMPTY && this.right > 0)
         {
            _loc1_ += this.right;
         }
         return _loc1_;
      }
      
      public function get vPadding() : int
      {
         var _loc1_:uint = 0;
         if(this.top != EMPTY && this.top > 0)
         {
            _loc1_ += this.top;
         }
         if(this.bottom != EMPTY && this.bottom > 0)
         {
            _loc1_ += this.bottom;
         }
         return _loc1_;
      }
      
      public function get isLeftRight() : Boolean
      {
         return this.right != EMPTY && this.left != EMPTY;
      }
      
      public function get isTopBottom() : Boolean
      {
         return this.bottom != EMPTY && this.top != EMPTY;
      }
      
      private function get isDependentSize() : Boolean
      {
         return this.layoutW <= 0 || this.layoutH <= 0 || this.right != EMPTY && this.left != EMPTY || this.bottom != EMPTY && this.top != EMPTY;
      }
      
      public function get leftOrZero() : int
      {
         return this.left != EMPTY ? this.left : 0;
      }
      
      public function get rightOrZero() : int
      {
         return this.right != EMPTY ? this.right : 0;
      }
      
      public function get topOrZero() : int
      {
         return this.top != EMPTY ? this.top : 0;
      }
      
      public function get bottomOrZero() : int
      {
         return this.bottom != EMPTY ? this.bottom : 0;
      }
      
      public function calcAccurateW() : uint
      {
         var _loc1_:VComponent = null;
         if(this.layoutW < 0 || this.isLeftRight)
         {
            if(parent is VComponent)
            {
               _loc1_ = parent as VComponent;
               if(_loc1_.layoutW > 0 && !_loc1_.isLeftRight)
               {
                  return this.applyRangeW(this.isLeftRight ? int(_loc1_.layoutW - (this.left + this.right)) : int(_loc1_.layoutW * (-this.layoutW / 100)));
               }
            }
         }
         else if(this.layoutW > 0)
         {
            return this.applyRangeW(this.layoutW);
         }
         return 0;
      }
      
      public function calcAccurateH() : uint
      {
         var _loc1_:VComponent = null;
         if(this.layoutH < 0 || this.isTopBottom)
         {
            if(parent is VComponent)
            {
               _loc1_ = parent as VComponent;
               if(_loc1_.layoutH > 0 && !_loc1_.isTopBottom)
               {
                  return this.applyRangeH(this.isTopBottom ? int(_loc1_.layoutH - (this.top + this.bottom)) : int(_loc1_.layoutH * (-this.layoutH / 100)));
               }
            }
         }
         else if(this.layoutH > 0)
         {
            return this.applyRangeH(this.layoutH);
         }
         return 0;
      }
      
      public function useRuledLayout(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.mode |= RULED_LAYOUT;
         }
         else
         {
            this.mode &= ~RULED_LAYOUT;
         }
      }
   }
}

