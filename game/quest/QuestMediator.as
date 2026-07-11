package game.quest
{
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import game.rank.LeagueUpDialog;
   import game.rank.RankMediator;
   import logic.ActionLogic;
   import logic.DialogLogic;
   import logic.QuestLogic;
   import logic.ShopLogic;
   import logic.quests.QuestHash;
   import logic.quests.QuestTrain;
   import logic.training.AbstractTrain;
   import model.QuestProxy;
   import model.vo.VOQuest;
   import proto.game.family_0010.PExecuteQuestTarget;
   import proto.game.family_0010.PUserAction;
   import proto.game.family_0010.Packet_0010_23;
   import proto.model.PCost;
   import proto.model.PLevelInfo;
   import proto.model.PNewLevelInfo;
   import proto.model.PQuest;
   import proto.model.PQuestTarget;
   import proto.model.PQuestTargetInfo;
   import proto.model.PShopDivision;
   import proto.model.PUser;
   import proto.tuples.str_str;
   import ui.common.MessageDialog;
   import ui.game.PriceButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VEvent;
   
   public class QuestMediator
   {
      
      private const editList:Vector.<PQuest> = new Vector.<PQuest>();
      
      private var levelList:Vector.<PNewLevelInfo>;
      
      private var newList:Vector.<PQuest>;
      
      private var storyList:Vector.<str_str>;
      
      private var storyDialogList:Vector.<String>;
      
      private var isDialog:Boolean;
      
      private var isWaitUpdate:Boolean;
      
      private var leagueList:Array;
      
      public var questBtPanel:QuestBtPanel;
      
      public function QuestMediator(param1:QuestBtPanel)
      {
         super();
         this.questBtPanel = param1;
         param1.addEventListener(VEvent.VARIANCE,this.onVariance);
         param1.rankBt.addClickListener(this.onRank);
      }
      
      public function clear() : void
      {
         this.isDialog = false;
         this.storyList = null;
         this.newList = null;
         this.editList.length = 0;
         this.levelList = null;
         QuestLogic.clear();
         this.questBtPanel.clear();
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = param1.variance;
         var _loc3_:VOQuest = param1.data as VOQuest;
         if(_loc2_ == QuestDialog.SPEEDUP_BT)
         {
            this.showSpeedupDialog(_loc3_);
         }
         else
         {
            this.closeQuestDialog();
            if(_loc2_ == QuestDialog.SHOW_ALL_QUEST)
            {
               this.showAllQuest(_loc3_);
            }
            else if(_loc2_ == QuestDialog.SHOW_ONE_QUEST)
            {
               this.showOneQuest(_loc3_);
            }
            else if(_loc2_ == QuestDialog.HELP_BT)
            {
               QuestLogic.onHelp(_loc3_);
            }
            else if(_loc2_ == QuestDialog.REWARD_BT)
            {
               this.reward(_loc3_);
            }
         }
      }
      
      private function showOneQuest(param1:VOQuest) : void
      {
         var _loc2_:QuestOneDialog = new QuestOneDialog(param1,this.questBtPanel.dpMax > 1);
         _loc2_.addListener(VEvent.VARIANCE,this.onVariance);
         Facade.mainMediator.showDialog(_loc2_);
      }
      
      private function showAllQuest(param1:VOQuest) : void
      {
         var _loc4_:VOQuest = null;
         var _loc5_:QuestDialog = null;
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         for each(_loc4_ in Facade.questProxy.questList)
         {
            if(!_loc4_.isHidden)
            {
               if(_loc4_ == param1)
               {
                  _loc3_ = _loc2_.length;
               }
               _loc2_.push(_loc4_);
            }
         }
         if(_loc2_.length > 0)
         {
            _loc5_ = new QuestDialog();
            _loc5_.grid.setDataProvider(_loc2_,_loc3_);
            _loc5_.addListener(VEvent.VARIANCE,this.onVariance);
            Facade.mainMediator.showDialog(_loc5_);
         }
      }
      
      private function reward(param1:VOQuest, param2:Boolean = true) : void
      {
         var _loc3_:Array = Facade.questProxy.questList;
         _loc3_.splice(_loc3_.indexOf(param1),1);
         ShopLogic.applyCostList(param1.meta.qi_prize);
         ShopLogic.applySoldierList(param1.meta.qi_prize_units);
         this.updateQuestButtons();
         if(AbstractTrain.instance is QuestTrain)
         {
            if((AbstractTrain.instance as QuestTrain).item == param1)
            {
               AbstractTrain.clear();
            }
         }
         QuestLogic.clear(param1.kind);
         Facade.audioProxy.play("quest_complete");
         if(param2)
         {
            ActionLogic.request(PUserAction.USER_COMPLITE_QUEST,param1.kind);
         }
      }
      
      private function showSpeedupDialog(param1:VOQuest) : void
      {
         var _loc2_:Array = param1.target.qti_buy_finish;
         if(_loc2_.length > 1)
         {
            throw new Error("finish quest price length > 1");
         }
         var _loc3_:MessageDialog = new MessageDialog(QuestRenderer.getDesc(param1),Lang.getString("quest_speedup"),SkinManager.getExternal(param1.meta.qi_icon));
         _loc3_.addDelegateButton(new PriceButton().assignCost(_loc2_[0]),this.onSpeedup,[param1]);
         Facade.mainMediator.showDialog(_loc3_);
      }
      
      private function onSpeedup(param1:VOQuest) : void
      {
         var _loc2_:PCost = param1.target.qti_buy_finish[0];
         if(ShopLogic.checkPrice(_loc2_))
         {
            this.closeQuestDialog();
            ShopLogic.applyCost(_loc2_,true);
            ActionLogic.request(PUserAction.EXECUTE_QUEST_TARGET,PExecuteQuestTarget.create(param1.kind,0));
            this.reward(param1,false);
         }
      }
      
      public function updateQuestButtons() : void
      {
         this.questBtPanel.updateAll(Facade.questProxy.questList.slice());
      }
      
      public function newQuest(param1:PQuest) : void
      {
         if(Facade.questProxy.getQuest(param1.qname))
         {
            return;
         }
         if(!this.newList)
         {
            this.newList = new <PQuest>[param1];
            this.isWaitUpdate = true;
         }
         else
         {
            this.newList.push(param1);
         }
      }
      
      public function newStory(param1:str_str) : void
      {
         if(!this.storyList)
         {
            this.storyList = new Vector.<str_str>();
            this.isWaitUpdate = true;
         }
         this.storyList.push(param1);
      }
      
      public function init(param1:PUser) : void
      {
         var _loc2_:PQuest = null;
         var _loc3_:str_str = null;
         this.newList = null;
         Facade.questProxy.assignOpenQuests(param1.quests);
         if(param1.stories.length > 0)
         {
            if(!this.storyList)
            {
               this.storyList = new Vector.<str_str>();
            }
            else
            {
               this.storyList.length = 0;
            }
            for each(_loc3_ in param1.stories)
            {
               this.storyList.push(_loc3_);
            }
            this.isWaitUpdate = true;
         }
         else
         {
            this.storyList = null;
         }
         if(param1.divisions_reward.length > 0)
         {
            this.leagueList = param1.divisions_reward;
            this.isWaitUpdate = true;
         }
         this.updateQuestButtons();
         for each(_loc2_ in param1.quests)
         {
            this.learnQuest(_loc2_.qname);
         }
         if(this.isWaitUpdate)
         {
            this.update();
         }
         this.syncRankButton();
         QuestHash.checkTrain();
      }
      
      public function newLevelUp(param1:PNewLevelInfo) : void
      {
         if(!this.levelList)
         {
            this.levelList = new Vector.<PNewLevelInfo>();
            this.isWaitUpdate = true;
         }
         this.levelList.push(param1);
         if(this.isDialog)
         {
            if(Facade.mainMediator.searchDialog(LeagueUpDialog))
            {
               this.isDialog = false;
            }
         }
      }
      
      public function checkNewLeague(param1:uint) : void
      {
         param1--;
         var _loc2_:PShopDivision = Facade.manualProxy.getLeagueShop(param1);
         if(_loc2_.division_level == param1)
         {
            param1 = _loc2_.division_num + 1;
            if(this.leagueList)
            {
               if(this.leagueList.indexOf(param1) < 0)
               {
                  this.leagueList.push(param1);
               }
            }
            else
            {
               this.leagueList = [param1];
            }
         }
      }
      
      public function editQuest(param1:PQuest, param2:Boolean = true) : void
      {
         var _loc3_:String = param1.qname;
         if(!param2 || Boolean(Facade.questProxy.getQuest(_loc3_)))
         {
            this.editList.push(param1);
            this.isWaitUpdate = true;
         }
         else if(QuestProxy.isLikeOffer(_loc3_))
         {
            this.likeEvent(param1);
         }
         else if(Facade.userProxy.checkOffer(_loc3_))
         {
            Facade.myMediator.openOfferDialog(_loc3_,true);
         }
      }
      
      private function learnQuest(param1:String) : void
      {
         var _loc2_:QuestTrain = null;
         if(!AbstractTrain.instance)
         {
            if(QuestHash.learn.hasOwnProperty(param1))
            {
               _loc2_ = new QuestHash.learn[param1]() as QuestTrain;
               if(_loc2_)
               {
                  _loc2_.item = Facade.questProxy.getQuest(param1);
                  if(_loc2_.item.isNew)
                  {
                     this.questBtPanel.removeStatus(param1);
                     _loc2_.item.isNew = false;
                  }
                  AbstractTrain.assign(_loc2_);
               }
            }
         }
         else
         {
            _loc2_ = AbstractTrain.instance as QuestTrain;
            if(Boolean(_loc2_) && _loc2_.item.kind == param1)
            {
               _loc2_.run();
            }
         }
      }
      
      public function checkWaitUpdate() : Boolean
      {
         return this.isWaitUpdate;
      }
      
      public function update() : void
      {
         if(!Facade.isMyMap)
         {
            return;
         }
         this.isWaitUpdate = false;
         if(this.isDialog)
         {
            return;
         }
         if(this.editList.length > 0)
         {
            this.applyEditList();
         }
         if(this.levelList)
         {
            this.useLevelUp();
         }
         else if(this.leagueList)
         {
            this.useLeagueUp();
         }
         else if(this.storyList)
         {
            this.useStory();
         }
         else if(this.newList)
         {
            this.applyNewList();
         }
      }
      
      private function applyEditList() : void
      {
         var _loc1_:PQuest = null;
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:QuestDialog = null;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc7_:Boolean = false;
         for each(_loc1_ in this.editList)
         {
            _loc2_ = _loc1_.qname;
            if(_loc1_.qtargets.length != 1)
            {
               throw new Error("bad editQuest " + _loc2_);
            }
            _loc3_ = Facade.questProxy.editQuest(_loc2_,(_loc1_.qtargets[0] as PQuestTarget).variance == PQuestTarget.QTOPEN ? uint((_loc1_.qtargets[0] as PQuestTarget).value) : uint.MAX_VALUE);
            if(_loc3_ is String)
            {
               this.questBtPanel.useProgressStatus(_loc2_,_loc3_ as String);
            }
            else if(_loc3_ is VOQuest)
            {
               if((_loc3_ as VOQuest).meta.qi_achievement)
               {
                  _loc5_ = true;
                  if((_loc3_ as VOQuest).isComplete)
                  {
                     this.questBtPanel.rankBt.data = _loc2_;
                     this.questBtPanel.rankBt.useCollectStatus(false);
                     this.syncRankButton();
                  }
               }
            }
            else
            {
               _loc6_ = _loc3_ as uint;
               if(_loc6_ == 1)
               {
                  this.questBtPanel.useCollectStatus(_loc2_);
               }
               else
               {
                  if(_loc6_ != 2)
                  {
                     continue;
                  }
                  _loc7_ = true;
               }
            }
            _loc4_ = Facade.mainMediator.searchDialog(QuestDialog);
            if(_loc4_)
            {
               _loc4_.grid.sync();
            }
         }
         if(_loc7_)
         {
            this.updateQuestButtons();
         }
         for each(_loc1_ in this.editList)
         {
            this.learnQuest(_loc1_.qname);
         }
         this.editList.length = 0;
         if(_loc5_)
         {
            this.syncAchievements();
         }
      }
      
      private function applyNewList() : void
      {
         var _loc1_:Vector.<VOQuest> = null;
         var _loc3_:PQuest = null;
         var _loc4_:VOQuest = null;
         var _loc2_:QuestProxy = Facade.questProxy;
         for each(_loc3_ in this.newList)
         {
            _loc4_ = _loc2_.addQuest(_loc3_);
            if((Boolean(_loc4_)) && Boolean(_loc4_.meta.qi_achievement))
            {
               if(!_loc1_)
               {
                  _loc1_ = new Vector.<VOQuest>();
               }
               _loc1_.push(_loc4_);
            }
         }
         this.updateQuestButtons();
         for each(_loc3_ in this.newList)
         {
            this.learnQuest(_loc3_.qname);
         }
         this.newList = null;
         if(_loc1_)
         {
            this.syncAchievements(_loc1_);
         }
      }
      
      private function syncAchievements(param1:Vector.<VOQuest> = null) : void
      {
         var _loc2_:RankMediator = Facade.mainMediator.searchDialog(RankMediator);
         if(_loc2_)
         {
            _loc2_.syncAchievements(param1);
         }
      }
      
      private function useLevelUp() : void
      {
         var _loc3_:LevelUpDialog = null;
         var _loc1_:PNewLevelInfo = this.levelList.shift();
         if(this.levelList.length == 0)
         {
            this.levelList = null;
         }
         var _loc2_:PLevelInfo = Facade.manualProxy.getLevelInfo(_loc1_.new_level);
         if(Boolean(_loc2_) && _loc1_.new_level != 2)
         {
            this.isDialog = true;
            _loc3_ = new LevelUpDialog(_loc1_,_loc2_.l_bonus);
            _loc3_.addListener(VEvent.CLOSE_DIALOG,this.onDefaultDialogClose);
            Facade.mainMediator.showDialog(_loc3_);
            Facade.audioProxy.play("new_level");
         }
         else
         {
            this.update();
         }
      }
      
      private function onDefaultDialogClose(param1:VEvent) : void
      {
         this.isDialog = false;
         this.update();
      }
      
      private function useStory() : void
      {
         var _loc5_:Object = null;
         var _loc6_:NewStoryDialog = null;
         var _loc7_:uint = 0;
         if(this.storyList[0].field_0 == "hero2_mission2")
         {
         }
         var _loc1_:str_str = this.storyList.shift();
         if(this.storyList.length == 0)
         {
            this.storyList = null;
         }
         var _loc2_:String = _loc1_.field_0;
         var _loc3_:int = _loc2_.indexOf("_");
         if(_loc3_ > 0)
         {
            _loc2_ = "un_" + _loc2_.substr(0,_loc3_);
            _loc5_ = Facade.userProxy.soldierLevelHash[_loc2_];
            if(!(_loc5_ is uint) || _loc5_ == 0)
            {
               _loc5_ = _loc2_.indexOf("hero") != -1 ? "" : "1";
            }
            _loc2_ += String(_loc5_);
         }
         else
         {
            _loc2_ = "un_jaina1";
         }
         var _loc4_:String = Lang.getNullString(_loc1_.field_0);
         if(_loc4_)
         {
            _loc6_ = new NewStoryDialog(_loc2_,Lang.getString(_loc1_.field_0));
            _loc6_.data = _loc1_.field_0;
            _loc6_.addListener(VEvent.CLOSE_DIALOG,this.onStoryClose);
            Facade.mainMediator.showDialog(_loc6_);
            this.isDialog = true;
         }
         else
         {
            this.storyDialogList = new Vector.<String>();
            _loc7_ = 1;
            while(true)
            {
               _loc4_ = Lang.getNullString(_loc1_.field_0 + "_" + _loc7_);
               if(!_loc4_)
               {
                  break;
               }
               this.storyDialogList.push(_loc4_);
               _loc7_++;
            }
            this.storyDialogList.push(_loc2_);
            this.storyDialogList.push(_loc1_.field_0);
            this.onLongStoryClose();
         }
      }
      
      private function onStoryClose(param1:VEvent) : void
      {
         ActionLogic.request(PUserAction.READ_STORY,(param1.currentTarget as NewStoryDialog).data);
         this.isDialog = false;
         this.update();
      }
      
      private function onLongStoryClose(param1:VEvent = null) : void
      {
         var _loc5_:NewStoryDialog = null;
         var _loc6_:String = null;
         var _loc2_:String = this.storyDialogList[this.storyDialogList.length - 2];
         var _loc3_:String = this.storyDialogList[this.storyDialogList.length - 1];
         var _loc4_:* = int(Facade.mainPanel.numChildren - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = Facade.mainPanel.getChildAt(_loc4_) as NewStoryDialog;
            if(_loc5_)
            {
               break;
            }
            _loc4_--;
         }
         if(!_loc5_)
         {
            _loc5_ = new NewStoryDialog();
            _loc5_.addStretch(Facade.mainPanel.createDialogBg(),0);
            _loc5_.addListener(VEvent.CLOSE_DIALOG,this.onLongStoryClose);
            Facade.mainPanel.addInterLayer(_loc5_);
            Facade.mainPanel.layerPanel.visible = false;
            this.isDialog = true;
         }
         if(this.storyDialogList.length > 2)
         {
            _loc6_ = this.storyDialogList.shift();
            _loc5_.say(_loc2_,_loc6_);
         }
         else
         {
            Facade.mainPanel.layerPanel.visible = true;
            _loc5_.removeFromParent();
            ActionLogic.request(PUserAction.READ_STORY,_loc3_);
            this.isDialog = false;
            this.update();
         }
      }
      
      private function closeQuestDialog() : void
      {
         Facade.mainMediator.searchDialog(QuestOneDialog,true);
         Facade.mainMediator.searchDialog(QuestDialog,true);
      }
      
      public function changeQuest(param1:uint, param2:int, param3:String = null, param4:Number = 0, param5:Boolean = true, param6:uint = 0) : void
      {
         var _loc7_:VOQuest = null;
         var _loc8_:PQuestTargetInfo = null;
         for each(_loc7_ in Facade.questProxy.questList)
         {
            _loc8_ = _loc7_.target;
            if(_loc8_.qti_action.variance == param1)
            {
               if((!_loc8_.qti_kind || param3 == _loc8_.qti_kind) && (isNaN(_loc8_.qti_level) || _loc8_.qti_level == param4))
               {
                  if(!(param6 == 1 && _loc7_.isComplete))
                  {
                     if(param5)
                     {
                        param2 += _loc7_.count;
                        if(param2 < 0)
                        {
                           param2 = 0;
                        }
                     }
                     if(param2 > _loc8_.qti_count)
                     {
                        param2 = int(_loc8_.qti_count);
                     }
                     if(!(param6 == 2 && param2 < _loc7_.count))
                     {
                        if(param2 != _loc7_.count)
                        {
                           if(param2 < _loc7_.count)
                           {
                              this.questBtPanel.removeStatus(_loc7_.kind);
                           }
                           this.editQuest(PQuest.create(_loc7_.kind,[PQuestTarget.create(PQuestTarget.QTOPEN,param2)]),false);
                        }
                     }
                  }
               }
            }
         }
         if(this.isWaitUpdate)
         {
            this.update();
         }
      }
      
      public function likeEvent(param1:PQuest) : void
      {
         var _loc3_:PQuestTarget = null;
         var _loc2_:uint = 0;
         for each(_loc3_ in param1.qtargets)
         {
            _loc2_ += _loc3_.value;
         }
         if(_loc2_ == 0 && Facade.commonHash.hasOwnProperty(param1.qname))
         {
            Facade.commonHash[param1.qname] = true;
            Facade.callJS("checkAll");
         }
         this.openQuestOffer(param1);
      }
      
      public function openQuestOffer(param1:PQuest) : void
      {
         var _loc2_:Object = Facade.userProxy.offerHash;
         if(!_loc2_ || !_loc2_.hasOwnProperty(param1.qname))
         {
            Facade.myMediator.changeOffer(param1.qname,param1);
         }
         else
         {
            _loc2_[param1.qname] = param1;
         }
         Facade.myMediator.openOfferDialog(param1.qname,true);
      }
      
      public function syncRankButton() : void
      {
         var _loc2_:VOQuest = null;
         var _loc1_:Boolean = false;
         for each(_loc2_ in Facade.questProxy.questList)
         {
            if(Boolean(_loc2_.meta.qi_achievement) && _loc2_.isComplete)
            {
               _loc1_ = true;
               break;
            }
         }
         this.questBtPanel.rankAttention(_loc1_);
      }
      
      private function onRank(param1:MouseEvent) : void
      {
         var _loc2_:QuestButton = this.questBtPanel.rankBt;
         _loc2_.removeClip();
         DialogLogic.openRank(_loc2_.data is String ? RankMediator.ACHIEVEMENT : -1,_loc2_.data);
         _loc2_.data = null;
      }
      
      private function useLeagueUp() : void
      {
         var _loc1_:LeagueUpDialog = new LeagueUpDialog(Facade.manualProxy.getLeagueShop(this.leagueList.shift(),false));
         if(this.leagueList.length == 0)
         {
            this.leagueList = null;
         }
         this.isDialog = true;
         _loc1_.addListener(VEvent.CLOSE_DIALOG,this.onLeagueClose);
         Facade.mainMediator.showDialog(_loc1_);
         Facade.audioProxy.play("new_level");
      }
      
      private function onLeagueClose(param1:VEvent) : void
      {
         var _loc2_:PShopDivision = (param1.currentTarget as LeagueUpDialog).league;
         ShopLogic.applyCostList(_loc2_.division_reward);
         this.onDefaultDialogClose(param1);
         Facade.protoProxy.request(new Packet_0010_23(_loc2_.division_num));
         if(param1.data)
         {
            DialogLogic.openRank(RankMediator.MY_LEAGUE);
         }
      }
   }
}

