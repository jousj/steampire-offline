package clans
{
   import game.clan.center.TextInfoDialog;
   import game.common.DialogMediator;
   import logic.DialogLogic;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   
   public class ClanMedialor extends DialogMediator
   {
      
      public var dialog:ClanDialog;
      
      public function ClanMedialor()
      {
         super();
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog = new ClanDialog();
         this.dialog.tabPanel.addListener(VEvent.CHANGE,this.onTabChange);
         this.dialog.infoBt.addClickListener(this.onInfo);
         return this.dialog;
      }
      
      private function onInfo(param1:*) : void
      {
         DialogLogic.open(new TextInfoDialog("help_clan_points_title","help_clan_points"));
      }
      
      private function onTabChange(param1:*) : void
      {
         switch(this.dialog.tabPanel.index)
         {
            case ClanDialog.INFO:
            case ClanDialog.MAP:
            case ClanDialog.WAR:
            case ClanDialog.TOPS:
         }
         this.dialog.setTab(this.dialog.tabPanel.index);
      }
   }
}

