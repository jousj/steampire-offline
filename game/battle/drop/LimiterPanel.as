package game.battle.drop
{
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class LimiterPanel extends VComponent
   {
      
      private const text:VText = UIFactory.createYellowText(null,VText.CONTAIN_CENTER);
      
      private const maxText:VText = UIFactory.createYellowText(null,VText.CONTAIN_CENTER,13,true);
      
      private const indicator:VSkin = SkinManager.getEmbed("LightRedIndicator",VSkin.STRETCH | VSkin.ROTATE_270);
      
      private var max:uint = 1;
      
      public function LimiterPanel()
      {
         super();
         setSize(38,90);
         var _loc1_:Object = {
            "w":28,
            "hCenter":0,
            "top":0,
            "bottom":16
         };
         add(SkinManager.getEmbed("TrackSPb",VSkin.STRETCH | VSkin.ROTATE_90),_loc1_);
         add(this.indicator,{
            "w":22,
            "hCenter":0,
            "bottom":layoutH - 56
         });
         add(SkinManager.getEmbed("DarkBorder",VSkin.STRETCH),_loc1_);
         add(SkinManager.getEmbed("FeatureIconBg"),{
            "wP":100,
            "bottom":0
         });
         add(this.text,{
            "bottom":8,
            "hCenter":0,
            "wP":100
         });
         add(this.maxText,{
            "left":-4,
            "right":-4,
            "top":-30
         });
      }
      
      public function setMax(param1:uint) : void
      {
         if(param1 == 0)
         {
            param1 = 1;
         }
         this.max = param1;
         this.maxText.value = Lang.getString("limiter_max") + "\n" + param1;
      }
      
      public function set value(param1:uint) : void
      {
         if(param1 > this.max)
         {
            param1 = this.max;
         }
         this.text.value = (this.max - param1).toString();
         this.indicator.layoutH = 52 * (1 - param1 / this.max);
         this.indicator.syncLayout();
         this.indicator.visible = this.indicator.layoutH > 0;
      }
   }
}

