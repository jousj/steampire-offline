package ui.vbase
{
   import flash.text.engine.TextLine;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.ScrollPolicy;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TextAlign;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.VerticalAlign;
   import flashx.textLayout.tlf_internal;
   
   public class VText extends VComponent
   {
      
      public static const MIDDLE:uint = 1;
      
      public static const CONTAIN:uint = 2;
      
      public static const BOTTOM:uint = 4;
      
      public static const CENTER:uint = 8;
      
      public static const CONTAIN_CENTER:uint = 10;
      
      public static const SELECTION:uint = 16;
      
      protected const textFlow:TextFlow = new TextFlow();
      
      private var span:SpanElement;
      
      public function VText(param1:String = null, param2:uint = 0, param3:uint = 16777216, param4:uint = 0)
      {
         super();
         mouseEnabled = false;
         var _loc5_:TextLayoutFormat = this.textFlow.format as TextLayoutFormat;
         if(param3 < 16777216)
         {
            _loc5_.color = param3;
         }
         if(param4 > 0)
         {
            _loc5_.fontSize = param4;
         }
         this.mode = param2;
         this.updateMode();
         this.value = param1;
      }
      
      public static function getComposeW(param1:VComponent, param2:Boolean) : uint
      {
         var _loc3_:uint = 0;
         if(!param2)
         {
            _loc3_ = param1.calcAccurateW();
            if(param1.maxW > 0 && _loc3_ == 0)
            {
               return param1.maxW;
            }
         }
         return _loc3_;
      }
      
      public static function getComposeH(param1:VComponent) : uint
      {
         var _loc2_:uint = param1.calcAccurateH();
         if(param1.maxH > 0 && _loc2_ == 0)
         {
            return param1.maxH;
         }
         return _loc2_;
      }
      
      public static function checkValidContentSize(param1:VComponent, param2:TextFlow, param3:Boolean) : void
      {
         var _loc4_:ContainerController = null;
         var _loc5_:Number = NaN;
         if(param1.validContentSize && param2.flowComposer.numControllers > 0)
         {
            _loc4_ = param2.flowComposer.getControllerAt(0);
            _loc5_ = _loc4_.compositionWidth;
            if(isNaN(_loc5_))
            {
               _loc5_ = 0;
            }
            if(getComposeW(param1,param3) != _loc5_)
            {
               param1.validContentSize = false;
            }
            else
            {
               _loc5_ = _loc4_.compositionHeight;
               if(isNaN(_loc5_))
               {
                  _loc5_ = 0;
               }
               if(getComposeH(param1) != _loc5_)
               {
                  param1.validContentSize = false;
               }
            }
         }
      }
      
      public function get format() : TextLayoutFormat
      {
         return this.textFlow.format as TextLayoutFormat;
      }
      
      public function syncFormat(param1:Boolean = false) : void
      {
         this.textFlow.invalidateAllFormats();
         if(param1)
         {
            syncContentSize(true);
         }
      }
      
      public function setBaseFormat(param1:uint, param2:uint) : void
      {
         var _loc3_:TextLayoutFormat = this.textFlow.format as TextLayoutFormat;
         _loc3_.fontSize = param1;
         _loc3_.color = param2;
         this.textFlow.invalidateAllFormats();
      }
      
      public function setColor(param1:uint) : void
      {
         (this.textFlow.format as TextLayoutFormat).color = param1;
         this.textFlow.invalidateAllFormats();
      }
      
      protected function updateMode() : void
      {
         this.textFlow.textAlign = (mode & CENTER) != 0 ? TextAlign.CENTER : TextAlign.LEFT;
         if((mode & CONTAIN) != 0)
         {
            this.textFlow.lineBreak = LineBreak.EXPLICIT;
            this.textFlow.verticalAlign = VerticalAlign.TOP;
         }
         else
         {
            this.textFlow.lineBreak = LineBreak.TO_FIT;
            if((mode & MIDDLE) != 0)
            {
               this.textFlow.verticalAlign = VerticalAlign.MIDDLE;
            }
            else if((mode & BOTTOM) != 0)
            {
               this.textFlow.verticalAlign = VerticalAlign.BOTTOM;
            }
            else
            {
               this.textFlow.verticalAlign = VerticalAlign.TOP;
            }
         }
         mouseChildren = (mode & SELECTION) != 0;
         if(mouseChildren)
         {
            if(!this.textFlow.interactionManager)
            {
               this.textFlow.interactionManager = new SelectionManager();
               if(this.textFlow.numChildren > 0 && !this.span)
               {
                  this.span = (this.textFlow.getChildAt(0) as ParagraphElement).getChildAt(0) as SpanElement;
               }
            }
         }
         else
         {
            this.textFlow.interactionManager = null;
         }
      }
      
      public function setMode(param1:uint) : void
      {
         mode = param1;
         this.updateMode();
         this.customUpdate();
      }
      
      public function set value(param1:String) : void
      {
         if(this.span)
         {
            this.span.text = param1;
         }
         else
         {
            this.addSpan(param1);
         }
         syncContentSize(true);
      }
      
      private function addSpan(param1:String) : void
      {
         var _loc2_:ParagraphElement = new ParagraphElement();
         this.span = new SpanElement();
         _loc2_.addChild(this.span);
         this.span.text = param1;
         this.textFlow.addChild(_loc2_);
      }
      
      public function get value() : String
      {
         return this.span ? this.span.text : "";
      }
      
      override public function dispose() : void
      {
         this.textFlow.flowComposer.removeAllControllers();
         super.dispose();
      }
      
      protected function buildText(param1:Number, param2:Number) : void
      {
         var _loc3_:ContainerController = null;
         if(this.textFlow.flowComposer.numControllers == 0)
         {
            _loc3_ = new ContainerController(this,param1,param2);
            _loc3_.verticalScrollPolicy = ScrollPolicy.OFF;
            this.textFlow.flowComposer.addController(_loc3_);
         }
         else
         {
            _loc3_ = this.textFlow.flowComposer.getControllerAt(0);
            _loc3_.setCompositionSize(param1,param2);
         }
         this.textFlow.flowComposer.updateAllControllers();
      }
      
      override public function get measuredWidth() : uint
      {
         if(layoutW <= 0)
         {
            checkValidContentSize(this,this.textFlow,(mode & CONTAIN) != 0);
         }
         return super.measuredWidth;
      }
      
      override public function get measuredHeight() : uint
      {
         if(layoutH <= 0)
         {
            checkValidContentSize(this,this.textFlow,(mode & CONTAIN) != 0);
         }
         return super.measuredHeight;
      }
      
      override protected function calcContentSize() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = getComposeW(this,(mode & CONTAIN) != 0);
         _loc2_ = getComposeH(this);
         this.buildText(_loc1_ > 0 ? _loc1_ : NaN,_loc2_ > 0 ? _loc2_ : NaN);
         var _loc3_:ContainerController = this.textFlow.flowComposer.getControllerAt(0);
         contentW = Math.ceil(_loc3_.tlf_internal::contentWidth);
         contentH = Math.ceil(_loc3_.tlf_internal::contentHeight);
         updateW = _loc1_ > contentW ? _loc1_ : contentW;
         updateH = _loc2_ > contentH ? _loc2_ : contentH;
      }
      
      override protected function customUpdate() : void
      {
         if((mode & CONTAIN) != 0)
         {
            this.containUpdate();
         }
         else
         {
            this.buildText(w,h);
         }
      }
      
      private function containUpdate() : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:TextLine = null;
         var _loc10_:Number = NaN;
         this.buildText(NaN,NaN);
         var _loc1_:int = numChildren;
         if(_loc1_ == 0)
         {
            return;
         }
         var _loc2_:ContainerController = this.textFlow.flowComposer.getControllerAt(0);
         var _loc3_:Number = _loc2_.tlf_internal::contentWidth;
         var _loc4_:Number = _loc2_.tlf_internal::contentHeight;
         var _loc5_:Boolean = _loc3_ > w || _loc4_ > h;
         if(_loc5_)
         {
            _loc8_ = w / h <= _loc3_ / _loc4_ ? w / _loc3_ : h / _loc4_;
            _loc4_ = (1 - _loc8_) * _loc4_ / 2;
         }
         else
         {
            _loc8_ = 1;
         }
         var _loc6_:Boolean = (mode & CENTER) != 0;
         var _loc7_:uint = 0;
         while(_loc7_ < _loc1_)
         {
            _loc9_ = getChildAt(_loc7_) as TextLine;
            if(_loc7_ == 0)
            {
               _loc10_ = -_loc9_.getRect(null).y;
            }
            _loc9_.scaleX = _loc8_;
            _loc9_.scaleY = _loc8_;
            _loc9_.y = (_loc9_.userData as TextFlowLine).y + _loc10_;
            if(_loc5_)
            {
               _loc9_.y = _loc9_.y * _loc8_ + _loc4_;
            }
            _loc9_.x = _loc6_ ? (w - _loc9_.width) / 2 : 0;
            _loc7_++;
         }
         _loc5_ = (mode & MIDDLE) != 0;
         if((_loc5_) || (mode & BOTTOM) != 0)
         {
            _loc4_ = h - getChildAt(_loc1_ - 1).getRect(this).bottom;
            if(_loc5_)
            {
               _loc4_ /= 2;
            }
            _loc7_ = 0;
            while(_loc7_ < _loc1_)
            {
               getChildAt(_loc7_).y = getChildAt(_loc7_).y + _loc4_;
               _loc7_++;
            }
         }
      }
      
      override public function add(param1:VComponent, param2:Object = null, param3:int = -1) : void
      {
         throw new Error("VText don\'t use add method");
      }
      
      override public function remove(param1:VComponent, param2:Boolean = true) : void
      {
         throw new Error("VText don\'t use remove method");
      }
      
      public function assignW(param1:int) : VText
      {
         layoutW = param1;
         return this;
      }
      
      public function assignMaxW(param1:int) : VText
      {
         maxW = param1;
         return this;
      }
   }
}

