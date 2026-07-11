package game.portal
{
   import game.battle.raid.RaidSoldierRenderer;
   import model.vo.VORaidMember;
   import proto.model.PUserBase;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.StatPanel;
   import ui.game.CircleAvatarPanel;
   import ui.game.ClanPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VGrid;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class StartRaidRenderer extends VRenderer
   {
      
      private const nameText:VText = new VText(null,VText.MIDDLE,Style.metalRGB,16);
      
      private const avatar:CircleAvatarPanel = new CircleAvatarPanel();
      
      private const capacityStat:StatPanel = new StatPanel(SkinManager.getEmbed("HumanIcon"),null,StatPanel.YELLOW_TEXT,2,28,20);
      
      private const grid:VGrid = new VGrid(4,1,RaidSoldierRenderer,null,5,0,VGrid.USE_VISIBLE_CALC_LAYOUT | VGrid.USE_END_LIMIT);
      
      private const clanPanel:ClanPanel = new ClanPanel(0,3,26,14);
      
      private const leagueSkin:VSkin = new VSkin(VSkin.BOTTOM);
      
      private var item:VORaidMember;
      
      public function StartRaidRenderer()
      {
         super();
         layoutH = 70;
         var _loc1_:VSkin = SkinManager.getEmbed("RaidPartyBg",VSkin.STRETCH);
         _loc1_.alpha = 0.5;
         add(_loc1_,{
            "right":0,
            "left":40,
            "h":60,
            "vCenter":0
         });
         this.avatar.add(this.leagueSkin,{
            "w":24,
            "right":0,
            "bottom":-3
         });
         add(this.avatar,{
            "w":68,
            "h":68,
            "vCenter":0
         });
         this.nameText.format.lineHeight = "100%";
         add(this.nameText,{
            "left":78,
            "top":6,
            "w":198
         });
         add(this.clanPanel,{
            "left":78,
            "bottom":6,
            "maxW":198
         });
         add(this.capacityStat,{
            "left":272,
            "vCenter":0
         });
         add(this.grid,{
            "vCenter":0,
            "hCenter":182
         });
         UIFactory.useGridControlNav(this.grid,UIFactory.addNavBt18);
      }
      
      override public function setData(param1:Object) : void
      {
         if(param1 == this.item)
         {
            return;
         }
         this.item = param1 as VORaidMember;
         var _loc2_:PUserBase = this.item.ub;
         this.nameText.layoutH = _loc2_.clan ? 34 : 58;
         this.nameText.syncLayout();
         this.nameText.value = _loc2_.name;
         this.avatar.setUser(_loc2_,this.item.num);
         SkinManager.applyEmbed(this.leagueSkin,"league" + Facade.manualProxy.getLeagueShop(_loc2_.level).division_num);
         this.clanPanel.assignUserClan(_loc2_.clan);
         this.capacityStat.value = this.item.capacity;
         this.grid.setDataProvider(this.item.soldierDp);
      }
   }
}

