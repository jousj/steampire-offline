package game.clan.war
{
   import game.clan.center.CapitalLevelPanel;
   import proto.model.PCost;
   import proto.model.clan.PClanTop;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class StartWarRenderer extends VRenderer
   {
      
      private const emblemSkin:VSkin = new VSkin();
      
      private const titleText:VText = UIFactory.createYellowText(null,VText.CENTER | VText.MIDDLE,19);
      
      private const ratingStat:StatPanel = new StatPanel(SkinManager.getEmbed("RatingIcon"),null,0,2,24,16);
      
      private const memberStat:StatPanel = new StatPanel(SkinManager.getEmbed("MembersIcon"),null,0,3,24,16);
      
      private const placeStat:StatPanel = new StatPanel(SkinManager.getEmbed("CupIcon"),null,0,2,24,16);
      
      private const pricePanel:PricePanel = new PricePanel(20,18,PricePanel.GLOW_FILTER | PricePanel.CLAN);
      
      private const warBt:RectButton = new RectButton(new VBox(new <VComponent>[UIFactory.createYellowText(Lang.getString("war_begin")),this.pricePanel],0,VBox.VERTICAL),RectButton.h56,RectButton.ORANGE);
      
      private const clanInfoBt:CircleButton = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.GOLD,CircleButton.size30);
      
      private const clanSection:VComponent = new VComponent();
      
      private const prizeSection:VComponent = new VComponent();
      
      private const prizeSectionBox:VBox = new VBox(null,7,VBox.VERTICAL);
      
      private const priceListPanel:PriceListPanel = new PriceListPanel(12);
      
      private const trophyPanel:PriceListPanel = new PriceListPanel(12);
      
      private var fill:VFill;
      
      private var levelPanel:CapitalLevelPanel;
      
      private var emptyPriceText:VComponent;
      
      public function StartWarRenderer()
      {
         super();
         layoutH = 118;
         add(this.emblemSkin,{
            "left":8,
            "vCenter":0,
            "w":70,
            "h":90
         });
         this.clanSection.add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "left":0,
            "right":4,
            "h":26
         });
         this.clanSection.add(UIFactory.createYellowText(Lang.getString("clan_info"),VText.CONTAIN_CENTER,16),{
            "left":25,
            "right":25,
            "top":5
         });
         this.clanInfoBt.addVarianceListener(this,WarVariance.INFO);
         this.clanSection.add(this.clanInfoBt,{
            "right":-5,
            "top":-2
         });
         this.titleText.format.lineHeight = "100%";
         this.clanSection.add(this.titleText,{
            "left":-7,
            "right":-7,
            "top":28,
            "h":42
         });
         this.placeStat.maxW = this.ratingStat.maxW = 90;
         this.memberStat.hint = Lang.getString("clan_member_count");
         this.ratingStat.hint = Lang.getString("rating");
         this.clanSection.add(new VBox(new <VComponent>[this.placeStat,this.memberStat,this.ratingStat],8),{
            "bottom":0,
            "hCenter":0
         });
         add(this.clanSection,{
            "left":95,
            "top":13,
            "w":300,
            "h":98
         });
         this.prizeSection.add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "left":0,
            "right":4,
            "h":26
         });
         this.prizeSection.add(UIFactory.createYellowText(Lang.getString("war_spoils"),VText.CONTAIN_CENTER,16),{
            "left":25,
            "right":25,
            "top":5
         });
         this.prizeSection.add(this.prizeSectionBox,{
            "hCenter":0,
            "vCenter":20
         });
         add(this.prizeSection,{
            "left":408,
            "top":13,
            "w":300,
            "h":98
         });
         this.warBt.addVarianceListener(this,WarVariance.START);
         add(this.warBt,{
            "right":8,
            "vCenter":0,
            "w":150
         });
         this.priceListPanel.priceMode |= PricePanel.CLAN;
         this.trophyPanel.mouseEnabled = true;
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PClanTop = null;
         var _loc6_:PCost = null;
         _loc2_ = param1 as PClanTop;
         this.warBt.data = _loc2_;
         this.titleText.value = _loc2_.name;
         SkinManager.applyExternal(this.emblemSkin,UIFactory.EMBLEM_PACK,_loc2_.icon);
         this.clanInfoBt.data = _loc2_.id;
         this.memberStat.value = _loc2_.members_count;
         this.ratingStat.value = _loc2_.ratio;
         this.placeStat.value = _loc2_.place;
         this.placeStat.hint = Lang.getPatternString("clan_rating","__VALUE__",_loc2_.place.toString());
         this.pricePanel.assignCost(_loc2_.war_params.wp_price[0]);
         var _loc3_:Boolean = _loc2_.level > 0;
         if(_loc3_ != Boolean(this.levelPanel && this.levelPanel.parent))
         {
            if(_loc3_)
            {
               if(!this.levelPanel)
               {
                  this.levelPanel = new CapitalLevelPanel();
                  this.levelPanel.left = 49;
                  this.levelPanel.top = 84;
               }
               add(this.levelPanel);
            }
            else
            {
               remove(this.levelPanel,false);
            }
         }
         if(_loc3_)
         {
            this.levelPanel.text.value = _loc2_.level.toString();
         }
         var _loc4_:int = 0;
         if(_loc2_.war_params.wp_prize.length > 0)
         {
            this.priceListPanel.assignList(null);
            for each(_loc6_ in _loc2_.war_params.wp_prize)
            {
               if(_loc6_.variance == PCost.TROPHY)
               {
                  _loc2_.war_params.wp_trophy = _loc6_.value;
               }
               else
               {
                  if(_loc4_ == 0)
                  {
                     this.priceListPanel.assignCost(_loc6_);
                  }
                  else
                  {
                     this.priceListPanel.addCost(_loc6_);
                  }
                  _loc4_++;
               }
            }
         }
         var _loc5_:Boolean = _loc4_ > 0;
         if(_loc5_ != Boolean(this.priceListPanel.parent))
         {
            if(_loc5_)
            {
               this.prizeSectionBox.add(this.priceListPanel,null,0);
            }
            else
            {
               this.prizeSectionBox.remove(this.priceListPanel,false);
            }
         }
         _loc5_ = _loc2_.war_params.wp_trophy > 0;
         this.trophyPanel.assignList([]);
         if(_loc5_)
         {
            this.trophyPanel.addCost(PCost.create(PCost.TROPHY,_loc2_.war_params.wp_trophy));
         }
         this.trophyPanel.addCost(PCost.create(PCost.CLAN_POINTS,Facade.references.clan_war_win));
         if(Boolean(this.priceListPanel.parent) != Boolean(this.trophyPanel.parent))
         {
            if(this.priceListPanel.parent)
            {
               this.prizeSectionBox.add(this.trophyPanel);
            }
            else
            {
               this.prizeSectionBox.remove(this.trophyPanel,false);
            }
         }
         _loc5_ = this.prizeSectionBox.list.length == 0;
         if(_loc5_ != Boolean(this.emptyPriceText))
         {
            if(_loc5_)
            {
               this.emptyPriceText = UIFactory.createDecorText(Lang.getString("war_prize_empty"),false,20,220,false);
               this.prizeSection.add(this.emptyPriceText,{
                  "hCenter":0,
                  "vCenter":16
               });
            }
            else
            {
               this.prizeSection.remove(this.emptyPriceText);
               this.emptyPriceText = null;
            }
         }
         if(Boolean(this.fill) != ((dataIndex & 1) == 1))
         {
            if(this.fill)
            {
               remove(this.fill);
               this.fill = null;
            }
            else
            {
               this.fill = new VFill(12367020);
               addStretch(this.fill,0);
            }
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this.levelPanel) && !this.levelPanel.parent)
         {
            this.levelPanel.dispose();
         }
         if(!this.priceListPanel.parent)
         {
            this.priceListPanel.dispose();
         }
         if(!this.trophyPanel.parent)
         {
            this.trophyPanel.dispose();
         }
         super.dispose();
      }
   }
}

