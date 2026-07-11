package game.rank
{
   import ui.UIFactory;
   import ui.vbase.GridControl;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VGrid;
   import ui.vbase.VPager;
   import ui.vbase.VProgressBar;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class AchievementPanel extends VComponent
   {
      
      public const grid:VGrid = new VGrid(1,3,AchievementRenderer,null,0,8,VGrid.H_STRETCH);
      
      public const pb:VProgressBar = UIFactory.createProgressBar("LightGreenIndicator");
      
      public const pbText:VText = UIFactory.createYellowText(null,VText.CENTER,18,true);
      
      public function AchievementPanel()
      {
         super();
         layoutW = 762;
         this.grid.dispatcher = this;
         this.grid.layoutW = -100;
         addChild(this.grid);
         UIFactory.useGridControlH43(this.grid,false,GridControl.PAGER_CALC_COUNT | GridControl.NAV_BT_DISABLED,this.addPager);
         add(this.pb,{
            "left":49,
            "right":0,
            "bottom":14,
            "h":37
         });
         add(this.pbText,{
            "left":70,
            "right":14,
            "bottom":23
         });
         add(SkinManager.getEmbed("FeatureIconBg",VSkin.STRETCH),{
            "left":15,
            "bottom":10,
            "w":50,
            "h":46
         });
         add(SkinManager.getEmbed("AchvPointsIcon"),{
            "left":16,
            "bottom":11
         });
      }
      
      public function sync(param1:uint, param2:uint) : void
      {
         this.pbText.value = param1 + "/" + param2;
         this.pb.value = param1 / param2;
         this.grid.sync();
      }
      
      private function addPager(param1:VGrid, param2:VPager) : void
      {
         add(param2,{
            "hCenter":0,
            "bottom":-36
         });
      }
   }
}

