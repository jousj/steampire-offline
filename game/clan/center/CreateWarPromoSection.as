package game.clan.center
{
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class CreateWarPromoSection extends VComponent
   {
      
      public function CreateWarPromoSection()
      {
         super();
         layoutH = 237;
         add(ClanCenterFactory.createFill(),{
            "wP":100,
            "top":22,
            "bottom":0
         });
         add(UIFactory.createYellowText(Lang.getString("news_clan_wars_title"),VText.CONTAIN),{
            "left":10,
            "right":10
         });
         add(SkinManager.getEmbed("ChBox",VSkin.STRETCH),{
            "left":20,
            "top":46,
            "w":228,
            "h":158
         });
         add(SkinManager.getEmbed("war_promo"),{
            "left":24,
            "top":50
         });
         add(new VText(Lang.getString("clan_war_promo"),VText.CENTER | VText.MIDDLE,Style.metalRGB,16),{
            "left":250,
            "right":12,
            "top":37,
            "h":100
         });
         var _loc1_:RectButton = new RectButton(Lang.getString("cur_war_list"),RectButton.h42,RectButton.ORANGE);
         _loc1_.addVarianceListener(this,ClanCenterFactory.TO_WAR_LIST);
         add(_loc1_,{
            "hCenter":120,
            "bottom":14,
            "minW":170,
            "maxW":240
         });
      }
   }
}

