package engine.units
{
   import engine.display.Animation;
   import flash.display.MovieClip;
   import game.board.UnitMenuPanel;
   import logic.units.AbstractJob;
   import logic.units.AbstractLogic;
   import model.CommonEvent;
   import ui.game.ClipPanel;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class Unit extends ZObject
   {
      
      public static const boomHash:Object = {};
      
      public static const pointHash:Object = {};
      
      private static var uiScale:Number = 1;
      
      private var menuPanel:UnitMenuPanel;
      
      private var progressBar:VComponent;
      
      private var statusIcon:VComponent;
      
      private var uiBox:VBox;
      
      private var isScaleListener:Boolean;
      
      public var stamina:uint;
      
      public var armor:uint;
      
      public var id:uint;
      
      public var logic:AbstractLogic;
      
      public var level:uint;
      
      public var job:AbstractJob;
      
      public var boomList:Vector.<int>;
      
      public function Unit()
      {
         super();
      }
      
      public static function changeBoardScale(param1:Number) : void
      {
         uiScale = (1 - (1 - param1) / 2) / param1;
         Facade.dispatchCommonEvent(CommonEvent.BOARD_SCALE);
      }
      
      override public function dispose() : void
      {
         if(this.uiBox)
         {
            this.removeUIBox();
            this.statusIcon = null;
            this.progressBar = null;
         }
         this.setMenu(null);
         this.stopJob();
         this.logic = null;
         super.dispose();
      }
      
      override protected function syncIconPos(param1:Animation) : Boolean
      {
         if(super.syncIconPos(param1))
         {
            if(this.isScaleListener)
            {
               this.syncUIPos();
            }
            return true;
         }
         return false;
      }
      
      private function syncScaleListener() : void
      {
         var _loc1_:Boolean = Boolean(this.uiBox) || Boolean(this.menuPanel);
         if(_loc1_ != this.isScaleListener)
         {
            this.isScaleListener = _loc1_;
            if(_loc1_)
            {
               Facade.addListener(CommonEvent.BOARD_SCALE,this.onBoardScale);
            }
            else
            {
               Facade.removeListener(CommonEvent.BOARD_SCALE,this.onBoardScale);
            }
         }
      }
      
      private function removeUIBox() : void
      {
         display.removeChild(this.uiBox);
         this.uiBox.dispose();
         this.uiBox = null;
         this.syncScaleListener();
      }
      
      private function addUI(param1:VComponent, param2:int = -1) : void
      {
         if(!this.uiBox)
         {
            this.uiBox = new VBox(null,2,VBox.VERTICAL);
            this.uiBox.mouseEnabled = false;
            this.uiBox.geometryPhase();
            this.uiBox.scaleY = this.uiBox.scaleX = uiScale;
            display.addChild(this.uiBox);
            this.syncScaleListener();
         }
         this.uiBox.add(param1,null,param2);
      }
      
      private function removeUI(param1:VComponent, param2:Boolean = true) : void
      {
         this.uiBox.remove(param1,param2);
         if(this.uiBox.list.length == 0)
         {
            this.removeUIBox();
         }
      }
      
      public function setMenu(param1:UnitMenuPanel) : void
      {
         if(param1)
         {
            this.menuPanel = param1;
            this.menuPanel.scaleY = this.menuPanel.scaleX = uiScale;
            this.syncUIPos();
         }
         else if(this.menuPanel)
         {
            this.menuPanel.removeFromParent(false);
            this.menuPanel = null;
         }
         this.syncScaleListener();
      }
      
      public function setProgress(param1:VComponent, param2:Boolean = false) : void
      {
         if(param1 != this.progressBar)
         {
            if(param1)
            {
               this.addUI(param1);
            }
            if(param2 && Boolean(this.statusIcon))
            {
               this.removeUI(this.statusIcon);
               this.statusIcon = null;
            }
            if(this.progressBar)
            {
               this.removeUI(this.progressBar);
            }
            this.progressBar = param1;
            if(Boolean(param1) && !display.visible)
            {
               param1.visible = false;
            }
            this.syncUIPos();
         }
      }
      
      public function clearProgress(param1:Boolean = true) : void
      {
         if(this.progressBar)
         {
            this.removeUI(this.progressBar,param1);
            this.progressBar = null;
            this.syncUIPos();
         }
      }
      
      public function getProgress() : VComponent
      {
         return this.progressBar;
      }
      
      public function setStatus(param1:VComponent, param2:Boolean = false) : void
      {
         if(param1 != this.statusIcon)
         {
            if(param1)
            {
               this.addUI(param1,Boolean(this.progressBar) && !param2 ? this.progressBar.parent.getChildIndex(this.progressBar) : -1);
            }
            if(param2 && Boolean(this.progressBar))
            {
               this.removeUI(this.progressBar);
               this.progressBar = null;
            }
            if(this.statusIcon)
            {
               this.removeUI(this.statusIcon);
            }
            this.statusIcon = param1;
            if(param1)
            {
               this.syncStatusVisible();
            }
            this.syncUIPos();
         }
      }
      
      public function get isStatus() : Boolean
      {
         return this.statusIcon != null;
      }
      
      public function getStatus() : VComponent
      {
         return this.statusIcon;
      }
      
      public function assignJob(param1:AbstractJob) : void
      {
         if(this.job)
         {
            this.job.stop();
         }
         this.job = param1;
         param1.assignTarget(this);
         param1.start();
      }
      
      public function stopJob() : void
      {
         if(this.job)
         {
            this.job.stop();
            this.job = null;
         }
      }
      
      override public function toString() : String
      {
         return kind + "(id=" + this.id + ")";
      }
      
      private function onBoardScale(param1:CommonEvent) : void
      {
         if(this.uiBox)
         {
            this.uiBox.scaleY = this.uiBox.scaleX = uiScale;
         }
         if(this.menuPanel)
         {
            this.menuPanel.scaleY = this.menuPanel.scaleX = uiScale;
         }
         this.syncUIPos();
      }
      
      private function syncUIPos() : void
      {
         if(this.uiBox)
         {
            this.uiBox.x = Math.round(iconX - this.uiBox.w * this.uiBox.scaleX / 2);
            this.uiBox.y = Math.round(iconY - this.uiBox.h * this.uiBox.scaleY - 2);
         }
         if(this.menuPanel)
         {
            this.menuPanel.posX = display.x + iconX;
            this.menuPanel.posY = display.y + iconY;
            if(this.uiBox)
            {
               this.menuPanel.posY -= Math.round((this.uiBox.h + this.uiBox.gap) * this.uiBox.scaleY);
            }
            this.menuPanel.syncPos();
         }
      }
      
      override protected function changeDisplayVisible(param1:Boolean) : void
      {
         display.visible = param1;
         if(this.statusIcon)
         {
            this.syncStatusVisible();
         }
         if(this.progressBar)
         {
            this.progressBar.visible = param1;
         }
      }
      
      private function syncStatusVisible() : void
      {
         if(this.statusIcon is VSkin)
         {
            if((this.statusIcon as VSkin).content is MovieClip)
            {
               (this.statusIcon as VSkin).contentPlay(display.visible);
            }
         }
         else if(this.statusIcon is ClipPanel)
         {
            (this.statusIcon as ClipPanel).clip.pause = !display.visible;
         }
      }
   }
}

