package game.history
{
   import model.ui.VOBattleItem;
   import ui.Style;
   import ui.game.SquareSoldierPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class SoldierHistoryRenderer extends VRenderer
   {
      
      private const soldierPanel:SquareSoldierPanel = new SquareSoldierPanel();
      
      private var deadText:VText;
      
      private var deadSkin:VSkin;
      
      public function SoldierHistoryRenderer()
      {
         super();
         setSize(68,68);
         mouseChildren = false;
         this.soldierPanel.useLevelPanel();
         addStretch(this.soldierPanel);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:VOBattleItem = param1 as VOBattleItem;
         this.soldierPanel.assignBattleItem(_loc2_,this);
         if(Boolean(_loc2_) && _loc2_.select > 0)
         {
            if(!this.deadText)
            {
               this.deadSkin = SkinManager.getEmbed("TombIcon");
               add(this.deadSkin,{
                  "right":0,
                  "bottom":-4
               });
               this.deadText = new VText(null);
               Style.applyDefaultFormat(this.deadText,14);
               add(this.deadText,{
                  "right":0,
                  "bottom":2
               });
            }
            this.deadText.value = "-" + _loc2_.select;
         }
         else if(this.deadText)
         {
            remove(this.deadText);
            remove(this.deadSkin);
            this.deadText = null;
            this.deadSkin = null;
         }
      }
   }
}

