package logic.training.firstsession
{
   import engine.Position;
   import engine.signal.Signal;
   import engine.units.Soldier;
   import flash.filters.GlowFilter;
   import game.battle.BattleMediator;
   import game.battle.drop.DropRenderer;
   import game.battle.drop.PowerBuyDialog;
   import game.battle.drop.PowerBuyRenderer;
   import logic.CoreLogic;
   import logic.UnitFactory;
   import logic.sim.Sim;
   import logic.sim.SimBuildingT;
   import logic.training.*;
   import model.ui.VOBattleItem;
   import model.ui.VOCallback;
   import proto.model.PBtype;
   import proto.model.PShopPowerPoint;
   import proto.model.PShopUnit;
   import ui.game.PricePanel;
   
   public class BossTrain extends AbstractTrain
   {
      
      private const townHallSignal:Signal;
      
      private const signal:Signal = new Signal();
      
      private const glowFilter:GlowFilter = new GlowFilter(16711680,1,4,4);
      
      private const bm:BattleMediator = Facade.battleMediator;
      
      private var notHardSpell:Boolean;
      
      private var buyIn:Boolean;
      
      private var fbcount:uint = 1;
      
      private var bubbleArgs:Array;
      
      private var sim:Sim;
      
      private var boss:Soldier;
      
      public function BossTrain()
      {
         this.townHallSignal = new Signal(this.onTownHallSignal);
         super();
      }
      
      override public function run() : void
      {
         Facade.mainPanel.addInterLayer(Facade.myMediator.prefPanel,false,false);
         this.bm.isBoss = true;
         this.bm.dropPanel.usePower = false;
         this.bm.dropPanel.setSpellDp(null);
         this.bm.dropPanel.update();
         this.bm.dropPanel.mouseChildren = false;
         this.bm.rivalPanel.visible = false;
         this.bm.battlePanel.visible = false;
         this.bm.bp.winList.length = 0;
         this.bm.battlePanel.setWinTarget(null,null);
         Facade.boardMediator.moveBoard(34,23);
         Facade.myMediator.changeZoom(0.75);
         var _loc1_:PShopUnit = getShop("un_boss_warrior",1);
         this.boss = UnitFactory.createSoldier(_loc1_,10001);
         this.boss.display.addFilter(this.glowFilter);
         this.boss.setGeometry(43,22,true);
         Facade.boardMediator.addObject(this.boss,false);
         boardLock = true;
         this.bossWalk();
      }
      
      private function onTownHallSignal() : void
      {
         this.sim.data.buildings.iter(this.iterFunc);
      }
      
      private function iterFunc(param1:uint, param2:SimBuildingT) : void
      {
         if(param2.type == PBtype.TOWNHALL)
         {
            if(param2.stamina < param2.max_stamina * 0.3)
            {
               this.townHallSignal.stopWithoutHandler();
               this.initDestroyWarriors();
            }
         }
      }
      
      private function bossWalk() : void
      {
         this.boss.useWalkPath();
         this.boss.startWalkPath(36,22,this.onBossStart);
      }
      
      private function onBossStart() : void
      {
         Facade.changeUserStage("boss_emperor1");
         this.boss.stand();
         Facade.boardMediator.moveBoard(24,20);
         assignStep(new NewStoryStep("un_emperor",Lang.getString("emperor_appear_1"),false).useMultipleSay(),this.onEmperor1);
      }
      
      private function onEmperor1() : void
      {
         Facade.changeUserStage("boss_emperor1_click");
         assignStep(new NewStoryStep("un_emperor",Lang.getString("emperor_appear_2"),false).useMultipleSay(),this.onEmperor2);
      }
      
      private function onEmperor2() : void
      {
         Facade.changeUserStage("boss_emperor2_click");
         assignStep(new NewStoryStep("un_boss_warrior",Lang.getString("boss1_appear1"),false),this.onBossPlayAttack);
      }
      
      private function onBossPlayAttack() : void
      {
         Facade.changeUserStage("boss_zlovius");
         UnitFactory.useBubble(this.boss,Lang.getString("boss_attack_bubble_1"),{
            "w":120,
            "h":68,
            "left":26,
            "vCenter":22
         });
         this.boss.playAttack();
         var _loc1_:PShopUnit = getShop("un_warrior");
         _loc1_.su_stamina = 18;
         this.sim = this.bm.sim;
         this.sim.addUnitEvent(_loc1_,null,1,new Position(32,23),new Position(21,17),this.bm.curSimTime + 30);
         wait(1.5,this.clearBossBubble);
         this.bubbleArgs = [1.5,this.onBossAttack];
      }
      
      private function clearBossBubble() : void
      {
         this.boss.setStatus(null);
         if(this.bubbleArgs)
         {
            wait(this.bubbleArgs[0],this.bubbleArgs[1]);
            this.bubbleArgs = null;
         }
      }
      
      private function onBossAttack() : void
      {
         UnitFactory.useBubble(this.boss,Lang.getString("boss_attack_bubble_2"),{
            "w":120,
            "h":68,
            "left":26,
            "vCenter":22
         });
         wait(1.5,this.clearBossBubble);
         this.bubbleArgs = [6.5,this.onBossAttack2];
         this.boss.playAttack();
         var _loc1_:PShopUnit = getShop("un_warrior");
         _loc1_.su_stamina = 18;
         this.sim.addUnitEvent(_loc1_,null,5,new Position(32,23),new Position(21,17),this.bm.curSimTime + 30);
      }
      
      private function onBossAttack2() : void
      {
         UnitFactory.useBubble(this.boss,Lang.getString("boss_attack_bubble_3"),{
            "w":120,
            "h":68,
            "left":26,
            "vCenter":22
         });
         wait(1.5,this.clearBossBubble);
         this.bubbleArgs = [1.5,this.moreWarriors];
         this.boss.playAttack();
         var _loc1_:PShopUnit = getShop("un_warrior");
         _loc1_.su_stamina = 15;
         this.sim.addUnitEvent(_loc1_,null,10,new Position(32,23),new Position(21,17),this.bm.curSimTime + 30);
         this.sim.addUnitEvent(_loc1_,null,10,new Position(35,15),new Position(21,17),this.bm.curSimTime + 300);
      }
      
      private function moreWarriors() : void
      {
         var _loc4_:DropRenderer = null;
         var _loc5_:DropRenderer = null;
         this.boss.playAttack();
         var _loc1_:PShopUnit = getShop("un_warrior");
         _loc1_.su_stamina = 15;
         this.sim.addUnitEvent(_loc1_,null,10,new Position(32,23),new Position(21,17),this.bm.curSimTime + 30);
         _loc1_ = getShop("un_warrior",4);
         _loc1_.su_eff = 0;
         this.sim.addUnitEvent(_loc1_,null,10,new Position(35,15),new Position(21,17),this.bm.curSimTime + 300);
         var _loc2_:VOBattleItem = new VOBattleItem();
         var _loc3_:String = "sp_fireball";
         _loc2_.spellShop = Facade.manualProxy.getSpellShop(_loc3_,1);
         _loc2_.count = 1;
         boardLock = false;
         this.bm.dropPanel.mouseChildren = this.bm.battlePanel.visible = this.bm.dropPanel.usePower = this.bm.simVisual.usePower = true;
         this.bm.battlePanel.useDropPanel(true);
         this.bm.sim.data.power = 28;
         this.bm.sim.changePower(0);
         this.bm.dropPanel.setSpellDp([_loc2_]);
         this.bm.soldierDp.length = 0;
         this.bm.dropPanel.update(this.bm.soldierDp);
         for each(_loc4_ in this.bm.dropPanel.spellGrid.renderList)
         {
            if(_loc4_.item.spellShop.ssp_kind == "sp_fireball")
            {
               _loc5_ = _loc4_;
               break;
            }
         }
         assignStep(new SoftHintStep(_loc5_),this.paintSignal);
         this.townHallSignal.delay = 0.5;
         this.townHallSignal.run(Number.MAX_VALUE);
      }
      
      private function paintSignal() : void
      {
         this.notHardSpell = true;
         Facade.changeUserStage("boss_fireball_choice1");
         this.signal.handler = this.paintWarriors;
         this.signal.delay = 0.5;
         this.signal.run(2.5);
         assignStep(new SoftDropStep(),this.onNextSpellCheckDrop);
      }
      
      private function onNextSpellCheckDrop() : void
      {
         Facade.changeUserStage("boss_fireball_use1");
         assignStep(new SoftDropStep(),this.onLowPowerDrop);
      }
      
      private function onLowPowerDrop() : void
      {
         this.buyIn = true;
         CoreLogic.pause = true;
         wait(1,this.showBuyPowerStep);
      }
      
      private function showBuyPowerStep() : void
      {
         Facade.changeUserStage("boss_jaina1");
         assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_mission1_buy_spell")),this.onBuyPower);
      }
      
      private function onBuyPower() : void
      {
         Facade.changeUserStage("boss_jaina1_click");
         this.bm.usePowerBuy();
         assignStep(new BlackoutClickStep(this.bm.dropPanel.powerPanel.buyBt,0,{
            "hCenter":0,
            "top":4
         }),this.onPowerBuyOpen);
      }
      
      private function onPowerBuyOpen() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:PowerBuyRenderer = null;
         Facade.changeUserStage("boss_ruby_shop_click");
         var _loc1_:PowerBuyDialog = Facade.mainMediator.searchDialog(PowerBuyDialog);
         if(_loc1_)
         {
            _loc2_ = 0;
            for each(_loc3_ in _loc1_.grid.renderList)
            {
               _loc3_.bt.disabled = _loc2_ != 1;
               _loc2_++;
            }
            _loc3_ = _loc1_.grid.renderList[1] as PowerBuyRenderer;
            (_loc3_.bt.icon as PricePanel).setValue(0);
            assignStep(new BlackoutClickStep(_loc3_.bt,0,{
               "hCenter":0,
               "top":4
            },new VOCallback(this.onPowerBuyConfirm,[(_loc3_.bt.data as PShopPowerPoint).power_count]),false));
         }
      }
      
      private function onPowerBuyConfirm(param1:uint) : void
      {
         Facade.changeUserStage("boss_ruby_shop_free");
         this.bm.dropPanel.powerPanel.removeBuyBt();
         Facade.mainMediator.searchDialog(PowerBuyDialog,true);
         this.bm.sim.changePower(param1);
         this.bm.dropPanel.mouseLock = false;
         if(!this.buyIn)
         {
            this.buyIn = true;
            this.initDestroyWarriors();
         }
         else
         {
            CoreLogic.pause = false;
         }
      }
      
      private function paintWarriors() : void
      {
         var _loc1_:Soldier = null;
         for each(_loc1_ in Facade.userProxy.soldierHash)
         {
            if(_loc1_.id == 10001)
            {
               this.boss.display.removeFilter(this.glowFilter);
            }
            else
            {
               _loc1_.display.addFilter(this.glowFilter,true);
            }
         }
      }
      
      private function initDestroyWarriors() : void
      {
         this.notHardSpell = this.notHardSpell;
         Facade.fact(this.notHardSpell ? 25 : 26);
         CoreLogic.pause = true;
         Facade.changeUserStage("boss_fireball_choice" + this.fbcount);
         Mission1Train.assignSelectDropStep(this,"sp_fireball",this.destroyWarriors);
      }
      
      private function destroyWarriors() : void
      {
         var _loc1_:Soldier = null;
         CoreLogic.pause = true;
         this.paintWarriors();
         for each(_loc1_ in Facade.userProxy.soldierHash)
         {
            if(_loc1_.id != 10001)
            {
               if(this.buyIn || this.bm.sim.data.power > 25)
               {
                  if(this.bm.sim.data.power < 25)
                  {
                     this.bm.sim.changePower(25);
                  }
                  assignStep(new DropSpellStep(_loc1_.c_x,_loc1_.c_y,0,0,1),this.confirmDestroyWarriors);
               }
               else
               {
                  assignStep(new DropSpellStep(_loc1_.c_x,_loc1_.c_y,0,0,1),this.confirmLowPower);
               }
               return;
            }
         }
      }
      
      private function confirmLowPower() : void
      {
         CoreLogic.pause = true;
         wait(1,this.showBuyPowerStep);
      }
      
      private function confirmDestroyWarriors() : void
      {
         Facade.changeUserStage("boss_fireball_use" + this.fbcount);
         ++this.fbcount;
         CoreLogic.pause = false;
         wait(1,this.destroyWarriors);
      }
      
      override public function dispose() : void
      {
         Facade.mainPanel.layerPanel.add(Facade.myMediator.prefPanel);
         this.signal.stopWithoutHandler();
         this.townHallSignal.stopWithoutHandler();
         super.dispose();
      }
   }
}

