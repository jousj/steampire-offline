package logic.quests
{
   import game.missions.MissionButton;
   import game.missions.MissionMapDialog;
   import game.my.GoDialog;
   import logic.CoreLogic;
   import logic.training.AbstractTrain;
   import logic.training.DownStep;
   import model.CommonEvent;
   import proto.model.PExtMission;
   import ui.vbase.VEvent;
   import utils.StringHelper;
   
   public class MissionHelpTrain extends AbstractTrain
   {
      
      private var data:Object;
      
      public function MissionHelpTrain(param1:Object)
      {
         super();
         this.data = param1;
      }
      
      override public function run() : void
      {
         Facade.addListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         assignStep(new DownStep(Facade.myMediator.myPanel.goBt,-40,{
            "left":5,
            "top":5
         }));
      }
      
      private function onShowDialog(param1:CommonEvent) : void
      {
         if(param1.data is GoDialog)
         {
            assignStep(new DownStep((param1.data as GoDialog).missionBt,0,{"hCenter":0}));
         }
         else if(param1.data is MissionMapDialog)
         {
            Facade.removeListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
            (param1.data as MissionMapDialog).addLoadListener(this.onMissionMapLoaded);
            (param1.data as MissionMapDialog).addListener(VEvent.CLOSE_DIALOG,this.onClose);
         }
         else
         {
            this.dispose();
         }
      }
      
      private function onClose(param1:VEvent) : void
      {
         this.dispose();
      }
      
      override public function dispose() : void
      {
         Facade.removeListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         super.dispose();
      }
      
      private function onMissionMapLoaded(param1:VEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc5_:PExtMission = null;
         var _loc6_:MissionButton = null;
         var _loc4_:MissionMapDialog = param1.data as MissionMapDialog;
         if(this.data is Array)
         {
            _loc3_ = this.data[0] as String;
            for each(_loc5_ in _loc4_.exMissionList)
            {
               if(_loc5_.em_kind == _loc3_)
               {
                  Facade.mainMediator.showMessage(Lang.getPatternString("no_ext_mission","__NUM__",StringHelper.getTimeDesc(_loc5_.em_last_time - CoreLogic.serverTime,true)));
                  return;
               }
            }
            if(!_loc2_)
            {
               return;
            }
         }
         else
         {
            _loc3_ = this.data as String;
            if(!_loc3_ && _loc4_.missionList.length > 0)
            {
               _loc3_ = _loc4_.missionList[0].em_kind;
            }
         }
         if(_loc3_)
         {
            _loc3_ = _loc3_.substr(MissionMapDialog.MISSION_PREFIX.length);
            _loc6_ = _loc4_.getButton(_loc3_,_loc2_);
            if(_loc6_)
            {
               _loc4_.scroll(_loc3_);
               assignStep(new DownStep(_loc6_,0,{
                  "hCenter":0,
                  "top":4
               }));
            }
         }
      }
   }
}

