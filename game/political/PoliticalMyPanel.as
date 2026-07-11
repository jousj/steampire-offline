package game.political
{
   import game.clan.donate.TreasuryPanel;
   import game.shop.ShopUnitPanel;
   import proto.model.PCost;
   import proto.model.PReferences;
   import proto.model.clan.PBase;
   import proto.model.clan.PClan;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.common.RectButton;
   import ui.game.ResourcePanel;
   import ui.game.UnitClipPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class PoliticalMyPanel extends VComponent
   {
      
      public var territoryCountText:VText;
      
      public function PoliticalMyPanel()
      {
         super();
      }
      
      public function clearMode() : void
      {
         this.territoryCountText = null;
         removeAllChildren();
      }
      
      public function clanMode(param1:PClan) : void
      {
         var _loc2_:PBase = param1.base;
         add(new VFill(12235690),{
            "top":-2,
            "hCenter":1,
            "wP":100,
            "h":122
         });
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "w":208,
            "h":55,
            "hCenter":0,
            "top":15
         });
         add(SkinManager.getPack(UIFactory.POLITICAL_PACK,"MyArea"),{
            "left":25,
            "top":19
         });
         add(new VText(_loc2_.name,VText.CENTER | VText.MIDDLE,Style.metalRGB),{
            "left":5,
            "right":5,
            "top":77,
            "h":40
         });
         add(SkinManager.getPack(UIFactory.EMBLEM_PACK,_loc2_.icon),{
            "top":4,
            "hCenter":0,
            "h":75
         });
         this.territoryCountText = new VText(null,VText.CONTAIN_CENTER,16777215,20);
         Style.applyGlowFilter(this.territoryCountText,0,4);
         add(this.territoryCountText,{
            "left":27,
            "top":34,
            "w":37
         });
         var _loc3_:UnitClipPanel = new UnitClipPanel();
         _loc3_.show("bl_town_hall",param1.townhall_level == 0 ? 1 : param1.townhall_level);
         add(_loc3_,{
            "top":15,
            "right":17,
            "w":55,
            "h":55
         });
         add(SkinManager.getEmbed("ClanMarker"),{
            "right":18,
            "top":47
         });
         if(param1.townhall_level > 0)
         {
            add(new LevelPanel(LevelPanel.size28,param1.townhall_level),{
               "top":10,
               "right":12
            });
         }
         add(SkinManager.getEmbed("GridSeparator",VSkin.STRETCH),{
            "top":120,
            "left":1,
            "right":-1
         });
         add(UIFactory.createYellowText(Lang.getString("clan_resources"),VText.CONTAIN_CENTER),{
            "left":6,
            "right":6,
            "top":138
         });
         add(new VBox(new <VComponent>[TreasuryPanel.createResPanel(PCost.GOLD,_loc2_.gold,0),TreasuryPanel.createResPanel(PCost.MITHRIL,_loc2_.mithril,Facade.references.clan_mithril_limit),TreasuryPanel.createResPanel(PCost.OIL,_loc2_.oil,param1.storage_max_oil),TreasuryPanel.createResPanel(PCost.CRYSTAL,_loc2_.crystal,param1.storage_max_crystal)],10,VBox.VERTICAL | VBox.STRETCH),{
            "w":200,
            "top":164,
            "hCenter":0
         });
         var _loc4_:PReferences = Facade.references;
         var _loc5_:ResourcePanel = TreasuryPanel.createResPanel(PCost.TROPHY,param1.trophy,param1.base.has_capital ? uint(_loc4_.trophy_gen_cap_limit) : uint(_loc4_.trophy_gen_limit));
         _loc5_.addHeader(Lang.getPatternString("trophy_gen","__COUNT__",String(86400 / (param1.base.has_capital ? _loc4_.trophy_gen_cap_time : _loc4_.trophy_gen_time))));
         add(_loc5_,{
            "top":380,
            "w":200,
            "h":37,
            "hCenter":0
         });
      }
      
      public function loadMode() : void
      {
         add(UIFactory.createYellowText(Lang.getString("load_title"),VText.CENTER),{
            "wP":100,
            "vCenter":0
         });
      }
      
      public function searchMode() : void
      {
         var _loc3_:RectButton = null;
         var _loc1_:ShopUnitPanel = new ShopUnitPanel();
         _loc1_.show("bl_clan_center",1);
         _loc1_.setSize(200,190);
         var _loc2_:VText = UIFactory.createYellowText(Lang.getString("territory_no_clan"),VText.CENTER,16);
         _loc2_.layoutW = 210;
         _loc3_ = new RectButton(Lang.getString("clan_search"),RectButton.h42);
         _loc3_.layoutW = 180;
         _loc3_.addVarianceListener(this,PoliticalMapDialog.TO_TOPS);
         add(new VBox(new <VComponent>[_loc1_,_loc2_,_loc3_],14,VBox.VERTICAL),{
            "vCenter":-20,
            "hCenter":0
         });
      }
   }
}

