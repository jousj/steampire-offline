package logic.training.firstsession
{
   import engine.units.Build;
   import game.my.GoDialog;
   import game.portal.PortalDialog;
   import game.portal.PortalMediator;
   import game.portal.PortalRenderer;
   import game.portal.StartRaidDialog;
   import logic.CoreLogic;
   import logic.MainLogic;
   import logic.quests.QuestTrain;
   import logic.training.BlackoutClickStep;
   import logic.training.NewStoryStep;
   import model.vo.VORaidMember;
   import proto.model.PBtype;
   import proto.model.PCost;
   import proto.model.PUserBase;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   
   public class NewPortalTrain extends QuestTrain
   {
      
      private var dialog:StartRaidDialog;
      
      private var dp:Array;
      
      public function NewPortalTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc1_:Build = null;
         if(!item.isComplete)
         {
            _loc1_ = Facade.userProxy.getBuild(PBtype.RAID,false);
            if(!_loc1_)
            {
               return;
            }
            Facade.mainMediator.closeAllDialog();
            Facade.boardMediator.resetMoved();
            Facade.board.mouseChildren = false;
            boardLock = true;
            Facade.boardMediator.moveBoard(_loc1_.b_x - 1,_loc1_.b_y + 1);
            assignStep(new NewStoryStep("un_dwarf1",Lang.getString("dwarf_raid_1")).useMultipleSay(),this.nextDwarfPhrase);
         }
      }
      
      private function nextDwarfPhrase() : void
      {
         Facade.changeUserStage("home3_dwarf1_click");
         assignStep(new NewStoryStep("un_dwarf1",Lang.getString("dwarf_raid_2")).useMultipleSay(),this.lastDwatfPhrase);
      }
      
      private function lastDwatfPhrase() : void
      {
         Facade.changeUserStage("home3_dwarf2_click");
         assignStep(new NewStoryStep("un_dwarf1",Lang.getString("dwarf_raid_3")),this.stepPortalOpen);
      }
      
      override public function dispose() : void
      {
         boardLock = false;
         Facade.board.mouseChildren = true;
         super.dispose();
      }
      
      private function stepPortalButton() : void
      {
         Facade.changeUserStage("home3_dwarf3_click");
         assignStep(new BlackoutClickStep(Facade.myMediator.myPanel.goBt,-40,{
            "left":5,
            "top":5
         }),this.onGoOpen);
      }
      
      private function onGoOpen() : void
      {
         var _loc1_:GoDialog = Facade.mainMediator.searchDialog(GoDialog);
         if(_loc1_)
         {
            Facade.changeUserStage("home3_attack_click");
            assignStep(new BlackoutClickStep(_loc1_.raidBt,0,{
               "hCenter":0,
               "top":4
            },null,false),this.stepPortalOpen);
         }
      }
      
      private function stepPortalOpen() : void
      {
         var _loc2_:RectButton = null;
         Facade.mainMediator.searchDialog(GoDialog,true);
         Facade.mainMediator.showDialog(new PortalMediator());
         var _loc1_:PortalDialog = Facade.mainMediator.searchDialog(PortalDialog);
         if(_loc1_)
         {
            Facade.changeUserStage("home3_raid_click");
            _loc2_ = (_loc1_.grid.renderList[1] as PortalRenderer).bt;
            if(_loc2_)
            {
               assignStep(new BlackoutClickStep(_loc2_,-90,{"top":26},null,false),this.stepRaidStart);
               return;
            }
         }
         this.dispose();
      }
      
      private function stepRaidStart() : void
      {
         Facade.changeUserStage("home3_fake_raid_click");
         Facade.mainMediator.closeAllDialog();
         CoreLogic.pause = true;
         this.dialog = new StartRaidDialog("rd_storm",Facade.references.raid_members_count,[PCost.create(PCost.H_GLORY,25)]);
         this.dialog.portalBt.visible = false;
         this.dialog.closeBt.disabled = true;
         var _loc1_:VORaidMember = new VORaidMember();
         _loc1_.assign(Facade.userProxy.base,1);
         _loc1_.addSoldierItem("un_warrior",1,10);
         _loc1_.addSoldierItem("un_sniper",1,10);
         this.dp = [_loc1_];
         _loc1_ = new VORaidMember();
         var _loc2_:PUserBase = new PUserBase();
         _loc2_.name = Lang.getString("un_dwarf");
         _loc2_.user_id = "dwarf";
         _loc2_.avatar = SkinManager.url + "images/un_dwarf1.png";
         _loc2_.level = 50;
         _loc1_.assign(_loc2_,2);
         _loc1_.addSoldierItem("un_dwarf",4,30);
         this.dp.push(_loc1_);
         this.dialog.setMembers(this.dp);
         this.dialog.setSearchMode(CoreLogic.serverTime + 10);
         Facade.mainMediator.showDialog(this.dialog);
         Facade.changeUserStage("fr_team_waiting");
         wait(2,this.stepBotWait);
      }
      
      private function stepBotWait() : void
      {
         Facade.changeUserStage("fr_dwarf_raid_1_close");
         wait(3,this.stepBotJoin);
      }
      
      private function stepBotJoin() : void
      {
         var _loc1_:VORaidMember = new VORaidMember();
         var _loc2_:PUserBase = new PUserBase();
         _loc2_.name = Lang.getString("raid_bot_name");
         _loc2_.user_id = "raid_bot";
         _loc2_.avatar = SkinManager.url + "images/raid_plr_avatar.png";
         _loc2_.level = 20;
         _loc1_.assign(_loc2_,3);
         _loc1_.addSoldierItem("un_motocycle",1,10);
         this.dp.push(_loc1_);
         this.dialog.setMembers(this.dp);
         wait(3,this.stepBattle);
      }
      
      private function stepBattle() : void
      {
         this.dialog.close();
         Facade.changeUserStage("fr_dwarf_raid_2_close");
         MainLogic.getFriendMap("ms_fake_raid",true,false,5);
      }
   }
}

