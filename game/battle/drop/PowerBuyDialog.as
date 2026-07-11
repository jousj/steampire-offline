package game.battle.drop
{
   import proto.model.PCost;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.game.ResourcePanel;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VGrid;
   import ui.vbase.VText;
   
   public class PowerBuyDialog extends BaseDialog
   {
      
      public var grid:VGrid;
      
      public function PowerBuyDialog(param1:Array, param2:uint)
      {
         var _loc4_:VText = null;
         super();
         useWhiteBg(0,0);
         addDialogTitle(Lang.getString("power"),false,200);
         var _loc3_:ResourcePanel = new ResourcePanel(PCost.GOLD,ResourcePanel.BG);
         _loc3_.setData(param2);
         add(_loc3_,{
            "right":64,
            "top":14,
            "w":128,
            "h":39
         });
         _loc4_ = new VText(Lang.getString("buy_power_info"),VText.CENTER,Style.darkKhakiRGB,16);
         _loc4_.layoutW = 430;
         this.grid = new VGrid(2,1,PowerBuyRenderer,param1,8);
         this.grid.dispatcher = this;
         add(new VBox(new <VComponent>[_loc4_,this.grid],7,VBox.VERTICAL),{
            "left":22,
            "right":22,
            "top":78,
            "bottom":24
         });
         UIFactory.useGridControlH43(this.grid,false);
      }
   }
}

