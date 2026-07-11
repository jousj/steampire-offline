package game.barrack
{
   import engine.units.Build;
   import flash.events.MouseEvent;
   import game.common.DialogMediator;
   import game.feature.FeatureMediator;
   import game.my.MyPanel;
   import game.shop.ShopMediator;
   import logic.ActionLogic;
   import logic.DialogLogic;
   import logic.MainLogic;
   import logic.ShopLogic;
   import logic.UnitFactory;
   import logic.training.AbstractTrain;
   import logic.training.BlackoutClickStep;
   import model.CommonEvent;
   import model.ManualProxy;
   import model.UserProxy;
   import model.ui.VOBarrackItem;
   import model.ui.VOBattleItem;
   import model.vo.VOStorageSpec;
   import proto.game.family_0010.PMakeUnit;
   import proto.game.family_0010.PUserAction;
   import proto.game.family_0010.Packet_0010_19;
   import proto.model.PAction;
   import proto.model.PBtype;
   import proto.model.PCost;
   import proto.model.PCostt;
   import proto.model.PKindCount;
   import proto.model.PMoneyPriceInfo;
   import proto.model.PShopResourcesPack;
   import proto.model.PShopUnit;
   import proto.model.PUnitsPackInfo;
   import proto.tuples.str_i;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.VButton;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import utils.CostHelper;
   
   public class BarrackMediator extends DialogMediator
   {
      
      public var build:Build;
      
      public var dialog:BarrackDialog;
      
      private const buyDp:Array = [];
      
      private const buyClanDp:Array = [];
      
      private const buyGoldDp:Array = [];
      
      private const prodDp:Array = [];
      
      private var savedPack:PUnitsPackInfo;
      
      private var toKind:String;
      
      private var saveTabIndex:uint;
      
      private var arrowSkin:VSkin;
      
      private var isChange:Boolean;
      
      public function BarrackMediator(param1:Build, param2:String = null)
      {
         super();
         this.build = param1;
         this.toKind = param2;
      }
      
      public static function soldierSort(param1:VOBarrackItem, param2:VOBarrackItem) : Number
      {
         return param1.shop.order - param2.shop.order;
      }
      
      public static function filterLastArmy() : void
      {
         var _loc2_:ManualProxy = null;
         var _loc3_:* = 0;
         var _loc4_:PShopUnit = null;
         var _loc1_:UserProxy = Facade.userProxy;
         if(_loc1_.lastArmyList)
         {
            _loc2_ = Facade.manualProxy;
            _loc3_ = int(_loc1_.lastArmyList.length - 1);
            for(; _loc3_ >= 0; _loc3_--)
            {
               _loc4_ = _loc2_.getSoldierShop((_loc1_.lastArmyList[_loc3_] as PKindCount).kind,1,true);
               if(Boolean((_loc4_) && _loc4_.su_can_buy && !_loc4_.su_is_hero) && Boolean(_loc1_.soldierLevelHash[_loc4_.su_kind] > 0) && _loc4_.su_kind != "un_zombie")
               {
                  if(!_loc4_.su_is_clan || Boolean(_loc1_.clan) && Boolean(_loc1_.clan.uc_units_can_buy.indexOf(_loc4_.su_kind) >= 0))
                  {
                     continue;
                  }
               }
               _loc1_.lastArmyList.splice(_loc3_,1);
            }
         }
      }
      
      public static function checkLastArmy(param1:Array = null, param2:Array = null) : Boolean
      {
         var _loc7_:PKindCount = null;
         var _loc8_:uint = 0;
         var _loc9_:PShopUnit = null;
         var _loc10_:VOBattleItem = null;
         var _loc3_:UserProxy = Facade.userProxy;
         var _loc4_:ManualProxy = Facade.manualProxy;
         var _loc5_:int = _loc3_.soldierCapacityMax - _loc3_.soldierCapacityCur;
         var _loc6_:Boolean = false;
         if(_loc5_ > 0)
         {
            for each(_loc7_ in _loc3_.lastArmyList)
            {
               _loc8_ = uint(_loc3_.soldierCountHash[_loc7_.kind]);
               if(_loc7_.count > _loc8_)
               {
                  _loc9_ = _loc4_.getSoldierShop(_loc7_.kind);
                  if(_loc5_ >= _loc9_.su_hspace)
                  {
                     _loc6_ = true;
                     if(param1)
                     {
                        _loc10_ = new VOBattleItem();
                        _loc10_.shop = _loc9_;
                        _loc10_.count = _loc7_.count - _loc8_;
                        _loc8_ = _loc5_ / _loc9_.su_hspace;
                        if(_loc8_ < _loc10_.count)
                        {
                           _loc10_.count = _loc8_;
                        }
                        _loc8_ = _loc10_.count * _loc9_.su_hspace;
                        _loc5_ -= _loc8_;
                        param1.push(_loc10_);
                        CostHelper.addCostToList(param2,_loc9_.su_price.variance,_loc9_.su_price.value * _loc10_.count);
                     }
                  }
               }
            }
         }
         return _loc6_;
      }
      
      public static function sellClanArmy() : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:PShopUnit = null;
         var _loc1_:UserProxy = Facade.userProxy;
         var _loc2_:ManualProxy = Facade.manualProxy;
         for(_loc4_ in _loc1_.soldierCountHash)
         {
            _loc5_ = uint(_loc1_.soldierCountHash[_loc4_]);
            if(_loc5_ > 0)
            {
               _loc6_ = _loc2_.getSoldierShop(_loc4_);
               if(_loc6_.su_is_clan)
               {
                  _loc1_.soldierCountHash[_loc4_] = 0;
                  _loc1_.soldierCapacityCur -= _loc6_.su_hspace * _loc5_;
                  if(!_loc3_)
                  {
                     _loc3_ = [];
                  }
                  CostHelper.addCostToList(_loc3_,_loc6_.su_price.variance,_loc6_.su_price.value * _loc5_);
                  CostHelper.addCostToList(_loc3_,PCost.CALL,_loc6_.su_hspace * _loc5_);
                  ActionLogic.request(PUserAction.REMOVE_UNIT,PMakeUnit.create(_loc6_.su_kind,_loc5_));
               }
            }
         }
         if(_loc3_)
         {
            ShopLogic.applyCostList(_loc3_);
            filterLastArmy();
         }
         Facade.mainMediator.searchDialog(BarrackDialog,true);
         Facade.mainMediator.searchDialog(LastArmyDialog,true);
      }
      
      override public function onAdd() : BaseDialog
      {
         var _loc1_:PShopUnit = null;
         var _loc2_:PUnitsPackInfo = null;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         var _loc6_:VOBarrackItem = null;
         var _loc7_:int = 0;
         var _loc8_:str_i = null;
         var _loc9_:String = null;
         for each(_loc1_ in mp.soldierShopList)
         {
            if(_loc1_.su_level == 1 && _loc1_.su_can_buy && !_loc1_.su_is_hero)
            {
               if(!(Boolean(_loc1_.su_event_requirement) && !ShopLogic.checkRequierement(_loc1_.su_event_requirement)))
               {
                  _loc6_ = new VOBarrackItem();
                  _loc7_ = int(up.soldierLevelHash[_loc1_.su_kind]);
                  if(_loc1_.su_is_clan)
                  {
                     if(!up.clan || up.clan.uc_units_can_buy.indexOf(_loc1_.su_kind) < 0)
                     {
                        _loc7_ = 0;
                     }
                  }
                  _loc6_.isResearchLock = _loc7_ == 0;
                  _loc6_.shop = _loc7_ > 1 ? mp.getSoldierShop(_loc1_.su_kind,_loc7_) : _loc1_;
                  if(_loc1_.su_is_clan)
                  {
                     this.buyClanDp.push(_loc6_);
                  }
                  else
                  {
                     this.buyDp.push(_loc6_);
                     if(_loc1_.su_kind == "un_zombie")
                     {
                        _loc6_.isHide = true;
                     }
                  }
               }
            }
         }
         for each(_loc2_ in mp.soldierGoldShopList)
         {
            _loc6_ = new VOBarrackItem();
            _loc8_ = _loc2_.up_units[0];
            _loc6_.specialPack = _loc2_;
            _loc6_.shop = mp.getSoldierShop(_loc8_.field_0,up.soldierLevelHash[_loc8_.field_0]);
            this.buyGoldDp.push(_loc6_);
         }
         this.buyDp.sort(soldierSort);
         this.buyClanDp.sort(soldierSort);
         this.buyGoldDp.sort(soldierSort);
         _loc3_ = 0;
         _loc7_ = 0;
         _loc4_ = Boolean(this.toKind);
         if(_loc4_)
         {
            _loc7_ = this.getDpIndex(this.buyDp);
            if(_loc7_ < 0)
            {
               _loc7_ = this.getDpIndex(this.buyClanDp);
               if(_loc7_ >= 0 && Boolean(up.clan))
               {
                  _loc3_ = 1;
               }
               else
               {
                  _loc7_ = 0;
                  _loc4_ = false;
                  this.toKind = null;
               }
            }
         }
         else
         {
            _loc3_ = uint(getDialogSetting());
            if(_loc3_ == 1 && !up.clan)
            {
               _loc3_ = 0;
            }
         }
         var _loc5_:Boolean = false;
         if(Facade.checkUserStage("home4_hero_click"))
         {
            _loc9_ = up.getCustomData("first_barrack_open");
            if(!_loc9_)
            {
               _loc5_ = true;
            }
         }
         this.dialog = new BarrackDialog(this.build.kind,this.build.level,_loc3_,_loc5_);
         this.dialog.oilPanel.setMax(up.oilMax);
         this.dialog.goldPanel.addBuyBt(this.onResourcePackBuy);
         this.dialog.mithrilPanel.setMax(Facade.references.mithril_limit,false);
         this.dialog.mithrilPanel.useTrack();
         this.sync(false,false);
         this.dialog.prodGrid.setDataProvider(this.prodDp);
         this.dialog.buyGrid.setDataProvider(_loc3_ == 0 ? this.buyDp : (_loc3_ == 1 ? this.buyClanDp : this.buyGoldDp),_loc7_);
         if(_loc4_)
         {
            this.dialog.buyGrid.addListener(VEvent.CHANGE,this.onChangeIndex);
            this.onChangeIndex();
         }
         this.onOil();
         this.onGold();
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         this.dialog.addListener(VEvent.CHANGE,this.onTabChange);
         Facade.addListenerForComponent(CommonEvent.OIL,this.onOil,this.dialog);
         Facade.addListenerForComponent(CommonEvent.GOLD,this.onGold,this.dialog);
         Facade.addListenerForComponent(CommonEvent.CONSTRUCTION_UP,this.onConstructionUp,this.dialog);
         return this.dialog;
      }
      
      private function getDpIndex(param1:Array) : int
      {
         var _loc2_:* = int(param1.length - 1);
         while(_loc2_ >= 0)
         {
            if((param1[_loc2_] as VOBarrackItem).shop.su_kind == this.toKind)
            {
               return _loc2_;
            }
            _loc2_--;
         }
         return -1;
      }
      
      private function addProdItems(param1:Array) : void
      {
         var _loc2_:VOBarrackItem = null;
         for each(_loc2_ in param1)
         {
            _loc2_.space = up.soldierCapacityCur + _loc2_.shop.su_hspace - up.soldierCapacityMax;
            _loc2_.count = up.soldierCountHash[_loc2_.shop.su_kind];
            if(_loc2_.count > 0)
            {
               this.prodDp.push(_loc2_);
            }
         }
      }
      
      private function sync(param1:Boolean = true, param2:Boolean = true) : void
      {
         this.dialog.armyBar.value = up.soldierCapacityCur / up.soldierCapacityMax;
         this.dialog.capacityText.value = up.soldierCapacityCur + "/" + up.soldierCapacityMax;
         this.prodDp.length = 0;
         this.addProdItems(this.buyDp);
         this.addProdItems(this.buyClanDp);
         if(param1)
         {
            this.dialog.prodGrid.sync();
         }
         if(param2)
         {
            this.dialog.buyGrid.sync();
         }
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = param1.variance;
         switch(_loc2_)
         {
            case BarrackDialog.INC:
               this.inc(param1.data);
               break;
            case BarrackDialog.INC_5:
               this.inc(param1.data,5);
               break;
            case BarrackDialog.DEC:
               this.dec(param1.data);
               break;
            case BarrackDialog.INFO:
               Facade.mainMediator.showDialog(new FeatureMediator((param1.data as VOBarrackItem).shop));
         }
      }
      
      private function inc(param1:VOBarrackItem, param2:uint = 1) : void
      {
         var _loc5_:PCost = null;
         var _loc6_:uint = 0;
         var _loc4_:PShopUnit = param1.shop;
         if(param1.specialPack)
         {
            if(this.savedPack)
            {
               for each(param1 in this.buyGoldDp)
               {
                  if(param1.specialPack.up_num == this.savedPack.up_num)
                  {
                     param1.specialPack.up_price.value = this.savedPack.up_price.value;
                     param1.specialPack.up_units[0].field_1 = this.savedPack.up_units[0].field_1;
                     break;
                  }
               }
               this.savedPack = null;
               Facade.userProxy.setCustomData("first_barrack_open","1");
               Facade.protoProxy.request(new Packet_0010_19("so_free_unit_pack"));
               this.onRemove();
               MainLogic.getMyMap();
               return;
            }
            _loc5_ = param1.specialPack.up_price;
            if(up.checkCost(_loc5_.variance,_loc5_.value) > 0)
            {
               this.onResourcePackBuy(PCostt.GOLD);
               return;
            }
            param2 = uint(param1.specialPack.up_units[0].field_1);
            ActionLogic.request(PUserAction.BUY_UNITS_PACK,param1.specialPack.up_num);
         }
         else
         {
            _loc5_ = _loc4_.su_price;
            if(param2 > 1 && _loc4_.su_hspace > 0)
            {
               if(up.soldierCapacityCur < up.soldierCapacityMax)
               {
                  _loc6_ = (up.soldierCapacityMax - up.soldierCapacityCur) / _loc4_.su_hspace;
               }
               else
               {
                  _loc6_ = 0;
               }
               if(param2 > _loc6_)
               {
                  param2 = _loc6_ == 0 ? 1 : _loc6_;
               }
               if(param2 > 1)
               {
                  _loc5_ = PCost.create(_loc5_.variance,_loc5_.value * param2);
               }
            }
            if(_loc5_.variance == PCost.OIL)
            {
               if(up.checkCost(_loc5_.variance,_loc5_.value) > 0)
               {
                  this.onResourcePackBuy(PCostt.OIL);
                  return;
               }
            }
            else if(!ShopLogic.checkPrice(_loc5_,this.inc,arguments))
            {
               return;
            }
            ActionLogic.request(PUserAction.MAKE_UNIT,PMakeUnit.create(_loc4_.su_kind,param2));
         }
         ShopLogic.applyCost(_loc5_,true);
         param1.count += param2;
         up.makeSoldier(_loc4_.su_kind,_loc4_.su_hspace,param2);
         this.sync();
         Facade.questMediator.changeQuest(PAction.AC_TRAIN_UNIT,param2,_loc4_.su_kind);
         Facade.questMediator.changeQuest(PAction.AC_HAVE_UNIT,param2,_loc4_.su_kind);
         this.isChange = true;
      }
      
      private function dec(param1:VOBarrackItem) : void
      {
         var _loc2_:PShopUnit = param1.shop;
         if(param1.count == 0)
         {
            return;
         }
         var _loc3_:uint = BarrackProdRenderer.calcDecCount(param1.count);
         if(_loc3_ > param1.count)
         {
            _loc3_ = param1.count;
         }
         param1.count -= _loc3_;
         up.soldierCountHash[_loc2_.su_kind] -= _loc3_;
         up.soldierCapacityCur -= _loc2_.su_hspace * _loc3_;
         ShopLogic.applyCost(_loc3_ > 1 ? PCost.create(_loc2_.su_price.variance,_loc2_.su_price.value * _loc3_) : _loc2_.su_price);
         this.sync();
         ActionLogic.request(PUserAction.REMOVE_UNIT,PMakeUnit.create(_loc2_.su_kind,_loc3_));
         Facade.questMediator.changeQuest(PAction.AC_HAVE_UNIT,-_loc3_,_loc2_.su_kind,0,true,1);
         this.isChange = true;
      }
      
      private function onConstructionUp(param1:CommonEvent) : void
      {
         var _loc2_:uint = 0;
         if(param1.data is Build)
         {
            _loc2_ = (param1.data as Build).type;
            if(_loc2_ == PBtype.STORAGE && ((param1.data as Build).spec as VOStorageSpec).costVariance == PCost.OIL)
            {
               this.dialog.oilPanel.setMax(up.oilMax);
               this.onOil();
            }
         }
      }
      
      private function onChangeIndex(param1:VEvent = null) : void
      {
         var _loc2_:BarrackBuyRenderer = null;
         if(this.arrowSkin)
         {
            this.arrowSkin.removeFromParent();
            this.arrowSkin = null;
         }
         for each(_loc2_ in this.dialog.buyGrid.renderList)
         {
            if(_loc2_.checkBuyBt(this.toKind))
            {
               this.arrowSkin = UIFactory.createLearnArrow(0);
               this.arrowSkin.addListener(MouseEvent.CLICK,this.onClick,_loc2_);
               _loc2_.add(this.arrowSkin,{
                  "hCenter":0,
                  "top":0
               });
               break;
            }
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.dialog.buyGrid.removeListener(VEvent.CHANGE,this.onChangeIndex);
         this.arrowSkin.removeFromParent();
         this.arrowSkin = null;
      }
      
      override public function onRemove() : void
      {
         setDialogSetting(this.dialog.getTabIndex());
         if(this.isChange)
         {
            UnitFactory.useSoldierPatrol();
            UnitFactory.buildLogic.syncStatus(this.build);
         }
      }
      
      private function onOil(param1:CommonEvent = null) : void
      {
         this.dialog.oilPanel.setData(up.oil);
         if(up.oil < up.oilMax != Boolean(this.dialog.oilPanel.buyBt))
         {
            if(up.oil < up.oilMax)
            {
               this.dialog.oilPanel.addBuyBt(this.onResourcePackBuy,Lang.getString("resource_buy"),PCostt.OIL);
            }
            else
            {
               this.dialog.oilPanel.removeBuyBt();
            }
         }
      }
      
      private function onGold(param1:CommonEvent = null) : void
      {
         this.dialog.goldPanel.setData(up.gold);
      }
      
      private function onResourcePackBuy(param1:*) : void
      {
         var _loc3_:PShopResourcesPack = null;
         var _loc5_:uint = 0;
         var _loc6_:PMoneyPriceInfo = null;
         if(param1 is MouseEvent)
         {
            _loc5_ = uint((param1.currentTarget as VButton).data);
         }
         else
         {
            _loc5_ = param1;
         }
         var _loc2_:Array = [];
         for each(_loc3_ in mp.resourcePackList)
         {
            if(_loc3_.rs_type.variance == _loc5_)
            {
               _loc2_.push(_loc3_.rs_kind);
            }
         }
         if(_loc5_ == PCostt.GOLD)
         {
            if(Facade.socialnet == Facade.VZ)
            {
               ShopLogic.openVZBuy();
               return;
            }
            if(_loc2_.length == 0)
            {
               for each(_loc6_ in mp.goldShopList)
               {
                  _loc2_.push("rs_gold" + _loc6_.num);
               }
            }
         }
         var _loc4_:ShopMediator = new ShopMediator(null,_loc2_[Math.floor(_loc2_.length / 2)],true,new <String>[ShopMediator.CURRENCY]);
         _loc4_.buyHandler = this.onBuy;
         Facade.mainMediator.showDialog(_loc4_);
      }
      
      private function onBuy(param1:Object) : void
      {
         var _loc2_:uint = 0;
         if(param1 is PShopResourcesPack)
         {
            _loc2_ = CostHelper.getVarianceFromType(param1.rs_type);
            Facade.mainMediator.showYesNoDialog(Lang.getPatternString("purchase_message","__COST__",CostHelper.getString(_loc2_,Facade.userProxy.getResourcePackCount(param1 as PShopResourcesPack),22,18)),ShopLogic.buy,[param1],Lang.getString("purchase_title"),CostHelper.getMessageSkin(_loc2_));
         }
         else
         {
            ShopLogic.buy(param1);
         }
      }
      
      private function onTabChange(param1:VEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:str_i = null;
         var _loc7_:VOBarrackItem = null;
         var _loc8_:AbstractTrain = null;
         var _loc2_:uint = this.dialog.getTabIndex();
         var _loc3_:Boolean = _loc2_ == 1 && !up.clan;
         if(!_loc3_ != this.dialog.buyGrid.visible)
         {
            this.dialog.buyGrid.visible = !_loc3_;
            if(_loc3_ && !this.dialog.lockPanel)
            {
               if(up.getBuild(PBtype.CLAN,false) != null)
               {
                  this.dialog.createClanLock("clan_search","elite_lock_clan",this.onLockClick,true);
               }
               else
               {
                  this.dialog.createClanLock("help_toShop","elite_lock_build",this.onLockClick,false);
               }
            }
            this.dialog.lockPanelVisible = _loc3_;
         }
         if(_loc2_ == 2 && Boolean(this.dialog.goldTab))
         {
            _loc5_ = 0;
            while(_loc5_ < this.buyGoldDp.length)
            {
               _loc7_ = this.buyGoldDp[_loc5_];
               if(_loc7_.specialPack.up_num == 0)
               {
                  break;
               }
               _loc5_++;
            }
            _loc6_ = _loc7_.specialPack.up_units[0];
            this.savedPack = PUnitsPackInfo.create(_loc7_.specialPack.up_num,[str_i.create(_loc6_.field_0,_loc6_.field_1)],PCost.create(_loc7_.specialPack.up_price.variance,_loc7_.specialPack.up_price.value));
            _loc7_.specialPack.up_price.value = 0;
            _loc6_.field_1 = 2;
         }
         var _loc4_:uint = this.dialog.buyGrid.index;
         this.dialog.buyGrid.setDataProvider(_loc2_ == 0 ? this.buyDp : (_loc2_ == 1 ? this.buyClanDp : this.buyGoldDp),this.saveTabIndex);
         this.saveTabIndex = _loc4_;
         if(_loc2_ == 2 && Boolean(this.dialog.goldTab))
         {
            _loc8_ = new AbstractTrain();
            AbstractTrain.assign(_loc8_);
            _loc8_.assignStep(new BlackoutClickStep((this.dialog.buyGrid.renderList[_loc5_] as BarrackBuyRenderer).buyBt,270,{
               "vCenter":0,
               "left":0
            }),AbstractTrain.clear);
            MyPanel.changeButtonCount(this.dialog.goldTab,0);
         }
      }
      
      private function onLockClick(param1:MouseEvent) : void
      {
         if((param1.currentTarget as VButton).data)
         {
            DialogLogic.openClanCenter();
         }
         else
         {
            DialogLogic.openShop(ShopMediator.ARMY,"bl_clan_center");
         }
         this.dialog.close();
      }
   }
}

