package game.feature
{
   import ui.UIFactory;
   import ui.vbase.VComponent;
   import ui.vbase.VGrid;
   import ui.vbase.VText;
   
   public class CampSoldierPanel extends VComponent
   {
      
      public const grid:VGrid = new VGrid(1,1,CampRenderer,null,7);
      
      public function CampSoldierPanel(param1:String = null, param2:uint = 4018009)
      {
         super();
         var _loc3_:Boolean = Boolean(param1);
         if(_loc3_)
         {
            addChild(new VText(param1,VText.CONTAIN_CENTER,param2,16).assignW(-100));
         }
         add(this.grid,{
            "hCenter":0,
            "top":(_loc3_ ? 19 : 0)
         });
         UIFactory.useGridControlNav(this.grid,UIFactory.addNavBt18);
      }
      
      public function setDp(param1:Array, param2:uint) : void
      {
         this.grid.changeRendererCount(param1.length > param2 ? param2 : param1.length,1,param1);
      }
   }
}

