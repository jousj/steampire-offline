package game.clan.center
{
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   
   public class MembersDialog extends BaseDialog
   {
      
      public var grid:VGrid = new VGrid(1,10,ClanMemberRenderer,null,0,0,VGrid.H_STRETCH);
      
      public var chestStat:ClanChestReward = new ClanChestReward();
      
      public function MembersDialog()
      {
         super();
         useDefaultBg(620,Lang.getString("clan_member_list"));
         UIFactory.addGridWithBg(this.grid,this,false,84,20,20,false);
         UIFactory.useGridControl(this.grid,UIFactory.addNavBt30);
         this.grid.add(new VFill(16509863,0.2),{
            "left":-1,
            "hP":100,
            "w":41
         });
         add(this.chestStat,{
            "left":700,
            "top":10
         });
      }
   }
}

