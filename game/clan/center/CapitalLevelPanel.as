package game.clan.center
{
   import flash.filters.GlowFilter;
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class CapitalLevelPanel extends VComponent
   {
      
      public const text:VText = new VText(null,VText.CONTAIN_CENTER,Style.yellowRGB,16);
      
      public function CapitalLevelPanel(param1:uint = 0)
      {
         super();
         setSize(34,28);
         var _loc2_:VSkin = SkinManager.getEmbed("CapitalFlagIcon");
         _loc2_.filters = [new GlowFilter(14869218,1,4,4,8)];
         add(_loc2_,{
            "h":34,
            "hCenter":0,
            "top":-6
         });
         Style.applyGlowFilter(this.text,5066061,6);
         add(this.text,{
            "vCenter":3,
            "wP":100
         });
         if(param1 > 0)
         {
            this.text.value = param1.toString();
         }
      }
   }
}

