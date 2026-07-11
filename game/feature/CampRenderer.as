package game.feature
{
   import flash.display.BlendMode;
   import model.ui.VOBattleItem;
   import ui.game.SquareSoldierPanel;
   import ui.vbase.VRenderer;
   
   public class CampRenderer extends VRenderer
   {
      
      protected const soldierPanel:SquareSoldierPanel = new SquareSoldierPanel();
      
      public function CampRenderer()
      {
         super();
         setSize(82,82);
         mouseChildren = false;
         this.soldierPanel.useLevelPanel();
         addStretch(this.soldierPanel);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:Boolean = param1 is VOBattleItem;
         if(_loc2_)
         {
            this.soldierPanel.assignBattleItem(param1 as VOBattleItem,this);
         }
         else
         {
            this.soldierPanel.clear();
         }
         if(_loc2_ != (alpha == 1))
         {
            if(_loc2_)
            {
               alpha = 1;
               this.soldierPanel.blendMode = BlendMode.NORMAL;
            }
            else
            {
               alpha = 0.3;
               this.soldierPanel.blendMode = BlendMode.LAYER;
            }
         }
      }
   }
}

