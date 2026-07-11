package ui.common
{
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VScrollBar;
   import ui.vbase.VSkin;
   
   public class ValueBar extends VScrollBar
   {
      
      private var skin:VSkin = SkinManager.getEmbed(UIFactory.INDICATOR_GREEN,VSkin.STRETCH);
      
      public function ValueBar()
      {
         var _loc1_:VSkin = SkinManager.getEmbed("ResBg",VSkin.STRETCH);
         var _loc2_:VSkin = SkinManager.getEmbed("ZoomThumb",VSkin.NO_STRETCH | VSkin.ROTATE_90);
         super(_loc1_,_loc2_,VScrollBar.TRACK_DOWN | VScrollBar.HORIZONTAL);
         setSize(166,34);
         add(_loc1_,{
            "wP":100,
            "hP":100
         });
         add(this.skin,{
            "left":6,
            "top":6,
            "bottom":6
         });
         add(SkinManager.getEmbed("ResFg",VSkin.STRETCH),{
            "wP":100,
            "hP":100
         });
         add(_loc2_,{
            "vCenter":0,
            "minH":2,
            "left":7,
            "right":9
         });
         setEnv(2,102);
      }
      
      override protected function syncUI() : void
      {
         super.syncUI();
         this.skin.width = thumbPos - this.skin.hPadding;
      }
   }
}

