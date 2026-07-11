package game.clan.center
{
   import game.political.TopClansPanel;
   import ui.Style;
   import ui.vbase.VBox;
   import ui.vbase.VText;
   
   public class SeasonPanel extends TopClansPanel
   {
      
      private const infoText:VText = new VText(Lang.getString("season_finish"),VText.CENTER,Style.metalRGB,14);
      
      private const timer:TimePanelSeason = new TimePanelSeason();
      
      private const box:VBox = new VBox(null,10);
      
      public function SeasonPanel(param1:Number, param2:int)
      {
         super(param2,32,0,0,-48,TopClanRendererSeason);
         hCenter = 0;
         layoutW = -100;
         this.infoText.format.lineHeight = "100%";
         add(this.infoText,{
            "top":6,
            "right":10
         });
         add(this.box,{
            "top":2,
            "right":10
         });
         this.box.add(new VText(Lang.getString("end_season_time"),VText.CENTER,Style.metalRGB,14));
         this.box.add(this.timer);
         this.timer.assign(param1,0);
      }
      
      public function setCurSeason(param1:Boolean) : void
      {
         this.box.visible = param1;
         this.infoText.visible = !param1;
      }
   }
}

