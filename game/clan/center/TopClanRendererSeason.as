package game.clan.center
{
   import game.political.TopClanRendererBase;
   import proto.model.PClanTopRecord;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   
   public class TopClanRendererSeason extends TopClanRendererBase
   {
      
      protected const ratingStat:StatPanel = new StatPanel(SkinManager.getEmbed("ClanEmblemIcon"),null,0,4,32,18);
      
      protected const chest:ClanChestReward = new ClanChestReward();
      
      public function TopClanRendererSeason(param1:Boolean = false)
      {
         super(param1);
         this.ratingStat.hint = Lang.getString("ClanEmblemIcon");
         add(this.ratingStat,{
            "vCenter":0,
            "right":200,
            "w":110
         });
         add(this.chest,{
            "vCenter":0,
            "right":100
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PClanTopRecord = param1 as PClanTopRecord;
         setPlace(_loc2_.place,TopClansDialog.seasonLineCount);
         this.chest.setData(_loc2_.place);
         this.ratingStat.value = _loc2_.clan_points;
         super.update(_loc2_.name,_loc2_.icon,_loc2_.members_count,_loc2_.id);
      }
   }
}

