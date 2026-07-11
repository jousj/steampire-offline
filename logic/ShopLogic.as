package logic
{
   import engine.Position;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Decor;
   import engine.units.Fence;
   import engine.units.Garbage;
   import engine.units.Unit;
   import engine.units.Worker;
   import game.offer.WorkerOfferDialog;
   import game.shop.AlinkDialog;
   import game.shop.ShareDialog;
   import game.shop.ShopMediator;
   import logic.units.CannonLogic;
   import model.CommonEvent;
   import model.UserProxy;
   import model.ui.VOCallback;
   import model.vo.MapAction;
   import proto.game.family_0010.PUserAction;
   import proto.game.family_0010.Packet_0010_1A;
   import proto.model.PAdventure;
   import proto.model.PBoardObj;
   import proto.model.PBtype;
   import proto.model.PBuildRequierement;
   import proto.model.PCallEffect;
   import proto.model.PCost;
   import proto.model.PJainaMissionInfo;
   import proto.model.PMoneyPriceInfo;
   import proto.model.PObjType;
   import proto.model.PShopBuilding;
   import proto.model.PShopCall;
   import proto.model.PShopCannon;
   import proto.model.PShopDecor;
   import proto.model.PShopFence;
   import proto.model.PShopGarbage;
   import proto.model.PShopOffer;
   import proto.model.PShopResourcesPack;
   import proto.model.PShopShield;
   import proto.model.PShopUnit;
   import proto.model.PSpeedUp;
   import proto.model.PStartStudy;
   import proto.model.i_PJainaEvent;
   import proto.tuples.str_uint;
   import ui.Style;
   import ui.common.BaseDialog;
   import ui.common.DurationPanel;
   import ui.common.MessageDialog;
   import ui.game.PriceButton;
   import ui.game.UnitPanel;
   import ui.vbase.VComponent;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class ShopLogic
   {
      
      public function ShopLogic()
      {
         super();
      }
      
      public static function buy(param1:Object) : void
      {
         var _loc3_:PCost = null;
         var _loc4_:Array = null;
         var _loc7_:PShopBuilding = null;
         var _loc8_:PShopCannon = null;
         var _loc5_:Number = 0;
         if(param1 is PShopBuilding)
         {
            _loc7_ = param1 as PShopBuilding;
            _loc4_ = getCustomPrice(_loc7_.sb_kind,_loc7_.sb_price_list,_loc7_.sb_price);
            _loc5_ = (param1 as PShopBuilding).sb_upgrade_time;
         }
         else if(param1 is PShopCannon)
         {
            _loc8_ = param1 as PShopCannon;
            _loc4_ = getCustomPrice(_loc8_.sc_kind,_loc8_.sc_price_list,_loc8_.sc_price);
            _loc5_ = (param1 as PShopCannon).sc_upgrade_time;
         }
         else if(param1 is PShopFence)
         {
            _loc3_ = (param1 as PShopFence).sf_price;
         }
         else
         {
            if(param1 is PShopCall)
            {
               buyEnergy(param1 as PShopCall);
               return;
            }
            if(param1 is PShopDecor)
            {
               _loc3_ = (param1 as PShopDecor).sd_price;
            }
            else
            {
               if(param1 is PShopShield)
               {
                  buyShield(param1 as PShopShield);
                  return;
               }
               if(param1 is PShopResourcesPack)
               {
                  buyResource(param1 as PShopResourcesPack);
                  return;
               }
               if(param1 is PMoneyPriceInfo)
               {
                  buyGold(param1 as PMoneyPriceInfo);
                  return;
               }
               if(!(param1 is PShopGarbage))
               {
                  return;
               }
            }
         }
         if(Facade.isMissionEditor)
         {
            _loc3_ = PCost.create(0,0);
            _loc4_ = null;
         }
         else if((Boolean(_loc4_) || Boolean(_loc3_)) && !checkPrice(_loc4_ ? _loc4_ : _loc3_,buy,arguments))
         {
            return;
         }
         if(_loc5_ > 0 && !checkWorker(buy,arguments))
         {
            return;
         }
         var _loc6_:Unit = UnitFactory.createConstruction(param1,0,null);
         Facade.boardMediator.addNewObject(_loc6_,false);
         Facade.boardMediator.useMoveState(_loc6_,param1,_loc4_ ? _loc4_ : _loc3_);
         Facade.mainMediator.closeAllDialog();
      }
      
      public static function buyWorker(param1:PShopBuilding) : void
      {
         if(Facade.socialnet == Facade.VZ)
         {
            DialogLogic.openShop(ShopMediator.RESOURCE,param1.sb_kind);
         }
         else
         {
            Facade.mainMediator.showDialog(new WorkerOfferDialog(param1));
         }
      }
      
      private static function buyShield(param1:PShopShield) : void
      {
         if(checkPrice(param1.sh_price,buy,arguments))
         {
            ActionLogic.request(PUserAction.BUY_SHIELD,param1.sh_kind);
            applyCost(param1.sh_price,true);
            Facade.myMediator.showShield(param1.sh_duration,true);
            Facade.mainMediator.searchDialog(ShopMediator,true);
         }
      }
      
      private static function buyResource(param1:PShopResourcesPack) : void
      {
         var _loc2_:uint = Facade.userProxy.getResourcePackCount(param1);
         var _loc3_:uint = CostHelper.getVarianceFromType(param1.rs_type);
         var _loc4_:PCost = getExchangeCost(_loc3_,_loc2_);
         if(checkPrice(_loc4_))
         {
            ActionLogic.request(PUserAction.BUY_RESOURCES_PACK,param1.rs_kind);
            applyCost(_loc4_,true);
            applyCost(PCost.create(_loc3_,_loc2_),false,false);
            Facade.mainMediator.searchDialog(ShopMediator,true);
         }
      }
      
      public static function buyEnergy(param1:PShopCall) : void
      {
         var _loc3_:int = 0;
         if(checkPrice(param1.call_price,buyEnergy,arguments))
         {
            ActionLogic.request(PUserAction.BUY_CALLS,param1.call_num);
            applyCost(param1.call_price,true);
            _loc3_ = param1.call_effect.variance == PCallEffect.FULL ? int(Facade.userProxy.energyMax) : int(param1.call_effect.value);
            setEnergy(_loc3_,true,false);
            Facade.mainMediator.searchDialog(ShopMediator,true);
            Facade.mainMediator.showDialog(new ShareDialog(CostHelper.getKind(PCost.CALL),_loc3_.toString(),"share_ask_energy"));
         }
      }
      
      private static function buyGold(param1:PMoneyPriceInfo) : void
      {
         Facade.protoProxy.request(new Packet_0010_1A());
         Facade.callJS("pay",Facade.socialnet == Facade.FACEBOOK ? param1.num : param1.votes);
         Facade.mainMediator.searchDialog(ShopMediator,true);
      }
      
      public static function getCustomPrice(param1:String, param2:Array, param3:Array) : Array
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(param2)
         {
            _loc4_ = param2.length;
            if(_loc4_ > 0)
            {
               _loc5_ = Facade.userProxy.getConstructionCount(param1);
               if(_loc5_ >= _loc4_)
               {
                  _loc5_ = _loc4_ - 1;
               }
               return param2[_loc5_];
            }
         }
         return param3;
      }
      
      public static function confirmBuy(param1:Unit, param2:Object, param3:Boolean = true) : void
      {
         var _loc5_:uint = 0;
         var _loc7_:PCost = null;
         var _loc8_:Array = null;
         var _loc9_:PShopBuilding = null;
         var _loc10_:PShopCannon = null;
         var _loc4_:UserProxy = Facade.userProxy;
         var _loc6_:Number = 0;
         if(param1 is Build)
         {
            _loc9_ = param2 as PShopBuilding;
            _loc8_ = getCustomPrice(_loc9_.sb_kind,_loc9_.sb_price_list,_loc9_.sb_price);
            _loc6_ = _loc9_.sb_upgrade_time;
            _loc5_ = PObjType.BUILDING;
            (param1 as Build).setUpdateLevel(1);
            if((param1 as Build).type == PBtype.PYLON)
            {
               CannonLogic.checkPylonCannon();
            }
         }
         else if(param1 is Cannon)
         {
            _loc10_ = param2 as PShopCannon;
            _loc8_ = getCustomPrice(_loc10_.sc_kind,_loc10_.sc_price_list,_loc10_.sc_price);
            _loc6_ = _loc10_.sc_upgrade_time;
            _loc5_ = PObjType.CANNON;
            (param1 as Cannon).skipPylonAnim = false;
            (param1 as Cannon).setUpdateLevel(1);
         }
         else if(param1 is Fence)
         {
            _loc7_ = (param2 as PShopFence).sf_price;
            _loc5_ = PObjType.FENCE;
         }
         else if(param1 is Decor)
         {
            _loc7_ = (param2 as PShopDecor).sd_price;
            _loc5_ = PObjType.DECOR;
         }
         else
         {
            if(!(param1 is Garbage))
            {
               throw new Error("ShopLogic.requestBuy not unitType " + param1.toString());
            }
            _loc5_ = PObjType.GARBAGE;
         }
         _loc4_.changeConstructionCount(param1.kind,1);
         param1.id = _loc4_.constructionId++;
         _loc4_.constructionHash[param1.id] = param1;
         if(Facade.isMissionEditor)
         {
            _loc6_ = 0;
            _loc7_ = PCost.create(PCost.CRYSTAL,0);
            _loc8_ = null;
         }
         else if(_loc7_)
         {
            applyCost(_loc7_,true);
         }
         else
         {
            for each(_loc7_ in _loc8_)
            {
               applyCost(_loc7_,true);
            }
         }
         if(_loc6_ > 0)
         {
            ActionLogic.addFinishConstruction(param1,_loc6_);
            Facade.boardMediator.syncSelected(param1);
            Facade.audioProxy.play("begin_building");
         }
         else if(_loc5_ == PObjType.BUILDING || _loc5_ == PObjType.CANNON)
         {
            ActionLogic.finishConstruction(param1);
         }
         else
         {
            Facade.audioProxy.play("construction_complete");
         }
         Facade.dispatchCommonEvent(CommonEvent.NEW_UNIT,true);
         if(!param3)
         {
            return;
         }
         ActionLogic.request(PUserAction.BUY_OBJECT,PBoardObj.create(PObjType.create(_loc5_),param1.kind,new Position(param1.b_x,param1.b_y)));
         if(_loc5_ == PObjType.FENCE)
         {
            if(Facade.userProxy.getConstructionCount(param1.kind) < Facade.userProxy.getConstructionMax(param1.kind) || Facade.isMissionEditor)
            {
               if(_loc4_.isCost(_loc7_) && (_loc6_ == 0 || _loc4_.getFreeWorker() > 0))
               {
                  UnitFactory.fenceLogic.useMultipleBuy(param1 as Fence,param2);
                  return;
               }
            }
         }
         if(_loc6_ == 0)
         {
            Facade.boardMediator.syncSelected(param1);
         }
      }
      
      public static function applyCost(param1:PCost, param2:Boolean = false, param3:Boolean = true) : void
      {
         var _loc4_:uint = param1.variance;
         var _loc5_:int = param1.value;
         if(param2)
         {
            _loc5_ *= -1;
         }
         var _loc6_:UserProxy = Facade.userProxy;
         switch(_loc4_)
         {
            case PCost.OIL:
               _loc6_.setOil(_loc5_,true,param3);
               break;
            case PCost.CRYSTAL:
               _loc6_.setCrystal(_loc5_,true,param3);
               break;
            case PCost.CALL:
               setEnergy(_loc5_,true,param3);
               break;
            case PCost.H_GLORY:
               _loc6_.setGlory(_loc5_,true);
               break;
            case PCost.J_GLORY:
               _loc6_.setJGlory(_loc5_,true);
               break;
            case PCost.MITHRIL:
               _loc6_.setMithril(_loc5_,true,param3);
               break;
            case PCost.EXP:
               _loc6_.setExp(_loc5_,true);
               break;
            case PCost.RAR_DRAGON:
               _loc6_.setRarDragon(_loc5_,true);
               break;
            case PCost.GOLD:
               _loc6_.setGold(_loc5_,true);
               break;
            case PCost.BLUE_PRINT:
               _loc6_.setBlueprint(_loc5_,true);
               break;
            case PCost.RED_ORE:
            case PCost.GREEN_ORE:
            case PCost.BLUE_ORE:
               _loc6_.setOre(_loc5_,true,_loc4_);
               break;
            case PCost.RUBY:
               _loc6_.setRuby(_loc5_,true);
               break;
            default:
               throw new Error("ShopLogic.applyCost need variance " + _loc4_);
         }
      }
      
      public static function applyCostList(param1:Array, param2:Boolean = false, param3:Boolean = true) : void
      {
         var _loc4_:PCost = null;
         for each(_loc4_ in param1)
         {
            applyCost(_loc4_,param2,param3);
         }
      }
      
      public static function setEnergy(param1:int, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc4_:UserProxy = null;
         _loc4_ = Facade.userProxy;
         if(param2)
         {
            param1 += _loc4_.energy;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param3)
         {
            param1 = _loc4_.calcLimitResource(_loc4_.energy,param1,_loc4_.energyMax);
         }
         if(_loc4_.energy != param1)
         {
            if(_loc4_.energy >= _loc4_.energyMax && param1 < _loc4_.energyMax)
            {
               ActionLogic.addRecoveryEnergy();
            }
            else if(_loc4_.energy < _loc4_.energyMax && param1 >= _loc4_.energyMax)
            {
               CoreLogic.removeFilterActions(0,ActionLogic.RECOVERY_ENERGY);
            }
            _loc4_.energy = param1;
            Facade.dispatchCommonEvent(CommonEvent.ENERGY,_loc4_.energy,PCost.CALL);
         }
      }
      
      public static function getSpeedupGold(param1:Number, param2:uint = 0, param3:uint = 0) : uint
      {
         var _loc4_:Number = NaN;
         if(param1 < 0)
         {
            param1 = 0;
         }
         else
         {
            if(param3 == ActionLogic.RECOVERY_HERO)
            {
               _loc4_ = 70;
            }
            else
            {
               _loc4_ = 400;
            }
            param1 = Math.round(param1 / _loc4_ * (1 / Math.pow(param1 / 85,0.25)) + 0.21);
         }
         return param1 < param2 ? param2 : uint(param1);
      }
      
      public static function getSpeedupFreeTime() : Number
      {
         return 127;
      }
      
      public static function getSpeedupCost(param1:Number, param2:uint = 0, param3:uint = 0) : PCost
      {
         return PCost.create(PCost.GOLD,getSpeedupGold(param1,param2,param3));
      }
      
      public static function getExchangeCost(param1:uint, param2:uint, param3:PCost = null) : PCost
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(param1 == PCost.CRYSTAL || param1 == PCost.OIL)
         {
            if(Facade.isCapital)
            {
               _loc5_ = 100;
               _loc6_ = 0.325;
            }
            else
            {
               _loc5_ = 20;
               _loc6_ = 0.595;
            }
            param2 = Math.round(param2 / _loc5_ * (1 / Math.pow(param2 / 100,_loc6_)));
         }
         else
         {
            _loc4_ = 0.3;
            if(param1 == PCost.H_GLORY || param1 == PCost.J_GLORY)
            {
               _loc5_ = 1;
               _loc6_ = 5;
            }
            else if(param1 == PCost.MITHRIL)
            {
               _loc5_ = Facade.isCapital ? 25 : 10;
               _loc6_ = 100;
            }
            else if(param1 == PCost.BLUE_PRINT)
            {
               _loc5_ = 10;
               _loc6_ = 100;
               _loc4_ = 0.225;
            }
            else if(param1 == PCost.RED_ORE)
            {
               _loc5_ = 0.5;
               _loc6_ = 2.5;
            }
            else if(param1 == PCost.GREEN_ORE)
            {
               _loc5_ = 2;
               _loc6_ = 10;
            }
            else
            {
               if(param1 != PCost.BLUE_ORE)
               {
                  throw new Error("getExchangeCost bad variance: " + param1);
               }
               _loc5_ = 10;
               _loc6_ = 50;
            }
            param2 = Math.round(param2 * _loc5_ * (1 / Math.pow(param2 * _loc6_,_loc4_)));
         }
         if(param2 == 0)
         {
            param2 = 1;
         }
         if(param3)
         {
            param3.value += param2;
         }
         else
         {
            param3 = PCost.create(PCost.GOLD,param2);
         }
         return param3;
      }
      
      public static function checkWorker(param1:Function = null, param2:Array = null) : Boolean
      {
         var _loc4_:Worker = null;
         var _loc5_:Worker = null;
         var _loc6_:PShopBuilding = null;
         var _loc3_:UserProxy = Facade.userProxy;
         if(_loc3_.getFreeWorker() == 0)
         {
            if(_loc3_.workerMax == 0)
            {
               Facade.mainMediator.showMessage(Lang.getString("need_worker_build"));
               return false;
            }
            _loc4_ = null;
            _loc5_ = _loc3_.workerList.head as Worker;
            while(_loc5_)
            {
               if(!_loc5_.isFree)
               {
                  if(!_loc4_ || _loc5_.endTime < _loc4_.endTime)
                  {
                     _loc4_ = _loc5_;
                  }
               }
               _loc5_ = _loc5_.link_next as Worker;
            }
            if(_loc4_)
            {
               for each(_loc6_ in Facade.manualProxy.buildShopList)
               {
                  if(_loc6_.sb_level == 1 && _loc6_.sb_can_buy && _loc6_.sb_btype.variance == PBtype.WORKER)
                  {
                     break;
                  }
                  _loc6_ = null;
               }
               showActionSpeedupDialog(_loc4_.targetId,_loc4_.actionVariance,Lang.getString("workers_busy"),param1,param2,_loc6_);
            }
            return false;
         }
         return true;
      }
      
      public static function showActionSpeedupDialog(param1:Object, param2:uint, param3:String = null, param4:Function = null, param5:Array = null, param6:PShopBuilding = null) : void
      {
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         var _loc12_:Unit = null;
         var _loc13_:PShopUnit = null;
         if(param1 is Unit)
         {
            _loc12_ = param1 as Unit;
         }
         else
         {
            _loc12_ = Facade.userProxy.constructionHash[uint(param1)] as Unit;
         }
         var _loc7_:MapAction = CoreLogic.getAction(param2,_loc12_.id);
         if(!_loc7_)
         {
            return;
         }
         var _loc8_:Number = _loc7_.time - CoreLogic.serverTime;
         if(_loc8_ <= 0 || getSpeedupGold(_loc8_,0,param2) == 0)
         {
            onConfirmSpeedup(_loc12_.id,param2,param4,param5);
            return;
         }
         if(param2 == ActionLogic.FINISH_RESEARCH || param2 == ActionLogic.RECOVERY_HERO)
         {
            _loc13_ = _loc7_.value as PShopUnit;
            _loc9_ = _loc13_.su_kind;
            _loc10_ = _loc13_.su_model_level;
            if(param2 == ActionLogic.FINISH_RESEARCH)
            {
               if(!Facade.isCapital)
               {
                  Facade.mainMediator.showDialog(new AlinkDialog().useSpeedupMode(true,_loc12_.id,_loc9_,_loc13_.su_level,_loc8_,onConfirmSpeedup,[_loc12_.id,param2,param4,param5],null,_loc10_));
                  return;
               }
               _loc11_ = Lang.getPatternString("speedup_study","__NAME__",StringHelper.getUnitName(_loc9_,_loc13_.su_level));
            }
            else
            {
               _loc11_ = Boolean(param4) ? Lang.getPatternString("hero_raid_speedup_text","__NAME__",StringHelper.getUnitName(_loc9_,_loc13_.su_level)) : Lang.getPatternString("speedup_hero","__NAME__",StringHelper.getUnitName(_loc9_,_loc13_.su_level));
            }
         }
         else
         {
            _loc9_ = _loc12_.kind;
            _loc10_ = _loc12_.level;
            if(param2 == ActionLogic.FINISH_CONSTRUCTION)
            {
               if(_loc12_ is Build)
               {
                  _loc10_ = (_loc12_ as Build).updateLevel;
               }
               else if(_loc12_ is Cannon)
               {
                  _loc10_ = (_loc12_ as Cannon).updateLevel;
               }
               if(!Facade.isCapital)
               {
                  Facade.mainMediator.showDialog(new AlinkDialog().useSpeedupMode(false,_loc12_.id,_loc9_,_loc10_,_loc8_,onConfirmSpeedup,[_loc12_.id,param2,param4,param5],param6));
                  return;
               }
               _loc11_ = Lang.getPatternString("speedup_build","__NAME__",StringHelper.getUnitName(_loc9_,_loc10_));
            }
            else
            {
               if(param2 != ActionLogic.CLEANUP_GARBAGE)
               {
                  throw new Error("showSpeedupDialog bad actionVariance: " + param2);
               }
               _loc11_ = Lang.getPatternString("speedup_garbage","__NAME__","<span" + Style.darkKhakiColor + ">" + Lang.getString(_loc9_) + "</span>");
            }
         }
         showSpeedupDialog(_loc11_,_loc8_,onConfirmSpeedup,[_loc12_.id,param2,param4,param5],UnitPanel.createForMessage(_loc9_,_loc10_),0,param3,MessageDialog.UNIT_ICON,param2);
      }
      
      public static function onConfirmSpeedup(param1:uint, param2:uint, param3:Function, param4:Array) : void
      {
         var _loc5_:MapAction = CoreLogic.getAction(param2,param1);
         if(_loc5_)
         {
            if(useSpeedup(param1,param2,getSpeedupCost(_loc5_.time - CoreLogic.serverTime,0,_loc5_.variance)) && param3 != null)
            {
               param3.apply(null,param4);
            }
         }
      }
      
      private static function useSpeedup(param1:uint, param2:uint, param3:PCost) : Boolean
      {
         var _loc5_:uint = 0;
         if(checkPrice(param3,useSpeedup,arguments))
         {
            _loc5_ = param2;
            if(_loc5_ == ActionLogic.FINISH_CONSTRUCTION)
            {
               _loc5_ = Facade.userProxy.constructionHash[param1] is Build ? PUserAction.SPEED_UP_BUILDING : PUserAction.SPEED_UP_CANNON;
            }
            else if(_loc5_ == ActionLogic.FINISH_RESEARCH)
            {
               _loc5_ = PUserAction.SPEED_UP_STUDY;
            }
            else if(_loc5_ == ActionLogic.CLEANUP_GARBAGE)
            {
               _loc5_ = PUserAction.SPEED_UP_GARBAGE;
            }
            else
            {
               if(_loc5_ != ActionLogic.RECOVERY_HERO)
               {
                  throw new Error("bad useSpeedup variance");
               }
               _loc5_ = PUserAction.SPEED_UP_HERO;
            }
            applyCost(param3,true);
            CoreLogic.removeFilterActions(param1,param2,true);
            ActionLogic.request(_loc5_,PSpeedUp.create(param1,param3));
            return true;
         }
         return false;
      }
      
      public static function checkCostAndWorker(param1:Object, param2:Function = null, param3:Array = null, param4:Boolean = true) : Boolean
      {
         return checkPrice(param1,param2,param3) && (!param4 || checkWorker(param2,param3));
      }
      
      public static function applySoldierList(param1:Array) : void
      {
         var _loc3_:str_uint = null;
         var _loc2_:UserProxy = Facade.userProxy;
         for each(_loc3_ in param1)
         {
            _loc2_.soldierCapacityCur += Facade.manualProxy.getSoldierShop(_loc3_.field_0,1).su_hspace * _loc3_.field_1;
            _loc2_.soldierCountHash[_loc3_.field_0] += _loc3_.field_1;
         }
      }
      
      public static function showCancelDialog(param1:Unit, param2:uint, param3:uint = 0, param4:String = null) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(param3 == 0)
         {
            param3 = param1.level;
         }
         if(!param4)
         {
            param4 = param1.kind;
         }
         if(param2 == ActionLogic.FINISH_CONSTRUCTION)
         {
            _loc6_ = "cancel_build";
            _loc7_ = StringHelper.getUnitName(param4,param3);
         }
         else
         {
            if(param2 == ActionLogic.FINISH_RESEARCH)
            {
               _loc6_ = "cancel_study";
            }
            else
            {
               if(param2 != ActionLogic.CLEANUP_GARBAGE)
               {
                  throw new Error("showCancelDialog bad actionVariance: " + param2);
               }
               _loc6_ = "cancel_garbage";
            }
            _loc7_ = "<span" + Style.darkKhakiColor + ">" + Lang.getString(param4) + "</span>";
         }
         var _loc5_:UnitPanel = new UnitPanel(UnitPanel.FEATURE_MODE);
         UnitPanel.feature(_loc5_,param4);
         _loc5_.show(param4,param3);
         Facade.mainMediator.showYesNoDialog(Lang.getPatternString(_loc6_,"__NAME__",_loc7_),onConfirmCancel,[param1,param2],Lang.getString("move_cancel"),_loc5_,MessageDialog.UNIT_ICON);
      }
      
      public static function onConfirmCancel(param1:Unit, param2:uint, param3:Boolean = true) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:Array = null;
         var _loc7_:PCost = null;
         var _loc8_:PShopUnit = null;
         var _loc4_:MapAction = CoreLogic.getAction(param2,param1.id);
         if(_loc4_)
         {
            if(param2 == ActionLogic.FINISH_CONSTRUCTION)
            {
               if(param1 is Build)
               {
                  _loc5_ = (param1 as Build).updateLevel == 1;
                  _loc6_ = Facade.manualProxy.getBuildShop(param1.kind,_loc5_ ? 1 : uint(param1.level + 1)).sb_price;
                  if(param3)
                  {
                     ActionLogic.request(PUserAction.CANCEL_CONSTRUCTING_BUILDING,param1.id);
                  }
               }
               else
               {
                  if(!(param1 is Cannon))
                  {
                     return;
                  }
                  _loc5_ = (param1 as Cannon).updateLevel == 1;
                  _loc6_ = Facade.manualProxy.getCannonShop(param1.kind,_loc5_ ? 1 : uint(param1.level + 1)).sc_price;
                  if(param3)
                  {
                     ActionLogic.request(PUserAction.CANCEL_CONSTRUCTING_CANNON,param1.id);
                  }
               }
               ActionLogic.finishConstruction(param1,true);
               if(_loc5_)
               {
                  UnitFactory.removeConstruction(param1);
                  Facade.userProxy.changeConstructionCount(param1.kind,-1);
               }
            }
            else if(param2 == ActionLogic.CLEANUP_GARBAGE)
            {
               if(param3)
               {
                  ActionLogic.request(PUserAction.CANCEL_REMOVE_GARBAGE,param1.id);
               }
               param1.setProgress(null);
               UnitFactory.removeWorker(param1.id);
               (param1 as Garbage).cleaning = false;
               Facade.boardMediator.syncSelected(param1);
               _loc7_ = (param1 as Garbage).shop.sg_remove_price;
            }
            else
            {
               if(param2 != ActionLogic.FINISH_RESEARCH)
               {
                  return;
               }
               _loc8_ = _loc4_.value as PShopUnit;
               if(param3)
               {
                  ActionLogic.request(PUserAction.CANCEL_STUDY,PStartStudy.create(param1.id,_loc8_.su_kind));
               }
               Facade.dispatchCommonEvent(CommonEvent.FINISH_RESEARCH,_loc8_.su_kind,param1.id);
               for each(_loc7_ in _loc8_.su_upgrade_price)
               {
                  applyCancelCost(_loc7_);
               }
               _loc7_ = null;
            }
            if(_loc7_)
            {
               applyCancelCost(_loc7_);
            }
            for each(_loc7_ in _loc6_)
            {
               applyCancelCost(_loc7_);
            }
            CoreLogic.removeAction(_loc4_);
         }
      }
      
      private static function applyCancelCost(param1:PCost) : void
      {
         applyCost(PCost.create(param1.variance,Math.round(param1.value / 2)),false,false);
      }
      
      public static function checkPrice(param1:Object, param2:Function = null, param3:Array = null) : Boolean
      {
         var _loc5_:PCost = null;
         var _loc6_:BaseDialog = null;
         var _loc7_:Array = null;
         var _loc8_:PCost = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc4_:UserProxy = Facade.userProxy;
         if(param1 is Array && param1.length == 1)
         {
            param1 = param1[0];
         }
         if(param1 is Array)
         {
            _loc7_ = null;
            for each(_loc8_ in param1 as Array)
            {
               _loc9_ = _loc8_.variance;
               _loc10_ = _loc4_.checkCost(_loc9_,_loc8_.value);
               if(_loc9_ == PCost.GOLD && _loc10_ > 0)
               {
                  Facade.mainMediator.showMessage(Lang.getPatternString("not_capital_gold","__COST__",CostHelper.getClanString(_loc9_,_loc10_,true)),Lang.getString("not_enough_title"),CostHelper.getMessageSkin(_loc9_));
                  return false;
               }
               if(_loc10_ > 0)
               {
                  if(checkBuyLock(_loc9_,_loc10_))
                  {
                     return false;
                  }
                  if(!_loc5_)
                  {
                     _loc5_ = PCost.create(PCost.GOLD,0);
                  }
                  getExchangeCost(_loc9_,_loc10_,_loc5_);
                  if(_loc10_ != _loc8_.value)
                  {
                     _loc8_ = PCost.create(_loc9_,_loc10_);
                  }
                  if(_loc7_)
                  {
                     _loc7_.push(_loc8_);
                  }
                  else
                  {
                     _loc7_ = [_loc8_];
                  }
               }
            }
            if(!_loc7_)
            {
               return true;
            }
            _loc8_ = _loc7_[0];
         }
         else
         {
            _loc8_ = param1 as PCost;
            _loc9_ = _loc8_.variance;
            _loc10_ = _loc4_.checkCost(_loc9_,_loc8_.value);
            if(_loc10_ == 0)
            {
               return true;
            }
            if(_loc9_ == PCost.GOLD)
            {
               if(Facade.isCapital)
               {
                  Facade.mainMediator.showMessage(Lang.getPatternString("not_capital_gold","__COST__",CostHelper.getClanString(_loc9_,_loc10_,true)),Lang.getString("not_enough_title"),CostHelper.getMessageSkin(_loc9_));
               }
               else if(Facade.socialnet == Facade.VZ)
               {
                  openVZBuy();
               }
               else
               {
                  showShopCurrencyMessage(_loc9_,_loc10_);
               }
               return false;
            }
            if(checkBuyLock(_loc9_,_loc10_))
            {
               return false;
            }
            _loc5_ = getExchangeCost(_loc9_,_loc10_);
            _loc8_ = PCost.create(_loc9_,_loc10_);
         }
         _loc9_ = _loc8_.variance;
         if(!_loc7_ && (_loc9_ == PCost.CRYSTAL || _loc9_ == PCost.OIL) && !Facade.isCapital)
         {
            _loc6_ = new AlinkDialog();
            (_loc6_ as AlinkDialog).useResourceMode(_loc8_,_loc5_,onBuyPrice,[_loc5_,_loc8_,VOCallback.create(param2,param3)]);
         }
         else
         {
            _loc6_ = new MessageDialog(Lang.getPatternString("not_enough_cost","__COST__",_loc7_ ? CostHelper.get18ListString(_loc7_,true) : (Facade.isCapital ? CostHelper.getClanString(_loc9_,_loc8_.value,true) : CostHelper.get18StringC(_loc8_,true))),Lang.getString("not_enough_title"),!_loc7_ || _loc7_.length == 1 ? CostHelper.getMessageSkin(_loc9_) : null);
            (_loc6_ as MessageDialog).addDelegateButton(new PriceButton().assignCost(_loc5_),onBuyPrice,[_loc5_,_loc7_ ? _loc7_ : _loc8_,VOCallback.create(param2,param3)]);
         }
         Facade.mainMediator.showDialog(_loc6_);
         return false;
      }
      
      private static function checkBuyLock(param1:uint, param2:uint) : Boolean
      {
         if(param1 == PCost.RAR_DRAGON)
         {
            showBuyLockMessage("rar_dragon_price",param1,param2);
         }
         else
         {
            if(param1 != PCost.MITHRIL)
            {
               return false;
            }
            showBuyLockMessage("mithril_price",param1,param2);
         }
         return true;
      }
      
      public static function showBuyLockMessage(param1:String, param2:uint, param3:uint) : void
      {
         Facade.mainMediator.showMessage(Lang.getPatternString(param1,"__COST__",!Facade.isCapital ? CostHelper.get18String(param2,param3,true) : CostHelper.getClanString(param2,param3,true)),Lang.getString("not_enough_title"));
      }
      
      private static function showShopCurrencyMessage(param1:uint, param2:uint) : void
      {
         Facade.mainMediator.showYesNoDialog(Lang.getPatternString("not_enough_gold","__COST__",CostHelper.get18String(param1,param2,true)),DialogLogic.openShop,[ShopMediator.CURRENCY],Lang.getString("not_enough_title"),CostHelper.getMessageSkin(param1));
      }
      
      public static function openVZBuy() : void
      {
         Facade.callJS("setSelectedTab",1);
      }
      
      private static function applyBuyCost(param1:PCost) : void
      {
         applyCost(param1,false,false);
         if(param1.variance == PCost.CALL)
         {
            ActionLogic.request(PUserAction.BUY_CALLS,param1.value);
         }
         else
         {
            ActionLogic.request(PUserAction.BUY_RESOURCE_BY_GOLD,param1);
         }
      }
      
      public static function onBuyPrice(param1:PCost, param2:Object, param3:VOCallback = null) : void
      {
         var _loc4_:PCost = null;
         if(checkPrice(param1))
         {
            applyCost(param1,true);
            if(param2 is Array)
            {
               for each(_loc4_ in param2 as Array)
               {
                  applyBuyCost(_loc4_);
               }
            }
            else
            {
               applyBuyCost(param2 as PCost);
            }
            if(param3)
            {
               param3.apply();
            }
         }
      }
      
      public static function callBackPriceInfoFB(param1:Array, param2:Array = null, param3:Array = null) : void
      {
         var _loc5_:Object = null;
         var _loc6_:ShopMediator = null;
         var _loc7_:PMoneyPriceInfo = null;
         var _loc8_:PShopOffer = null;
         var _loc4_:Array = Facade.manualProxy.goldShopList;
         if(_loc4_)
         {
            _loc4_.length = 0;
         }
         else
         {
            Facade.manualProxy.goldShopList = _loc4_ = [];
         }
         for each(_loc5_ in param1)
         {
            _loc7_ = new PMoneyPriceInfo();
            _loc7_.caption = _loc5_.caption;
            _loc7_.votes = _loc5_.votes;
            _loc7_.num = _loc5_.num;
            _loc7_.money = _loc5_.money;
            _loc4_.push(_loc7_);
         }
         for each(_loc5_ in param3)
         {
            for each(_loc8_ in Facade.manualProxy.offerShopList)
            {
               if(_loc8_.offer_kind == _loc5_.num)
               {
                  _loc8_.offer_social_price = _loc5_.votes;
                  _loc8_.caption = _loc5_.caption;
                  break;
               }
            }
         }
         _loc6_ = Facade.mainMediator.searchDialog(ShopMediator);
         if(_loc6_)
         {
            _loc6_.invalidateTab(ShopMediator.CURRENCY);
         }
      }
      
      public static function showSpeedupDialog(param1:String, param2:Number, param3:Function, param4:Array, param5:VComponent = null, param6:uint = 0, param7:String = null, param8:uint = 0, param9:uint = 0) : MessageDialog
      {
         var _loc10_:MessageDialog = new MessageDialog(param1,param7 ? param7 : Lang.getString("speedup"),param5,param8);
         _loc10_.box.add(new DurationPanel(40).setTrackTime(param2));
         _loc10_.addDelegateButton(new PriceButton().assignTime(param2,0,param6,param9),param3,param4);
         _loc10_.addCloseSignal(param2);
         Facade.mainMediator.showDialog(_loc10_);
         return _loc10_;
      }
      
      public static function showExchangeDialog(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:AlinkDialog = new AlinkDialog();
         var _loc5_:PCost = PCost.create(param1,param2);
         var _loc6_:PCost = getExchangeCost(param1,param2);
         var _loc7_:PCost = PCost.create(param1,param3);
         var _loc8_:PCost = getExchangeCost(param1,param3);
         _loc4_.useExchangeMode(_loc5_,_loc6_,_loc7_,_loc8_,VOCallback.create(onBuyPrice,[_loc6_,_loc5_]),VOCallback.create(onBuyPrice,[_loc8_,_loc7_]));
         Facade.mainMediator.showDialog(_loc4_);
      }
      
      public static function checkRequierementList(param1:Array) : Boolean
      {
         var _loc2_:PBuildRequierement = null;
         for each(_loc2_ in param1)
         {
            if(!checkRequierement(_loc2_))
            {
               return false;
            }
         }
         return true;
      }
      
      public static function checkRequierement(param1:PBuildRequierement) : Boolean
      {
         if(param1.variance == PBuildRequierement.JAINA_MISSION)
         {
            return checkJainaRequierement(param1.value);
         }
         return true;
      }
      
      private static function checkJainaRequierement(param1:String) : Boolean
      {
         var _loc2_:PJainaMissionInfo = null;
         var _loc3_:i_PJainaEvent = null;
         var _loc4_:PAdventure = null;
         for each(_loc2_ in Facade.manualProxy.jainaMissionList)
         {
            if(_loc2_.jmi_mission == param1)
            {
               for each(_loc3_ in Facade.userProxy.jainaEventList)
               {
                  if(_loc3_.field_0 == _loc2_.jmi_event_id)
                  {
                     if(_loc2_.jmi_number < _loc3_.field_1.je_mission || _loc2_.jmi_number == _loc3_.field_1.je_mission && _loc3_.field_1.je_mission_finished)
                     {
                        return true;
                     }
                     break;
                  }
               }
               for each(_loc4_ in Facade.userProxy.adventureList)
               {
                  if(_loc4_.event_id == _loc2_.jmi_event_id)
                  {
                     if(_loc4_.level > 1 || _loc4_.current_mission > _loc2_.jmi_number)
                     {
                        return true;
                     }
                     break;
                  }
               }
            }
         }
         return false;
      }
      
      public static function getMulCost(param1:PCost, param2:Number) : PCost
      {
         return PCost.create(param1.variance,param1.value * param2);
      }
      
      public static function getMulCosts(param1:Array, param2:Number) : Array
      {
         var _loc4_:PCost = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param1)
         {
            _loc3_.push(getMulCost(_loc4_,param2));
         }
         return _loc3_;
      }
   }
}

