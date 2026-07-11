package game.clan.center
{
   import proto.model.PClanReward;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   
   public class ClanChestReward extends VSkin
   {
      
      public function ClanChestReward(param1:int = -1)
      {
         super();
         if(param1 >= 0)
         {
            this.setData(param1);
         }
      }
      
      public function setData(param1:int) : void
      {
         mouseEnabled = true;
         var _loc2_:int = Facade.manualProxy.getClanRewardIndex(param1);
         var _loc3_:PClanReward = Facade.manualProxy.getClanReward(param1);
         hint = Lang.getString("chest_" + (5 - _loc3_.prize.length));
         SkinManager.applyEmbed(this,"ClanChest_" + _loc2_);
         visible = param1 >= 0;
      }
   }
}

