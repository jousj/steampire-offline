package ui.vbase
{
   import flash.display.Sprite;
   import flash.display.StageDisplayState;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.ScrollPolicy;
   import flashx.textLayout.edit.EditManager;
   import flashx.textLayout.edit.ISelectionManager;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.edit.TextScrap;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.FlowOperationEvent;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.operations.DeleteTextOperation;
   import flashx.textLayout.operations.InsertTextOperation;
   import flashx.textLayout.operations.PasteOperation;
   import flashx.textLayout.operations.SplitParagraphOperation;
   
   public class VInputText extends VText
   {
      
      public static const MULTI_LINE:uint = 2048;
      
      public static const BREAK_LINE:uint = 4096;
      
      public static const DIGIT_RESTRICT:uint = 8192;
      
      private static const SCROLL_LINE:uint = MULTI_LINE | BREAK_LINE;
      
      private static const ENTER_EVENT:uint = 16384;
      
      public var restrict:RegExp;
      
      public var maxChars:uint;
      
      private var bgSkin:VSkin;
      
      private var promptSpan:SpanElement;
      
      private const container:Sprite = new Sprite();
      
      public function VInputText(param1:uint = 0, param2:VSkin = null, param3:int = 0, param4:int = 0)
      {
         super(null,param1);
         if((param1 & DIGIT_RESTRICT) != 0)
         {
            this.restrict = /^\d+$/;
         }
         if(param2)
         {
            this.bgSkin = param2;
            addChild(param2);
            param2.left = param2.right = param3;
            param2.top = param2.bottom = param4;
            this.container.x = param3;
            this.container.y = param4;
         }
         addChild(this.container);
         textFlow.interactionManager = new EditManager();
         textFlow.addEventListener(FlowOperationEvent.FLOW_OPERATION_BEGIN,this.onFlowOperationBegin);
         textFlow.addEventListener(FlowOperationEvent.FLOW_OPERATION_END,this.onFlowOperationEnd);
         textFlow.addEventListener(FlowOperationEvent.FLOW_OPERATION_COMPLETE,this.onFlowOperationComplete);
         addListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      override protected function updateMode() : void
      {
         textFlow.lineBreak = (mode & SCROLL_LINE) != 0 ? LineBreak.TO_FIT : LineBreak.EXPLICIT;
         (textFlow.configuration as Configuration).manageEnterKey = (mode & MULTI_LINE) != 0;
      }
      
      public function useEnterEvent() : void
      {
         (textFlow.configuration as Configuration).manageEnterKey = true;
         mode |= ENTER_EVENT;
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            stage.displayState = StageDisplayState.NORMAL;
         }
         if(Boolean(this.promptSpan) && Boolean(this.promptSpan.parent))
         {
            this.value = null;
         }
      }
      
      public function set enabled(param1:Boolean) : void
      {
         mouseChildren = param1;
      }
      
      override public function set value(param1:String) : void
      {
         while(textFlow.numChildren)
         {
            textFlow.removeChildAt(0);
         }
         if(param1)
         {
            if((mode & MULTI_LINE) == 0)
            {
               param1 = param1.replace(/\n/g,"");
            }
            if(this.promptSpan)
            {
               this.setPromptVisible(false);
            }
            this.createNewSpan(param1);
         }
         else if(this.promptSpan)
         {
            this.setPromptVisible(!textFlow.interactionManager.focused);
         }
         syncContentSize(true);
      }
      
      private function createNewSpan(param1:String) : void
      {
         var _loc2_:SpanElement = new SpanElement();
         _loc2_.text = param1;
         this.addNewSpan(_loc2_);
      }
      
      private function addNewSpan(param1:SpanElement) : void
      {
         var _loc2_:ParagraphElement = new ParagraphElement();
         _loc2_.addChild(param1);
         textFlow.addChild(_loc2_);
      }
      
      override public function get value() : String
      {
         return !(this.promptSpan && this.promptSpan.parent) ? textFlow.getText() : "";
      }
      
      public function setSelection(param1:int = -1, param2:int = -1) : void
      {
         var _loc3_:ISelectionManager = textFlow.interactionManager;
         _loc3_.setFocus();
         var _loc4_:uint = uint(textFlow.textLength);
         if(param1 < 0)
         {
            param1 += _loc4_;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 >= _loc4_)
         {
            param1 = _loc4_ > 0 ? int(_loc4_ - 1) : 0;
         }
         if(param2 < 0)
         {
            param2 += _loc4_;
         }
         if(param2 < param1)
         {
            param2 = param1;
         }
         else if(param2 >= _loc4_)
         {
            param2 = _loc4_ > 0 ? int(_loc4_ - 1) : 0;
         }
         _loc3_.selectRange(param1,param2);
         _loc3_.refreshSelection();
      }
      
      public function setPromptData(param1:String, param2:int = -1) : void
      {
         if(param1)
         {
            if(!this.promptSpan)
            {
               this.promptSpan = new SpanElement();
               addListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            }
            if(param2 >= 0)
            {
               this.promptSpan.color = param2;
            }
            this.promptSpan.text = param1;
            if(!textFlow.interactionManager.focused && textFlow.getText().length == 0)
            {
               this.value = null;
            }
         }
         else if(this.promptSpan)
         {
            removeListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            if(this.promptSpan.parent)
            {
               this.promptSpan = null;
               this.value = null;
            }
            else
            {
               this.promptSpan = null;
            }
         }
      }
      
      private function setPromptVisible(param1:Boolean) : void
      {
         if(param1)
         {
            if(!this.promptSpan.parent)
            {
               this.addNewSpan(this.promptSpan);
            }
         }
         else if(this.promptSpan.parent)
         {
            this.promptSpan.parent.removeChild(this.promptSpan);
         }
      }
      
      private function onFocusOut(param1:FocusEvent) : void
      {
         if(textFlow.getText().length == 0)
         {
            this.value = null;
         }
      }
      
      override public function dispose() : void
      {
         textFlow.removeEventListener(FlowOperationEvent.FLOW_OPERATION_BEGIN,this.onFlowOperationBegin);
         textFlow.removeEventListener(FlowOperationEvent.FLOW_OPERATION_END,this.onFlowOperationEnd);
         textFlow.removeEventListener(FlowOperationEvent.FLOW_OPERATION_COMPLETE,this.onFlowOperationComplete);
         textFlow.flowComposer.removeAllControllers();
         super.dispose();
      }
      
      private function onFlowOperationBegin(param1:FlowOperationEvent) : void
      {
         var _loc2_:InsertTextOperation = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:SelectionState = null;
         var _loc6_:int = 0;
         if(param1.operation is InsertTextOperation)
         {
            _loc2_ = param1.operation as InsertTextOperation;
            _loc3_ = _loc2_.text;
            if(this.maxChars > 0)
            {
               _loc4_ = textFlow.getText().length;
               _loc5_ = _loc2_.deleteSelectionState;
               if(_loc5_)
               {
                  _loc4_ -= _loc5_.absoluteEnd - _loc5_.absoluteStart;
               }
               if(_loc4_ == this.maxChars)
               {
                  param1.preventDefault();
               }
               else
               {
                  _loc6_ = _loc3_.length;
                  if(_loc4_ + _loc6_ > this.maxChars)
                  {
                     _loc2_.text = _loc3_.substr(0,this.maxChars - _loc4_);
                  }
               }
            }
         }
         else if(param1.operation is DeleteTextOperation)
         {
            if(textFlow.getText().length == 0)
            {
               param1.preventDefault();
            }
         }
         else if((mode & ENTER_EVENT) != 0 && param1.operation is SplitParagraphOperation)
         {
            param1.preventDefault();
            dispatchEvent(new VEvent(VEvent.SELECT));
         }
      }
      
      private function onFlowOperationEnd(param1:FlowOperationEvent) : void
      {
         var _loc2_:PasteOperation = null;
         var _loc3_:Boolean = false;
         var _loc4_:TextScrap = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:EditManager = null;
         var _loc8_:SelectionState = null;
         if(param1.operation is PasteOperation)
         {
            _loc2_ = param1.operation as PasteOperation;
            _loc3_ = Boolean(this.restrict) || this.maxChars > 0;
            if(!_loc3_ && (mode & MULTI_LINE) != 0)
            {
               return;
            }
            _loc4_ = _loc2_.textScrap;
            if(!_loc4_)
            {
               return;
            }
            _loc5_ = this.extractText(_loc4_.textFlow);
            if(!_loc3_ && _loc5_.indexOf("\n") == -1)
            {
               return;
            }
            _loc6_ = _loc5_.length;
            if((mode & MULTI_LINE) == 0)
            {
               _loc5_ = _loc5_.replace(/\n/g,"");
            }
            _loc7_ = textFlow.interactionManager as EditManager;
            _loc8_ = new SelectionState(_loc2_.textFlow,_loc2_.absoluteStart,_loc2_.absoluteStart + _loc6_);
            _loc7_.deleteText(_loc8_);
            _loc8_ = new SelectionState(_loc2_.textFlow,_loc2_.absoluteStart,_loc2_.absoluteStart);
            _loc7_.insertText(_loc5_,_loc8_);
         }
      }
      
      private function extractText(param1:TextFlow) : String
      {
         var _loc4_:ParagraphElement = null;
         var _loc2_:String = "";
         var _loc3_:FlowLeafElement = param1.getFirstLeaf();
         while(_loc3_)
         {
            _loc4_ = _loc3_.getParagraph();
            do
            {
               _loc2_ += _loc3_.text;
               _loc3_ = _loc3_.getNextLeaf(_loc4_);
            }
            while(_loc3_);
            _loc3_ = _loc4_.getLastLeaf().getNextLeaf(null);
            if(_loc3_)
            {
               _loc2_ += "\n";
            }
         }
         return _loc2_;
      }
      
      private function onFlowOperationComplete(param1:FlowOperationEvent) : void
      {
         dispatcher.dispatchEvent(new VEvent(VEvent.CHANGE));
      }
      
      override protected function buildText(param1:Number, param2:Number) : void
      {
         var _loc3_:ContainerController = null;
         if(this.bgSkin)
         {
            param1 -= this.bgSkin.hPadding;
            param2 -= this.bgSkin.vPadding;
         }
         if(textFlow.flowComposer.numControllers == 0)
         {
            _loc3_ = new ContainerController(this.container,param1,param2);
            _loc3_.verticalScrollPolicy = (mode & SCROLL_LINE) != 0 ? ScrollPolicy.ON : ScrollPolicy.OFF;
            textFlow.flowComposer.addController(_loc3_);
         }
         else
         {
            _loc3_ = textFlow.flowComposer.getControllerAt(0);
            _loc3_.setCompositionSize(param1,param2);
         }
         textFlow.flowComposer.updateAllControllers();
      }
      
      override protected function calcContentSize() : void
      {
         super.calcContentSize();
         if(this.bgSkin)
         {
            contentW += this.bgSkin.hPadding;
            if(contentW > updateW)
            {
               updateW = contentW;
            }
            contentH += this.bgSkin.vPadding;
            if(contentH > updateH)
            {
               updateH = contentH;
            }
         }
      }
      
      override public function updatePhase(param1:Boolean = false) : void
      {
         super.updatePhase(param1);
         if(Boolean(this.bgSkin) && (this.bgSkin.w != w || this.bgSkin.h != h))
         {
            this.bgSkin.setGeometrySize(w,h,false);
         }
      }
   }
}

