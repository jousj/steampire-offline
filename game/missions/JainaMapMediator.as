package game.missions
{
   import flash.events.MouseEvent;
   import game.common.DialogMediator;
   import logic.CoreLogic;
   import logic.MainLogic;
   import logic.ShopLogic;
   import proto.game.family_0010.PFightKind;
   import proto.model.PCost;
   import proto.model.PJainaEvent;
   import proto.model.PJainaEventInfo;
   import proto.model.PJainaMissionInfo;
   import proto.model.PMissionInfo;
   import proto.model.PShopBuilding;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   import utils.StringHelper;
   
   public class JainaMapMediator extends DialogMediator
   {
      
      public var dialog:JainaMapDialog;
      
      private var jainaEventInfo:PJainaEventInfo;
      
      private var jainaEventData:PJainaEvent;
      
      private var missionInfo:PMissionInfo;
      
      private var price:PCost;
      
      private var isAdventure:Boolean;
      
      public function JainaMapMediator(param1:Array)
      {
         super();
         this.jainaEventInfo = param1[1];
         this.jainaEventData = param1[2];
         this.isAdventure = Boolean(up.currentAdventure);
      }
      
      override public function onAdd() : BaseDialog
      {
         var _loc1_:PJainaMissionInfo = null;
         var _loc2_:* = 0;
         this.dialog = new JainaMapDialog(this.isAdventure ? Lang.getString("adventure" + this.jainaEventInfo.jei_id) + " " + StringHelper.getRomanFromArab(up.getAdventureLevel(this.jainaEventInfo.jei_id)) : Lang.getString("adventure"));
         for each(_loc1_ in mp.jainaMissionList)
         {
            if(_loc1_.jmi_event_id == this.jainaEventInfo.jei_id)
            {
               this.dialog.missionList.push(_loc1_);
            }
         }
         if(this.jainaEventData)
         {
            _loc2_ = this.jainaEventData.je_mission;
            if(!this.jainaEventData.je_mission_finished)
            {
               _loc2_--;
            }
            while(_loc2_ > 0)
            {
               this.dialog.winList.push(_loc2_.toString());
               _loc2_--;
            }
         }
         this.price = Facade.references.jaina_mission_start_cost;
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         this.dialog.addListener(VEvent.EXTERNAL_COMPLETE,this.onCompleteMap);
         this.dialog.loadMap([240,955,465,846,327,693,310,534,212,362,440,295,292,124,643,89,797,193,1043,327,781,433,620,633,906,692,722,927,1025,847],new <String>["1","2","2","3","3","4","4","5","5","6","6","7","7","8","8","9","9","10","10","11","11","12","12","13","13","14","14","15"]);
         return this.dialog;
      }
      
      private function onVariance(param1:VEvent, param2:PJainaMissionInfo = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         if(param1)
         {
            param2 = param1.data;
         }
         if(!param2)
         {
            return;
         }
         this.missionInfo = mp.getMissionInfo(param2.jmi_mission);
         if(!this.dialog.cellarPanel)
         {
            this.dialog.addCellar(this.onBattle,this.price);
            this.dialog.cellarPanel.capacityCur = up.soldierCapacityCur;
            this.dialog.cellarPanel.capacityMax = up.soldierCapacityMax;
         }
         this.dialog.checkOverlapCellar(param2.jmi_number.toString());
         if(this.isAdventure)
         {
            _loc3_ = mp.getAdventureReward(param2.jmi_mission,up.getAdventureLevel(this.jainaEventInfo.jei_id));
            if(_loc3_)
            {
               _loc4_ = int(_loc3_[0].value);
            }
         }
         else
         {
            _loc4_ = this.missionInfo.mi_jglory;
         }
         if(this.jainaEventData)
         {
            _loc5_ = (this.missionInfo.mi_init_obj_cnt - this.jainaEventData.je_alive_objs) / this.missionInfo.mi_init_obj_cnt * 100;
            _loc4_ = this.jainaEventData.je_alive_objs * int(_loc4_ / this.missionInfo.mi_init_obj_cnt);
         }
         else
         {
            _loc5_ = 0;
         }
         this.dialog.cellarPanel.setData(param2.jmi_mission,param2.jmi_number,_loc5_,_loc4_,this.missionInfo.mi_average_hspace);
      }
      
      private function onBattle(param1:MouseEvent) : void
      {
         if(up.isCost(this.price))
         {
            MainLogic.getRivalMap(PFightKind.create(this.isAdventure ? PFightKind.ADVENTURE : PFightKind.JAINA_MISSION,this.missionInfo.mi_kind));
         }
         else
         {
            Facade.myMediator.onAlinkEnergy();
         }
      }
      
      private function onCompleteMap(param1:VEvent) : void
      {
         var _loc3_:PJainaMissionInfo = null;
         var _loc4_:PShopBuilding = null;
         this.dialog.showTime((this.isAdventure ? up.currentAdventure.start_time + Facade.references.adventure_duration : this.jainaEventInfo.jei_date_finish) - CoreLogic.serverTime,this.isAdventure);
         var _loc2_:int = 0;
         if(this.jainaEventData)
         {
            _loc2_ = this.jainaEventData.je_mission;
            if(this.jainaEventData.je_mission_finished)
            {
               _loc2_++;
            }
         }
         else
         {
            _loc2_ = 1;
         }
         for each(_loc3_ in this.dialog.missionList)
         {
            if(_loc3_.jmi_number == _loc2_)
            {
               _loc4_ = mp.getJainaBuild(_loc3_.jmi_mission);
               this.dialog.showNewBuild(Boolean(_loc4_) && !ShopLogic.checkRequierementList(_loc4_.sb_requirements) ? _loc4_.sb_kind : null);
               this.onVariance(null,_loc3_);
               break;
            }
         }
         this.dialog.sync(true,this.isAdventure ? this.jainaEventInfo.jei_id : 0);
      }
   }
}

