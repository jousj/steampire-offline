package game.political
{
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import proto.model.PClanDivision;
   import proto.model.PClanTownhallDivision;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class ClanLeagueUpDialog extends BaseDialog
   {
      
      private var toMapCb:Function;
      
      public function ClanLeagueUpDialog(param1:Function, param2:PClanDivision, param3:String, param4:PClanTownhallDivision, param5:Boolean)
      {
         var _loc8_:RectButton = null;
         var _loc9_:RectButton = null;
         super();
         this.toMapCb = param1;
         useSimpleBg(572,450,Lang.getString("league_up" + (param5 ? "" : "_no")));
         var _loc6_:VSkin = SkinManager.getPack(UIFactory.POLITICAL_PACK,"map" + param4.division);
         _loc6_.scrollRect = new Rectangle(0,0,layoutW - 4,136);
         add(_loc6_,{
            "left":2,
            "right":2,
            "top":37
         },1);
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "left":70,
            "right":18,
            "top":82,
            "h":77
         });
         add(new TownHallLevelPanel(param4.townhall),{
            "left":18,
            "top":78
         });
         add(UIFactory.createDecorText(Lang.getString(param2.cd_region),true,26,422),{
            "left":118,
            "top":105
         });
         add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
            "left":0,
            "right":0,
            "top":171,
            "h":230
         });
         add(SkinManager.getPack(UIFactory.EMBLEM_PACK,param3,0,SkinManager.LOAD_CLIP),{
            "left":28,
            "top":192,
            "w":70,
            "h":70
         });
         add(new VText(Lang.getString("clan_league_up" + (param5 ? "" : "_no")),VText.MIDDLE | VText.CENTER,Style.darkKhakiRGB),{
            "left":108,
            "right":29,
            "top":186,
            "h":84
         });
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "w":530,
            "hCenter":0,
            "top":276,
            "h":100
         });
         add(new VText(Lang.getString("league_prize"),VText.CONTAIN_CENTER,Style.metalRGB),{
            "left":30,
            "right":30,
            "top":288
         });
         var _loc7_:PriceListPanel = new PriceListPanel(12);
         _loc7_.priceMode |= PricePanel.CLAN;
         _loc7_.useVertical(50,60,80);
         _loc7_.assignList(param4.townhall_upgrade_reward);
         add(_loc7_,{
            "top":308,
            "hCenter":0
         });
         _loc8_ = new RectButton(Lang.getString("bt_ok"),RectButton.h56,RectButton.ORANGE);
         _loc8_.addClickListener(close);
         _loc9_ = RectButton.createIconAndTitle(SkinManager.getEmbed("TerritoryIcon"),Lang.getString("to_regions_map"),18,RectButton.GREEN,173);
         _loc9_.layoutW = 173;
         _loc9_.data = true;
         _loc9_.addClickListener(this.toMap);
         add(new VBox(new <VComponent>[_loc8_,_loc9_],20),{
            "hCenter":0,
            "bottom":-17
         });
      }
      
      protected function toMap(param1:MouseEvent) : void
      {
         this.close();
         this.toMapCb();
      }
   }
}

