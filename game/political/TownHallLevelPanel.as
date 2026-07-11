package game.political
{
   import ui.common.LevelPanel;
   import ui.game.UnitClipPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   
   public class TownHallLevelPanel extends VComponent
   {
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size34);
      
      private const unitPanel:UnitClipPanel = new UnitClipPanel();
      
      private var cacheValue:uint;
      
      public function TownHallLevelPanel(param1:uint = 0)
      {
         super();
         setSize(85,85);
         addStretch(SkinManager.getEmbed("TrainCircleBg"));
         add(this.unitPanel,{
            "top":9,
            "left":9,
            "w":layoutW - 20,
            "h":layoutH - 20
         });
         add(this.levelPanel,{
            "right":0,
            "top":-1
         });
         add(SkinManager.getEmbed("ClanMarker"),{
            "right":12,
            "bottom":12,
            "h":25
         });
         if(param1 > 0)
         {
            this.value = param1;
         }
      }
      
      public function set value(param1:uint) : void
      {
         if(this.cacheValue != param1)
         {
            this.cacheValue = param1;
            this.unitPanel.show("bl_town_hall",param1);
            this.levelPanel.value = param1;
         }
      }
   }
}

