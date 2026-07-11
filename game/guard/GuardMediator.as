package game.guard
{
   import engine.units.Build;
   import flash.events.MouseEvent;
   import game.barrack.BarrackDialog;
   import game.barrack.BarrackMediator;
   import game.barrack.BarrackProdRenderer;
   import game.common.DialogMediator;
   import game.feature.FeatureMediator;
   import logic.ActionLogic;
   import logic.ShopLogic;
   import logic.UnitFactory;
   import model.ManualProxy;
   import model.ui.VOBarrackItem;
   import model.ui.VOCallback;
   import model.vo.VOGuardSpec;
   import proto.game.family_0010.PChargeGuard;
   import proto.game.family_0010.PGuardConfig;
   import proto.game.family_0010.PUserAction;
   import proto.model.PBtype;
   import proto.model.PCost;
   import proto.model.PKindCount;
   import proto.model.PShopUnit;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   
   public class GuardMediator extends DialogMediator
   {
      
      private var dialog:GuardDialog;
      
      private var spec:VOGuardSpec;
      
      private var build:Build;
      
      private var configDp:Array;
      
      private var buyDp:Array;
      
      private var isConfigChange:Boolean;
      
      private var oldCharge:uint;
      
      private var isConfigSave:Boolean;
      
      private var buildList:Vector.<Build> = new Vector.<Build>();
      
      private var tabIndex:int = 0;
      
      public function GuardMediator(param1:Build)
      {
         super();
         Facade.userProxy.getBuild(PBtype.GUARD,true,0,this.buildList);
         this.build = param1;
         this.spec = param1.spec;
         this.oldCharge = this.spec.chargeCur;
         this.tabIndex = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.buildList.length)
         {
            if(this.buildList[_loc2_].id == param1.id)
            {
               this.tabIndex = _loc2_;
            }
            _loc2_++;
         }
      }
      
      public static function checkElite(param1:Build) : void
      {
         var _loc7_:PKindCount = null;
         var _loc8_:int = 0;
         var _loc9_:PShopUnit = null;
         if(Facade.isMissionEditor)
         {
            return;
         }
         var _loc2_:VOGuardSpec = param1.spec;
         var _loc3_:ManualProxy = Facade.manualProxy;
         var _loc4_:Boolean = false;
         var _loc5_:uint = _loc2_.chargeCur;
         var _loc6_:* = int(_loc2_.configList.length - 1);
         while(_loc6_ >= 0)
         {
            _loc7_ = _loc2_.configList[_loc6_];
            if(_loc3_.getSoldierShop(_loc7_.kind,1).su_is_clan)
            {
               _loc4_ = true;
               if(_loc2_.chargeCur > 0)
               {
                  ShopLogic.applyCost(getChargePrice(_loc2_,_loc2_.chargeCur));
                  ActionLogic.request(PUserAction.CHARGE_GUARD,PChargeGuard.create(param1.id,false,_loc2_.chargeCur));
                  _loc2_.chargeCur = 0;
               }
               _loc8_ = _loc7_.kind.indexOf("_elite");
               if(_loc8_ > 0)
               {
                  _loc9_ = _loc3_.getSoldierShop(_loc7_.kind.substr(0,_loc8_),0,true);
               }
               else
               {
                  _loc9_ = null;
               }
               if(_loc9_)
               {
                  _loc7_.kind = _loc9_.su_kind;
               }
               else
               {
                  _loc2_.configList.splice(_loc6_,1);
               }
            }
            _loc6_--;
         }
         if(_loc4_)
         {
            ActionLogic.request(PUserAction.SET_GUARD_CONFIG,PGuardConfig.create(param1.id,_loc2_.configList));
            if(_loc5_ != _loc2_.chargeCur)
            {
               ShopLogic.applyCost(getChargePrice(_loc2_,_loc5_),true);
               _loc2_.chargeCur = _loc5_;
               ActionLogic.request(PUserAction.CHARGE_GUARD,PChargeGuard.create(param1.id,true,_loc5_));
            }
         }
      }
      
      private static function getChargePrice(param1:VOGuardSpec, param2:uint) : PCost
      {
         var _loc4_:PKindCount = null;
         var _loc3_:uint = 0;
         for each(_loc4_ in param1.configList)
         {
            _loc3_ += Facade.manualProxy.getSoldierShop(_loc4_.kind).su_price.value * _loc4_.count;
         }
         return PCost.create(PCost.OIL,_loc3_ * param2);
      }
      
      override public function onAdd() : BaseDialog
      {
         var _loc1_:PShopUnit = null;
         var _loc2_:PKindCount = null;
         var _loc3_:uint = 0;
         var _loc4_:VOBarrackItem = null;
         this.buyDp = [];
         for each(_loc1_ in mp.soldierShopList)
         {
            if(_loc1_.su_level == 1 && _loc1_.su_can_buy && !_loc1_.su_is_hero)
            {
               _loc3_ = uint(up.soldierLevelHash[_loc1_.su_kind]);
               if(_loc3_ > 0 && !_loc1_.su_is_healer && !_loc1_.su_is_clan || Facade.isMissionEditor)
               {
                  _loc4_ = new VOBarrackItem();
                  _loc4_.flag = true;
                  _loc4_.shop = mp.getSoldierShop(_loc1_.su_kind,_loc3_);
                  this.buyDp.push(_loc4_);
               }
            }
         }
         this.buyDp.sort(BarrackMediator.soldierSort);
         this.configDp = [];
         for each(_loc2_ in this.spec.configList)
         {
            _loc4_ = new VOBarrackItem();
            _loc4_.count = _loc2_.count;
            _loc4_.shop = mp.getSoldierShop(_loc2_.kind);
            this.configDp.push(_loc4_);
         }
         this.dialog = new GuardDialog(this.spec.chargeMax,this.build,this.buildList,this.tabIndex);
         this.dialog.tabPanel.addListener(VEvent.CHANGE,this.onTabChange);
         this.dialog.oilPanel.useTrack();
         this.sync(false,false);
         this.dialog.configGrid.setDataProvider(this.configDp);
         this.dialog.buyGrid.setDataProvider(this.buyDp);
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         this.dialog.addBt.addClickListener(this.chargeInc);
         this.dialog.removeBt.addClickListener(this.chargeDec);
         return this.dialog;
      }
      
      private function buyAll(param1:MouseEvent) : void
      {
         var _loc2_:Build = null;
         var _loc3_:VOGuardSpec = null;
         var _loc4_:uint = 0;
         var _loc5_:PKindCount = null;
         var _loc6_:PCost = null;
         this.saveConfig();
         for each(_loc2_ in this.buildList)
         {
            _loc3_ = _loc2_.spec;
            if(_loc3_.configList.length > 0 && _loc3_.chargeCur < _loc3_.chargeMax)
            {
               checkElite(_loc2_);
               _loc4_ = 0;
               for each(_loc5_ in _loc3_.configList)
               {
                  _loc4_ += Facade.manualProxy.getSoldierShop(_loc5_.kind).su_price.value * _loc5_.count;
               }
               _loc6_ = PCost.create(PCost.OIL,_loc4_ * (_loc3_.chargeMax - _loc3_.chargeCur));
               UnitFactory.buildLogic.onBuyGuardUnits(_loc2_,_loc6_);
            }
         }
         for each(_loc2_ in this.buildList)
         {
            UnitFactory.buildLogic.syncStatus(_loc2_);
         }
         this.dialog.close();
      }
      
      private function onTabChange(param1:VEvent) : void
      {
         var _loc3_:PKindCount = null;
         var _loc4_:VOBarrackItem = null;
         this.save();
         var _loc2_:int = int(this.dialog.tabPanel.index);
         this.build = this.buildList[_loc2_];
         this.spec = this.build.spec;
         this.oldCharge = this.spec.chargeCur;
         this.configDp = [];
         for each(_loc3_ in this.spec.configList)
         {
            _loc4_ = new VOBarrackItem();
            _loc4_.count = _loc3_.count;
            _loc4_.shop = mp.getSoldierShop(_loc3_.kind);
            this.configDp.push(_loc4_);
         }
         this.sync(false,false);
         this.dialog.configGrid.setDataProvider(this.configDp);
         this.dialog.buyGrid.setDataProvider(this.buyDp);
         this.dialog.levelPanel.value = this.build.level;
      }
      
      private function save() : void
      {
         if(this.isConfigChange)
         {
            this.saveConfig();
         }
         if(this.oldCharge != this.spec.chargeCur)
         {
            UnitFactory.buildLogic.syncStatus(this.build);
         }
         if(this.isConfigSave || this.oldCharge != this.spec.chargeCur)
         {
            Facade.boardMediator.syncSelected(this.build);
         }
      }
      
      override public function onRemove() : void
      {
         this.save();
      }
      
      private function sync(param1:Boolean = true, param2:Boolean = true) : void
      {
         var _loc4_:VOBarrackItem = null;
         var _loc3_:uint = this.getConfigCapacity();
         this.dialog.updateCount(_loc3_,this.spec.capacity,this.getConfigPrice(),this.spec.chargeCur,this.spec.chargeMax);
         for each(_loc4_ in this.buyDp)
         {
            _loc4_.space = _loc3_ + _loc4_.shop.su_hspace - this.spec.capacity;
            if(Facade.isMissionEditor)
            {
               _loc4_.space = 0;
            }
         }
         if(param2)
         {
            this.dialog.buyGrid.sync();
         }
         if(param1)
         {
            this.dialog.configGrid.sync();
         }
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = param1.variance;
         if(_loc2_ == BarrackDialog.INC)
         {
            this.inc(param1.data);
         }
         else if(_loc2_ == BarrackDialog.DEC)
         {
            this.dec(param1.data);
         }
         else if(_loc2_ == BarrackDialog.INFO)
         {
            Facade.mainMediator.showDialog(new FeatureMediator((param1.data as VOBarrackItem).shop));
         }
      }
      
      private function getConfigCapacity() : uint
      {
         var _loc2_:VOBarrackItem = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.configDp)
         {
            _loc1_ += _loc2_.count * _loc2_.shop.su_hspace;
         }
         return _loc1_;
      }
      
      private function getConfigPrice() : PCost
      {
         var _loc2_:VOBarrackItem = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.configDp)
         {
            _loc1_ += _loc2_.count * _loc2_.shop.su_price.value;
         }
         return PCost.create(PCost.OIL,_loc1_);
      }
      
      private function inc(param1:VOBarrackItem) : void
      {
         var _loc4_:VOBarrackItem = null;
         var _loc5_:VOBarrackItem = null;
         if(this.spec.chargeCur > 0)
         {
            this.showDisbandDialog(new VOCallback(this.inc,arguments));
            return;
         }
         var _loc3_:uint = this.getConfigCapacity();
         if(_loc3_ + param1.shop.su_hspace > this.spec.capacity)
         {
            if(!Facade.isMissionEditor)
            {
               Facade.mainMediator.showMessage(Lang.getString("guard_config_limit"));
               return;
            }
         }
         for each(_loc5_ in this.configDp)
         {
            if(_loc5_.shop == param1.shop)
            {
               _loc4_ = _loc5_;
               break;
            }
         }
         if(_loc4_)
         {
            ++_loc4_.count;
         }
         else
         {
            _loc4_ = new VOBarrackItem();
            _loc4_.count = 1;
            _loc4_.shop = param1.shop;
            this.configDp.push(_loc4_);
         }
         this.isConfigChange = true;
         this.sync();
         this.dialog.dispatchEvent(new VEvent(VEvent.CHANGE));
      }
      
      private function dec(param1:VOBarrackItem) : void
      {
         var _loc5_:VOBarrackItem = null;
         if(this.spec.chargeCur > 0)
         {
            this.showDisbandDialog(new VOCallback(this.dec,arguments));
            return;
         }
         var _loc3_:uint = BarrackProdRenderer.calcDecCount(param1.count);
         var _loc4_:* = int(this.configDp.length - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = this.configDp[_loc4_] as VOBarrackItem;
            if(_loc5_.shop == param1.shop)
            {
               if(_loc3_ < _loc5_.count)
               {
                  _loc5_.count -= _loc3_;
                  break;
               }
               this.configDp.splice(_loc4_,1);
               break;
            }
            _loc4_--;
         }
         this.isConfigChange = true;
         this.sync();
         this.dialog.dispatchEvent(new VEvent(VEvent.CHANGE));
      }
      
      private function showDisbandDialog(param1:VOCallback) : void
      {
         Facade.mainMediator.showYesNoDialog(Lang.getString("guard_config_change"),this.disband,[param1]);
      }
      
      private function disband(param1:VOCallback) : void
      {
         var _loc2_:PCost = this.getConfigPrice();
         _loc2_.value *= this.spec.chargeCur;
         ShopLogic.applyCost(_loc2_);
         ActionLogic.request(PUserAction.CHARGE_GUARD,PChargeGuard.create(this.build.id,false,this.spec.chargeCur));
         this.spec.chargeCur = 0;
         if(param1)
         {
            param1.apply();
         }
         else
         {
            this.sync();
         }
      }
      
      private function saveConfig() : void
      {
         var _loc2_:VOBarrackItem = null;
         this.isConfigChange = false;
         this.isConfigSave = true;
         var _loc1_:Array = [];
         for each(_loc2_ in this.configDp)
         {
            _loc1_.push(PKindCount.create(_loc2_.shop.su_kind,_loc2_.count));
         }
         this.spec.configList = _loc1_;
         ActionLogic.request(PUserAction.SET_GUARD_CONFIG,PGuardConfig.create(this.build.id,_loc1_));
      }
      
      private function chargeInc(param1:MouseEvent = null) : void
      {
         var _loc2_:PCost = null;
         if(this.spec.chargeCur < this.spec.chargeMax && this.configDp.length > 0)
         {
            _loc2_ = this.getConfigPrice();
            if(!ShopLogic.checkPrice(_loc2_,this.chargeInc))
            {
               return;
            }
            ShopLogic.applyCost(_loc2_,true);
            ++this.spec.chargeCur;
            this.sync();
            if(this.isConfigChange)
            {
               this.saveConfig();
            }
            ActionLogic.request(PUserAction.CHARGE_GUARD,PChargeGuard.create(this.build.id,true,1));
            this.dialog.dispatchEvent(new VEvent(VEvent.CHANGE,true));
         }
      }
      
      private function chargeDec(param1:MouseEvent) : void
      {
         if(this.spec.chargeCur > 0)
         {
            ShopLogic.applyCost(this.getConfigPrice());
            --this.spec.chargeCur;
            this.sync();
            ActionLogic.request(PUserAction.CHARGE_GUARD,PChargeGuard.create(this.build.id,false,1));
            this.dialog.dispatchEvent(new VEvent(VEvent.CHANGE,true));
         }
      }
   }
}

