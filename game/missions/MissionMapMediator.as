package game.missions
{
   import engine.signal.Signal;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.common.DialogMediator;
   import logic.MainLogic;
   import proto.BinaryBuffer;
   import proto.game.family_0010.PFightKind;
   import proto.game.family_0010.Packet_0010_0B;
   import proto.game.family_0010.Packet_0010_0C;
   import proto.model.PCost;
   import proto.model.PExtMission;
   import proto.model.PMissionInfo;
   import proto.model.PMissionPercentage;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   import utils.CostHelper;
   
   public class MissionMapMediator extends DialogMediator
   {
      
      public var dialog:MissionMapDialog;
      
      private var winMission:String;
      
      private var aKind:String;
      
      private var aEx:Boolean;
      
      public function MissionMapMediator()
      {
         super();
         this.winMission = Facade.commonHash[Facade.battleMediator] as String;
         if(this.winMission)
         {
            delete Facade.commonHash[Facade.battleMediator];
         }
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog = new MissionMapDialog();
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         this.dialog.addListener(VEvent.EXTERNAL_COMPLETE,this.onCompleteMap);
         this.dialog.addListener(VEvent.CHANGE,this.syncExTime);
         if(!up.missionPercentageList)
         {
            this.dialog.showMessage();
            Facade.protoProxy.request(new Packet_0010_0B(),this.resultPercentage);
         }
         else
         {
            this.loadMap();
         }
         Facade.myMediator.myPanel.cacheAsBitmap = true;
         return this.dialog;
      }
      
      override public function onRemove() : void
      {
         var _loc1_:Point = getDialogSetting() as Point;
         if(!_loc1_)
         {
            _loc1_ = new Point();
            setDialogSetting(_loc1_);
         }
         this.dialog.getMovePoint(_loc1_);
         Facade.myMediator.myPanel.cacheAsBitmap = false;
      }
      
      private function resultPercentage(param1:BinaryBuffer) : void
      {
         up.missionPercentageList = new Packet_0010_0C(param1).value;
         this.loadMap();
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc4_:PMissionPercentage = null;
         this.aKind = param1.data;
         var _loc2_:String = "ms_mission" + this.aKind;
         this.aEx = param1.variance == 0;
         var _loc3_:PMissionInfo = mp.getMissionInfo(this.aEx ? up.getMissionExKind(_loc2_) : _loc2_);
         if(!_loc3_)
         {
            throw new Error("no mission info" + _loc2_);
         }
         if(this.aEx)
         {
            _loc2_ += "_ex";
         }
         for each(_loc4_ in up.missionPercentageList)
         {
            if(_loc4_.mp_mission_kind == _loc2_)
            {
               break;
            }
         }
         if(Boolean(_loc4_) && _loc4_.mp_mission_kind != _loc2_)
         {
            _loc4_ = null;
         }
         if(!this.dialog.cellarPanel)
         {
            this.dialog.addCellar(this.onBattle);
            this.dialog.cellarPanel.capacityCur = up.soldierCapacityCur;
            this.dialog.cellarPanel.capacityMax = up.soldierCapacityMax;
         }
         this.dialog.checkOverlapCellar(this.aKind,this.aEx);
         this.dialog.cellarPanel.setData(_loc2_,uint(this.aKind),this.aEx,_loc3_,_loc4_);
      }
      
      private function onBattle(param1:MouseEvent) : void
      {
         MainLogic.getRivalMap(PFightKind.create(this.aEx ? PFightKind.EXT_MISSION : PFightKind.MISSION,"ms_mission" + this.aKind));
      }
      
      private function loadMap() : void
      {
         this.dialog.loadMap(1,["",1,190,910,"",2,225,1035,"",3,350,1055,"",4,500,1020,"",5,610,920,"",6,770,880,"",7,935,980,"un_warrior_mithril1",8,995,820,"",9,895,705,"",10,720,680,"",11,560,730,"",12,375,785,"",13,210,780,"",14,80,710,"",15,60,580,"",16,170,435,"",17,330,350,"",18,520,350,"un_troll_mithril1",19,560,495,"",20,770,420,"",21,930,520,"",22,1015,360,"",23,900,230,"",24,745,175,"",25,595,140,"",26,430,100,"un_healer_mithril1",27,255,50],["1","2",-35,-140,"2","3",-92,-28,"3","4",-132,28,"4","5",-102,88,"5","6",-126,80,"6","7",-162,-107,"7","8",-64,150,"8","9",122,122,"9","10",202,21,"10","11",190,-61,"11","12",205,-65,"12","13",192,5,"13","14",152,76,"14","15",33,146,"15","16",-108,162,"16","17",-146,80,"17","18",-189,-1,"18","19",-26,-166,"19","20",-212,70,"20","21",-136,-92,"21","22",-95,154,"22","23",126,136,"23","24",194,56,"24","25",156,40,"25","26",162,28,"26","27",182,42,"27","28",38,92],["4",690,1030,"15",255,560,"22",1115,230]);
      }
      
      private function syncExTime(param1:VEvent = null) : void
      {
         var _loc3_:PExtMission = null;
         var _loc4_:String = null;
         var _loc5_:ExtMissionStatus = null;
         var _loc6_:Array = null;
         var _loc7_:Point = null;
         var _loc2_:Object = {};
         for each(_loc3_ in up.extMissionList)
         {
            _loc4_ = _loc3_.em_kind;
            _loc5_ = new ExtMissionStatus();
            _loc6_ = Facade.manualProxy.getMissionInfo(Facade.userProxy.getMissionExKind(_loc4_)).mi_resources;
            _loc5_.resourceStatus = CostHelper.getValueFromList(_loc6_,PCost.CRYSTAL) > 0 ? (CostHelper.getValueFromList(_loc6_,PCost.OIL) > 0 ? ExtMissionStatus.BOTH : ExtMissionStatus.CRYSTAL) : ExtMissionStatus.OIL;
            _loc5_.missionTime = _loc3_.em_last_time + Facade.manualProxy.getMissionInfo(_loc4_).mi_cooldown;
            _loc2_[_loc4_] = _loc5_;
         }
         this.dialog.exMissionStatus = _loc2_;
         if(!param1)
         {
            _loc7_ = getDialogSetting() as Point;
            if(_loc7_)
            {
               this.dialog.sync(false);
               this.dialog.move(_loc7_.x,_loc7_.y,false);
               return;
            }
         }
         this.dialog.sync(!param1);
      }
      
      private function onCompleteMap(param1:VEvent) : void
      {
         var _loc3_:int = 0;
         this.dialog.winList = up.winMissionList;
         this.dialog.missionList = mp.missionList;
         var _loc2_:Boolean = Boolean(this.winMission);
         if(_loc2_)
         {
            _loc3_ = this.dialog.winList.indexOf(this.winMission);
            if(_loc3_ >= 0)
            {
               this.dialog.winList.splice(_loc3_,1);
            }
         }
         this.dialog.exMissionList = up.extMissionList;
         this.syncExTime();
         if(_loc2_)
         {
            this.dialog.setBtLayerLock(true);
            Signal.delayWeakCall(1.5,this.onWinMission);
         }
      }
      
      private function onWinMission() : void
      {
         this.dialog.setBtLayerLock(false);
         this.dialog.addWinIndex(this.winMission.substr(MissionMapDialog.MISSION_PREFIX.length));
         this.winMission = null;
      }
   }
}

