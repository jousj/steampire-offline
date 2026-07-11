package game.battle
{
   import engine.signal.Signal;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import game.battle.common.InfoTimerPanel;
   import game.battle.common.TimerPanel;
   import game.battle.common.WinTargetRenderer;
   import game.battle.drop.DropPanel;
   import model.ui.VOBattleItem;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VGradientFill;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class BattlePanel extends VComponent
   {
      
      public const dropPanel:DropPanel = new DropPanel();
      
      public const timerPanel:TimerPanel = new TimerPanel();
      
      public const soldierCursor:VSkin = new VSkin(VSkin.NO_STRETCH);
      
      private const waitTimerPanel:InfoTimerPanel = new InfoTimerPanel(null);
      
      private const moveCursor:VSkin = SkinManager.getEmbed("MoveMode",VSkin.CACHE_AS_BITMAP);
      
      private var winSignal:Signal;
      
      private var winHandler:Function;
      
      private var winArgs:Array;
      
      private var isWaitTimer:Boolean;
      
      private var winTargetPanel:VComponent;
      
      private var winTargetGrid:VGrid;
      
      public var stormPanel:VComponent;
      
      public var isCursor:Boolean;
      
      public var isLanding:Boolean = true;
      
      public function BattlePanel()
      {
         super();
         stretch();
         this.dropPanel.assignLayout({
            "bottom":0,
            "left":10,
            "right":10
         });
         this.timerPanel.left = 6;
         this.timerPanel.top = 90;
         this.waitTimerPanel.top = 106;
         this.waitTimerPanel.layoutH = 74;
         this.moveCursor.setGeometrySize(24,24,true);
      }
      
      public function changeTimer(param1:Boolean, param2:uint = 0) : void
      {
         this.isWaitTimer = param2 > 0;
         if(this.isWaitTimer)
         {
            this.waitTimerPanel.titleText.value = Lang.getString(param2 == 1 ? "battle_start" : "battle_finish");
         }
         if((param1 && this.isWaitTimer) != Boolean(this.waitTimerPanel.parent))
         {
            if(this.waitTimerPanel.parent)
            {
               removeChild(this.waitTimerPanel);
            }
            else
            {
               add(this.waitTimerPanel);
            }
         }
         if((param1 && !this.isWaitTimer) != Boolean(this.timerPanel.parent))
         {
            if(this.timerPanel.parent)
            {
               removeChild(this.timerPanel);
            }
            else
            {
               add(this.timerPanel);
            }
         }
         if(this.winTargetPanel)
         {
            this.syncWinTargetPos();
         }
      }
      
      public function updateTime(param1:Number) : void
      {
         if(this.isWaitTimer)
         {
            this.waitTimerPanel.valueText.value = StringHelper.getTimeFormat(param1);
         }
         else
         {
            this.timerPanel.value = StringHelper.getTimeFormat(param1 - 6);
         }
      }
      
      public function setWinTarget(param1:Array, param2:Function) : void
      {
         var _loc3_:VComponent = null;
         if(this.winTargetPanel)
         {
            remove(this.winTargetPanel);
            this.winTargetPanel = null;
            this.winTargetGrid = null;
         }
         if(Boolean(param1) && param1.length > 0)
         {
            _loc3_ = new VComponent();
            _loc3_.addStretch(SkinManager.getEmbed("UnitPanelBg",VSkin.STRETCH_BG));
            _loc3_.add(UIFactory.createYellowText(Lang.getString("mission_target"),VText.CONTAIN_CENTER,14,true),{
               "left":5,
               "right":5,
               "top":8
            });
            this.winTargetGrid = new VGrid(1,6,WinTargetRenderer,param1,0,4,VGrid.USE_VISIBLE_CALC_LAYOUT);
            this.winTargetGrid.addListener(VEvent.SELECT,param2);
            _loc3_.add(this.winTargetGrid,{
               "top":28,
               "bottom":8,
               "hCenter":0
            });
            add(_loc3_,{
               "w":90,
               "left":10
            });
            this.winTargetPanel = _loc3_;
            this.syncWinTargetPos();
         }
         if(!this.winTargetGrid || !param1 || param1.length == 0)
         {
            this.timerPanel.left = 6;
         }
      }
      
      private function syncWinTargetPos() : void
      {
         this.winTargetPanel.y = this.winTargetPanel.top = 96;
         this.timerPanel.left = 110;
      }
      
      public function syncWinTargets() : void
      {
         if(this.winTargetGrid)
         {
            this.winTargetGrid.sync();
         }
      }
      
      public function showStormPanel(param1:Function = null, param2:int = 0, param3:int = 0) : void
      {
         var _loc6_:VSkin = null;
         var _loc7_:RectButton = null;
         this.hideStormPanel();
         this.stormPanel = new VComponent();
         this.stormPanel.minW = 500;
         this.stormPanel.addStretch(SkinManager.getEmbed("DarkPanelBg",VSkin.STRETCH));
         var _loc4_:VSkin = new VSkin();
         var _loc5_:VText = UIFactory.createYellowText(null,VText.CENTER | VText.MIDDLE);
         this.stormPanel.add(_loc4_,{
            "left":12,
            "vCenter":0,
            "w":43,
            "h":43
         });
         this.stormPanel.add(_loc5_,{
            "left":60,
            "right":12,
            "vCenter":-1,
            "maxW":564,
            "h":40
         });
         if(param1 != null)
         {
            if(param2 >= param3)
            {
               SkinManager.applyEmbed(_loc4_,"BarrackIcon");
               _loc5_.value = Lang.getPatternString("storm_prompt","__COUNT__",Facade.references.wp_wave_members_count.toString());
               _loc6_ = SkinManager.getEmbed("Energy");
               _loc6_.layoutW = 25;
               _loc7_ = new RectButton(new VBox(new <VComponent>[UIFactory.createYellowText(Lang.getString("to_mission"),VText.CONTAIN,16).assignMaxW(70),_loc6_,UIFactory.createYellowText(Facade.references.enter_storm_price.value.toString(),0,16)]),RectButton.h42);
               _loc7_.addClickListener(param1);
               this.stormPanel.add(_loc7_,{
                  "hCenter":0,
                  "bottom":-27
               });
            }
            else
            {
               SkinManager.applyEmbed(_loc4_,"ArmyCapacityIcon");
               _loc5_.value = Lang.getPatternString("storm_need","__COUNT__",param2 + "/" + param3);
            }
         }
         else if(param2 < 0)
         {
            SkinManager.applyEmbed(_loc4_,"AttentionStatus");
            _loc5_.value = Lang.getString("storm_observer");
         }
         else
         {
            SkinManager.applyEmbed(_loc4_,"ClockIcon");
            _loc5_.value = Lang.getString("storm_lock");
         }
         add(this.stormPanel,{
            "bottom":30,
            "hCenter":0,
            "h":60
         });
         this.stormPanel.cacheAsBitmap = true;
      }
      
      public function hideWinTargetPanel() : void
      {
         if(this.winTargetPanel)
         {
            this.winTargetPanel.removeFromParent();
         }
         this.timerPanel.left = 6;
      }
      
      public function hideStormPanel() : void
      {
         if(this.stormPanel)
         {
            remove(this.stormPanel);
            this.stormPanel = null;
         }
      }
      
      public function useDropPanel(param1:Boolean) : void
      {
         if(param1 != Boolean(this.dropPanel.parent))
         {
            if(param1)
            {
               add(this.dropPanel);
            }
            else
            {
               this.dropPanel.reset();
               remove(this.dropPanel,false);
            }
         }
      }
      
      public function clear() : void
      {
         this.dropPanel.clear();
         this.useDropPanel(false);
         removeFromParent(false);
         this.isLanding = this.isCursor = false;
      }
      
      public function syncCursor(param1:VOBattleItem) : void
      {
         Facade.mainPanel.applyCursor(this.isCursor ? (Boolean(param1) && (Boolean(this.isLanding) || Boolean(param1.spellShop)) ? this.soldierCursor : this.moveCursor) : null);
      }
      
      public function showWinPanel(param1:Function, param2:Array, param3:Number = 0) : void
      {
         this.winHandler = param1;
         this.winArgs = param2;
         var _loc4_:VGradientFill = Facade.mainPanel.createDialogBg();
         add(_loc4_,{
            "hCenter":0,
            "w":-120,
            "h":-100
         });
         if(param3 > 0)
         {
            _loc4_.alpha = 0;
            this.winSignal = new Signal(this.onFillSignal);
            this.winSignal.data = _loc4_;
            this.winSignal.delay = 0.02;
            this.winSignal.run(param3);
         }
         else
         {
            this.winSignal = new Signal();
            this.showEmblem(_loc4_);
         }
      }
      
      private function onFillSignal() : void
      {
         var _loc1_:VGradientFill = this.winSignal.data;
         _loc1_.alpha = this.winSignal.passedRate;
         if(this.winSignal.tail == 0)
         {
            this.showEmblem(_loc1_);
         }
      }
      
      private function showEmblem(param1:VGradientFill) : void
      {
         var _loc2_:VComponent = new VComponent();
         _loc2_.addStretch(SkinManager.getPack("VictoryAnim","VictoryAnimRus",VSkin.PLAY_MOVIE_CLIP | VSkin.ZERO_CENTER));
         _loc2_.add(SkinManager.getPack("VictoryAnim","victoryText" + Lang.locale),{
            "hCenter":10,
            "top":173
         });
         add(_loc2_,{
            "vCenter":0,
            "hCenter":0
         });
         this.winSignal.handler = this.onWinEmblemStop;
         this.winSignal.data = [_loc2_,param1];
         this.winSignal.delay = 2.2;
         this.winSignal.run(2.2);
      }
      
      private function onWinEmblemStop() : void
      {
         var _loc1_:VComponent = null;
         var _loc2_:VGradientFill = null;
         if(this.winSignal.tail == 0)
         {
            _loc1_ = this.winSignal.data[0];
            _loc1_.blendMode = BlendMode.LAYER;
            _loc2_ = this.winSignal.data[1];
            this.winSignal.handler = this.onEmblemFade;
            this.winSignal.data = [_loc1_,_loc2_];
            this.winSignal.delay = 0.02;
            this.winSignal.run(0.2);
         }
      }
      
      private function onEmblemFade() : void
      {
         var _loc2_:VGradientFill = null;
         var _loc1_:VComponent = this.winSignal.data[0];
         _loc1_.alpha = 1 - this.winSignal.passedRate / 2;
         if(this.winSignal.tail == 0)
         {
            _loc2_ = this.winSignal.data[1];
            _loc1_.removeFromParent();
            if(_loc2_)
            {
               _loc2_.removeFromParent();
            }
            if(Boolean(this.winHandler))
            {
               this.winHandler.apply(null,this.winArgs);
               this.winHandler = null;
               this.winArgs = null;
            }
            this.winSignal.stopWithoutHandler();
            this.winSignal = null;
         }
      }
   }
}

