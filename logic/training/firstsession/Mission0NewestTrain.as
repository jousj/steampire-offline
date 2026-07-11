package logic.training.firstsession
{
   import engine.Position;
   import engine.data.MapCell;
   import engine.data.MoveData;
   import engine.signal.Signal;
   import engine.units.AnimObject;
   import engine.units.Build;
   import engine.units.Soldier;
   import flash.display.StageQuality;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import game.battle.BattleMediator;
   import game.battle.drop.DropRenderer;
   import game.missions.MissionButton;
   import game.missions.MissionMapDialog;
   import game.quest.ComicDialog;
   import game.quest.ComicSlide;
   import logic.BoardLogic;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import logic.MainLogic;
   import logic.UnitFactory;
   import logic.sim.SimUnitT;
   import logic.training.*;
   import model.ui.VOBattleItem;
   import proto.model.PBtype;
   import ui.vbase.SkinManager;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import utils.CommonUtils;
   
   public class Mission0NewestTrain extends AbstractTrain
   {
      
      private const fadeToBlack:VFill = new VFill(0);
      
      private const bm:BattleMediator = Facade.battleMediator;
      
      private var fact:int;
      
      private var mapPoint:Point;
      
      private var dialog:MissionMapDialog;
      
      private var savedDp:Array;
      
      private var dropCount:uint;
      
      private var isDown:Boolean;
      
      private var targetRenderer:DropRenderer;
      
      private var damageStep:DamageStep;
      
      private var filter:GlowFilter;
      
      private var signal:Signal = new Signal();
      
      private var boss:Soldier;
      
      public function Mission0NewestTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc3_:VOBattleItem = null;
         Facade.changeUserStage("first_look");
         Facade.mainPanel.addInterLayer(Facade.myMediator.prefPanel,false,false);
         this.bm.dropPanel.usePower = false;
         this.bm.dropPanel.setSpellDp(null);
         this.bm.dropPanel.update();
         this.bm.dropPanel.mouseLock = true;
         this.bm.rivalPanel.visible = false;
         this.bm.battlePanel.visible = false;
         Facade.myMediator.prefPanel.lock = true;
         boardLock = true;
         Facade.audioProxy.changeVolume(0.3,false);
         var _loc1_:Build = Facade.userProxy.getBuild(PBtype.TOWNHALL,true);
         _loc1_.setStatus(SkinManager.getEmbed("TargetStatus",VSkin.CACHE_AS_BITMAP));
         Facade.boardMediator.moveBoard(22,33);
         Facade.myMediator.changeZoom(0.75);
         this.boss = UnitFactory.createSoldier(getShop("un_boss_healer",1),10001);
         this.boss.display.addFilter(new GlowFilter(13421568,1,2,2));
         this.boss.setGeometry(22,43,true);
         Facade.boardMediator.addObject(this.boss,false);
         var _loc2_:VOBattleItem = null;
         this.savedDp = [];
         for each(_loc3_ in this.bm.soldierDp)
         {
            if(_loc3_.shop.su_kind == "un_tank_mithril")
            {
               _loc2_ = _loc3_;
            }
            else
            {
               this.savedDp.push(_loc3_);
            }
         }
         this.bm.soldierDp.length = 0;
         this.bm.soldierDp.push(_loc2_);
         this.bm.syncDropDp();
         this.fact = 1;
         Facade.stage.addEventListener(MouseEvent.CLICK,this.onPreStoryClick);
         Facade.myMediator.prefPanel.settingBt.addClickListener(this.onSettingsClick);
         Facade.myMediator.prefPanel.fullScreenBt.addClickListener(this.onFullClick);
         this.startBossWalk();
      }
      
      private function onPreStoryClick(param1:MouseEvent) : void
      {
         Facade.stage.removeEventListener(MouseEvent.CLICK,this.onPreStoryClick);
         --this.fact;
      }
      
      private function onFullClick(param1:MouseEvent) : void
      {
         if(!Facade.checkUserStage("m0_healer1_click"))
         {
            Facade.myMediator.prefPanel.fullScreenBt.removeListener(MouseEvent.CLICK,this.onFullClick);
            Facade.changeUserStage("m0_healer1_click");
            Facade.fact(4);
         }
      }
      
      private function onSettingsClick(param1:MouseEvent) : void
      {
         if(!Facade.checkUserStage("m0_healer1_click"))
         {
            Facade.myMediator.prefPanel.settingBt.removeListener(MouseEvent.CLICK,this.onSettingsClick);
            Facade.changeUserStage("m0_healer1_click");
            Facade.fact(3);
         }
      }
      
      private function startBossWalk() : void
      {
         var _loc3_:MapCell = null;
         this.boss.useWalkPath();
         var _loc1_:MoveData = new MoveData();
         _loc1_.endHandler = this.onBossStart;
         var _loc2_:* = 41;
         while(_loc2_ >= 38)
         {
            _loc3_ = new MapCell();
            _loc3_.x = 22;
            _loc3_.y = _loc2_;
            _loc1_.pathList.push(_loc3_);
            _loc2_--;
         }
         this.boss.startWalkPathEx(_loc1_);
      }
      
      private function bossPlayStand() : void
      {
         this.boss.animClip.endHandler = this.bossPlayStand2;
         this.boss.playAnim("stand");
      }
      
      private function bossPlayStand2() : void
      {
         this.boss.animClip.endHandler = this.bossPlayAttack;
         this.boss.playAnim("stand");
      }
      
      private function bossPlayAttack() : void
      {
         this.boss.animClip.endHandler = this.bossPlayStand;
         this.boss.playAnim("attack1");
         var _loc1_:VOBattleItem = new VOBattleItem();
         var _loc2_:String = "sp_fireball";
         _loc1_.spellShop = Facade.manualProxy.getSpellShop(_loc2_,1);
         var _loc3_:uint = 0;
         while(_loc3_ < 4)
         {
            this.bm.sim.addSpellEvent(this.bm.curSimTime + 300 + CommonUtils.getRangeRandom(0,350),new Position(CommonUtils.getRangeRandom(12,31),CommonUtils.getRangeRandom(15,31)),_loc1_.spellShop,_loc1_.count,true);
            _loc3_++;
         }
         this.signal.handler = this.onSignal1;
         Signal.delayCall(0.2 / CoreLogic.simulateFactor,this.signal.run,[0.6 / CoreLogic.simulateFactor]);
      }
      
      private function onSignal1() : void
      {
         this.getFilter(this.signal.passedRate);
         this.boss.display.filters = [this.filter];
         if(this.signal.tail == 0)
         {
            this.signal.handler = this.onSignal2;
            this.signal.run(0.6 / CoreLogic.simulateFactor);
         }
      }
      
      private function onSignal2() : void
      {
         this.getFilter(1 - this.signal.passedRate);
         this.boss.display.filters = [this.filter];
         if(this.signal.tail == 0)
         {
            this.boss.display.filters = null;
         }
      }
      
      private function getFilter(param1:Number) : void
      {
         if(!this.filter)
         {
            this.filter = new GlowFilter(16763904,0,24,24,8);
         }
         this.filter.alpha = param1;
         this.filter.blurX = this.filter.blurY = 18 * param1;
         this.filter.strength = 6 * param1;
      }
      
      private function onBossStart() : void
      {
         this.boss.stand();
         Facade.boardMediator.smoothMoveBoard(22,27);
         wait(1,this.onBossStory1);
      }
      
      private function onBossStory1() : void
      {
         if(!Facade.checkUserStage("m0_healer1"))
         {
            Facade.fact(this.fact);
         }
         if(!this.mapPoint)
         {
            this.mapPoint = new Point(Facade.board.x,Facade.board.y);
         }
         CoreLogic.pause = true;
         Facade.changeUserStage("m0_healer1");
         assignStep(new NewStoryStep("un_boss_healer",Lang.getString("healer_mithril_intro1")).useMultipleSay(),this.onEmperorStory);
      }
      
      private function onEmperorStory() : void
      {
         if(!Facade.checkUserStage("m0_healer1_click"))
         {
            Facade.changeUserStage("m0_healer1_click");
            Facade.fact(2);
         }
         assignStep(new NewStoryStep("un_emperor",Lang.getString("emperor_intro"),false).useMultipleSay(),this.onBossStory2);
      }
      
      private function onBossStory2() : void
      {
         Facade.changeUserStage("m0_emperor_click");
         assignStep(new NewStoryStep("un_boss_healer",Lang.getString("healer_mithril_intro2"),true,Lang.getString("help_attack")),this.onAttack1);
      }
      
      private function onAttack1() : void
      {
         UnitFactory.buildLogic.stopExAnimation();
         Facade.stage.quality = StageQuality.MEDIUM;
         Facade.changeUserStage("m0_healer2_click");
         this.bm.bp.winList.length = 0;
         this.bm.battlePanel.setWinTarget(null,null);
         this.bm.battlePanel.visible = true;
         UnitFactory.useBubble(this.boss,Lang.getString("help_attack"),{
            "w":120,
            "h":68,
            "left":26,
            "vCenter":22
         });
         this.boss.direction = AnimObject.RIGHT_UP;
         this.boss.animClip.endHandler = this.bossPlayStand;
         this.boss.playAnim("stand");
         this.boss.setStatus(null);
         Mission1Train.assignSelectDropStep(this,"un_tank_mithril",this.onTank);
      }
      
      private function onTank() : void
      {
         Facade.changeUserStage("m0_tank_choice");
         this.boss.setStatus(null);
         boardLock = false;
         var _loc1_:CmdStep = new CmdStep(new Position(22,35),new Position(21,20),"m0_tank_vector_click",new Position(22,29),false).setArea(2);
         _loc1_.isForceEnd = true;
         if(!Facade.checkUserStage("m0_tank_vector_success"))
         {
            _loc1_.fact = 5;
         }
         assignStep(_loc1_,this.onTank2);
      }
      
      private function onTank2() : void
      {
         var _loc1_:SimUnitT = null;
         Facade.changeUserStage("m0_tank_vector_success");
         for each(_loc1_ in this.bm.sim.data.units)
         {
            if(_loc1_.kind == "un_tank_mithril")
            {
               _loc1_.damage *= 1.5;
               _loc1_.move_delay /= 2;
            }
         }
         this.bm.dropPanel.reset();
         CoreLogic.pause = false;
         wait(1,this.onLandingPause);
         this.damageStep = new DamageStep("bl_town_hall");
         this.damageStep.run();
         this.damageStep.endFunc = this.onWin1;
      }
      
      private function checkWarriorHint(param1:VEvent = null) : void
      {
         var _loc2_:DropRenderer = null;
         BoardLogic.updateLanding(true);
         this.targetRenderer = null;
         for each(_loc2_ in this.bm.dropPanel.soldierGrid.renderList)
         {
            if(_loc2_.item.shop.su_kind == "un_warrior_mithril")
            {
               this.targetRenderer = _loc2_;
               break;
            }
         }
         if(this.targetRenderer)
         {
            wait(12,this.checkWarriorBlackout);
            Facade.board.addEventListener(MouseEvent.MOUSE_DOWN,this.onMDown);
            Facade.board.addEventListener(MouseEvent.MOUSE_UP,this.onMUp);
            assignStep(new SoftHintStep(this.targetRenderer,1.5));
            this.bm.dropPanel.addListener(VEvent.SELECT,this.onSelect);
         }
         else
         {
            this.checkOtherHint();
         }
      }
      
      private function onSelect(param1:VEvent) : void
      {
         if(this.bm.dropPanel.selectPanel)
         {
            this.onOtherSelect();
         }
         else
         {
            this.checkOtherHint();
         }
      }
      
      private function onMUp(param1:MouseEvent) : void
      {
         this.isDown = false;
      }
      
      private function onMDown(param1:MouseEvent) : void
      {
         this.isDown = true;
      }
      
      private function checkWarriorBlackout() : void
      {
         var _loc1_:DropRenderer = null;
         if(this.getDropCount() < this.dropCount)
         {
            Facade.fact(9);
            return;
         }
         if(this.isDown)
         {
            wait(1,this.checkWarriorBlackout);
         }
         else
         {
            Facade.fact(10);
            Facade.board.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMDown);
            Facade.board.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMUp);
            this.bm.dropPanel.removeListener(VEvent.SELECT,this.onSelect);
            for each(_loc1_ in this.bm.dropPanel.soldierGrid.renderList)
            {
               if(_loc1_.item.shop.su_kind == "un_warrior_mithril")
               {
                  this.bm.dropPanel.reset();
                  CoreLogic.pause = true;
                  if(!this.bm.dropPanel.selectPanel || this.bm.dropPanel.selectPanel.item.shop.su_kind != "un_warrior_mithril")
                  {
                     Mission1Train.assignSelectDropStep(this,"un_warrior_mithril",this.onWarriorSelect);
                  }
                  else
                  {
                     this.onWarriorSelect();
                  }
                  return;
               }
            }
         }
      }
      
      private function onWarriorSelect() : void
      {
         Facade.changeUserStage("m0_warrior_choice");
         this.bm.dropPanel.selectPanel.drop_value = this.targetRenderer.item.count;
         assignStep(new CmdStep(new Position(21,36),new Position(21,20),"m0_warrior_vector_click").setArea(2),this.onWarriorDrop);
      }
      
      private function onWarriorDrop() : void
      {
         Facade.changeUserStage("m0_warrior_vector_success");
         this.bm.dropPanel.addListener(VEvent.SELECT,this.onSelect);
         BoardLogic.updateLanding(false);
         CoreLogic.pause = false;
         this.bm.dropPanel.reset();
      }
      
      private function checkOtherHint(param1:Number = 2) : void
      {
         var _loc2_:VGrid = null;
         this.targetRenderer = null;
         if(this.bm.dropPanel.soldierGrid.length > 0)
         {
            _loc2_ = this.bm.dropPanel.soldierGrid;
            this.targetRenderer = _loc2_.renderList[0] as DropRenderer;
            assignStep(new SoftHintStep(this.targetRenderer,param1));
         }
         else
         {
            this.bm.dropPanel.removeListener(VEvent.SELECT,this.onSelect);
         }
      }
      
      private function onOtherSelect() : void
      {
         this.bm.dropPanel.selectPanel.drop_value = this.targetRenderer.item.count;
         assignStep(new SoftDropStep(new Position(24,36),new Position(20,19),0.2),this.checker);
      }
      
      private function checker() : void
      {
         this.bm.dropPanel.reset();
         Facade.myMediator.changeZoom(0.65);
      }
      
      private function getDropCount() : uint
      {
         var _loc2_:VOBattleItem = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.bm.soldierDp)
         {
            _loc1_ += _loc2_.count;
         }
         return _loc1_;
      }
      
      private function onLandingPause() : void
      {
         var _loc1_:VOBattleItem = null;
         this.bm.soldierDp.length = 0;
         for each(_loc1_ in this.savedDp)
         {
            this.bm.soldierDp.push(_loc1_);
         }
         this.bm.syncDropDp();
         this.dropCount = this.getDropCount();
         this.bm.dropPanel.mouseLock = false;
         this.checkWarriorHint();
      }
      
      private function onWin1() : void
      {
         Facade.fact(14 - this.bm.dropPanel.soldierGrid.length);
         if(Boolean(this.mapPoint) && (this.mapPoint.x != Facade.board.x || this.mapPoint.y != Facade.board.y))
         {
            Facade.fact(15);
         }
         else
         {
            Facade.fact(16);
         }
         this.damageStep.dispose();
         this.damageStep.endFunc = null;
         this.damageStep = null;
         Facade.board.mouseEnabled = false;
         wait(1,this.onWin2);
      }
      
      private function onWin2() : void
      {
         CoreLogic.pause = true;
         CoreLogic.simulateFactor = 2;
         CoreLogic.pause = false;
         wait(0.5,this.onWin4);
      }
      
      private function onWin4() : void
      {
         var _loc2_:SimUnitT = null;
         this.bm.battlePanel.add(this.fadeToBlack,{
            "hCenter":0,
            "w":-120,
            "h":-100
         });
         this.fadeToBlack.alpha = 0;
         var _loc1_:Signal = new Signal(this.onHalfFillSignal,0,true);
         _loc1_.delay = 0.02;
         _loc1_.run(5);
         for each(_loc2_ in this.bm.sim.data.units)
         {
            if(_loc2_.kind == "un_tank")
            {
               _loc2_.damage *= 4;
            }
         }
      }
      
      private function onHalfFillSignal(param1:Signal) : void
      {
         this.fadeToBlack.alpha = param1.passedRate / 3;
         if(param1.tail == 0)
         {
            CoreLogic.pause = true;
            this.fadeToBlack.alpha = 0;
            Facade.changeUserStage("m0_hero1");
            assignStep(new NewStoryStep("un_hero1",Lang.getString("hero2_intro")),this.onComicStart);
         }
      }
      
      private function onComicStart() : void
      {
         Facade.changeUserStage("m0_hero1_click");
         this.fadeToBlack.alpha = 0.5;
         this.signal.handler = this.onFillSignal;
         this.signal.delay = 0.02;
         this.signal.run(1);
      }
      
      private function onFillSignal() : void
      {
         var _loc1_:Vector.<ComicSlide> = null;
         var _loc2_:uint = 0;
         this.fadeToBlack.alpha = 0.33 + 2 * this.signal.passedRate / 3;
         if(this.signal.tail == 0)
         {
            _loc1_ = new Vector.<ComicSlide>();
            _loc2_ = 1;
            while(_loc2_ <= 3)
            {
               _loc1_.push(new ComicSlide("comics_intro" + _loc2_,"start_comic_slide_0" + _loc2_));
               _loc2_++;
            }
            Facade.mainMediator.showDialog(new ComicDialog(_loc1_,this.onComicEnd,"comics"));
         }
      }
      
      private function onComicEnd() : void
      {
         this.signal.handler = this.onUnFillSignal;
         this.signal.delay = 0.02;
         this.signal.run(0.5);
         this.bm.rivalPanel.visible = false;
         this.bm.battlePanel.visible = false;
         Facade.board.tilePanel.visible = Facade.board.groundPanel.visible = Facade.board.effectPanel.visible = false;
         MissionButton.currentBoss = "something";
         DialogLogic.toMissionMap();
         this.dialog = Facade.mainMediator.searchDialog(MissionMapDialog);
         this.dialog.mouseChildren = false;
         this.dialog.addLoadListener(this.onMapLoad);
      }
      
      private function onMapLoad(param1:VEvent) : void
      {
         this.dialog.scroll("27");
         MissionButton.currentBoss = null;
         this.dialog.openSingleZone("27");
         wait(1.5,this.onMapScroll);
      }
      
      private function onMapScroll() : void
      {
         var _loc1_:Point = this.dialog.getScrollParams("27");
         var _loc2_:Point = this.dialog.getScrollParams("1");
         this.signal.handler = this.onScrollSignal;
         this.signal.data = [_loc1_,_loc2_];
         this.signal.delay = 0.02;
         this.signal.run(1.2);
      }
      
      private function onScrollSignal() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         if(this.signal.tail != 0)
         {
            _loc1_ = this.signal.data[0];
            _loc2_ = this.signal.data[1];
            this.dialog.move(_loc1_.x - this.signal.passedRate * (_loc1_.x - _loc2_.x),_loc1_.y - this.signal.passedRate * (_loc1_.y - _loc2_.y),false);
         }
         else
         {
            this.appearFirstMissionStep();
         }
      }
      
      private function appearFirstMissionStep() : void
      {
         Facade.changeUserStage("map1_ms1_arrow");
         assignStep(new BlackoutClickStep(this.dialog.getButton("1"),0,{
            "hCenter":0,
            "top":4
         },null,false),this.onMissionClick);
      }
      
      private function onMissionClick() : void
      {
         Facade.changeUserStage("map1_ms1_click");
         MainLogic.checkTrainMission();
      }
      
      private function onUnFillSignal() : void
      {
         this.fadeToBlack.alpha = 1 - this.signal.passedRate;
         if(this.signal.tail == 0)
         {
            this.fadeToBlack.removeFromParent();
         }
      }
      
      override public function dispose() : void
      {
         Facade.fact(Facade.audioProxy.getVolume(true) > 0 ? 17 : 18);
         Facade.fact(Facade.audioProxy.getVolume(false) > 0 ? 19 : 20);
         Facade.board.tilePanel.visible = Facade.board.groundPanel.visible = Facade.board.effectPanel.visible = true;
         Facade.myMediator.prefPanel.fullScreenBt.removeListener(MouseEvent.CLICK,this.onFullClick);
         Facade.myMediator.prefPanel.settingBt.removeListener(MouseEvent.CLICK,this.onSettingsClick);
         Facade.stage.removeEventListener(MouseEvent.CLICK,this.onPreStoryClick);
         Facade.board.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMDown);
         Facade.board.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMUp);
         this.bm.dropPanel.removeListener(VEvent.SELECT,this.onSelect);
         this.bm.rivalPanel.visible = this.bm.battlePanel.visible = true;
         this.bm.dropPanel.mouseLock = Facade.myMediator.prefPanel.lock = boardLock = false;
         this.fadeToBlack.removeFromParent();
         if(this.signal)
         {
            this.signal.stopWithoutHandler();
         }
         Facade.mainPanel.layerPanel.add(Facade.myMediator.prefPanel);
         super.dispose();
      }
   }
}

