package logic.training
{
   import engine.Position;
   import game.battle.BattleMediator;
   import game.battle.drop.DropPanel;
   import game.battle.drop.PowerBuyDialog;
   import game.battle.drop.PowerBuyRenderer;
   import logic.BoardLogic;
   import logic.CoreLogic;
   import logic.MainLogic;
   import model.CommonEvent;
   import model.ui.VOBattleItem;
   import proto.model.PCommand;
   import proto.model.PCommandKind;
   import proto.model.PShopPowerPoint;
   import ui.game.PricePanel;
   import ui.vbase.VGrid;
   
   public class Mission3Train extends AbstractTrain
   {
      
      private const bm:BattleMediator = Facade.battleMediator;
      
      private const dropPanel:DropPanel = this.bm.dropPanel;
      
      private var power:int;
      
      public function Mission3Train()
      {
         super();
      }
      
      private function set spellLock(param1:Boolean) : void
      {
         var _loc3_:VOBattleItem = null;
         if(param1)
         {
            this.dropPanel.reset();
         }
         var _loc2_:VGrid = this.dropPanel.spellGrid;
         for each(_loc3_ in _loc2_.getDataProvider())
         {
            _loc3_.isLock = param1;
         }
         _loc2_.sync();
      }
      
      private function set soldierLock(param1:Boolean) : void
      {
         var _loc2_:VOBattleItem = null;
         for each(_loc2_ in this.bm.soldierDp)
         {
            _loc2_.isLock = param1;
         }
         this.bm.syncDropDp();
      }
      
      override public function run() : void
      {
         this.bm.soldierDp.length = 0;
         var _loc1_:VOBattleItem = new VOBattleItem();
         _loc1_.shop = Facade.manualProxy.getSoldierShop("un_warrior",1);
         _loc1_.count = 30;
         this.bm.soldierDp.push(_loc1_);
         _loc1_ = new VOBattleItem();
         _loc1_.spellShop = Facade.manualProxy.getSpellShop("sp_fireball",1);
         this.power = _loc1_.spellShop.ssp_power_price;
         _loc1_.count = 1;
         this.dropPanel.setSpellDp([_loc1_]);
         this.bm.syncDropDp();
         this.bm.sim.data.power = 40;
         this.soldierLock = true;
         Facade.boardMediator.moveBoard(20,23);
         assignStep(new StoryStep("un_jaina1",Lang.getString("jaina_mission3_try_spell"),-156,156,true),this.onFireballSelect1);
      }
      
      private function onFireballSelect1() : void
      {
         Facade.changeUserStage("m3_spell_train");
         boardLock = true;
         Mission1Train.assignSelectDropStep(this,"sp_fireball",this.onFireballDrop1);
      }
      
      private function onFireballDrop1() : void
      {
         Facade.changeUserStage("m3_spell1_choose");
         boardLock = false;
         assignStep(new DropSpellStep(20,22),this.onFireballWait1);
      }
      
      private function onFireballWait1() : void
      {
         Facade.changeUserStage("m3_spell1_use");
         this.spellLock = true;
         wait(2.3,this.onWarriorSelect);
      }
      
      private function onWarriorSelect() : void
      {
         boardLock = true;
         var _loc1_:String = "un_warrior";
         Mission1Train.changeSoldierLock(_loc1_,false);
         Mission1Train.assignSelectDropStep(this,_loc1_,this.onWarriorDrop1);
      }
      
      private function onWarriorDrop1() : void
      {
         boardLock = false;
         assignStep(new CmdStep(new Position(18,27),new Position(20,22),"m3_warrior_vector1_click",new Position(20,22)),this.onWarriorDrop2);
      }
      
      private function onWarriorDrop2() : void
      {
         Facade.changeUserStage("m3_warrior_vector1_success");
         CoreLogic.simulateFactor = 1.5;
         CoreLogic.pause = true;
         assignStep(new CmdStep(new Position(27,21),new Position(26,16),"m3_warrior_vector2_click",new Position(24,21)),this.onPowerWait);
      }
      
      private function onPowerWait() : void
      {
         Facade.changeUserStage("m3_warrior_vector2_success");
         this.dropPanel.reset();
         BoardLogic.updateLanding(false);
         this.soldierLock = false;
         Facade.addListener(CommonEvent.DAMAGE,this.onDamage);
         CoreLogic.pause = false;
      }
      
      private function onDamage(param1:CommonEvent) : void
      {
         if(this.bm.sim.data.power >= this.power)
         {
            Facade.removeListener(CommonEvent.DAMAGE,this.onDamage);
            CoreLogic.pause = boardLock = this.soldierLock = true;
            this.spellLock = false;
            Mission1Train.assignSelectDropStep(this,"sp_fireball",this.onFireballDrop2);
         }
      }
      
      private function onFireballDrop2() : void
      {
         Facade.changeUserStage("m3_spell2_choose");
         boardLock = false;
         assignStep(new DropSpellStep(13,11),this.onFireballWait2);
      }
      
      private function onFireballWait2() : void
      {
         Facade.changeUserStage("m3_spell2_use");
         CoreLogic.simulateFactor = 1;
         CoreLogic.pause = false;
         this.dropPanel.mouseChildren = this.dropPanel.mouseEnabled = false;
         wait(1.9,this.onFireballDrop3);
      }
      
      private function onFireballDrop3() : void
      {
         CoreLogic.pause = true;
         assignStep(new DropSpellStep(18,8),this.onPowerStory);
      }
      
      private function onPowerStory() : void
      {
         Facade.changeUserStage("m3_spell3_use_fail");
         this.dropPanel.reset();
         assignStep(new StoryStep("un_jaina1",Lang.getString("jaina_mission3_more_rubies"),-156,156,true),this.onPowerBuy);
      }
      
      private function onPowerBuy() : void
      {
         Facade.changeUserStage("m3_need_rubies");
         this.bm.usePowerBuy();
         assignStep(new BlackoutClickStep(this.dropPanel.powerPanel.buyBt,0,{
            "hCenter":0,
            "top":4
         }),this.onPowerBuyOpen);
      }
      
      private function onPowerBuyOpen() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:PowerBuyRenderer = null;
         var _loc1_:PowerBuyDialog = Facade.mainMediator.searchDialog(PowerBuyDialog);
         if(_loc1_)
         {
            Facade.changeUserStage("m3_rubies_shop_open");
            _loc2_ = _loc1_.grid.length - 1;
            _loc3_ = 0;
            for each(_loc4_ in _loc1_.grid.renderList)
            {
               _loc4_.bt.disabled = _loc3_ != _loc2_;
               _loc3_++;
            }
            (_loc4_.bt.icon as PricePanel).setValue(0);
            this.power = (_loc4_.bt.data as PShopPowerPoint).power_count;
            assignStep(new BlackoutClickStep(_loc4_.bt,0,{
               "hCenter":0,
               "top":4
            },null,false),this.onPowerBuyConfirm);
         }
      }
      
      private function onPowerBuyConfirm() : void
      {
         Facade.changeUserStage("m3_rubies_received");
         this.dropPanel.powerPanel.removeBuyBt();
         Facade.mainMediator.searchDialog(PowerBuyDialog,true);
         this.bm.sim.changePower(this.power);
         this.dropPanel.mouseChildren = this.dropPanel.mouseEnabled = true;
         Mission1Train.assignSelectDropStep(this,"sp_fireball",this.onFireballDrop4);
         CoreLogic.pause = this.soldierLock = false;
      }
      
      private function onFireballDrop4() : void
      {
         Facade.changeUserStage("m3_spell3_choose");
         assignStep(new DropSpellStep(18,8),this.onFireballDrop5);
      }
      
      private function onFireballDrop5() : void
      {
         Facade.changeUserStage("m3_spell3_use");
         assignStep(new DropSpellStep(15,11),this.onEnd);
      }
      
      private function onEnd() : void
      {
         Facade.changeUserStage("m3_spell4_use");
      }
      
      public function stepResult(param1:Array) : void
      {
         var _loc3_:PCommand = null;
         var _loc2_:uint = 1;
         for each(_loc3_ in param1)
         {
            if(_loc3_.cm_kind.variance == PCommandKind.SPELL)
            {
               _loc2_++;
            }
         }
         if(_loc2_ <= 4)
         {
            _loc2_ = 29;
         }
         else if(_loc2_ > 8)
         {
            _loc2_ = 34;
         }
         else
         {
            _loc2_ += 25;
         }
         Facade.fact(_loc2_);
         if(!Facade.checkUserStage("tryCampaignMission3_final"))
         {
            Facade.changeUserStage("tryCampaignMission3_final");
            Facade.fact(this.bm.bp.isWin ? 19 : 20);
         }
         MainLogic.getMyMap();
      }
   }
}

