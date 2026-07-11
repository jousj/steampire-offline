package ui.vbase
{
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.ScrollPolicy;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.elements.TextFlow;
   
   public class VScrollLabel extends VLabel
   {
      
      public static const SELECTION_MODE:uint = 2048;
      
      public static const USE_MANUAL_SCROLL:uint = 4096;
      
      public static const USE_BAR_VISIBLE:uint = 8192;
      
      private var scrollBar:VScrollBar;
      
      private var minShift:uint;
      
      public function VScrollLabel(param1:VScrollBar, param2:String = null, param3:uint = 0, param4:uint = 18)
      {
         this.scrollBar = param1;
         this.minShift = param4;
         param1.addListener(VEvent.SCROLL,this.setScroll);
         super(param2,param3);
         if((param3 & SELECTION_MODE) != 0)
         {
            mouseChildren = true;
         }
      }
      
      public function getTextFlow() : TextFlow
      {
         return textFlow;
      }
      
      override public function set text(param1:String) : void
      {
         super.text = param1;
         if(textFlow)
         {
            if((mode & SELECTION_MODE) != 0)
            {
               textFlow.interactionManager = new SelectionManager();
            }
         }
      }
      
      override protected function buildText(param1:Number, param2:Number) : void
      {
         super.buildText(param1,param2);
         if(textFlow)
         {
            textFlow.flowComposer.getControllerAt(0).verticalScrollPolicy = ScrollPolicy.ON;
         }
         this.updateScroll();
      }
      
      public function getScrollHeight() : Number
      {
         var _loc2_:ContainerController = null;
         var _loc1_:Number = 0;
         if(Boolean(textFlow) && isGeometryPhase)
         {
            _loc2_ = textFlow.flowComposer.getControllerAt(0);
            if(_loc2_)
            {
               textFlow.flowComposer.composeToPosition();
               _loc1_ = _loc2_.getScrollDelta(textFlow.flowComposer.numLines);
               if(_loc1_ < 0)
               {
                  _loc1_ = 0;
               }
            }
         }
         return _loc1_;
      }
      
      private function updateScroll() : void
      {
         var _loc1_:uint = 0;
         if((mode & USE_MANUAL_SCROLL) == 0)
         {
            _loc1_ = h + this.getScrollHeight();
            this.scrollBar.setEnv(h,_loc1_,this.scrollBar.value,this.minShift);
            if((mode & USE_BAR_VISIBLE) != 0)
            {
               this.scrollBar.visible = h < _loc1_;
            }
         }
      }
      
      public function setScroll(param1:Object) : void
      {
         if(Boolean(textFlow) && textFlow.flowComposer.numControllers > 0)
         {
            textFlow.flowComposer.getControllerAt(0).verticalScrollPosition = param1 is VEvent ? Number((param1 as VEvent).data) : Number(param1);
            textFlow.flowComposer.updateToController(0);
         }
      }
      
      public function getScrollBar() : VScrollBar
      {
         return this.scrollBar;
      }
   }
}

