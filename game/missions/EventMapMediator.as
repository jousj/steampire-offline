package game.missions
{
   import flash.events.MouseEvent;
   import game.common.DialogMediator;
   import logic.CoreLogic;
   import logic.MainLogic;
   import logic.ShopLogic;
   import proto.game.family_0010.PFightKind;
   import proto.model.PCost;
   import proto.model.PFightType;
   import proto.model.PJainaEvent;
   import proto.model.PJainaEventInfo;
   import proto.model.PJainaMissionInfo;
   import proto.model.PMissionInfo;
   import proto.model.PShopBuilding;
   import proto.model.PShopUnit;
   import ui.common.BaseDialog;
   import ui.vbase.AssetLoader;
   import ui.vbase.SkinManager;
   import ui.vbase.VEvent;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class EventMapMediator extends DialogMediator
   {
      
      public var dialog:EventMapDialog;
      
      private var jainaEventInfo:PJainaEventInfo;
      
      private var jainaEventData:PJainaEvent;
      
      private var missionInfo:PMissionInfo;
      
      private var price:PCost;
      
      private var isAdventure:Boolean;
      
      private var rewardVariance:uint = 1;
      
      private var rewardValue:int;
      
      public function EventMapMediator(param1:Array)
      {
         super();
         this.jainaEventInfo = param1[1];
         this.jainaEventData = param1[2];
         this.isAdventure = Boolean(up.currentAdventure);
      }
      
      private static function checkMapBg(param1:String) : Boolean
      {
         if(!Facade.board.bgHash.hasOwnProperty(param1))
         {
            Facade.board.bgHash[param1] = AssetLoader.load(SkinManager.url + "images/" + param1 + ".jpg",false,onMapBgFinish);
            return false;
         }
         return true;
      }
      
      private static function onMapBgFinish(param1:AssetLoader) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:PJainaMissionInfo = null;
         var _loc2_:Object = Facade.board.bgHash;
         for(_loc3_ in _loc2_)
         {
            if(_loc2_[_loc3_] == param1)
            {
               break;
            }
         }
         if(param1.isError)
         {
            _loc2_[_loc3_] = null;
         }
         else
         {
            Facade.board.initBg(_loc2_[_loc3_] = param1.loader);
         }
         if(Facade.isBattle && Facade.battleMediator.checkFightType(PFightType.JAINA_MISSION))
         {
            _loc4_ = String(Facade.battleMediator.targetInfo.ti_fight_type.value);
            for each(_loc5_ in Facade.manualProxy.jainaMissionList)
            {
               if(_loc5_.jmi_mission == _loc4_)
               {
                  applyBg(_loc5_.jmi_event_id,_loc3_);
                  break;
               }
            }
         }
         else if(Facade.isBattle && Facade.battleMediator.checkFightType(PFightType.STORM))
         {
            Facade.board.changeMapBg(_loc3_);
         }
      }
      
      public static function applyBg(param1:int, param2:String = null) : void
      {
         var _loc3_:PJainaEventInfo = null;
         for each(_loc3_ in Facade.manualProxy.jainaEventList)
         {
            if(_loc3_.jei_id == param1)
            {
               if(!param2 || _loc3_.jei_bg_kind == param2)
               {
                  setBg(_loc3_.jei_bg_kind);
               }
               break;
            }
         }
      }
      
      public static function setBg(param1:String) : void
      {
         if(checkMapBg(param1))
         {
            Facade.board.changeMapBg(param1);
         }
      }
      
      override public function onAdd() : BaseDialog
      {
         var _loc1_:PJainaMissionInfo = null;
         this.dialog = new EventMapDialog(this.isAdventure ? Lang.getString("adventure" + this.jainaEventInfo.jei_id) + " " + StringHelper.getRomanFromArab(up.getAdventureLevel(this.jainaEventInfo.jei_id)) : Lang.getString("adventure"));
         for each(_loc1_ in mp.jainaMissionList)
         {
            if(_loc1_.jmi_event_id == this.jainaEventInfo.jei_id)
            {
               this.dialog.missionList.push(_loc1_);
            }
         }
         if(this.jainaEventData)
         {
            this.dialog.activeIndex = this.jainaEventData.je_mission - 1;
            if(this.jainaEventData.je_mission_finished)
            {
               ++this.dialog.activeIndex;
            }
         }
         this.price = Facade.references.jaina_mission_start_cost;
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         this.dialog.addListener(VEvent.EXTERNAL_COMPLETE,this.onCompleteMap);
         this.dialog.init(this.jainaEventInfo.jei_id == 3 ? "MMapOnyx" : "MMapDragon",[268,931,290,779,251,675,415,762,524,898,666,935,706,831,843,847,875,958,955,885,1072,755,930,676,1110,503,770,525,758,658,596,607,438,551,237,573,466,412,470,320,235,250,417,132,696,369,974,357,836,170]);
         return this.dialog;
      }
      
      private function onVariance(param1:VEvent, param2:PJainaMissionInfo = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         if(param1)
         {
            param2 = param1.data;
         }
         if(!param2)
         {
            return;
         }
         this.missionInfo = mp.getMissionInfo(param2.jmi_mission);
         this.rewardValue = 0;
         if(this.isAdventure)
         {
            _loc3_ = mp.getAdventureReward(param2.jmi_mission,up.getAdventureLevel(this.jainaEventInfo.jei_id));
            if(_loc3_)
            {
               this.rewardVariance = _loc3_[0].variance;
               this.rewardValue = _loc3_[0].value;
            }
         }
         else if(this.missionInfo.mi_jglory > 0)
         {
            this.rewardVariance = PCost.J_GLORY;
            this.rewardValue = this.missionInfo.mi_jglory;
         }
         else if(this.missionInfo.mi_rar_dragon > 0)
         {
            this.rewardVariance = PCost.RAR_DRAGON;
            this.rewardValue = this.missionInfo.mi_rar_dragon;
         }
         else if(this.missionInfo.mi_mithril > 0)
         {
            this.rewardVariance = PCost.MITHRIL;
            this.rewardValue = this.missionInfo.mi_mithril;
         }
         if(!this.dialog.cellarPanel)
         {
            this.dialog.addCellar(this.onBattle,this.price,this.rewardVariance);
            this.dialog.cellarPanel.capacityCur = up.soldierCapacityCur;
            this.dialog.cellarPanel.capacityMax = up.soldierCapacityMax;
         }
         this.dialog.checkOverlapCellar(param2.jmi_number);
         if(this.jainaEventData)
         {
            _loc4_ = (this.missionInfo.mi_init_obj_cnt - this.jainaEventData.je_alive_objs) / this.missionInfo.mi_init_obj_cnt * 100;
            this.rewardValue = this.jainaEventData.je_alive_objs * int(this.rewardValue / this.missionInfo.mi_init_obj_cnt);
         }
         this.dialog.cellarPanel.setData(param2.jmi_mission,param2.jmi_number,_loc4_,this.rewardValue,this.missionInfo.mi_average_hspace);
      }
      
      private function onBattle(param1:MouseEvent = null) : void
      {
         var _loc2_:int = 0;
         if(up.isCost(this.price))
         {
            if(Boolean(param1) && Boolean(this.rewardVariance == PCost.MITHRIL) && this.rewardValue > 0)
            {
               _loc2_ = up.mithril + this.rewardValue - Facade.references.mithril_limit;
               if(_loc2_ > 0)
               {
                  Facade.mainMediator.showYesNoDialog(Lang.getPatternString("desc_onyx_capacity","__VALUE__",CostHelper.get18String(this.rewardVariance,_loc2_,true)),this.onBattle,null,Lang.getString("title_onyx_capacity"));
                  return;
               }
            }
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
         var _loc5_:PShopUnit = null;
         this.dialog.showTime((this.isAdventure ? up.currentAdventure.start_time + Facade.references.adventure_duration : this.jainaEventInfo.jei_date_finish) - CoreLogic.serverTime,this.jainaEventInfo.jei_id,this.isAdventure);
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
               _loc5_ = mp.getJainaUnit(_loc3_.jmi_mission);
               this.dialog.showNew(Boolean(_loc4_) && !ShopLogic.checkRequierementList(_loc4_.sb_requirements) ? _loc4_.sb_kind : null,Boolean(_loc5_) && !ShopLogic.checkRequierement(_loc5_.su_event_requirement) ? _loc5_.su_kind : null);
               this.onVariance(null,_loc3_);
               break;
            }
         }
         this.dialog.sync(this.isAdventure ? this.jainaEventInfo.jei_id : 0);
         checkMapBg(this.jainaEventInfo.jei_bg_kind);
      }
   }
}

