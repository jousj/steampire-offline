package game.clan.center
{
   import game.common.DialogMediator;
   import game.political.TopClanRenderer;
   import game.political.TopClanRendererBase;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import logic.MainLogic;
   import proto.BinaryBuffer;
   import proto.game.family_0060.Packet_0060_1D;
   import proto.game.family_0060.Packet_0060_1E;
   import proto.game.family_0060.Packet_0060_39;
   import proto.game.family_0060.Packet_0060_3A;
   import proto.game.family_0060.Packet_0060_3F;
   import proto.game.family_0060.Packet_0060_40;
   import proto.model.PClanCompPlaceAnswer;
   import proto.model.PClanCompTopAnswer;
   import proto.model.PClanCompTopRequest;
   import proto.model.PClanTopRecord;
   import proto.model.PHallOfFame;
   import proto.model.clan.PClan;
   import proto.model.clan.PClanTop;
   import proto.model.clan.PTopRequest;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   import utils.ClickStatistic;
   import utils.CommonUtils;
   import utils.StringHelper;
   
   public class TopClansMediator extends DialogMediator
   {
      
      public var dialog:TopClansDialog;
      
      private var topRequest:PTopRequest;
      
      private var topSeasonRequest:PClanCompTopRequest;
      
      private var isTopLoad:Boolean;
      
      private var initIndex:int = 0;
      
      public function TopClansMediator(param1:int)
      {
         super();
         this.initIndex = param1;
      }
      
      public static function getCurSeason() : int
      {
         return (CoreLogic.serverTime - Facade.references.clan_competition_start_time) / Facade.references.clan_competition_duration + (ActionLogic.isWaitSeasonResult ? 0 : 1);
      }
      
      override public function onAdd() : BaseDialog
      {
         var _loc2_:int = 0;
         var _loc1_:int = getCurSeason();
         Facade.mainMediator.searchDialog(TopClansDialog,true);
         ClickStatistic.startTime();
         this.topRequest = getDialogSetting() as PTopRequest;
         if(!this.topRequest)
         {
            this.topRequest = PTopRequest.create("",0,TopClansDialog.searchLineCount - 1 + 1,!up.clan,false,NaN);
            setDialogSetting(this.topRequest);
         }
         this.dialog = new TopClansDialog(_loc1_,_loc1_ * Facade.references.clan_competition_duration + Facade.references.clan_competition_start_time,this.topRequest);
         this.dialog.addEventListener(VEvent.VARIANCE,this.onVariance);
         this.dialog.searchPanel.joinCb.addListener(VEvent.CHANGE,this.onJoinChange);
         this.dialog.setTab(this.initIndex);
         switch(this.initIndex)
         {
            case TopClanRendererBase.curSeasonIndex():
               _loc2_ = int(TopClanRendererBase.CUR_SEASON);
               break;
            case TopClanRendererBase.lastSeasonIndex():
               _loc2_ = int(TopClanRendererBase.LAST_SEASON);
               break;
            case TopClanRendererBase.topsIndex():
               _loc2_ = int(TopClanRendererBase.TOP);
               break;
            case TopClanRendererBase.hallOfFameIndex():
               _loc2_ = int(TopClanRendererBase.HALL_OF_FAME);
         }
         this.onVariance(new VEvent(VEvent.VARIANCE,0,_loc2_));
         this.dialog.setTab(this.initIndex);
         return null;
      }
      
      private function onJoinChange(param1:VEvent) : void
      {
         this.getTopDp(-1);
      }
      
      private function getTopSeasonDp(param1:int, param2:int = 0) : void
      {
         if(this.isTopLoad)
         {
            this.dialog.seasonPanel.loadMode = true;
            return;
         }
         this.topSeasonRequest = PClanCompTopRequest.create(param1,param2 + 1,TopClansDialog.seasonLineCount - 1 + 1);
         this.dialog.seasonPanel.loadMode = this.isTopLoad = true;
         this.topSeasonRequest.season_num = param1;
         Facade.protoProxy.request(new Packet_0060_39(this.topSeasonRequest),this.resultSeasonTopDp);
      }
      
      private function resultSeasonTopDp(param1:BinaryBuffer) : void
      {
         var _loc2_:PClanCompTopAnswer = null;
         var _loc3_:Boolean = false;
         var _loc4_:PClan = null;
         var _loc5_:* = 0;
         var _loc6_:PClanCompPlaceAnswer = null;
         var _loc7_:PClanTopRecord = null;
         this.isTopLoad = false;
         if(this.dialog.parent)
         {
            _loc2_ = new Packet_0060_3A(param1).value;
            _loc3_ = true;
            _loc4_ = up.clanData;
            if(_loc4_)
            {
               _loc5_ = int(_loc2_.clans.length - 1);
               if(_loc5_ >= TopClansDialog.seasonLineCount)
               {
                  _loc5_ = TopClansDialog.seasonLineCount;
               }
               while(_loc5_ >= 0)
               {
                  if((_loc2_.clans[_loc5_] as PClanTopRecord).id == _loc4_.base.id)
                  {
                     _loc3_ = false;
                     break;
                  }
                  _loc5_--;
               }
            }
            else
            {
               _loc3_ = false;
            }
            if(isNaN(this.topSeasonRequest.from_place))
            {
               this.topRequest.from_place = _loc2_.clans.length > 0 ? (_loc2_.clans[0] as PClanTopRecord).place : 0;
            }
            CommonUtils.sort(_loc2_.clans,["place"],[Array.NUMERIC]);
            if(Facade.userProxy.clan)
            {
               _loc6_ = _loc2_.season_num == getCurSeason() ? Facade.userProxy.curSeason : Facade.userProxy.lastSeason;
               _loc7_ = PClanTopRecord.create(_loc6_.place,_loc6_.clan_id,_loc4_.base.name,_loc6_ ? _loc6_.clan_points : 0,_loc4_.members.length,_loc4_.base.icon);
               this.dialog.seasonPanel.myPlace = _loc6_.place;
            }
            else
            {
               this.dialog.seasonPanel.myPlace = 0;
            }
            this.dialog.seasonPanel.change(this.topSeasonRequest.from_place,_loc2_.clans,_loc3_,_loc7_,_loc2_.records_count);
         }
      }
      
      private function getTopDp(param1:int) : void
      {
         var _loc2_:String = null;
         if(this.isTopLoad)
         {
            this.dialog.searchPanel.loadMode = true;
            return;
         }
         if(param1 < 0)
         {
            _loc2_ = StringHelper.trim(this.dialog.searchPanel.inputText.value);
            if(_loc2_ != null)
            {
               _loc2_ = _loc2_.replace(/ {2,}/g," ").toLowerCase();
            }
            else
            {
               _loc2_ = "";
            }
            if(this.dialog.searchPanel.joinCb.checked == this.topRequest.can_invite && _loc2_ == this.topRequest.name)
            {
               return;
            }
            if(_loc2_ != this.topRequest.name)
            {
               this.topRequest.name = _loc2_;
               this.dialog.searchPanel.setInfo(_loc2_);
            }
            this.topRequest.can_invite = this.dialog.searchPanel.joinCb.checked;
            this.topRequest.from_place = 0;
         }
         else
         {
            this.topRequest.from_place = param1;
         }
         this.dialog.searchPanel.loadMode = this.isTopLoad = true;
         Facade.protoProxy.request(new Packet_0060_1D(this.topRequest),this.resultTopDp,96,30);
      }
      
      private function resultTopDp(param1:BinaryBuffer) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:PClan = null;
         var _loc5_:* = 0;
         this.isTopLoad = false;
         if(this.dialog.parent)
         {
            _loc2_ = new Packet_0060_1E(param1).value;
            _loc3_ = true;
            _loc4_ = up.clanData;
            if(_loc4_)
            {
               _loc5_ = int(_loc2_.length - 1);
               if(_loc5_ >= TopClansDialog.searchLineCount)
               {
                  _loc5_ = int(TopClansDialog.searchLineCount - 1);
               }
               while(_loc5_ >= 0)
               {
                  if((_loc2_[_loc5_] as PClanTop).id == _loc4_.base.id)
                  {
                     _loc4_.top_place = (_loc2_[_loc5_] as PClanTop).place;
                     _loc3_ = false;
                     break;
                  }
                  _loc5_--;
               }
               this.dialog.searchPanel.myPlace = _loc4_.top_place;
            }
            else
            {
               _loc3_ = false;
            }
            if(this.topRequest.can_invite || this.topRequest.name != "")
            {
               _loc3_ = false;
            }
            if(isNaN(this.topRequest.from_place))
            {
               this.topRequest.from_place = _loc2_.length > 0 ? (_loc2_[0] as PClanTop).place : 0;
            }
            this.dialog.searchPanel.change(this.topRequest.from_place,_loc2_,_loc3_,_loc4_ ? _loc4_.base : null,_loc2_.length > 0 ? (_loc2_[0] as PClanTop).full_cnt : 0);
         }
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = param1.variance;
         ClickStatistic.clan(_loc2_,TopClanRenderer,"CLAN_TOPS");
         switch(_loc2_)
         {
            case TopClanRendererBase.PAGER:
               switch(this.dialog.tabPanel.index)
               {
                  case TopClanRendererBase.topsIndex():
                     this.getTopDp(param1.data);
                     break;
                  case TopClanRendererBase.curSeasonIndex():
                     this.getTopSeasonDp(getCurSeason(),param1.data);
                     break;
                  case TopClanRendererBase.lastSeasonIndex():
                     this.getTopSeasonDp(getCurSeason() - 1,param1.data);
               }
               break;
            case TopClanRendererBase.SEARCH:
               this.getTopDp(param1.data);
               break;
            case TopClanRendererBase.TOP:
               this.getTopDp(param1.data);
               break;
            case TopClanRendererBase.LAST_SEASON:
               this.getTopSeasonDp(getCurSeason() - 1);
               break;
            case TopClanRendererBase.CUR_SEASON:
               this.getTopSeasonDp(getCurSeason());
               break;
            case TopClanRendererBase.INFO:
               DialogLogic.openClanAbout(param1.data);
               break;
            case TopClanRendererBase.CAPITAL:
               Facade.setMapCallback(DialogLogic.openTopClans);
               if(param1.data != null || !up.clanData.war || isNaN(up.clanData.war.war_storm))
               {
                  MainLogic.getCapitalMap(param1.data);
                  break;
               }
               MainLogic.getStorm(false);
               break;
            case TopClanRendererBase.HALL_OF_FAME:
               Facade.protoProxy.request(new Packet_0060_3F(),this.resultHallOfFame);
         }
      }
      
      private function resultHallOfFame(param1:BinaryBuffer) : void
      {
         var _loc2_:PHallOfFame = new Packet_0060_40(param1).value;
         this.dialog.fameHallPanel.setData(_loc2_);
      }
   }
}

