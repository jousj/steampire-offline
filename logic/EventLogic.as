package logic
{
   import clans.ClanDialog;
   import clans.ClanMedialor;
   import engine.units.Build;
   import game.clan.center.ClanCenterDialog;
   import game.clan.center.ClanMembersMediator;
   import game.clan.center.SeasonPrizeDialog;
   import game.clan.center.TopClansDialog;
   import game.clan.center.TopClansMediator;
   import game.clan.war.WarStatusDialog;
   import game.offer.CompensationDialog;
   import game.offer.OfferResultDialog;
   import game.political.ClanLeagueUpDialog;
   import game.shop.ShareDialog;
   import model.CommonEvent;
   import proto.BinaryBuffer;
   import proto.game.family_0010.Packet_0010_07;
   import proto.game.family_0010.Packet_0010_08;
   import proto.game.family_0060.Packet_0060_02;
   import proto.game.family_0060.Packet_0060_03;
   import proto.model.*;
   import proto.model.clan.PCapitalLogKind;
   import proto.model.clan.PClan;
   import proto.model.clan.PMember;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.MessageDialog;
   import ui.common.RectButton;
   import ui.game.UnitPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class EventLogic
   {
      
      public function EventLogic()
      {
         super();
      }
      
      public static function run(param1:Object) : void
      {
         var _loc4_:PUserEvent = null;
         var _loc5_:uint = 0;
         var _loc6_:* = undefined;
         var _loc7_:BaseDialog = null;
         var _loc8_:Build = null;
         var _loc9_:PSubscription = null;
         if(!Facade.isMyMap)
         {
            return;
         }
         var _loc2_:Array = param1 is BinaryBuffer ? new Packet_0010_07(param1 as BinaryBuffer).value : param1 as Array;
         if(_loc2_.length == 0)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = _loc4_.variance;
            _loc6_ = _loc4_.value;
            switch(_loc5_)
            {
               case PUserEvent.MITHRIL:
                  showMithrilStatus(_loc6_);
                  break;
               case PUserEvent.EDIT_QUEST:
                  Facade.questMediator.editQuest(_loc6_);
                  break;
               case PUserEvent.START_QUEST:
                  Facade.questMediator.newQuest(_loc6_);
                  break;
               case PUserEvent.START_WAR:
               case PUserEvent.END_WAR:
                  showWarStatus(_loc2_,_loc3_);
                  break;
               case PUserEvent.STORY:
                  Facade.questMediator.newStory(_loc6_);
                  break;
               case PUserEvent.LEVEL:
                  Facade.questMediator.newLevelUp(_loc6_);
                  break;
               case PUserEvent.ALINK:
                  alink(_loc6_);
                  break;
               case PUserEvent.SHARE_CRYSTAL:
               case PUserEvent.SHARE_OIL:
               case PUserEvent.SHARE_GOLD:
                  shareResource(_loc6_,_loc4_.variance);
                  break;
               case PUserEvent.SHARE_SHIELD:
                  shareShield(_loc6_);
                  break;
               case PUserEvent.RESTART_AT:
                  if(CoreLogic.running && Facade.isMyMap && _loc6_ != Facade.userProxy.restartTime)
                  {
                     Facade.userProxy.restartTime = _loc6_;
                     Facade.mainMediator.setRestartTime(_loc6_ - CoreLogic.serverTime <= 600 ? Number(_loc6_) : 0);
                  }
                  break;
               case PUserEvent.STAGE_CHANGED:
                  if(Preloader.userStageList.indexOf(_loc6_) > Preloader.userStageList.indexOf(Facade.userStage))
                  {
                     Facade.userStage = _loc6_;
                  }
                  break;
               case PUserEvent.NEW_OFFER:
                  ActionLogic.addOffer(_loc6_,true);
                  break;
               case PUserEvent.DEL_OFFER:
               case PUserEvent.BUY_OFFER:
                  CoreLogic.getActionEx(ActionLogic.FINISH_OFFER,_loc6_,true);
                  Facade.myMediator.changeOffer(_loc6_);
                  if(_loc5_ == PUserEvent.BUY_OFFER)
                  {
                     Facade.mainMediator.showDialog(new OfferResultDialog(_loc6_ == "so_scout_7days" ? null : Facade.manualProxy.getOfferShop(_loc6_).offer_goods,"share_buy_count"));
                  }
                  break;
               case PUserEvent.CLAN_DIVISION:
                  clanLeagueUp(_loc6_);
                  break;
               case PUserEvent.CREATE_CAPITAL:
                  createCapital(_loc6_);
                  break;
               case PUserEvent.ORE_SPELL_COMPENSATIONS:
                  Facade.mainMediator.showDialog(new CompensationDialog(_loc6_));
                  break;
               case PUserEvent.CLAN_COMP_PRIZE:
                  if(ActionLogic.isWaitSeasonResult)
                  {
                     ActionLogic.resetSeasonFlag();
                  }
                  else
                  {
                     ActionLogic.isGetSeasonResult = true;
                  }
                  Facade.userProxy.updateSeasonInfo();
                  ShopLogic.applyCostList((_loc6_ as PClanCompPrize).prize,false,false);
                  _loc7_ = Facade.mainMediator.searchDialog(TopClansDialog);
                  if(_loc7_)
                  {
                     _loc7_.close();
                  }
                  _loc7_ = Facade.mainMediator.searchDialog(ClanCenterDialog);
                  if(_loc7_)
                  {
                     _loc7_.close();
                  }
                  Facade.mainMediator.showDialog(new SeasonPrizeDialog(_loc6_));
                  if(Facade.userProxy.clanData)
                  {
                     Facade.protoProxy.request(new Packet_0060_03(),resultClanData);
                  }
                  break;
               case PUserEvent.USER_CLAN_POINTS:
                  addClanPoint(_loc6_ as int);
                  break;
               case PUserEvent.CLAN_CENTER_PRIZE:
                  Facade.userProxy.clanHallPrize = PClanCenter.create(0,_loc6_);
                  _loc8_ = Facade.userProxy.getBuild(PBtype.CLAN,true);
                  if(_loc8_)
                  {
                     UnitFactory.buildLogic.syncStatus(_loc8_);
                  }
                  break;
               case PUserEvent.UPDATE_SUBSCRIPTION:
                  _loc9_ = _loc6_ as PSubscription;
                  Facade.userProxy.subs = _loc9_;
                  Facade.log("UPDATE_SUBSCRIPTION");
                  MainLogic.getMyMap();
            }
            _loc3_++;
         }
         if(Facade.questMediator.checkWaitUpdate())
         {
            Facade.questMediator.update();
         }
      }
      
      public static function addClanPoint(param1:int) : void
      {
         var _loc2_:int = ClanMembersMediator.getCurRating(Facade.userProxy.base.clan_points);
         if(!Facade.userProxy.base.clan_points)
         {
            Facade.userProxy.base.clan_points = PUsersClanPoints.create(0,0);
         }
         Facade.userProxy.base.clan_points.points = param1;
         Facade.userProxy.base.clan_points.season_num = TopClansMediator.getCurSeason();
         var _loc3_:PMember = Facade.userProxy.getClanMember(Facade.userProxy.base.user_id);
         if(_loc3_)
         {
            _loc3_.user_base.clan_points = PUsersClanPoints.create(TopClansMediator.getCurSeason(),param1);
         }
         if(Boolean(Facade.userProxy.clanData) && Boolean(Facade.userProxy.clan))
         {
            Facade.userProxy.clanData.base.clan_points += Facade.userProxy.base.clan_points.points - _loc2_;
         }
         if(Facade.userProxy.clanData)
         {
            Facade.protoProxy.request(new Packet_0060_03(),resultClanData);
         }
      }
      
      private static function resultClanData(param1:BinaryBuffer) : void
      {
         Facade.userProxy.assignClanData(new Packet_0060_02(param1).value);
         var _loc2_:PMember = Facade.userProxy.getClanMember(Facade.userProxy.base.user_id);
         if(_loc2_)
         {
            Facade.userProxy.base.clan_points = _loc2_.user_base.clan_points;
         }
      }
      
      public static function sync() : void
      {
         Facade.protoProxy.request(new Packet_0010_08(),run,16,7,null,"getEvents");
      }
      
      private static function shareResource(param1:i_PSign, param2:uint) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(param2 == PUserEvent.SHARE_CRYSTAL)
         {
            _loc3_ = CostHelper.getKind(PCost.CRYSTAL);
            _loc4_ = String(param1.field_0 / 100 * Facade.userProxy.crystalMax);
            _loc5_ = "shareCrystal";
         }
         else if(param2 == PUserEvent.SHARE_OIL)
         {
            _loc3_ = CostHelper.getKind(PCost.OIL);
            _loc4_ = String(param1.field_0 / 100 * Facade.userProxy.oilMax);
            _loc5_ = "shareOil";
         }
         else if(param2 == PUserEvent.SHARE_GOLD)
         {
            _loc3_ = CostHelper.getKind(PCost.GOLD);
            _loc4_ = param1.field_0.toString();
            Facade.userProxy.setGold(param1.field_0,true);
            _loc5_ = "shareGold";
         }
         Facade.mainMediator.showDialog(new ShareDialog(_loc3_,_loc4_,"share_" + _loc3_.toLowerCase(),param1.field_1,_loc5_));
      }
      
      private static function shareShield(param1:time_PSign) : void
      {
         Facade.mainMediator.showDialog(new ShareDialog("ShieldIcon",StringHelper.getTimeDesc(param1.field_0),"share_shield",param1.field_1,"shareShield",false));
      }
      
      private static function alink(param1:PAlinkEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:PCost = null;
         var _loc2_:uint = param1.variance;
         switch(_loc2_)
         {
            case PAlinkEvent.COSTS:
            case PAlinkEvent.UNIT:
            case PAlinkEvent.SHIELD:
               _loc3_ = [];
               if(_loc2_ == PAlinkEvent.COSTS)
               {
                  for each(_loc4_ in param1.value)
                  {
                     _loc3_.push(POfferGoods.create(POfferGoods.COST,_loc4_));
                  }
                  ShopLogic.applyCostList(param1.value);
               }
               else
               {
                  _loc3_.push(POfferGoods.create(_loc2_ == PAlinkEvent.UNIT ? POfferGoods.UNIT : POfferGoods.SHIELD,param1.value));
               }
               Facade.mainMediator.showDialog(new OfferResultDialog(_loc3_,"share_reward_desc"));
               break;
            case PAlinkEvent.MESSAGE:
               Facade.mainMediator.showMessage(Lang.getString(param1.value));
         }
      }
      
      private static function createCapital(param1:PCreateCapitalEvent) : void
      {
         var _loc2_:PClan = Facade.userProxy.clanData;
         if(_loc2_)
         {
            _loc2_.storage_max_crystal = param1.cce_crystal;
            _loc2_.storage_max_oil = param1.cce_oil;
            _loc2_.townhall_level = param1.cce_th_level;
            _loc2_.base.has_capital = true;
            Facade.userProxy.changeClanResource(PCost.create(PCost.GOLD,Facade.references.create_capital_price.value),true,PCapitalLogKind.BUY_CAPITAL);
            Facade.mainMediator.showMessage(Lang.getString("create_capital"),null,UnitPanel.createForMessage("bl_town_hall",4),MessageDialog.UNIT_ICON);
            Facade.dispatchCommonEvent(CommonEvent.MY_GAME_STREAM,PRaidEvent.create(PRaidEvent.CREATE_CAPITAL,param1));
         }
      }
      
      private static function showWarStatus(param1:Array, param2:int) : void
      {
         var _loc3_:Boolean = false;
         var _loc5_:PUserEvent = null;
         var _loc6_:WarStatusDialog = null;
         var _loc4_:* = int(param1.length - 1);
         while(_loc4_ >= param2)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_.variance == PUserEvent.START_WAR || _loc5_.variance == PUserEvent.END_WAR)
            {
               if(!_loc3_)
               {
                  _loc3_ = true;
                  if(Facade.userProxy.clan)
                  {
                     _loc6_ = new WarStatusDialog(_loc5_.value);
                     _loc6_.addListener(VEvent.CLOSE_DIALOG,onWarStatusClose);
                     Facade.mainMediator.showDialog(_loc6_);
                  }
               }
               param1.splice(_loc4_,1);
            }
            _loc4_--;
         }
         Facade.myMediator.syncStormStatus(Facade.userProxy.clanData);
      }
      
      private static function onWarStatusClose(param1:VEvent) : void
      {
         if(param1.data)
         {
            DialogLogic.openWar();
         }
      }
      
      private static function showMithrilStatus(param1:PMithrilEvent) : void
      {
         var _loc5_:int = 0;
         var _loc7_:VSkin = null;
         var _loc8_:VText = null;
         var _loc2_:BaseDialog = new BaseDialog();
         _loc2_.useWhiteBg(574,318,Lang.getString("mithril_bonus"));
         _loc2_.add(SkinManager.getExternal("MithrilStatusBg"),{
            "left":10,
            "bottom":10
         },1);
         var _loc3_:Array = [param1.cnt_by_clan,"mithril_for_clan",195,param1.cnt_by_capital,"mithril_for_capital",154,param1.cnt_by_ter,"mithril_for_territory",114];
         var _loc4_:String = CostHelper.getKind(PCost.MITHRIL);
         _loc5_ = _loc3_.length - 3;
         while(_loc5_ >= 0)
         {
            _loc7_ = SkinManager.getEmbed(_loc4_);
            _loc7_.layoutH = 28;
            _loc8_ = UIFactory.createYellowText(_loc3_[_loc5_] + " " + Lang.getString(_loc3_[_loc5_ + 1]),VText.CONTAIN,20,true);
            _loc2_.add(new VBox(new <VComponent>[_loc7_,_loc8_]),{
               "hCenter":0,
               "top":_loc3_[_loc5_ + 2]
            });
            _loc5_ -= 3;
         }
         var _loc6_:RectButton = new RectButton(Lang.getString("collectQuestBt"),RectButton.h42);
         _loc6_.addClickListener(_loc2_.close);
         _loc2_.add(_loc6_,{
            "hCenter":0,
            "bottom":29,
            "minW":170
         });
         Facade.mainMediator.showDialog(_loc2_);
      }
      
      private static function clanLeagueUp(param1:uint) : void
      {
         var _loc2_:PClanTownhallDivision = null;
         var _loc3_:PClanTownhallDivision = null;
         if(Facade.userProxy.clan)
         {
            _loc2_ = Facade.manualProxy.getDivisionByLevel(param1);
            _loc3_ = Facade.manualProxy.getDivisionByLevel(param1 - 1);
            Facade.mainMediator.showDialog(new ClanLeagueUpDialog(toWarMap,Facade.manualProxy.getClanLeagueByNum(_loc2_.division),Facade.userProxy.clan.uc_icon,_loc2_,_loc2_.division != _loc3_.division));
         }
      }
      
      public static function toWarMap() : void
      {
         var _loc2_:ClanMedialor = null;
         var _loc1_:ClanDialog = Facade.mainMediator.searchDialog(ClanDialog);
         if(!_loc1_)
         {
            _loc2_ = new ClanMedialor();
            DialogLogic.open(_loc2_);
            _loc1_ = _loc2_.dialog;
         }
         _loc1_.setTab(ClanDialog.MAP);
      }
   }
}

