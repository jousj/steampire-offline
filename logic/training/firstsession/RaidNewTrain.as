package logic.training.firstsession
{
   import engine.Position;
   import engine.signal.Signal;
   import engine.units.Build;
   import game.battle.BattleMediator;
   import game.battle.drop.DropRenderer;
   import game.battle.raid.SayPanel;
   import game.battle.result.BattleResultDialog;
   import game.board.BoardMediator;
   import logic.BoardLogic;
   import logic.CoreLogic;
   import logic.MainLogic;
   import logic.battle.SimVisual;
   import logic.training.AbstractTrain;
   import logic.training.ClickStep;
   import logic.training.CmdStep;
   import logic.training.Mission1Train;
   import logic.training.NewStoryStep;
   import logic.training.SoftDropStep;
   import logic.training.SoftHintStep;
   import model.CommonEvent;
   import model.ui.VOBattleItem;
   import model.ui.VOWinItem;
   import model.vo.VORaidMember;
   import proto.model.PBtype;
   import proto.model.PCost;
   import proto.model.PMissionWin;
   import proto.model.PUserBase;
   import ui.vbase.SkinManager;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   
   public class RaidNewTrain extends AbstractTrain
   {
      
      private const cooldownSignal:Signal = new Signal();
      
      private const bm:BoardMediator = Facade.boardMediator;
      
      private const btm:BattleMediator = Facade.battleMediator;
      
      private var targetCount:uint;
      
      private var dropCount:uint;
      
      private var targetRenderer:DropRenderer;
      
      private var sayPanel:SayPanel;
      
      private var myMember:VORaidMember;
      
      private var dwarfMember:VORaidMember;
      
      private var botMember:VORaidMember;
      
      private var dwarfList:Vector.<int>;
      
      public function RaidNewTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc2_:Build = null;
         Mission1Train.clearSoldierDp();
         this.btm.rivalPanel.nameText.value = Lang.getString("rd_storm");
         this.btm.rivalPanel.myResourceVisible = true;
         var _loc1_:Vector.<Build> = new Vector.<Build>();
         Facade.userProxy.getBuild(PBtype.STORAGE,true,0,_loc1_);
         for each(_loc2_ in _loc1_)
         {
            _loc2_.setStatus(SkinManager.getEmbed("TargetStatus",VSkin.CACHE_AS_BITMAP));
         }
         this.btm.bp.winList.push(new VOWinItem(PMissionWin.create(_loc2_.kind,_loc2_.level,3),3));
         _loc2_ = Facade.userProxy.getBuild(PBtype.TOWNHALL,true);
         this.btm.bp.winList.push(new VOWinItem(PMissionWin.create(_loc2_.kind,_loc2_.level,1),1));
         _loc2_.setStatus(SkinManager.getEmbed("TargetStatus",VSkin.CACHE_AS_BITMAP));
         this.btm.battlePanel.setWinTarget(this.btm.bp.winList,this.btm.onToWinTarget);
         this.bm.moveBoard(11,20);
         Facade.myMediator.changeZoom(0.65);
         assignStep(new NewStoryStep("un_dwarf1",Lang.getString("dwarf_raid_4")).useMultipleSay(),this.step1);
      }
      
      private function step1() : void
      {
         Facade.changeUserStage("raid_dwarf1_click");
         assignStep(new NewStoryStep("un_dwarf1",Lang.getString("dwarf_raid_5")),this.step2);
      }
      
      private function step2() : void
      {
         var _loc2_:VOBattleItem = null;
         Facade.changeUserStage("raid_dwarf2_click");
         this.myMember = new VORaidMember();
         this.myMember.assign(Facade.userProxy.base,1);
         this.myMember.addSoldierItem("un_warrior",1,10);
         this.myMember.addSoldierItem("un_sniper",1,10);
         var _loc1_:PUserBase = new PUserBase();
         _loc1_.name = Lang.getString("un_dwarf");
         _loc1_.user_id = "dwarf";
         _loc1_.avatar = SkinManager.url + "images/un_dwarf1.png";
         _loc1_.level = 50;
         this.dwarfMember = new VORaidMember();
         this.dwarfMember.assign(_loc1_,2);
         this.dwarfMember.addSoldierItem("un_dwarf",4,30);
         _loc1_ = new PUserBase();
         _loc1_.name = Lang.getString("raid_bot_name");
         _loc1_.user_id = "raid_bot";
         _loc1_.avatar = SkinManager.url + "images/raid_plr_avatar.png";
         _loc1_.level = 20;
         this.botMember = new VORaidMember();
         this.botMember.assign(_loc1_,3);
         this.botMember.addSoldierItem("un_motocycle",1,10);
         this.btm.visitorPanel.setRaidMembers([this.myMember,this.dwarfMember,this.botMember]);
         this.btm.soldierDp.length = 0;
         for each(_loc2_ in this.myMember.soldierDp)
         {
            this.btm.soldierDp.push(_loc2_);
         }
         this.btm.syncDropDp();
         this.bm.smoothMoveBoard(13,22);
         this.btm.visitorPanel.createSayPanel();
         this.sayPanel = this.btm.visitorPanel.sayPanel;
         this.sayPanel.addListener(VEvent.VARIANCE,this.onMessage);
         this.sayPanel.addMessage(this.dwarfMember,"4",true);
         this.sayPanel.addMessage(this.dwarfMember,"raid_msg0",true);
         Facade.changeUserStage("fr_dwarf_raid_3_close");
         wait(1.5,this.stepDwarfDropWait);
         this.cooldownSignal.handler = this.onCooldown;
         this.cooldownSignal.delay = 12;
         this.cooldownSignal.run(12);
         this.dropCount = this.getDropCount();
         this.targetCount = 0;
         Facade.addListener(CommonEvent.DAMAGE,this.onDamage);
      }
      
      private function getDropCount() : uint
      {
         var _loc2_:VOBattleItem = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.btm.soldierDp)
         {
            _loc1_ += _loc2_.count;
         }
         return _loc1_;
      }
      
      private function onCooldown() : void
      {
         if(this.getDropCount() >= this.dropCount && this.dropCount > 0)
         {
            this.btm.dropPanel.removeListener(VEvent.SELECT,this.onSelect);
            CoreLogic.pause = true;
            assignStep(new NewStoryStep("un_dwarf1",Lang.getString("dwarf_raid_slow")),this.slowStep);
            this.bm.moveBoard(14,16);
         }
      }
      
      private function onDamage(param1:CommonEvent) : void
      {
         if(param1.data == "bl_crystal_storage" || param1.data == "bl_town_hall")
         {
            ++this.targetCount;
            if(this.targetCount == 4)
            {
               Facade.changeUserStage("raid_targets_dead");
               Facade.removeListener(CommonEvent.DAMAGE,this.onDamage);
               this.btm.visitorPanel.useSpeedup();
               this.btm.visitorPanel.fightBox.addChildAt(this.btm.visitorPanel.surrenderBt,0);
               assignStep(new ClickStep(this.btm.visitorPanel.speedupBt,180,{
                  "hCenter":0,
                  "top":30
               }),this.onSpeedupClick);
            }
         }
      }
      
      private function onSpeedupClick() : void
      {
         Facade.changeUserStage("raid_speedup_click");
      }
      
      private function slowStep() : void
      {
         this.btm.dropPanel.reset();
         Mission1Train.assignSelectDropStep(this,"un_warrior",this.onWarriorSelect);
      }
      
      private function onWarriorSelect() : void
      {
         BoardLogic.updateLanding(true);
         Facade.changeUserStage("raid_troop_choice");
         this.btm.dropPanel.selectPanel.drop_value = 20;
         assignStep(new CmdStep(new Position(10,27),new Position(20,14),null,new Position(11,20)).setArea(2),this.applyLanding);
      }
      
      private function applyLanding() : void
      {
         Facade.changeUserStage("raid_troop_vector");
         CoreLogic.pause = false;
         BoardLogic.updateLanding(true);
         this.setOtherHint();
      }
      
      private function setOtherHint() : void
      {
         var _loc1_:VGrid = null;
         this.btm.dropPanel.addListener(VEvent.SELECT,this.onSelect);
         if(this.btm.dropPanel.soldierGrid.length > 0)
         {
            _loc1_ = this.btm.dropPanel.soldierGrid;
            this.targetRenderer = _loc1_.renderList[0] as DropRenderer;
            assignStep(new SoftHintStep(this.targetRenderer,1.5));
         }
         else
         {
            this.btm.dropPanel.removeListener(VEvent.SELECT,this.onSelect);
         }
      }
      
      private function onSelect(param1:VEvent) : void
      {
         if(this.btm.dropPanel.selectPanel)
         {
            this.onOtherSelect();
         }
         else
         {
            this.checkOtherHint();
         }
      }
      
      private function onOtherSelect() : void
      {
         Facade.changeUserStage("raid_troop_choice");
         this.btm.dropPanel.selectPanel.drop_value = this.targetRenderer.item.count;
         assignStep(new SoftDropStep(new Position(10,27),new Position(20,14)),this.onLanding);
      }
      
      private function onLanding() : void
      {
         Facade.changeUserStage("raid_troop_vector");
         this.btm.dropPanel.reset();
      }
      
      private function checkOtherHint(param1:Number = 2) : void
      {
         var _loc2_:VGrid = null;
         this.targetRenderer = null;
         if(this.btm.dropPanel.soldierGrid.length > 0)
         {
            _loc2_ = this.btm.dropPanel.soldierGrid;
            this.targetRenderer = _loc2_.renderList[0] as DropRenderer;
            assignStep(new SoftHintStep(this.targetRenderer,param1));
         }
         else
         {
            this.btm.dropPanel.removeListener(VEvent.SELECT,this.onSelect);
         }
      }
      
      private function onMessage(param1:VEvent) : void
      {
         this.sayPanel.addMessage(this.myMember,param1.data,true);
      }
      
      private function stepDwarfDropWait() : void
      {
         Facade.changeUserStage("fr_dwarf_raid_4_close");
         wait(1,this.stepDwarfDrop);
      }
      
      private function stepDwarfDrop() : void
      {
         this.dwarfMember.maxCapacity = 0;
         this.btm.syncRaidMembers();
         this.dwarfList = new <int>[7,27,20,14,3,23,20,14];
         this.dwarfDrop();
      }
      
      private function dwarfDrop() : void
      {
         var _loc1_:Position = new Position(this.dwarfList[0],this.dwarfList[1]);
         var _loc2_:Position = new Position(this.dwarfList[2],this.dwarfList[3]);
         this.btm.sim.addUnitEvent((this.dwarfMember.soldierDp[0] as VOBattleItem).shop,null,this.dwarfList.length / 4 * 10,_loc1_,_loc2_,this.btm.curSimTime + 300,2);
         (this.btm.sim.getSimRun() as SimVisual).drawVector(_loc1_,_loc2_,true,2);
         this.dwarfList.splice(0,4);
         if(this.dwarfList.length > 0)
         {
            wait(1,this.dwarfDrop);
         }
         else
         {
            this.setOtherHint();
            wait(3,this.stepBotDrop);
         }
      }
      
      private function stepBotDrop() : void
      {
         this.botMember.maxCapacity = 0;
         this.btm.syncRaidMembers();
         var _loc1_:Position = new Position(11,31);
         var _loc2_:Position = new Position(18,15);
         this.btm.sim.addUnitEvent((this.botMember.soldierDp[0] as VOBattleItem).shop,null,10,_loc1_,_loc2_,this.btm.curSimTime + 300,3);
         (this.btm.sim.getSimRun() as SimVisual).drawVector(_loc1_,_loc2_,true,3);
      }
      
      public function stepResult() : void
      {
         this.btm.battlePanel.showWinPanel(this.showDialog,null);
      }
      
      private function showDialog() : void
      {
         Facade.changeUserStage("raid_win_dialog");
         var _loc1_:PCost = PCost.create(PCost.H_GLORY,30);
         this.myMember.heroList = [PCost.create(PCost.CRYSTAL,200),_loc1_];
         this.myMember.dropCapacity = 20;
         this.dwarfMember.heroList = [PCost.create(PCost.CRYSTAL,1000),_loc1_];
         this.dwarfMember.dropCapacity = 160;
         this.botMember.dropCapacity = 40;
         this.botMember.heroList = [PCost.create(PCost.CRYSTAL,300),_loc1_];
         var _loc2_:BattleResultDialog = new BattleResultDialog(true,null,0);
         _loc2_.initRaid(null,[],[this.myMember,this.dwarfMember,this.botMember],100,[]);
         Facade.mainMediator.showDialog(_loc2_);
         _loc2_.addListener(VEvent.CLOSE_DIALOG,this.onResultClose);
      }
      
      private function onResultClose(param1:VEvent) : void
      {
         Facade.changeUserStage("raid_win_dialog_click");
         MainLogic.getMyMap();
      }
      
      override public function dispose() : void
      {
         this.btm.dropPanel.removeListener(VEvent.SELECT,this.onSelect);
         Facade.removeListener(CommonEvent.DAMAGE,this.onDamage);
         this.btm.visitorPanel.setRaidMembers(null);
         this.cooldownSignal.stopWithoutHandler();
         if(this.sayPanel)
         {
            this.sayPanel.removeFromParent();
            this.sayPanel = null;
            Facade.battleMediator.visitorPanel.sayPanel = null;
         }
         super.dispose();
      }
   }
}

