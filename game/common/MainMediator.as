package game.common
{
   import engine.signal.Signal;
   import engine.signal.Tween;
   import engine.units.Unit;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import game.admin.UidDialog;
   import game.battle.common.InfoTimerPanel;
   import logic.CoreLogic;
   import logic.ErrorLogic;
   import logic.MainLogic;
   import model.CommonEvent;
   import ui.MainPanel;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.HintPanel;
   import ui.common.MessageDialog;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VInputText;
   import ui.vbase.VLabel;
   import ui.vbase.VScrollBar;
   import ui.vbase.VScrollLabel;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class MainMediator
   {
      
      private var mainPanel:MainPanel;
      
      private var hintPanel:HintPanel;
      
      private var tempHint:Object;
      
      private var infoTimerPanel:InfoTimerPanel;
      
      private var flMessageTime:Number = 0;
      
      public function MainMediator()
      {
         super();
         this.mainPanel = Facade.mainPanel;
         this.hintPanel = this.mainPanel.hintPanel;
         this.mainPanel.stage.addEventListener(Event.MOUSE_LEAVE,this.onMouseLeave);
         this.mainPanel.addEventListener(MouseEvent.ROLL_OVER,this.onMouseLeave);
         this.mainPanel.stage.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.mainPanel.stage.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.mainPanel.stage.addEventListener(MouseEvent.CLICK,this.onClick);
         this.mainPanel.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         Facade.board.contextMenu = new ContextMenu();
         var _loc1_:ContextMenuItem = new ContextMenuItem("user id",true);
         _loc1_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onUID);
         Facade.board.contextMenu.customItems.push(_loc1_);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.target is VButton)
         {
            if(this.hintPanel.target == param1.target)
            {
               this.hintPanel.applyContent(null);
            }
            Facade.audioProxy.playTrack("button_click");
         }
      }
      
      public function clear() : void
      {
         if(Facade.commonHash[this])
         {
            this.onInfoMessageTween(Facade.commonHash[this],3);
         }
         this.mainPanel.clearInfoPanel();
         if(this.hintPanel.target)
         {
            this.hintPanel.applyContent(null);
         }
         this.closeAllDialog();
         this.setRestartTime(0);
      }
      
      private function onMouseLeave(param1:Event) : void
      {
         if(this.mainPanel.cursor)
         {
            this.mainPanel.cursor.visible = param1.type != Event.MOUSE_LEAVE;
         }
         if(this.hintPanel.target)
         {
            this.hintPanel.applyContent(null);
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(param1.target is VComponent)
         {
            this.tempHint = (param1.target as VComponent).getHintData();
            if(this.tempHint)
            {
               this.hintPanel.applyContent(this.tempHint,param1.target);
               this.tempHint = null;
            }
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         if(this.hintPanel.target == param1.target)
         {
            this.hintPanel.applyContent(null);
         }
      }
      
      public function setHint(param1:Object, param2:Object) : void
      {
         if(param2 != null)
         {
            this.hintPanel.applyContent(param2,param1);
         }
         else if(this.hintPanel.target == param1)
         {
            this.hintPanel.applyContent(null);
         }
      }
      
      public function syncHint(param1:VComponent) : void
      {
         if(!param1)
         {
            if(!(this.hintPanel.target is VComponent))
            {
               return;
            }
            param1 = this.hintPanel.target as VComponent;
         }
         if(this.hintPanel.target == param1)
         {
            this.hintPanel.applyContent(param1.getHintData(),param1);
         }
      }
      
      public function showDialog(param1:Object, param2:Boolean = false) : BaseDialog
      {
         var _loc3_:BaseDialog = null;
         this.useAnimationPause(true);
         if(param1 is DialogMediator)
         {
            _loc3_ = (param1 as DialogMediator).onAdd();
            if(_loc3_)
            {
               _loc3_.mediator = param1;
            }
         }
         else
         {
            _loc3_ = param1 as BaseDialog;
         }
         if(_loc3_)
         {
            _loc3_.addListener(VEvent.CLOSE_DIALOG,this.onCloseDialog);
            this.mainPanel.showDialog(_loc3_,param2);
            Facade.audioProxy.play("dialog_open");
            Facade.dispatchCommonEvent(CommonEvent.SHOW_DIALOG,_loc3_);
         }
         return _loc3_;
      }
      
      private function onCloseDialog(param1:Object) : void
      {
         var _loc2_:BaseDialog = null;
         if(param1 is VEvent)
         {
            _loc2_ = (param1 as VEvent).currentTarget as BaseDialog;
            Facade.audioProxy.play("dialog_close");
         }
         else
         {
            _loc2_ = param1 as BaseDialog;
         }
         if(_loc2_.mediator is DialogMediator)
         {
            (_loc2_.mediator as DialogMediator).onRemove();
         }
         this.mainPanel.closeDialog(_loc2_);
         this.useAnimationPause(false);
      }
      
      private function useAnimationPause(param1:Boolean) : void
      {
         var _loc2_:Unit = null;
         var _loc3_:VComponent = null;
         if((Facade.isMyMap || Facade.isCapital) && this.mainPanel.dialogPanel.numChildren == 0)
         {
            CoreLogic.pause = param1;
            for each(_loc2_ in Facade.userProxy.constructionHash)
            {
               _loc3_ = _loc2_.getProgress();
               if(_loc3_)
               {
                  _loc3_.visible = !param1 && _loc2_.display.visible;
               }
            }
         }
      }
      
      public function closeAllDialog() : void
      {
         var _loc3_:BaseDialog = null;
         var _loc1_:VComponent = this.mainPanel.dialogPanel;
         var _loc2_:* = int(_loc1_.numChildren - 1);
         while(_loc2_ > 0)
         {
            _loc3_ = _loc1_.getChildAt(_loc2_) as BaseDialog;
            if(_loc3_)
            {
               this.onCloseDialog(_loc3_);
            }
            _loc2_--;
         }
      }
      
      public function searchDialog(param1:*, param2:Boolean = false) : *
      {
         var _loc6_:BaseDialog = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc3_:Boolean = param1 is Class;
         var _loc4_:VComponent = this.mainPanel.dialogPanel;
         var _loc5_:* = int(_loc4_.numChildren - 1);
         while(_loc5_ > 0)
         {
            _loc6_ = _loc4_.getChildAt(_loc5_) as BaseDialog;
            if(_loc6_)
            {
               _loc7_ = false;
               if(_loc3_)
               {
                  _loc8_ = _loc6_ is param1;
                  _loc7_ = (_loc8_) || _loc6_.mediator is param1;
               }
               else
               {
                  _loc7_ = _loc6_.mediator === param1;
               }
               if(_loc7_)
               {
                  if(!param2)
                  {
                     return !_loc3_ || _loc8_ ? _loc6_ : _loc6_.mediator;
                  }
                  _loc6_.close();
               }
            }
            _loc5_--;
         }
         return null;
      }
      
      public function showMessage(param1:String, param2:String = null, param3:VComponent = null, param4:uint = 0, param5:String = null) : BaseDialog
      {
         param4 |= MessageDialog.ADD_OK_BUTTON;
         return this.showDialog(new MessageDialog(param1,param2,param3,param4,param5));
      }
      
      public function showYesNoDialog(param1:String, param2:Function, param3:Array = null, param4:String = null, param5:VComponent = null, param6:uint = 0, param7:Function = null) : void
      {
         var _loc8_:MessageDialog = new MessageDialog(param1,param4,param5,param6);
         _loc8_.addYesNoButton(param2,param3,param7);
         this.showDialog(_loc8_);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.target.parent is VInputText)
         {
            return;
         }
         if(param1.ctrlKey && param1.keyCode == 69)
         {
            this.showDebugInfo("Proto",Facade.protoProxy.logs.join("\n"),400,400);
         }
      }
      
      private function addFlightText(param1:String, param2:uint, param3:uint, param4:uint = 18) : VText
      {
         var _loc5_:VText = new VText(param1,VText.CENTER,param2,param4);
         _loc5_.maxW = 500;
         _loc5_.geometryPhase();
         _loc5_.filters = [new GlowFilter(param3,1,4,4,6)];
         this.mainPanel.infoPanel.addChild(_loc5_);
         return _loc5_;
      }
      
      public function flightMessage(param1:String, param2:Boolean = true) : void
      {
         if(param2)
         {
            if(CoreLogic.serverTime - this.flMessageTime < 0.5)
            {
               return;
            }
            this.flMessageTime = CoreLogic.serverTime;
         }
         var _loc3_:VText = this.addFlightText(param1,16711680,16777215);
         _loc3_.x = Math.round((this.mainPanel.w - _loc3_.w) / 2);
         _loc3_.y = Math.round((this.mainPanel.h - _loc3_.h) / 2) + 50;
         var _loc4_:Tween = new Tween(_loc3_);
         _loc4_.stopHandler = this.onKillMessage;
         _loc4_.play(["y",_loc3_.y - 110,"alpha",0.2],3);
      }
      
      private function onKillMessage(param1:Tween) : void
      {
         (param1.target as VComponent).removeFromParent();
      }
      
      public function flightUnitMessage(param1:String, param2:uint, param3:uint, param4:Unit = null) : void
      {
         var _loc7_:Point = null;
         if(param4)
         {
            if(!param4.display.visible)
            {
               return;
            }
            _loc7_ = param4.display.localToGlobal(new Point(param4.iconX,param4.iconY));
         }
         else
         {
            _loc7_ = new Point(this.mainPanel.mouseX,this.mainPanel.mouseY);
         }
         var _loc5_:VText = this.addFlightText(param1,param2,param3);
         _loc5_.x = Math.round(_loc7_.x - _loc5_.w / 2);
         _loc5_.y = Math.round(_loc7_.y) - 20;
         var _loc6_:Tween = new Tween(_loc5_);
         _loc6_.stopHandler = this.onKillMessage;
         _loc6_.play(["y",_loc5_.y - 110,"alpha",0.2],3);
      }
      
      public function flightGlobalMessage(param1:String, param2:Number = 8.2) : void
      {
         var _loc3_:Tween = Facade.commonHash[this];
         if(_loc3_)
         {
            _loc3_.stop();
            (_loc3_.target as VComponent).removeFromParent();
         }
         var _loc4_:VLabel = new VLabel("<p" + Style.yellowColor + ">" + param1 + "</p>",VLabel.CENTER);
         _loc4_.geometryPhase();
         Style.applyDefaultFilter(_loc4_);
         _loc4_.x = Math.round((this.mainPanel.w - _loc4_.w) / 2);
         _loc4_.y = 170;
         this.mainPanel.infoPanel.addChild(_loc4_);
         _loc3_ = new Tween(_loc4_,this.onInfoMessageTween);
         _loc3_.data = param2;
         Facade.commonHash[this] = _loc3_;
         _loc3_.play(["alpha",0,1],0.4);
      }
      
      private function onInfoMessageTween(param1:Tween, param2:uint = 0) : void
      {
         if(param2 == 0)
         {
            param2 = param1.step;
         }
         if(param2 == 1)
         {
            param1.wait(param1.data);
         }
         else if(param2 == 2)
         {
            param1.revert();
         }
         else
         {
            (param1.target as VComponent).removeFromParent();
            delete Facade.commonHash[this];
         }
      }
      
      private function onUID(param1:ContextMenuEvent) : void
      {
         this.showDialog(new UidDialog());
      }
      
      public function showDebugInfo(param1:String, param2:String, param3:int, param4:int) : void
      {
         var _loc5_:BaseDialog = new BaseDialog();
         _loc5_.useWhiteBg(param3,param4,param1);
         var _loc6_:VScrollBar = UIFactory.createScrollBar();
         _loc5_.add(new VScrollLabel(_loc6_,"<div fontSize=\"14\" fontFamily=\"Myriad Pro\">" + param2 + "</div>",VScrollLabel.SELECTION_MODE),{
            "left":20,
            "top":78,
            "right":45,
            "bottom":18
         });
         _loc5_.add(_loc6_,{
            "top":76,
            "right":18,
            "bottom":18
         });
         _loc6_.changeButtonSize(18);
         this.showDialog(_loc5_);
      }
      
      public function setRestartTime(param1:Number) : void
      {
         if(param1 > 0 != Boolean(this.infoTimerPanel))
         {
            if(param1 > 0)
            {
               this.infoTimerPanel = new InfoTimerPanel(Lang.getString("restart_time"),34);
               this.infoTimerPanel.add(SkinManager.getEmbed("BoardMoveBg",VSkin.STRETCH_BG),{
                  "left":-7,
                  "top":-5,
                  "right":-7,
                  "bottom":-3
               },0);
               this.mainPanel.add(this.infoTimerPanel,{
                  "top":112,
                  "h":60
               },this.mainPanel.getChildIndex(this.hintPanel));
            }
            else
            {
               Signal.stopRef(this.infoTimerPanel);
               this.mainPanel.remove(this.infoTimerPanel);
               this.infoTimerPanel = null;
            }
         }
         if(param1 > 0)
         {
            Signal.createRef(this.infoTimerPanel,this.onRestartSignal,Signal.ADD_TIMER).run(0,param1,true);
         }
      }
      
      private function onRestartSignal(param1:Signal) : void
      {
         if(param1.tail > 0)
         {
            this.infoTimerPanel.valueText.value = StringHelper.getTimeDesc(param1.tail);
         }
         else
         {
            this.mainPanel.hideLoadPanel();
            MainLogic.free(false,null,true);
            this.showMessage(Lang.getString("restart_now")).addListener(VEvent.CLOSE_DIALOG,this.onRestartClose);
         }
      }
      
      private function onRestartClose(param1:VEvent) : void
      {
         ErrorLogic.onReload(true);
      }
   }
}

