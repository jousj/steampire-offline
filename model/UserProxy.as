package model
{
   import engine.data.LinkedList;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Fence;
   import engine.units.Worker;
   import flash.utils.Dictionary;
   import game.clan.center.ClanCenterDialog;
   import game.clan.center.ClanMembersMediator;
   import game.clan.center.MembersDialog;
   import game.clan.center.TopClansMediator;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import proto.BinaryBuffer;
   import proto.game.family_0010.PUserAction;
   import proto.game.family_0060.Packet_0060_02;
   import proto.game.family_0060.Packet_0060_03;
   import proto.game.family_0060.Packet_0060_3B;
   import proto.game.family_0060.Packet_0060_3C;
   import proto.model.PAdventure;
   import proto.model.PAsk;
   import proto.model.PClanCenter;
   import proto.model.PClanCompPlaceAnswer;
   import proto.model.PClanCompPlaceRequest;
   import proto.model.PClanRequest;
   import proto.model.PCost;
   import proto.model.PCostt;
   import proto.model.PCurrentAdventure;
   import proto.model.PExtMission;
   import proto.model.PHero;
   import proto.model.PHome;
   import proto.model.PPermission;
   import proto.model.PRaidEvent;
   import proto.model.PRaidFriendEvent;
   import proto.model.PRole;
   import proto.model.PShopResourcesPack;
   import proto.model.PShopSubscription;
   import proto.model.PSubscription;
   import proto.model.PUser;
   import proto.model.PUserBase;
   import proto.model.PUserClan;
   import proto.model.clan.PBase;
   import proto.model.clan.PCallRequest;
   import proto.model.clan.PCapitalLog;
   import proto.model.clan.PCapitalLogKind;
   import proto.model.clan.PClan;
   import proto.model.clan.PMember;
   import proto.model.clan.PMessage;
   import proto.model.clan.PResources;
   import proto.model.clan.PSetRole;
   import proto.tuples.str_str;
   import ui.common.BaseDialog;
   import utils.CommonUtils;
   
   public class UserProxy
   {
      
      public var stage:String;
      
      public var base:PUserBase;
      
      public var _clan:PUserClan;
      
      public var group_id:uint;
      
      public var level:uint;
      
      public var exp:uint;
      
      public var nextExp:uint;
      
      public var gold:uint;
      
      public var ruby:uint;
      
      public var crystal:int;
      
      public var crystalMax:uint;
      
      public var oil:int;
      
      public var oilMax:uint;
      
      public var energy:uint;
      
      public var energyMax:uint;
      
      public var rating:uint;
      
      public var blueOre:uint;
      
      public var greenOre:uint;
      
      public var redOre:uint;
      
      public var glory:uint;
      
      public var j_glory:uint;
      
      public var rar_dragon:uint;
      
      public var mithril:int;
      
      public var blueprint:uint;
      
      public var clanEnergy:uint;
      
      public var townHallLevel:uint;
      
      public var customData:Array;
      
      public var workerMax:uint;
      
      public var soldierCapacityCur:uint;
      
      public var soldierCapacityMax:uint;
      
      public var soldierCountHash:Dictionary;
      
      public var soldierLevelHash:Dictionary;
      
      public var constructionId:uint;
      
      public var constructionHash:Dictionary;
      
      public var soldierHash:Dictionary;
      
      public var spellList:Array;
      
      public var buildList:LinkedList = new LinkedList();
      
      public var cannonList:LinkedList = new LinkedList();
      
      public var fenceList:LinkedList = new LinkedList();
      
      public var decorList:LinkedList = new LinkedList();
      
      public var garbageList:LinkedList = new LinkedList();
      
      public var workerList:LinkedList = new LinkedList();
      
      public var landingGroup:Vector.<LinkedList> = new <LinkedList>[this.cannonList,this.buildList,this.fenceList,this.decorList];
      
      public var soldierList:LinkedList = new LinkedList();
      
      public var heroSpecList:Array;
      
      public var shopNewList:Array;
      
      public var jainaEventList:Array;
      
      public var adventureList:Array;
      
      public var currentAdventure:PCurrentAdventure;
      
      public var winMissionList:Array;
      
      public var extMissionList:Array;
      
      public var raidMissionList:Array;
      
      public var historyList:Array;
      
      public var missionPercentageList:Array;
      
      public var chatList:Vector.<PMessage>;
      
      public var clanData:PClan;
      
      public var energyRequestList:Array;
      
      public var readClanTime:Number;
      
      public var alinkHistoryList:Array;
      
      public var alinkRequestList:Array;
      
      public var alinkStartTime:Number;
      
      public var buyOfferList:Array;
      
      public var offerHash:Dictionary;
      
      public var lastArmyList:Array;
      
      public var subs:PSubscription;
      
      public var restartTime:Number;
      
      private var constructionCountHash:Dictionary;
      
      private var constructionMaxHash:Dictionary;
      
      public var lastSeason:PClanCompPlaceAnswer = null;
      
      public var curSeason:PClanCompPlaceAnswer = null;
      
      public var clanHallPrize:PClanCenter;
      
      public function UserProxy()
      {
         super();
      }
      
      public function clear() : void
      {
         this.exp = 0;
         this.nextExp = uint.MAX_VALUE;
         this.rar_dragon = this.j_glory = this.glory = 0;
         this.clanEnergy = this.energy = 0;
         this.mithril = this.blueOre = this.greenOre = this.redOre = 0;
         this.constructionHash = new Dictionary();
         this.soldierHash = new Dictionary();
         this.constructionId = 0;
         this.constructionCountHash = new Dictionary();
         this.workerMax = 0;
         this.soldierCapacityCur = this.soldierCapacityMax = 0;
         this.soldierCountHash = new Dictionary();
         this.soldierLevelHash = new Dictionary();
         this.heroSpecList = null;
         this.buildList.clear();
         this.cannonList.clear();
         this.fenceList.clear();
         this.decorList.clear();
         this.garbageList.clear();
         this.workerList.clear();
         this.soldierList.clear();
         this.historyList = null;
         this.missionPercentageList = null;
         this.buyOfferList = null;
         this.offerHash = null;
         this.restartTime = 0;
         this.lastArmyList = null;
      }
      
      public function assignUser(param1:PUser, param2:PHome) : void
      {
         this.base = param1.base;
         this.clan = this.base.clan;
         if(this.clan)
         {
            this.assignClanData(param2.clan);
            this.applyCallList(param2.clan_requests);
         }
         Preloader.uid = param1.base.user_id;
         this.base.clan = null;
         this.group_id = param1.group_id;
         this.setMithril(param1.mithril,false,false);
         this.setGold(param1.gold,false);
         this.setRuby(param1.ruby,false);
         this.oil = this.crystal = uint.MAX_VALUE;
         this.setCrystal(param1.crystal,false,false);
         this.setOil(param1.oil,false,false);
         this.exp = this.base.exp;
         this.energy = param1.call;
         this.clanEnergy = param1.clan_calls;
         this.glory = param1.hglory;
         this.j_glory = param1.jglory;
         this.rar_dragon = param1.rar_dragon;
         this.blueOre = param1.blue_ore;
         this.greenOre = param1.green_ore;
         this.redOre = param1.red_ore;
         this.mithril = param1.mithril;
         this.blueprint = param1.blue_print;
         this.setLevel(this.base.level,false);
         this.setRating(this.base.ratio,false);
         this.winMissionList = param1.win_missions;
         this.winMissionList.unshift("ms_mission1");
         this.extMissionList = param1.ext_missions;
         this.raidMissionList = param1.raid_cooldowns;
         this.historyList = param1.fight_hist;
         this.readClanTime = param1.read_chat_time;
         this.alinkHistoryList = param1.request_list;
         this.alinkStartTime = param1.request_time;
         this.alinkRequestList = param1.requests;
         this.shopNewList = param1.shop_unwatched;
         this.lastArmyList = param1.last_units;
         this.spellList = param1.spells;
         this.jainaEventList = param1.jaina_events;
         this.adventureList = param1.adventures;
         this.currentAdventure = param1.current_adventure;
         this.subs = param1.subscription;
      }
      
      public function set clan(param1:PUserClan) : void
      {
         this._clan = param1;
         if(this._clan)
         {
            this.updateSeasonInfo();
            Facade.protoProxy.request(new Packet_0060_3B(PClanCompPlaceRequest.create(TopClansMediator.getCurSeason() - 1,Facade.userProxy.clan.uc_clan_id)),this.saveLastSeason);
         }
         else
         {
            this.curSeason = null;
            this.lastSeason = null;
         }
      }
      
      public function updateSeasonInfo() : void
      {
         if(Facade.userProxy.clan)
         {
            Facade.protoProxy.request(new Packet_0060_3B(PClanCompPlaceRequest.create(TopClansMediator.getCurSeason(),Facade.userProxy.clan.uc_clan_id)),this.saveCurSeason);
         }
      }
      
      private function saveCurSeason(param1:BinaryBuffer) : void
      {
         var _loc3_:BaseDialog = null;
         var _loc2_:PClanCompPlaceAnswer = new Packet_0060_3C(param1).value;
         this.curSeason = _loc2_;
         if(Boolean(this.clanData) && (this.clanData.clan_comp_place_opt != _loc2_.place || this.clanData.base.clan_points != _loc2_.clan_points))
         {
            this.clanData.clan_comp_place_opt = _loc2_.place;
            this.clanData.base.clan_points = _loc2_.clan_points;
            _loc3_ = Facade.mainMediator.searchDialog(MembersDialog);
            if(_loc3_)
            {
               _loc3_.close();
               Facade.mainMediator.searchDialog(ClanCenterDialog,true);
               DialogLogic.openClanCenter(false);
               DialogLogic.open(new ClanMembersMediator(this.clanData));
            }
            else
            {
               _loc3_ = Facade.mainMediator.searchDialog(ClanCenterDialog);
               if(_loc3_)
               {
                  _loc3_.close();
                  DialogLogic.openClanCenter(false);
               }
            }
         }
      }
      
      private function saveLastSeason(param1:BinaryBuffer) : void
      {
         var _loc2_:PClanCompPlaceAnswer = new Packet_0060_3C(param1).value;
         this.lastSeason = _loc2_;
      }
      
      public function get clan() : PUserClan
      {
         return this._clan;
      }
      
      public function assignCapital(param1:PBase) : void
      {
         this.oil = this.crystal = uint.MAX_VALUE;
         this.setCrystal(param1.crystal,false,false);
         this.setOil(param1.oil,false,false);
         this.setGold(param1.gold,false);
         this.setMithril(param1.mithril,false,false);
         this.exp = param1.exp;
         this.setLevel(param1.level,false);
      }
      
      public function setGold(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            param1 += this.gold;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(this.gold != param1)
         {
            this.gold = param1;
            Facade.dispatchCommonEvent(CommonEvent.GOLD,this.gold,PCost.GOLD);
         }
      }
      
      public function setRuby(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            param1 += this.ruby;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(this.ruby != param1)
         {
            this.ruby = param1;
            Facade.dispatchCommonEvent(CommonEvent.RUBY,this.ruby,PCost.RUBY);
         }
      }
      
      public function setOre(param1:int, param2:Boolean, param3:uint) : void
      {
         if(param2)
         {
            if(param3 == PCost.RED_ORE)
            {
               param1 += this.redOre;
            }
            else if(param3 == PCost.GREEN_ORE)
            {
               param1 += this.greenOre;
            }
            else
            {
               param1 += this.blueOre;
            }
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param3 == PCost.RED_ORE)
         {
            this.redOre = param1;
         }
         else if(param3 == PCost.GREEN_ORE)
         {
            this.greenOre = param1;
         }
         else
         {
            this.blueOre = param1;
         }
         Facade.dispatchCommonEvent(CommonEvent.ORE,param1,param3);
      }
      
      public function setMithril(param1:int, param2:Boolean, param3:Boolean) : void
      {
         if(param2)
         {
            param1 += this.mithril;
         }
         if(param3)
         {
            param1 = this.calcLimitResource(this.mithril,param1,Facade.isCapital ? Facade.references.clan_mithril_limit : Facade.references.mithril_limit);
         }
         if(this.mithril != param1)
         {
            this.mithril = param1;
            Facade.dispatchCommonEvent(CommonEvent.MITHRIL,this.mithril,PCost.MITHRIL);
         }
      }
      
      public function setRarDragon(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            param1 += this.rar_dragon;
         }
         if(this.rar_dragon != param1)
         {
            this.rar_dragon = param1;
            Facade.dispatchCommonEvent(CommonEvent.RAR_DRAGON,this.rar_dragon,PCost.RAR_DRAGON);
         }
      }
      
      public function setCrystal(param1:int, param2:Boolean, param3:Boolean) : void
      {
         if(param2)
         {
            param1 += this.crystal;
         }
         if(param3)
         {
            param1 = this.calcLimitResource(this.crystal,param1,this.crystalMax);
         }
         if(this.crystal != param1)
         {
            this.crystal = param1;
            Facade.dispatchCommonEvent(CommonEvent.CRYSTAL,param1,PCost.CRYSTAL);
         }
      }
      
      public function setOil(param1:int, param2:Boolean, param3:Boolean) : void
      {
         if(param2)
         {
            param1 += this.oil;
         }
         if(param3)
         {
            param1 = this.calcLimitResource(this.oil,param1,this.oilMax);
         }
         if(this.oil != param1)
         {
            this.oil = param1;
            Facade.dispatchCommonEvent(CommonEvent.OIL,param1,PCost.OIL);
         }
      }
      
      public function setExp(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            param1 += this.exp;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         this.exp = param1;
         if(this.exp >= this.nextExp)
         {
            do
            {
               this.setLevel(this.level + 1,true);
            }
            while(this.exp >= this.nextExp);
         }
         else
         {
            Facade.dispatchCommonEvent(CommonEvent.EXP,this.exp,PCost.EXP);
         }
      }
      
      public function setGlory(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            param1 += this.glory;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(this.glory != param1)
         {
            this.glory = param1;
            Facade.dispatchCommonEvent(CommonEvent.GLORY,this.glory,PCost.H_GLORY);
         }
      }
      
      public function setJGlory(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            param1 += this.j_glory;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(this.j_glory != param1)
         {
            this.j_glory = param1;
            Facade.dispatchCommonEvent(CommonEvent.J_GLORY,this.j_glory,PCost.J_GLORY);
         }
      }
      
      public function setBlueprint(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            param1 += this.blueprint;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > Facade.references.blue_print_limit)
         {
            param1 = Facade.references.blue_print_limit;
         }
         if(this.blueprint != param1)
         {
            this.blueprint = param1;
            Facade.dispatchCommonEvent(CommonEvent.BLUEPRINT,this.blueprint,PCost.BLUE_PRINT);
         }
      }
      
      public function setRating(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            param1 += this.rating;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         this.rating = param1;
         Facade.dispatchCommonEvent(CommonEvent.RATING,this.rating);
      }
      
      private function setLevel(param1:uint, param2:Boolean) : void
      {
         this.level = param1;
         this.nextExp = Facade.manualProxy.getExp(param1 + 1);
         Facade.dispatchCommonEvent(CommonEvent.LEVEL,param2);
      }
      
      public function getCostCur(param1:uint) : int
      {
         switch(param1)
         {
            case PCost.CRYSTAL:
               return this.crystal;
            case PCost.OIL:
               return this.oil;
            case PCost.CALL:
               return this.energy;
            case PCost.H_GLORY:
               return this.glory;
            case PCost.J_GLORY:
               return this.j_glory;
            case PCost.MITHRIL:
               return this.mithril;
            case PCost.RAR_DRAGON:
               return this.rar_dragon;
            case PCost.BLUE_PRINT:
               return this.blueprint;
            case PCost.GOLD:
               return this.gold;
            case PCost.RED_ORE:
               return this.redOre;
            case PCost.GREEN_ORE:
               return this.greenOre;
            case PCost.BLUE_ORE:
               return this.blueOre;
            case PCost.RUBY:
               return this.ruby;
            default:
               throw new Error("getCostCur need add variance " + param1);
         }
      }
      
      public function checkCost(param1:uint, param2:uint) : uint
      {
         var _loc3_:int = this.getCostCur(param1);
         if(param2 > _loc3_)
         {
            return param2 - _loc3_;
         }
         return 0;
      }
      
      public function isCost(param1:PCost) : Boolean
      {
         return this.checkCost(param1.variance,param1.value) == 0;
      }
      
      public function getConstructionCount(param1:String) : uint
      {
         if(this.constructionCountHash.hasOwnProperty(param1))
         {
            return this.constructionCountHash[param1];
         }
         return 0;
      }
      
      public function changeConstructionCount(param1:String, param2:int, param3:Boolean = true) : void
      {
         if(param3)
         {
            param2 += this.getConstructionCount(param1);
         }
         if(param2 < 0)
         {
            param2 = 0;
         }
         this.constructionCountHash[param1] = param2;
      }
      
      public function getConstructionMax(param1:String) : uint
      {
         if(Boolean(this.constructionMaxHash) && this.constructionMaxHash.hasOwnProperty(param1))
         {
            return this.constructionMaxHash[param1];
         }
         return 0;
      }
      
      public function changeConstructionMaxHash(param1:Dictionary) : void
      {
         this.constructionMaxHash = param1;
      }
      
      public function makeSoldier(param1:String, param2:uint, param3:uint = 1) : void
      {
         this.soldierCapacityCur += param2 * param3;
         this.soldierCountHash[param1] += param3;
      }
      
      public function getFreeWorker() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:Worker = this.workerList.head as Worker;
         while(_loc2_)
         {
            if(!_loc2_.isFree)
            {
               _loc1_++;
            }
            _loc2_ = _loc2_.link_next as Worker;
         }
         return this.workerMax - _loc1_;
      }
      
      public function getBuild(param1:uint, param2:Boolean, param3:uint = 0, param4:Vector.<Build> = null) : Build
      {
         var _loc5_:Build = this.buildList.head as Build;
         while(_loc5_)
         {
            if(_loc5_.type == param1)
            {
               if(_loc5_.updateLevel == 0 || !param2 && _loc5_.updateLevel > 1)
               {
                  if(param3 == 0 || _loc5_.level >= param3)
                  {
                     if(!param4)
                     {
                        return _loc5_;
                     }
                     param4.push(_loc5_);
                  }
               }
            }
            _loc5_ = _loc5_.link_next as Build;
         }
         return null;
      }
      
      public function getBuildEx(param1:Object, param2:Boolean, param3:uint = 0, param4:Vector.<Build> = null) : Build
      {
         var _loc5_:Boolean = param1 is String;
         var _loc6_:Build = this.buildList.head as Build;
         while(_loc6_)
         {
            if(_loc5_ && _loc6_.kind == param1 || !_loc5_ && _loc6_.type == param1)
            {
               if(_loc6_.updateLevel == 0 || !param2)
               {
                  if(param3 == 0 || _loc6_.level >= param3)
                  {
                     if(!param4)
                     {
                        return _loc6_;
                     }
                     param4.push(_loc6_);
                  }
               }
            }
            _loc6_ = _loc6_.link_next as Build;
         }
         return null;
      }
      
      public function getCannon(param1:Object, param2:Boolean, param3:uint = 0, param4:Vector.<Cannon> = null) : Cannon
      {
         var _loc5_:Cannon = this.cannonList.head as Cannon;
         while(_loc5_)
         {
            if(_loc5_.kind == param1)
            {
               if(_loc5_.updateLevel == 0 || !param2)
               {
                  if(param3 == 0 || _loc5_.level >= param3)
                  {
                     if(!param4)
                     {
                        return _loc5_;
                     }
                     param4.push(_loc5_);
                  }
               }
            }
            _loc5_ = _loc5_.link_next as Cannon;
         }
         return null;
      }
      
      public function getFence(param1:Object, param2:uint = 0, param3:Vector.<Fence> = null) : Fence
      {
         var _loc4_:Fence = this.fenceList.head as Fence;
         while(_loc4_)
         {
            if(_loc4_.kind == param1)
            {
               if(param2 == 0 || _loc4_.level >= param2)
               {
                  if(!param3)
                  {
                     return _loc4_;
                  }
                  param3.push(_loc4_);
               }
            }
            _loc4_ = _loc4_.link_next as Fence;
         }
         return null;
      }
      
      public function checkBuild(param1:String, param2:uint = 0) : Boolean
      {
         var _loc3_:Build = this.buildList.head as Build;
         while(_loc3_)
         {
            if(_loc3_.kind == param1 && _loc3_.updateLevel != 1)
            {
               if(param2 == 0 || _loc3_.level > param2 || _loc3_.level == param2 && _loc3_.updateLevel == 0)
               {
                  return true;
               }
            }
            _loc3_ = _loc3_.link_next as Build;
         }
         return false;
      }
      
      public function getResourcePackCount(param1:PShopResourcesPack) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = param1.rs_type.variance;
         if(_loc3_ == PCostt.CRYSTAL)
         {
            _loc2_ = this.crystalMax;
         }
         else if(_loc3_ == PCostt.OIL)
         {
            _loc2_ = this.oilMax;
         }
         else
         {
            if(_loc3_ != PCostt.CALL)
            {
               throw new Error("getResourcePackCount bad type");
            }
            _loc2_ = this.energyMax;
         }
         return Math.round(_loc2_ * param1.rs_percentage / 100);
      }
      
      public function getHeroSpec(param1:String) : PHero
      {
         var _loc2_:PHero = null;
         for each(_loc2_ in this.heroSpecList)
         {
            if(_loc2_.hero_kind == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getMissionExKind(param1:String, param2:Boolean = false) : String
      {
         var _loc3_:PExtMission = null;
         for each(_loc3_ in this.extMissionList)
         {
            if(param2)
            {
               if(_loc3_.em_next_mission == param1)
               {
                  return _loc3_.em_kind;
               }
            }
            else if(_loc3_.em_kind == param1)
            {
               return _loc3_.em_next_mission;
            }
         }
         throw new Error("bad ex mission from kind=" + param1);
      }
      
      public function getClanMember(param1:String) : PMember
      {
         var _loc2_:PMember = null;
         if(this.clanData)
         {
            for each(_loc2_ in this.clanData.members)
            {
               if(_loc2_.user_base.user_id == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function applyChatList(param1:Array) : void
      {
         var _loc2_:PRaidFriendEvent = null;
         this.chatList = new Vector.<PMessage>();
         CommonUtils.sort(param1,["rf_ts"],[Array.NUMERIC]);
         for each(_loc2_ in param1)
         {
            if(_loc2_.rf_event.variance == PRaidEvent.CHAT_MESSAGE)
            {
               this.chatList.push(_loc2_.rf_event.value);
            }
         }
      }
      
      public function applyCallList(param1:Array) : void
      {
         var _loc2_:PCallRequest = null;
         this.energyRequestList = [];
         for each(_loc2_ in param1)
         {
            if(!(_loc2_.cr_current_count >= _loc2_.cr_full_count || _loc2_.cr_user_id == this.base.user_id || _loc2_.cr_senders.indexOf(this.base.user_id) >= 0))
            {
               _loc2_.member = this.getClanMember(_loc2_.cr_user_id);
               if(_loc2_.member)
               {
                  this.energyRequestList.push(_loc2_);
               }
            }
         }
         this.energyRequestList.sortOn("cr_time",Array.DESCENDING);
      }
      
      public function addClanMember(param1:PMember) : void
      {
         this.clanData.members.push(param1);
         ++this.clanData.base.members_count;
         this.clanData.base.ratio += param1.user_base.ratio;
         this.clanData.base.clan_points += ClanMembersMediator.getCurRating(param1.user_base.clan_points);
         this.updateSeasonInfo();
      }
      
      public function deleteMember(param1:String) : void
      {
         var _loc4_:PMember = null;
         var _loc2_:Array = this.clanData.members;
         var _loc3_:* = int(_loc2_.length - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = _loc2_[_loc3_] as PMember;
            if(_loc4_.user_base.user_id == param1)
            {
               --this.clanData.base.members_count;
               this.clanData.base.ratio -= _loc4_.user_base.ratio;
               this.clanData.base.clan_points -= ClanMembersMediator.getCurRating(_loc4_.user_base.clan_points);
               _loc2_.splice(_loc3_,1);
               break;
            }
            _loc3_--;
         }
         if(this.energyRequestList)
         {
            _loc3_ = int(this.energyRequestList.length - 1);
            while(_loc3_ >= 0)
            {
               if((this.energyRequestList[_loc3_] as PCallRequest).cr_user_id == param1)
               {
                  this.energyRequestList.splice(_loc3_,1);
               }
               _loc3_--;
            }
         }
         this.updateSeasonInfo();
      }
      
      public function deleteClanRequest(param1:String) : void
      {
         var _loc2_:* = int(this.clanData.requests.length - 1);
         while(_loc2_ >= 0)
         {
            if((this.clanData.requests[_loc2_] as PClanRequest).cr_user_id == param1)
            {
               this.clanData.requests.splice(_loc2_,1);
               break;
            }
            _loc2_--;
         }
      }
      
      public function addClanRequest(param1:PClanRequest) : void
      {
         this.clanData.requests.push(param1);
         this.clanData.requests.sortOn("cr_time");
      }
      
      public function setClanRole(param1:PSetRole) : void
      {
         var _loc2_:PMember = null;
         if(param1.sr_user_id == this.base.user_id)
         {
            this.clan.uc_role = param1.sr_role;
         }
         for each(_loc2_ in this.clanData.members)
         {
            if(_loc2_.user_base.user_id == param1.sr_user_id)
            {
               _loc2_.role = param1.sr_role;
               break;
            }
         }
      }
      
      public function clanMemberSort(param1:PMember, param2:PMember) : int
      {
         var _loc3_:int = param2.user_base.ratio - param1.user_base.ratio;
         if(_loc3_ == 0)
         {
            _loc3_ = param2.user_base.exp - param1.user_base.exp;
            if(_loc3_ == 0)
            {
               _loc3_ = param1.user_base.name.localeCompare(param2.user_base.name);
            }
         }
         return _loc3_;
      }
      
      public function assignClanData(param1:PClan) : void
      {
         var _loc4_:PCapitalLog = null;
         var _loc5_:* = 0;
         if(param1.workers_count < 1)
         {
            param1.workers_count = 1;
         }
         else
         {
            --param1.workers_count;
         }
         param1.members.sort(this.clanMemberSort);
         var _loc2_:Array = param1.capital_log;
         var _loc3_:* = int(_loc2_.length - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.cl_costs.length > 1)
            {
               _loc5_ = int(_loc4_.cl_costs.length - 1);
               while(_loc5_ >= 1)
               {
                  _loc2_.splice(_loc3_,0,PCapitalLog.create(_loc4_.cl_id,_loc4_.cl_time,_loc4_.cl_name,_loc4_.cl_role,_loc4_.cl_level,[_loc4_.cl_costs[_loc5_]],_loc4_.cl_kind,_loc4_.cl_snetwork));
                  _loc5_--;
               }
               _loc4_.cl_costs.length = 1;
            }
            _loc3_--;
         }
         this.clanData = param1;
         if(Boolean(param1.war) && param1.war.war_points >= Facade.references.wp_storm_req)
         {
            param1.war.war_points_lat = CoreLogic.serverTime;
         }
      }
      
      public function checkReadClanTime(param1:Boolean) : uint
      {
         var _loc2_:uint = 0;
         if(this.clanData)
         {
            if(Boolean(this.chatList) && Boolean(this.chatList.length > 0) && this.readClanTime < this.chatList[this.chatList.length - 1].m_time)
            {
               _loc2_ = 1;
            }
            if(this.clanData.requests.length > 0 && param1 && this.readClanTime < (this.clanData.requests[0] as PClanRequest).cr_time)
            {
               return _loc2_ | 2;
            }
            if(Boolean(this.energyRequestList) && Boolean(this.energyRequestList.length > 0) && this.readClanTime < (this.energyRequestList[0] as PCallRequest).cr_time)
            {
               return _loc2_ | 2;
            }
         }
         if(Boolean(this.alinkRequestList) && Boolean(this.alinkRequestList.length > 0) && this.readClanTime < (this.alinkRequestList[0] as PAsk).ask_time)
         {
            _loc2_ |= 2;
         }
         return _loc2_;
      }
      
      public function syncReadClanTime(param1:Boolean) : void
      {
         var _loc2_:Number = CoreLogic.serverTime;
         if(Boolean(this.alinkRequestList) && Boolean(this.alinkRequestList.length > 0) && (this.alinkRequestList[0] as PAsk).ask_time > _loc2_)
         {
            _loc2_ = (this.alinkRequestList[0] as PAsk).ask_time;
         }
         if(this.clanData)
         {
            if(Boolean(this.chatList) && Boolean(this.chatList.length > 0) && this.chatList[this.chatList.length - 1].m_time > _loc2_)
            {
               _loc2_ = this.chatList[this.chatList.length - 1].m_time;
            }
            if(Boolean(this.energyRequestList) && Boolean(this.energyRequestList.length > 0) && (this.energyRequestList[0] as PCallRequest).cr_time > _loc2_)
            {
               _loc2_ = (this.energyRequestList[0] as PCallRequest).cr_time;
            }
            if(this.clanData.requests.length > 0 && param1 && (this.clanData.requests[0] as PClanRequest).cr_time > _loc2_)
            {
               _loc2_ = (this.clanData.requests[0] as PClanRequest).cr_time;
            }
         }
         this.readClanTime = _loc2_;
      }
      
      public function updateAskRequest(param1:PAsk) : void
      {
         var _loc3_:PAsk = null;
         if(!this.alinkRequestList)
         {
            this.alinkRequestList = [];
         }
         var _loc2_:* = int(this.alinkRequestList.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this.alinkRequestList[_loc2_];
            if(_loc3_.ask_is_help == param1.ask_is_help && _loc3_.ask_user_id == param1.ask_user_id)
            {
               this.alinkRequestList.splice(_loc2_,1);
               break;
            }
            _loc2_--;
         }
         this.alinkRequestList.unshift(param1);
      }
      
      public function changeClanResource(param1:PCost, param2:Boolean, param3:uint, param4:String = null, param5:Object = null) : void
      {
         var _loc8_:PMember = null;
         var _loc9_:PUserBase = null;
         if(!this.clanData)
         {
            return;
         }
         var _loc6_:PBase = this.clanData.base;
         var _loc7_:int = param1.value;
         if(param2)
         {
            _loc7_ *= -1;
         }
         switch(param1.variance)
         {
            case PCost.CRYSTAL:
               _loc7_ = _loc6_.crystal = this.calcLimitResource(_loc6_.crystal,_loc7_ + _loc6_.crystal,param3 != PCapitalLogKind.UNKNOWN ? int(this.clanData.storage_max_crystal) : -1);
               break;
            case PCost.OIL:
               _loc7_ = _loc6_.oil = this.calcLimitResource(_loc6_.oil,_loc7_ + _loc6_.oil,param3 != PCapitalLogKind.UNKNOWN ? int(this.clanData.storage_max_oil) : -1);
               break;
            case PCost.MITHRIL:
               _loc7_ = _loc6_.mithril = _loc6_.mithril + _loc7_;
               break;
            case PCost.GOLD:
               _loc7_ = _loc6_.gold = _loc6_.gold + _loc7_;
               break;
            case PCost.TROPHY:
               _loc7_ = this.clanData.trophy = this.clanData.trophy + _loc7_;
               break;
            default:
               return;
         }
         if(param3 != PCapitalLogKind.UNKNOWN)
         {
            if(param4)
            {
               _loc8_ = this.getClanMember(param4);
            }
            else
            {
               for each(_loc8_ in this.clanData.members)
               {
                  if(_loc8_.role.variance == PRole.CREATOR)
                  {
                     break;
                  }
               }
            }
            if(_loc8_)
            {
               _loc9_ = _loc8_.user_base;
               this.clanData.capital_log.unshift(PCapitalLog.create(_loc9_.user_id,CoreLogic.serverTime,_loc9_.name,_loc8_.role,_loc9_.level,[param1],PCapitalLogKind.create(param3,param5),_loc9_.snetwork));
            }
         }
         Facade.dispatchCommonEvent(CommonEvent.CLAN_RESOURCE,_loc7_,param1.variance);
      }
      
      public function calcLimitResource(param1:int, param2:int, param3:int) : int
      {
         if(param3 >= 0)
         {
            if(param1 > param3)
            {
               param3 = param1;
            }
            return param2 > param3 ? param3 : param2;
         }
         return param2;
      }
      
      public function checkClanPrice(param1:Array) : PCost
      {
         var _loc2_:PCost = null;
         var _loc3_:int = 0;
         for each(_loc2_ in param1)
         {
            _loc3_ = this.checkClanCost(_loc2_);
            if(_loc3_ > 0)
            {
               return PCost.create(_loc2_.variance,_loc3_);
            }
         }
         return null;
      }
      
      public function applyClanPrice(param1:Array, param2:Boolean, param3:uint) : void
      {
         var _loc4_:PCost = null;
         for each(_loc4_ in param1)
         {
            this.changeClanResource(_loc4_,param2,param3);
         }
      }
      
      public function addBuyOfferItem(param1:*) : void
      {
         if(Facade.isMyMap)
         {
            if(!this.buyOfferList)
            {
               this.buyOfferList = [];
            }
            this.buyOfferList.push(param1);
         }
      }
      
      public function checkIncRatio(param1:uint) : uint
      {
         var _loc2_:uint = this.radarEnabled ? uint(Facade.manualProxy.getLevelInfo(this.base.level).l_max_ratio * 2) : Facade.manualProxy.getLevelInfo(this.base.level).l_max_ratio;
         if(this.base.ratio + param1 > _loc2_)
         {
            return this.base.ratio >= _loc2_ ? 0 : uint(_loc2_ - this.base.ratio);
         }
         return param1;
      }
      
      public function checkClanRolePermission(param1:uint) : Boolean
      {
         var _loc2_:PPermission = null;
         if(this.clan)
         {
            for each(_loc2_ in Facade.manualProxy.getClanRoleInfo(this.clan.uc_role.variance).scr_role_permissions)
            {
               if(_loc2_.variance == param1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function checkClanCost(param1:PCost) : int
      {
         var _loc2_:uint = param1.variance;
         if(_loc2_ == PCost.CRYSTAL)
         {
            return param1.value - this.clanData.base.crystal;
         }
         if(_loc2_ == PCost.OIL)
         {
            return param1.value - this.clanData.base.oil;
         }
         if(_loc2_ == PCost.TROPHY)
         {
            return param1.value - this.clanData.trophy;
         }
         if(_loc2_ == PCost.GOLD)
         {
            return param1.value - this.clanData.base.gold;
         }
         return 0;
      }
      
      public function syncClanResource(param1:PResources) : Boolean
      {
         var _loc2_:PBase = null;
         if(param1)
         {
            if(this.clanData)
            {
               _loc2_ = this.clanData.base;
               _loc2_.gold = param1.gold;
               _loc2_.crystal = param1.crystal;
               _loc2_.oil = param1.oil;
               this.clanData.trophy = param1.trophy;
            }
            return true;
         }
         return false;
      }
      
      public function getClanLeagueNum() : uint
      {
         if(this.clanData)
         {
            return this.clanData.base.division;
         }
         return 0;
      }
      
      public function getBossKind(param1:Boolean = false) : String
      {
         if(this.winMissionList.indexOf("ms_mission8") < 0)
         {
            return param1 ? "ms_mission8" : "un_boss_warrior";
         }
         if(this.winMissionList.indexOf("ms_mission19") < 0)
         {
            return param1 ? "ms_mission19" : "un_boss_troll";
         }
         return param1 ? "ms_mission27" : "un_boss_healer";
      }
      
      public function checkOffer(param1:String) : Boolean
      {
         return Boolean(this.offerHash) && this.offerHash.hasOwnProperty(param1);
      }
      
      public function getCustomData(param1:String) : String
      {
         var _loc2_:str_str = null;
         for each(_loc2_ in this.customData)
         {
            if(_loc2_.field_0 == param1)
            {
               return _loc2_.field_1;
            }
         }
         return "";
      }
      
      public function setCustomData(param1:String, param2:String) : void
      {
         var _loc5_:str_str = null;
         var _loc3_:str_str = str_str.create(param1,param2);
         var _loc4_:Boolean = false;
         for each(_loc5_ in this.customData)
         {
            if(_loc3_.field_0 == _loc5_.field_0)
            {
               _loc5_.field_1 = _loc3_.field_1;
               _loc4_ = true;
               break;
            }
         }
         if(!_loc4_)
         {
            this.customData.push(_loc3_);
         }
         ActionLogic.request(PUserAction.SET_CUSTOM_DATA,_loc3_);
      }
      
      public function getHeroLevel(param1:*) : uint
      {
         var _loc3_:uint = 0;
         var _loc2_:PHero = param1 is PHero ? param1 : this.getHeroSpec(param1);
         if(_loc2_)
         {
            _loc3_ = (_loc2_.stamina_mod_level + _loc2_.armor_mod_level + _loc2_.damage_mod_level + _loc2_.recover_mod_level) / 4;
            if(_loc3_ > 0)
            {
               return _loc3_;
            }
         }
         return 1;
      }
      
      public function getEnergyCooldown() : Number
      {
         return Math.ceil(Facade.references.call_repair_period * (this.base.scouting > CoreLogic.serverTime ? 0.5 : 1));
      }
      
      public function get radarEnabled() : Boolean
      {
         return this.base.scouting > CoreLogic.serverTime;
      }
      
      public function getAdventureLevel(param1:int) : int
      {
         var _loc2_:PAdventure = null;
         for each(_loc2_ in this.adventureList)
         {
            if(_loc2_.event_id == param1)
            {
               return _loc2_.level;
            }
         }
         return 1;
      }
      
      public function updateClanData() : void
      {
         if(this.clanData)
         {
            Facade.protoProxy.request(new Packet_0060_03(),this.resultClanData);
         }
      }
      
      private function resultClanData(param1:BinaryBuffer) : void
      {
         var _loc3_:BaseDialog = null;
         var _loc2_:PClan = new Packet_0060_02(param1).value;
         if(this.curSeason)
         {
            this.curSeason.clan_points = _loc2_.base.clan_points;
            this.curSeason.place = _loc2_.clan_comp_place_opt;
         }
         if(Boolean(this.clanData) && (this.clanData.clan_comp_place_opt != _loc2_.clan_comp_place_opt || this.clanData.base.clan_points != _loc2_.base.clan_points))
         {
            this.assignClanData(_loc2_);
            _loc3_ = Facade.mainMediator.searchDialog(ClanCenterDialog);
            if(_loc3_)
            {
               _loc3_.close();
               DialogLogic.openClanCenter(false);
            }
         }
         else if(this.clanData)
         {
            this.clanData.members = _loc2_.members;
         }
      }
      
      public function isActiveSub() : Boolean
      {
         var _loc1_:PShopSubscription = null;
         if(this.subs)
         {
            _loc1_ = Facade.manualProxy.getSubscription(this.subs.id);
            return CoreLogic.serverTime < this.subs.start_time + _loc1_.duration_days * 24 * 60 * 60;
         }
         return false;
      }
   }
}

