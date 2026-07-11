package logic.training.firstsession
{
   import engine.signal.Signal;
   import engine.units.Build;
   import flash.geom.Point;
   import game.barrack.BarrackBuyRenderer;
   import game.barrack.BarrackDialog;
   import game.missions.MissionButton;
   import game.missions.MissionMapDialog;
   import game.my.GoDialog;
   import logic.DialogLogic;
   import logic.MainLogic;
   import logic.training.*;
   import model.CommonEvent;
   import model.UserProxy;
   import model.ui.VOBarrackItem;
   import model.ui.VOCallback;
   import proto.model.PBtype;
   import proto.model.PShopUnit;
   import ui.vbase.VButton;
   import ui.vbase.VEvent;
   
   public class WarriorTrain extends AbstractTrain
   {
      
      private const signal:Signal = new Signal();
      
      private var step:uint = 0;
      
      private var warriorsCount:uint;
      
      private var dialog:MissionMapDialog;
      
      public function WarriorTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         Facade.changeUserStage("boss_beaten");
         assignStep(new NewStoryStep("un_boss_warrior",Lang.getString("boss1_beaten"),false),this.openMap);
         this.warriorsCount = Facade.userProxy.soldierCapacityCur;
      }
      
      private function openMap() : void
      {
         MissionButton.currentBoss = "something";
         DialogLogic.toMissionMap();
         this.dialog = Facade.mainMediator.searchDialog(MissionMapDialog);
         this.dialog.mouseChildren = false;
         this.dialog.addLoadListener(this.onMapLoad);
      }
      
      private function onMapLoad(param1:VEvent) : void
      {
         var _loc2_:Point = this.dialog.getScrollParams("1");
         var _loc3_:Point = this.dialog.getScrollParams("8");
         this.signal.handler = this.onSignal;
         this.signal.data = [_loc2_,_loc3_];
         this.signal.delay = 0.02;
         this.signal.run(1.2);
      }
      
      private function onSignal() : void
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
            this.appearBossStep();
         }
      }
      
      private function appearBossStep() : void
      {
         MissionButton.currentBoss = null;
         this.dialog.openSingleZone("8");
         wait(2,this.onMapOpen);
      }
      
      private function onMapOpen() : void
      {
         assignStep(new BlackoutClickStep(this.dialog.closeBt,225,{
            "top":25,
            "hCenter":-5
         },new VOCallback(this.onMapClose)));
         this.dialog.mouseChildren = true;
      }
      
      private function onMapClose() : void
      {
         Facade.changeUserStage("map2_close");
         assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_train_army")),this.getWarriors);
      }
      
      private function getWarriors() : void
      {
         Facade.changeUserStage("home2_jaina1_click");
         var _loc1_:Build = Facade.userProxy.getBuild(PBtype.BARRACK,false);
         if(Boolean(_loc1_) && this.warriorsCount < Facade.userProxy.soldierCapacityMax)
         {
            Facade.boardMediator.moveBoard(_loc1_.t_x,_loc1_.t_y);
            assignStep(new BlackoutClickStep(_loc1_.getStatus(),180,{
               "hCenter":0,
               "bottom":0
            }),this.onBarrackFirstOpen);
         }
         else
         {
            this.finishHire();
         }
      }
      
      private function onBarrackFirstOpen() : void
      {
         Facade.changeUserStage("home2_barrack_click");
         this.onBarrackOpen();
      }
      
      private function onBarrackOpen() : void
      {
         var _loc3_:BarrackBuyRenderer = null;
         var _loc4_:String = null;
         var _loc5_:PShopUnit = null;
         var _loc6_:VButton = null;
         var _loc1_:BarrackDialog = Facade.mainMediator.searchDialog(BarrackDialog);
         if(!_loc1_)
         {
            this.finishHire();
         }
         var _loc2_:UserProxy = Facade.userProxy;
         for each(_loc3_ in _loc1_.buyGrid.renderList)
         {
            _loc4_ = this.warriorsCount < 20 ? "un_warrior" : "un_sniper";
            if(_loc3_.checkBuyBt(_loc4_))
            {
               _loc5_ = (_loc3_.buyBt.data as VOBarrackItem).shop;
               if(_loc2_.checkCost(_loc5_.su_price.variance,_loc5_.su_price.value) > 0 || _loc2_.energy < _loc5_.su_hspace)
               {
                  assignStep(new BlackoutClickStep(_loc1_.closeBt,225,{
                     "top":25,
                     "hCenter":-5
                  },new VOCallback(this.finishHire)));
                  return;
               }
               if(Boolean(_loc3_.buy5Bt) && _loc3_.buy5Bt.visible)
               {
                  this.warriorsCount += 5;
                  _loc6_ = _loc3_.buy5Bt;
               }
               else
               {
                  ++this.warriorsCount;
                  _loc6_ = _loc3_.buyBt;
               }
               Facade.changeUserStage("home2_hire_" + this.warriorsCount);
               assignStep(new BlackoutClickStep(_loc6_,0,{"hCenter":0}),this.onBarrackOpen);
               return;
            }
         }
         assignStep(new BlackoutClickStep(_loc1_.closeBt,225,{
            "top":25,
            "hCenter":-5
         },new VOCallback(this.finishHire)));
      }
      
      private function finishHire() : void
      {
         Facade.changeUserStage("home2_barrack_close_click");
         assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_mission2")),this.steamPhrase);
      }
      
      private function steamPhrase() : void
      {
         Facade.changeUserStage("home2_jaina2_click");
         assignStep(new NewStoryStep("un_hero1",Lang.getString("hero2_mission2"),true,null,"_1"),this.openQuest);
      }
      
      private function openQuest() : void
      {
         Facade.addListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         Facade.changeUserStage("home2_hero1_click");
         assignStep(new BlackoutClickStep(Facade.myMediator.myPanel.goBt,-40,{
            "left":5,
            "top":5
         }));
      }
      
      private function onShowDialog(param1:CommonEvent) : void
      {
         if(this.step == 0)
         {
            if(param1.data is GoDialog)
            {
               this.onGoDialog(param1.data);
            }
         }
         else if(this.step == 1)
         {
            if(param1.data is MissionMapDialog)
            {
               this.onMissionMapDialog(param1.data);
            }
         }
      }
      
      private function onGoDialog(param1:GoDialog) : void
      {
         Facade.changeUserStage("home2_attack_click");
         ++this.step;
         assignStep(new BlackoutClickStep(param1.missionBt,0,{"hCenter":0}));
      }
      
      private function onMissionMapDialog(param1:MissionMapDialog) : void
      {
         Facade.changeUserStage("home2_campaign_click");
         Facade.removeListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         param1.addLoadListener(this.onMissionMapLoaded);
      }
      
      private function onMissionMapLoaded(param1:VEvent) : void
      {
         Facade.changeUserStage("map3_mission2_arrow");
         this.dialog = param1.data as MissionMapDialog;
         this.dialog.scroll("2");
         assignStep(new BlackoutClickStep(this.dialog.getButton("2"),0,{
            "hCenter":0,
            "top":4
         }),this.onMissionClick);
      }
      
      private function onMissionClick() : void
      {
         Facade.changeUserStage("map3_mission2_icon_click");
         assignStep(new BlackoutClickStep(this.dialog.cellarPanel.battleBt,0,{
            "hCenter":0,
            "top":4
         },null,false),this.getNextMission);
      }
      
      private function getNextMission() : void
      {
         Facade.changeUserStage("map3_mission2_attack_click");
         MainLogic.getFriendMap("ms_mission2",true,false,4);
      }
      
      override public function dispose() : void
      {
         this.signal.stopWithoutHandler();
         Facade.removeListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         boardLock = false;
         Facade.board.mouseChildren = true;
         super.dispose();
      }
   }
}

