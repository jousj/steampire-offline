package logic.training.firstsession
{
   import engine.Position;
   import engine.signal.Signal;
   import engine.units.Build;
   import flash.display.StageDisplayState;
   import game.battle.BattleMediator;
   import game.battle.drop.DropRenderer;
   import logic.BoardLogic;
   import logic.CoreLogic;
   import logic.MainLogic;
   import logic.sim.SimCannonT;
   import logic.sim.SimUnitT;
   import logic.training.*;
   import model.ui.VOBattleItem;
   import model.ui.VOWinItem;
   import proto.model.PBtype;
   import proto.model.PMissionWin;
   import ui.MainPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   
   public class Mission2NewTrain extends AbstractTrain
   {
      
      private const blackout:BlackoutPanel;
      
      private const checkResourceSignal:Signal;
      
      private const bm:BattleMediator;
      
      private var oilMembered:Number;
      
      private var oilChecked:Boolean;
      
      private var crystalChecked:Boolean;
      
      private var crystalMembered:Number;
      
      public function Mission2NewTrain()
      {
         var _loc2_:Build = null;
         this.blackout = new BlackoutPanel();
         this.checkResourceSignal = new Signal();
         this.bm = Facade.battleMediator;
         super();
         Facade.myMediator.changeZoom(0.75);
         Facade.boardMediator.moveBoard(20,17);
         Facade.myMediator.prefPanel.lock = false;
         this.bm.rivalPanel.visible = true;
         this.bm.rivalPanel.myResourceVisible = true;
         this.bm.dropPanel.setSpellDp(null);
         var _loc1_:Vector.<Build> = new Vector.<Build>();
         Facade.userProxy.getBuild(PBtype.STORAGE,true,0,_loc1_);
         for each(_loc2_ in _loc1_)
         {
            this.bm.bp.winList.push(new VOWinItem(PMissionWin.create(_loc2_.kind,_loc2_.level,1),1));
            _loc2_.setStatus(SkinManager.getEmbed("TargetStatus",VSkin.CACHE_AS_BITMAP));
         }
         _loc2_ = Facade.userProxy.getBuild(PBtype.TOWNHALL,true);
         if(_loc2_)
         {
            this.bm.bp.winList.push(new VOWinItem(PMissionWin.create(_loc2_.kind,_loc2_.level,1),1));
            _loc2_.setStatus(SkinManager.getEmbed("TargetStatus",VSkin.CACHE_AS_BITMAP));
         }
         this.bm.battlePanel.setWinTarget(this.bm.bp.winList,this.bm.onToWinTarget);
         this.bm.soldierDp.length = 0;
         var _loc3_:VOBattleItem = new VOBattleItem();
         _loc3_.shop = getShop("un_warrior",1);
         _loc3_.count = 10;
         this.bm.soldierDp.push(_loc3_);
         this.bm.syncDropDp();
         assignStep(new NewStoryStep("un_warrior1",Lang.getString("warrior_mission2")),this.onAttack1);
      }
      
      override public function run() : void
      {
         this.checkResourceSignal.handler = this.onResourceSignal;
         this.checkResourceSignal.delay = 0.5;
         this.checkResourceSignal.run(Number.MAX_VALUE);
         this.oilMembered = this.bm.bp.oil;
         this.crystalMembered = this.bm.bp.crystal;
      }
      
      private function onResourceSignal() : void
      {
         var _loc1_:MainPanel = Facade.mainPanel;
         if(!this.oilChecked && this.oilMembered != this.bm.bp.oil)
         {
            _loc1_.addStretch(this.blackout,_loc1_.getChildIndex(_loc1_.dialogPanel));
            this.blackout.track(this.bm.rivalPanel.crystalMyPanel);
            this.oilChecked = true;
         }
         else if(!this.crystalChecked && this.crystalMembered != this.bm.bp.crystal)
         {
            _loc1_.addStretch(this.blackout,_loc1_.getChildIndex(_loc1_.dialogPanel));
            this.blackout.track(this.bm.rivalPanel.crystalMyPanel);
            this.crystalChecked = true;
         }
         if(this.oilChecked || this.crystalChecked)
         {
            wait(4,this.stopBlackout);
            this.checkResourceSignal.stopWithoutHandler();
         }
      }
      
      private function stopBlackout() : void
      {
         Facade.changeUserStage("m2_stealing_resource");
         this.blackout.removeFromParent();
      }
      
      private function onAttack1() : void
      {
         Facade.changeUserStage("m2_warrior1_click");
         if(Facade.stage.displayState == StageDisplayState.NORMAL)
         {
            assignStep(new BlackoutClickStep(Facade.myMediator.prefPanel.fullScreenBt,270,{
               "left":4,
               "vCenter":0
            }),this.onFullscreen);
         }
         else
         {
            this.onFullscreen();
         }
      }
      
      private function onFullscreen() : void
      {
         Facade.changeUserStage("m2_fullscreen_click");
         Mission1Train.assignSelectDropStep(this,"un_warrior",this.onWarriorSelect);
      }
      
      private function onWarriorSelect() : void
      {
         Facade.changeUserStage("m2_warrior_choice");
         assignStep(new CmdStep(new Position(28,21),new Position(17,13),"m_somesage"),this.onWarriorLand);
      }
      
      private function onWarriorLand() : void
      {
         var _loc1_:SimCannonT = null;
         var _loc2_:SimUnitT = null;
         Facade.changeUserStage("m2_vector1_success");
         for each(_loc1_ in this.bm.sim.data.cannons)
         {
            _loc1_.attack_time = 300;
         }
         for each(_loc2_ in this.bm.sim.data.units)
         {
            if(_loc2_.kind == "un_warrior")
            {
               _loc2_.damage *= 2.5;
               _loc2_.stamina = 40;
            }
         }
         wait(5,this.onWarriorDamage);
         this.bm.dropPanel.mouseLock = boardLock = true;
      }
      
      private function onWarriorDamage() : void
      {
         CoreLogic.pause = true;
         assignStep(new NewStoryStep("un_warrior1",Lang.getString("warrior_mission2_fail")),this.onWarriorSay);
      }
      
      private function onWarriorSay() : void
      {
         Facade.changeUserStage("m2_warrior2_click");
         assignStep(new NewStoryStep("un_sniper1",Lang.getString("sniper_mission2")),this.onSniperSay);
      }
      
      private function onSniperSay() : void
      {
         Facade.changeUserStage("m2_sniper_click");
         var _loc1_:VOBattleItem = new VOBattleItem();
         _loc1_.shop = getShop("un_sniper",1);
         _loc1_.count = 10;
         this.bm.soldierDp.push(_loc1_);
         this.bm.syncDropDp();
         Mission1Train.assignSelectDropStep(this,"un_sniper",this.onFirstSniperSelect);
      }
      
      private function onFirstSniperSelect() : void
      {
         Facade.changeUserStage("m2_sniper_choice");
         this.bm.dropPanel.mouseLock = boardLock = false;
         this.bm.dropPanel.selectPanel.boxVisible(true);
         this.bm.dropPanel.mouseLock = false;
         assignStep(new BlackoutClickStep(this.bm.dropPanel.selectPanel.getButton(5),0,{
            "hCenter":0,
            "top":4
         }),this.onFirstSniperSelect5);
      }
      
      private function onFirstSniperSelect5() : void
      {
         Facade.changeUserStage("m2_sniper_5");
         assignStep(new CmdStep(new Position(26,28),new Position(22,22),"m_somesage",new Position(21,21),true,false),this.onFirstSniperLand);
      }
      
      private function onFirstSniperLand() : void
      {
         Facade.changeUserStage("m2_vecror2_success");
         CoreLogic.pause = false;
         this.bm.dropPanel.mouseLock = boardLock = true;
         wait(1.5,this.onSniperAttack);
      }
      
      private function onSniperAttack() : void
      {
         CoreLogic.pause = true;
         this.bm.dropPanel.mouseLock = boardLock = false;
         assignStep(new CmdStep(new Position(27,6),new Position(22,12),"m_somesage",new Position(22,14),true,false),this.onSecondSniperLand);
      }
      
      private function onSecondSniperLand() : void
      {
         var _loc1_:SimUnitT = null;
         var _loc2_:VOBattleItem = null;
         var _loc3_:DropRenderer = null;
         var _loc4_:DropRenderer = null;
         Facade.changeUserStage("m2_vecror3_success");
         Facade.boardMediator.smoothMoveBoard(19,18);
         for each(_loc1_ in this.bm.sim.data.units)
         {
            if(_loc1_.kind == "un_sniper")
            {
               _loc1_.damage *= 4;
            }
         }
         CoreLogic.pause = false;
         BoardLogic.updateLanding(true);
         _loc2_ = new VOBattleItem();
         _loc2_.spellShop = Facade.manualProxy.getSpellShop("sp_fireball",1);
         _loc2_.count = 1;
         this.bm.dropPanel.setSpellDp([_loc2_]);
         this.bm.dropPanel.update();
         this.bm.dropPanel.usePower = true;
         this.bm.sim.data.power = 40;
         this.bm.sim.changePower(0);
         _loc2_ = new VOBattleItem();
         _loc2_.shop = Facade.manualProxy.getSoldierShop("un_warrior",1);
         _loc2_.count = 10;
         this.bm.soldierDp.push(_loc2_);
         _loc2_ = new VOBattleItem();
         _loc2_.shop = Facade.manualProxy.getSoldierShop("un_sniper",1);
         _loc2_.count = 5;
         this.bm.soldierDp.push(_loc2_);
         _loc2_ = new VOBattleItem();
         _loc2_.shop = Facade.manualProxy.getSoldierShop("un_hero",1);
         _loc2_.count = 1;
         this.bm.soldierDp.push(_loc2_);
         this.bm.syncDropDp();
         for each(_loc3_ in this.bm.dropPanel.soldierGrid.renderList)
         {
            if(_loc3_.item.shop.su_kind == "un_warrior")
            {
               _loc4_ = _loc3_;
               break;
            }
         }
         if(_loc4_)
         {
            assignStep(new SoftHintStep(_loc4_),this.onSoftWarriorSelect);
         }
         else
         {
            this.onSoftWarriorDrop();
         }
      }
      
      private function onSoftWarriorSelect() : void
      {
         assignStep(new SoftDropStep(new Position(28,20),new Position(20,15)),this.onSoftWarriorDrop);
      }
      
      private function onSoftWarriorDrop() : void
      {
         var _loc1_:DropRenderer = null;
         var _loc2_:DropRenderer = null;
         this.bm.dropPanel.reset();
         for each(_loc1_ in this.bm.dropPanel.soldierGrid.renderList)
         {
            if(_loc1_.item.shop.su_kind == "un_sniper")
            {
               _loc2_ = _loc1_;
               break;
            }
         }
         if(_loc2_)
         {
            assignStep(new SoftHintStep(_loc2_),this.onSoftSniperSelect);
         }
         else
         {
            this.onSoftSniperDrop();
         }
      }
      
      private function onSoftSniperSelect() : void
      {
         assignStep(new SoftDropStep(new Position(28,20),new Position(20,15)),this.onSoftSniperDrop);
      }
      
      private function onSoftSniperDrop() : void
      {
         var _loc1_:DropRenderer = null;
         var _loc2_:DropRenderer = null;
         for each(_loc1_ in this.bm.dropPanel.spellGrid.renderList)
         {
            if(_loc1_.item.spellShop.ssp_kind == "sp_fireball")
            {
               _loc2_ = _loc1_;
               break;
            }
         }
         assignStep(new SoftHintStep(_loc2_));
         this.bm.dropPanel.reset();
      }
      
      public function stepResult() : void
      {
         Facade.changeUserStage("m2_win_dialog");
         Facade.fact(this.bm.dropPanel.soldierGrid.length == 0 ? 27 : 28);
         this.bm.battlePanel.showWinPanel(MainLogic.checkTrainMission,null);
      }
      
      override public function dispose() : void
      {
         this.blackout.removeFromParent();
         this.checkResourceSignal.stopWithoutHandler();
      }
   }
}

