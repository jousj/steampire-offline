package ui.vbase
{
   public class VBox extends VComponent
   {
      
      public static const VERTICAL:uint = 1;
      
      public static const TOP:uint = 2;
      
      public static const LEFT:uint = 4;
      
      public static const BOTTOM:uint = 8;
      
      public static const RIGHT:uint = 16;
      
      public static const STRETCH:uint = 32;
      
      public static const LIMIT_SIZE:uint = 64;
      
      public static const CENTER:uint = 128;
      
      public static const MIDDLE:uint = 256;
      
      public var list:Vector.<VComponent>;
      
      private var $gap:uint;
      
      public function VBox(param1:Vector.<VComponent> = null, param2:uint = 5, param3:uint = 0)
      {
         var _loc4_:Boolean = false;
         var _loc5_:VComponent = null;
         super();
         this.mode = param3;
         this.$gap = param2;
         if(param1)
         {
            this.list = param1;
            _loc4_ = (param3 & STRETCH) != 0;
            for each(_loc5_ in param1)
            {
               addChild(_loc5_);
               if(_loc4_)
               {
                  this.applyStretch(_loc5_);
               }
            }
         }
         else
         {
            this.list = new Vector.<VComponent>();
         }
      }
      
      private function applyStretch(param1:VComponent) : void
      {
         if((mode & VERTICAL) != 0)
         {
            param1.layoutW = -100;
         }
         else
         {
            param1.layoutH = -100;
         }
      }
      
      public function set gap(param1:uint) : void
      {
         this.$gap = param1;
         syncContentSize(true);
      }
      
      public function get gap() : uint
      {
         return this.$gap;
      }
      
      override protected function syncChildLayout(param1:VComponent) : void
      {
         syncContentSize(true);
      }
      
      override public function add(param1:VComponent, param2:Object = null, param3:int = -1) : void
      {
         if(param3 >= 0 && param3 < this.list.length)
         {
            this.list.splice(param3,0,param1);
         }
         else
         {
            this.list.push(param1);
         }
         if(param2)
         {
            param1.assignLayout(param2);
         }
         addChild(param1);
         if((mode & STRETCH) != 0)
         {
            this.applyStretch(param1);
         }
         if(isGeometryPhase || Boolean(parent))
         {
            syncContentSize(true);
         }
         else
         {
            validContentSize = false;
         }
      }
      
      override public function remove(param1:VComponent, param2:Boolean = true) : void
      {
         var _loc3_:int = this.list.indexOf(param1);
         if(_loc3_ >= 0)
         {
            this.removeAt(_loc3_,param2);
         }
      }
      
      public function removeAt(param1:uint, param2:Boolean = true) : void
      {
         var _loc3_:VComponent = null;
         if(param1 < this.list.length)
         {
            _loc3_ = this.list[param1];
            this.list.splice(param1,1);
            if(param2)
            {
               _loc3_.dispose();
            }
            if(_loc3_.parent == this)
            {
               removeChild(_loc3_);
            }
            syncContentSize(true);
         }
      }
      
      public function removeAll(param1:Boolean = true) : void
      {
         var _loc2_:VComponent = null;
         if(Boolean(this.list) && this.list.length > 0)
         {
            for each(_loc2_ in this.list)
            {
               removeChild(_loc2_);
               if(param1)
               {
                  _loc2_.dispose();
               }
            }
            this.list.length = 0;
         }
      }
      
      public function addAll() : void
      {
         var _loc1_:VComponent = null;
         if(Boolean(this.list) && this.list.length > 0)
         {
            for each(_loc1_ in this.list)
            {
               addChild(_loc1_);
            }
            syncContentSize(true);
         }
      }
      
      override protected function calcContentSize() : void
      {
         var _loc4_:VComponent = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Boolean = (mode & VERTICAL) != 0;
         for each(_loc4_ in this.list)
         {
            _loc5_ = _loc4_.measuredWidth;
            _loc6_ = _loc4_.measuredHeight;
            if(_loc3_)
            {
               if(_loc5_ > _loc1_)
               {
                  _loc1_ = _loc5_;
               }
               _loc2_ += _loc6_;
            }
            else
            {
               if(_loc6_ > _loc2_)
               {
                  _loc2_ = _loc6_;
               }
               _loc1_ += _loc5_;
            }
         }
         if(this.list.length > 0)
         {
            _loc7_ = (this.list.length - 1) * this.$gap;
            if(_loc3_)
            {
               _loc2_ += _loc7_;
            }
            else
            {
               _loc1_ += _loc7_;
            }
         }
         contentW = _loc1_;
         contentH = _loc2_;
      }
      
      override protected function customUpdate() : void
      {
         if(this.list.length > 0)
         {
            if((mode & VERTICAL) != 0)
            {
               this.vertical();
            }
            else
            {
               this.horizontal();
            }
         }
         if(this.list.length != numChildren)
         {
            this.updateRuledComponents();
         }
      }
      
      private function updateRuledComponents() : void
      {
         var _loc3_:VComponent = null;
         var _loc1_:* = int(this.list.length - 1);
         var _loc2_:* = int(numChildren - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = getChildAt(_loc2_) as VComponent;
            if(_loc1_ < 0 || this.list[_loc1_] != _loc3_)
            {
               if((_loc3_.getMode() & VComponent.RULED_LAYOUT) != 0)
               {
                  _loc3_.geometryPhase();
               }
            }
            else
            {
               _loc1_--;
            }
            _loc2_--;
         }
      }
      
      private function horizontal() : void
      {
         var _loc2_:Vector.<uint> = null;
         var _loc9_:VComponent = null;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc1_:int = 0;
         var _loc3_:uint = this.$gap * (this.list.length - 1);
         var _loc4_:int = this.w - _loc3_;
         var _loc5_:int = int(this.h);
         var _loc6_:Boolean = (mode & TOP) != 0;
         var _loc7_:Boolean = (mode & BOTTOM) != 0;
         var _loc8_:* = int(this.list.length - 1);
         while(_loc8_ >= 0)
         {
            _loc9_ = this.list[_loc8_];
            if(_loc9_.isTopBottom)
            {
               _loc10_ = _loc5_ - _loc9_.vPadding;
            }
            else
            {
               _loc10_ = _loc9_.layoutH < 0 ? int(_loc5_ * (-_loc9_.layoutH / 100)) : _loc9_.layoutH;
            }
            _loc10_ = _loc10_ <= 0 ? int(_loc9_.measuredHeight) : int(_loc9_.applyRangeH(_loc10_));
            if(_loc10_ > _loc5_ && (mode & LIMIT_SIZE) != 0)
            {
               _loc10_ = _loc5_;
            }
            if(_loc6_)
            {
               _loc9_.y = 0;
            }
            else
            {
               _loc9_.y = _loc7_ ? _loc5_ - _loc10_ : Math.round((_loc5_ - _loc10_) / 2);
            }
            if(_loc9_.layoutW < 0)
            {
               if(!_loc2_)
               {
                  _loc2_ = new Vector.<uint>();
               }
               _loc2_.push(_loc8_,_loc10_);
               _loc1_ += _loc9_.layoutW;
            }
            else
            {
               _loc9_.setGeometrySize(_loc9_.measuredWidth,_loc10_,false);
               _loc4_ -= _loc9_.w;
               _loc3_ += _loc9_.w;
            }
            _loc8_--;
         }
         if(_loc2_)
         {
            _loc11_ = _loc2_.length - 1;
            _loc8_ = 0;
            while(_loc8_ < _loc11_)
            {
               _loc9_ = this.list[_loc2_[_loc8_]];
               _loc9_.setGeometrySize(_loc4_ > 0 ? _loc9_.applyRangeW(_loc9_.layoutW / _loc1_ * _loc4_) : _loc9_.measuredWidth,_loc2_[_loc8_ + 1],false);
               _loc3_ += _loc9_.w;
               _loc8_ += 2;
            }
         }
         if((mode & CENTER) != 0)
         {
            _loc8_ = int((this.w - _loc3_) / 2);
         }
         else if((mode & RIGHT) != 0)
         {
            _loc8_ = int(this.w - _loc3_);
         }
         else
         {
            _loc8_ = 0;
         }
         for each(_loc9_ in this.list)
         {
            _loc9_.x = _loc8_;
            _loc8_ += _loc9_.w + this.$gap;
         }
      }
      
      private function vertical() : void
      {
         var _loc2_:Vector.<uint> = null;
         var _loc9_:VComponent = null;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc1_:int = 0;
         var _loc3_:uint = this.$gap * (this.list.length - 1);
         var _loc4_:int = this.h - _loc3_;
         var _loc5_:int = int(this.w);
         var _loc6_:Boolean = (mode & LEFT) != 0;
         var _loc7_:Boolean = (mode & RIGHT) != 0;
         var _loc8_:* = int(this.list.length - 1);
         while(_loc8_ >= 0)
         {
            _loc9_ = this.list[_loc8_];
            if(_loc9_.isLeftRight)
            {
               _loc10_ = _loc5_ - _loc9_.hPadding;
            }
            else
            {
               _loc10_ = _loc9_.layoutW < 0 ? int(_loc5_ * (-_loc9_.layoutW / 100)) : _loc9_.layoutW;
            }
            _loc10_ = _loc10_ <= 0 ? int(_loc9_.measuredWidth) : int(_loc9_.applyRangeW(_loc10_));
            if(_loc10_ > _loc5_ && (mode & LIMIT_SIZE) != 0)
            {
               _loc10_ = _loc5_;
            }
            if(_loc6_)
            {
               _loc9_.x = 0;
            }
            else
            {
               _loc9_.x = _loc7_ ? _loc5_ - _loc10_ : Math.round((_loc5_ - _loc10_) / 2);
            }
            if(_loc9_.layoutH < 0)
            {
               if(!_loc2_)
               {
                  _loc2_ = new Vector.<uint>();
               }
               _loc2_.push(_loc8_,_loc10_);
               _loc1_ += _loc9_.layoutH;
            }
            else
            {
               _loc9_.setGeometrySize(_loc10_,_loc9_.measuredHeight,false);
               _loc4_ -= _loc9_.h;
               _loc3_ += _loc9_.h;
            }
            _loc8_--;
         }
         if(_loc2_)
         {
            _loc11_ = _loc2_.length - 1;
            _loc8_ = 0;
            while(_loc8_ < _loc11_)
            {
               _loc9_ = this.list[_loc2_[_loc8_]];
               _loc9_.setGeometrySize(_loc2_[_loc8_ + 1],_loc4_ > 0 ? _loc9_.applyRangeH(_loc9_.layoutH / _loc1_ * _loc4_) : _loc9_.measuredHeight,false);
               _loc3_ += _loc9_.h;
               _loc8_ += 2;
            }
         }
         if((mode & MIDDLE) != 0)
         {
            _loc8_ = int((this.h - _loc3_) / 2);
         }
         else if((mode & BOTTOM) != 0)
         {
            _loc8_ = int(this.h - _loc3_);
         }
         else
         {
            _loc8_ = 0;
         }
         for each(_loc9_ in this.list)
         {
            _loc9_.y = _loc8_;
            _loc8_ += _loc9_.h + this.$gap;
         }
      }
   }
}

