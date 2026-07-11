package ui
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import ui.common.HintPanel;
   import ui.load.LoadPanel;
   import ui.vbase.VComponent;
   import ui.vbase.VGradientFill;
   
   public class MainPanel extends VComponent
   {
      
      private var dialogBg:VGradientFill;
      
      private var commonPanel:VComponent;
      
      public const layerPanel:VComponent = new VComponent();
      
      public const infoPanel:Sprite = new Sprite();
      
      public const hintPanel:HintPanel = new HintPanel();
      
      public const dialogPanel:VComponent = new VComponent();
      
      public var loadPanel:VComponent;
      
      public var cursor:Sprite;
      
      public function MainPanel()
      {
         super();
         mouseEnabled = false;
         this.layerPanel.mouseEnabled = false;
         addStretch(this.layerPanel);
         this.infoPanel.mouseEnabled = this.infoPanel.mouseChildren = false;
         addChild(this.infoPanel);
         this.dialogPanel.mouseEnabled = false;
         addStretch(this.dialogPanel);
         addChild(this.hintPanel);
      }
      
      public function applyCursor(param1:Sprite) : void
      {
         if(this.cursor != param1)
         {
            if(this.cursor)
            {
               if(this.cursor.parent)
               {
                  this.cursor.stopDrag();
                  this.infoPanel.removeChild(this.cursor);
               }
               this.cursor = null;
            }
            if(param1)
            {
               this.cursor = param1;
               this.updateCursor();
            }
         }
      }
      
      private function updateCursor() : void
      {
         var _loc1_:Boolean = false;
         if(this.cursor)
         {
            _loc1_ = this.cursor.parent != null;
            if(_loc1_ != (this.dialogPanel.numChildren == 0))
            {
               if(_loc1_)
               {
                  this.infoPanel.removeChild(this.cursor);
                  this.cursor.stopDrag();
               }
               else
               {
                  this.cursor.x = mouseX + 10;
                  this.cursor.y = mouseY + 10;
                  this.infoPanel.addChild(this.cursor);
                  this.cursor.startDrag();
               }
            }
         }
      }
      
      public function showDialog(param1:VComponent, param2:Boolean = false) : void
      {
         if(this.dialogPanel.numChildren > 0)
         {
            if(param2)
            {
               param1.visible = false;
            }
            else
            {
               this.dialogPanel.getChildAt(this.dialogPanel.numChildren - 1).visible = false;
            }
         }
         else
         {
            this.dialogBg = this.createDialogBg();
            this.dialogPanel.addStretch(this.dialogBg,0);
         }
         this.dialogPanel.add(param1,{
            "hCenter":0,
            "vCenter":0
         },param2 ? 1 : this.dialogPanel.numChildren);
         if(Facade.fakeResize && (param1.layoutW > 780 || param1.layoutH > 530))
         {
            param1.x += param1.measuredWidth * 0.075;
            param1.y += param1.measuredHeight * 0.075;
            param1.scaleX = param1.scaleY = 0.85;
         }
         this.updateCursor();
      }
      
      public function createDialogBg() : VGradientFill
      {
         var _loc1_:VGradientFill = new VGradientFill();
         _loc1_.setFill([4210752,0],[0.5,0.5],[0,255],Math.PI / 2);
         _loc1_.mouseEnabled = true;
         return _loc1_;
      }
      
      public function closeDialog(param1:VComponent) : void
      {
         var _loc2_:* = int(this.dialogPanel.numChildren - 1);
         while(_loc2_ > 0)
         {
            if(this.dialogPanel.getChildAt(_loc2_) == param1)
            {
               this.dialogPanel.remove(param1);
               if(this.dialogPanel.numChildren == 1)
               {
                  this.dialogPanel.remove(this.dialogBg);
                  this.dialogBg = null;
                  break;
               }
               this.dialogPanel.getChildAt(this.dialogPanel.numChildren - 1).visible = true;
               break;
            }
            _loc2_--;
         }
         this.updateCursor();
      }
      
      public function showLoadPanel(param1:String = null) : void
      {
         if(!this.loadPanel)
         {
            this.loadPanel = new LoadPanel(param1);
            addStretch(this.loadPanel);
         }
      }
      
      public function hideLoadPanel() : void
      {
         if(this.loadPanel)
         {
            remove(this.loadPanel);
            this.loadPanel = null;
         }
      }
      
      public function showCommonPanel(param1:VComponent) : void
      {
         if(this.commonPanel != param1)
         {
            if(this.commonPanel)
            {
               this.layerPanel.remove(this.commonPanel,false);
            }
            this.commonPanel = param1;
            if(param1.layoutW >= 0)
            {
               param1.stretch();
            }
            this.layerPanel.add(param1,null,0);
         }
      }
      
      public function clearInfoPanel() : void
      {
         var _loc1_:DisplayObject = null;
         this.applyCursor(null);
         while(this.infoPanel.numChildren)
         {
            _loc1_ = this.infoPanel.getChildAt(0);
            if(_loc1_ is VComponent)
            {
               (_loc1_ as VComponent).dispose();
            }
            this.infoPanel.removeChild(_loc1_);
         }
      }
      
      public function addInterLayer(param1:VComponent, param2:Boolean = true, param3:Boolean = true) : void
      {
         if(param3)
         {
            param1.stretch();
         }
         add(param1,null,param2 ? int(getChildIndex(this.layerPanel) + 1) : getChildIndex(this.dialogPanel));
      }
   }
}

