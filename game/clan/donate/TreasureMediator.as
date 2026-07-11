package game.clan.donate
{
   import game.clan.center.ClanMembersMediator;
   import game.clan.social.ClanSocialMediator;
   import game.common.DialogMediator;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import model.CommonEvent;
   import model.ui.VODonateItem;
   import proto.model.PCost;
   import proto.model.PPermission;
   import proto.model.PRaidEvent;
   import proto.model.clan.PCapitalLog;
   import proto.model.clan.PCapitalLogKind;
   import proto.model.clan.PMember;
   import proto.model.clan.PSetRole;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import utils.ClickStatistic;
   
   public class TreasureMediator extends DialogMediator
   {
      
      private const dialog:BaseDialog = new BaseDialog();
      
      private var panel:TreasuryPanel;
      
      public function TreasureMediator()
      {
         super();
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog.useDefaultBg(638,Lang.getString("clan_treasury"));
         this.init();
         Facade.addListenerForComponent(CommonEvent.MY_GAME_STREAM,this.onGameStream,this.dialog);
         ClickStatistic.startTime();
         return this.dialog;
      }
      
      private function init() : void
      {
         this.panel = new TreasuryPanel(up.clanData,up.checkClanRolePermission(PPermission.TREAS_REPORTS),0);
         this.dialog.add(this.panel,{
            "w":778,
            "h":525,
            "hCenter":0,
            "top":83
         });
         this.panel.addListener(VEvent.VARIANCE,this.onVariance);
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = param1.variance;
         ClickStatistic.clan(_loc2_,TreasuryPanel,"TREASURE");
         switch(_loc2_)
         {
            case TreasuryPanel.DONATE:
               DialogLogic.openDonate();
               break;
            case TreasuryPanel.DONATE_REPORT:
               this.showDonateReport(param1.data);
               break;
            case TreasuryPanel.DONATE_ALERT:
               this.donateAlert();
         }
      }
      
      private function showDonateReport(param1:uint, param2:uint = 0) : void
      {
         var _loc8_:PMember = null;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:DonateReportDialog = null;
         var _loc12_:VODonateItem = null;
         var _loc13_:uint = 0;
         var _loc14_:PCapitalLog = null;
         var _loc15_:uint = 0;
         var _loc16_:PCost = null;
         var _loc17_:uint = 0;
         var _loc3_:Array = [];
         var _loc4_:uint = 86400;
         var _loc5_:Number = CoreLogic.serverTime;
         var _loc6_:Date = CoreLogic.getDate(_loc5_);
         var _loc7_:Number = _loc5_ + _loc4_ - (_loc6_.hours * 3600 + _loc6_.minutes * 60 + _loc6_.seconds);
         for each(_loc8_ in up.clanData.members)
         {
            _loc12_ = new VODonateItem();
            _loc12_.member = _loc8_;
            _loc12_.exp = _loc8_.user_base.exp;
            _loc12_.variance = param1;
            switch(param1)
            {
               case PCost.GOLD:
                  _loc15_ = uint(_loc8_.full_donate_gold);
                  break;
               case PCost.CRYSTAL:
                  _loc15_ = uint(_loc8_.full_donate_crystal);
                  break;
               case PCost.OIL:
                  _loc15_ = uint(_loc8_.full_donate_oil);
                  break;
               case PCost.CALL:
                  _loc15_ = uint(_loc8_.full_donate_call);
                  break;
               default:
                  _loc15_ = 0;
            }
            _loc13_ = 0;
            for each(_loc14_ in up.clanData.capital_log)
            {
               if(_loc14_.cl_kind.variance == PCapitalLogKind.DONATE && _loc14_.cl_id == _loc8_.user_base.user_id)
               {
                  for each(_loc16_ in _loc14_.cl_costs)
                  {
                     if(param1 == _loc16_.variance)
                     {
                        _loc13_ += _loc16_.value;
                        if(_loc14_.cl_time >= _loc7_ - 7 * _loc4_)
                        {
                           _loc12_.week += _loc16_.value;
                        }
                        _loc17_ = 3;
                        while(_loc17_ >= 1)
                        {
                           if(_loc14_.cl_time >= _loc7_ - _loc17_ * _loc4_ && _loc14_.cl_time < _loc7_ - (_loc17_ - 1) * _loc4_)
                           {
                              _loc12_["day" + _loc17_] += _loc16_.value;
                           }
                           _loc17_--;
                        }
                     }
                  }
               }
            }
            _loc12_.all = _loc15_ > _loc13_ ? _loc15_ : _loc13_;
            _loc3_.push(_loc12_);
         }
         _loc9_ = "week";
         _loc10_ = true;
         this.reportDpSort(_loc3_,_loc9_,_loc10_);
         _loc11_ = new DonateReportDialog(param1,_loc5_,_loc3_,param2);
         _loc11_.sortField = _loc9_;
         _loc11_.isDescending = _loc10_;
         _loc11_.syncSortArrow();
         _loc11_.memberList = up.clanData.members;
         _loc11_.addListener(VEvent.VARIANCE,this.onReportSortChange);
         Facade.mainMediator.showDialog(_loc11_);
      }
      
      private function reportDpSort(param1:Array, param2:String, param3:Boolean) : void
      {
         var _loc4_:uint = Array.NUMERIC;
         if(param3)
         {
            _loc4_ |= Array.DESCENDING;
         }
         if(param2 == "exp")
         {
            param1.sortOn(param2,_loc4_);
         }
         else
         {
            param1.sortOn([param2,"exp"],[_loc4_,Array.NUMERIC | Array.DESCENDING]);
         }
      }
      
      private function onReportSortChange(param1:VEvent) : void
      {
         var _loc3_:DonateReportRenderer = null;
         var _loc2_:DonateReportDialog = param1.currentTarget as DonateReportDialog;
         if(param1.variance == 0)
         {
            if(_loc2_.sortField != param1.data)
            {
               _loc2_.sortField = param1.data;
            }
            else
            {
               _loc2_.isDescending = !_loc2_.isDescending;
            }
            _loc2_.syncSortArrow();
            this.reportDpSort(_loc2_.grid.getDataProvider(),_loc2_.sortField,_loc2_.isDescending);
            _loc2_.grid.sync(0);
         }
         else
         {
            _loc3_ = param1.data as DonateReportRenderer;
            ClanMembersMediator.showMemberMenu(_loc3_.member,_loc2_.memberList,true,_loc2_,_loc3_.menuBt,45,14);
         }
      }
      
      private function syncDonateReport(param1:Boolean = false) : void
      {
         var _loc3_:VGrid = null;
         var _loc2_:DonateReportDialog = Facade.mainMediator.searchDialog(DonateReportDialog);
         if(_loc2_)
         {
            if(param1)
            {
               _loc3_ = _loc2_.grid;
               if(_loc3_.length > 0)
               {
                  _loc2_.close();
                  this.showDonateReport((_loc3_.getDataProvider()[0] as VODonateItem).variance,_loc3_.index);
               }
            }
            else
            {
               _loc2_.grid.sync();
            }
         }
      }
      
      private function donateAlert() : void
      {
         ClanSocialMediator.addChatMessage("@<sys>@donate_chat");
         Facade.myMediator.closeClanPanel();
         Facade.myMediator.showMyClanNotify();
         Facade.mainMediator.showMessage(Lang.getString("donate_alert"));
      }
      
      private function onGameStream(param1:CommonEvent) : void
      {
         var _loc2_:PRaidEvent = param1.data;
         switch(_loc2_.variance)
         {
            case PRaidEvent.CLAN_DONATE:
               this.panel.grid.sync();
               break;
            case PRaidEvent.DEL_CLAN_MEMBER:
               if(_loc2_.value == Preloader.uid)
               {
                  Facade.mainMediator.searchDialog(DonateReportDialog,true);
                  this.dialog.close();
                  break;
               }
               this.syncDonateReport(true);
               break;
            case PRaidEvent.NEW_CLAN_MEMBER:
               this.syncDonateReport(true);
               break;
            case PRaidEvent.SET_CLAN_ROLE:
               if((_loc2_.value as PSetRole).sr_user_id == Preloader.uid)
               {
                  this.panel.removeFromParent();
                  this.init();
               }
               this.syncDonateReport(false);
         }
      }
   }
}

