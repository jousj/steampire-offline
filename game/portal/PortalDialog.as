package game.portal
{
   import proto.model.PCost;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.game.ResourcePanel;
   import ui.vbase.VCheckbox;
   import ui.vbase.VGrid;
   
   public class PortalDialog extends BaseDialog
   {
      
      public const grid:VGrid = new VGrid(1,3,PortalRenderer,null,0,10,VGrid.H_STRETCH | VGrid.USE_VISIBLE_CALC_LAYOUT | VGrid.USE_END_LIMIT);
      
      public const gloryPanel:ResourcePanel = new ResourcePanel(PCost.H_GLORY,ResourcePanel.BG | ResourcePanel.TWEEN);
      
      public const friendsCb:VCheckbox = UIFactory.createCheckbox(Lang.getString("raid_with_friends"));
      
      public function PortalDialog(param1:Array)
      {
         super();
         useDefaultBg(0,Lang.getString("bl_portal"),276);
         add(this.gloryPanel,{
            "top":15,
            "right":82
         });
         this.grid.dispatcher = this;
         add(this.grid,{
            "left":22,
            "right":26,
            "top":80,
            "bottom":57
         });
         UIFactory.useGridControlV33(this.grid);
         this.grid.setDataProvider(param1);
         add(this.friendsCb,{
            "right":17,
            "bottom":23,
            "maxW":320
         });
      }
   }
}

