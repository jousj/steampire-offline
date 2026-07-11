package game.quest
{
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.VGrid;
   
   public class QuestDialog extends BaseDialog
   {
      
      public static const SHOW_ALL_QUEST:uint = 1;
      
      public static const SHOW_ONE_QUEST:uint = 2;
      
      public static const REWARD_BT:uint = 100;
      
      public static const SPEEDUP_BT:uint = 101;
      
      public static const HELP_BT:uint = 102;
      
      public const grid:VGrid = new VGrid(1,3,QuestRenderer,null,0,14,VGrid.USE_VISIBLE_CALC_LAYOUT);
      
      public function QuestDialog()
      {
         super();
         useSimpleBg(800,0,Lang.getString("quests"));
         this.grid.dispatcher = this;
         add(this.grid,{
            "hCenter":0,
            "top":82,
            "bottom":34
         });
         UIFactory.useGridControlV33(this.grid);
      }
   }
}

