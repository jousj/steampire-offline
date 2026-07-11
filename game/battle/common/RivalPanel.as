package game.battle.common
{
   import engine.signal.Signal;
   import proto.model.PCost;
   import proto.model.PFightType;
   import proto.model.PGroupFightInfo;
   import proto.model.PStormTerritory;
   import proto.model.PUserBase;
   import proto.model.clan.PBase;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.common.StatPanel;
   import ui.game.CircleAvatarPanel;
   import ui.game.ClanPanel;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class RivalPanel extends VComponent
   {
      
      public const oilMyPanel:ResourcePanel = new ResourcePanel(PCost.OIL,ResourcePanel.PROGRESS | ResourcePanel.SKIP_ICON | ResourcePanel.SKIP_HINT);
      
      public const oilTargetPanel:ResourcePanel = new ResourcePanel(PCost.OIL,ResourcePanel.PROGRESS | ResourcePanel.FLIP | ResourcePanel.SKIP_HINT | ResourcePanel.CACHE_ICON);
      
      public const crystalMyPanel:ResourcePanel = new ResourcePanel(PCost.CRYSTAL,ResourcePanel.PROGRESS | ResourcePanel.SKIP_ICON | ResourcePanel.SKIP_HINT);
      
      public const crystalTargetPanel:ResourcePanel = new ResourcePanel(PCost.CRYSTAL,ResourcePanel.PROGRESS | ResourcePanel.FLIP | ResourcePanel.SKIP_HINT | ResourcePanel.CACHE_ICON);
      
      public const damagePanel:DamagePanel = new DamagePanel();
      
      public const nameText:VText = UIFactory.createYellowText(null,VText.CONTAIN,18,true);
      
      private const avatarPanel:CircleAvatarPanel = new CircleAvatarPanel();
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size34);
      
      private const userBox:VBox = new VBox(null,2,VBox.VERTICAL | VBox.LEFT);
      
      private const ratingPanel:StatPanel = new StatPanel(SkinManager.getEmbed("RatingIcon"),null,StatPanel.YELLOW_B_TEXT,5,34,22);
      
      private const clanPanel:ClanPanel = new ClanPanel(StatPanel.YELLOW_B_TEXT,3,24,14);
      
      private const resourcePanel:VComponent = new VComponent();
      
      private const box:VBox = new VBox(new <VComponent>[this.userBox,this.resourcePanel],7);
      
      private var ratioPanel:BattleRatioPanel;
      
      private var warText:VText;
      
      private var radarSkin:VSkin;
      
      private var leagueSkin:VSkin;
      
      private var league:uint;
      
      public function RivalPanel()
      {
         super();
         add(SkinManager.getEmbed("BattleBlock",VSkin.STRETCH_BG),{
            "h":85,
            "left":0,
            "right":-10
         });
         this.avatarPanel.left = 6;
         addChild(this.avatarPanel);
         this.clanPanel.maxW = this.nameText.maxW = 210;
         this.clanPanel.nameCharMax = 20;
         this.oilTargetPanel.hint = this.oilMyPanel.hint = Lang.getString(CostHelper.getKind(PCost.OIL));
         this.crystalTargetPanel.hint = this.crystalMyPanel.hint = Lang.getString(CostHelper.getKind(PCost.CRYSTAL));
         this.oilTargetPanel.layoutW = this.crystalTargetPanel.layoutW = this.oilMyPanel.layoutW = this.crystalMyPanel.layoutW = 144;
         this.resourcePanel.layoutH = -100;
         this.oilMyPanel.left = this.crystalMyPanel.left = 104;
         this.resourcePanel.addChild(this.oilTargetPanel);
         this.crystalMyPanel.bottom = this.crystalTargetPanel.bottom = 0;
         this.resourcePanel.addChild(this.crystalTargetPanel);
         add(this.box,{
            "left":100,
            "vCenter":0,
            "hP":100
         });
         this.damagePanel.hint = Lang.getString("damage_count");
         this.levelPanel.bottom = this.levelPanel.left = -4;
         this.avatarPanel.cacheAsBitmap = true;
      }
      
      private function setNameTextMode(param1:uint) : void
      {
         if(param1 != this.nameText.getMode())
         {
            this.nameText.value = null;
            this.nameText.maxH = param1 > 0 ? 0 : 40;
            this.nameText.setMode(param1);
         }
      }
      
      public function assign(param1:PFightType, param2:PUserBase, param3:String = null, param4:Boolean = false) : void
      {
         var _loc5_:uint = param1.variance;
         if(param4 || _loc5_ == PFightType.JAINA_MISSION)
         {
            this.hideResourcePanel();
         }
         else if(!this.resourcePanel.parent)
         {
            this.box.right = VComponent.EMPTY;
            this.box.add(this.resourcePanel);
         }
         this.userBox.removeAll(false);
         var _loc6_:Vector.<VComponent> = this.userBox.list;
         _loc6_.push(this.nameText);
         if(_loc5_ == PFightType.SINGLE)
         {
            if(param2.user_id.indexOf("boss") != -1)
            {
               this.avatarPanel.setMission(param2.name + "1",true,false,true);
               param2.name = Lang.getString(param2.name);
            }
            else
            {
               this.avatarPanel.setUser(param2,0);
            }
            if(!param3)
            {
               param3 = param2.name;
            }
            this.levelPanel.changeSNetwork(param2.snetwork);
            this.levelPanel.value = param2.level;
            if(!this.levelPanel.parent)
            {
               this.avatarPanel.add(this.levelPanel);
            }
            this.ratingPanel.value = param2.ratio;
            this.clanPanel.assignUserClan(param2.clan);
            if(param2.clan)
            {
               _loc6_.push(this.clanPanel);
            }
            _loc6_.push(this.ratingPanel);
         }
         else
         {
            if(_loc5_ == PFightType.JAINA_MISSION)
            {
               _loc5_ = PFightType.MISSION;
            }
            this.avatarPanel.setMission(_loc5_ == PFightType.MISSION && !param4 ? param1.value : null);
            if(!param3)
            {
               if(param4)
               {
                  param3 = Lang.getString("regent");
               }
               else if(_loc5_ == PFightType.GROUP)
               {
                  param3 = Lang.getString((param1.value as PGroupFightInfo).fgi_raid_kind);
               }
               else if(_loc5_ == PFightType.MISSION)
               {
                  param3 = Lang.getString(param1.value);
               }
            }
            this.avatarPanel.remove(this.levelPanel,false);
            if(!param4)
            {
               _loc6_.push(this.damagePanel);
            }
         }
         this.setNameTextMode(_loc5_ == PFightType.SINGLE ? VText.CONTAIN : 0);
         this.nameText.value = param3;
         this.userBox.addAll();
      }
      
      public function assignStorm(param1:PBase, param2:PStormTerritory, param3:PUserBase = null) : void
      {
         this.userBox.removeAll(false);
         this.setNameTextMode(0);
         if(param1)
         {
            this.nameText.value = param1.name;
            this.avatarPanel.setMission(param1.icon,true);
            this.avatarPanel.remove(this.levelPanel,false);
         }
         else if(param2)
         {
            this.nameText.value = Lang.getString(param2.st_ter_kind);
            this.avatarPanel.setMission("MapIcon",true,true);
            this.levelPanel.changeSNetwork(null);
            this.levelPanel.value = param2.st_ter_level;
            if(!this.levelPanel.parent)
            {
               this.avatarPanel.add(this.levelPanel);
            }
         }
         else if(param3)
         {
            this.nameText.value = param3.name;
         }
         this.userBox.list.push(this.nameText,this.damagePanel);
         this.userBox.addAll();
         this.hideResourcePanel();
      }
      
      private function hideResourcePanel() : void
      {
         if(this.resourcePanel.parent)
         {
            this.box.right = 6;
            this.box.remove(this.resourcePanel,false);
         }
      }
      
      public function set myResourceVisible(param1:Boolean) : void
      {
         if(param1 != Boolean(this.crystalMyPanel.parent))
         {
            if(param1)
            {
               this.resourcePanel.addChildAt(this.crystalMyPanel,0);
               this.resourcePanel.add(this.oilMyPanel,null,0);
            }
            else
            {
               this.resourcePanel.removeChild(this.crystalMyPanel);
               this.resourcePanel.remove(this.oilMyPanel,false);
            }
         }
      }
      
      public function showDamagePanel() : void
      {
         if(!this.damagePanel.parent)
         {
            if(this.ratingPanel.parent)
            {
               this.userBox.remove(this.ratingPanel,false);
            }
            this.userBox.add(this.damagePanel);
         }
      }
      
      public function showRatio(param1:int, param2:int) : void
      {
         if(!this.ratioPanel)
         {
            this.ratioPanel = new BattleRatioPanel();
            this.ratioPanel.cacheAsBitmap = true;
         }
         this.ratioPanel.assign(param1,param2);
         if(!this.ratioPanel.parent)
         {
            this.box.add(this.ratioPanel,null,2);
         }
      }
      
      public function hideRatio() : void
      {
         if(Boolean(this.ratioPanel) && Boolean(this.ratioPanel.parent))
         {
            this.box.remove(this.ratioPanel,false);
         }
      }
      
      public function showWarTime(param1:Number) : void
      {
         var _loc2_:VComponent = null;
         var _loc3_:VComponent = null;
         if(!this.warText)
         {
            this.warText = UIFactory.createYellowText(null,VText.CONTAIN_CENTER);
            _loc3_ = new VComponent();
            _loc3_.add(SkinManager.getEmbed("BattleBlock",VSkin.STRETCH),{
               "hP":100,
               "left":-10,
               "right":-10
            });
            _loc3_.add(UIFactory.createYellowText(Lang.getString("war_end_time"),VText.CONTAIN_CENTER,15),{
               "left":10,
               "right":10,
               "top":12
            });
            _loc3_.add(SkinManager.getEmbed("ResBg",VSkin.STRETCH),{
               "left":42,
               "right":16,
               "top":38,
               "h":30
            });
            _loc3_.add(SkinManager.getEmbed("ResFg",VSkin.STRETCH),{
               "left":38,
               "right":13,
               "top":35
            });
            _loc3_.add(SkinManager.getEmbed("WarFireImg"),{
               "left":11,
               "top":28,
               "w":50
            });
            _loc3_.add(SkinManager.getEmbed("SwordsIcon"),{
               "left":13,
               "top":33
            });
            _loc3_.cacheAsBitmap = true;
            _loc2_ = new VComponent();
            _loc2_.setSize(204,85);
            _loc2_.addStretch(_loc3_);
            _loc2_.add(this.warText,{
               "left":60,
               "right":26,
               "bottom":21
            });
            _loc2_.right = -(_loc2_.layoutW + 7);
         }
         else
         {
            _loc2_ = this.warText.parent as VComponent;
         }
         add(_loc2_);
         Signal.createRef(this.warText,this.onWarSignal,Signal.ADD_TIMER).run(0,param1,true);
      }
      
      public function hideWarTime() : void
      {
         var _loc1_:VComponent = null;
         if(this.warText)
         {
            _loc1_ = this.warText.parent as VComponent;
            if(_loc1_.parent)
            {
               Signal.stopRef(this.warText);
               remove(_loc1_,false);
            }
         }
      }
      
      private function onWarSignal(param1:Signal) : void
      {
         this.warText.value = StringHelper.getTimeDesc(param1.tail);
      }
      
      public function setSingleInfo(param1:Boolean, param2:uint) : void
      {
         if(param1 && !this.radarSkin)
         {
            this.radarSkin = SkinManager.getEmbed("RadarIconAnim",VSkin.PLAY_MOVIE_CLIP);
            this.radarSkin.left = 58;
         }
         if(Boolean(this.radarSkin) && param1 != Boolean(this.radarSkin.parent))
         {
            if(param1)
            {
               add(this.radarSkin);
            }
            else
            {
               remove(this.radarSkin,false);
            }
         }
         param1 = param2 > 0;
         if(param1 && !this.leagueSkin)
         {
            this.leagueSkin = new VSkin();
            this.leagueSkin.assignLayout({
               "right":0,
               "bottom":-4,
               "h":30
            });
         }
         if(Boolean(this.leagueSkin) && param1 != Boolean(this.leagueSkin.parent))
         {
            if(param1)
            {
               this.avatarPanel.add(this.leagueSkin,null,3);
            }
            else
            {
               this.avatarPanel.remove(this.leagueSkin,false);
            }
         }
         if(param1 && this.league != param2)
         {
            this.league = param2;
            SkinManager.applyEmbed(this.leagueSkin,"league" + param2);
         }
      }
      
      public function initResources(param1:uint, param2:uint) : void
      {
         this.oilTargetPanel.setMax(param1,true,false);
         this.crystalTargetPanel.setMax(param2,true,false);
         this.oilMyPanel.setDataEx(0,param1);
         this.crystalMyPanel.setDataEx(0,param2);
      }
   }
}

