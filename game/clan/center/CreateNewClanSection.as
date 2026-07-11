package game.clan.center
{
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.game.PricePanel;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   
   public class CreateNewClanSection extends VComponent
   {
      
      public function CreateNewClanSection()
      {
         super();
         layoutH = 237;
         add(ClanCenterFactory.createFill(),{
            "wP":100,
            "top":0,
            "bottom":21
         });
         add(UIFactory.createYellowText(Lang.getString("clan_create_title"),VText.CONTAIN_CENTER),{
            "left":10,
            "right":10,
            "top":8
         });
         var _loc1_:VText = new VText(Lang.getString("clan_create_desc"),VText.CENTER,Style.darkKhakiRGB,14);
         _loc1_.format.lineHeight = "130%";
         add(_loc1_,{
            "left":10,
            "top":34,
            "right":10,
            "h":116
         });
         add(new VText(Lang.getString("price"),VText.CONTAIN_CENTER,Style.metalRGB,16),{
            "left":10,
            "right":10,
            "bottom":80
         });
         var _loc2_:PricePanel = new PricePanel(20,18,PricePanel.GLOW_FILTER);
         _loc2_.assignCost(Facade.references.create_clan_price);
         add(_loc2_,{
            "hCenter":0,
            "bottom":51
         });
         var _loc3_:RectButton = new RectButton(Lang.getString("new_clan"),RectButton.h42,RectButton.ORANGE);
         add(_loc3_,{
            "hCenter":0,
            "bottom":0,
            "minW":145,
            "maxW":220
         });
         _loc3_.addVarianceListener(this,ClanCenterFactory.EDIT_CLAN);
      }
   }
}

