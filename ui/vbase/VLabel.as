package ui.vbase
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.ScrollPolicy;
   import flashx.textLayout.conversion.ConversionType;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.conversion.TextLayoutImporter;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.FlowElementMouseEvent;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TextAlign;
   import flashx.textLayout.formats.VerticalAlign;
   import flashx.textLayout.tlf_internal;
   
   public class VLabel extends VComponent
   {
      
      public static const MIDDLE:uint = 1;
      
      public static const CONTAIN:uint = 2;
      
      public static const BOTTOM:uint = 4;
      
      public static const CENTER:uint = 8;
      
      public static const CONTAIN_CENTER:uint = 10;
      
      public static const LEADING_BOX:uint = 16;
      
      public static const IMG_HINT:uint = 48;
      
      public static const SELECTION:uint = 64;
      
      protected static const importer:TextLayoutImporter = new TextLayoutImporter();
      
      protected var textFlow:TextFlow;
      
      protected var content:Sprite;
      
      public function VLabel(param1:String = null, param2:uint = 0)
      {
         super();
         mouseEnabled = false;
         this.mode = param2;
         this.text = param1;
      }
      
      public function set text(param1:String) : void
      {
         var value:String = param1;
         if(this.textFlow)
         {
            this.clearText();
            this.textFlow = null;
         }
         if(value != null && value.length > 0)
         {
            try
            {
               this.textFlow = importer.createTextFlowFromXML(new XML("<TextFlow xmlns=\"http://ns.adobe.com/textLayout/2008\" version=\"3.0.0\">" + value + "</TextFlow>"));
               if((mode & LEADING_BOX) != 0)
               {
                  this.textFlow.leadingModel = LeadingModel.BOX;
               }
               if((mode & CONTAIN) != 0)
               {
                  this.textFlow.lineBreak = LineBreak.EXPLICIT;
               }
               if((mode & CENTER) != 0)
               {
                  this.textFlow.textAlign = TextAlign.CENTER;
               }
               if((mode & MIDDLE) != 0)
               {
                  this.textFlow.verticalAlign = VerticalAlign.MIDDLE;
               }
               else if((mode & BOTTOM) != 0)
               {
                  this.textFlow.verticalAlign = VerticalAlign.BOTTOM;
               }
               if((mode & SELECTION) != 0)
               {
                  mouseChildren = true;
                  this.textFlow.interactionManager = new SelectionManager();
                  this.textFlow.addEventListener("click",this.onClick,false,0,true);
               }
               else
               {
                  mouseChildren = (mode & IMG_HINT) != 0;
               }
            }
            catch(error:Error)
            {
            }
         }
         syncContentSize(true);
      }
      
      private function onClick(param1:FlowElementMouseEvent) : void
      {
         if(param1.flowElement is LinkElement)
         {
            dispatcher.dispatchEvent(new VEvent(VEvent.SELECT,(param1.flowElement as LinkElement).href));
         }
      }
      
      public function get text() : String
      {
         return this.textFlow ? this.textFlow.getText() : null;
      }
      
      public function setMode(param1:uint) : void
      {
         mode = param1;
         this.text = this.tlfText;
      }
      
      public function get tlfText() : String
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(this.textFlow)
         {
            _loc1_ = TextConverter.export(this.textFlow,TextConverter.TEXT_LAYOUT_FORMAT,ConversionType.STRING_TYPE) as String;
            if(Boolean(_loc1_) && _loc1_.substr(0,9) == "<TextFlow")
            {
               _loc2_ = _loc1_.indexOf(">");
               if(_loc2_ > 0)
               {
                  _loc1_ = _loc1_.slice(_loc2_ + 1,-11);
               }
            }
         }
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         this.clearText();
         super.dispose();
      }
      
      private function clearText() : void
      {
         if(this.textFlow)
         {
            this.textFlow.flowComposer.removeAllControllers();
         }
         if(this.content)
         {
            removeChild(this.content);
            this.content = null;
         }
      }
      
      protected function buildText(param1:Number, param2:Number) : void
      {
         this.clearText();
         this.content = new Sprite();
         addChild(this.content);
         var _loc3_:IFlowComposer = this.textFlow.flowComposer;
         var _loc4_:ContainerController = new ContainerController(this.content,param1,param2);
         _loc4_.verticalScrollPolicy = ScrollPolicy.OFF;
         _loc3_.addController(_loc4_);
         _loc3_.updateAllControllers();
      }
      
      override public function get measuredWidth() : uint
      {
         if(layoutW <= 0 && Boolean(this.textFlow))
         {
            VText.checkValidContentSize(this,this.textFlow,(mode & CONTAIN) != 0);
         }
         return super.measuredWidth;
      }
      
      override public function get measuredHeight() : uint
      {
         if(layoutH <= 0 && Boolean(this.textFlow))
         {
            VText.checkValidContentSize(this,this.textFlow,(mode & CONTAIN) != 0);
         }
         return super.measuredHeight;
      }
      
      override protected function calcContentSize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:ContainerController = null;
         var _loc4_:Rectangle = null;
         if(this.textFlow)
         {
            _loc1_ = VText.getComposeW(this,(mode & CONTAIN) != 0);
            _loc2_ = VText.getComposeH(this);
            this.buildText(_loc1_ > 0 ? _loc1_ : NaN,_loc2_ > 0 ? _loc2_ : NaN);
            _loc3_ = this.textFlow.flowComposer.getControllerAt(0);
            contentW = Math.ceil(_loc3_.tlf_internal::contentWidth);
            updateW = _loc1_ > contentW ? _loc1_ : contentW;
            if((mode & LEADING_BOX) != 0)
            {
               _loc4_ = this.content.getRect(null);
               contentH = Math.ceil(_loc4_.height + _loc4_.y);
            }
            else
            {
               contentH = Math.ceil(_loc3_.tlf_internal::contentHeight);
            }
            updateH = _loc2_ > contentH ? _loc2_ : contentH;
         }
      }
      
      override protected function customUpdate() : void
      {
         var _loc1_:ContainerController = null;
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.textFlow)
         {
            this.buildText(w,h);
            if((mode & CONTAIN) != 0)
            {
               _loc1_ = this.textFlow.flowComposer.getControllerAt(0);
               _loc2_ = Math.ceil(_loc1_.tlf_internal::contentWidth);
               if(_loc2_ > w)
               {
                  this.buildText(_loc2_,h);
                  _loc3_ = _loc1_.tlf_internal::contentTop;
                  _loc4_ = this.content.height;
                  VSkin.contain(this.content,w,h,true);
                  this.content.y = Math.ceil(_loc3_ * (1 - this.content.scaleY) + (_loc4_ - this.content.height) / 2);
               }
            }
         }
      }
      
      override public function add(param1:VComponent, param2:Object = null, param3:int = -1) : void
      {
         throw new Error("VLabel no use add method");
      }
      
      override public function remove(param1:VComponent, param2:Boolean = true) : void
      {
         throw new Error("VLabel no use remove method");
      }
   }
}

