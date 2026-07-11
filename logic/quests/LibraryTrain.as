package logic.quests
{
   import engine.units.Build;
   import game.library.LibraryDialog;
   import game.library.SpellBuyRenderer;
   import game.missions.MissionButton;
   import game.missions.MissionMapDialog;
   import game.my.GoDialog;
   import game.my.MyMediator;
   import game.quest.QuestOneDialog;
   import logic.MainLogic;
   import logic.training.BlackoutClickStep;
   import logic.training.ClickStep;
   import logic.training.DownStep;
   import model.CommonEvent;
   import proto.model.PBtype;
   import ui.vbase.VButton;
   import ui.vbase.VEvent;
   
   public class LibraryTrain extends QuestTrain
   {
      
      private var isShowListener:Boolean;
      
      public function LibraryTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc1_:Build = null;
         if(item.isComplete)
         {
            clearStep();
            Facade.questMediator.questBtPanel.removeStatus(item.kind);
            Facade.questMediator.questBtPanel.useCollectStatus(item.kind);
            if(!this.isShowListener)
            {
               this.isShowListener = true;
               Facade.addListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
            }
         }
         else if(Facade.userProxy.spellList.length == 0)
         {
            _loc1_ = Facade.userProxy.getBuild(PBtype.LIBRARY,false);
            if(_loc1_)
            {
               Facade.boardMediator.setSelected(_loc1_);
               Facade.boardMediator.moveBoard(_loc1_.t_x,_loc1_.t_y);
               assignStep(new BlackoutClickStep(MyMediator.commonBt,180,{
                  "hCenter":0,
                  "bottom":0
               }),this.onLibraryOpen);
            }
         }
         else if(Facade.userProxy.soldierCapacityCur / Facade.userProxy.soldierCapacityMax >= Facade.references.raid_units_min_perc / 100)
         {
            assignStep(new BlackoutClickStep(Facade.myMediator.myPanel.goBt,315,{
               "hCenter":-20,
               "vCenter":-20
            }),this.onGoOpen);
         }
      }
      
      private function onLibraryOpen() : void
      {
         var _loc1_:LibraryDialog = Facade.mainMediator.searchDialog(LibraryDialog);
         if(!_loc1_)
         {
            return;
         }
         Facade.changeUserStage("buildLibraryLvl1_library_click");
         var _loc2_:VButton = (_loc1_.buyGrid.renderList[0] as SpellBuyRenderer).buyBt;
         if(Boolean(_loc2_) && !_loc2_.disabled)
         {
            assignStep(new BlackoutClickStep(_loc2_,0,{"hCenter":0}),this.onSpellSelect);
         }
      }
      
      private function onSpellSelect() : void
      {
         var _loc1_:LibraryDialog = Facade.mainMediator.searchDialog(LibraryDialog);
         if(_loc1_)
         {
            Facade.changeUserStage("buildLibraryLvl1_add_spell");
            assignStep(new ClickStep(_loc1_.closeBt,225,{
               "left":0,
               "bottom":0
            }),this.onLibraryClose);
         }
      }
      
      private function onLibraryClose() : void
      {
         Facade.changeUserStage("buildLibraryLvl1_library_close");
         this.run();
      }
      
      private function onGoOpen() : void
      {
         var _loc1_:GoDialog = Facade.mainMediator.searchDialog(GoDialog);
         if(_loc1_)
         {
            Facade.changeUserStage(item.kind + "_to_fight");
            assignStep(new BlackoutClickStep(_loc1_.missionBt,0,{
               "hCenter":0,
               "top":4
            }),this.onPvESelect);
         }
      }
      
      private function onPvESelect() : void
      {
         var _loc1_:MissionMapDialog = Facade.mainMediator.searchDialog(MissionMapDialog);
         if(_loc1_)
         {
            Facade.changeUserStage(item.kind + "_map");
            _loc1_.closeBt.disabled = true;
            _loc1_.addLoadListener(this.onPvELoad);
         }
      }
      
      private function onPvELoad(param1:VEvent) : void
      {
         var _loc2_:MissionMapDialog = param1.data as MissionMapDialog;
         _loc2_.scroll("3");
         var _loc3_:MissionButton = _loc2_.getButton("3");
         if(_loc3_)
         {
            assignStep(new BlackoutClickStep(_loc3_,0,{
               "hCenter":0,
               "top":4
            }),this.onMission3Select);
         }
      }
      
      private function onMission3Select() : void
      {
         var _loc1_:MissionMapDialog = Facade.mainMediator.searchDialog(MissionMapDialog);
         if(Boolean(_loc1_) && Boolean(_loc1_.cellarPanel))
         {
            Facade.changeUserStage(item.kind + "_choice");
            assignStep(new BlackoutClickStep(_loc1_.cellarPanel.battleBt,0,{
               "hCenter":0,
               "top":4
            },null,false),this.onBattleStart);
         }
      }
      
      private function onBattleStart() : void
      {
         Facade.changeUserStage(item.kind + "_start");
         MainLogic.getFriendMap("ms_mission3",true,false,3);
      }
      
      private function onShowDialog(param1:CommonEvent) : void
      {
         var _loc2_:QuestOneDialog = param1.data as QuestOneDialog;
         if(_loc2_)
         {
            Facade.changeUserStage(item.kind + "_quest_dialog");
            if(_loc2_.renderer.rewardBt)
            {
               assignStep(new DownStep(_loc2_.renderer.rewardBt,270,{
                  "vCenter":0,
                  "left":-4
               }));
            }
         }
      }
      
      override public function dispose() : void
      {
         Facade.removeListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         super.dispose();
      }
   }
}

