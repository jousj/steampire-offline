package game.clan.center
{
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   
   public class CreateTopClansSection extends VComponent
   {
      
      public function CreateTopClansSection()
      {
         super();
         layoutH = 237;
         add(ClanCenterFactory.createFill(),{
            "wP":100,
            "top":0,
            "bottom":21
         });
         add(UIFactory.createYellowText(Lang.getString("clan_join_title"),VText.CONTAIN_CENTER),{
            "left":10,
            "right":10,
            "top":8
         });
         var _loc1_:VText = new VText(Lang.getString("clan_join_desc"),VText.CENTER,Style.darkKhakiRGB,14);
         _loc1_.format.lineHeight = "130%";
         add(_loc1_,{
            "left":10,
            "top":34,
            "right":10,
            "h":160
         });
         var _loc2_:RectButton = new RectButton(Lang.getString("clan_tops"),RectButton.h42);
         add(_loc2_,{
            "hCenter":0,
            "bottom":0,
            "minW":145,
            "maxW":220
         });
         _loc2_.addVarianceListener(this,ClanCenterFactory.TOP_CLANS);
      }
   }
}

