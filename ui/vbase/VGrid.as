package ui.vbase
{
   public class VGrid extends VComponent
   {
      
      public static const FILTER_MODE:uint = 1;
      
      public static const H_STRETCH:uint = 2;
      
      public static const V_STRETCH:uint = 4;
      
      public static const FLOAT_INDEX:uint = 8;
      
      public static const USE_NULL_DATA:uint = 16;
      
      public static const USE_TOP_LEFT:uint = 32;
      
      public static const USE_END_LIMIT:uint = 64;
      
      public static const USE_VISIBLE_CALC_LAYOUT:uint = 128;
      
      public static const SELECTED_MODE:uint = 256;
      
      public static const USE_INVERT_SELECT:uint = 512;
      
      protected static const CALC_H_COUNT:uint = 32768;
      
      protected static const CALC_V_COUNT:uint = 65536;
      
      public const renderList:Vector.<VRenderer> = new Vector.<VRenderer>();
      
      public var emptyFactory:Function;
      
      public var control:GridControl;
      
      private var dataProvider:Array;
      
      private var _hGap:uint;
      
      private var _vGap:uint;
      
      private var _hCount:uint;
      
      private var _vCount:uint;
      
      private var _maxRenderer:uint;
      
      private var dpIndex:uint;
      
      private var dpLength:uint;
      
      private var rendererFactory:Object;
      
      private var emptyComponent:VComponent;
      
      private var selectDataIndex:uint = 4294967295;
      
      public function VGrid(param1:uint, param2:uint, param3:Object, param4:Array = null, param5:uint = 0, param6:uint = 0, param7:uint = 0, param8:uint = 0)
      {
         super();
         if(param1 == 0)
         {
            param7 |= CALC_H_COUNT;
            param1 = 1;
         }
         if(param2 == 0)
         {
            param7 |= CALC_V_COUNT;
            param2 = 1;
         }
         this._hCount = param1;
         this._vCount = param2;
         this._maxRenderer = param2 * param1;
         this._hGap = param5;
         this._vGap = param6;
         this.mode = param7;
         if((param7 & SELECTED_MODE) != 0)
         {
            addListener(VEvent.SELECT,this.onSelect);
         }
         this.rendererFactory = param3;
         this.renderList.push(this.createRenderer());
         if(param4)
         {
            this.dataProvider = param4;
            this.sync(param8,false);
         }
      }
      
      public function changeRendererCount(param1:uint, param2:uint, param3:Array = null, param4:uint = 0, param5:Boolean = true) : void
      {
         if(param1 == 0)
         {
            param1 = 1;
         }
         if(param2 == 0)
         {
            param2 = 1;
         }
         var _loc6_:Boolean = param1 != this._hCount || param2 != this._vCount;
         if(_loc6_)
         {
            this._maxRenderer = param1 * param2;
            this._hCount = param1;
            this._vCount = param2;
            while(this.renderList.length > this._maxRenderer)
            {
               super.remove(this.renderList.pop());
            }
         }
         if(param3)
         {
            this.setDataProvider(param3,param4);
         }
         else if(_loc6_)
         {
            this.sync();
         }
         if(_loc6_ && param5)
         {
            syncContentSize(true);
         }
      }
      
      private function createRenderer() : VRenderer
      {
         var _loc1_:VRenderer = this.rendererFactory is Function ? (this.rendererFactory as Function)() : new (this.rendererFactory as Class)();
         if(_loc1_.layoutW == 0)
         {
            _loc1_.layoutW = 100;
         }
         if(_loc1_.layoutH == 0)
         {
            _loc1_.layoutH = 100;
         }
         _loc1_.useRuledLayout();
         _loc1_.dispatcher = this;
         return _loc1_;
      }
      
      override protected function calcContentSize() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc1_:Boolean = (mode & USE_VISIBLE_CALC_LAYOUT) != 0;
         if(_loc1_)
         {
            _loc2_ = this.getRendererVisibleCount();
            if(_loc2_ == 0)
            {
               _loc2_ = 1;
            }
            _loc3_ = _loc2_ <= this._hCount ? _loc2_ : this._hCount;
         }
         else
         {
            _loc3_ = this._hCount;
         }
         contentW = this.renderList[0].layoutW * _loc3_;
         if(_loc3_ > 1)
         {
            contentW += this._hGap * (_loc3_ - 1);
         }
         if(_loc1_)
         {
            _loc3_ = Math.ceil(_loc2_ / this._hCount);
            if(_loc3_ > this._vCount)
            {
               _loc3_ = this._vCount;
            }
         }
         else
         {
            _loc3_ = this._vCount;
         }
         contentH = this.renderList[0].layoutH * _loc3_;
         if(_loc3_ > 1)
         {
            contentH += this._vGap * (_loc3_ - 1);
         }
      }
      
      public function get vGap() : uint
      {
         return this._vGap;
      }
      
      public function set vGap(param1:uint) : void
      {
         this._vGap = param1;
         syncContentSize(true);
      }
      
      public function get hGap() : uint
      {
         return this._hGap;
      }
      
      public function set hGap(param1:uint) : void
      {
         this._hGap = param1;
         syncContentSize(true);
      }
      
      public function get hCount() : uint
      {
         return this._hCount;
      }
      
      public function get vCount() : uint
      {
         return this._vCount;
      }
      
      public function get maxRenderer() : uint
      {
         return this._maxRenderer;
      }
      
      public function setDataProvider(param1:Array, param2:uint = 0) : void
      {
         this.dataProvider = param1;
         this.sync(param2);
      }
      
      private function applyIndex() : void
      {
         if(this.dpIndex > 0)
         {
            if(this.dpLength <= this._maxRenderer)
            {
               this.dpIndex = 0;
            }
            else
            {
               if(this.dpIndex >= this.dpLength)
               {
                  this.dpIndex = this.dpLength - 1;
               }
               if((mode & FLOAT_INDEX) == 0)
               {
                  this.dpIndex = uint(this.dpIndex / this._maxRenderer) * this._maxRenderer;
               }
               if((mode & USE_END_LIMIT) != 0 && this.dpIndex > this.dpLength - this._maxRenderer)
               {
                  this.dpIndex = this.dpLength - this._maxRenderer;
               }
            }
         }
      }
      
      protected function get useFilterItem() : Boolean
      {
         return (mode & FILTER_MODE) != 0 && this.dataProvider && this.dataProvider.length > 0 && this.dataProvider[0] is VOGridFilterItem;
      }
      
      public function sync(param1:int = -1, param2:Boolean = true) : void
      {
         var _loc3_:VOGridFilterItem = null;
         if(param1 >= 0)
         {
            this.dpIndex = param1;
         }
         if(this.dataProvider)
         {
            if(this.useFilterItem)
            {
               this.dpLength = 0;
               for each(_loc3_ in this.dataProvider)
               {
                  if(_loc3_.isUse)
                  {
                     ++this.dpLength;
                  }
               }
            }
            else
            {
               this.dpLength = this.dataProvider.length;
            }
         }
         else
         {
            this.dpLength = 0;
         }
         this.applyIndex();
         this.updateRendererData();
         if(this.dpLength == 0)
         {
            if(!this.emptyComponent && this.emptyFactory != null)
            {
               this.emptyComponent = this.emptyFactory();
               addChild(this.emptyComponent);
               this.emptyComponent.geometryPhase();
            }
         }
         else if(this.emptyComponent)
         {
            super.remove(this.emptyComponent);
            this.emptyComponent = null;
         }
         if(param2)
         {
            dispatchEvent(new VEvent(VEvent.CHANGE,this.dpIndex));
         }
      }
      
      public function getDataProvider() : Array
      {
         return this.dataProvider;
      }
      
      public function get length() : uint
      {
         return this.dpLength;
      }
      
      public function get index() : uint
      {
         return this.dpIndex;
      }
      
      public function set index(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this.dataProvider)
         {
            _loc2_ = this.dpIndex;
            this.dpIndex = param1;
            this.applyIndex();
            if(_loc2_ != this.dpIndex)
            {
               this.updateRendererData();
               dispatchEvent(new VEvent(VEvent.CHANGE,this.dpIndex));
            }
         }
      }
      
      public function checkShowIndex(param1:uint) : Boolean
      {
         return param1 >= this.dpIndex && param1 < this.dpIndex + this._maxRenderer;
      }
      
      public function clear() : void
      {
         this.dataProvider = null;
         this.dpLength = 0;
         this.dpIndex = 0;
         this.updateRendererData();
      }
      
      public function getIndexData() : Object
      {
         return this.dpIndex < this.dpLength ? this.dataProvider[this.dpIndex] : null;
      }
      
      public function getData(param1:uint) : Object
      {
         return param1 < this.dpLength ? this.dataProvider[param1] : null;
      }
      
      public function getSelectData() : Object
      {
         return this.selectDataIndex < this.dpLength ? this.dataProvider[this.selectDataIndex] : null;
      }
      
      public function getSelectIndex() : uint
      {
         return this.selectDataIndex;
      }
      
      protected function getFilterData(param1:uint) : Object
      {
         var _loc3_:VOGridFilterItem = null;
         if(param1 >= this.dpLength)
         {
            return null;
         }
         var _loc2_:uint = 0;
         for each(_loc3_ in this.dataProvider)
         {
            if(_loc3_.isUse)
            {
               if(param1 == _loc2_)
               {
                  return _loc3_;
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      protected function updateRendererData() : void
      {
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Object = null;
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = (mode & USE_NULL_DATA) != 0;
         var _loc3_:uint = this.renderList.length;
         if(isGeometryPhase && (mode & USE_VISIBLE_CALC_LAYOUT) != 0)
         {
            _loc8_ = this.getRendererVisibleCount();
         }
         if((mode & SELECTED_MODE) != 0)
         {
            _loc9_ = this.getRendererIndex(this.selectDataIndex);
         }
         var _loc4_:VRenderer = this.renderList[0];
         var _loc5_:int = _loc4_.parent ? getChildIndex(_loc4_) : numChildren;
         var _loc6_:Boolean = this.useFilterItem;
         var _loc7_:uint = 0;
         while(_loc7_ < this._maxRenderer)
         {
            _loc10_ = this.dpIndex + _loc7_;
            _loc11_ = _loc6_ ? this.getFilterData(_loc10_) : this.getData(_loc10_);
            if((Boolean(_loc11_)) || _loc2_)
            {
               if(_loc7_ == _loc3_)
               {
                  _loc4_ = this.createRenderer();
                  addChildAt(_loc4_,_loc5_ + _loc7_);
                  this.renderList.push(_loc4_);
                  _loc1_ = true;
                  _loc3_++;
               }
               else
               {
                  _loc4_ = this.renderList[_loc7_];
                  if(!_loc4_.parent)
                  {
                     addChildAt(_loc4_,_loc5_ + _loc7_);
                  }
               }
               _loc4_.dataIndex = _loc10_;
               _loc4_.setData(_loc11_);
            }
            else if(_loc7_ < _loc3_)
            {
               _loc4_ = this.renderList[_loc7_];
               if(_loc4_.parent)
               {
                  removeChild(_loc4_);
               }
            }
            _loc7_++;
         }
         if((mode & SELECTED_MODE) != 0)
         {
            _loc10_ = this.getRendererIndex(this.selectDataIndex);
            if(_loc9_ != _loc10_)
            {
               this.changeSelected(_loc9_,false,false);
               this.changeSelected(_loc10_,true,false);
            }
         }
         if(isGeometryPhase)
         {
            if((mode & USE_VISIBLE_CALC_LAYOUT) != 0)
            {
               if(this.checkChangeVisibleCount(_loc8_))
               {
                  syncContentSize(true);
                  return;
               }
            }
            if(_loc1_)
            {
               this.updateRendererPos();
            }
         }
      }
      
      private function getRendererVisibleCount() : uint
      {
         var _loc2_:VRenderer = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.renderList)
         {
            if(_loc2_.parent)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      private function checkChangeVisibleCount(param1:uint) : Boolean
      {
         var _loc2_:uint = this.getRendererVisibleCount();
         var _loc3_:uint = Math.ceil(_loc2_ / this._hCount);
         return _loc3_ != Math.ceil(param1 / this._hCount) || _loc3_ == 1 && _loc2_ != param1;
      }
      
      protected function updateRendererPos() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc10_:Number = NaN;
         var _loc11_:uint = 0;
         var _loc12_:VRenderer = null;
         if((mode & USE_VISIBLE_CALC_LAYOUT) != 0)
         {
            _loc1_ = this.getRendererVisibleCount();
            if(_loc1_ == 0)
            {
               _loc1_ = 1;
            }
            _loc2_ = Math.ceil(_loc1_ / this._hCount);
            if(_loc1_ > this._hCount)
            {
               _loc1_ = this._hCount;
            }
            if(_loc2_ > this._vCount)
            {
               _loc2_ = this._vCount;
            }
         }
         else
         {
            _loc1_ = this._hCount;
            _loc2_ = this._vCount;
         }
         var _loc3_:uint = uint(this.renderList[0].layoutW);
         if((mode & H_STRETCH) != 0 || _loc3_ == 0)
         {
            _loc3_ = (w - (_loc1_ - 1) * this._hGap) / _loc1_;
         }
         var _loc4_:Number = w - ((_loc3_ + this._hGap) * _loc1_ - this._hGap);
         if(_loc4_ > 0 && (mode & USE_TOP_LEFT) == 0)
         {
            _loc4_ = Math.round(_loc4_ / 2);
         }
         else
         {
            _loc4_ = 0;
         }
         var _loc5_:uint = uint(this.renderList[0].layoutH);
         if((mode & V_STRETCH) != 0 || _loc5_ == 0)
         {
            _loc5_ = (h - (_loc2_ - 1) * this._vGap) / _loc2_;
         }
         var _loc6_:Number = h - ((_loc5_ + this._vGap) * _loc2_ - this._vGap);
         if(_loc6_ > 0 && (mode & USE_TOP_LEFT) == 0)
         {
            _loc6_ = Math.round(_loc6_ / 2);
         }
         else
         {
            _loc6_ = 0;
         }
         var _loc7_:* = 0;
         var _loc8_:uint = this.renderList.length;
         var _loc9_:uint = 0;
         while(_loc9_ < _loc2_)
         {
            _loc10_ = Math.round(_loc9_ * (_loc5_ + this._vGap)) + _loc6_;
            _loc11_ = 0;
            while(_loc11_ < _loc1_)
            {
               _loc12_ = this.renderList[_loc7_];
               _loc12_.left = _loc12_.x = Math.round(_loc11_ * (_loc3_ + this._hGap) + _loc4_);
               _loc12_.y = _loc10_;
               _loc12_.setGeometrySize(_loc3_,_loc5_,false);
               if(++_loc7_ == _loc8_)
               {
                  return;
               }
               _loc11_++;
            }
            _loc9_++;
         }
      }
      
      override public function dispose() : void
      {
         if(this.control)
         {
            this.control.dispose();
         }
         super.dispose();
      }
      
      override protected function customUpdate() : void
      {
         var _loc4_:VComponent = null;
         var _loc1_:Boolean = (mode & CALC_H_COUNT) != 0;
         var _loc2_:Boolean = (mode & CALC_V_COUNT) != 0;
         if(_loc1_ || _loc2_)
         {
            isGeometryPhase = false;
            this.changeRendererCount(_loc1_ && (layoutW <= 0 || right != EMPTY && left != EMPTY) ? uint(Math.floor(w / (this.renderList[0].layoutW + this._hGap))) : this._hCount,_loc2_ && (layoutH <= 0 || bottom != EMPTY && top != EMPTY) ? uint(Math.floor(h / (this.renderList[0].layoutH + this._vGap))) : this._vCount,null,0,false);
            isGeometryPhase = true;
         }
         this.updateRendererPos();
         var _loc3_:* = int(numChildren - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = getChildAt(_loc3_) as VComponent;
            if((Boolean(_loc4_)) && !(_loc4_ is VRenderer))
            {
               _loc4_.geometryPhase();
            }
            _loc3_--;
         }
      }
      
      override public function add(param1:VComponent, param2:Object = null, param3:int = -1) : void
      {
         param1.useRuledLayout();
         super.add(param1,param2,param3);
      }
      
      override public function remove(param1:VComponent, param2:Boolean = true) : void
      {
         if(!param2)
         {
            param1.useRuledLayout(false);
         }
         super.remove(param1,param2);
      }
      
      private function getRendererIndex(param1:uint) : uint
      {
         var _loc2_:uint = this.renderList.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.renderList[_loc3_].dataIndex == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return uint.MAX_VALUE;
      }
      
      private function changeSelected(param1:uint, param2:Boolean, param3:Boolean = true) : void
      {
         if(param3)
         {
            param1 = this.getRendererIndex(param1);
         }
         if(param1 < this.renderList.length)
         {
            this.renderList[param1].setSelected(param2);
         }
      }
      
      public function setSelected(param1:uint = 4294967295) : void
      {
         if(this.selectDataIndex == param1)
         {
            if((mode & USE_INVERT_SELECT) != 0)
            {
               this.changeSelected(param1,false);
               this.selectDataIndex = uint.MAX_VALUE;
            }
         }
         else
         {
            this.changeSelected(this.selectDataIndex,false);
            this.changeSelected(param1,true);
            this.selectDataIndex = param1;
         }
      }
      
      private function onSelect(param1:VEvent) : void
      {
         this.setSelected(param1.variance);
      }
      
      public function getEmptyComponent() : VComponent
      {
         return this.emptyComponent;
      }
   }
}

