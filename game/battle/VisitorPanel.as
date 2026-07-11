package game.battle
{
   import game.battle.common.RivalPanel;
   import game.battle.raid.RaidMemberRenderer;
   import game.battle.raid.SayPanel;
   import proto.model.PCost;
   import proto.model.PTownhallUnlock;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class VisitorPanel extends VComponent
   {
      
      public static const TO_HOME:uint = 1;
      
      public static const SPEEDUP:uint = 2;
      
      public static const SURRENDER:uint = 3;
      
      public static const NEXT:uint = 4;
      
      public static const MESSAGE:uint = 5;
      
      public const rivalPanel:RivalPanel = new RivalPanel();
      
      public const rightBox:VBox = new VBox(null,16);
      
      public var sayPanel:SayPanel;
      
      public var raidGrid:VGrid;
      
      public var homeBt:RectButton;
      
      public var nextBt:RectButton;
      
      public var fightBox:VBox;
      
      public var speedupBt:RectButton;
      
      public var surrenderBt:RectButton;
      
      private var clockPanel:VComponent;
      
      private var messageText:VText;
      
      private var energyStatPanel:StatPanel;
      
      private var energyResPanel:ResourcePanel;
      
      private var uiComponent:VComponent;
      
      public function VisitorPanel()
      {
         super();
         maxW = 1850;
         hCenter = 0;
         this.rivalPanel.left = 10;
         addChild(this.rivalPanel);
         var _loc1_:VSkin = SkinManager.getEmbed("BattleBlock",VSkin.STRETCH_BG);
         _loc1_.useRuledLayout();
         _loc1_.assignLayout({
            "hP":100,
            "left":-14,
            "right":-14
         });
         this.rightBox.addChild(_loc1_);
         this.rightBox.assignLayout({
            "right":14,
            "h":84
         });
      }
      
      private function createHomeBt() : void
      {
         this.homeBt = RectButton.createIconAndTitle42(SkinManager.getEmbed("HomeIcon"),Lang.getString("to_base"),150);
         this.homeBt.layoutW = 150;
         this.homeBt.addVarianceListener(this,TO_HOME);
      }
      
      public function useHome() : void
      {
         if(!this.homeBt)
         {
            this.createHomeBt();
         }
         else if(Boolean(this.nextBt) && this.homeBt.parent == this.nextBt.parent)
         {
            (this.homeBt.parent as VBox).remove(this.homeBt,false);
         }
         this.setRightUI(this.homeBt);
      }
      
      public function useNextPvP(param1:int, param2:PTownhallUnlock) : void
      {
         var _loc4_:VComponent = null;
         if(this.homeBt == this.uiComponent)
         {
            this.rightBox.remove(this.homeBt,false);
            this.uiComponent = null;
         }
         if(!this.nextBt)
         {
            if(!this.homeBt)
            {
               this.createHomeBt();
            }
            this.nextBt = RectButton.createIconAndTitle42(SkinManager.getEmbed("PvPIcon"),Lang.getString("search"),150,RectButton.ORANGE);
            this.nextBt.layoutW = 150;
            this.nextBt.addVarianceListener(this,NEXT);
            this.energyStatPanel = new StatPanel(SkinManager.getEmbed("Crystal"),param2.tu_find_target_price,StatPanel.YELLOW_B_TEXT,3,24);
            this.energyResPanel = new ResourcePanel(PCost.CRYSTAL,ResourcePanel.BG,"BlueIndicatorS");
            _loc4_ = new VComponent();
            _loc4_.setSize(308,70);
            _loc4_.add(new VBox(new <VComponent>[UIFactory.createYellowText(Lang.getString("pvp_search_price"),VText.CONTAIN,16,true).assignMaxW(240),this.energyStatPanel],7),{"hCenter":0});
            _loc4_.add(new VBox(new <VComponent>[this.homeBt,this.nextBt],8),{
               "hCenter":0,
               "bottom":0
            });
            _loc4_.add(this.energyResPanel,{
               "right":0,
               "bottom":-54,
               "w":130
            });
         }
         else
         {
            _loc4_ = this.nextBt.parent.parent as VComponent;
         }
         if(!this.homeBt.parent)
         {
            (this.nextBt.parent as VBox).add(this.homeBt,null,0);
         }
         var _loc3_:int = param2.tu_find_target_price.value;
         this.energyStatPanel.value = _loc3_;
         this.energyResPanel.setData(param1);
         this.nextBt.disabled = param1 < _loc3_;
         this.setRightUI(_loc4_);
      }
      
      public function useStartBattle(param1:Boolean, param2:Boolean) : void
      {
         if(param1)
         {
            if(!param2)
            {
               this.createSayPanel();
               this.sayPanel.dispatcher = this;
            }
         }
         else
         {
            this.rivalPanel.hideRatio();
            this.rivalPanel.showDamagePanel();
         }
         if(param2)
         {
            this.useEmpty();
         }
         else
         {
            this.rivalPanel.myResourceVisible = true;
            this.useSurrender();
         }
      }
      
      private function useFightBox(param1:Boolean) : void
      {
         if(!this.fightBox)
         {
            this.speedupBt = RectButton.createIconAndTitle42(SkinManager.getEmbed("BattleSimIcon"),Lang.getString("to_finish_battle"));
            this.speedupBt.addVarianceListener(this,SPEEDUP);
            this.surrenderBt = RectButton.createIconAndTitle30(SkinManager.getEmbed("SurrenderIcon"),Lang.getString("step_back"),0,RectButton.ORANGE);
            this.surrenderBt.addVarianceListener(this,SURRENDER);
            this.fightBox = new VBox(new <VComponent>[this.speedupBt,this.surrenderBt],4,VBox.VERTICAL);
         }
         if(!this.fightBox.parent)
         {
            this.setRightUI(this.fightBox);
         }
         this.surrenderBt.disabled = !param1;
         this.speedupBt.disabled = param1;
      }
      
      public function useSpeedup() : void
      {
         this.useFightBox(false);
      }
      
      public function useSurrender() : void
      {
         this.useFightBox(true);
      }
      
      public function useMessage(param1:String) : void
      {
         if(!this.messageText)
         {
            this.messageText = UIFactory.createYellowText(null,VText.CENTER | VText.MIDDLE,18,true);
            this.messageText.maxW = 250;
            this.messageText.layoutH = 80;
         }
         if(!this.messageText.parent)
         {
            this.setRightUI(this.messageText);
         }
         this.messageText.value = param1;
      }
      
      public function useEmpty() : void
      {
         this.setRightUI(null);
      }
      
      public function clear() : void
      {
         this.useEmpty();
         this.rivalPanel.hideRatio();
         this.rivalPanel.myResourceVisible = false;
         this.setClockVisible(false);
         if(this.sayPanel)
         {
            remove(this.sayPanel);
            this.sayPanel = null;
         }
      }
      
      public function createSayPanel() : void
      {
         this.sayPanel = new SayPanel();
         add(this.sayPanel,{
            "bottom":(Facade.fakeResize ? 90 : 122),
            "left":10,
            "h":250
         });
      }
      
      public function setClockVisible(param1:Boolean) : void
      {
         if(param1 != Boolean(this.clockPanel))
         {
            if(param1)
            {
               if(parent is VComponent)
               {
                  this.clockPanel = new VComponent();
                  this.clockPanel.addStretch(new VFill(Style.bgRGB,0.6));
                  this.clockPanel.add(SkinManager.getEmbed("ClockClip",VSkin.PLAY_MOVIE_CLIP),{
                     "hCenter":0,
                     "vCenter":0
                  });
                  (parent as VComponent).addStretch(this.clockPanel,parent.getChildIndex(this) + 1);
               }
            }
            else
            {
               this.clockPanel.removeFromParent();
               this.clockPanel = null;
            }
         }
      }
      
      public function setRaidMembers(param1:Array, param2:Function = null) : void
      {
         if(Boolean(param1) && param1.length > 0)
         {
            if(!this.raidGrid)
            {
               this.raidGrid = new VGrid(param1.length,1,RaidMemberRenderer,param1,12);
               if(param2 != null)
               {
                  this.raidGrid.addListener(VEvent.VARIANCE,param2);
               }
               this.raidGrid.layoutH = 78;
               this.rightBox.add(this.raidGrid,null,0);
               this.syncRightBoxVisible();
            }
            else
            {
               this.raidGrid.changeRendererCount(param1.length,1,param1);
            }
         }
         else if(this.raidGrid)
         {
            this.rightBox.remove(this.raidGrid);
            this.raidGrid = null;
            this.syncRightBoxVisible();
         }
      }
      
      private function setRightUI(param1:VComponent) : void
      {
         if(this.uiComponent != param1)
         {
            if(this.uiComponent)
            {
               this.rightBox.remove(this.uiComponent,false);
            }
            this.uiComponent = param1;
            if(param1)
            {
               this.rightBox.add(param1);
            }
            this.syncRightBoxVisible();
         }
      }
      
      private function syncRightBoxVisible() : void
      {
         var _loc1_:Boolean = this.rightBox.list.length > 0;
         if(_loc1_ != Boolean(this.rightBox.parent))
         {
            if(_loc1_)
            {
               add(this.rightBox);
            }
            else
            {
               removeChild(this.rightBox);
            }
         }
      }
   }
}

