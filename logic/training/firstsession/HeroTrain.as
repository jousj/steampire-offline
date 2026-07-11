package logic.training.firstsession
{
   import engine.units.Build;
   import game.feature.FeatureDialog;
   import game.feature.FeatureRenderer;
   import game.my.MyMediator;
   import logic.training.AbstractTrain;
   import logic.training.BlackoutClickStep;
   import logic.training.BlackoutPanel;
   import logic.training.NewStoryStep;
   import proto.model.PBtype;
   import ui.MainPanel;
   import ui.game.ResourcePanel;
   import ui.vbase.VComponent;
   
   public class HeroTrain extends AbstractTrain
   {
      
      public const blackout:BlackoutPanel = new BlackoutPanel();
      
      public const steamHouse:Build = Facade.userProxy.getBuild(PBtype.HERO,true);
      
      public var dialog:FeatureDialog;
      
      private const mp:MainPanel = Facade.mainPanel;
      
      public function HeroTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         Facade.changeUserStage("home4_dwarf1");
         assignStep(new NewStoryStep("un_dwarf1",Lang.getString("dwarf_reward_1")).useMultipleSay(),this.nextDwarfPhrase);
      }
      
      private function nextDwarfPhrase() : void
      {
         Facade.changeUserStage("home4_dwarf1_click");
         assignStep(new NewStoryStep("un_dwarf1",Lang.getString("dwarf_reward_2")),this.focusSteamHouse);
      }
      
      private function focusSteamHouse() : void
      {
         Facade.changeUserStage("home4_dwarf2_click");
         Facade.boardMediator.smoothMoveBoard(this.steamHouse.c_x,this.steamHouse.c_y);
         boardLock = true;
         Facade.mainPanel.mouseChildren = Facade.board.mouseChildren = false;
         wait(1,this.selectSteamHouse);
      }
      
      private function selectSteamHouse() : void
      {
         Facade.changeUserStage("home4_workshop_arrow");
         boardLock = false;
         Facade.mainPanel.mouseChildren = Facade.board.mouseChildren = true;
         Facade.boardMediator.setSelected(this.steamHouse);
         assignStep(new BlackoutClickStep(MyMediator.common3Bt,0,{"hCenter":-5}),this.onSteamSelect);
      }
      
      private function onSteamSelect() : void
      {
         Facade.changeUserStage("home4_workshop_click");
         Facade.userProxy.setCrystal(200,true,false);
         Facade.userProxy.setGlory(30,false);
         this.dialog = Facade.mainMediator.searchDialog(FeatureDialog);
         this.dialog.mouseChildren = false;
         var _loc1_:ResourcePanel = this.dialog.resPanel;
         _loc1_.cur = 0;
         _loc1_.setData(30);
         this.addBlackout(_loc1_);
         wait(2,this.stopHintStep);
      }
      
      private function stopHintStep() : void
      {
         this.blackout.removeFromParent();
         if(Facade.checkUserStage("home4_increase_hp_click"))
         {
            this.steamPhrase();
         }
         else
         {
            wait(1,this.checkStamina);
         }
      }
      
      private function addBlackout(param1:VComponent) : void
      {
         this.mp.dialogPanel.addStretch(this.blackout);
         this.blackout.track(param1);
      }
      
      private function checkStamina() : void
      {
         var _loc1_:FeatureRenderer = null;
         this.dialog.mouseChildren = true;
         for each(_loc1_ in this.dialog.grid.renderList)
         {
            if(_loc1_.kind == "stamina")
            {
               assignStep(new BlackoutClickStep(_loc1_.updateBt,0,{"hCenter":0}),this.steamPhrase);
               return;
            }
         }
      }
      
      private function steamPhrase() : void
      {
         Facade.changeUserStage("home4_increase_hp_click");
         assignStep(new NewStoryStep("un_hero1",Lang.getString("hero1_upgrade"),true,null,"_1").useUpperLayer(),this.finish);
      }
      
      private function finish() : void
      {
         Facade.changeUserStage("home4_hero_click");
         clear();
      }
      
      override public function dispose() : void
      {
         this.blackout.removeFromParent();
         boardLock = false;
         Facade.mainPanel.mouseChildren = Facade.board.mouseChildren = true;
         super.dispose();
      }
   }
}

