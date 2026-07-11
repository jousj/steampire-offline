package logic.training.firstsession
{
   import engine.Position;
   import engine.units.Build;
   import engine.units.Unit;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.training.*;
   import model.CommonEvent;
   import model.vo.MapAction;
   import proto.model.PBtype;
   
   public class BallistaTrain extends BuyTrain
   {
      
      private var cooldownHandler:Function;
      
      private var step:uint = 0;
      
      private const ENERGY_DELAY:Number = 1;
      
      public function BallistaTrain()
      {
         Facade.isBattle = Facade.battleMediator.isAudioTheme = true;
         Facade.audioProxy.startTheme();
         Facade.isBattle = Facade.battleMediator.isAudioTheme = false;
         Facade.changeUserStage("home1_jaina1");
         var _loc1_:Build = Facade.userProxy.getBuild(PBtype.PYLON,false);
         if(Facade.userProxy.getCannon("cn_ballista",true))
         {
            this.step = 1;
         }
         else
         {
            boardLock = true;
            Facade.board.mouseChildren = false;
         }
         super("cn_ballista",new Position(_loc1_.c_x,_loc1_.c_y + _loc1_.size + _loc1_.spec.radius + 3));
      }
      
      override public function run() : void
      {
         if(this.step == 0)
         {
            Facade.changeUserStage("home1_jaina1_click");
            assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_ballista_1")).useMultipleSay(),this.storyStep2);
         }
         else
         {
            this.storyStep3();
         }
      }
      
      private function storyStep2() : void
      {
         Facade.changeUserStage("home1_jaina2_click");
         assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_ballista_2")),super.run);
      }
      
      override protected function showShopButton() : void
      {
         super.showShopButton();
      }
      
      override protected function onShopOpen() : void
      {
         Facade.changeUserStage("home1_shop_click");
         super.onShopOpen();
      }
      
      override protected function onShopSelect() : void
      {
         boardLock = false;
         Facade.board.mouseChildren = true;
         Facade.changeUserStage("home1_ballista_hover");
         var _loc1_:PlaceStep = new PlaceStep(pos);
         _loc1_.smooth = false;
         assignStep(_loc1_,onPlace);
         Facade.addListener(CommonEvent.NEW_UNIT,this.onPlaceCheck);
         Facade.addListener(CommonEvent.BOARD_NOT_PUT,this.onPlaceCheck);
      }
      
      private function onPlaceCheck(param1:CommonEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MapAction = null;
         if(param1.type == CommonEvent.NEW_UNIT)
         {
            _loc2_ = 23;
            if(param1.data)
            {
               _loc3_ = CoreLogic.getAction(ActionLogic.FINISH_CONSTRUCTION,Facade.boardMediator.getSelected().id);
               if(_loc3_)
               {
                  this.writeMAHandler(_loc3_);
               }
            }
         }
         else
         {
            _loc2_ = 24;
         }
         if(!Facade.checkUserStage("home1_ballista_placed"))
         {
            Facade.changeUserStage("home1_ballista_placed");
            Facade.fact(_loc2_);
         }
      }
      
      private function writeMAHandler(param1:MapAction) : void
      {
         this.cooldownHandler = param1.handler;
         param1.handler = this.onFinishConstruction;
      }
      
      override protected function showUnit(param1:Unit) : void
      {
         var _loc2_:MapAction = CoreLogic.getAction(ActionLogic.FINISH_CONSTRUCTION,param1.id);
         if(_loc2_)
         {
            this.writeMAHandler(_loc2_);
         }
         super.showUnit(param1);
      }
      
      private function onFinishConstruction(param1:Object, param2:Boolean = false) : void
      {
         this.cooldownHandler.apply(null,[param1,param2]);
         if(this.step < 3)
         {
            this.useSpeedupStage();
         }
      }
      
      override protected function useSpeedupStage() : void
      {
         this.step = 3;
         Facade.changeUserStage("home1_ballista_speedup_click");
         super.useSpeedupStage();
         Facade.boardMediator.setSelected(null);
         boardLock = true;
         Facade.board.mouseChildren = false;
         wait(this.ENERGY_DELAY,this.storyStep3);
      }
      
      private function storyStep3() : void
      {
         assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_ballista_energy_1")).useMultipleSay(),this.storyStep4);
      }
      
      private function storyStep4() : void
      {
         Facade.changeUserStage("home1_jaina3_click");
         assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_ballista_energy_2")),this.finish);
      }
      
      private function finish() : void
      {
         Facade.changeUserStage("home1_jaina4_click");
         AbstractTrain.assign(new PowerTrain());
      }
      
      override public function dispose() : void
      {
         Facade.removeListener(CommonEvent.NEW_UNIT,onPlace);
         Facade.removeListener(CommonEvent.BOARD_NOT_PUT,onPlace);
         boardLock = false;
         Facade.board.mouseChildren = true;
         super.dispose();
      }
   }
}

