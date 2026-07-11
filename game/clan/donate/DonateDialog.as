package game.clan.donate
{
   import proto.model.PClanTownhallUnlock;
   import proto.model.clan.PBase;
   import proto.model.clan.PClan;
   import ui.common.BaseDialog;
   
   public class DonateDialog extends BaseDialog
   {
      
      public var panel:DonatePanel;
      
      public function DonateDialog(param1:PClan, param2:PClanTownhallUnlock, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint, param8:uint)
      {
         var _loc9_:PBase = null;
         var _loc10_:int = 0;
         super();
         useWhiteBg(550,0,Lang.getString("clan_donate"));
         this.panel = new DonatePanel(param1,param2,param3,param4,param5,param6,param7,param8);
         this.panel.dispatcher = this;
         _loc9_ = param1.base;
         _loc10_ = 86;
         if(_loc9_.has_capital)
         {
            layoutH = 485;
         }
         else
         {
            layoutH = 579;
            add(new CapitalBuyPanel(_loc9_.gold,false),{
               "hCenter":0,
               "top":_loc10_
            });
            _loc10_ = 180;
         }
         add(this.panel,{
            "top":_loc10_,
            "hCenter":0,
            "h":350,
            "w":500
         });
      }
   }
}

