package logic.training.firstsession
{
   import engine.Position;
   import engine.units.Cannon;
   import flash.geom.Point;
   import logic.MainLogic;
   import logic.training.AbstractTrain;
   import logic.training.NewStoryStep;
   import logic.training.PlaceStep;
   import logic.training.SelectUnitStep;
   
   public class PowerTrain extends AbstractTrain
   {
      
      private var ballista:Cannon;
      
      public function PowerTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         this.ballista = Facade.userProxy.getCannon("cn_ballista",false);
         if(!this.ballista)
         {
            return;
         }
         boardLock = false;
         Facade.board.mouseChildren = true;
         Facade.mainMediator.closeAllDialog();
         Facade.boardMediator.resetMoved();
         Facade.mainPanel.mouseChildren = false;
         assignStep(new SelectUnitStep(this.ballista,1,true,new Point(30,50)),this.stepBallistaSelect);
      }
      
      private function stepBallistaSelect() : void
      {
         Facade.changeUserStage("home1_ballista_click1");
         this.ballista.logic.changeOver(this.ballista,false);
         boardLock = true;
         Facade.boardMediator.getMenuBox(false).mouseChildren = false;
         Facade.board.mouseChildren = false;
         wait(0.7,this.stepBallistaSelect2);
      }
      
      private function stepBallistaSelect2() : void
      {
         boardLock = false;
         Facade.board.mouseChildren = true;
         Facade.changeUserStage("home1_ballista_click2");
         assignStep(new SelectUnitStep(this.ballista,1,false,new Point(30,50)),this.stepBallistaPlace);
      }
      
      private function stepBallistaPlace() : void
      {
         Facade.boardMediator.movePanel.visible = false;
         assignStep(new PlaceStep(new Position(27,19),false),this.finishMove);
      }
      
      private function finishMove() : void
      {
         wait(1,this.onJainaPhrase);
         Facade.stage.mouseChildren = false;
      }
      
      private function onJainaPhrase() : void
      {
         Facade.mainPanel.mouseChildren = Facade.stage.mouseChildren = true;
         Facade.changeUserStage("home1_jaina5");
         assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_ballista_completed")),this.getNextMission);
      }
      
      private function getNextMission() : void
      {
         Facade.changeUserStage("home1_jaina5_click");
         MainLogic.getFriendMap(Preloader.uid,false,false,3);
      }
      
      override public function dispose() : void
      {
         boardLock = false;
         Facade.boardMediator.getMenuBox(false).mouseChildren = Facade.mainPanel.mouseChildren = Facade.stage.mouseChildren = Facade.board.mouseChildren = true;
         super.dispose();
      }
   }
}

