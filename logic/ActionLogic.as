package logic
{
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Fence;
   import engine.units.Garbage;
   import engine.units.Soldier;
   import engine.units.Unit;
   import flash.events.MouseEvent;
   import game.capital.CapitalMediator;
   import game.clan.center.TopClansMediator;
   import game.political.TerritoryDialog;
   import logic.units.BuildLogic;
   import logic.units.CannonLogic;
   import logic.units.FenceLogic;
   import model.CommonEvent;
   import model.ManualProxy;
   import model.UserProxy;
   import model.vo.MapAction;
   import model.vo.VOResourceSpec;
   import model.vo.VOShieldSpec;
   import model.vo.VOStorageSpec;
   import proto.BinaryBuffer;
   import proto.game.family_0010.POkUserAction;
   import proto.game.family_0010.PUaPacket;
   import proto.game.family_0010.PUserAction;
   import proto.game.family_0010.Packet_0010_01;
   import proto.game.family_0010.Packet_0010_02;
   import proto.game.family_0060.Packet_0060_1B;
   import proto.game.family_0060.Packet_0060_42;
   import proto.model.PAction;
   import proto.model.PBtype;
   import proto.model.PClanAction;
   import proto.model.PCost;
   import proto.model.PHero;
   import proto.model.PHeroUpgradeKind;
   import proto.model.POffer;
   import proto.model.PResearch;
   import proto.model.PShopHero;
   import proto.model.PShopOffer;
   import proto.model.PShopUnit;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.vbase.SkinManager;
   import utils.CommonUtils;
   import utils.CostHelper;
   
   public class ActionLogic
   {
      
      public static const FINISH_CONSTRUCTION:uint = 1;
      
      public static const FINISH_RESEARCH:uint = 2;
      
      public static const RECOVERY_HERO:uint = 3;
      
      public static const RECOVERY_ENERGY:uint = 4;
      
      public static const CLEANUP_GARBAGE:uint = 5;
      
      public static const STATUS_RESOURCE:uint = 6;
      
      public static const RECOVERY_REQUEST_ENERGY:uint = 7;
      
      public static const FINISH_OFFER:uint = 8;
      
      public static const FINISH_SHIELD:uint = 9;
      
      public static const END_SEASON:uint = 10;
      
      public static const START_TERRITORY_WAR:uint = 11;
      
      public static var isWaitSeasonResult:Boolean = false;
      
      public static var isGetSeasonResult:Boolean = false;
      
      public function ActionLogic()
      {
         super();
      }
      
      public static function request(param1:uint, param2:*, param3:Boolean = true) : void
      {
         if(Facade.isCapital)
         {
            Facade.protoProxy.request(new Packet_0060_1B([createClanAction(param1,param2)]),resultRequest,16,2);
         }
         else
         {
            Facade.protoProxy.request(new Packet_0010_01([PUaPacket.create(CoreLogic.serverTime,PUserAction.create(param1,param2))],param3),resultRequest,16,2,[param1],CommonUtils.getConstantName(PUserAction,param1));
         }
      }
      
      private static function createClanAction(param1:uint, param2:*) : PClanAction
      {
         switch(param1)
         {
            case PUserAction.COLLECT_RESOURCE:
               param1 = PClanAction.COLLECT_RESOURCE;
               break;
            case PUserAction.REMOVE_GARBAGE:
               param1 = PClanAction.REMOVE_GARBAGE;
               break;
            case PUserAction.UPGRADE:
               param1 = PClanAction.UPGRADE;
               break;
            case PUserAction.MOVE:
               param1 = PClanAction.MOVE;
               param2 = [param2];
               break;
            case PUserAction.SPEED_UP_GARBAGE:
               param1 = PClanAction.SPEED_UP_GARBAGE;
               break;
            case PUserAction.SPEED_UP_BUILDING:
               param1 = PClanAction.SPEED_UP_BUILDING;
               break;
            case PUserAction.SPEED_UP_CANNON:
               param1 = PClanAction.SPEED_UP_CANNON;
               break;
            case PUserAction.BUY_OBJECT:
               param1 = PClanAction.BUY_OBJECT;
               break;
            case PUserAction.START_STUDY:
               param1 = PClanAction.START_STUDY;
               break;
            case PUserAction.SPEED_UP_STUDY:
               param1 = PClanAction.SPEED_UP_STUDY;
               break;
            case PUserAction.BUY_RESOURCE_BY_GOLD:
               param1 = PClanAction.BUY_RESOURCE_BY_GOLD;
               break;
            case PUserAction.BUY_RESOURCES_PACK:
               param1 = PClanAction.BUY_RESOURCES_PACK;
               break;
            case PUserAction.SELL_DECOR:
               param1 = PClanAction.SELL_DECOR;
               break;
            case PUserAction.CANCEL_STUDY:
               param1 = PClanAction.CANCEL_STUDY;
               break;
            case PUserAction.CANCEL_REMOVE_GARBAGE:
               param1 = PClanAction.CANCEL_REMOVE_GARBAGE;
               break;
            case PUserAction.CANCEL_CONSTRUCTING_BUILDING:
               param1 = PClanAction.CANCEL_CONSTRUCTING_BUILDING;
               break;
            case PUserAction.CANCEL_CONSTRUCTING_CANNON:
               param1 = PClanAction.CANCEL_CONSTRUCTING_CANNON;
               break;
            default:
               throw new Error("bad capital action: ",param1);
         }
         return PClanAction.create(param1,param2);
      }
      
      public static function groupRequest(param1:Array) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc2_:uint = param1.length;
         if(_loc2_ == 0)
         {
            return;
         }
         if((_loc2_ & 1) != 0)
         {
            throw new Error("bad count groupRequest arguments");
         }
         var _loc3_:Array = [];
         if(Facade.isCapital)
         {
            _loc5_ = true;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               if(param1[_loc4_] !== PUserAction.MOVE)
               {
                  _loc5_ = false;
                  break;
               }
               _loc4_ += 2;
            }
            if(_loc5_)
            {
               _loc4_ = 1;
               while(_loc4_ < _loc2_)
               {
                  _loc3_.push(param1[_loc4_]);
                  _loc4_ += 2;
               }
               _loc3_ = [PClanAction.create(PClanAction.MOVE,_loc3_)];
            }
            else
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  _loc3_.push(createClanAction(param1[_loc4_],param1[_loc4_ + 1]));
                  _loc4_ += 2;
               }
            }
            Facade.protoProxy.request(new Packet_0060_1B(_loc3_),resultRequest,16,2);
         }
         else
         {
            _loc6_ = CoreLogic.serverTime;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_.push(PUaPacket.create(_loc6_,PUserAction.create(param1[_loc4_],param1[_loc4_ + 1])));
               _loc4_ += 2;
            }
            Facade.protoProxy.request(new Packet_0010_01(_loc3_,true),resultRequest,16,2);
         }
      }
      
      private static function resultRequest(param1:BinaryBuffer, param2:int = -1) : void
      {
         var _loc4_:POkUserAction = null;
         var _loc3_:Packet_0010_02 = new Packet_0010_02(param1);
         if(_loc3_.variance == Packet_0010_02.ERROR)
         {
            if(Facade.isCapital)
            {
               CapitalMediator.instance.lock();
            }
            else
            {
               ErrorLogic.show(_loc3_.value,"action",param2 >= 0 ? CommonUtils.getConstantName(PUserAction,param2) : null,false);
            }
         }
         else
         {
            _loc4_ = _loc3_.value;
            CoreLogic.calcDiff(_loc4_.server_time,Facade.protoProxy.requestTime);
            if(_loc4_.events.length > 0)
            {
               EventLogic.run(_loc4_.events);
            }
         }
      }
      
      public static function addFinishConstruction(param1:Object, param2:Number, param3:Number = 0) : void
      {
         var _loc4_:Unit = null;
         var _loc5_:Boolean = false;
         if(param1 is Unit)
         {
            _loc4_ = param1 as Unit;
            Facade.audioProxy.play("start_construction");
         }
         else
         {
            _loc4_ = Facade.userProxy.constructionHash[uint(param1)] as Unit;
            _loc5_ = true;
         }
         if(param3 <= 0)
         {
            param3 = CoreLogic.serverTime + param2;
         }
         UnitFactory.addProgress(_loc4_,param3,param2,!(_loc4_ is Cannon));
         UnitFactory.addWorker(CoreLogic.createAction(finishConstruction,FINISH_CONSTRUCTION,param3,_loc4_.id),_loc5_);
      }
      
      public static function finishConstruction(param1:Object, param2:Boolean = false) : void
      {
         var _loc7_:Build = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:VOStorageSpec = null;
         var _loc11_:Cannon = null;
         var _loc3_:UserProxy = Facade.userProxy;
         var _loc4_:Unit = (param1 is Unit ? param1 : _loc3_.constructionHash[uint(param1)]) as Unit;
         if(!_loc4_)
         {
            throw new Error("finishConstruction: нет юнита id=" + param1);
         }
         var _loc5_:ManualProxy = Facade.manualProxy;
         var _loc6_:uint = 0;
         if(_loc4_ is Build)
         {
            _loc7_ = _loc4_ as Build;
            if(_loc7_.updateLevel == 0)
            {
               throw new Error(_loc7_ + " не улучшается");
            }
            _loc8_ = _loc7_.type;
            if(_loc7_.updateLevel > 1 && !param2)
            {
               if(_loc8_ == PBtype.STORAGE)
               {
                  _loc9_ = (_loc7_.spec as VOStorageSpec).capacityMax;
               }
               _loc7_.assignShop(_loc5_.getBuildShop(_loc7_.kind,_loc7_.updateLevel));
               UnitFactory.assignBuildShop(_loc7_);
            }
            if(!param2 && _loc8_ == PBtype.SHIELD)
            {
               (_loc7_.spec as VOShieldSpec).isRecovery = false;
            }
            _loc7_.setUpdateLevel(0);
            if(_loc8_ == PBtype.RESOURCE)
            {
               (_loc7_.spec as VOResourceSpec).lastTime = CoreLogic.serverTime;
               _loc7_.syncResJob();
            }
            else if(_loc8_ == PBtype.PYLON)
            {
               CannonLogic.checkPylonCannon();
            }
            else if(!param2)
            {
               if(_loc8_ == PBtype.STORAGE)
               {
                  _loc10_ = _loc7_.spec as VOStorageSpec;
                  if(_loc10_.costVariance == PCost.CRYSTAL)
                  {
                     _loc3_.crystalMax += _loc10_.capacityMax - _loc9_;
                  }
                  else if(_loc10_.costVariance == PCost.OIL)
                  {
                     _loc3_.oilMax += _loc10_.capacityMax - _loc9_;
                  }
                  Facade.myMediator.updateStorageMax();
                  BuildLogic.calcStorage();
               }
               else if(_loc8_ == PBtype.CAMP)
               {
                  _loc3_.soldierCapacityMax = _loc5_.getCampShop(_loc7_.level).sca_capacity;
               }
               else if(_loc8_ == PBtype.WORKER)
               {
                  ++_loc3_.workerMax;
                  Facade.myMediator.checkBuyWorker();
               }
               else if(_loc8_ == PBtype.TOWNHALL)
               {
                  BuildLogic.changeTownHallLevel(_loc7_.level,true);
               }
               else if(_loc8_ == PBtype.BARRACK)
               {
                  UnitFactory.buildLogic.upBarrack(_loc7_);
               }
               else if(_loc8_ == PBtype.LIBRARY)
               {
                  UnitFactory.buildLogic.upLibrary(_loc7_);
               }
            }
            if(!param2)
            {
               _loc6_ = _loc7_.shop.sb_upgrade_time;
               Facade.questMediator.changeQuest(PAction.AC_FINISH_BUILDING,1,_loc7_.kind,_loc7_.level);
               Facade.questMediator.changeQuest(PAction.AC_UP_BUILDING,_loc7_.level,_loc7_.kind,0,false,2);
            }
            UnitFactory.buildLogic.syncStatus(_loc7_);
         }
         else if(_loc4_ is Cannon)
         {
            _loc11_ = _loc4_ as Cannon;
            if(_loc11_.updateLevel == 0)
            {
               throw new Error(_loc11_ + " не улучшается");
            }
            if(!param2)
            {
               if(_loc11_.updateLevel > 1)
               {
                  _loc11_.assignShop(_loc5_.getCannonShop(_loc11_.kind,_loc11_.updateLevel));
               }
               _loc6_ = _loc11_.shop.sc_upgrade_time;
               Facade.questMediator.changeQuest(PAction.AC_FINISH_CANNON,1,_loc11_.kind,_loc11_.level);
               Facade.questMediator.changeQuest(PAction.AC_UP_CANNON,_loc11_.level,_loc11_.kind,0,false,2);
            }
            _loc11_.setUpdateLevel(0);
         }
         else
         {
            if(!(_loc4_ is Fence))
            {
               throw new Error("юнит данного типа не может быть улучшен " + _loc4_);
            }
            FenceLogic.finishUpdate(_loc4_ as Fence);
         }
         _loc4_.setProgress(null);
         UnitFactory.removeWorker(_loc4_.id);
         if(_loc6_ > 0)
         {
            _loc3_.setExp(_loc5_.calcExp(_loc6_),true);
         }
         Facade.boardMediator.syncSelected(_loc4_);
         Facade.audioProxy.play("construction_complete");
         if(_loc4_ is Build)
         {
            if(_loc8_ == PBtype.HERO)
            {
               applyHeroUpdate(_loc4_ as Build,param2);
            }
            else if(_loc8_ == PBtype.CLAN)
            {
               syncClanCenterProgress(_loc4_ as Build);
            }
            else if(_loc8_ == PBtype.SHIELD)
            {
               if(param2)
               {
                  addRecoveryShield(_loc7_);
               }
            }
         }
         if(!param2)
         {
            Facade.dispatchCommonEvent(CommonEvent.CONSTRUCTION_UP,_loc4_);
         }
      }
      
      public static function addResearchP(param1:uint, param2:PResearch) : void
      {
         if(param2)
         {
            addResearch(param1,Facade.manualProxy.getResearchSoldierShop(param2.research_unit_kind),param2.research_start_time);
         }
      }
      
      public static function addResearch(param1:uint, param2:PShopUnit, param3:Number) : void
      {
         var _loc4_:Build = Facade.userProxy.constructionHash[param1] as Build;
         UnitFactory.addProgress(_loc4_,param3 + param2.su_upgrade_time,param2.su_upgrade_time,true).setIcon(param2.su_kind + param2.su_model_level + "_m");
         CoreLogic.createAction(finishResearch,FINISH_RESEARCH,param3 + param2.su_upgrade_time,param1,param2);
      }
      
      public static function finishResearch(param1:uint, param2:PShopUnit) : void
      {
         var _loc3_:UserProxy = Facade.userProxy;
         var _loc4_:String = param2.su_kind;
         ++_loc3_.soldierLevelHash[_loc4_];
         if(param2.su_upgrade_time > 0)
         {
            _loc3_.setExp(Facade.manualProxy.calcExp(param2.su_upgrade_time),true);
         }
         Facade.dispatchCommonEvent(CommonEvent.FINISH_RESEARCH,_loc4_,param1);
         Facade.questMediator.changeQuest(PAction.AC_RESEARCH,1,_loc4_,param2.su_level);
         var _loc5_:Build = Facade.userProxy.constructionHash[param1] as Build;
         if(_loc5_)
         {
            _loc5_.setProgress(null);
            UnitFactory.buildLogic.syncStatus(_loc5_);
         }
         _loc5_ = Facade.boardMediator.getSelected() as Build;
         if((Boolean(_loc5_)) && _loc5_.type == PBtype.GUARD)
         {
            Facade.boardMediator.syncSelected();
         }
         var _loc6_:Soldier = _loc3_.soldierList.head as Soldier;
         while(_loc6_)
         {
            if(_loc6_.shop.su_kind == _loc4_ && _loc6_.shop.su_model_level != param2.su_model_level)
            {
               _loc6_.assignShop(param2);
               if(_loc6_.isStand)
               {
                  _loc6_.stand();
               }
            }
            _loc6_ = _loc6_.link_next as Soldier;
         }
         Facade.audioProxy.play("study_finish");
      }
      
      public static function addCleanupGarbage(param1:Object, param2:Number) : void
      {
         var _loc5_:Garbage = null;
         var _loc6_:Boolean = false;
         if(param1 is Garbage)
         {
            _loc5_ = param1 as Garbage;
         }
         else
         {
            _loc5_ = Facade.userProxy.constructionHash[param1] as Garbage;
            _loc6_ = true;
         }
         var _loc3_:Number = _loc5_.shop.sg_remove_time;
         var _loc4_:Number = param2 + _loc3_;
         UnitFactory.addProgress(_loc5_,_loc4_,_loc3_);
         _loc5_.cleaning = true;
         UnitFactory.addWorker(CoreLogic.createAction(cleanupGarbage,CLEANUP_GARBAGE,_loc4_,_loc5_.id),_loc6_);
      }
      
      public static function cleanupGarbage(param1:Object) : void
      {
         var _loc3_:Boolean = false;
         var _loc2_:Garbage = (param1 is Garbage ? param1 : Facade.userProxy.constructionHash[param1]) as Garbage;
         if(_loc2_)
         {
            _loc3_ = _loc2_.shop.sg_gtype == "tree";
            if(!Facade.boardMediator.isEditorMode)
            {
               Facade.boardMediator.resetSelected(_loc2_);
               UnitFactory.removeWorker(_loc2_.id);
               Facade.userProxy.setExp(_loc2_.shop.sg_exp,true);
               ShopLogic.applyCost(_loc2_.prize);
               Facade.questMediator.changeQuest(PAction.AC_REMOVE_GARBAGE,1,_loc2_.kind);
               Facade.questMediator.changeQuest(_loc3_ ? PAction.AC_REMOVE_TREE : PAction.AC_REMOVE_STONE,1,_loc2_.kind);
            }
            Facade.mainMediator.flightGlobalMessage(Lang.getPatternString(_loc3_ ? "tree_prize" : "stone_prize","__PRIZE__",CostHelper.getListString([_loc2_.prize,PCost.create(PCost.EXP,_loc2_.shop.sg_exp)],30,24,6)));
            UnitFactory.removeConstruction(_loc2_);
         }
      }
      
      public static function addStatusResource(param1:uint, param2:Number) : void
      {
         CoreLogic.createAction(statusResource,STATUS_RESOURCE,param2,param1);
      }
      
      public static function statusResource(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:CircleButton = null;
         var _loc2_:Build = (param1 is Build ? param1 : Facade.userProxy.constructionHash[param1]) as Build;
         if(_loc2_)
         {
            BuildLogic.calcResource(_loc2_);
            _loc2_.syncResAnim();
            _loc3_ = CostHelper.getKind((_loc2_.spec as VOResourceSpec).prodVariance);
            _loc4_ = CircleButton.create(SkinManager.getEmbed(_loc3_),_loc3_ + "CollectBg",onCollectStatus,_loc2_,CircleButton.sizeStatus50);
            if(Facade.isMyMap && Facade.userProxy.radarEnabled && (_loc2_.spec as VOResourceSpec).prodVariance != PCost.GOLD)
            {
               _loc4_.add(SkinManager.getEmbed("PremiumArrowIcon"),{
                  "w":18,
                  "bottom":5,
                  "left":35
               });
            }
            _loc2_.setStatus(_loc4_);
         }
      }
      
      private static function onCollectStatus(param1:MouseEvent) : void
      {
         var _loc4_:Build = null;
         var _loc2_:Build = (param1.currentTarget as CircleButton).data as Build;
         var _loc3_:Vector.<Build> = new Vector.<Build>();
         Facade.userProxy.getBuild(_loc2_.shop.sb_btype.variance,true,0,_loc3_);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.kind == _loc2_.kind)
            {
               UnitFactory.buildLogic.collectResource(_loc4_,true,true,true);
            }
         }
      }
      
      public static function addRecoveryHero(param1:PHero) : void
      {
         var _loc4_:PShopHero = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Vector.<Build> = null;
         var _loc8_:Build = null;
         var _loc2_:PShopUnit = Facade.manualProxy.getSoldierShop(param1.hero_kind);
         var _loc3_:uint = _loc2_.su_stamina;
         if(param1.stamina_mod_level > 0)
         {
            _loc3_ += Facade.manualProxy.getHeroUpdateShop(_loc2_.su_kind,param1.stamina_mod_level,PHeroUpgradeKind.STAMINA).shu_effect;
         }
         if(param1.hero_stamina < _loc3_)
         {
            if(Facade.userProxy.soldierCountHash[_loc2_.su_kind] == 1)
            {
               Facade.userProxy.soldierCountHash[_loc2_.su_kind] = 0;
            }
            _loc4_ = Facade.manualProxy.getHeroShop(_loc2_.su_kind,_loc2_.su_level);
            _loc5_ = _loc4_.sh_reg_time;
            if(param1.recover_mod_level > 0)
            {
               _loc5_ -= Facade.manualProxy.getHeroUpdateShop(_loc2_.su_kind,param1.recover_mod_level,PHeroUpgradeKind.RECOVER).shu_effect;
            }
            _loc6_ = param1.hero_last_reg_time + Math.ceil((_loc3_ - param1.hero_stamina) / _loc3_ * _loc5_);
            _loc7_ = new Vector.<Build>();
            _loc3_ = 0;
            Facade.userProxy.getBuild(PBtype.HERO,false,0,_loc7_);
            for each(_loc8_ in _loc7_)
            {
               if(_loc8_.kind == _loc4_.sh_kind)
               {
                  if(_loc8_.updateLevel == 0)
                  {
                     UnitFactory.addProgress(_loc8_,_loc6_,_loc5_,false,UIFactory.INDICATOR_GREEN).setIcon(_loc2_.su_kind + _loc2_.su_model_level + "_m");
                  }
                  _loc3_ = _loc8_.id;
                  break;
               }
            }
            CoreLogic.createAction(recoveryHero,RECOVERY_HERO,_loc6_,_loc3_,_loc2_).useSelfArg = true;
            if(_loc3_ > 0)
            {
               Facade.boardMediator.syncSelected(_loc8_);
            }
         }
      }
      
      private static function recoveryHero(param1:MapAction) : void
      {
         var _loc4_:Build = null;
         if(param1.objId > 0)
         {
            _loc4_ = Facade.userProxy.constructionHash[param1.objId] as Build;
            if(_loc4_)
            {
               if(_loc4_.updateLevel == 0)
               {
                  _loc4_.setProgress(null);
               }
               Facade.boardMediator.syncSelected(_loc4_);
            }
         }
         var _loc2_:PShopUnit = param1.value as PShopUnit;
         Facade.userProxy.soldierCountHash[_loc2_.su_kind] = 1;
         var _loc3_:PHero = Facade.userProxy.getHeroSpec(_loc2_.su_kind);
         _loc3_.hero_stamina = _loc2_.su_stamina;
         if(_loc3_.stamina_mod_level > 0)
         {
            _loc3_.hero_stamina += Facade.manualProxy.getHeroUpdateShop(_loc2_.su_kind,_loc3_.stamina_mod_level,PHeroUpgradeKind.STAMINA).shu_effect;
         }
         UnitFactory.useSoldierPatrol();
      }
      
      public static function removeHeroRecovery(param1:PHero) : void
      {
         var _loc2_:MapAction = null;
         var _loc3_:PShopUnit = null;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         for each(_loc2_ in CoreLogic.getActionList(ActionLogic.RECOVERY_HERO))
         {
            _loc3_ = _loc2_.value as PShopUnit;
            if(_loc3_.su_kind == param1.hero_kind)
            {
               _loc4_ = _loc3_.su_stamina;
               if(param1.stamina_mod_level > 0)
               {
                  _loc4_ += Facade.manualProxy.getHeroUpdateShop(_loc3_.su_kind,param1.stamina_mod_level,PHeroUpgradeKind.STAMINA).shu_effect;
               }
               _loc5_ = (_loc2_.time - param1.hero_last_reg_time) / (_loc4_ - param1.hero_stamina);
               _loc6_ = (CoreLogic.serverTime - param1.hero_last_reg_time) / _loc5_;
               param1.hero_stamina += _loc6_;
               param1.hero_last_reg_time += Math.floor(_loc6_ * _loc5_);
               CoreLogic.removeAction(_loc2_);
               break;
            }
         }
      }
      
      private static function applyHeroUpdate(param1:Build, param2:Boolean) : void
      {
         var _loc3_:String = Facade.manualProxy.getHeroShop(param1.kind,param1.level,false,true).sh_unit_kind;
         if(!Facade.userProxy.getHeroSpec(_loc3_) && !param2)
         {
            Facade.userProxy.heroSpecList.push(PHero.create(_loc3_,Facade.manualProxy.getSoldierShop(_loc3_).su_stamina,0,0,0,0,0));
         }
      }
      
      public static function addRecoveryEnergy(param1:Number = -1) : void
      {
         if(CoreLogic.getAction(RECOVERY_ENERGY))
         {
            return;
         }
         if(param1 < 0)
         {
            param1 = CoreLogic.serverTime;
         }
         var _loc2_:Number = Facade.userProxy.getEnergyCooldown();
         CoreLogic.createAction(recoveryEnergy,RECOVERY_ENERGY,param1 + _loc2_,0,_loc2_).useSelfArg = true;
      }
      
      private static function recoveryEnergy(param1:MapAction) : void
      {
         var _loc2_:UserProxy = Facade.userProxy;
         ++_loc2_.energy;
         if(_loc2_.energy < _loc2_.energyMax)
         {
            CoreLogic.addAction(param1,param1.time + param1.value);
         }
         Facade.dispatchCommonEvent(CommonEvent.ENERGY,_loc2_.energy,PCost.CALL);
      }
      
      public static function addRecoveryRequestEnergy(param1:Build = null, param2:Number = -1) : void
      {
         var _loc3_:Number = Facade.references.clan_request_cd;
         if(param2 < 0)
         {
            param2 = CoreLogic.serverTime;
         }
         else if(param2 + _loc3_ <= CoreLogic.serverTime)
         {
            return;
         }
         syncClanCenterProgress(param1,CoreLogic.createAction(syncClanCenterProgress,RECOVERY_REQUEST_ENERGY,param2 + _loc3_));
      }
      
      private static function syncClanCenterProgress(param1:Build = null, param2:MapAction = null) : void
      {
         if(!param1)
         {
            param1 = Facade.userProxy.getBuild(PBtype.CLAN,false);
         }
         if(param1)
         {
            Facade.boardMediator.syncSelected(param1);
            if(param1.updateLevel != 0)
            {
               return;
            }
            if(Facade.userProxy.clan)
            {
               if(!param2)
               {
                  param2 = CoreLogic.getAction(ActionLogic.RECOVERY_REQUEST_ENERGY);
               }
               if(param2)
               {
                  UnitFactory.addProgress(param1,param2.time,Facade.references.clan_request_cd,false,UIFactory.INDICATOR_GREEN).add(SkinManager.getEmbed("CallRequestIcon"),{
                     "left":-25,
                     "h":30,
                     "vCenter":4
                  });
                  return;
               }
            }
            param1.setProgress(null);
         }
      }
      
      public static function addOffer(param1:POffer, param2:Boolean = false) : void
      {
         var _loc3_:String = param1.offer_kind;
         if(Facade.userProxy.checkOffer(_loc3_))
         {
            return;
         }
         Facade.myMediator.changeOffer(_loc3_,param1);
         if(param2)
         {
            Facade.myMediator.swipeOffer(_loc3_);
         }
         var _loc4_:PShopOffer = Facade.manualProxy.getOfferShop(_loc3_);
         if(param2 && _loc4_.offer_is_autoview)
         {
            Facade.myMediator.openOfferDialog(_loc3_);
         }
         if(_loc4_.offer_duration > 0)
         {
            CoreLogic.createAction(Facade.myMediator.changeOffer,FINISH_OFFER,param1.offer_start_time + _loc4_.offer_duration,0,_loc3_);
         }
      }
      
      public static function addRecoveryShield(param1:Object, param2:Boolean = true) : void
      {
         var _loc3_:Build = (param1 is Build ? param1 : Facade.userProxy.constructionHash[param1]) as Build;
         var _loc4_:VOShieldSpec = _loc3_.spec;
         if(!param2 || _loc4_.recoveryTime > CoreLogic.serverTime)
         {
            UnitFactory.addProgress(_loc3_,_loc4_.recoveryTime,_loc4_.recoveryDuration,true).add(SkinManager.getEmbed("ShieldStat"),{
               "left":-25,
               "h":28,
               "vCenter":4
            });
            CoreLogic.createAction(recoveryShield,FINISH_SHIELD,_loc4_.recoveryTime,_loc3_.id);
         }
      }
      
      private static function recoveryShield(param1:uint) : void
      {
         var _loc2_:Build = Facade.userProxy.constructionHash[param1] as Build;
         (_loc2_.spec as VOShieldSpec).isRecovery = false;
         _loc2_.setProgress(null);
         Facade.boardMediator.syncSelected(_loc2_);
      }
      
      public static function createEndSeason() : void
      {
         var _loc1_:int = TopClansMediator.getCurSeason();
         CoreLogic.createAction(createEndSeasonResult,END_SEASON,_loc1_ * Facade.references.clan_competition_duration + Facade.references.clan_competition_start_time);
      }
      
      private static function createEndSeasonResult(param1:* = null) : void
      {
         if(isGetSeasonResult)
         {
            resetSeasonFlag();
         }
         else
         {
            isWaitSeasonResult = true;
         }
      }
      
      public static function resetSeasonFlag() : void
      {
         isGetSeasonResult = false;
         isWaitSeasonResult = false;
      }
      
      public static function territiryWarsRegEnd(param1:Number, param2:String) : void
      {
         var _loc3_:MapAction = null;
         for each(_loc3_ in CoreLogic.getActionList(ActionLogic.START_TERRITORY_WAR))
         {
            if(_loc3_.value == param2)
            {
               CoreLogic.removeAction(_loc3_);
            }
         }
         CoreLogic.createAction(onTerritiryWarsRegEnd,START_TERRITORY_WAR,param1,0,param2);
      }
      
      private static function onTerritiryWarsRegEnd(param1:* = null) : void
      {
         var _loc2_:TerritoryDialog = Facade.mainMediator.searchDialog(TerritoryDialog);
         if(Boolean(_loc2_) && _loc2_.kind == param1)
         {
            _loc2_.close();
         }
         Facade.protoProxy.request(new Packet_0060_42(param1));
      }
   }
}

