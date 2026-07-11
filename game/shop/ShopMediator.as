package game.shop
{
   import engine.units.Build;
   import flash.utils.Dictionary;
   import game.common.DialogMediator;
   import game.feature.FeatureMediator;
   import logic.ActionLogic;
   import logic.ShopLogic;
   import model.CommonEvent;
   import model.ui.VOShopItem;
   import proto.game.family_0010.PUserAction;
   import proto.model.PBtype;
   import proto.model.PCallEffect;
   import proto.model.PCost;
   import proto.model.PCostt;
   import proto.model.PMoneyPriceInfo;
   import proto.model.PShopBuilding;
   import proto.model.PShopCall;
   import proto.model.PShopCannon;
   import proto.model.PShopDecor;
   import proto.model.PShopFence;
   import proto.model.PShopGarbage;
   import proto.model.PShopResourcesPack;
   import proto.model.PShopShield;
   import proto.tuples.str_uint;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import utils.CostHelper;
   
   public class ShopMediator extends DialogMediator
   {
      
      public static const ARMY:String = "army";
      
      public static const DEFENCE:String = "defence";
      
      public static const RESOURCE:String = "res";
      
      public static const CURRENCY:String = "currency";
      
      public static const DECOR:String = "decor";
      
      private static const GARBAGE:String = "garbage";
      
      public var dialog:ShopDialog;
      
      public var arrowSkin:VSkin;
      
      public var buyHandler:Function;
      
      private var toGroup:String;
      
      private var toKind:String;
      
      private var isHelpArrow:Boolean;
      
      private var groupList:Vector.<String>;
      
      private var newList:Array;
      
      private var indexList:Vector.<uint>;
      
      private const cacheHash:Object = {};
      
      public function ShopMediator(param1:String = null, param2:String = null, param3:Boolean = true, param4:Vector.<String> = null)
      {
         super();
         this.toGroup = param1;
         this.toKind = param2;
         this.isHelpArrow = param3;
         this.groupList = param4;
      }
      
      override public function onAdd() : BaseDialog
      {
         var _loc3_:Boolean = false;
         if(!this.groupList)
         {
            this.groupList = new Vector.<String>(0);
            if(Facade.isBattle)
            {
               this.groupList.push(CURRENCY);
            }
            else
            {
               this.groupList.push(ARMY,DEFENCE,RESOURCE,CURRENCY,DECOR);
            }
            if(Facade.isMissionEditor)
            {
               this.groupList.push(GARBAGE);
            }
         }
         var _loc1_:int = 0;
         var _loc2_:str_uint = getDialogSetting() as str_uint;
         if(Boolean(_loc2_) && Boolean(!this.toGroup) && !this.toKind)
         {
            _loc1_ = int(_loc2_.field_1);
            this.toKind = _loc2_.field_0;
         }
         else
         {
            _loc3_ = this.isHelpArrow && this.toKind != null;
            if(!this.toGroup && Boolean(this.toKind))
            {
               this.toGroup = this.getGroup(this.toKind);
            }
            if(this.toGroup)
            {
               _loc1_ = this.groupList.indexOf(this.toGroup);
            }
            else
            {
               this.toKind = null;
            }
         }
         if(_loc1_ < 0 || _loc1_ >= this.groupList.length)
         {
            _loc1_ = 0;
         }
         this.dialog = new ShopDialog(this.groupList,_loc1_);
         if(_loc3_)
         {
            this.dialog.grid.addListener(VEvent.CHANGE,this.onChangeIndex);
         }
         this.dialog.tabPanel.addListener(VEvent.CHANGE,this.onTabChange);
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         this.dialog.crystalPanel.setData(up.crystal);
         this.dialog.oilPanel.setData(up.oil);
         this.dialog.goldPanel.setData(up.gold);
         Facade.addListenerForComponent(CommonEvent.CONSTRUCTION_UP,this.onConstructionUp,this.dialog);
         if(Facade.isMyMap)
         {
            this.newList = up.shopNewList;
            if(Boolean(this.newList) && this.newList.length > 0)
            {
               if(up.townHallLevel < 2)
               {
                  ActionLogic.request(PUserAction.REMOVE_SHOP_UNWATCHED,this.newList);
                  this.newList.length = 0;
                  this.newList = null;
                  Facade.myMediator.syncShopButton(false);
               }
               else
               {
                  this.dialog.grid.addListener(VEvent.CHANGE,this.onNewChange);
               }
            }
            else
            {
               this.newList = null;
            }
         }
         this.showGroup(this.groupList[_loc1_],this.toKind);
         this.toGroup = null;
         return this.dialog;
      }
      
      override public function onRemove() : void
      {
         var _loc1_:str_uint = getDialogSetting() as str_uint;
         if(!_loc1_)
         {
            _loc1_ = new str_uint();
            setDialogSetting(_loc1_);
         }
         _loc1_.field_1 = this.dialog.tabPanel.index;
         var _loc2_:VOShopItem = this.dialog.grid.getIndexData() as VOShopItem;
         _loc1_.field_0 = _loc2_ ? _loc2_.kind : null;
      }
      
      private function onConstructionUp(param1:CommonEvent) : void
      {
         var _loc2_:uint = 0;
         if(param1.data is Build)
         {
            _loc2_ = (param1.data as Build).type;
            if(_loc2_ == PBtype.CAMP || _loc2_ == PBtype.STORAGE)
            {
               this.invalidateTab(CURRENCY);
            }
         }
      }
      
      private function onTabChange(param1:VEvent) : void
      {
         if(!this.indexList)
         {
            this.indexList = new Vector.<uint>(this.groupList.length,true);
         }
         this.indexList[param1.variance] = this.dialog.grid.index;
         var _loc2_:uint = param1.data;
         this.showGroup(this.groupList[_loc2_],null,this.indexList[_loc2_]);
      }
      
      private function applyReq(param1:VOShopItem, param2:uint) : void
      {
         var _loc4_:Vector.<Dictionary> = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Dictionary = null;
         var _loc8_:uint = 0;
         var _loc3_:String = param1.kind;
         param1.cur = up.getConstructionCount(_loc3_);
         if(Facade.isMissionEditor)
         {
            param1.max = 2000;
            param1.price = PCost.create(param1.price ? param1.price.variance : uint(param1.priceList[0].variance),0);
         }
         else
         {
            param1.townhall_req = up.townHallLevel >= param2 ? 0 : param2;
            param1.max = up.getConstructionMax(_loc3_);
         }
         if(param1.cur >= param1.max && param1.townhall_req == 0)
         {
            _loc4_ = mp.townHallUnlockList;
            _loc5_ = _loc4_.length;
            _loc6_ = up.townHallLevel;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc4_[_loc6_];
               _loc8_ = _loc7_.hasOwnProperty(_loc3_) ? uint(_loc7_[_loc3_]) : 0;
               if(_loc8_ > param1.max)
               {
                  param1.next_townhall_req = _loc6_ + 1;
                  return;
               }
               _loc6_++;
            }
         }
      }
      
      private function addBuild(param1:uint, param2:Array) : void
      {
         var _loc3_:PShopBuilding = null;
         var _loc4_:VOShopItem = null;
         for each(_loc3_ in mp.buildShopList)
         {
            if(_loc3_.sb_level == 1 && _loc3_.sb_can_buy && _loc3_.sb_btype.variance == param1 && ShopLogic.checkRequierementList(_loc3_.sb_requirements))
            {
               _loc4_ = new VOShopItem();
               _loc4_.shop = _loc3_;
               _loc4_.kind = _loc3_.sb_kind;
               _loc4_.priceList = ShopLogic.getCustomPrice(_loc3_.sb_kind,_loc3_.sb_price_list,_loc3_.sb_price);
               _loc4_.duration = _loc3_.sb_upgrade_time;
               this.applyReq(_loc4_,_loc3_.sb_townhall_req);
               param2.push(_loc4_);
            }
         }
      }
      
      private function addCannon(param1:Array) : void
      {
         var _loc2_:PShopCannon = null;
         var _loc3_:VOShopItem = null;
         for each(_loc2_ in mp.cannonShopList)
         {
            if(_loc2_.sc_level == 1 && _loc2_.sc_can_buy)
            {
               _loc3_ = new VOShopItem();
               _loc3_.shop = _loc2_;
               _loc3_.kind = _loc2_.sc_kind;
               _loc3_.priceList = ShopLogic.getCustomPrice(_loc2_.sc_kind,_loc2_.sc_price_list,_loc2_.sc_price);
               _loc3_.duration = _loc2_.sc_upgrade_time;
               this.applyReq(_loc3_,_loc2_.sc_townhall_req);
               param1.push(_loc3_);
            }
         }
      }
      
      private function addFenceDp(param1:Array) : void
      {
         var _loc2_:PShopFence = null;
         var _loc3_:VOShopItem = null;
         for each(_loc2_ in mp.fenceShopList)
         {
            if(_loc2_.sf_level == 1 && _loc2_.sf_can_buy)
            {
               _loc3_ = new VOShopItem();
               _loc3_.shop = _loc2_;
               _loc3_.kind = _loc2_.sf_kind;
               _loc3_.price = _loc2_.sf_price;
               this.applyReq(_loc3_,_loc2_.sf_townhall_req);
               param1.push(_loc3_);
            }
         }
      }
      
      private function addDecor(param1:Array) : void
      {
         var _loc2_:PShopDecor = null;
         var _loc3_:VOShopItem = null;
         for each(_loc2_ in mp.decorShopList)
         {
            if(_loc2_.sd_can_buy)
            {
               _loc3_ = new VOShopItem();
               _loc3_.shop = _loc2_;
               _loc3_.kind = _loc2_.sd_kind;
               _loc3_.price = _loc2_.sd_price;
               _loc3_.order = _loc2_.sd_order;
               this.applyReq(_loc3_,0);
               param1.push(_loc3_);
            }
         }
      }
      
      private function addGarbage(param1:Array) : void
      {
         var _loc2_:PShopGarbage = null;
         var _loc3_:VOShopItem = null;
         for each(_loc2_ in mp.garbageShopList)
         {
            _loc3_ = new VOShopItem();
            _loc3_.shop = _loc2_;
            _loc3_.kind = _loc2_.sg_kind;
            _loc3_.price = PCost.create(PCost.GOLD,0);
            this.applyReq(_loc3_,0);
            param1.push(_loc3_);
         }
      }
      
      private function addCurrency(param1:Array) : void
      {
         var _loc3_:VOShopItem = null;
         var _loc4_:PMoneyPriceInfo = null;
         var _loc5_:PShopShield = null;
         var _loc6_:PShopCall = null;
         var _loc7_:PShopResourcesPack = null;
         var _loc8_:uint = 0;
         var _loc2_:Boolean = Facade.isMyMap;
         if((_loc2_ || Facade.isBattle) && Facade.socialnet != Facade.VZ)
         {
            for each(_loc4_ in mp.goldShopList)
            {
               _loc3_ = new VOShopItem();
               _loc3_.shop = _loc4_;
               _loc3_.kind = "rs_gold" + _loc4_.num;
               _loc3_.cur = 4;
               param1.push(_loc3_);
            }
         }
         if(_loc2_)
         {
            for each(_loc5_ in mp.shieldPackList)
            {
               _loc3_ = new VOShopItem();
               _loc3_.shop = _loc5_;
               _loc3_.kind = _loc5_.sh_kind;
               _loc3_.price = _loc5_.sh_price;
               _loc3_.cur = 1;
               _loc3_.duration = _loc5_.sh_duration;
               param1.push(_loc3_);
            }
            for each(_loc6_ in mp.energyShopList)
            {
               _loc3_ = new VOShopItem();
               _loc3_.shop = _loc6_;
               _loc3_.kind = "rs_calls" + (_loc6_.call_num + 1);
               _loc3_.cur = 2;
               _loc3_.next_townhall_req = _loc6_.call_effect.variance == PCallEffect.FULL ? up.energyMax : uint(_loc6_.call_effect.value);
               _loc3_.price = _loc6_.call_price;
               param1.push(_loc3_);
            }
         }
         if(_loc2_ || Facade.isCapital)
         {
            for each(_loc7_ in mp.resourcePackList)
            {
               _loc8_ = _loc7_.rs_type.variance;
               if(_loc8_ == PCostt.CRYSTAL || _loc8_ == PCostt.OIL)
               {
                  _loc3_ = new VOShopItem();
                  _loc3_.shop = _loc7_;
                  _loc3_.kind = _loc7_.rs_kind;
                  _loc3_.cur = _loc8_ == PCostt.OIL ? 3 : 2;
                  _loc3_.townhall_req = CostHelper.getVarianceFromType(_loc7_.rs_type);
                  _loc3_.next_townhall_req = up.getResourcePackCount(_loc7_);
                  _loc3_.price = ShopLogic.getExchangeCost(_loc3_.townhall_req,_loc3_.next_townhall_req);
                  param1.push(_loc3_);
               }
            }
         }
      }
      
      private function showGroup(param1:String, param2:String = null, param3:uint = 0) : void
      {
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         if(this.cacheHash.hasOwnProperty(param1))
         {
            _loc4_ = this.cacheHash[param1];
         }
         else
         {
            _loc4_ = [];
            if(param1 == ARMY)
            {
               this.addBuild(PBtype.BARRACK,_loc4_);
               this.addBuild(PBtype.CAMP,_loc4_);
               this.addBuild(PBtype.HERO,_loc4_);
               this.addBuild(PBtype.RESEARCH,_loc4_);
               this.addBuild(PBtype.CLAN,_loc4_);
               this.addBuild(PBtype.RAID,_loc4_);
               this.addBuild(PBtype.LIBRARY,_loc4_);
            }
            else if(param1 == DEFENCE)
            {
               this.addFenceDp(_loc4_);
               this.addBuild(PBtype.SHIELD,_loc4_);
               this.addBuild(PBtype.PYLON,_loc4_);
               this.addCannon(_loc4_);
               this.addBuild(PBtype.GUARD,_loc4_);
            }
            else if(param1 == RESOURCE)
            {
               if(Facade.isMissionEditor && up.townHallLevel == 0)
               {
                  this.addBuild(PBtype.TOWNHALL,_loc4_);
               }
               this.addBuild(PBtype.WORKER,_loc4_);
               this.addBuild(PBtype.RESOURCE,_loc4_);
               this.addBuild(PBtype.STORAGE,_loc4_);
               this.addBuild(PBtype.SCOUTING,_loc4_);
            }
            else if(param1 == DECOR)
            {
               this.addDecor(_loc4_);
            }
            else if(param1 == CURRENCY)
            {
               this.addCurrency(_loc4_);
            }
            else if(param1 == GARBAGE)
            {
               this.addGarbage(_loc4_);
            }
            _loc5_ = int(_loc4_.length - 1);
            while(_loc5_ >= 0)
            {
               (_loc4_[_loc5_] as VOShopItem).order = _loc5_;
               _loc5_--;
            }
            if(Facade.isMyMap && Boolean(this.newList))
            {
               this.checkNewStatus(_loc4_);
            }
            this.cacheHash[param1] = _loc4_;
         }
         if(param1 != CURRENCY)
         {
            _loc4_.sort(this.shopSort);
         }
         if(param2)
         {
            _loc5_ = int(_loc4_.length - 1);
            while(_loc5_ >= 0)
            {
               if((_loc4_[_loc5_] as VOShopItem).kind == param2)
               {
                  param3 = _loc5_;
                  break;
               }
               _loc5_--;
            }
         }
         this.dialog.grid.setDataProvider(_loc4_,param3);
      }
      
      private function getGroup(param1:String) : String
      {
         var _loc3_:uint = 0;
         var _loc2_:PShopBuilding = mp.getBuildShop(param1,1,true);
         if(_loc2_)
         {
            _loc3_ = _loc2_.sb_btype.variance;
            if(_loc3_ == PBtype.PYLON || _loc3_ == PBtype.GUARD)
            {
               return DEFENCE;
            }
            if(_loc3_ == PBtype.WORKER || _loc3_ == PBtype.RESOURCE || _loc3_ == PBtype.STORAGE)
            {
               return RESOURCE;
            }
            return ARMY;
         }
         if(Boolean(mp.getCannonShop(param1,1,true)) || Boolean(mp.getFenceShop(param1,1,true)))
         {
            return DEFENCE;
         }
         return DECOR;
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:VOShopItem = null;
         if(param1.data is String)
         {
            this.showGroup(param1.data as String);
            Facade.mainMediator.syncHint(null);
         }
         else
         {
            _loc2_ = param1.variance;
            _loc3_ = param1.data;
            if(_loc2_ == 0)
            {
               if(this.buyHandler != null)
               {
                  this.buyHandler(_loc3_.shop);
               }
               else
               {
                  ShopLogic.buy(_loc3_.shop);
               }
            }
            else if(_loc2_ == 1)
            {
               Facade.mainMediator.showDialog(_loc3_.shop is PShopCannon ? new FeatureMediator(_loc3_.shop) : new ShopInfoDialog(_loc3_.kind));
            }
         }
      }
      
      private function onChangeIndex(param1:VEvent) : void
      {
         var _loc2_:ShopRenderer = null;
         var _loc3_:VOShopItem = null;
         if(this.arrowSkin)
         {
            this.arrowSkin.removeFromParent();
            this.arrowSkin = null;
         }
         for each(_loc2_ in this.dialog.grid.renderList)
         {
            if(!_loc2_.parent)
            {
               break;
            }
            _loc3_ = _loc2_.bt.data as VOShopItem;
            if(_loc3_.kind == this.toKind)
            {
               this.arrowSkin = UIFactory.createLearnArrow(-60);
               _loc2_.add(this.arrowSkin,{
                  "left":54,
                  "top":80
               });
               break;
            }
         }
      }
      
      private function shopSort(param1:VOShopItem, param2:VOShopItem) : int
      {
         var _loc3_:Boolean = param1.townhall_req > 0 || param1.cur >= param1.max;
         var _loc4_:Boolean = param2.townhall_req > 0 || param2.cur >= param2.max;
         if(!_loc3_ || !_loc4_)
         {
            return _loc3_ == _loc4_ ? int(param1.order - param2.order) : (_loc3_ ? 1 : -1);
         }
         _loc4_ = param2.townhall_req > 0;
         if(param1.townhall_req > 0)
         {
            return _loc4_ ? int(param1.townhall_req - param2.townhall_req) : -1;
         }
         if(_loc4_)
         {
            return 1;
         }
         return param1.order - param2.order;
      }
      
      public function invalidateTab(param1:String) : void
      {
         if(this.cacheHash.hasOwnProperty(param1))
         {
            delete this.cacheHash[param1];
            if(this.dialog.tabPanel.index == this.groupList.indexOf(param1))
            {
               this.showGroup(param1,null,this.dialog.grid.index);
            }
         }
      }
      
      private function checkNewStatus(param1:Array) : void
      {
         var _loc2_:VOShopItem = null;
         for each(_loc2_ in param1)
         {
            _loc2_.isNew = this.newList.indexOf(_loc2_.kind) >= 0;
         }
      }
      
      private function onNewChange(param1:VEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:ShopRenderer = null;
         var _loc4_:int = 0;
         for each(_loc3_ in this.dialog.grid.renderList)
         {
            if(!_loc3_.parent)
            {
               break;
            }
            _loc4_ = this.newList.indexOf((_loc3_.bt.data as VOShopItem).kind);
            if(_loc4_ >= 0)
            {
               if(!_loc2_)
               {
                  _loc2_ = [];
               }
               _loc2_.push(this.newList[_loc4_]);
               this.newList.splice(_loc4_,1);
            }
         }
         if(_loc2_)
         {
            if(this.newList.length == 0)
            {
               this.newList = null;
               this.dialog.grid.removeListener(VEvent.CHANGE,this.onNewChange);
               Facade.myMediator.syncShopButton(false);
            }
         }
         ActionLogic.request(PUserAction.REMOVE_SHOP_UNWATCHED,_loc2_);
      }
   }
}

