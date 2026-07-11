package game.clan.center
{
   import clans.ClanDialog;
   import game.common.DialogMediator;
   import game.political.PoliticalMapMediator;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import logic.EventLogic;
   import logic.ShopLogic;
   import logic.UnitFactory;
   import model.CommonEvent;
   import model.UserProxy;
   import proto.BinaryBuffer;
   import proto.game.family_0060.Packet_0060_01;
   import proto.game.family_0060.Packet_0060_02;
   import proto.game.family_0060.Packet_0060_03;
   import proto.game.family_0060.Packet_0060_0D;
   import proto.game.family_0060.Packet_0060_15;
   import proto.game.family_0060.Packet_0060_16;
   import proto.model.PEventPlace;
   import proto.model.PPermission;
   import proto.model.PRaidEvent;
   import proto.model.PRole;
   import proto.model.PShopClanIcon;
   import proto.model.PUnitsLevel;
   import proto.model.PUserClan;
   import proto.model.clan.PBase;
   import proto.model.clan.PCapitalLogKind;
   import proto.model.clan.PChangeClan;
   import proto.model.clan.PClan;
   import proto.model.clan.PCreateClan;
   import proto.model.clan.PEntryPolicy;
   import proto.model.clan.PSetRole;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import utils.ClickStatistic;
   import utils.StringHelper;
   
   public class ClanEditMediator extends DialogMediator
   {
      
      private const dialog:BaseDialog = new BaseDialog();
      
      private var editPanel:ClanEditPanel;
      
      private var emblemIndex:uint;
      
      public function ClanEditMediator()
      {
         super();
      }
      
      public static function joinClan(param1:PUserClan, param2:PClan = null, param3:Function = null) : void
      {
         resultJoinRequest(null,[param1,param2,null,CoreLogic.getCheckTime(),param3]);
      }
      
      private static function resultJoinRequest(param1:BinaryBuffer, param2:Array) : void
      {
         var _loc3_:UserProxy = null;
         var _loc4_:PUnitsLevel = null;
         if(param1)
         {
            if(CoreLogic.getCheckTime() != param2[3])
            {
               return;
            }
            if(param1.family == 96 && param1.subfamily == 2)
            {
               param2[1] = new Packet_0060_02(param1).value;
            }
            else if(param1.family == 96 && param1.subfamily == 22)
            {
               param2[2] = new Packet_0060_16(param1).value;
            }
         }
         if(!param2[1])
         {
            Facade.protoProxy.request(new Packet_0060_03(),resultJoinRequest,96,2,[param2],"getClanData");
         }
         else if(!param2[2])
         {
            Facade.protoProxy.request(new Packet_0060_15(),resultJoinRequest,96,22,[param2],"getRequests");
         }
         else
         {
            _loc3_ = Facade.userProxy;
            _loc3_.clan = param2[0];
            _loc3_.assignClanData(param2[1]);
            for each(_loc4_ in _loc3_.clanData.units_levels)
            {
               _loc3_.soldierLevelHash[_loc4_.ul_kind] = _loc4_.ul_level;
            }
            _loc3_.applyCallList(param2[2]);
            ActionLogic.addRecoveryRequestEnergy(null,_loc3_.clan.uc_clan_calls_time);
            UnitFactory.buildLogic.syncClanCenter();
            Facade.myMediator.syncClanButton();
            Facade.myMediator.getChatHistory();
            EventLogic.sync();
            Facade.gameStream.run(PEventPlace.NOTHING,_loc3_.clan.uc_clan_id);
            Facade.mainMediator.searchDialog(ClanCenterDialog,true);
            Facade.mainMediator.searchDialog(ClanInfoDialog,true);
            Facade.mainMediator.searchDialog(ClanDialog,true);
            Facade.mainMediator.searchDialog(ClanCenterDialog,true);
            Facade.mainMediator.searchDialog(ClanInfoDialog,true);
            Facade.mainMediator.searchDialog(ClanDialog,true);
            Facade.mainMediator.searchDialog(ClanCenterDialog,true);
            Facade.mainMediator.searchDialog(ClanInfoDialog,true);
            Facade.mainMediator.searchDialog(ClanDialog,true);
            DialogLogic.openClanCenter();
            Facade.mainPanel.hideLoadPanel();
            if(param2[4] is Function)
            {
               param2[4]();
            }
         }
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog.useDefaultBg(588,Lang.getString(up.clan ? "edit_clan" : "new_clan"));
         this.assign();
         Facade.addListenerForComponent(CommonEvent.MY_GAME_STREAM,this.onGameStream,this.dialog);
         ClickStatistic.startTime();
         return this.dialog;
      }
      
      private function assign(param1:PCreateClan = null) : void
      {
         if(this.editPanel)
         {
            this.editPanel.removeFromParent();
         }
         var _loc2_:uint = mp.levelList.length + 1;
         var _loc3_:PBase = up.clanData ? up.clanData.base : null;
         if(_loc3_)
         {
            this.editPanel = new ClanEditPanel(_loc2_,_loc3_.entry_policy.variance,_loc3_.icon);
            this.editPanel.useEditMode(_loc3_.name,_loc3_.description,_loc3_.min_level);
         }
         else
         {
            if(param1)
            {
               this.editPanel = new ClanEditPanel(_loc2_,param1.entry_policy.variance,param1.icon);
               this.editPanel.descInput.value = param1.description;
               this.editPanel.levelReqPanel.value = param1.min_level;
            }
            else
            {
               this.editPanel = new ClanEditPanel(_loc2_,PEntryPolicy.FREE,"emblem1");
            }
            this.editPanel.useNewMode(Facade.references.create_clan_price);
            if(param1)
            {
               this.editPanel.titleInput.value = param1.name;
            }
         }
         this.dialog.add(this.editPanel,{
            "w":778,
            "h":472,
            "hCenter":0,
            "top":83
         });
         this.editPanel.addEventListener(VEvent.VARIANCE,this.onVariance);
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = param1.variance;
         ClickStatistic.clan(_loc2_,ClanEditPanel,"CLAN_EDIT");
         switch(_loc2_)
         {
            case ClanEditPanel.SAVE:
               this.saveEditClan();
               break;
            case ClanEditPanel.CANCEL:
               this.dialog.close();
               break;
            case ClanEditPanel.EDIT_EMBLEM:
               this.showEmblemDialog();
               break;
            case ClanEditPanel.CREATE:
               this.createClan();
         }
      }
      
      private function showEmblemDialog() : void
      {
         var _loc1_:BaseDialog = null;
         var _loc3_:PShopClanIcon = null;
         var _loc4_:uint = 0;
         _loc1_ = new BaseDialog();
         _loc1_.mediator = "emblems";
         _loc1_.useWhiteBg(770,656,Lang.getString("clan_select_emblem"));
         var _loc2_:Array = [];
         for each(_loc3_ in mp.clanEmblemShopList)
         {
            if(Boolean(up.clanData) && up.clanData.premium_icons.indexOf(_loc3_.sci_kind) >= 0)
            {
               _loc2_.push(PShopClanIcon.create(_loc3_.sci_kind,null));
            }
            else
            {
               _loc2_.push(_loc3_);
            }
         }
         _loc4_ = 1;
         while(_loc4_ <= 96)
         {
            _loc2_.push("emblem" + _loc4_);
            _loc4_++;
         }
         var _loc5_:VGrid = new VGrid(4,4,EmblemRenderer,_loc2_,10,10,VGrid.USE_NULL_DATA,this.emblemIndex);
         _loc5_.dispatcher = _loc1_;
         _loc1_.add(_loc5_,{
            "hCenter":0,
            "top":84
         });
         _loc1_.addListener(VEvent.VARIANCE,this.onEmblemSelect);
         _loc5_.addListener(VEvent.CHANGE,this.onEmblemIndexChange);
         UIFactory.useGridControlH43(_loc5_,false);
         Facade.mainMediator.showDialog(_loc1_);
      }
      
      private function onEmblemSelect(param1:VEvent) : void
      {
         var _loc2_:PShopClanIcon = null;
         var _loc3_:String = null;
         var _loc4_:EmblemBuyDialog = null;
         if(param1.data is PShopClanIcon)
         {
            _loc2_ = param1.data as PShopClanIcon;
            if(_loc2_.sci_price)
            {
               _loc4_ = new EmblemBuyDialog(_loc2_,up.clanData);
               _loc4_.addListener(VEvent.VARIANCE,this.onEmblemBuy);
               Facade.mainMediator.showDialog(_loc4_);
               return;
            }
            _loc3_ = _loc2_.sci_kind;
         }
         else
         {
            _loc3_ = String(param1.data);
         }
         this.editPanel.setEmblem(_loc3_);
         BaseDialog(param1.currentTarget).close();
      }
      
      private function onEmblemBuy(param1:VEvent) : void
      {
         var _loc3_:PBase = null;
         var _loc2_:PShopClanIcon = param1.data as PShopClanIcon;
         if(PoliticalMapMediator.checkClanPrice(_loc2_.sci_price,"emblem_change"))
         {
            up.applyClanPrice(_loc2_.sci_price,true,PCapitalLogKind.UNKNOWN);
            up.clanData.premium_icons.push(_loc2_.sci_kind);
            _loc3_ = up.clanData.base;
            Facade.protoProxy.request(new Packet_0060_0D(PChangeClan.create(_loc3_.min_level,_loc3_.entry_policy,_loc3_.description,_loc2_.sci_kind)),null,96,14);
            Facade.mainMediator.searchDialog("emblems",true);
            this.editPanel.setEmblem(_loc2_.sci_kind);
         }
         (param1.currentTarget as BaseDialog).close();
      }
      
      private function onEmblemIndexChange(param1:VEvent) : void
      {
         this.emblemIndex = param1.data;
      }
      
      private function saveEditClan() : void
      {
         var _loc2_:PBase = null;
         var _loc1_:PChangeClan = PChangeClan.create(this.editPanel.levelReqPanel.value,PEntryPolicy.create(this.editPanel.policyCb.data),this.editPanel.descInput.value,this.editPanel.emblem);
         if(!_loc1_.cc_description || _loc1_.cc_description.length < 2)
         {
            Facade.mainMediator.showMessage(Lang.getString("clan_edit_empty"));
         }
         else
         {
            _loc2_ = up.clanData.base;
            _loc2_.description = _loc1_.cc_description;
            _loc2_.min_level = _loc1_.cc_min_level;
            _loc2_.entry_policy.variance = _loc1_.cc_entry_policy.variance;
            _loc2_.icon = _loc1_.cc_icon;
            Facade.protoProxy.request(new Packet_0060_0D(_loc1_),null,96,14);
            this.dispatchChange();
         }
      }
      
      private function createClan() : void
      {
         var _loc1_:PCreateClan = PCreateClan.create(StringHelper.trim(this.editPanel.titleInput.value),this.editPanel.emblem,this.editPanel.levelReqPanel.value,PEntryPolicy.create(this.editPanel.policyCb.data),StringHelper.trim(this.editPanel.descInput.value));
         if(!_loc1_.name || _loc1_.name.length < 2 || !_loc1_.description || _loc1_.description.length < 2)
         {
            Facade.mainMediator.showMessage(Lang.getString("clan_edit_empty"));
         }
         else
         {
            _loc1_.name = _loc1_.name.replace(/ {2,}/g," ");
            if(ShopLogic.checkPrice(Facade.references.create_clan_price,this.createClan))
            {
               ShopLogic.applyCost(Facade.references.create_clan_price,true);
               Facade.mainPanel.showLoadPanel(Lang.getString("clan_create"));
               Facade.protoProxy.request(new Packet_0060_01(_loc1_),this.resultCreateClan,0,0,[_loc1_,CoreLogic.getCheckTime()]);
            }
         }
      }
      
      private function resultCreateClan(param1:BinaryBuffer, param2:PCreateClan, param3:int) : void
      {
         var _loc4_:PClan = null;
         var _loc5_:PBase = null;
         var _loc6_:Number = NaN;
         var _loc7_:Array = null;
         var _loc8_:* = 0;
         if(param3 != CoreLogic.getCheckTime())
         {
            return;
         }
         Facade.mainPanel.hideLoadPanel();
         if(param1.family == 96 && param1.subfamily == 4)
         {
            ShopLogic.applyCost(Facade.references.create_clan_price);
            Facade.mainMediator.showMessage(Lang.getString("clan_name_copy"));
            this.assign(param2);
         }
         else
         {
            _loc4_ = new Packet_0060_02(param1).value;
            _loc5_ = _loc4_.base;
            _loc6_ = CoreLogic.serverTime;
            _loc7_ = ["un_warrior_elite","un_warrior_mithril"];
            _loc8_ = int(_loc7_.length - 1);
            while(_loc8_ >= 0)
            {
               up.soldierLevelHash[_loc7_[_loc8_]] = 1;
               _loc8_--;
            }
            joinClan(PUserClan.create(_loc5_.id,_loc5_.name,_loc5_.icon,_loc5_.level,PRole.create(PRole.CREATOR),0,_loc6_,_loc6_,_loc7_,_loc6_),_loc4_,this.dispatchChange);
         }
      }
      
      private function dispatchChange() : void
      {
         this.dialog.dispatchEvent(new VEvent(VEvent.CHANGE));
         this.dialog.close();
      }
      
      private function onGameStream(param1:CommonEvent) : void
      {
         var _loc2_:PRaidEvent = param1.data;
         if(_loc2_.variance == PRaidEvent.DEL_CLAN_MEMBER)
         {
            if(_loc2_.value == Preloader.uid)
            {
               this.dialog.close();
            }
         }
         else if(_loc2_.variance == PRaidEvent.SET_CLAN_ROLE)
         {
            if((_loc2_.value as PSetRole).sr_user_id == Preloader.uid && !up.checkClanRolePermission(PPermission.INFO))
            {
               this.dialog.close();
            }
         }
      }
   }
}

