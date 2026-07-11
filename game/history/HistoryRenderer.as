package game.history
{
   import model.ui.VOHistoryItem;
   import proto.model.PCost;
   import proto.model.PFightLogInfo;
   import proto.model.PHistFight;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.game.CircleAvatarPanel;
   import ui.game.ClanPanel;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VGrid;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class HistoryRenderer extends VRenderer
   {
      
      private const avatarPanel:CircleAvatarPanel = new CircleAvatarPanel();
      
      private const ratingStat:StatPanel = new StatPanel(SkinManager.getEmbed("RatingIcon"),null,0,3,28,16);
      
      private const nameText:VText = UIFactory.createYellowText(null,VText.CONTAIN);
      
      private const levelPanel:LevelPanel = new LevelPanel();
      
      private const timeText:VText = new VText(null,0,Style.metalRGB,12);
      
      private const damageStat:StatPanel = new StatPanel(SkinManager.getEmbed("DamageIcon"),null,StatPanel.YELLOW_TEXT,1,30);
      
      private const ratingDeltaStat:StatPanel = new StatPanel(SkinManager.getEmbed("RatingIcon"),null,StatPanel.YELLOW_TEXT,3,26);
      
      private const clanPanel:ClanPanel = new ClanPanel();
      
      private const pricePanel:PriceListPanel = new PriceListPanel(14);
      
      private const replayBt:VButton = VButton.createEmbed(RectButton.GREEN,VSkin.STRETCH,SkinManager.getEmbed("ReplayIcon"),{
         "hCenter":0,
         "vCenter":0
      });
      
      private const revengeBt:RectButton = RectButton.createIconAndTitle30(SkinManager.getEmbed("BarrackIcon"),Lang.getString("revengeBt"),0,RectButton.ORANGE,3);
      
      private const toBt:VButton = VButton.createEmbed(RectButton.GREEN,VSkin.STRETCH,SkinManager.getEmbed("SearchIcon"),{
         "hCenter":0,
         "vCenter":0,
         "w":25
      });
      
      private const clanBox:VBox = new VBox(null,6);
      
      private const leagueSkin:VSkin = new VSkin();
      
      private var grid:VGrid;
      
      private var resultComponent:VComponent;
      
      private var resultSkin:VSkin;
      
      private var isCacheWin:Boolean;
      
      private var shieldPanel:VComponent;
      
      private var cryPanel:ResourcePanel;
      
      private var oilPanel:ResourcePanel;
      
      private var radarSkin:VSkin;
      
      public function HistoryRenderer()
      {
         super();
         setSize(745,166);
         addStretch(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH));
         var _loc1_:VSkin = SkinManager.getEmbed("RaidPartyBg",VSkin.STRETCH);
         _loc1_.alpha = 0.65;
         add(_loc1_,{
            "left":59,
            "top":45,
            "w":370,
            "h":54
         });
         add(this.avatarPanel,{
            "w":70,
            "h":70,
            "top":37,
            "left":25
         });
         this.levelPanel.setCustomSize(28,28,18,5,4);
         this.avatarPanel.add(this.leagueSkin,{
            "right":-4,
            "bottom":-8,
            "h":30
         });
         add(this.levelPanel,{
            "left":20,
            "top":32
         });
         add(this.timeText,{
            "hCenter":-146,
            "top":30
         });
         add(this.nameText,{
            "left":99,
            "top":50,
            "maxW":324
         });
         this.ratingStat.maxW = 72;
         this.clanBox.add(this.ratingStat);
         this.clanPanel.layoutW = -100;
         this.clanPanel.nameCharMax = 20;
         this.clanBox.add(this.clanPanel);
         add(this.clanBox,{
            "left":99,
            "top":69
         });
         add(new VText(Lang.getString("battle_result"),VText.CONTAIN_CENTER,Style.metalRGB,12),{
            "left":28,
            "w":400,
            "bottom":50
         });
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "left":28,
            "w":400,
            "bottom":20
         });
         this.ratingDeltaStat.text.format.baselineShift = this.damageStat.text.format.baselineShift = -2;
         this.pricePanel.priceMode |= PricePanel.NEGATIVE;
         this.pricePanel.setStyle(26,18);
         add(new VBox(new <VComponent>[this.pricePanel,this.ratingDeltaStat,this.damageStat],14),{
            "bottom":19,
            "hCenter":-146
         });
         add(new VText(Lang.getString("enemy_loss"),VText.CONTAIN_CENTER,Style.metalRGB,12),{
            "right":20,
            "top":24,
            "w":286
         });
         this.grid = new VGrid(4,1,SoldierHistoryRenderer,null,7,0,VGrid.USE_NULL_DATA);
         this.grid.renderList[0].setSize(60,60);
         add(this.grid,{
            "right":32,
            "top":44
         });
         UIFactory.useGridControlNav(this.grid,UIFactory.addNavBt18);
         this.replayBt.hint = Lang.getString("replayBt");
         this.replayBt.setSize(44,30);
         this.replayBt.addVarianceListener(this,1);
         this.toBt.hint = Lang.getString("to_friend");
         this.toBt.setSize(44,30);
         this.toBt.addVarianceListener(this,3);
         this.revengeBt.hint = Lang.getString("revengeBt");
         this.revengeBt.setSize(120,30);
         this.revengeBt.addVarianceListener(this,2);
         add(new VBox(new <VComponent>[this.revengeBt,this.toBt,this.replayBt]),{
            "right":30,
            "bottom":20
         });
      }
      
      public static function createShieldPanel(param1:Number) : VComponent
      {
         var _loc2_:VComponent = new VComponent();
         _loc2_.setSize(128,28);
         _loc2_.addStretch(SkinManager.getEmbed("StatBg",VSkin.STRETCH));
         var _loc3_:VSkin = SkinManager.getEmbed(param1 < 0 ? "OnlineIcon" : "ShieldIcon");
         if(param1 > 0)
         {
            _loc3_.layoutH = 30;
         }
         §§push(_loc2_);
         §§push(§§findproperty(VBox));
         var _temp_2:* = new <VComponent>[_loc3_,new VText(param1 < 0 ? "online" : StringHelper.getTimeDesc(param1 > 3600 ? Math.round(param1 / 3600) * 3600 : param1,true),0,Style.metalRGB)];
         §§pop().add(new §§pop().VBox(new <VComponent>[_loc3_,new VText(param1 < 0 ? "online" : StringHelper.getTimeDesc(param1 > 3600 ? Math.round(param1 / 3600) * 3600 : param1,true),0,Style.metalRGB)]),{
            "hCenter":0,
            "vCenter":0
         });
         return _loc2_;
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:VOHistoryItem = param1 as VOHistoryItem;
         var _loc3_:PHistFight = _loc2_.item;
         var _loc4_:String = _loc2_.boss;
         if(_loc4_)
         {
            this.syncRevengeInfo(true,_loc2_.log);
            this.revengeBt.visible = false;
         }
         else
         {
            this.syncRevengeInfo(_loc2_.isRevenge,_loc2_.log);
            _loc5_ = _loc2_.log ? _loc2_.log.fli_shield_end_time : 0;
            this.revengeBt.visible = this.toBt.visible = _loc5_ == 0;
            if(this.shieldPanel)
            {
               remove(this.shieldPanel);
               this.shieldPanel = null;
            }
            if(_loc5_ != 0)
            {
               this.shieldPanel = createShieldPanel(_loc5_);
               add(this.shieldPanel,{
                  "bottom":20,
                  "right":82
               });
            }
            else
            {
               this.toBt.disabled = this.revengeBt.disabled = !_loc2_.isRevenge;
            }
            if(this.replayBt.data == _loc3_)
            {
               return;
            }
         }
         this.syncWinStatus(!_loc3_.phf_is_win);
         if(_loc4_)
         {
            this.nameText.value = Lang.getString(_loc4_);
            this.levelPanel.visible = this.leagueSkin.visible = false;
            this.avatarPanel.setMission(_loc4_ + "1",true,false,true);
            this.toBt.disabled = false;
         }
         else
         {
            this.nameText.value = _loc3_.phf_name;
            this.levelPanel.visible = this.leagueSkin.visible = true;
            this.levelPanel.changeSNetwork(_loc3_.phf_snetwork);
            this.levelPanel.value = _loc3_.phf_level;
            this.avatarPanel.setUser(_loc3_.phf_avatar,1);
         }
         this.ratingStat.value = _loc3_.phf_ratio;
         SkinManager.applyEmbed(this.leagueSkin,"league" + Facade.manualProxy.getLeagueShop(_loc3_.phf_level).division_num);
         this.clanPanel.assignClan(_loc3_.phf_clan);
         this.damageStat.text.value = _loc3_.phf_percentage + "%";
         this.timeText.value = Lang.getPatternString("time_ago","__TIME__",StringHelper.getTimeDesc(_loc2_.tailTime));
         this.replayBt.disabled = !_loc3_.phf_has_replay;
         this.toBt.data = this.revengeBt.data = this.replayBt.data = _loc3_;
         this.pricePanel.assignList(_loc3_.phf_steal_res);
         this.ratingDeltaStat.text.value = _loc3_.phf_change_ratio > 0 ? "+" + _loc3_.phf_change_ratio : String(_loc3_.phf_change_ratio);
         if(_loc3_.phf_scouting && !this.radarSkin)
         {
            this.radarSkin = SkinManager.getEmbed("RadarIconAnim",VSkin.PLAY_MOVIE_CLIP);
            add(this.radarSkin,{
               "left":69,
               "top":28
            });
         }
         if(this.radarSkin)
         {
            this.radarSkin.visible = _loc3_.phf_scouting;
         }
         this.grid.setDataProvider(_loc2_.soldierList);
      }
      
      private function syncWinStatus(param1:Boolean) : void
      {
         if(!this.resultComponent || this.isCacheWin != param1)
         {
            this.isCacheWin = param1;
            if(this.resultComponent)
            {
               this.resultComponent.removeFromParent();
            }
            this.resultComponent = UIFactory.createDecorText(Lang.getString(param1 ? "victory" : "defeat"),param1);
            add(this.resultComponent,{
               "top":-2,
               "hCenter":-146
            });
         }
         if(param1 != Boolean(this.resultSkin))
         {
            if(param1)
            {
               this.resultSkin = SkinManager.getEmbed("QTargetFg",VSkin.STRETCH);
               add(this.resultSkin,{
                  "left":10,
                  "right":10,
                  "top":8,
                  "bottom":10
               },1);
            }
            else if(this.resultSkin)
            {
               this.resultSkin.removeFromParent();
               this.resultSkin = null;
            }
         }
      }
      
      private function syncRevengeInfo(param1:Boolean, param2:PFightLogInfo) : void
      {
         var _loc3_:uint = 0;
         if(param1)
         {
            if(!this.cryPanel)
            {
               this.oilPanel = new ResourcePanel(PCost.OIL,ResourcePanel.PROGRESS,UIFactory.INDICATOR_PURPLE);
               add(this.oilPanel,{
                  "left":331,
                  "top":43,
                  "w":140
               });
               this.cryPanel = new ResourcePanel(PCost.CRYSTAL,ResourcePanel.PROGRESS,UIFactory.INDICATOR_BLUE);
               add(this.cryPanel,{
                  "left":331,
                  "top":74,
                  "w":140
               });
               this.cryPanel.scaleX = this.cryPanel.scaleY = this.oilPanel.scaleX = this.oilPanel.scaleY = 0.7;
            }
            else
            {
               this.cryPanel.visible = this.oilPanel.visible = true;
            }
            if(param2)
            {
               _loc3_ = CostHelper.getValueFromList(param2.fli_resources,PCost.CRYSTAL);
               this.cryPanel.setDataEx(_loc3_,_loc3_);
               _loc3_ = CostHelper.getValueFromList(param2.fli_resources,PCost.OIL);
               this.oilPanel.setDataEx(_loc3_,_loc3_);
            }
            else
            {
               this.cryPanel.setData(0);
               this.cryPanel.setCustom("?");
               this.oilPanel.setData(0);
               this.oilPanel.setCustom("?");
            }
            _loc3_ = 226;
         }
         else
         {
            _loc3_ = 324;
            if(this.cryPanel)
            {
               this.cryPanel.visible = this.oilPanel.visible = false;
            }
         }
         if(this.nameText.maxW != _loc3_)
         {
            this.clanBox.maxW = this.nameText.maxW = _loc3_;
            this.nameText.syncLayout();
            this.clanBox.syncLayout();
         }
      }
   }
}

