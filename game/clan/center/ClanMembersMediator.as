package game.clan.center
{
   import game.common.DialogMediator;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import logic.MainLogic;
   import logic.ShopLogic;
   import model.CommonEvent;
   import model.ManualProxy;
   import model.vo.VOClanMember;
   import proto.BinaryBuffer;
   import proto.game.family_0060.Packet_0060_0E;
   import proto.game.family_0060.Packet_0060_0F;
   import proto.game.family_0060.Packet_0060_10;
   import proto.game.family_0060.Packet_0060_38;
   import proto.game.family_0060.Packet_0060_3B;
   import proto.model.PClanCompPlaceRequest;
   import proto.model.PClanReward;
   import proto.model.PCost;
   import proto.model.PPermission;
   import proto.model.PRaidEvent;
   import proto.model.PRole;
   import proto.model.PShopClanRole;
   import proto.model.PUsersClanPoints;
   import proto.model.clan.PClan;
   import proto.model.clan.PMember;
   import proto.model.clan.PSetRole;
   import proto.tuples.str_uint;
   import ui.Style;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   
   public class ClanMembersMediator extends DialogMediator
   {
      
      private const dialog:MembersDialog = new MembersDialog();
      
      public var clan:PClan;
      
      public function ClanMembersMediator(param1:PClan)
      {
         super();
         this.clan = param1 || up.clanData;
      }
      
      public static function showMemberMenu(param1:PMember, param2:Array, param3:Boolean, param4:VComponent, param5:VButton, param6:Number, param7:Number, param8:Boolean = true) : void
      {
         if(param1.user_base.user_id == Preloader.uid)
         {
            return;
         }
         var _loc9_:Vector.<VComponent> = new <VComponent>[MenuPanel.createButton(Lang.getString("to_friend"),0,param1,null,RectButton.YELLOW)];
         if(param3)
         {
            addPermissionMenuItem(_loc9_,param1,param2,param8);
         }
         var _loc10_:MenuPanel = new MenuPanel(_loc9_);
         _loc10_.addListener(VEvent.VARIANCE,onMemberMenu);
         _loc10_.show(param4,param5,param6,param7);
      }
      
      private static function addPermissionMenuItem(param1:Vector.<VComponent>, param2:PMember, param3:Array, param4:Boolean) : void
      {
         var _loc9_:PShopClanRole = null;
         var _loc10_:* = 0;
         var _loc11_:uint = 0;
         var _loc5_:ManualProxy = Facade.manualProxy;
         var _loc6_:PShopClanRole = _loc5_.getClanRoleInfo(Facade.userProxy.clan.uc_role.variance);
         var _loc7_:uint = _loc5_.getRolePermission(_loc6_);
         var _loc8_:PShopClanRole = _loc5_.getClanRoleInfo(param2.role.variance);
         if(_loc6_.scr_role_kind.variance == PRole.CREATOR)
         {
            param1.push(MenuPanel.createButton(Lang.getString("clan_role0"),4,param2,null,RectButton.GREEN));
         }
         if(_loc8_.scr_role_priority > _loc6_.scr_role_priority)
         {
            if((_loc7_ & 1 << PPermission.ROLE) != 0)
            {
               if(param4)
               {
                  for each(_loc9_ in _loc5_.clanRoleList)
                  {
                     if(_loc9_ != _loc8_ && _loc6_.scr_role_priority < _loc9_.scr_role_priority)
                     {
                        if(checkRoleUnique(param3,_loc9_))
                        {
                           param1.push(MenuPanel.createButton(Lang.getString("clan_role" + _loc9_.scr_role_kind.variance),_loc8_.scr_role_priority - _loc9_.scr_role_priority > 0 ? 1 : 2,param2,_loc9_));
                        }
                     }
                  }
               }
               else
               {
                  _loc10_ = int(_loc8_.scr_role_priority - 1);
                  while(_loc10_ > _loc6_.scr_role_priority)
                  {
                     _loc9_ = _loc5_.getClanRoleInfo(_loc10_,false,true);
                     if((Boolean(_loc9_)) && checkRoleUnique(param3,_loc9_))
                     {
                        param1.push(MenuPanel.createButton(Lang.getString("clan_role_up"),1,param2,_loc9_));
                        break;
                     }
                     _loc10_--;
                  }
                  _loc11_ = _loc5_.getClanRoleInfo(PRole.BEGINNER).scr_role_priority;
                  _loc10_ = int(_loc8_.scr_role_priority + 1);
                  while(_loc10_ <= _loc11_)
                  {
                     _loc9_ = _loc5_.getClanRoleInfo(_loc10_,false,true);
                     if((Boolean(_loc9_)) && checkRoleUnique(param3,_loc9_))
                     {
                        param1.push(MenuPanel.createButton(Lang.getString("clan_role_down"),2,param2,_loc9_));
                        break;
                     }
                     _loc10_++;
                  }
               }
            }
            if((_loc7_ & 1 << PPermission.OUST) != 0)
            {
               param1.push(MenuPanel.createButton(Lang.getString("clan_ban"),3,param2,null,RectButton.ORANGE));
            }
         }
      }
      
      private static function checkRoleUnique(param1:Array, param2:PShopClanRole) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:PMember = null;
         if(param2.scr_role_is_unique)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = param1[_loc3_] is PMember ? param1[_loc3_] : (param1[_loc3_] as VOClanMember).user;
               if(_loc4_.role.variance == param2.scr_role_kind.variance)
               {
                  return false;
               }
               _loc3_++;
            }
         }
         return true;
      }
      
      private static function onMemberMenu(param1:VEvent) : void
      {
         var _loc2_:Array = null;
         var _loc5_:ClanCenterMediator = null;
         var _loc6_:ClanMembersMediator = null;
         var _loc7_:PShopClanRole = null;
         (param1.currentTarget as MenuPanel).removeFromParent();
         _loc2_ = param1.data;
         var _loc3_:uint = uint(_loc2_[0]);
         var _loc4_:PMember = _loc2_[1];
         switch(_loc3_)
         {
            case 0:
               _loc5_ = Facade.mainMediator.searchDialog(ClanCenterMediator);
               if(_loc5_)
               {
                  Facade.setMapCallback(reopen,[_loc5_.getClanInfo()]);
               }
               _loc6_ = Facade.mainMediator.searchDialog(ClanMembersMediator);
               if(_loc6_)
               {
                  Facade.setMapCallback(DialogLogic.open,[new ClanMembersMediator(_loc6_.clan)]);
               }
               MainLogic.getFriendMap(_loc4_.user_base.user_id);
               break;
            case 1:
            case 2:
               _loc7_ = _loc2_[2];
               Facade.mainMediator.showDialog(new ClanRoleDialog(_loc4_,_loc7_,Lang.getString(_loc3_ == 1 ? "clan_role_up" : "clan_role_down"),confirmChangeRole,[_loc4_,_loc7_]));
               break;
            case 3:
               if(Facade.userProxy.clanData.war)
               {
                  Facade.mainMediator.showMessage(Lang.getString("clan_leave_block"));
                  break;
               }
               if(checkRegent(_loc4_,true))
               {
                  Facade.mainMediator.showYesNoDialog(Lang.getPatternString("clan_member_ban","__NAME__","<span" + Style.redColor + ">" + _loc4_.user_base.name + "</span>"),confirmBan,[_loc4_]);
               }
               break;
            case 4:
               Facade.mainMediator.showDialog(new ClanRoleDialog(_loc4_,Facade.manualProxy.getClanRoleInfo(PRole.CREATOR,true),Lang.getString("clan_role_up"),confirmChangeCreator,[_loc4_],Facade.references.change_creator_price));
         }
      }
      
      private static function confirmChangeRole(param1:PMember, param2:PShopClanRole) : void
      {
         param1.role.variance = param2.scr_role_kind.variance;
         var _loc3_:PSetRole = PSetRole.create(param1.user_base.user_id,param2.scr_role_kind);
         Facade.protoProxy.request(new Packet_0060_10(_loc3_),null,96,17);
         Facade.dispatchCommonEvent(CommonEvent.MY_GAME_STREAM,PRaidEvent.create(PRaidEvent.SET_CLAN_ROLE,_loc3_));
      }
      
      private static function confirmChangeCreator(param1:PMember) : void
      {
         var _loc2_:PSetRole = null;
         if(ShopLogic.checkPrice(Facade.references.change_creator_price))
         {
            ShopLogic.applyCost(Facade.references.change_creator_price,true);
            _loc2_ = PSetRole.create(Preloader.uid,PRole.create(PRole.BEGINNER));
            Facade.userProxy.setClanRole(_loc2_);
            Facade.dispatchCommonEvent(CommonEvent.MY_GAME_STREAM,PRaidEvent.create(PRaidEvent.SET_CLAN_ROLE,_loc2_));
            Facade.protoProxy.request(new Packet_0060_38(param1.user_base.user_id));
         }
      }
      
      private static function confirmBan(param1:PMember) : void
      {
         Facade.userProxy.deleteMember(param1.user_base.user_id);
         Facade.dispatchCommonEvent(CommonEvent.MY_GAME_STREAM,PRaidEvent.create(PRaidEvent.DEL_CLAN_MEMBER,param1.user_base.user_id));
         Facade.protoProxy.request(new Packet_0060_0F(param1.user_base.user_id),resultBan,0,0,[param1,CoreLogic.getCheckTime()]);
         var _loc2_:ClanMembersMediator = Facade.mainMediator.searchDialog(ClanMembersMediator);
         if(_loc2_)
         {
            _loc2_.updateMembersData();
         }
      }
      
      private static function resultBan(param1:BinaryBuffer, param2:PMember, param3:int) : void
      {
         var _loc4_:PClan = Facade.userProxy.clanData;
         if(!_loc4_ || param3 != CoreLogic.getCheckTime())
         {
            return;
         }
         if(param1.family == 96 && param1.subfamily == 14)
         {
            _loc4_.base = new Packet_0060_0E(param1).value;
         }
         else
         {
            Facade.mainMediator.showMessage(Lang.getString("clan_ban_lock"),Lang.getString("clan_ban_title"));
            Facade.userProxy.addClanMember(param2);
            Facade.dispatchCommonEvent(CommonEvent.MY_GAME_STREAM,PRaidEvent.create(PRaidEvent.NEW_CLAN_MEMBER,param2));
         }
      }
      
      private static function reopen(param1:PClan) : void
      {
         if(param1)
         {
            DialogLogic.openClanAbout(param1.base.id);
            DialogLogic.open(new ClanMembersMediator(param1));
         }
      }
      
      public static function checkRegent(param1:PMember, param2:Boolean) : Boolean
      {
         return true;
      }
      
      public static function getCurRating(param1:PUsersClanPoints) : int
      {
         return Boolean(param1) && param1.season_num == TopClansMediator.getCurSeason() ? param1.points : 0;
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog.grid.addListener(VEvent.VARIANCE,this.onShowMemberMenu);
         if(this.clan == up.clanData)
         {
            Facade.addListenerForComponent(CommonEvent.MY_GAME_STREAM,this.onGameStream,this.dialog);
         }
         this.updateMembersData();
         Facade.protoProxy.request(new Packet_0060_3B(PClanCompPlaceRequest.create(TopClansMediator.getCurSeason(),this.clan.base.id)),this.resultSeasonPlace);
         return this.dialog;
      }
      
      public function updateMembersData() : void
      {
         this.setClanMembers();
      }
      
      private function setClanMembers() : void
      {
         var _loc4_:PMember = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:VOClanMember = null;
         var _loc8_:VOClanMember = null;
         var _loc9_:Number = NaN;
         var _loc1_:str_uint = getDialogSetting() as str_uint;
         var _loc2_:Array = [];
         var _loc3_:PClanReward = Facade.manualProxy.getClanReward(this.clan.clan_comp_place_opt);
         for each(_loc4_ in this.clan.members)
         {
            _loc7_ = new VOClanMember(_loc4_);
            _loc7_.clan_place = this.clan.clan_comp_place_opt;
            _loc2_.push(_loc7_);
         }
         _loc5_ = Facade.manualProxy.getRewardPercInfo(1).perc;
         _loc2_.sort(this.onSortMembers);
         _loc6_ = 0;
         while(_loc6_ < _loc2_.length)
         {
            _loc8_ = _loc2_[_loc6_];
            _loc9_ = Facade.manualProxy.getRewardPercInfo(_loc6_ + 1).perc;
            _loc8_.prize = ShopLogic.getMulCosts(_loc3_.prize,_loc9_);
            _loc8_.prize.sort(this.onSortPrize);
            _loc8_.place = _loc6_ + 1;
            _loc8_.prize_pct = _loc9_ / _loc5_;
            _loc6_++;
         }
         this.dialog.grid.setDataProvider(_loc2_,Boolean(_loc1_) && _loc1_.field_0 == this.clan.base.id ? _loc1_.field_1 : 0);
         this.dialog.chestStat.setData(this.clan.clan_comp_place_opt);
      }
      
      private function onSortPrize(param1:PCost, param2:PCost) : int
      {
         if(param1.variance == PCost.MITHRIL && param2.variance != PCost.MITHRIL)
         {
            return -1;
         }
         if(param1.variance != PCost.MITHRIL && param2.variance == PCost.MITHRIL)
         {
            return 1;
         }
         if(param1.variance == PCost.GOLD && param2.variance != PCost.GOLD)
         {
            return -1;
         }
         if(param1.variance != PCost.GOLD && param2.variance == PCost.GOLD)
         {
            return 1;
         }
         if(param1.variance == PCost.CRYSTAL && param2.variance != PCost.CRYSTAL)
         {
            return -1;
         }
         if(param1.variance != PCost.CRYSTAL && param2.variance == PCost.CRYSTAL)
         {
            return 1;
         }
         return 0;
      }
      
      private function resultSeasonPlace(param1:BinaryBuffer) : void
      {
         this.setClanMembers();
      }
      
      private function onSortMembers(param1:VOClanMember, param2:VOClanMember) : int
      {
         var _loc3_:int = ClanMembersMediator.getCurRating(param1.user.user_base.clan_points);
         var _loc4_:int = ClanMembersMediator.getCurRating(param2.user.user_base.clan_points);
         return _loc3_ == _loc4_ ? (param1.user.user_base.ratio < param2.user.user_base.ratio ? 1 : -1) : (_loc3_ < _loc4_ ? 1 : -1);
      }
      
      override public function onRemove() : void
      {
         var _loc1_:str_uint = getDialogSetting() as str_uint;
         if(!_loc1_)
         {
            _loc1_ = new str_uint();
            setDialogSetting(_loc1_);
         }
         _loc1_.field_0 = this.clan.base.id;
         _loc1_.field_1 = this.dialog.grid.index;
      }
      
      private function onShowMemberMenu(param1:VEvent) : void
      {
         var _loc2_:ClanMemberRenderer = param1.data as ClanMemberRenderer;
         showMemberMenu(_loc2_.member,this.dialog.grid.getDataProvider(),Boolean(this.clan) && Boolean(up.clanData) && this.clan.base.id == up.clanData.base.id,this.dialog,_loc2_.menuBt,36,20);
      }
      
      protected function onGameStream(param1:CommonEvent) : void
      {
         var _loc4_:ClanRoleDialog = null;
         var _loc2_:PRaidEvent = param1.data;
         var _loc3_:uint = _loc2_.variance;
         if(_loc3_ == PRaidEvent.DEL_CLAN_MEMBER || _loc3_ == PRaidEvent.NEW_CLAN_MEMBER || _loc3_ == PRaidEvent.SET_CLAN_ROLE)
         {
            if(_loc3_ == PRaidEvent.DEL_CLAN_MEMBER && _loc2_.value == Preloader.uid)
            {
               this.dialog.close();
            }
            else
            {
               this.dialog.grid.sync();
            }
            if(_loc3_ == PRaidEvent.DEL_CLAN_MEMBER || _loc3_ == PRaidEvent.SET_CLAN_ROLE)
            {
               _loc4_ = Facade.mainMediator.searchDialog(ClanRoleDialog);
               if((Boolean(_loc4_)) && _loc4_.member.user_base.user_id == (_loc3_ == PRaidEvent.SET_CLAN_ROLE ? (_loc2_.value as PSetRole).sr_user_id : _loc2_.value))
               {
                  _loc4_.close();
               }
            }
         }
      }
   }
}

