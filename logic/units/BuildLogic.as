package logic.units
{
   import engine.display.RepeatClip;
   import engine.signal.Signal;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Fence;
   import engine.units.Unit;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import game.barrack.BarrackMediator;
   import game.barrack.LastArmyDialog;
   import game.battle.BattleMediator;
   import game.board.UnitMenuButton;
   import game.feature.FeatureMediator;
   import game.guard.GuardMediator;
   import game.library.LibraryMediator;
   import game.my.MyMediator;
   import game.research.ResearchMediator;
   import game.shop.ShareDialog;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import logic.MainLogic;
   import logic.ShopLogic;
   import logic.UnitFactory;
   import logic.battle.SimBaseVisual;
   import model.CommonEvent;
   import model.vo.MapAction;
   import model.vo.VOGuardSpec;
   import model.vo.VOPylonSpec;
   import model.vo.VOResourceSpec;
   import model.vo.VOShieldSpec;
   import model.vo.VOStorageSpec;
   import proto.BinaryBuffer;
   import proto.game.family_0010.PChargeGuard;
   import proto.game.family_0010.PGuardConfig;
   import proto.game.family_0010.PUserAction;
   import proto.game.family_0010.Packet_0010_26;
   import proto.game.family_0010.Packet_0010_27;
   import proto.model.PBtype;
   import proto.model.PCost;
   import proto.model.PKindCount;
   import proto.model.PRaidEvent;
   import proto.model.PRequirement;
   import proto.model.PShopBuilding;
   import proto.model.PShopHero;
   import proto.model.PShopSpell;
   import proto.model.PShopUnit;
   import proto.model.clan.PCallRequest;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.game.ClipPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VProgressBar;
   import ui.vbase.VSkin;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class BuildLogic extends AbstractLogic
   {
      
      public function BuildLogic()
      {
         super();
      }
      
      public static function changeTownHallLevel(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:Vector.<Dictionary> = null;
         var _loc4_:Dictionary = null;
         if(userProxy.townHallLevel != param1)
         {
            _loc3_ = manualProxy.townHallUnlockList;
            userProxy.townHallLevel = param1;
            _loc4_ = param1 > 0 && param1 <= _loc3_.length ? _loc3_[param1 - 1] : null;
            userProxy.changeConstructionMaxHash(_loc4_);
            if(!isCapital)
            {
               if(param2 && Boolean(_loc4_))
               {
                  changeShopNewList(_loc4_,param1 > 1 ? _loc3_[param1 - 2] : null,userProxy.shopNewList);
               }
               userProxy.energyMax = manualProxy.getTownHallUnlock(param1).tu_calls;
               if(param2 && userProxy.energy < userProxy.energyMax)
               {
                  ShopLogic.setEnergy(userProxy.energyMax,false);
               }
            }
         }
      }
      
      private static function changeShopNewList(param1:Dictionary, param2:Dictionary, param3:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         for(_loc4_ in param1)
         {
            _loc5_ = uint(param1[_loc4_]);
            _loc6_ = Boolean(param2) && param2.hasOwnProperty(_loc4_) ? uint(param2[_loc4_]) : 0;
            if(_loc5_ > _loc6_ && param3.indexOf(_loc4_) < 0)
            {
               param3.push(_loc4_);
            }
         }
         myMediator.syncShopButton(true);
      }
      
      public static function calcStorage(param1:Boolean = true, param2:Boolean = true) : void
      {
         var _loc9_:VOStorageSpec = null;
         var _loc10_:int = 0;
         var _loc3_:uint = PBtype.STORAGE;
         var _loc4_:uint = userProxy.crystal > 0 ? uint(userProxy.crystal) : 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = userProxy.oil > 0 ? uint(userProxy.oil) : 0;
         var _loc7_:uint = 0;
         var _loc8_:Build = userProxy.buildList.head as Build;
         while(_loc8_)
         {
            if(_loc8_.type == _loc3_)
            {
               _loc9_ = _loc8_.spec;
               if(_loc9_.costVariance == PCost.CRYSTAL)
               {
                  if(param1)
                  {
                     _loc9_.capacityCur = _loc9_.capacityMax / userProxy.crystalMax * _loc4_;
                     _loc5_ += _loc9_.capacityCur;
                     _loc8_.syncResAnim();
                  }
               }
               else if(param2 && _loc9_.costVariance == PCost.OIL)
               {
                  _loc9_.capacityCur = _loc9_.capacityMax / userProxy.oilMax * _loc6_;
                  _loc7_ += _loc9_.capacityCur;
                  _loc8_.syncResAnim();
               }
            }
            _loc8_ = _loc8_.link_next as Build;
         }
         if(param1 && _loc5_ < _loc4_ || param2 && _loc7_ < _loc6_)
         {
            _loc5_ = _loc4_ - _loc5_;
            _loc7_ = _loc6_ - _loc7_;
            _loc8_ = userProxy.buildList.head as Build;
            while(_loc8_)
            {
               if(_loc8_.type == _loc3_)
               {
                  _loc9_ = _loc8_.spec;
                  _loc10_ = _loc9_.capacityMax - _loc9_.capacityCur;
                  if(_loc10_ > 0)
                  {
                     if(_loc9_.costVariance == PCost.CRYSTAL)
                     {
                        if(param1)
                        {
                           if(_loc10_ >= _loc5_)
                           {
                              _loc9_.capacityCur += _loc5_;
                              _loc5_ = 0;
                              if(_loc7_ == 0)
                              {
                                 break;
                              }
                           }
                           else
                           {
                              _loc9_.capacityCur += _loc10_;
                              _loc5_ -= _loc10_;
                           }
                        }
                     }
                     else if(param2 && _loc9_.costVariance == PCost.OIL)
                     {
                        if(_loc10_ >= _loc7_)
                        {
                           _loc9_.capacityCur += _loc7_;
                           _loc7_ = 0;
                           if(_loc5_ == 0)
                           {
                              break;
                           }
                        }
                        else
                        {
                           _loc9_.capacityCur += _loc10_;
                           _loc7_ -= _loc10_;
                        }
                     }
                  }
               }
               _loc8_ = _loc8_.link_next as Build;
            }
         }
      }
      
      public static function onUpdate(param1:Unit) : void
      {
         mainMediator.showDialog(new FeatureMediator(param1,true));
      }
      
      public static function startUpdate(param1:Unit, param2:Object, param3:Number, param4:Boolean = true) : void
      {
         var _loc6_:Build = null;
         var _loc7_:uint = 0;
         if(ShopLogic.checkCostAndWorker(param2,startUpdate,arguments,param3 > 0 || param1 is Fence && param1.level + 1 >= references.fence_builder_req_lvl))
         {
            if(param1 is Build)
            {
               _loc6_ = param1 as Build;
               _loc7_ = _loc6_.type;
               if(_loc7_ == PBtype.RESOURCE)
               {
                  calcResource(_loc6_);
               }
               _loc6_.setUpdateLevel(param1.level + 1);
               if(_loc7_ == PBtype.RESOURCE)
               {
                  _loc6_.syncResJob();
                  CoreLogic.removeFilterActions(_loc6_.id,ActionLogic.STATUS_RESOURCE);
               }
               else if(_loc7_ == PBtype.PYLON)
               {
                  CannonLogic.checkPylonCannon();
               }
               else if(_loc7_ == PBtype.GUARD)
               {
                  disbandGuard(_loc6_);
               }
               else if(_loc7_ == PBtype.SHIELD)
               {
                  CoreLogic.removeFilterActions(_loc6_.id,ActionLogic.FINISH_SHIELD);
               }
            }
            else if(param1 is Cannon)
            {
               (param1 as Cannon).setUpdateLevel(param1.level + 1);
            }
            else if(!(param1 is Fence))
            {
               throw new Error("BuildLogic.startUpdate error");
            }
            if(param2 is PCost)
            {
               ShopLogic.applyCost(param2 as PCost,true);
            }
            else
            {
               ShopLogic.applyCostList(param2 as Array,true);
            }
            if(param3 > 0)
            {
               ActionLogic.addFinishConstruction(param1,param3);
               boardMediator.syncSelected(param1);
            }
            else
            {
               ActionLogic.finishConstruction(param1);
            }
            if(param4)
            {
               ActionLogic.request(PUserAction.UPGRADE,UnitFactory.getServerObjectId(param1));
            }
         }
      }
      
      private static function disbandGuard(param1:Build) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:PKindCount = null;
         var _loc2_:VOGuardSpec = param1.spec;
         if(_loc2_.configList.length == 0)
         {
            return;
         }
         if(_loc2_.chargeCur > 0)
         {
            _loc3_ = 0;
            for each(_loc4_ in _loc2_.configList)
            {
               _loc3_ += manualProxy.getSoldierShop(_loc4_.kind).su_price.value * _loc4_.count;
            }
            userProxy.setOil(_loc3_ * _loc2_.chargeCur,true,false);
            _loc2_.chargeCur = 0;
         }
         _loc2_.configList.length = 0;
         ActionLogic.request(PUserAction.SET_GUARD_CONFIG,PGuardConfig.create(param1.id,_loc2_.configList));
      }
      
      public static function calcResource(param1:Build) : void
      {
         var _loc4_:uint = 0;
         if(param1.updateLevel != 0)
         {
            return;
         }
         var _loc2_:VOResourceSpec = param1.spec;
         var _loc3_:Number = CoreLogic.serverTime;
         if(_loc2_.capacityCur < _loc2_.capacityMax && _loc3_ > _loc2_.lastTime)
         {
            _loc4_ = (_loc3_ - _loc2_.lastTime) * _loc2_.prodValue;
            if(_loc4_ > 0)
            {
               _loc2_.capacityCur += _loc4_;
               if(_loc2_.capacityCur > _loc2_.capacityMax)
               {
                  _loc4_ -= _loc2_.capacityCur - _loc2_.capacityMax;
                  _loc2_.capacityCur = _loc2_.capacityMax;
               }
               _loc2_.lastTime += _loc4_ / _loc2_.prodValue;
            }
         }
      }
      
      override public function changeSelect(param1:Unit, param2:Boolean) : void
      {
         var _loc3_:Build = param1 as Build;
         if(_loc3_.updateLevel != 1 && !boardMediator.isEditorMode)
         {
            if(param2)
            {
               if(_loc3_.isStatus)
               {
                  _loc3_.setStatus(null);
                  if(_loc3_.type == PBtype.RESOURCE)
                  {
                     this.collectResource(_loc3_,false);
                  }
               }
               else if(_loc3_.type == PBtype.RESOURCE)
               {
                  CoreLogic.removeFilterActions(_loc3_.id,ActionLogic.STATUS_RESOURCE);
               }
            }
            else if(_loc3_.type == PBtype.WORKER)
            {
               this.syncWorkerStatus(_loc3_);
            }
            else
            {
               this.syncStatus(_loc3_);
            }
         }
         if(!_loc3_.spec)
         {
            return;
         }
         if(_loc3_.type == PBtype.PYLON || _loc3_.type == PBtype.GUARD)
         {
            if(param2)
            {
               if(_loc3_.type == PBtype.PYLON)
               {
                  _loc3_.showRadius((_loc3_.spec as VOPylonSpec).radius,0);
               }
               else
               {
                  _loc3_.showRadius((_loc3_.spec as VOGuardSpec).radius,16777215);
               }
            }
            else
            {
               _loc3_.hideRadius();
            }
         }
      }
      
      override public function changeMove(param1:Unit, param2:Boolean, param3:Boolean = false) : void
      {
         if(!param2 && (param1 as Build).type == PBtype.PYLON)
         {
            CannonLogic.checkPylonCannon();
         }
      }
      
      override public function onMove(param1:Unit) : void
      {
         if((param1 as Build).type == PBtype.PYLON)
         {
            CannonLogic.checkPylonCannon();
         }
      }
      
      override public function getMenu(param1:Unit, param2:Vector.<VComponent>) : void
      {
         var _loc4_:Build = null;
         var _loc6_:UnitMenuButton = null;
         var _loc7_:PShopBuilding = null;
         var _loc8_:Array = null;
         var _loc3_:UnitMenuButton = MyMediator.commonBt;
         _loc4_ = param1 as Build;
         var _loc5_:uint = _loc4_.type;
         if(_loc4_.updateLevel > 0)
         {
            _loc6_ = MyMediator.cancelBt;
            _loc6_.changeHandler(ShopLogic.showCancelDialog,ActionLogic.FINISH_CONSTRUCTION,_loc4_.updateLevel);
            param2.push(_loc6_);
            _loc6_ = MyMediator.speedupBt;
            if(isCapital)
            {
               _loc6_.trackSpeedup(CoreLogic.getActionTimeLeft(ActionLogic.FINISH_CONSTRUCTION,_loc4_.id));
            }
            else
            {
               _loc6_.trackFree(CoreLogic.getActionTimeLeft(ActionLogic.FINISH_CONSTRUCTION,_loc4_.id));
            }
            _loc6_.changeHandler(ShopLogic.showActionSpeedupDialog,ActionLogic.FINISH_CONSTRUCTION);
            param2.push(_loc6_);
         }
         else
         {
            _loc7_ = manualProxy.getBuildShop(param1.kind,param1.level + 1,true);
            if((Boolean(_loc7_)) && _loc7_.sb_can_buy)
            {
               _loc6_ = MyMediator.updateBt;
               _loc6_.applyPriceList(_loc7_.sb_price);
               _loc6_.handler = onUpdate;
               param2.push(_loc6_);
            }
            if(_loc5_ == PBtype.RESEARCH)
            {
               _loc3_.change("ResearchIcon",true,Lang.getString("researchBt"),this.goInsideBuild);
               param2.push(_loc3_);
            }
            else if(!isCapital)
            {
               if(_loc5_ == PBtype.GUARD)
               {
                  _loc3_.change("GuardIcon",true,Lang.getString("guardBt"),this.goInsideBuild);
                  param2.push(_loc3_);
                  this.assignGuardButton(_loc4_,param2);
               }
               else if(_loc5_ == PBtype.RAID)
               {
                  _loc3_.change("PortalIcon",true,Lang.getString("getRaidBt"),this.goInsideBuild);
                  param2.push(_loc3_);
               }
               else if(_loc5_ == PBtype.SHIELD)
               {
                  if(!(_loc4_.spec as VOShieldSpec).isRecovery)
                  {
                     _loc3_.change("ShieldStat",true,Lang.getString("buyShieldBt"),this.onShield);
                     param2.push(_loc3_);
                  }
               }
               else if(_loc5_ == PBtype.SCOUTING)
               {
                  _loc3_.change("RadarIcon",true,Lang.getString("radarBt"),this.goInsideBuild);
                  param2.push(_loc3_);
               }
            }
         }
         if(_loc4_.updateLevel == 1)
         {
            return;
         }
         if(_loc5_ == PBtype.RESOURCE)
         {
            if(_loc4_.updateLevel == 0 || (_loc4_.spec as VOResourceSpec).capacityCur > 0)
            {
               this.assignResButton(_loc4_,_loc3_);
               param2.push(_loc3_);
            }
         }
         if(isCapital)
         {
            return;
         }
         if(_loc5_ == PBtype.BARRACK)
         {
            if(BarrackMediator.checkLastArmy())
            {
               _loc6_ = MyMediator.common2Bt;
               _loc6_.change("TombIcon",true,Lang.getString("dead_troops"),this.onBuyLastArmy);
               param2.push(_loc6_);
            }
            _loc3_.change("BarrackIcon",true,Lang.getString("barrackBt"),this.goInsideBuild);
            param2.push(_loc3_);
         }
         else if(_loc5_ == PBtype.LIBRARY)
         {
            _loc3_.change("SpellIcon",true,Lang.getString("libraryBt"),this.goInsideBuild);
            param2.push(_loc3_);
         }
         else if(_loc5_ == PBtype.HERO)
         {
            this.assignHeroButton(_loc4_,_loc3_,param2);
         }
         else if(_loc5_ == PBtype.CLAN)
         {
            _loc3_.change("ClanEmblemIcon",true,Lang.getString("clanBt"),this.goInsideBuild);
            param2.push(_loc3_);
            if(userProxy.clan)
            {
               if(userProxy.clanEnergy > 0)
               {
                  _loc6_ = MyMediator.common3Bt;
                  _loc6_.change(CostHelper.getKind(PCost.CALL),true,Lang.getString("collectBt"),this.collectClanEnergy);
                  _loc6_.applyResource(userProxy.clanEnergy);
                  param2.push(_loc6_);
               }
               if(Boolean(Facade.userProxy.clanHallPrize) && Facade.userProxy.clanHallPrize.resources.length > 0)
               {
                  _loc8_ = Facade.userProxy.clanHallPrize.resources;
                  _loc6_ = MyMediator.common4Bt;
                  _loc6_.change("ClanChest_9",true,Lang.getString("collectBt"),this.collectClanRes);
                  _loc6_.data = _loc8_;
                  param2.push(_loc6_);
               }
               if(!CoreLogic.getAction(ActionLogic.RECOVERY_REQUEST_ENERGY))
               {
                  _loc6_ = MyMediator.common2Bt;
                  _loc6_.change("CallRequestIcon",true,Lang.getString("requestEnergyBt"),this.onRequestEnergy);
                  param2.push(_loc6_);
               }
            }
         }
         else if(_loc5_ == PBtype.TOWNHALL)
         {
            _loc3_.change("EditorIcon",true,Lang.getString("editor_mode"),this.goInsideBuild);
            param2.push(_loc3_);
            _loc6_ = MyMediator.common2Bt;
            _loc6_.change("SwordsIcon",true,Lang.getString("self_attack"),this.onSelfAttack);
            param2.push(_loc6_);
         }
      }
      
      private function assignResButton(param1:Build, param2:UnitMenuButton) : void
      {
         var _loc3_:VOResourceSpec = param1.spec;
         param2.change(CostHelper.getKind(_loc3_.prodVariance),true,Lang.getString("collectBt"),this.collectResource);
         param2.trackResource(_loc3_,param1.updateLevel != 0);
      }
      
      private function assignHeroButton(param1:Build, param2:UnitMenuButton, param3:Vector.<VComponent>) : void
      {
         var _loc4_:MapAction = CoreLogic.getAction(ActionLogic.RECOVERY_HERO,param1.id);
         if(_loc4_)
         {
            param2.change("HeroIcon",true,Lang.getString("heroBt"),ShopLogic.showActionSpeedupDialog,_loc4_.variance);
            param2.trackSpeedup(_loc4_.time - CoreLogic.serverTime,_loc4_.variance);
            param3.push(param2);
         }
         param2 = MyMediator.common3Bt;
         param2.icon.setSize(0,0);
         var _loc5_:PShopHero = manualProxy.getHeroShop(param1.kind,param1.level,false,true);
         param2.change(_loc5_.sh_unit_kind,false,Lang.getString(_loc5_.sh_unit_kind),this.onHeroStat,_loc5_);
         param3.unshift(param2);
      }
      
      private function onHeroStat(param1:Build, param2:PShopHero) : void
      {
         mainMediator.showDialog(new FeatureMediator(manualProxy.getSoldierShop(param2.sh_unit_kind,userProxy.getHeroLevel(param2.sh_unit_kind))));
      }
      
      private function assignGuardButton(param1:Build, param2:Vector.<VComponent>) : void
      {
         var _loc6_:Build = null;
         var _loc7_:uint = 0;
         var _loc8_:PKindCount = null;
         var _loc9_:PCost = null;
         var _loc10_:UnitMenuButton = null;
         var _loc11_:UnitMenuButton = null;
         var _loc3_:VOGuardSpec = param1.spec;
         if(_loc3_.configList.length > 0 && _loc3_.chargeCur < _loc3_.chargeMax)
         {
            GuardMediator.checkElite(param1);
            _loc7_ = 0;
            for each(_loc8_ in _loc3_.configList)
            {
               _loc7_ += manualProxy.getSoldierShop(_loc8_.kind).su_price.value * _loc8_.count;
            }
            _loc9_ = PCost.create(PCost.OIL,_loc7_ * (_loc3_.chargeMax - _loc3_.chargeCur));
            _loc10_ = MyMediator.common2Bt;
            _loc10_.applyPrice(_loc9_);
            _loc10_.change("FullChargeIcon",true,Lang.getString("guardChargeBt"),this.onBuyGuardUnits,_loc9_);
            param2.push(_loc10_);
         }
         var _loc4_:Vector.<Build> = new Vector.<Build>();
         var _loc5_:int = 0;
         Facade.userProxy.getBuild(PBtype.GUARD,true,0,_loc4_);
         for each(_loc6_ in _loc4_)
         {
            if(_loc6_.spec.configList.length > 0 && _loc6_.spec.chargeCur < _loc6_.spec.chargeMax)
            {
               _loc7_ = 0;
               for each(_loc8_ in _loc6_.spec.configList)
               {
                  _loc7_ += manualProxy.getSoldierShop(_loc8_.kind).su_price.value * _loc8_.count;
               }
               _loc5_ += _loc7_ * (_loc6_.spec.chargeMax - _loc6_.spec.chargeCur);
            }
         }
         if(_loc5_ > 0 && (!_loc9_ || _loc9_.value != _loc5_))
         {
            _loc11_ = MyMediator.common4Bt;
            _loc9_ = PCost.create(PCost.OIL,_loc5_);
            param2.push(_loc11_);
            _loc11_.applyPrice(_loc9_);
            _loc11_.change("ArmyCapacityIcon",true,Lang.getString("guardChargeBtAll"),this.onBuyGuardUnitsAll,_loc9_);
         }
      }
      
      private function onBuyGuardUnitsAll(param1:Build, param2:PCost) : void
      {
         var _loc4_:Vector.<Build> = null;
         var _loc5_:Build = null;
         var _loc6_:VOGuardSpec = null;
         if(ShopLogic.checkPrice(param2,this.onBuyGuardUnitsAll,arguments))
         {
            ShopLogic.applyCost(param2,true);
            _loc4_ = new Vector.<Build>();
            Facade.userProxy.getBuild(PBtype.GUARD,true,0,_loc4_);
            for each(_loc5_ in _loc4_)
            {
               _loc6_ = _loc5_.spec;
               if(_loc6_.configList.length > 0)
               {
                  ActionLogic.request(PUserAction.CHARGE_GUARD,PChargeGuard.create(_loc5_.id,true,_loc6_.chargeMax - _loc6_.chargeCur));
                  _loc6_.chargeCur = _loc6_.chargeMax;
               }
            }
            for each(_loc5_ in _loc4_)
            {
               boardMediator.syncSelected(_loc5_);
               this.syncStatus(_loc5_);
            }
         }
      }
      
      public function onBuyGuardUnits(param1:Build, param2:PCost) : void
      {
         var _loc4_:VOGuardSpec = null;
         if(ShopLogic.checkPrice(param2,this.onBuyGuardUnits,arguments))
         {
            ShopLogic.applyCost(param2,true);
            _loc4_ = param1.spec;
            ActionLogic.request(PUserAction.CHARGE_GUARD,PChargeGuard.create(param1.id,true,_loc4_.chargeMax - _loc4_.chargeCur));
            _loc4_.chargeCur = _loc4_.chargeMax;
            boardMediator.syncSelected(param1);
            this.syncStatus(param1);
         }
      }
      
      public function collectResource(param1:Build, param2:Boolean = true, param3:Boolean = true, param4:Boolean = false) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         calcResource(param1);
         var _loc5_:VOResourceSpec = param1.spec;
         if(_loc5_.capacityCur > 0)
         {
            _loc6_ = _loc5_.prodVariance;
            if(_loc6_ == PCost.CRYSTAL)
            {
               _loc7_ = userProxy.crystalMax - userProxy.crystal;
            }
            else if(_loc6_ == PCost.OIL)
            {
               _loc7_ = userProxy.oilMax - userProxy.oil;
            }
            else
            {
               _loc7_ = int(_loc5_.capacityCur);
            }
            if(_loc5_.capacityCur < _loc7_)
            {
               _loc7_ = int(_loc5_.capacityCur);
            }
            if(_loc7_ > 0)
            {
               _loc8_ = (_loc6_ == PCost.CRYSTAL || _loc6_ == PCost.OIL) && isMyMap && userProxy.radarEnabled ? int(Math.floor(_loc7_ * (manualProxy.scoutingInfo.scouting_resources / 100))) : 0;
               ShopLogic.applyCost(PCost.create(_loc6_,_loc7_ + _loc8_));
               if(_loc5_.capacityCur == _loc5_.capacityMax)
               {
                  _loc5_.lastTime = CoreLogic.serverTime;
               }
               _loc5_.capacityCur -= _loc7_;
               param1.syncResAnim();
               if(param3)
               {
                  ActionLogic.request(PUserAction.COLLECT_RESOURCE,param1.id);
               }
               if(param1.updateLevel == 0 && _loc5_.capacityCur < _loc5_.capacityMax)
               {
                  param1.syncResJob();
               }
               if(boardMediator.getSelected() == param1)
               {
                  boardMediator.setSelected(null);
               }
               if(param4)
               {
                  this.planeCollectResource(param1);
               }
               if(isNormalQuality)
               {
                  if(_loc6_ == PCost.GOLD)
                  {
                     this.useGoldDropClip(param1);
                  }
                  else
                  {
                     this.useDropClip(param1,_loc6_,Math.ceil(_loc7_ / _loc5_.capacityMax * 3));
                  }
               }
               CostHelper.flightMessage(_loc5_.prodVariance,_loc8_ > 0 ? _loc7_ + "+" + _loc8_ : "+" + _loc7_,param1);
            }
            else if(param2)
            {
               mainMediator.flightMessage(Lang.getString("not_storage"));
            }
         }
      }
      
      private function useDropClip(param1:Build, param2:uint, param3:uint) : void
      {
         var _loc5_:VOStorageSpec = null;
         if(param3 == 0)
         {
            param3 = 1;
         }
         else if(param3 > 3)
         {
            param3 = 3;
         }
         var _loc4_:String = param2 == PCost.CRYSTAL ? "cry" : "oil";
         if(param2 != PCost.RUBY)
         {
            SimBaseVisual.addFlaEffect(_loc4_ + "Drop" + param3,param1);
         }
         audioProxy.play("collect_" + _loc4_);
         param1 = userProxy.buildList.head as Build;
         while(param1)
         {
            if(param1.type == PBtype.STORAGE && param1.updateLevel == 0 && param1.display.visible)
            {
               _loc5_ = param1.spec as VOStorageSpec;
               if(_loc5_.costVariance == param2 && _loc5_.capacityCur < _loc5_.capacityMax)
               {
                  SimBaseVisual.addFlaEffect(_loc4_ + "Storage",param1,1);
               }
            }
            param1 = param1.link_next as Build;
         }
      }
      
      private function useGoldDropClip(param1:Build) : void
      {
         var _loc2_:VSkin = SkinManager.getExternal("GoldDropClip1",0,VSkin.NO_STRETCH);
         _loc2_.x = param1.iconX;
         _loc2_.y = param1.iconY;
         param1.display.addChild(_loc2_);
         Signal.delayCall(_loc2_.isContent ? 2.5 : 5,this.onRemoveDropClip,[_loc2_]);
      }
      
      private function onRemoveDropClip(param1:VSkin) : void
      {
         param1.removeFromParent();
      }
      
      public function planeCollectResource(param1:Build) : void
      {
         var _loc2_:VOResourceSpec = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         CoreLogic.removeFilterActions(param1.id,ActionLogic.STATUS_RESOURCE);
         param1.setStatus(null);
         if(param1.updateLevel == 0)
         {
            _loc2_ = param1.spec;
            _loc3_ = Math.ceil(_loc2_.capacityMax / 100);
            if(_loc2_.capacityCur < _loc3_)
            {
               _loc4_ = Math.ceil((_loc3_ - _loc2_.capacityCur) / _loc2_.prodValue);
               if(_loc4_ > 0)
               {
                  ActionLogic.addStatusResource(param1.id,_loc2_.lastTime + _loc4_);
                  return;
               }
            }
            ActionLogic.statusResource(param1);
         }
      }
      
      public function goInsideBuild(param1:Build, param2:String = null) : Object
      {
         var _loc4_:Object = null;
         var _loc3_:uint = param1.type;
         if(_loc3_ == PBtype.BARRACK)
         {
            _loc4_ = new BarrackMediator(param1,param2);
         }
         else if(_loc3_ == PBtype.CLAN)
         {
            DialogLogic.openClanCenter();
         }
         else if(_loc3_ == PBtype.LIBRARY)
         {
            _loc4_ = new LibraryMediator(param1);
         }
         else if(_loc3_ == PBtype.RAID)
         {
            myMediator.toPortal();
         }
         else if(_loc3_ == PBtype.TOWNHALL)
         {
            boardMediator.useEditorMode();
         }
         else if(param1.updateLevel != 0)
         {
            mainMediator.showMessage(Lang.getPatternString("build_bad_inside","__BUILD__",StringHelper.getUnitName(param1.kind,param1.updateLevel)));
         }
         else if(_loc3_ == PBtype.GUARD)
         {
            GuardMediator.checkElite(param1);
            _loc4_ = new GuardMediator(param1);
         }
         else if(_loc3_ == PBtype.RESEARCH)
         {
            _loc4_ = new ResearchMediator(param1,param2);
         }
         else if(_loc3_ == PBtype.SCOUTING)
         {
            myMediator.toRadar();
         }
         if(_loc4_)
         {
            mainMediator.showDialog(_loc4_);
         }
         return _loc4_;
      }
      
      public function upBarrack(param1:Build) : void
      {
         var _loc2_:PShopUnit = null;
         for each(_loc2_ in manualProxy.soldierShopList)
         {
            if(_loc2_.su_level == 1)
            {
               if(_loc2_.su_upgrade_requirement.req_building_level == param1.level && _loc2_.su_upgrade_requirement.req_building_kind == param1.kind)
               {
                  ++userProxy.soldierLevelHash[_loc2_.su_kind];
                  dispatchCommonEvent(CommonEvent.FINISH_RESEARCH,_loc2_.su_kind);
               }
            }
         }
      }
      
      public function upLibrary(param1:Build) : void
      {
         var _loc2_:PShopSpell = null;
         for each(_loc2_ in manualProxy.spellShopList)
         {
            if(_loc2_.ssp_level == 1)
            {
               if(_loc2_.ssp_upgrade_requirement.req_building_level == param1.level && _loc2_.ssp_upgrade_requirement.req_building_kind == param1.kind)
               {
                  ++userProxy.soldierLevelHash[_loc2_.ssp_kind];
                  dispatchCommonEvent(CommonEvent.FINISH_RESEARCH,_loc2_.ssp_kind);
               }
            }
         }
      }
      
      public function syncStatus(param1:Build) : void
      {
         var _loc2_:uint = param1.type;
         if(isCapital && _loc2_ != PBtype.RESOURCE)
         {
            return;
         }
         var _loc3_:uint = param1.type;
         var _loc4_:Boolean = boardMediator.getSelected() != param1;
         switch(_loc3_)
         {
            case PBtype.BARRACK:
               if(_loc4_ && param1.updateLevel != 1)
               {
                  this.syncBarrackStatus(param1);
               }
               break;
            case PBtype.RESOURCE:
               if(_loc4_ && param1.updateLevel == 0)
               {
                  this.planeCollectResource(param1);
               }
               break;
            case PBtype.CLAN:
               if(_loc4_ && param1.updateLevel != 1)
               {
                  this.syncClanStatus(param1);
               }
               break;
            case PBtype.GUARD:
               if(param1.updateLevel == 0)
               {
                  this.syncGuardStatus(param1,_loc4_);
               }
               break;
            case PBtype.RESEARCH:
               if(_loc4_ && param1.updateLevel == 0)
               {
                  this.syncResearchStatus(param1);
               }
               break;
            case PBtype.LIBRARY:
               if(_loc4_ && param1.updateLevel == 0)
               {
                  this.syncLibraryStatus(param1);
               }
         }
      }
      
      private function syncBarrackStatus(param1:Build) : void
      {
         var _loc2_:Boolean = userProxy.soldierCapacityCur < userProxy.soldierCapacityMax;
         if(_loc2_ != param1.isStatus)
         {
            if(_loc2_)
            {
               param1.setStatus(CircleButton.create(SkinManager.getEmbed("BarrackIcon"),"NoteBg",this.onStatus,param1,CircleButton.sizeStatus50));
            }
            else
            {
               param1.setStatus(null);
            }
         }
      }
      
      public function syncClanStatus(param1:Build) : void
      {
         var _loc2_:CircleButton = null;
         if(Boolean(Facade.userProxy.clanHallPrize) && Facade.userProxy.clanHallPrize.resources.length > 0)
         {
            _loc2_ = CircleButton.create(SkinManager.getEmbed("ClanChest_9"),"EnergyCollectBg",this.onClanStatus,param1,CircleButton.sizeStatus50);
            _loc2_.hint = CostHelper.get18ListString(Facade.userProxy.clanHallPrize.resources);
            param1.setStatus(_loc2_);
         }
         else if(userProxy.clanEnergy > 0)
         {
            param1.setStatus(CircleButton.create(SkinManager.getEmbed("Energy"),"EnergyCollectBg",this.onClanStatus,param1,CircleButton.sizeStatus50));
         }
         else
         {
            param1.setStatus(null);
         }
      }
      
      private function onClanStatus(param1:MouseEvent) : void
      {
         if(Boolean(Facade.userProxy.clanHallPrize) && Facade.userProxy.clanHallPrize.resources.length > 0)
         {
            this.collectClanRes((param1.currentTarget as CircleButton).data as Build);
         }
         else
         {
            this.collectClanEnergy((param1.currentTarget as CircleButton).data as Build);
         }
      }
      
      private function syncGuardStatus(param1:Build, param2:Boolean) : void
      {
         var _loc4_:VProgressBar = null;
         var _loc5_:uint = 0;
         var _loc3_:VOGuardSpec = param1.spec as VOGuardSpec;
         if(_loc3_.chargeCur == 0 && param2)
         {
            if(!param1.isStatus)
            {
               param1.setStatus(CircleButton.create(SkinManager.getEmbed("GuardIcon"),"NoteBg",this.onStatus,param1,CircleButton.sizeStatus50),true);
            }
         }
         else if(_loc3_.chargeCur > 0 && _loc3_.chargeCur < _loc3_.chargeMax)
         {
            _loc4_ = param1.getProgress() as VProgressBar;
            if(!_loc4_)
            {
               _loc4_ = UIFactory.createProgressBar(UIFactory.INDICATOR_GREEN);
               _loc4_.setSize(90,24);
               if(_loc3_.chargeCur > 0)
               {
                  _loc5_ = 1;
                  while(_loc5_ < _loc3_.chargeMax)
                  {
                     _loc4_.add(SkinManager.getEmbed("SeparatorPb",VSkin.STRETCH),{
                        "left":_loc5_ / _loc3_.chargeMax * _loc4_.layoutW - 4,
                        "top":4,
                        "bottom":6
                     });
                     _loc5_++;
                  }
               }
               param1.setProgress(_loc4_,true);
            }
            _loc4_.value = _loc3_.chargeCur / _loc3_.chargeMax;
         }
         else
         {
            param1.setStatus(null);
            param1.setProgress(null);
         }
      }
      
      private function syncResearchStatus(param1:Build) : void
      {
         var _loc3_:String = null;
         var _loc4_:PShopUnit = null;
         var _loc5_:PRequirement = null;
         var _loc2_:Boolean = CoreLogic.getAction(ActionLogic.FINISH_RESEARCH,param1.id) == null;
         if(_loc2_)
         {
            _loc2_ = false;
            for(_loc3_ in userProxy.soldierLevelHash)
            {
               if(!manualProxy.getHeroShop(_loc3_,1,true))
               {
                  _loc4_ = manualProxy.getSoldierShop(_loc3_,userProxy.soldierLevelHash[_loc3_] + 1,true);
                  if((Boolean(_loc4_)) && Boolean(_loc4_.su_can_buy) && _loc4_.su_is_clan == isCapital)
                  {
                     _loc5_ = _loc4_.su_upgrade_requirement;
                     if(userProxy.checkBuild(_loc5_.req_building_kind,_loc5_.req_building_level))
                     {
                        _loc2_ = true;
                        break;
                     }
                  }
               }
            }
         }
         if(param1.isStatus != _loc2_)
         {
            if(_loc2_)
            {
               param1.setStatus(CircleButton.create(SkinManager.getEmbed("ResearchIcon"),"NoteBg",this.onStatus,param1,CircleButton.sizeStatus50),true);
            }
            else
            {
               param1.setStatus(null);
            }
         }
      }
      
      public function syncWorkerStatus(param1:Build) : void
      {
         var _loc3_:ClipPanel = null;
         var _loc2_:Boolean = Boolean(param1.spec);
         if(_loc2_ != param1.isStatus)
         {
            if(_loc2_)
            {
               _loc3_ = new ClipPanel(new RepeatClip(2,1));
               _loc3_.play("fla","zzz");
            }
            param1.setStatus(_loc3_);
         }
      }
      
      private function syncLibraryStatus(param1:Build) : void
      {
         var _loc2_:Boolean = userProxy.spellList.length < manualProxy.getLibraryShop(param1.level).sl_book_size;
         if(_loc2_ != param1.isStatus)
         {
            param1.setStatus(_loc2_ ? CircleButton.create(SkinManager.getEmbed("SpellIcon"),"NoteBg",this.onStatus,param1,CircleButton.sizeStatus50) : null);
         }
      }
      
      private function onStatus(param1:MouseEvent) : void
      {
         this.goInsideBuild((param1.currentTarget as CircleButton).data as Build);
      }
      
      public function stopExAnimation() : void
      {
         var _loc1_:Build = userProxy.buildList.head as Build;
         while(_loc1_)
         {
            _loc1_.isUseAnim = false;
            if(_loc1_.animClip.animation)
            {
               _loc1_.stand();
            }
            _loc1_ = _loc1_.link_next as Build;
         }
      }
      
      private function onRequestEnergy(param1:Build, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:PCost = null;
         if(!param3 && userProxy.clanEnergy > 0 && userProxy.clanEnergy > userProxy.energyMax - userProxy.energy)
         {
            mainMediator.showYesNoDialog(Lang.getPatternString("request_energy_prompt","__ENERGY__",CostHelper.get18String(PCost.CALL,userProxy.energy < userProxy.energyMax ? uint(userProxy.clanEnergy - userProxy.energyMax + userProxy.energy) : userProxy.clanEnergy)),this.onRequestEnergy,[param1,param2,true]);
            return;
         }
         var _loc5_:MapAction = CoreLogic.getAction(ActionLogic.RECOVERY_REQUEST_ENERGY);
         if(_loc5_)
         {
            _loc6_ = _loc5_.time - CoreLogic.serverTime;
            if(!param2)
            {
               ShopLogic.showSpeedupDialog(Lang.getString("request_energy_speedup"),_loc6_,this.onRequestEnergy,[param1,true,param3],SkinManager.getEmbed("CallRequestIcon"));
               return;
            }
            _loc7_ = ShopLogic.getSpeedupCost(_loc6_);
            if(!ShopLogic.checkPrice(_loc7_,this.onRequestEnergy,arguments))
            {
               return;
            }
            ShopLogic.applyCost(_loc7_,true);
            CoreLogic.removeAction(_loc5_);
         }
         if(userProxy.clanEnergy > 0)
         {
            if(userProxy.energy < userProxy.energyMax)
            {
               ShopLogic.setEnergy(userProxy.energyMax - userProxy.energy >= userProxy.clanEnergy ? int(userProxy.clanEnergy) : int(userProxy.energyMax - userProxy.energy));
            }
            userProxy.clanEnergy = 0;
         }
         ActionLogic.request(PUserAction.CLAN_CALL_REQUEST,null);
         ActionLogic.addRecoveryRequestEnergy(param1);
         dispatchCommonEvent(CommonEvent.MY_GAME_STREAM,PRaidEvent.create(PRaidEvent.UPDATE_CALL_REQUEST,PCallRequest.create(Preloader.uid,CoreLogic.serverTime,manualProxy.getClanCapacity(param1.level,true),0,[])));
      }
      
      private function collectClanRes(param1:Build) : void
      {
         Facade.protoProxy.request(new Packet_0010_26(),this.resultCollectClanRes,0,0,[param1]);
         Facade.userProxy.clanHallPrize = null;
         this.syncStatus(param1);
         boardMediator.syncSelected(param1);
      }
      
      private function resultCollectClanRes(param1:BinaryBuffer, param2:Build) : void
      {
         var _loc5_:PCost = null;
         var _loc3_:Packet_0010_27 = new Packet_0010_27(param1);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.value.length)
         {
            _loc5_ = _loc3_.value[_loc4_];
            ShopLogic.applyCost(_loc5_);
            Signal.delayCall(_loc4_ * 0.4,CostHelper.flightMessage,[_loc5_.variance,"+" + _loc5_.value,param2]);
            _loc4_++;
         }
      }
      
      private function collectClanEnergy(param1:Build) : void
      {
         var _loc2_:int = userProxy.energyMax - userProxy.energy;
         if(_loc2_ > 0)
         {
            if(_loc2_ > userProxy.clanEnergy)
            {
               _loc2_ = int(userProxy.clanEnergy);
            }
            ShopLogic.setEnergy(_loc2_);
            userProxy.clanEnergy -= _loc2_;
            boardMediator.syncSelected(param1);
            param1.setStatus(null);
            ActionLogic.request(PUserAction.COLLECT_CLAN_CALLS,_loc2_);
         }
         else
         {
            mainMediator.flightMessage(Lang.getString("not_storage_energy"));
         }
      }
      
      public function syncClanCenter(param1:Boolean = false) : void
      {
         var _loc2_:Build = boardMediator.getSelected() as Build;
         if(Boolean(_loc2_) && _loc2_.type == PBtype.CLAN)
         {
            boardMediator.syncSelected();
            if(param1)
            {
               _loc2_.setProgress(null);
            }
         }
         else
         {
            _loc2_ = userProxy.getBuild(PBtype.CLAN,false);
            if(_loc2_)
            {
               this.syncStatus(_loc2_);
            }
         }
      }
      
      private function onShield(param1:Build) : void
      {
         var _loc2_:VOShieldSpec = param1.spec as VOShieldSpec;
         _loc2_.assignData(CoreLogic.serverTime);
         ActionLogic.addRecoveryShield(param1,false);
         boardMediator.syncSelected(param1);
         ActionLogic.request(PUserAction.ENABLE_SHIELD_GEN,param1.id);
         myMediator.showShield(_loc2_.time,true);
         mainMediator.showDialog(new ShareDialog("ShieldIcon",StringHelper.getTimeDesc(_loc2_.time),"share_shield"));
         param1.stand();
      }
      
      public function onBuyLastArmy(param1:Build) : void
      {
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         if(BarrackMediator.checkLastArmy(_loc2_,_loc3_))
         {
            mainMediator.showDialog(new LastArmyDialog(_loc2_,_loc3_,param1));
         }
      }
      
      private function onSelfAttack(param1:Build) : void
      {
         MainLogic.getFriendMap(Preloader.uid,false,false,BattleMediator.SELF);
      }
   }
}

