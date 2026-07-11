package ui.common
{
   import ui.UIFactory;
   import ui.vbase.VButton;
   import ui.vbase.VGrid;
   import ui.vbase.VText;
   
   public class VerticalTabDialog extends BaseTabDialog
   {
      
      public var grid:VGrid;
      
      private var titleText:VText;
      
      public function VerticalTabDialog()
      {
         super(71);
         layoutW = 800;
         minH = 370;
         this.titleText = addDialogTitle(null,true);
      }
      
      public function createGrid(param1:Class, param2:uint = 1, param3:uint = 14, param4:uint = 128) : void
      {
         if(this.grid)
         {
            remove(this.grid);
         }
         this.grid = new VGrid(1,param2,param1,null,0,param3,param4);
         this.grid.dispatcher = this;
         add(this.grid,{
            "hCenter":7,
            "top":100,
            "bottom":32
         });
         UIFactory.useGridControlV33(this.grid);
      }
      
      override protected function setTabStatus(param1:VButton, param2:Boolean) : void
      {
         super.setTabStatus(param1,param2);
         if(param2)
         {
            this.titleText.value = String(param1.hint);
         }
      }
      
      override protected function calcContentSize() : void
      {
         if(this.grid)
         {
            contentH = this.grid.measuredHeight + this.grid.vPadding;
         }
         else
         {
            super.calcContentSize();
         }
      }
      
      public function setDp(param1:Array, param2:uint = 0) : void
      {
         this.grid.setDataProvider(param1,param2);
      }
      
      public function syncDp() : void
      {
         this.grid.sync();
      }
   }
}

