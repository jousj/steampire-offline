package game.portal
{
   import engine.signal.Signal;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import proto.model.PCost;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class StartRaidDialog extends BaseDialog
   {
      
      public const INVITE:uint = 1;
      
      public const AUTO_SEARCH:uint = 2;
      
      public const portalBt:RectButton = new RectButton(Lang.getString("closeBt"),RectButton.h30,RectButton.YELLOW);
      
      private const grid:VGrid = new VGrid(1,4,StartRaidRenderer,null,0,2,VGrid.H_STRETCH | VGrid.USE_VISIBLE_CALC_LAYOUT);
      
      private const countText:VText = UIFactory.createYellowText(null,VText.CENTER | VText.MIDDLE,22);
      
      private const gridSection:VComponent = new VComponent();
      
      private const statusBox:VBox = new VBox();
      
      private const signal:Signal;
      
      private var member_count:uint;
      
      private var searchPanel:VComponent;
      
      private var searchComponent:VComponent;
      
      public function StartRaidDialog(param1:String, param2:uint, param3:Array)
      {
         this.signal = new Signal(this.onSignal,Signal.ADD_TIMER);
         super();
         layoutW = 814;
         this.member_count = param2;
         addBg(false);
         addDialogTitle(Lang.getString("start_raid_title"),false);
         add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH_BG),{
            "top":100,
            "hCenter":0,
            "h":174,
            "w":727
         });
         add(SkinManager.getEmbed("FeatureGear"),{
            "left":37,
            "top":293
         });
         add(SkinManager.getEmbed("FeatureGear",VSkin.FLIP_X),{
            "right":37,
            "top":293
         });
         add(this.gridSection,{
            "top":300,
            "bottom":30,
            "hCenter":0,
            "w":688
         });
         this.gridSection.addStretch(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH_BG));
         add(SkinManager.getEmbed("RSeparator",VSkin.STRETCH),{
            "top":260,
            "hCenter":0,
            "w":752,
            "h":54
         });
         add(SkinManager.getEmbed("RSeparator"),{
            "left":93,
            "top":78
         });
         add(SkinManager.getEmbed("TrainCircleBg"),{
            "left":21,
            "top":82,
            "w":144,
            "h":144
         });
         add(SkinManager.getEmbed("Bolt"),{
            "left":95,
            "top":81
         });
         add(SkinManager.getExternal(param1,SkinManager.PNG | SkinManager.LOAD_CLIP,VSkin.NO_STRETCH),{
            "left":23,
            "top":86,
            "w":140,
            "h":140
         });
         add(UIFactory.createDecorText(Lang.getString("prize"),true,28),{
            "top":130,
            "hCenter":254
         });
         var _loc4_:PriceListPanel = new PriceListPanel();
         _loc4_.fontSize = 20;
         _loc4_.useVertical(45,72,62);
         if(param1 == "rd_bosses")
         {
            param3.unshift(PCost.create(PCost.BLUE_PRINT,1));
            param3.push(PCost.create(PCost.UNKNOWN,"hero_raid_reward_hint"));
         }
         _loc4_.assignList(param3);
         add(_loc4_,{
            "hCenter":254,
            "top":166
         });
         var _loc5_:VText = UIFactory.createYellowText(Lang.getString(param1),VText.MIDDLE,22,true);
         _loc5_.format.lineHeight = "90%";
         add(_loc5_,{
            "left":180,
            "top":81,
            "w":350,
            "h":43
         });
         add(UIFactory.createYellowText(Lang.getString(param1 + "_desc"),VText.MIDDLE),{
            "left":180,
            "top":133,
            "w":380,
            "h":61
         });
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "w":376,
            "h":34,
            "left":176,
            "top":200
         });
         this.statusBox.add(SkinManager.getEmbed("ChCheck"),{
            "w":28,
            "h":28
         });
         this.statusBox.add(new VText(Lang.getString("raid_step_map"),VText.CONTAIN,Style.anthraciteRGB,16),{"maxW":134});
         this.statusBox.add(SkinManager.getEmbed("GLoad",VSkin.PLAY_MOVIE_CLIP | VSkin.RIGHT),{
            "w":40,
            "h":28
         });
         this.statusBox.add(new VText(Lang.getString("raid_step_search"),VText.CONTAIN,Style.anthraciteRGB,16),{"maxW":150});
         add(this.statusBox,{
            "top":203,
            "hCenter":-44
         });
         var _loc6_:VText = new VText(Lang.getString("raid_party_prompt"),VText.CENTER | VText.MIDDLE,15960886);
         _loc6_.format.lineHeight = "90%";
         _loc6_.filters = [new DropShadowFilter(1,0,11141377,1,0.5,0.5,1,1,false,false,false),new GlowFilter(6488334,1,1.5,1.5,9,1,false,false)];
         add(_loc6_,{
            "right":60,
            "top":261,
            "w":310,
            "h":50
         });
         var _loc7_:VBox = new VBox();
         _loc5_ = UIFactory.createYellowText(Lang.getString("raid_member_count"),VText.CONTAIN,22);
         _loc5_.maxW = 286;
         _loc7_.add(_loc5_);
         _loc7_.add(SkinManager.getEmbed("FriendsIcon"),{"w":28});
         _loc7_.add(this.countText);
         add(_loc7_,{
            "hCenter":-146,
            "top":271
         });
         add(SkinManager.getEmbed("Bolt"),{
            "left":42,
            "top":262
         });
         add(SkinManager.getEmbed("Bolt"),{
            "right":43,
            "top":262
         });
         this.portalBt.addClickListener(onBtClose,true);
         add(this.portalBt,{
            "hCenter":0,
            "bottom":-3
         });
         this.grid.dispatcher = this;
         this.gridSection.add(this.grid,{
            "top":30,
            "bottom":26,
            "left":20,
            "right":20
         });
         UIFactory.useGridControlNav(this.grid,UIFactory.addNavBt30);
         addCloseButton();
      }
      
      override protected function calcContentSize() : void
      {
         contentH = this.gridSection.measuredHeight + this.gridSection.vPadding;
      }
      
      public function setMembers(param1:Array) : void
      {
         this.countText.value = param1.length + "/" + this.member_count;
         if(param1.length >= this.member_count && Boolean(this.searchPanel))
         {
            this.searchPanel.removeFromParent();
            this.signal.stop();
            this.searchPanel = null;
            this.searchComponent = null;
            this.grid.top = 30;
            this.grid.syncLayout();
         }
         this.grid.setDataProvider(param1);
      }
      
      public function setSearchMode(param1:Number = NaN) : void
      {
         var _loc2_:VSkin = null;
         var _loc3_:RectButton = null;
         if(this.grid.length >= this.member_count)
         {
            return;
         }
         if(!this.searchPanel)
         {
            this.searchPanel = new VComponent();
            _loc2_ = SkinManager.getEmbed("RaidPartyBg",VSkin.STRETCH);
            _loc2_.alpha = 0.5;
            this.searchPanel.add(_loc2_,{
               "left":40,
               "right":0,
               "hP":100
            });
            this.searchPanel.add(SkinManager.getEmbed("RWait"),{
               "top":-5,
               "w":68,
               "h":68
            });
            this.gridSection.add(this.searchPanel,{
               "left":20,
               "right":20,
               "h":60,
               "top":35
            });
            this.grid.top = 103;
            this.grid.syncLayout();
         }
         else
         {
            this.searchPanel.remove(this.searchComponent);
         }
         this.signal.stop();
         if(!isNaN(param1))
         {
            this.searchComponent = new VText(param1 == 0 ? Lang.getString("raid_search") : null,VText.MIDDLE,Style.anthraciteRGB,18);
            if(param1 > 0)
            {
               this.signal.run(0,param1,true);
            }
         }
         else
         {
            this.searchComponent = new VBox(null,8);
            _loc3_ = new RectButton(Lang.getString("auto_search"),RectButton.h42,RectButton.YELLOW);
            _loc3_.addVarianceListener(this,this.AUTO_SEARCH);
            _loc3_.maxW = 200;
            this.searchComponent.add(_loc3_);
            _loc3_ = new RectButton(Lang.getString("invite_to_raid"),RectButton.h42);
            _loc3_.addVarianceListener(this,this.INVITE);
            _loc3_.maxW = 200;
            this.searchComponent.add(_loc3_);
         }
         this.searchComponent.useCenter(0,1);
         this.searchPanel.add(this.searchComponent);
      }
      
      public function resetSearchMode() : void
      {
         if(this.searchPanel)
         {
            this.signal.stop();
            this.gridSection.remove(this.searchPanel);
            this.searchPanel = null;
            this.grid.top = 30;
            this.grid.syncLayout();
         }
      }
      
      override public function dispose() : void
      {
         this.signal.stop();
         super.dispose();
      }
      
      private function onSignal() : void
      {
         (this.searchComponent as VText).value = Lang.getString("raid_search") + " " + StringHelper.getTimeDesc(this.signal.tail);
      }
   }
}

