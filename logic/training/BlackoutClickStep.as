package logic.training
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import logic.ErrorLogic;
   import model.ui.VOCallback;
   import ui.MainPanel;
   import ui.common.BaseDialog;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   
   public class BlackoutClickStep extends AbstractTrainStep
   {
      
      public const panel:BlackoutPanel = new BlackoutPanel();
      
      protected var target:VComponent;
      
      private var isBtClick:Boolean;
      
      private var preCallback:VOCallback;
      
      private var isTargetListener:Boolean;
      
      public function BlackoutClickStep(param1:VComponent, param2:Number, param3:Object, param4:VOCallback = null, param5:Boolean = true)
      {
         super();
         this.target = param1;
         this.panel.track(param1,true,param2,param3);
         this.panel.mouseEnabled = true;
         this.panel.addListener(MouseEvent.CLICK,this.onPanelClick);
         this.preCallback = param4;
         this.isBtClick = param5;
         this.setTargetListener(true);
      }
      
      private function setTargetListener(param1:Boolean) : void
      {
         if(param1 != this.isTargetListener)
         {
            this.isTargetListener = param1;
            if(param1)
            {
               this.target.addListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
            }
            else
            {
               this.target.removeListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
            }
         }
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         this.dispose();
      }
      
      override public function run() : void
      {
         if(this.panel.parent)
         {
            return;
         }
         var _loc1_:DisplayObjectContainer = this.target;
         while(Boolean(_loc1_) && !(_loc1_ is BaseDialog))
         {
            _loc1_ = _loc1_.parent;
         }
         var _loc2_:MainPanel = Facade.mainPanel;
         if(_loc1_ is BaseDialog)
         {
            _loc2_.dialogPanel.addStretch(this.panel);
         }
         else
         {
            _loc2_.addStretch(this.panel,_loc2_.getChildIndex(_loc2_.dialogPanel));
         }
      }
      
      private function onPanelClick(param1:MouseEvent) : void
      {
         if(this.target.getRect(this.target.stage).contains(param1.stageX,param1.stageY))
         {
            this.setTargetListener(false);
            if(this.preCallback)
            {
               this.preCallback.apply();
            }
            if(this.isBtClick && this.target is VButton)
            {
               if((this.target as VButton).disabled)
               {
                  ErrorLogic.sendError("BlackoutClickStep button is disabled");
                  this.dispose();
                  return;
               }
               (this.target as VButton).click();
            }
            end();
         }
      }
      
      override public function dispose() : void
      {
         this.setTargetListener(false);
         if(this.panel.parent == Facade.mainPanel.dialogPanel)
         {
            Facade.mainPanel.closeDialog(this.panel);
         }
         else
         {
            this.panel.removeFromParent();
         }
      }
   }
}

