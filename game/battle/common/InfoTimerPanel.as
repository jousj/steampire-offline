package game.battle.common
{
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class InfoTimerPanel extends VComponent
   {
      
      public const titleText:VText = new VText();
      
      public const valueText:VText = new VText();
      
      public function InfoTimerPanel(param1:String, param2:uint = 0)
      {
         super();
         mouseChildren = mouseEnabled = false;
         hCenter = 0;
         this.titleText.value = param1;
         Style.applyGlowFormat(this.titleText,22,14738397,2959400);
         add(this.titleText,{"hCenter":0});
         Style.applyDefaultFormat(this.valueText,20);
         var _loc3_:VSkin = SkinManager.getEmbed("ClockIcon");
         if(param2 > 0)
         {
            _loc3_.setSize(param2,param2);
         }
         add(new VBox(new <VComponent>[_loc3_,this.valueText]),{
            "hCenter":0,
            "bottom":0
         });
      }
   }
}

