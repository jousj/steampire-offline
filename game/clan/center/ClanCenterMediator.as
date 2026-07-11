package game.clan.center
{
   import clans.ClanDialog;
   import game.barrack.BarrackMediator;
   import game.clan.donate.TreasureMediator;
   import game.clan.social.ClanSocialMediator;
   import game.clan.war.StormTerritoryMediator;
   import game.clan.war.WarMediator;
   import game.common.DialogMediator;
   import game.political.TopClanRendererBase;
   import logic.DialogLogic;
   import logic.MainLogic;
   import model.CommonEvent;
   import proto.BinaryBuffer;
   import proto.game.family_0060.Packet_0060_06;
   import proto.game.family_0060.Packet_0060_07;
   import proto.game.family_0060.Packet_0060_0A;
   import proto.game.family_0060.Packet_0060_0B;
   import proto.game.family_0060.Packet_0060_0C;
   import proto.model.PBtype;
   import proto.model.PCost;
   import proto.model.PRaidEvent;
   import proto.model.PRole;
   import proto.model.clan.PClan;
   import proto.model.clan.PMember;
   import proto.model.clan.PRequestAnswer;
   import proto.model.clan.PSetRole;
   import proto.tuples.i_i;
   import ui.Style;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   import utils.ClickStatistic;
   import utils.CommonUtils;
   import utils.CostHelper;
   
   public class ClanCenterMediator extends DialogMediator
   {
      
      public var dialog:ClanCenterDialog;
      
      public var id:String;
      
      public var clanInfo:PClan;
      
      public var isTopsBt:Boolean;
      
      public function ClanCenterMediator(param1:String, param2:Boolean)
      {
         super();
         this.id = param1;
         this.isTopsBt = param2;
         var _loc3_:Boolean = Boolean(param1);
         if(!_loc3_)
         {
            this.clanInfo = up.clanData;
         }
         Facade.mainMediator.searchDialog(ClanCenterDialog,true);
      }
      
      private static function resultJoin(param1:BinaryBuffer) : void
      {
         var _loc2_:PRequestAnswer = new Packet_0060_07(param1).value;
         if(_loc2_.variance == PRequestAnswer.OK)
         {
            Facade.mainMediator.searchDialog(TopClansMediator,true);
            Facade.mainMediator.searchDialog(ClanCenterMediator,true);
            ClanEditMediator.joinClan(_loc2_.value,null,null);
         }
         else
         {
            Facade.mainMediator.showMessage(Lang.getString("clan_join_" + CommonUtils.getConstantName(PRequestAnswer,_loc2_.variance)));
         }
      }
      
      override public function onAdd() : BaseDialog
      {
         ClickStatistic.startTime();
         if(this.id)
         {
            Facade.protoProxy.request(new Packet_0060_0A(this.id),this.resultClanInfo,96,11);
         }
         else
         {
            this.dialog = new ClanCenterDialog(Boolean(this.id),TopClansMediator.getCurSeason());
            this.dialog.addEventListener(VEvent.VARIANCE,this.onVariance);
            this.assignMyClan();
            Facade.addListenerForComponent(CommonEvent.MY_GAME_STREAM,this.onGameStream,this.dialog);
         }
         return this.dialog;
      }
      
      private function resultClanInfo(param1:BinaryBuffer) : void
      {
         this.clanInfo = new Packet_0060_0B(param1).value;
         var _loc2_:ClanInfoDialog = new ClanInfoDialog(this.clanInfo,mp.getClanCapacity(this.clanInfo.clanhall_level),!up.clan,up.level,this.isTopsBt);
         DialogLogic.open(_loc2_);
         _loc2_.addEventListener(VEvent.VARIANCE,this.onVariance);
      }
      
      private function assignMyClan(param1:VEvent = null) : void
      {
         var _loc3_:PClan = null;
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc6_:uint = 0;
         if(up.clan)
         {
            _loc3_ = up.clanData;
            _loc4_ = _loc3_.members;
            _loc5_ = int(_loc4_.length - 1);
            while(_loc5_ > 2)
            {
               if((_loc4_[_loc5_] as PMember).user_base.user_id == Preloader.uid)
               {
                  break;
               }
               _loc5_--;
            }
            _loc4_ = _loc4_.slice(0,3);
            if(_loc5_ > 2)
            {
               _loc4_[2] = _loc3_.members[_loc5_];
            }
            _loc6_ = up.clan.uc_role.variance;
            this.dialog.createClanPanel(_loc3_,_loc4_,mp.getClanCapacity(_loc3_.clanhall_level),mp.getRolePermission(mp.getClanRoleInfo(_loc6_)),_loc6_,_loc3_.war ? WarMediator.getCurWarPoints(_loc3_.war) : null);
         }
         else
         {
            this.dialog.createNoClanPanel();
         }
         if(Facade.fakeResize)
         {
            this.dialog.x += this.dialog.measuredWidth * 0.075;
            this.dialog.y += this.dialog.measuredHeight * 0.075;
         }
         var _loc2_:ClanDialog = Facade.mainMediator.searchDialog(ClanDialog);
         if(_loc2_)
         {
            _loc2_.ratingPanel.cur = ClanMembersMediator.getCurRating(Facade.userProxy.base.clan_points);
         }
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc3_:ClanDialog = null;
         var _loc2_:uint = param1.variance;
         ClickStatistic.clan(_loc2_,ClanCenterDialog,this.id ? "CLAN_INFO" : "CLAN_CENTER");
         switch(_loc2_)
         {
            case ClanCenterFactory.TOP_CLANS:
               _loc3_ = Facade.mainMediator.searchDialog(ClanDialog);
               if(_loc3_)
               {
                  _loc3_.setTab(ClanDialog.TOPS,TopClanRendererBase.topsIndex());
               }
               break;
            case ClanCenterFactory.SEASONS:
               _loc3_ = Facade.mainMediator.searchDialog(ClanDialog);
               if(_loc3_)
               {
                  _loc3_.setTab(ClanDialog.TOPS,TopClanRendererBase.curSeasonIndex());
               }
               break;
            case ClanCenterFactory.DONATE_ALERT:
               ClanSocialMediator.addChatMessage("@<sys>@donate_chat");
               Facade.myMediator.closeClanPanel();
               Facade.myMediator.showMyClanNotify();
               Facade.mainMediator.showMessage(Lang.getString("donate_alert"));
               break;
            case ClanCenterFactory.DONATE:
               DialogLogic.openDonate();
               break;
            case ClanCenterFactory.TREASURY:
               DialogLogic.open(new TreasureMediator());
               break;
            case ClanCenterFactory.TO_CAPITAL:
               Facade.setMapCallback(DialogLogic.openClanAbout,[this.id,true]);
               if(Boolean(this.id || !up.clanData) || Boolean(!up.clanData.war) || isNaN(up.clanData.war.war_storm))
               {
                  MainLogic.getCapitalMap(this.id);
                  break;
               }
               MainLogic.getStorm(false);
               break;
            case ClanCenterFactory.TO_POLITICAL_MAP:
               _loc3_ = Facade.mainMediator.searchDialog(ClanDialog);
               if(_loc3_)
               {
                  _loc3_.setTab(ClanDialog.MAP);
               }
               break;
            case ClanCenterFactory.TO_TERRITORY_STORM:
               DialogLogic.open(new StormTerritoryMediator());
               break;
            case ClanCenterFactory.TO_WAR_LIST:
               _loc3_ = Facade.mainMediator.searchDialog(ClanDialog);
               if(_loc3_)
               {
                  _loc3_.setTab(ClanDialog.WAR);
               }
               break;
            case ClanCenterFactory.CLAN_LEAGUE:
               break;
            case ClanCenterFactory.EDIT_CLAN:
               Facade.mainMediator.showDialog(new ClanEditMediator()).addListener(VEvent.CHANGE,this.assignMyClan);
               break;
            case ClanCenterFactory.MEMBERS:
               DialogLogic.open(new ClanMembersMediator(this.clanInfo));
               break;
            case ClanCenterFactory.LEAVE:
               this.leave();
               break;
            case ClanCenterFactory.JOIN:
               this.onJoin();
               break;
            case ClanCenterFactory.WAR:
               DialogLogic.openWar();
               if(up.clanData.war)
               {
                  this.dialog.close();
               }
               break;
            case ClanCenterFactory.TO_INFO_DIALOG:
               DialogLogic.open(new TextInfoDialog("help_clan_points_title","help_clan_points"));
         }
      }
      
      private function onGameStream(param1:CommonEvent) : void
      {
         var _loc4_:Boolean = false;
         var _loc2_:PRaidEvent = param1.data;
         var _loc3_:uint = _loc2_.variance;
         if(_loc3_ == PRaidEvent.DEL_CLAN_MEMBER || _loc3_ == PRaidEvent.NEW_CLAN_MEMBER)
         {
            _loc4_ = true;
         }
         else if(_loc3_ == PRaidEvent.START_WAR || _loc3_ == PRaidEvent.FINISH_WAR || _loc3_ == PRaidEvent.CREATE_CAPITAL)
         {
            _loc4_ = true;
         }
         else if(_loc3_ == PRaidEvent.SET_CLAN_ROLE && (_loc2_.value as PSetRole).sr_user_id == Preloader.uid)
         {
            _loc4_ = true;
         }
         if(_loc4_)
         {
            this.assignMyClan();
         }
      }
      
      private function leave() : void
      {
         var _loc1_:PMember = null;
         var _loc2_:Boolean = false;
         for each(_loc1_ in up.clanData.members)
         {
            if(_loc1_.user_base.user_id == Preloader.uid)
            {
               if(!ClanMembersMediator.checkRegent(_loc1_,false))
               {
                  return;
               }
               break;
            }
         }
         _loc2_ = mp.getClanRoleInfo(up.clan.uc_role.variance).scr_role_kind.variance == PRole.CREATOR;
         if(Boolean(up.clanData.war) || _loc2_ && up.clanData.active_territories)
         {
            Facade.mainMediator.showMessage(Lang.getString(_loc2_ ? "clan_reset_block" : "clan_leave_block"));
         }
         else
         {
            Facade.mainMediator.showYesNoDialog(Lang.getReplaceString(_loc2_ ? "clan_reset_prompt" : "clan_leave_prompt",{
               "__CLAN__":"<span" + Style.redColor + ">" + up.clanData.base.name + "</span>",
               "__CLAN_POINT__":CostHelper.get18StringC(PCost.create(PCost.CLAN_POINTS,ClanMembersMediator.getCurRating(Facade.userProxy.base.clan_points)),true)
            }),this.confirmLeave);
         }
      }
      
      private function confirmLeave(param1:Boolean = true) : void
      {
         Facade.myMediator.resetClan();
         if(param1)
         {
            Facade.protoProxy.request(new Packet_0060_0C());
         }
         this.assignMyClan();
      }
      
      private function onJoin() : void
      {
         if(up.getBuild(PBtype.CLAN,true))
         {
            BarrackMediator.sellClanArmy();
            Facade.protoProxy.request(new Packet_0060_06(this.clanInfo.base.id),resultJoin,96,7);
         }
         else
         {
            Facade.myMediator.showBuildNeed("clan_center_need","clanBt","ClanEmblemIcon","bl_clan_center");
         }
      }
      
      public function getClanInfo() : PClan
      {
         return this.clanInfo;
      }
   }
}

