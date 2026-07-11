package game.battle.common
{
   import ui.UIFactory;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   
   public class BattleRatioPanel extends VComponent
   {
      
      private const incStatPanel:StatPanel = new StatPanel(SkinManager.getEmbed("RatingIcon"),null,StatPanel.YELLOW_TEXT);
      
      private const decStatPanel:StatPanel = new StatPanel(SkinManager.getEmbed("RatingIcon"),null,StatPanel.YELLOW_TEXT);
      
      public function BattleRatioPanel()
      {
         super();
         setSize(188,82);
         mouseChildren = false;
         var _loc1_:VText = UIFactory.createYellowText(Lang.getString("ratio_win"),VText.CENTER | VText.MIDDLE,14,true);
         _loc1_.format.lineHeight = "100%";
         add(_loc1_,{
            "top":4,
            "w":114,
            "h":32
         });
         add(this.incStatPanel,{
            "right":8,
            "top":5,
            "w":59
         });
         _loc1_ = UIFactory.createYellowText(Lang.getString("ratio_loss"),VText.CENTER | VText.MIDDLE,14,true);
         _loc1_.format.lineHeight = "100%";
         add(_loc1_,{
            "bottom":4,
            "w":114,
            "h":34
         });
         add(this.decStatPanel,{
            "right":8,
            "bottom":5,
            "w":59
         });
      }
      
      public function assign(param1:int, param2:int) : void
      {
         this.incStatPanel.text.value = "+" + param1;
         this.decStatPanel.text.value = "-" + param2;
      }
   }
}

