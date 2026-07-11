package ui.game
{
   import proto.model.PPhfClan;
   import proto.model.PUserClan;
   import ui.UIFactory;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   
   public class ClanPanel extends StatPanel
   {
      
      public var nameCharMax:uint;
      
      private const emblemSkin:VSkin = new VSkin();
      
      public function ClanPanel(param1:uint = 0, param2:uint = 3, param3:uint = 30, param4:uint = 18)
      {
         this.emblemSkin.maxW = param3;
         super(this.emblemSkin,null,param1,param2,param3,param4);
      }
      
      public function assign(param1:String, param2:String) : void
      {
         SkinManager.applyExternal(this.emblemSkin,UIFactory.EMBLEM_PACK,param2);
         text.value = this.nameCharMax > 4 && param1.length > this.nameCharMax + 3 ? param1.substr(0,this.nameCharMax) + "..." : param1;
      }
      
      private function reset() : void
      {
         this.emblemSkin.resetContent();
         text.value = null;
      }
      
      public function assignUserClan(param1:PUserClan) : void
      {
         if(param1)
         {
            this.assign(param1.uc_name,param1.uc_icon);
         }
         else
         {
            this.reset();
         }
      }
      
      public function assignClan(param1:PPhfClan) : void
      {
         if(param1)
         {
            this.assign(param1.phf_name,param1.phf_icon);
         }
         else
         {
            this.reset();
         }
      }
      
      public function noClan() : void
      {
         this.emblemSkin.resetContent();
         text.value = Lang.getString("no_clan");
      }
   }
}

