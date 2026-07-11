package game.history
{
   import flash.utils.Dictionary;
   import game.common.DialogMediator;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import logic.MainLogic;
   import model.ui.VOBattleItem;
   import model.ui.VOHistoryItem;
   import proto.BinaryBuffer;
   import proto.game.family_0010.PUserAction;
   import proto.game.family_0010.Packet_0010_12;
   import proto.game.family_0010.Packet_0010_13;
   import proto.model.PFightKind2;
   import proto.model.PFightLogInfo;
   import proto.model.PFightRequestResult;
   import proto.model.PHistFight;
   import proto.model.PKindCount;
   import proto.model.PNewsInfo;
   import proto.model.PPhfClan;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   
   public class HistoryMediator extends DialogMediator
   {
      
      private var dialog:HistoryDialog;
      
      private var historyDp:Array;
      
      private var isNewsTab:Boolean;
      
      private var historyIndex:uint;
      
      private var logHash:Dictionary = new Dictionary();
      
      private var highLight:Boolean;
      
      public function HistoryMediator(param1:Boolean, param2:uint, param3:Boolean)
      {
         super();
         this.isNewsTab = param1;
         this.historyIndex = param2;
         this.highLight = param3;
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog = new HistoryDialog(this.isNewsTab ? HistoryDialog.NEWS_TAB : HistoryDialog.HISTORY_TAB);
         if(Boolean(up.historyList) && up.historyList.length == 0)
         {
            this.dialog.tabList[HistoryDialog.HISTORY_TAB].disabled = true;
         }
         if(Boolean(mp.newsList) && mp.newsList.length == 0)
         {
            this.dialog.tabList[HistoryDialog.NEWS_TAB].disabled = true;
         }
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         this.dialog.addListener(VEvent.CHANGE,this.onTabChange);
         this.onTabChange(null);
         if(this.highLight)
         {
            this.dialog.highLightBossFight();
         }
         return this.dialog;
      }
      
      override public function onRemove() : void
      {
         if(this.isNewsTab)
         {
            ActionLogic.request(PUserAction.READ_NEWS,(mp.newsList[0] as PNewsInfo).news_kind);
         }
      }
      
      private function createHistoryItem(param1:PHistFight) : VOHistoryItem
      {
         var _loc2_:VOHistoryItem = new VOHistoryItem();
         _loc2_.item = param1;
         if(param1.phf_id.indexOf("boss") >= 0)
         {
            _loc2_.boss = up.getBossKind();
            _loc2_.item.phf_ratio = Math.pow((up.level + up.historyList.length + 180) / 6,Math.E);
            _loc2_.item.phf_clan = PPhfClan.create("emblem_empire",Lang.getString("empire"));
         }
         else if(param1.phf_revenge)
         {
            this.syncRevengeLog(_loc2_);
         }
         else
         {
            _loc2_.isLog = true;
         }
         _loc2_.tailTime = CoreLogic.serverTime - param1.phf_time;
         return _loc2_;
      }
      
      private function syncRevengeLog(param1:VOHistoryItem) : void
      {
         var _loc2_:Object = this.logHash[param1.item.phf_uid];
         if(_loc2_ is PFightLogInfo)
         {
            param1.isLog = true;
            param1.log = _loc2_ as PFightLogInfo;
            param1.isRevenge = !param1.log.fli_is_online && param1.log.fli_shield_end_time == 0;
         }
         else if(_loc2_ === false)
         {
            param1.isLog = true;
         }
      }
      
      private function createHistoryDp() : void
      {
         var _loc2_:PHistFight = null;
         var _loc3_:VOHistoryItem = null;
         this.historyDp = [];
         var _loc1_:uint = 0;
         for each(_loc2_ in up.historyList)
         {
            _loc3_ = this.createHistoryItem(_loc2_);
            _loc3_.soldierList = this.getSoldierDp(_loc2_);
            this.historyDp.push(_loc3_);
            if(!_loc2_.phf_read)
            {
               _loc2_.phf_read = true;
               _loc1_++;
            }
         }
         if(_loc1_ > 0)
         {
            Facade.myMediator.myPanel.syncHistoryButton(0);
            ActionLogic.request(PUserAction.READ_FIGHT_HIST,null);
         }
      }
      
      private function getSoldierDp(param1:PHistFight) : Array
      {
         var _loc5_:PKindCount = null;
         var _loc6_:VOBattleItem = null;
         var _loc7_:uint = 0;
         var _loc8_:PKindCount = null;
         var _loc2_:uint = param1.phf_units_in_fight.length;
         var _loc3_:Array = param1.phf_units_in_fight.concat(param1.phf_spells);
         var _loc4_:* = int(_loc3_.length - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = _loc3_[_loc4_];
            _loc6_ = new VOBattleItem();
            _loc3_[_loc4_] = _loc6_;
            _loc7_ = mp.getUnitLevel(param1.phf_units_levels,_loc5_.kind);
            if(_loc4_ < _loc2_)
            {
               _loc6_.shop = mp.getSoldierShop(_loc5_.kind,_loc7_);
            }
            else
            {
               _loc6_.spellShop = mp.getSpellShop(_loc5_.kind,_loc7_);
            }
            _loc6_.count = _loc5_.count;
            for each(_loc8_ in param1.phf_unit_died)
            {
               if(_loc5_.kind == _loc8_.kind)
               {
                  _loc6_.select = _loc8_.count;
                  break;
               }
            }
            _loc4_--;
         }
         return _loc3_;
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:PHistFight = param1.data;
         switch(param1.variance)
         {
            case 1:
               this.setMyMapCallback();
               MainLogic.getReplay(_loc2_.phf_id);
               break;
            case 2:
               if(MainLogic.checkArmy())
               {
                  if(_loc2_.phf_id.indexOf("boss") >= 0)
                  {
                     DialogLogic.toMissionMap();
                     break;
                  }
                  Facade.myMediator.checkShieldAndCall(MainLogic.getRivalMap,[PFightKind2.create(PFightKind2.REVENGE,_loc2_.phf_id),true,this.onRevenge]);
               }
               break;
            case 3:
               if(_loc2_.phf_id.indexOf("boss") >= 0)
               {
                  this.setMyMapCallback();
                  MainLogic.getFriendMap(Facade.userProxy.getBossKind(true),true);
                  break;
               }
               this.setMyMapCallback();
               MainLogic.getFriendMap(_loc2_.phf_uid);
         }
      }
      
      private function setMyMapCallback() : void
      {
         Facade.setMapCallback(DialogLogic.openHistory,[false,this.historyIndex]);
      }
      
      private function onRevenge(... rest) : void
      {
         var _loc2_:BinaryBuffer = rest[0];
         if(_loc2_.family == 16 && _loc2_.subfamily == 4)
         {
            if(_loc2_.readUnsignedByte() == PFightRequestResult.NO_TARGET)
            {
               this.logHash = new Dictionary();
               if(this.dialog.getTabIndex() == HistoryDialog.HISTORY_TAB)
               {
                  this.createHistoryDp();
                  this.dialog.setDp(this.historyDp,this.historyIndex);
               }
               else
               {
                  this.historyDp = null;
               }
               Facade.mainPanel.hideLoadPanel();
               Facade.mainMediator.showMessage(Lang.getString("no_revenge"));
               return;
            }
         }
         this.setMyMapCallback();
         MainLogic.applyMapBuffer(_loc2_,rest.length >= 2 ? uint(rest[2]) : 0);
      }
      
      private function onTabChange(param1:VEvent) : void
      {
         switch(this.dialog.getTabIndex())
         {
            case HistoryDialog.HISTORY_TAB:
               if(!this.historyDp)
               {
                  this.createHistoryDp();
               }
               this.dialog.createGrid(HistoryRenderer,3);
               this.dialog.grid.addListener(VEvent.CHANGE,this.onHistoryChange);
               this.dialog.setDp(this.historyDp,this.historyIndex);
               break;
            case HistoryDialog.NEWS_TAB:
               this.dialog.createGrid(NewsRenderer);
               this.dialog.setDp(mp.newsList);
         }
      }
      
      private function onHistoryChange(param1:VEvent) : void
      {
         var _loc7_:Boolean = false;
         var _loc9_:VOHistoryItem = null;
         var _loc10_:String = null;
         var _loc2_:VGrid = this.dialog.grid;
         var _loc3_:uint = _loc2_.index;
         if(param1)
         {
            this.historyIndex = _loc3_;
         }
         _loc3_ += _loc2_.maxRenderer;
         var _loc4_:Array = _loc2_.getDataProvider();
         if(_loc4_.length < _loc3_)
         {
            _loc3_ = _loc4_.length;
         }
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc8_:uint = _loc2_.index;
         while(_loc8_ < _loc3_)
         {
            _loc9_ = _loc4_[_loc8_];
            if(!_loc9_.isLog)
            {
               this.syncRevengeLog(_loc9_);
               if(_loc9_.isLog)
               {
                  _loc7_ = true;
               }
               else
               {
                  _loc10_ = _loc9_.item.phf_uid;
                  if(this.logHash[_loc10_] !== true)
                  {
                     this.logHash[_loc10_] = true;
                     if(!_loc5_)
                     {
                        _loc5_ = [];
                        _loc6_ = [];
                     }
                     _loc5_.push(_loc9_.item.phf_id);
                     _loc6_.push(_loc10_);
                  }
               }
            }
            _loc8_++;
         }
         if(_loc5_)
         {
            Facade.protoProxy.request(new Packet_0010_12(_loc5_),this.resultHistoryLog,16,19,[_loc6_],"historyLogs");
         }
         if(_loc7_)
         {
            _loc2_.sync(-1,false);
         }
      }
      
      private function resultHistoryLog(param1:BinaryBuffer, param2:Array) : void
      {
         var _loc3_:PFightLogInfo = null;
         var _loc5_:* = 0;
         var _loc6_:Number = NaN;
         if(!this.dialog.parent)
         {
            return;
         }
         for each(_loc3_ in new Packet_0010_13(param1).value)
         {
            if(_loc3_.fli_is_online)
            {
               _loc6_ = -1;
            }
            else if(isNaN(_loc3_.fli_shield_end_time))
            {
               _loc6_ = 0;
            }
            else
            {
               _loc6_ = _loc3_.fli_shield_end_time - CoreLogic.serverTime;
               if(_loc6_ < 2)
               {
                  _loc6_ = 0;
               }
               else if(_loc6_ < 300)
               {
                  _loc6_ = 300;
               }
            }
            _loc3_.fli_shield_end_time = _loc6_;
            this.logHash[_loc3_.fli_user_id] = _loc3_;
            _loc5_ = param2.indexOf(_loc3_.fli_user_id);
            if(_loc5_ >= 0)
            {
               param2[_loc5_] = null;
            }
         }
         _loc5_ = int(param2.length - 1);
         while(_loc5_ >= 0)
         {
            if(param2[_loc5_])
            {
               this.logHash[param2[_loc5_]] = false;
            }
            _loc5_--;
         }
         var _loc4_:uint = this.dialog.getTabIndex();
         if(_loc4_ == HistoryDialog.HISTORY_TAB)
         {
            this.onHistoryChange(null);
         }
      }
   }
}

