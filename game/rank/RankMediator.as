package game.rank
{
   import game.common.DialogMediator;
   import logic.ActionLogic;
   import logic.DialogLogic;
   import logic.EventLogic;
   import logic.MainLogic;
   import logic.ShopLogic;
   import logic.SocialLogic;
   import model.QuestProxy;
   import model.ui.VOAchievementItem;
   import model.ui.VOTabHistory;
   import model.vo.VOQuest;
   import proto.BinaryBuffer;
   import proto.game.family_0010.PUserAction;
   import proto.game.family_0050.Packet_0050_09;
   import proto.game.family_0050.Packet_0050_0A;
   import proto.game.family_0060.Packet_0060_03;
   import proto.model.PAchievement;
   import proto.model.PAction;
   import proto.model.PQuestInfo;
   import proto.model.PShopDivision;
   import proto.model.PTopRes;
   import proto.model.PUserTop;
   import proto.model.PUserTopRequest;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.TabDialog;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   
   public class RankMediator extends DialogMediator
   {
      
      public static const ACHIEVEMENT:int = 0;
      
      public static const TOPS:int = 1;
      
      public static const MY_LEAGUE:int = 2;
      
      private const dialog:TabDialog = new TabDialog(Lang.getString("rank_title"));
      
      private var achievementDp:Array;
      
      private var tabHistory:VOTabHistory;
      
      private var topsRequest:PUserTopRequest;
      
      private var isTopsLoad:Boolean;
      
      private var myRequest:PUserTopRequest;
      
      private var isMyLoad:Boolean;
      
      private var leagueRequest:PUserTopRequest;
      
      private var leaguePanel:LeaguePanel;
      
      private var curLeague:PShopDivision;
      
      public function RankMediator(param1:int, param2:*)
      {
         super();
         this.tabHistory = getDialogSetting() as VOTabHistory;
         if(!this.tabHistory)
         {
            this.tabHistory = new VOTabHistory(ACHIEVEMENT,[0,0,0]);
            setDialogSetting(this.tabHistory);
         }
         if(param1 < 0 || param1 >= this.tabHistory.pageCount)
         {
            param1 = int(this.tabHistory.index);
            param2 = null;
         }
         if(param2 !== null)
         {
            this.tabHistory.pages[param1] = param2;
         }
         this.dialog.pageLayout = {
            "hCenter":0,
            "top":128,
            "bottom":28
         };
         this.dialog.init(new <String>[Lang.getString("achievements"),Lang.getString("top_players"),Lang.getString("my_league")],param1);
      }
      
      override public function onAdd() : BaseDialog
      {
         this.curLeague = mp.getLeagueShop(up.level);
         this.dialog.tabPanel.addListener(VEvent.CHANGE,this.onTabChange);
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         this.onTabChange(null);
         return this.dialog;
      }
      
      override public function onRemove() : void
      {
         this.savePageIndexes();
      }
      
      private function savePageIndexes() : void
      {
         this.tabHistory.index = this.dialog.tabPanel.index;
         if(this.dialog.page is AchievementPanel)
         {
            this.tabHistory.pages[ACHIEVEMENT] = (this.dialog.page as AchievementPanel).grid.index;
         }
      }
      
      private function onTabChange(param1:VEvent) : void
      {
         if(param1)
         {
            this.savePageIndexes();
         }
         var _loc2_:int = int(this.dialog.tabPanel.index);
         if(_loc2_ == ACHIEVEMENT)
         {
            this.showAchievements();
         }
         else if(_loc2_ == TOPS)
         {
            this.showTops();
         }
         else if(_loc2_ == MY_LEAGUE)
         {
            this.showMyLeague();
         }
         else
         {
            this.dialog.clearPage();
         }
      }
      
      private function showAchievements() : void
      {
         var _loc3_:PQuestInfo = null;
         var _loc4_:* = 0;
         if(!this.achievementDp)
         {
            this.createAchievementDp();
         }
         var _loc1_:AchievementPanel = new AchievementPanel();
         this.dialog.setPage(_loc1_);
         this.syncAchievements();
         var _loc2_:* = this.tabHistory.pages[ACHIEVEMENT];
         if(_loc2_ is String)
         {
            _loc3_ = Facade.questProxy.questDict[_loc2_] as PQuestInfo;
            _loc2_ = 0;
            if(Boolean(_loc3_) && Boolean(_loc3_.qi_achievement))
            {
               _loc4_ = int(this.achievementDp.length - 1);
               while(_loc4_ >= 0)
               {
                  if((this.achievementDp[_loc4_] as VOAchievementItem).kind == _loc3_.qi_achievement.achv_kind)
                  {
                     _loc2_ = _loc4_;
                     break;
                  }
                  _loc4_--;
               }
            }
            this.tabHistory.pages[ACHIEVEMENT] = _loc2_;
         }
         _loc1_.grid.setDataProvider(this.achievementDp,_loc2_);
      }
      
      private function createAchievementDp() : void
      {
         var _loc4_:String = null;
         var _loc5_:PQuestInfo = null;
         var _loc6_:PAchievement = null;
         var _loc7_:VOAchievementItem = null;
         var _loc8_:int = 0;
         var _loc9_:VOQuest = null;
         var _loc1_:Object = {};
         var _loc2_:QuestProxy = Facade.questProxy;
         var _loc3_:Object = mp.achievementHash;
         for(_loc4_ in _loc2_.questDict)
         {
            _loc5_ = _loc2_.questDict[_loc4_];
            if(!_loc5_.qi_disabled)
            {
               _loc6_ = _loc5_.qi_achievement;
               if(_loc6_)
               {
                  _loc7_ = _loc1_[_loc6_.achv_kind];
                  if(!_loc7_)
                  {
                     _loc7_ = new VOAchievementItem();
                     _loc7_.kind = _loc6_.achv_kind;
                     _loc1_[_loc6_.achv_kind] = _loc7_;
                  }
                  _loc8_ = _loc6_.achv_level - 1;
                  _loc7_.targetList[_loc8_] = _loc5_.qi_targets[0];
                  _loc7_.pointList[_loc8_] = _loc3_[_loc6_.achv_kind + _loc6_.achv_level];
                  _loc9_ = _loc2_.getQuest(_loc4_);
                  if(_loc9_)
                  {
                     if(!_loc7_.quest || _loc9_.count < _loc7_.quest.count)
                     {
                        _loc7_.quest = _loc9_;
                        _loc7_.index = _loc8_;
                        if(_loc8_ == 0 && _loc9_.count == 0)
                        {
                           _loc8_ = int(_loc9_.target.qti_action.variance);
                           if(_loc8_ == PAction.AC_HAVE_FRIEND)
                           {
                              SocialLogic.run();
                           }
                           else if(_loc8_ == PAction.AC_CLAN_LVL && Boolean(up.clan))
                           {
                              EventLogic.sync();
                           }
                        }
                     }
                  }
                  _loc7_.max_index = Math.max(_loc7_.max_index,_loc8_ + 1);
               }
            }
         }
         for each(_loc7_ in _loc1_)
         {
            _loc8_ = 0;
            while(_loc8_ <= 2)
            {
               if(_loc7_.index == -1)
               {
                  _loc7_.index = _loc7_.max_index;
               }
               _loc8_++;
            }
         }
         this.achievementDp = [];
         for each(_loc7_ in _loc1_)
         {
            _loc7_.lang = Lang.getString(_loc7_.kind);
            this.achievementDp.push(_loc7_);
         }
      }
      
      private function achievementSort(param1:VOAchievementItem, param2:VOAchievementItem) : Number
      {
         var _loc3_:Boolean = Boolean(param1.quest) && param1.quest.isComplete;
         var _loc4_:Boolean = Boolean(param2.quest) && param2.quest.isComplete;
         if(_loc3_ == _loc4_)
         {
            _loc3_ = param1.index > 2;
            _loc4_ = param2.index > 2;
            if(_loc3_ == _loc4_)
            {
               _loc3_ = Boolean(param1.quest) && param1.quest.count > 0;
               _loc4_ = Boolean(param2.quest) && param2.quest.count > 0;
               if(_loc3_ == _loc4_)
               {
                  if(param1.kind == "ach_richly_live")
                  {
                     return 1;
                  }
                  if(param2.kind == "ach_richly_live")
                  {
                     return -1;
                  }
                  return param1.lang.localeCompare(param2.lang);
               }
               return _loc3_ ? -1 : 1;
            }
            return _loc3_ ? 1 : -1;
         }
         return _loc3_ ? -1 : 1;
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:int = int(param1.variance);
         if(_loc2_ == 0)
         {
            this.achievementReward(param1.data);
         }
         else if(_loc2_ == 1)
         {
            if(this.topsRequest)
            {
               Facade.setMapCallback(DialogLogic.openRank,[TOPS,this.topsRequest.utr_from_place]);
            }
            MainLogic.getFriendMap((param1.data as PUserTop).ut_id);
         }
         else if(_loc2_ == 2)
         {
            if(param1.currentTarget == this.dialog)
            {
               this.getTopsDp(param1.data);
            }
            else
            {
               this.requestTopsDp(param1.data,this.leagueRequest,this.resultLeagueDp);
            }
         }
         else if(_loc2_ == 3)
         {
            if(param1.currentTarget == this.dialog)
            {
               this.getTopsDp(NaN);
            }
         }
         else if(_loc2_ == 4)
         {
            if(param1.currentTarget != this.dialog)
            {
               (param1.currentTarget as BaseDialog).close();
            }
            this.showAllLeagues(param1.data);
         }
         else if(_loc2_ == 5)
         {
            (param1.currentTarget as BaseDialog).close();
            this.showLeague(param1.data);
         }
      }
      
      private function achievementReward(param1:VOAchievementItem) : void
      {
         var _loc3_:int = 0;
         var _loc2_:VOQuest = param1.quest;
         if(Boolean(_loc2_) && _loc2_.isComplete)
         {
            param1.quest = null;
            ++param1.index;
            _loc3_ = Facade.questProxy.questList.indexOf(_loc2_);
            if(_loc3_ < 0)
            {
               throw new Error("bad achievementReward quest " + _loc2_.kind);
            }
            Facade.questProxy.questList.splice(_loc3_,1);
            ShopLogic.applyCostList(_loc2_.meta.qi_prize);
            Facade.audioProxy.play("quest_complete");
            this.syncAchievements(null,param1.index > 2);
            Facade.questMediator.syncRankButton();
            ActionLogic.request(PUserAction.USER_COMPLITE_QUEST,_loc2_.kind);
            if(param1.index <= 2)
            {
               _loc3_ = int(_loc2_.target.qti_action.variance);
               if(_loc3_ == PAction.AC_HAVE_FRIEND)
               {
                  if(!SocialLogic.isLoad && !SocialLogic.isOnlineLoad)
                  {
                     SocialLogic.friendList = null;
                     SocialLogic.run();
                  }
               }
               else if(_loc3_ == PAction.AC_CLAN_LVL)
               {
                  Facade.protoProxy.request(new Packet_0060_03());
                  EventLogic.sync();
               }
            }
         }
      }
      
      public function syncAchievements(param1:Vector.<VOQuest> = null, param2:Boolean = true) : void
      {
         var _loc3_:VOQuest = null;
         var _loc4_:PAchievement = null;
         var _loc5_:VOAchievementItem = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(!this.achievementDp)
         {
            return;
         }
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_.meta.qi_achievement;
            for each(_loc5_ in this.achievementDp)
            {
               if(_loc5_.kind == _loc4_.achv_kind)
               {
                  _loc5_.quest = _loc3_;
                  _loc5_.index = _loc4_.achv_level - 1;
                  break;
               }
            }
         }
         if(param2)
         {
            this.achievementDp.sort(this.achievementSort);
         }
         if(this.dialog.page is AchievementPanel)
         {
            _loc6_ = 0;
            _loc7_ = 0;
            for each(_loc5_ in this.achievementDp)
            {
               _loc8_ = 0;
               while(_loc8_ < 6)
               {
                  _loc7_ += _loc5_.pointList[_loc8_];
                  if(_loc8_ < _loc5_.index)
                  {
                     _loc6_ += _loc5_.pointList[_loc8_];
                  }
                  _loc8_++;
               }
            }
            (this.dialog.page as AchievementPanel).sync(_loc6_,_loc7_);
         }
      }
      
      private function showTops() : void
      {
         if(!this.topsRequest)
         {
            this.topsRequest = PUserTopRequest.create(this.tabHistory.pages[TOPS],7,NaN);
         }
         this.dialog.setPage(new TopUserPanel(7,3,0,0));
         this.getTopsDp(this.topsRequest.utr_from_place);
      }
      
      private function getTopsDp(param1:Number) : void
      {
         (this.dialog.page as TopUserPanel).loadMode = true;
         if(this.dialog.page is LeaguePanel)
         {
            if(!this.isMyLoad)
            {
               this.isMyLoad = true;
               (this.dialog.page as TopUserPanel).league = this.myRequest.utr_division;
               this.tabHistory.pages[MY_LEAGUE] = param1;
               this.requestTopsDp(param1,this.myRequest);
            }
         }
         else if(!this.isTopsLoad)
         {
            this.isTopsLoad = true;
            this.tabHistory.pages[TOPS] = param1;
            this.requestTopsDp(param1,this.topsRequest);
         }
      }
      
      private function requestTopsDp(param1:Number, param2:PUserTopRequest, param3:Function = null) : void
      {
         param2.utr_from_place = param1;
         Facade.protoProxy.request(new Packet_0050_09(param2),param3 != null ? param3 : this.resultTopsDp,80,10);
      }
      
      private function resultTopsDp(param1:BinaryBuffer) : void
      {
         var _loc2_:TopUserPanel = this.dialog.page as TopUserPanel;
         if(!_loc2_ || !this.dialog.parent)
         {
            return;
         }
         var _loc3_:PTopRes = new Packet_0050_0A(param1).value;
         if(isNaN(_loc3_.dnum))
         {
            this.isTopsLoad = false;
            if(isNaN(_loc2_.league))
            {
               this.applyTopsDp(_loc3_,this.topsRequest,_loc2_);
            }
         }
         else
         {
            this.isMyLoad = false;
            if(_loc3_.dnum == _loc2_.league)
            {
               this.applyTopsDp(_loc3_,this.myRequest,_loc2_);
            }
         }
      }
      
      private function applyTopsDp(param1:PTopRes, param2:PUserTopRequest, param3:TopUserPanel) : void
      {
         var _loc5_:Number = NaN;
         var _loc4_:Boolean = true;
         if(!isNaN(param2.utr_division) && this.curLeague.division_num != param2.utr_division)
         {
            param1.me = null;
            _loc4_ = false;
         }
         if(isNaN(param2.utr_from_place))
         {
            param2.utr_from_place = param1.users.length > 0 ? (param1.users[0] as PUserTop).ut_place - 1 : 0;
         }
         else if(param1.me)
         {
            _loc5_ = param1.me.ut_place - 1;
            if(_loc5_ >= param2.utr_from_place && _loc5_ < param2.utr_from_place + param2.utr_count)
            {
               param1.me = null;
            }
         }
         param3.change(param2.utr_from_place,param1.users,param1.full_count,param1.me,_loc4_);
      }
      
      private function showMyLeague() : void
      {
         if(!this.myRequest)
         {
            this.myRequest = PUserTopRequest.create(this.tabHistory.pages[MY_LEAGUE],6,this.curLeague.division_num);
         }
         this.dialog.setPage(new LeaguePanel(this.curLeague,this.curLeague));
         this.getTopsDp(this.myRequest.utr_from_place);
      }
      
      private function showAllLeagues(param1:PShopDivision) : void
      {
         var _loc4_:PShopDivision = null;
         var _loc5_:VGrid = null;
         var _loc2_:BaseDialog = new BaseDialog();
         _loc2_.useSimpleBg(800,0,Lang.getString("leagues_info"));
         var _loc3_:Array = [];
         for each(_loc4_ in mp.leagueList)
         {
            _loc3_.push(_loc4_);
         }
         _loc3_.reverse();
         _loc5_ = new VGrid(1,3,LeagueRenderer,_loc3_,0,6,VGrid.FLOAT_INDEX | VGrid.USE_END_LIMIT,_loc3_.length - (param1.division_num + 2));
         _loc5_.dispatcher = _loc2_;
         _loc2_.addListener(VEvent.VARIANCE,this.onVariance);
         _loc2_.add(_loc5_,{
            "hCenter":0,
            "top":82,
            "bottom":34
         });
         UIFactory.useGridControlV33(_loc5_);
         Facade.mainMediator.showDialog(_loc2_);
      }
      
      private function showLeague(param1:PShopDivision) : void
      {
         if(param1.division_num == this.curLeague.division_num)
         {
            return;
         }
         var _loc2_:BaseDialog = new BaseDialog();
         _loc2_.useSimpleBg(814,592,Lang.getString("league_about"));
         _loc2_.addListener(VEvent.CLOSE_DIALOG,this.onLeagueClose);
         _loc2_.addListener(VEvent.VARIANCE,this.onVariance);
         this.leaguePanel = new LeaguePanel(param1,this.curLeague);
         this.leaguePanel.changeBgTop(-20);
         this.leaguePanel.dispatcher = _loc2_;
         _loc2_.add(this.leaguePanel,{
            "top":79,
            "bottom":30,
            "hCenter":0
         },1);
         Facade.mainMediator.showDialog(_loc2_);
         if(!this.leagueRequest)
         {
            this.leagueRequest = PUserTopRequest.create(0,6,param1.division_num);
         }
         else
         {
            this.leagueRequest.utr_division = param1.division_num;
         }
         this.leaguePanel.loadMode = true;
         this.leaguePanel.league = param1.division_num;
         this.requestTopsDp(0,this.leagueRequest,this.resultLeagueDp);
      }
      
      private function onLeagueClose(param1:VEvent) : void
      {
         this.leaguePanel = null;
      }
      
      private function resultLeagueDp(param1:BinaryBuffer) : void
      {
         var _loc2_:PTopRes = null;
         if(this.leaguePanel)
         {
            _loc2_ = new Packet_0050_0A(param1).value;
            if(_loc2_.dnum == this.leaguePanel.league)
            {
               this.applyTopsDp(_loc2_,this.leagueRequest,this.leaguePanel);
            }
            else
            {
               this.leaguePanel.change(0,[],0,null,false);
            }
         }
      }
   }
}

