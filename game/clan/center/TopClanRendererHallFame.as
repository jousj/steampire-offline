package game.clan.center
{
   import game.political.TopClanRendererBase;
   import proto.model.PHallClan;
   import ui.common.CircleButton;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   
   public class TopClanRendererHallFame extends TopClanRendererBase
   {
      
      protected const clanPoint:StatPanel = new StatPanel(SkinManager.getEmbed("ClanEmblemIcon"),null,0,4,32,18);
      
      protected const cupPanel:CupPanel = new CupPanel();
      
      public function TopClanRendererHallFame(param1:Boolean = false)
      {
         super(param1);
         this.clanPoint.hint = Lang.getString("clan_points_text");
         add(this.clanPoint,{
            "vCenter":0,
            "right":200,
            "w":110
         });
         if(param1)
         {
            infoBt.removeFromParent();
            infoBt = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.TEAL,CircleButton.size42);
            infoBt.addVarianceListener(this,INFO);
            add(infoBt,{
               "right":12,
               "vCenter":0
            });
            add(SkinManager.getEmbed("Trophy"),{
               "vCenter":0,
               "left":-6,
               "w":54
            });
         }
         add(this.cupPanel,{
            "vCenter":0,
            "right":61
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PHallClan = param1 as PHallClan;
         update(_loc2_.name,_loc2_.icon,_loc2_.members_count,_loc2_.id);
         this.cupPanel.setData(_loc2_.wins);
         if(!isMy)
         {
            setPlace(dataIndex + 1,0);
         }
         this.clanPoint.value = _loc2_.clan_points;
      }
   }
}

