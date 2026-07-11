package game.capital
{
   import engine.signal.Signal;
   import engine.units.Build;
   import engine.units.Decor;
   import engine.units.Fence;
   import engine.units.Garbage;
   import engine.units.Unit;
   import game.my.MyPanel;
   import game.shop.ShopMediator;
   import logic.ActionLogic;
   import logic.BoardLogic;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import logic.MainLogic;
   import logic.ShopLogic;
   import logic.UnitFactory;
   import logic.units.BuildLogic;
   import logic.units.FenceLogic;
   import model.ManualProxy;
   import model.UserProxy;
   import proto.BinaryBuffer;
   import proto.game.family_0060.Packet_0060_02;
   import proto.game.family_0060.Packet_0060_03;
   import proto.model.PBoardObj;
   import proto.model.PBtype;
   import proto.model.PClanAction;
   import proto.model.PCost;
   import proto.model.PEventPlace;
   import proto.model.PGarbage;
   import proto.model.PMove;
   import proto.model.PObjType;
   import proto.model.PObjectId;
   import proto.model.PPermission;
   import proto.model.PRaidEvent;
   import proto.model.PRaidFriendEvent;
   import proto.model.PShopBuilding;
   import proto.model.PShopCannon;
   import proto.model.PShopUnit;
   import proto.model.PSpeedUp;
   import proto.model.PStartStorm;
   import proto.model.PUnitsLevel;
   import proto.model.PUserClan;
   import proto.model.clan.PBase;
   import proto.model.clan.PCapital;
   import proto.model.clan.PChangeClan;
   import proto.model.clan.PMember;
   import proto.model.clan.PSetRole;
   import ui.UIFactory;
   import ui.common.MessageDialog;
   import ui.vbase.SkinManager;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   
   public class CapitalMediator
   {
      
      public static var instance:CapitalMediator;
      
      private const up:UserProxy = Facade.userProxy;
      
      private const mp:ManualProxy = Facade.manualProxy;
      
      private const capitalPanel:CapitalPanel = new CapitalPanel();
      
      private const clanEmblem:VSkin = new VSkin();
      
      private var startEditTime:Number = 0;
      
      private var memberEditId:String;
      
      private var isAllowEdit:Boolean;
      
      private var signal:Signal;
      
      private var showId:String;
      
      private var myResourceList:Vector.<uint>;
      
      public function CapitalMediator()
      {
         super();
      }
      
      public static function clear() : void
      {
         instance.dispose();
         instance = null;
      }
      
      private function dispose() : void
      {
         if(this.signal)
         {
            this.signal.stop();
         }
         Facade.myMediator.myPanel.setCapitalMode(false);
         this.clanEmblem.removeFromParent();
         this.capitalPanel.removeFromParent();
      }
      
      public function init(param1:PCapital) : void
      {
         var _loc2_:PBase = null;
         var _loc5_:PShopUnit = null;
         _loc2_ = param1.cap_base;
         var _loc3_:MyPanel = Facade.myMediator.myPanel;
         _loc3_.setCapitalMode(true);
         this.capitalPanel.addChildAt(_loc3_.leftPanel,0);
         this.capitalPanel.clanText.value = _loc2_.name;
         SkinManager.applyExternal(this.clanEmblem,UIFactory.EMBLEM_PACK,_loc2_.icon,SkinManager.LOAD_CLIP);
         _loc3_.expPanel.add(this.clanEmblem,{
            "w":65,
            "h":65,
            "top":11,
            "left":11
         },_loc3_.expPanel.getChildIndex(_loc3_.expPanel.levelPanel));
         Facade.myMediator.updateStorageMax();
         var _loc4_:Boolean = Boolean(param1.cap_role);
         if(_loc4_)
         {
            if(this.up.clan)
            {
               this.up.clan.uc_icon = _loc2_.icon;
               this.up.clan.uc_level = _loc2_.level;
               this.up.clan.uc_role = param1.cap_role;
               this.myResourceList = new <uint>[this.up.oilMax,this.up.crystalMax,this.up.oil,this.up.crystal,this.up.gold,this.up.mithril];
            }
            else
            {
               this.up.clan = PUserClan.create(_loc2_.id,_loc2_.name,_loc2_.icon,_loc2_.level,param1.cap_role,0,0,0,null,0);
            }
         }
         this.up.assignCapital(_loc2_);
         for each(_loc5_ in this.mp.soldierShopList)
         {
            if(_loc5_.su_is_clan && _loc5_.su_level == 1 && _loc5_.su_can_buy)
            {
               this.up.soldierLevelHash[_loc5_.su_kind] = 0;
            }
         }
         Facade.mainPanel.showCommonPanel(this.capitalPanel);
         this.capitalPanel.assignButtons(_loc4_,this.myResourceList != null);
         this.capitalPanel.addListener(VEvent.VARIANCE,this.onVariance);
         if(_loc4_)
         {
            _loc3_.syncClanButton(true,true);
            if(_loc3_.lbPanel)
            {
               this.capitalPanel.addChild(_loc3_.lbPanel);
            }
            if(param1.cap_edit_lock)
            {
               this.startEditTime = param1.cap_edit_lock.cel_last_time;
               this.memberEditId = param1.cap_edit_lock.cel_user_id;
               if(this.memberEditId == Preloader.uid)
               {
                  this.memberEditId = null;
               }
            }
            this.signal = new Signal(this.onSignal);
            Facade.protoProxy.request(new Packet_0060_03(),this.resultClanData,96,2,[param1],"getClanData");
         }
         else
         {
            _loc3_.workerPanel.setCustom(this.up.workerMax.toString());
            _loc3_.workerPanel.removeBuyBt();
         }
      }
      
      private function resultClanData(param1:BinaryBuffer, param2:PCapital) : void
      {
         var _loc3_:PUnitsLevel = null;
         if(!this.capitalPanel.parent)
         {
            return;
         }
         this.up.assignClanData(new Packet_0060_02(param1).value);
         for each(_loc3_ in this.up.clanData.units_levels)
         {
            this.up.soldierLevelHash[_loc3_.ul_kind] = _loc3_.ul_level;
         }
         MainLogic.useActions(param2.cap_um,null);
         this.checkEditMode(true);
         Facade.gameStream.assign(param2.cap_um.init_time,this.onGameStream).run(PEventPlace.MY_CAPITAL,param2.cap_base.id);
      }
      
      private function checkEditMode(param1:Boolean = false) : void
      {
         var _loc3_:String = null;
         var _loc5_:PMember = null;
         if(param1)
         {
            this.isAllowEdit = this.up.checkClanRolePermission(PPermission.ARCHITECT);
         }
         var _loc2_:Boolean = false;
         var _loc4_:Number = 0;
         if(this.memberEditId)
         {
            _loc4_ = this.startEditTime + Facade.references.edit_capital_timeout - CoreLogic.serverTime;
            if(_loc4_ > 0)
            {
               _loc2_ = true;
               _loc5_ = this.up.getClanMember(this.memberEditId);
               if(_loc5_)
               {
                  _loc3_ = this.memberEditId;
               }
               else
               {
                  _loc3_ = "...";
               }
            }
            else
            {
               this.memberEditId = null;
            }
         }
         if(this.isAllowEdit && !_loc2_)
         {
            _loc3_ = "ok";
         }
         if(this.showId != _loc3_)
         {
            this.showId = _loc3_;
            this.capitalPanel.showEditInfo(_loc2_ ? Lang.getPatternString("capital_edit","__NAME__",_loc5_ ? _loc5_.user_base.name : "...") : (this.isAllowEdit ? Lang.getString("capital_allow_edit") : null));
         }
         Facade.boardMediator.allowMoveState = this.isAllowEdit && !_loc2_;
         if(_loc4_ > 0)
         {
            this.signal.delayCall(_loc4_);
         }
         else
         {
            this.signal.stop();
         }
      }
      
      private function onSignal() : void
      {
         this.memberEditId = null;
         this.checkEditMode();
      }
      
      private function onVariance(param1:VEvent) : void
      {
         if(param1.variance == 0)
         {
            MainLogic.getMyMap();
         }
         else if(param1.variance == 1)
         {
            this.toShop();
         }
         else if(param1.variance == 2)
         {
            DialogLogic.openDonate(this.myResourceList);
         }
      }
      
      public function toShop(param1:String = null, param2:String = null) : void
      {
         var _loc3_:ShopMediator = new ShopMediator(param1,param2,false,new <String>[ShopMediator.DEFENCE,ShopMediator.ARMY,ShopMediator.RESOURCE,ShopMediator.CURRENCY,ShopMediator.DECOR]);
         _loc3_.buyHandler = this.onBuy;
         Facade.mainMediator.showDialog(_loc3_);
      }
      
      private function onBuy(param1:Object) : void
      {
         if(Facade.boardMediator.allowMoveState)
         {
            ShopLogic.buy(param1);
         }
         else
         {
            Facade.mainMediator.showMessage(Lang.getString(this.isAllowEdit ? "capital_bad_shop" : "capital_shop_lock"));
         }
      }
      
      private function onGameStream(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:PRaidFriendEvent = null;
         var _loc4_:PRaidEvent = null;
         var _loc5_:PClanAction = null;
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_.rf_event;
            switch(_loc4_.variance)
            {
               case PRaidEvent.CLAN_ACTION:
                  for each(_loc5_ in _loc4_.value)
                  {
                     this.useClanAction(_loc5_,_loc3_.rf_friend_id);
                  }
                  break;
               case PRaidEvent.NEW_GARBAGES:
                  this.addGarbageList(_loc4_.value);
                  break;
               case PRaidEvent.CLAN_DONATE:
                  ShopLogic.applyCost(_loc3_.rf_event.value);
                  break;
               case PRaidEvent.DEL_CLAN_MEMBER:
                  if(_loc4_.value == Preloader.uid)
                  {
                     MainLogic.getMyMap();
                  }
                  break;
               case PRaidEvent.SET_CLAN_ROLE:
                  if((_loc4_.value as PSetRole).sr_user_id == Preloader.uid)
                  {
                     if(this.isAllowEdit)
                     {
                        Facade.boardMediator.resetMoved();
                     }
                     this.up.clan.uc_role = (_loc4_.value as PSetRole).sr_role;
                     this.checkEditMode(true);
                  }
                  break;
               case PRaidEvent.CHANGE_CLAN:
                  this.up.clan.uc_icon = PChangeClan(_loc4_.value).cc_icon;
                  SkinManager.applyExternal(this.clanEmblem,UIFactory.EMBLEM_PACK,this.up.clan.uc_icon,SkinManager.LOAD_CLIP);
                  break;
               case PRaidEvent.START_STORM:
                  if((_loc4_.value as PStartStorm).attacker_id != this.up.clan.uc_clan_id)
                  {
                     MainLogic.getMyMap();
                     Facade.mainMediator.showMessage(Lang.getString("capital_lock"));
                     return;
                  }
                  break;
               case PRaidEvent.CHAT_MESSAGE:
               case PRaidEvent.UPDATE_CALL_REQUEST:
               case PRaidEvent.ASK:
               case PRaidEvent.HELP:
               case PRaidEvent.NEW_CLAN_REQUEST:
                  if(!_loc2_)
                  {
                     _loc2_ = [];
                  }
                  _loc2_.push(_loc3_);
            }
         }
         if(_loc2_)
         {
            Facade.myMediator.onGameStream(_loc2_);
         }
      }
      
      private function addGarbageList(param1:Array) : void
      {
         var _loc2_:PGarbage = null;
         for each(_loc2_ in param1)
         {
            (UnitFactory.createConstruction(this.mp.getGarbageShop(_loc2_.garbage_kind),_loc2_.garbage_id,_loc2_.garbage_pos) as Garbage).prize = _loc2_.garbage_remove_prize;
         }
      }
      
      private function useClanAction(param1:PClanAction, param2:String) : void
      {
         var _loc3_:Build = null;
         if(param1.variance != PClanAction.COLLECT_RESOURCE)
         {
            this.startEditTime = CoreLogic.serverTime;
            this.memberEditId = param2;
            this.checkEditMode();
            if(this.isAllowEdit)
            {
               Facade.boardMediator.resetMoved();
            }
            this.applyClanAction(param1.variance,param1.value);
         }
         else
         {
            _loc3_ = this.up.constructionHash[param1.value] as Build;
            if(Boolean(_loc3_) && _loc3_.type == PBtype.RESOURCE)
            {
               UnitFactory.buildLogic.collectResource(_loc3_,false,false,true);
            }
         }
      }
      
      private function applyClanAction(param1:uint, param2:*) : void
      {
         var _loc3_:Unit = null;
         switch(param1)
         {
            case PClanAction.MOVE:
               this.moveObjects(param2);
               break;
            case PClanAction.REMOVE_GARBAGE:
               _loc3_ = this.up.constructionHash[param2] as Garbage;
               if(_loc3_)
               {
                  UnitFactory.garbageLogic.startCleanup(_loc3_ as Garbage,false);
               }
               break;
            case PClanAction.SPEED_UP_GARBAGE:
               ShopLogic.applyCost(PSpeedUp(param2).su_cost,true);
               CoreLogic.removeFilterActions(PSpeedUp(param2).su_obj_id,ActionLogic.CLEANUP_GARBAGE,true);
               break;
            case PClanAction.SPEED_UP_BUILDING:
            case PClanAction.SPEED_UP_CANNON:
               ShopLogic.applyCost(PSpeedUp(param2).su_cost,true);
               CoreLogic.removeFilterActions(PSpeedUp(param2).su_obj_id,ActionLogic.FINISH_CONSTRUCTION,true);
               break;
            case PClanAction.UPGRADE:
               this.updateObject(param2);
               break;
            case PClanAction.BUY_OBJECT:
               this.buyObject(param2);
               break;
            case PClanAction.BUY_RESOURCE_BY_GOLD:
               this.buyResource(param2);
               break;
            case PClanAction.CANCEL_CONSTRUCTING_BUILDING:
            case PClanAction.CANCEL_CONSTRUCTING_CANNON:
            case PClanAction.CANCEL_REMOVE_GARBAGE:
               _loc3_ = this.up.constructionHash[param2] as Unit;
               if(_loc3_)
               {
                  ShopLogic.onConfirmCancel(_loc3_,param1 == PClanAction.CANCEL_REMOVE_GARBAGE ? ActionLogic.CLEANUP_GARBAGE : ActionLogic.FINISH_CONSTRUCTION,false);
               }
               break;
            case PClanAction.SELL_DECOR:
               _loc3_ = this.up.constructionHash[param2] as Decor;
               if(_loc3_)
               {
                  UnitFactory.decorLogic.confirmSell(_loc3_ as Decor,false);
               }
         }
      }
      
      private function buyObject(param1:PBoardObj) : void
      {
         var _loc2_:Object = null;
         switch(param1.bo_type.variance)
         {
            case PObjType.BUILDING:
               _loc2_ = this.mp.getBuildShop(param1.bo_kind,1);
               break;
            case PObjType.CANNON:
               _loc2_ = this.mp.getCannonShop(param1.bo_kind,1);
               break;
            case PObjType.FENCE:
               _loc2_ = this.mp.getFenceShop(param1.bo_kind,1);
               break;
            case PObjType.DECOR:
               _loc2_ = this.mp.getDecorShop(param1.bo_kind);
               break;
            default:
               return;
         }
         var _loc3_:Unit = UnitFactory.createConstruction(_loc2_,0,null);
         Facade.boardMediator.addNewObject(_loc3_,false);
         _loc3_.setGeometry(param1.bo_pos.x,param1.bo_pos.y,true);
         _loc3_.stand();
         BoardLogic.bind(_loc3_,true);
         ShopLogic.confirmBuy(_loc3_,_loc2_,false);
         if(_loc3_ is Fence)
         {
            FenceLogic.connect(_loc3_ as Fence);
            FenceLogic.aroundConnect(_loc3_.b_x,_loc3_.b_y);
         }
         var _loc4_:ShopMediator = Facade.mainMediator.searchDialog(ShopMediator);
         if(_loc4_)
         {
            _loc4_.dialog.close();
            this.toShop();
         }
      }
      
      private function updateObject(param1:PObjectId) : void
      {
         var _loc2_:Unit = null;
         var _loc3_:PShopBuilding = null;
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:PShopCannon = null;
         _loc2_ = this.up.constructionHash[param1.value] as Unit;
         if(!_loc2_)
         {
            return;
         }
         switch(param1.variance)
         {
            case PObjectId.BUILDING:
               _loc3_ = this.mp.getBuildShop(_loc2_.kind,_loc2_.level + 1);
               _loc4_ = _loc3_.sb_price;
               _loc5_ = _loc3_.sb_upgrade_time;
               break;
            case PObjectId.CANNON:
               _loc6_ = this.mp.getCannonShop(_loc2_.kind,_loc2_.level + 1);
               _loc4_ = _loc6_.sc_price;
               _loc5_ = _loc6_.sc_upgrade_time;
               break;
            case PObjectId.FENCE:
               _loc4_ = this.mp.getFenceShop(_loc2_.kind,_loc2_.level + 1).sf_price;
               _loc5_ = 0;
               break;
            default:
               return;
         }
         BuildLogic.startUpdate(_loc2_,_loc4_,_loc5_,false);
      }
      
      private function buyResource(param1:PCost) : void
      {
         ShopLogic.applyCost(ShopLogic.getExchangeCost(param1.variance,param1.value),true);
         ShopLogic.applyCost(param1,false,false);
      }
      
      private function moveObjects(param1:Array) : void
      {
         var _loc3_:PMove = null;
         var _loc4_:Unit = null;
         var _loc2_:* = int(param1.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = this.up.constructionHash[_loc3_.move_id.value] as Unit;
            if(_loc4_)
            {
               Facade.boardMediator.resetSelected(_loc4_);
               BoardLogic.bind(_loc4_,false);
               if(_loc4_ is Fence)
               {
                  FenceLogic.aroundConnect(_loc4_.b_x,_loc4_.b_y);
               }
               _loc4_.setGeometry(_loc3_.move_pos.x,_loc3_.move_pos.y,true);
            }
            param1[_loc2_] = _loc4_;
            _loc2_--;
         }
         for each(_loc4_ in param1)
         {
            if(_loc4_)
            {
               BoardLogic.bind(_loc4_,true);
               if(_loc4_ is Fence)
               {
                  FenceLogic.connect(_loc4_ as Fence);
                  FenceLogic.aroundConnect(_loc4_.b_x,_loc4_.b_y);
               }
            }
         }
      }
      
      public function lock() : void
      {
         Facade.protoProxy.clear();
         if(this.signal)
         {
            Facade.gameStream.clear();
            this.signal.stop();
         }
         var _loc1_:MessageDialog = new MessageDialog(Lang.getString("capital_bad_edit"),null,SkinManager.getEmbed("EditorIcon"),MessageDialog.HIDE_CLOSE_BUTTON);
         _loc1_.addDelegateRectButton(Lang.getString("bt_next"),MainLogic.getCapitalMap);
         Facade.mainMediator.showDialog(_loc1_);
      }
      
      public function getAllowEdit() : Boolean
      {
         return this.isAllowEdit;
      }
   }
}

