package logic.training
{
   import engine.Position;
   import engine.units.AnimObject;
   import engine.units.Build;
   import engine.units.Soldier;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.battle.BattleMediator;
   import game.battle.drop.DropPanel;
   import game.battle.drop.DropRenderer;
   import logic.CoreLogic;
   import logic.UnitFactory;
   import logic.sim.SimBoard;
   import logic.sim.SimBuildingT;
   import logic.sim.SimData;
   import logic.sim.SimUnitT;
   import model.ui.VOBattleItem;
   import model.ui.VOCallback;
   import proto.model.PBtype;
   import ui.vbase.VButton;
   
   public class Mission1Train extends AbstractTrain
   {
      
      private var soldierDp:Array;
      
      private var fact:uint;
      
      private var mapPoint:Point;
      
      private const motoId:uint = 10000;
      
      public function Mission1Train()
      {
         super();
      }
      
      public static function assignSelectDropStep(param1:AbstractTrain, param2:String, param3:Function) : void
      {
         var _loc6_:DropRenderer = null;
         var _loc7_:DropRenderer = null;
         var _loc8_:BlackoutClickStep = null;
         var _loc4_:DropPanel = Facade.battleMediator.dropPanel;
         var _loc5_:Boolean = param2.indexOf("sp_") == 0;
         for each(_loc7_ in _loc5_ ? _loc4_.spellGrid.renderList : _loc4_.soldierGrid.renderList)
         {
            if(!_loc5_ && _loc7_.item.shop.su_kind == param2 || _loc5_ && _loc7_.item.spellShop.ssp_kind == param2)
            {
               _loc6_ = _loc7_;
               break;
            }
         }
         if(_loc6_)
         {
            _loc8_ = new BlackoutClickStep(_loc6_,0,{
               "hCenter":0,
               "top":10
            },new VOCallback(_loc4_.select,[_loc6_]),false);
            Facade.mainPanel.layerPanel.addStretch(_loc8_.panel,1);
            param1.assignStep(_loc8_,param3);
         }
      }
      
      public static function clearSoldierDp() : Array
      {
         var _loc1_:BattleMediator = Facade.battleMediator;
         var _loc2_:Array = _loc1_.soldierDp.slice();
         _loc1_.soldierDp.length = 0;
         _loc1_.syncDropDp();
         return _loc2_;
      }
      
      public static function showSoldierDp(param1:Array, param2:String) : void
      {
         var _loc4_:VOBattleItem = null;
         var _loc3_:Array = Facade.battleMediator.soldierDp;
         for each(_loc4_ in param1)
         {
            if(_loc4_.shop.su_kind == param2)
            {
               _loc3_.push(_loc4_);
               break;
            }
         }
         Facade.battleMediator.syncDropDp();
      }
      
      public static function changeSoldierLock(param1:String, param2:Boolean) : void
      {
         var _loc3_:VOBattleItem = null;
         for each(_loc3_ in Facade.battleMediator.soldierDp)
         {
            if(_loc3_.shop.su_kind == param1)
            {
               if(param2 != _loc3_.isLock)
               {
                  _loc3_.isLock = param2;
                  Facade.battleMediator.syncDropDp();
               }
               break;
            }
         }
      }
      
      private function setGuardEnabled(param1:Boolean) : void
      {
         var _loc3_:SimData = null;
         var _loc4_:SimBuildingT = null;
         var _loc5_:Point = null;
         var _loc2_:Build = Facade.userProxy.getBuild(PBtype.GUARD,true);
         if(_loc2_)
         {
            _loc3_ = Facade.battleMediator.sim.data;
            _loc4_ = _loc3_.buildings[_loc2_.id] as SimBuildingT;
            if(_loc4_)
            {
               _loc5_ = SimBoard.findCenter(_loc4_.pos,_loc4_.size);
               if(param1)
               {
                  _loc3_.board.registerGuard(_loc4_.id,_loc5_,_loc4_.size,_loc4_.guard_radius);
               }
               else
               {
                  _loc3_.board.unregisterGuard(_loc4_.id,_loc5_,_loc4_.size,_loc4_.guard_radius);
               }
            }
         }
      }
      
      override public function run() : void
      {
         this.soldierDp = clearSoldierDp();
         this.uiVisible = false;
         Facade.mainPanel.addInterLayer(Facade.myMediator.prefPanel,false,false);
         Facade.changeUserStage("m1_clip_start");
         if(!Facade.checkUserStage("m1_train1_1_open"))
         {
            Facade.stage.addEventListener(MouseEvent.CLICK,this.onClick1);
         }
         this.motoScoutStep1();
      }
      
      private function onClick1(param1:MouseEvent) : void
      {
         Facade.fact(0);
         this.fact |= 1;
      }
      
      override public function dispose() : void
      {
         this.uiVisible = true;
         if(Facade.checkUserStage("m1_motocycle_vector_success"))
         {
            Facade.fact(Facade.audioProxy.getVolume(true) > 0 ? 13 : 14);
            Facade.fact(Facade.audioProxy.getVolume(false) > 0 ? 15 : 16);
         }
         super.dispose();
      }
      
      private function set uiVisible(param1:Boolean) : void
      {
         Facade.battleMediator.rivalPanel.visible = param1;
         Facade.myMediator.prefPanel.lock = !param1;
      }
      
      private function motoScoutStep1() : void
      {
         Facade.fpsControl.applyFrameRate(60);
         Facade.myMediator.changeZoom(1);
         boardLock = true;
         cinemaStrips = true;
         Facade.boardMediator.moveBoard(37,43);
         var _loc1_:Soldier = UnitFactory.createSoldier(Facade.manualProxy.getSoldierShop("un_motocycle",1),this.motoId);
         _loc1_.setGeometry(37,43,true);
         Facade.boardMediator.addObject(_loc1_,false);
         _loc1_.direction = AnimObject.RIGHT_UP;
         _loc1_.stand();
         _loc1_.useWalkPath();
         wait(2,this.motoScoutStep2);
      }
      
      private function motoScoutStep2() : void
      {
         CoreLogic.simulateFactor = 1.5;
         (Facade.userProxy.soldierHash[this.motoId] as Soldier).startWalkPath(37,35,this.motoScoutStep3);
         Facade.boardMediator.smoothMoveBoard(32,37,1.1,0.01);
      }
      
      private function motoScoutStep3() : void
      {
         assignStep(new ZoomStep(0.75),this.motoScoutStep4);
      }
      
      private function motoScoutStep4() : void
      {
         Facade.fpsControl.applyFrameRate(30);
         cinemaStrips = false;
         assignStep(new StoryStep("un_motocycle1",Lang.getString("train1_1"),-160,150),this.attackWarriorStep1);
         if(!Facade.checkUserStage("m1_train1_1_open"))
         {
            Facade.stage.removeEventListener(MouseEvent.CLICK,this.onClick1);
            if((this.fact & 1) == 0)
            {
               Facade.fact(1);
            }
            Facade.stage.addEventListener(MouseEvent.CLICK,this.onClick2);
         }
         Facade.changeUserStage("m1_train1_1_open");
      }
      
      private function onClick2(param1:MouseEvent) : void
      {
         var _loc2_:uint = 6;
         if(param1.target == Facade.myMediator.prefPanel.fullScreenBt)
         {
            _loc2_ = 5;
         }
         else if(param1.target == Facade.myMediator.prefPanel.settingBt)
         {
            _loc2_ = 3;
         }
         else if(param1.target is VButton)
         {
            _loc2_ = 2;
         }
         Facade.fact(_loc2_);
         Facade.stage.removeEventListener(MouseEvent.CLICK,this.onClick2);
      }
      
      public function attackWarriorStep1() : void
      {
         Facade.audioProxy.themeCC.fade(2);
         Facade.changeUserStage("m1_train1_1_close");
         var _loc1_:Soldier = Facade.userProxy.soldierHash[this.motoId] as Soldier;
         if(_loc1_)
         {
            _loc1_.startWalkPath(43,35,this.removeMotoScout,true);
         }
         Facade.boardMediator.moveBoard(37,35);
         Facade.myMediator.changeZoom(0.75);
         var _loc2_:String = "un_warrior";
         showSoldierDp(this.soldierDp,_loc2_);
         assignSelectDropStep(this,_loc2_,this.attackWarriorStep2);
      }
      
      private function attackWarriorStep2() : void
      {
         Facade.changeUserStage("m1_warrior_choice");
         CoreLogic.simulateFactor = 1;
         boardLock = false;
         var _loc1_:CmdStep = new CmdStep(new Position(38,36),new Position(32,30),"m1_warrior_vector_click",new Position(37,35));
         _loc1_.isForceEnd = true;
         if(!Facade.checkUserStage("m1_warrior_vector_success"))
         {
            _loc1_.fact = 7;
         }
         assignStep(_loc1_,this.attackWarrior2_1);
      }
      
      private function changeDamageSoldiers(param1:Boolean) : void
      {
         var _loc2_:SimUnitT = null;
         for each(_loc2_ in Facade.battleMediator.sim.data.units)
         {
            if(_loc2_.is_attacker)
            {
               if(param1)
               {
                  _loc2_.damage *= 6;
                  _loc2_.attack_delay = 200;
               }
               else
               {
                  _loc2_.damage /= 6;
                  _loc2_.attack_delay = 400;
               }
            }
         }
      }
      
      private function attackWarrior2_1() : void
      {
         this.changeDamageSoldiers(true);
         wait(1,this.attackWarrior2_2);
      }
      
      private function attackWarrior2_2() : void
      {
         Facade.boardMediator.smoothMoveBoard(29,37);
         CoreLogic.pause = boardLock = true;
         assignStep(new StoryStep("un_motocycle1",Lang.getString("train1_vector"),-160,150),this.attackWarriorStep3);
      }
      
      private function attackWarriorStep3() : void
      {
         CoreLogic.pause = boardLock = false;
         Facade.boardMediator.smoothMoveBoard(32,30);
         if(!Facade.checkUserStage("m1_warrior_vector_success"))
         {
            this.fact |= 2;
            Facade.board.addEventListener(MouseEvent.MOUSE_DOWN,this.onBoardDown);
            Facade.board.addEventListener(MouseEvent.MOUSE_UP,this.onBoardUp);
            Facade.changeUserStage("m1_warrior_vector_success");
         }
         this.setGuardEnabled(false);
         assignStep(new DamageStep("bl_oil_tower"),this.attackWarriorStep4);
      }
      
      private function onBoardDown(param1:MouseEvent) : void
      {
         if(!this.mapPoint)
         {
            this.mapPoint = new Point();
         }
         this.mapPoint.x = Facade.board.x;
         this.mapPoint.y = Facade.board.y;
      }
      
      private function onBoardUp(param1:MouseEvent) : void
      {
         if(param1)
         {
            if(Boolean(this.mapPoint) && (this.mapPoint.x != Facade.board.x || this.mapPoint.y != Facade.board.y))
            {
               this.fact |= 4;
               this.onBoardUp(null);
               Facade.fact(11);
            }
         }
         else
         {
            Facade.board.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBoardDown);
            Facade.board.removeEventListener(MouseEvent.MOUSE_UP,this.onBoardUp);
         }
      }
      
      private function removeMotoScout(param1:Soldier) : void
      {
         UnitFactory.removeSoldier(param1);
      }
      
      private function attackWarriorStep4() : void
      {
         this.setGuardEnabled(true);
         this.changeDamageSoldiers(false);
         wait(1.3,this.heroStep1,true);
      }
      
      private function heroStep1() : void
      {
         CoreLogic.pause = boardLock = true;
         if((this.fact & 2) != 0)
         {
            if((this.fact & 4) == 0)
            {
               this.onBoardUp(null);
               Facade.fact(12);
            }
            this.mapPoint = null;
         }
         Facade.boardMediator.smoothMoveBoard(27,33);
         assignStep(new StoryStep("un_warrior1",Lang.getString("train1_2"),-180,144),this.heroStep2);
         Facade.changeUserStage("m1_train1_2_open");
      }
      
      private function heroStep2() : void
      {
         Facade.changeUserStage("m1_train1_2_close");
         var _loc1_:String = "un_hero";
         showSoldierDp(this.soldierDp,_loc1_);
         assignSelectDropStep(this,_loc1_,this.heroStep3);
      }
      
      private function heroStep3() : void
      {
         Facade.changeUserStage("m1_hero_choice");
         boardLock = false;
         assignStep(new CmdStep(new Position(38,36),new Position(29,26),"m1_hero_vector_click",new Position(34,32)),this.heroStep4);
      }
      
      private function heroStep4() : void
      {
         Facade.changeUserStage("m1_hero_vector_success");
         CoreLogic.pause = false;
         assignStep(new DamageStep("bl_guard_tower"),this.heroStep5);
      }
      
      private function heroStep5() : void
      {
         CoreLogic.pause = boardLock = true;
         Facade.boardMediator.smoothMoveBoard(26,22);
         assignStep(new StoryStep("un_motocycle1",Lang.getString("train1_3"),-168,146),this.onMoto2Step1);
         Facade.changeUserStage("m1_train1_3_open");
      }
      
      private function onMoto2Step1() : void
      {
         Facade.boardMediator.moveBoard(30,14);
         Facade.changeUserStage("m1_train1_3_close");
         boardLock = false;
         var _loc1_:String = "un_motocycle";
         showSoldierDp(this.soldierDp,_loc1_);
         assignSelectDropStep(this,_loc1_,this.onMoto2Step2);
      }
      
      private function onMoto2Step2() : void
      {
         Facade.changeUserStage("m1_motocycle_choice");
         assignStep(new CmdStep(new Position(30,11),new Position(30,16),"m1_motocycle_vector_click"),this.onMoto2Step3);
      }
      
      private function onMoto2Step3() : void
      {
         Facade.changeUserStage("m1_motocycle_vector_success");
         CoreLogic.pause = false;
         assignStep(new DamageStep("bl_power_plant"),this.onMoto2Step4);
      }
      
      private function onMoto2Step4() : void
      {
         Facade.boardMediator.smoothMoveBoard(26,22);
         CoreLogic.pause = true;
         assignStep(new StoryStep("un_motocycle1",Lang.getString("train1_electro"),-164,156),this.onMoto2Step5);
      }
      
      private function onMoto2Step5() : void
      {
         CoreLogic.pause = false;
      }
   }
}

