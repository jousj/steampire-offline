package logic.training.firstsession
{
   import engine.units.Build;
   import flash.geom.Point;
   import game.feature.FeatureDialog;
   import game.my.MyMediator;
   import game.quest.QuestButton;
   import game.quest.QuestOneDialog;
   import logic.training.BlackoutClickStep;
   import logic.training.SelectUnitStep;
   import model.CommonEvent;
   import model.ui.VOCallback;
   import proto.model.PBtype;
   import ui.vbase.VButton;
   
   public class TownTrain extends HardRewardTrain
   {
      
      private const townHall:Build = Facade.userProxy.getBuild(PBtype.TOWNHALL,false);
      
      public function TownTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         if(item.isComplete)
         {
            Facade.changeUserStage("home3_th_speedup_click");
            wait(1,this.checkQuestDialog);
         }
         else
         {
            Facade.changeUserStage("home3_jaina1_click");
            this.setTownHallSelect();
         }
      }
      
      override protected function checkQuestDialog(param1:QuestOneDialog = null) : Boolean
      {
         var _loc2_:VButton = null;
         var _loc3_:QuestButton = null;
         if(!param1)
         {
            param1 = Facade.mainMediator.searchDialog(QuestOneDialog);
         }
         if(param1)
         {
            Facade.changeUserStage("home3_qth_click");
            _loc2_ = param1.renderer.rewardBt;
            assignStep(new BlackoutClickStep(_loc2_,270,{
               "left":-4,
               "vCenter":0
            },new VOCallback(this.rewardComplete)));
            return true;
         }
         if(!isShowListener)
         {
            Facade.boardMediator.resetMoved();
            isShowListener = true;
            _loc3_ = Facade.myMediator.myPanel.questBtPanel.getButton(item.kind);
            if(_loc3_)
            {
               assignStep(new BlackoutClickStep(_loc3_,NaN,null));
            }
            _loc3_.loopClip();
            Facade.addListener(CommonEvent.SHOW_DIALOG,onShowDialog);
         }
         return false;
      }
      
      private function rewardComplete() : void
      {
         Facade.changeUserStage("home3_qth_reward_click");
      }
      
      private function setTownHallSelect() : void
      {
         Facade.changeUserStage("home3_jaina2_click");
         Facade.mainPanel.mouseChildren = false;
         assignStep(new SelectUnitStep(this.townHall,1,true,new Point(30,50)),this.stepTownHallUpgrade);
      }
      
      private function stepTownHallUpgrade() : void
      {
         Facade.changeUserStage("home3_th_click");
         Facade.mainPanel.mouseChildren = true;
         Facade.addListener(CommonEvent.SHOW_DIALOG,this.onShowFDialog);
         assignStep(new BlackoutClickStep(MyMediator.updateBt,180,{
            "hCenter":0,
            "bottom":0
         }));
      }
      
      private function onShowFDialog(param1:CommonEvent) : void
      {
         var _loc2_:FeatureDialog = param1.data as FeatureDialog;
         if(_loc2_)
         {
            Facade.changeUserStage("home3_th_up_click");
            Facade.removeListener(CommonEvent.SHOW_DIALOG,this.onShowFDialog);
            assignStep(new BlackoutClickStep(_loc2_.priceButton,0,{
               "hCenter":0,
               "top":0
            }),this.onUpgrade);
         }
      }
      
      private function onUpgrade() : void
      {
         Facade.changeUserStage("home3_th_up_start_click");
         assignStep(new BlackoutClickStep(MyMediator.speedupBt,180,{
            "hCenter":0,
            "bottom":0
         }));
      }
      
      override public function dispose() : void
      {
         Facade.removeListener(CommonEvent.SHOW_DIALOG,this.onShowFDialog);
         super.dispose();
      }
   }
}

