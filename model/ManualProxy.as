package model
{
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   import flash.utils.Dictionary;
   import proto.model.PAdventureReward;
   import proto.model.PBuildRequierement;
   import proto.model.PClanDivision;
   import proto.model.PClanReward;
   import proto.model.PClanRewardPerc;
   import proto.model.PClanTownhallDivision;
   import proto.model.PClanTownhallUnlock;
   import proto.model.PDict;
   import proto.model.PHero;
   import proto.model.PHeroUpgradeKind;
   import proto.model.PJainaEventInfo;
   import proto.model.PJainaMissionInfo;
   import proto.model.PLevelInfo;
   import proto.model.PMissionInfo;
   import proto.model.PPermission;
   import proto.model.PShopAchv;
   import proto.model.PShopBuilding;
   import proto.model.PShopCamp;
   import proto.model.PShopCannon;
   import proto.model.PShopClanRole;
   import proto.model.PShopClanhall;
   import proto.model.PShopDecor;
   import proto.model.PShopDivision;
   import proto.model.PShopFence;
   import proto.model.PShopGarbage;
   import proto.model.PShopGuard;
   import proto.model.PShopHero;
   import proto.model.PShopLibrary;
   import proto.model.PShopMine;
   import proto.model.PShopOffer;
   import proto.model.PShopPylon;
   import proto.model.PShopResource;
   import proto.model.PShopScouting;
   import proto.model.PShopShieldGen;
   import proto.model.PShopSpell;
   import proto.model.PShopStorage;
   import proto.model.PShopSubscription;
   import proto.model.PShopTerritory;
   import proto.model.PShopUnit;
   import proto.model.PShopUpgradeHero;
   import proto.model.PTownhallUnlock;
   import proto.model.PUnitsLevel;
   import proto.tuples.str_i;
   
   public class ManualProxy
   {
      
      public var buildShopList:Array;
      
      public var cannonShopList:Array;
      
      public var fenceShopList:Array;
      
      public var decorShopList:Array;
      
      public var garbageShopList:Array;
      
      public var campShopList:Array;
      
      public var soldierShopList:Array;
      
      public var soldierGoldShopList:Array;
      
      public var storageShopList:Array;
      
      public var resourceShopList:Array;
      
      public var pylonShopList:Array;
      
      public var levelList:Array;
      
      public var heroShopList:Array;
      
      public var guardShopList:Array;
      
      public var shieldPackList:Array;
      
      public var resourcePackList:Array;
      
      public var missionList:Array;
      
      public var heroUpdateShopList:Array;
      
      public var goldShopList:Array;
      
      public var clanRoleList:Array;
      
      public var newsList:Array;
      
      public var libraryShopList:Array;
      
      public var spellShopList:Array;
      
      public var townHallList:Array;
      
      public var townHallUnlockList:Vector.<Dictionary> = new Vector.<Dictionary>();
      
      public var raidShopList:Array;
      
      public var offerShopList:Array;
      
      public var shieldShopList:Array;
      
      public var mineShopList:Array;
      
      public var territoryShopList:Array;
      
      public var scoutingShopList:Array;
      
      public var scoutingInfo:PShopScouting;
      
      public var powerShopList:Array;
      
      public var energyShopList:Array;
      
      public var achievementHash:Object;
      
      public var leagueList:Array;
      
      public var clanLeagueList:Array;
      
      public var territoryDeny:Boolean;
      
      public var jainaMissionList:Array;
      
      public var jainaEventList:Array;
      
      public var adventureRewardList:Array;
      
      public var myLevelList:Array;
      
      public var myBuildShopList:Array;
      
      public var myCannonShopList:Array;
      
      public var myFenceShopList:Array;
      
      public var myDecorShopList:Array;
      
      public var myStorageShopList:Array;
      
      public var myResourceShopList:Array;
      
      public var myClanShopList:Array;
      
      public var myGarbageShopList:Array;
      
      public var myResourcePackList:Array;
      
      public var clanLevelList:Array;
      
      public var clanBuildShopList:Array;
      
      public var clanCannonShopList:Array;
      
      public var clanFenceShopList:Array;
      
      public var clanDecorShopList:Array;
      
      public var clanStorageShopList:Array;
      
      public var clanResourceShopList:Array;
      
      public var clanTownHallList:Array;
      
      public var clanClanShopList:Array;
      
      public var clanGarbageShopList:Array;
      
      public var clanResourcePackList:Array;
      
      public var clanEmblemShopList:Array;
      
      public var clanRewardPercInfo:Array;
      
      public var clanChestReward:Array;
      
      public var subscriptions:Array;
      
      public var clanTownhallDivisionInfo:Array;
      
      private var cookie:SharedObject;
      
      public function ManualProxy()
      {
         super();
         try
         {
            this.cookie = SharedObject.getLocal("redspell_steampunk","/");
            this.cookie.addEventListener(NetStatusEvent.NET_STATUS,this.onCookieStatus);
         }
         catch(error:Error)
         {
         }
      }
      
      private function onCookieStatus(param1:NetStatusEvent) : void
      {
      }
      
      public function setCookieData(param1:String, param2:*, param3:Boolean = true) : void
      {
         if(this.cookie)
         {
            this.cookie.data[param1] = param2;
            if(param3)
            {
               try
               {
                  this.cookie.flush();
               }
               catch(error:Error)
               {
               }
            }
         }
      }
      
      public function getCookieData(param1:String, param2:* = null) : *
      {
         return Boolean(this.cookie) && this.cookie.data.hasOwnProperty(param1) ? this.cookie.data[param1] : param2;
      }
      
      public function clearCookie() : void
      {
         if(this.cookie)
         {
            this.cookie.clear();
         }
      }
      
      public function assignDict(param1:PDict) : void
      {
         var _loc3_:PShopUnit = null;
         var _loc4_:PShopSpell = null;
         var _loc5_:PShopAchv = null;
         this.myLevelList = param1.levels;
         this.myBuildShopList = param1.building_info;
         this.myCannonShopList = param1.cannons_info;
         this.myFenceShopList = param1.fences_info;
         this.myDecorShopList = param1.decors_info;
         this.myGarbageShopList = param1.garbages_info;
         this.myStorageShopList = param1.storages_info;
         this.myResourceShopList = param1.resources_info;
         this.myClanShopList = param1.clanhalls_info;
         this.myResourcePackList = param1.resources_packs_info;
         this.clanLevelList = param1.clan_levels;
         this.clanBuildShopList = param1.clan_building_info;
         this.clanCannonShopList = param1.clan_cannons_info;
         this.clanFenceShopList = param1.clan_fences_info;
         this.clanDecorShopList = param1.clan_decors_info;
         this.clanGarbageShopList = param1.clan_garbages_info;
         this.clanResourceShopList = param1.clan_resources_info;
         this.clanStorageShopList = param1.clan_storages_info;
         this.clanTownHallList = param1.clan_townhall_unlocks;
         this.clanClanShopList = param1.clan_clanhalls_info;
         this.clanResourcePackList = param1.clan_resources_packs_info;
         this.clanEmblemShopList = param1.clan_icons_info;
         this.campShopList = param1.camps_info;
         this.soldierShopList = param1.units_info;
         this.soldierGoldShopList = param1.units_packs_info;
         var _loc2_:uint = 1000;
         for each(_loc3_ in this.soldierShopList)
         {
            _loc3_.order = _loc3_.su_is_hero ? uint(_loc2_ - 1000) : _loc2_;
            _loc2_++;
         }
         this.pylonShopList = param1.pylons_info;
         this.heroShopList = param1.heroes_info;
         this.heroUpdateShopList = param1.hero_upgrades;
         this.guardShopList = param1.guards_info;
         this.shieldPackList = param1.shields_info;
         this.missionList = param1.missions_info;
         this.goldShopList = param1.gold_price_info;
         this.clanRoleList = param1.clan_roles_info;
         this.newsList = param1.news;
         this.libraryShopList = param1.libraries_info;
         this.spellShopList = param1.spells_info;
         for each(_loc4_ in this.spellShopList)
         {
            _loc4_.order = _loc2_;
            _loc2_++;
         }
         this.raidShopList = param1.raid_cooldowns_info;
         this.townHallList = param1.townhall_unlocks;
         this.offerShopList = param1.offers_info;
         this.shieldShopList = param1.shield_gens_info;
         this.mineShopList = param1.mines_info;
         this.territoryShopList = param1.territories_info;
         this.scoutingInfo = param1.scoutings[0];
         this.scoutingShopList = param1.scouting_packs;
         this.powerShopList = param1.power_points_info;
         this.energyShopList = param1.calls_info;
         this.achievementHash = {};
         for each(_loc5_ in param1.achievements)
         {
            this.achievementHash[_loc5_.achv_kind + _loc5_.achv_level] = _loc5_.achv_points;
         }
         this.leagueList = param1.divisions;
         this.clanLeagueList = param1.clan_divisions;
         this.territoryDeny = param1.territory_deny;
         this.jainaMissionList = param1.jaina_missions_info;
         this.jainaEventList = param1.jaina_events_info;
         this.adventureRewardList = param1.adventure_rewards;
         this.clanRewardPercInfo = param1.clan_reward_perc_info;
         this.clanChestReward = param1.clan_rewards;
         this.subscriptions = param1.subscriptions;
         this.clanTownhallDivisionInfo = param1.clan_townhall_division_info;
         this.useMyMode();
      }
      
      public function clear() : void
      {
         if(Boolean(this.buildShopList) && this.buildShopList == this.clanBuildShopList)
         {
            this.useMyMode();
         }
      }
      
      public function useClanMode() : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:PClanTownhallUnlock = null;
         var _loc4_:str_i = null;
         Facade.userProxy.townHallLevel = 0;
         this.buildShopList = this.clanBuildShopList;
         this.cannonShopList = this.clanCannonShopList;
         this.fenceShopList = this.clanFenceShopList;
         this.decorShopList = this.clanDecorShopList;
         this.resourceShopList = this.clanResourceShopList;
         this.storageShopList = this.clanStorageShopList;
         this.garbageShopList = this.clanGarbageShopList;
         this.resourcePackList = this.clanResourcePackList;
         this.levelList = this.clanLevelList;
         this.townHallUnlockList.length = 0;
         var _loc1_:* = int(this.clanTownHallList.length);
         while(_loc1_ >= 1)
         {
            _loc2_ = new Dictionary();
            this.townHallUnlockList.unshift(_loc2_);
            for each(_loc3_ in this.clanTownHallList)
            {
               if(_loc3_.ctu_level == _loc1_)
               {
                  for each(_loc4_ in _loc3_.ctu_unlocks)
                  {
                     _loc2_[_loc4_.field_0] = _loc4_.field_1;
                  }
                  break;
               }
            }
            _loc1_--;
         }
      }
      
      public function useMyMode() : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:PTownhallUnlock = null;
         var _loc4_:str_i = null;
         Facade.userProxy.townHallLevel = 0;
         this.buildShopList = this.myBuildShopList;
         this.cannonShopList = this.myCannonShopList;
         this.fenceShopList = this.myFenceShopList;
         this.decorShopList = this.myDecorShopList;
         this.resourceShopList = this.myResourceShopList;
         this.storageShopList = this.myStorageShopList;
         this.garbageShopList = this.myGarbageShopList;
         this.resourcePackList = this.myResourcePackList;
         this.levelList = this.myLevelList;
         this.townHallUnlockList.length = 0;
         var _loc1_:* = int(this.townHallList.length);
         while(_loc1_ >= 1)
         {
            _loc2_ = new Dictionary();
            this.townHallUnlockList.unshift(_loc2_);
            for each(_loc3_ in this.townHallList)
            {
               if(_loc3_.tu_level == _loc1_)
               {
                  for each(_loc4_ in _loc3_.tu_unlocks)
                  {
                     _loc2_[_loc4_.field_0] = _loc4_.field_1;
                  }
                  break;
               }
            }
            _loc1_--;
         }
      }
      
      public function getBuildShop(param1:String, param2:uint, param3:Boolean = false) : PShopBuilding
      {
         var _loc4_:PShopBuilding = null;
         for each(_loc4_ in this.buildShopList)
         {
            if(_loc4_.sb_level == param2 && _loc4_.sb_kind == param1)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad getBuildShop " + param1 + "," + param2);
         }
         return null;
      }
      
      public function getCannonShop(param1:String, param2:uint, param3:Boolean = false) : PShopCannon
      {
         var _loc4_:PShopCannon = null;
         for each(_loc4_ in this.cannonShopList)
         {
            if(_loc4_.sc_level == param2 && _loc4_.sc_kind == param1)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad getCannonShop " + param1 + "," + param2);
         }
         return null;
      }
      
      public function getFenceShop(param1:String, param2:uint, param3:Boolean = false) : PShopFence
      {
         var _loc4_:PShopFence = null;
         for each(_loc4_ in this.fenceShopList)
         {
            if(_loc4_.sf_level == param2 && _loc4_.sf_kind == param1)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad getFenceShop " + param1 + "," + param2);
         }
         return null;
      }
      
      public function getCampShop(param1:uint, param2:Boolean = false) : PShopCamp
      {
         var _loc3_:PShopCamp = null;
         for each(_loc3_ in this.campShopList)
         {
            if(_loc3_.sca_level == param1)
            {
               return _loc3_;
            }
         }
         if(!param2)
         {
            throw new Error("bad getCampShop " + param1);
         }
         return null;
      }
      
      public function getSoldierShop(param1:String, param2:uint = 0, param3:Boolean = false) : PShopUnit
      {
         var _loc4_:PShopUnit = null;
         if(param2 == 0)
         {
            param2 = uint(Facade.userProxy.soldierLevelHash[param1]);
            if(param2 == 0)
            {
               param2 = 1;
            }
         }
         for each(_loc4_ in this.soldierShopList)
         {
            if(_loc4_.su_level == param2 && _loc4_.su_kind == param1)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad shopInfo " + param1 + "," + param2);
         }
         return null;
      }
      
      public function getStorageShop(param1:String, param2:uint, param3:Boolean = false) : PShopStorage
      {
         var _loc4_:PShopStorage = null;
         for each(_loc4_ in this.storageShopList)
         {
            if(_loc4_.ss_level == param2 && _loc4_.ss_kind == param1)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad shopInfo " + param1 + "," + param2);
         }
         return null;
      }
      
      public function getResourceShop(param1:String, param2:uint, param3:Boolean = false) : PShopResource
      {
         var _loc4_:PShopResource = null;
         for each(_loc4_ in this.resourceShopList)
         {
            if(_loc4_.sr_level == param2 && _loc4_.sr_kind == param1)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad getResourceShop " + param1 + "," + param2);
         }
         return null;
      }
      
      public function getPylonShop(param1:String, param2:uint, param3:Boolean = false) : PShopPylon
      {
         var _loc4_:PShopPylon = null;
         for each(_loc4_ in this.pylonShopList)
         {
            if(_loc4_.sp_level == param2 && _loc4_.sp_kind == param1)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad getPylonShop " + param1 + "," + param2);
         }
         return null;
      }
      
      public function getDecorShop(param1:String, param2:Boolean = false) : PShopDecor
      {
         var _loc3_:PShopDecor = null;
         for each(_loc3_ in this.decorShopList)
         {
            if(_loc3_.sd_kind == param1)
            {
               return _loc3_;
            }
         }
         if(!param2)
         {
            throw new Error("bad getDecorShop " + param1);
         }
         return null;
      }
      
      public function getGarbageShop(param1:String, param2:Boolean = false) : PShopGarbage
      {
         var _loc3_:PShopGarbage = null;
         for each(_loc3_ in this.garbageShopList)
         {
            if(_loc3_.sg_kind == param1)
            {
               return _loc3_;
            }
         }
         if(!param2)
         {
            throw new Error("bad getGarbageShop " + param1);
         }
         return null;
      }
      
      public function getHeroShop(param1:String, param2:uint, param3:Boolean = false, param4:Boolean = false) : PShopHero
      {
         var _loc5_:PShopHero = null;
         for each(_loc5_ in this.heroShopList)
         {
            if(_loc5_.sh_level == param2)
            {
               if(param4)
               {
                  if(_loc5_.sh_kind == param1)
                  {
                     return _loc5_;
                  }
               }
               else if(_loc5_.sh_unit_kind == param1)
               {
                  return _loc5_;
               }
            }
         }
         if(!param3)
         {
            throw new Error("bad getHeroShop " + param1 + "," + param2);
         }
         return null;
      }
      
      public function getGuardShop(param1:String, param2:uint, param3:Boolean = false) : PShopGuard
      {
         var _loc4_:PShopGuard = null;
         for each(_loc4_ in this.guardShopList)
         {
            if(_loc4_.sga_level == param2 && _loc4_.sga_kind == param1)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad shopInfo " + param1 + "," + param2);
         }
         return null;
      }
      
      public function getLevelInfo(param1:uint = 0, param2:Boolean = false) : PLevelInfo
      {
         if(param1 == 0)
         {
            param1 = Facade.userProxy.level;
         }
         param1--;
         if(param1 < this.levelList.length)
         {
            return this.levelList[param1];
         }
         if(!param2)
         {
            throw new Error("bad levelInfo " + param1);
         }
         return null;
      }
      
      public function getMissionInfo(param1:String, param2:Boolean = false) : PMissionInfo
      {
         var _loc3_:PMissionInfo = null;
         for each(_loc3_ in this.missionList)
         {
            if(_loc3_.mi_kind == param1)
            {
               return _loc3_;
            }
         }
         if(!param2)
         {
            throw new Error("bad missionInfo " + param1);
         }
         return null;
      }
      
      public function getExp(param1:uint) : uint
      {
         var _loc2_:PLevelInfo = this.getLevelInfo(param1,true);
         return _loc2_ ? _loc2_.l_require : uint.MAX_VALUE;
      }
      
      public function calcExp(param1:uint) : uint
      {
         return Math.floor(Math.sqrt(param1));
      }
      
      public function getHeroUpdateShop(param1:String, param2:uint, param3:uint, param4:Boolean = false) : PShopUpgradeHero
      {
         var _loc5_:PShopUpgradeHero = null;
         for each(_loc5_ in this.heroUpdateShopList)
         {
            if(param2 == _loc5_.shu_level && _loc5_.shu_kind.variance == param3 && _loc5_.shu_hero_kind == param1)
            {
               return _loc5_;
            }
         }
         if(!param4)
         {
            throw new Error("bad getHeroUpdate " + param1 + " lvl=" + param2 + " variance=" + param3);
         }
         return null;
      }
      
      public function getHeroStat(param1:PShopUnit, param2:uint, param3:PHero) : uint
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(param2 == PHeroUpgradeKind.STAMINA)
         {
            _loc4_ = param1.su_stamina;
            _loc5_ = param3.stamina_mod_level;
         }
         else if(param2 == PHeroUpgradeKind.DAMAGE)
         {
            _loc4_ = param1.su_damage;
            _loc5_ = param3.damage_mod_level;
         }
         else
         {
            if(param2 != PHeroUpgradeKind.ARMOR)
            {
               throw new Error("getHeroStat dont support " + param2);
            }
            _loc4_ = param1.su_armor;
            _loc5_ = param3.armor_mod_level;
         }
         if(_loc5_ > 0)
         {
            return _loc4_ + this.getHeroUpdateShop(param1.su_kind,_loc5_,param2).shu_effect;
         }
         return _loc4_;
      }
      
      public function getClanRoleInfo(param1:uint, param2:Boolean = true, param3:Boolean = false) : PShopClanRole
      {
         var _loc4_:PShopClanRole = null;
         for each(_loc4_ in this.clanRoleList)
         {
            if(param2)
            {
               if(_loc4_.scr_role_kind.variance == param1)
               {
                  return _loc4_;
               }
            }
            else if(_loc4_.scr_role_priority == param1)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad clanRole " + param1 + ", isRoleOrPriority=" + param2);
         }
         return null;
      }
      
      public function getRolePermission(param1:PShopClanRole) : uint
      {
         var _loc3_:PPermission = null;
         var _loc2_:uint = 0;
         for each(_loc3_ in param1.scr_role_permissions)
         {
            _loc2_ |= 1 << _loc3_.variance;
         }
         return _loc2_;
      }
      
      public function getClanCapacity(param1:uint, param2:Boolean = false) : uint
      {
         var _loc3_:PShopClanhall = null;
         for each(_loc3_ in param2 ? this.myClanShopList : this.clanClanShopList)
         {
            if(param1 == _loc3_.scl_level)
            {
               return _loc3_.scl_capacity;
            }
         }
         return 0;
      }
      
      public function getSpellShop(param1:String, param2:uint = 0, param3:Boolean = false) : PShopSpell
      {
         var _loc4_:PShopSpell = null;
         if(param2 == 0)
         {
            param2 = uint(Facade.userProxy.soldierLevelHash[param1]);
            if(param2 == 0)
            {
               param2 = 1;
            }
         }
         for each(_loc4_ in this.spellShopList)
         {
            if(param2 == _loc4_.ssp_level && param1 == _loc4_.ssp_kind)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad getSpellShop " + param1 + " lvl=" + param2);
         }
         return null;
      }
      
      public function getLibraryShop(param1:uint, param2:Boolean = false) : PShopLibrary
      {
         var _loc3_:PShopLibrary = null;
         for each(_loc3_ in this.libraryShopList)
         {
            if(param1 == _loc3_.sl_level)
            {
               return _loc3_;
            }
         }
         if(!param2)
         {
            throw new Error("bad getLibraryShop lvl=" + param1);
         }
         return null;
      }
      
      public function convertSpellShop(param1:PShopSpell) : PShopUnit
      {
         var _loc2_:PShopUnit = new PShopUnit();
         _loc2_.su_kind = param1.ssp_kind;
         _loc2_.su_level = param1.ssp_level;
         _loc2_.su_can_buy = param1.ssp_can_buy;
         _loc2_.su_upgrade_time = param1.ssp_upgrade_time;
         _loc2_.su_upgrade_requirement = param1.ssp_upgrade_requirement;
         _loc2_.su_upgrade_price = [param1.ssp_upgrade_price];
         _loc2_.order = param1.order;
         _loc2_.su_model_level = 1;
         return _loc2_;
      }
      
      public function getResearchSoldierShop(param1:String, param2:Boolean = false) : PShopUnit
      {
         var _loc3_:uint = Facade.userProxy.soldierLevelHash[param1] + 1;
         if(param1.indexOf("sp_") == 0)
         {
            return this.convertSpellShop(this.getSpellShop(param1,_loc3_,param2));
         }
         return this.getSoldierShop(param1,_loc3_,param2);
      }
      
      public function getTownHallUnlock(param1:uint = 0, param2:Boolean = false) : PTownhallUnlock
      {
         var _loc3_:PTownhallUnlock = null;
         if(param1 == 0)
         {
            param1 = Facade.userProxy.townHallLevel;
            if(param1 == 0)
            {
               param1 = 1;
            }
         }
         for each(_loc3_ in this.townHallList)
         {
            if(_loc3_.tu_level == param1)
            {
               return _loc3_;
            }
         }
         if(!param2)
         {
            throw new Error("bad getTownHallUnlock lvl=" + param1);
         }
         return null;
      }
      
      public function getClanTownHallUnlock(param1:uint, param2:Boolean = false) : PClanTownhallUnlock
      {
         var _loc3_:PClanTownhallUnlock = null;
         for each(_loc3_ in this.clanTownHallList)
         {
            if(_loc3_.ctu_level == param1)
            {
               return _loc3_;
            }
         }
         if(!param2)
         {
            throw new Error("bad getClanTownHallUnlock lvl=" + param1);
         }
         return null;
      }
      
      public function getOfferShop(param1:String) : PShopOffer
      {
         var _loc2_:PShopOffer = null;
         for each(_loc2_ in this.offerShopList)
         {
            if(_loc2_.offer_kind == param1)
            {
               return _loc2_;
            }
         }
         throw new Error("bad getOfferShop kind=" + param1);
      }
      
      public function getShieldShop(param1:String, param2:uint, param3:Boolean = false) : PShopShieldGen
      {
         var _loc4_:PShopShieldGen = null;
         for each(_loc4_ in this.shieldShopList)
         {
            if(_loc4_.ssg_level == param2 && _loc4_.ssg_kind == param1)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad getShieldShop kind=" + param1 + " lvl=" + param2);
         }
         return null;
      }
      
      public function getCannonMax(param1:String, param2:uint = 1) : uint
      {
         var _loc3_:PShopCannon = null;
         for each(_loc3_ in this.cannonShopList)
         {
            if(_loc3_.sc_level > param2 && _loc3_.sc_can_buy && _loc3_.sc_kind == param1)
            {
               param2 = _loc3_.sc_level;
            }
         }
         return param2;
      }
      
      public function getBuildMax(param1:String, param2:uint = 1) : uint
      {
         var _loc3_:PShopBuilding = null;
         for each(_loc3_ in this.buildShopList)
         {
            if(_loc3_.sb_level > param2 && _loc3_.sb_can_buy && _loc3_.sb_kind == param1)
            {
               param2 = _loc3_.sb_level;
            }
         }
         return param2;
      }
      
      public function getMineShop(param1:String, param2:uint, param3:Boolean = false) : PShopMine
      {
         var _loc4_:PShopMine = null;
         for each(_loc4_ in this.mineShopList)
         {
            if(_loc4_.mine_level == param2 && _loc4_.mine_region == param1)
            {
               return _loc4_;
            }
         }
         if(!param3)
         {
            throw new Error("bad getMineShop lvl=" + param2);
         }
         return null;
      }
      
      public function getTerritoryShop(param1:String, param2:Boolean = false) : PShopTerritory
      {
         var _loc3_:PShopTerritory = null;
         for each(_loc3_ in this.territoryShopList)
         {
            if(_loc3_.ter_kind == param1)
            {
               return _loc3_;
            }
         }
         if(!param2)
         {
            throw new Error("bad getTerritoryShop kind=" + param1);
         }
         return null;
      }
      
      public function getClanDivision(param1:String) : PClanDivision
      {
         var _loc2_:PClanDivision = null;
         for each(_loc2_ in this.clanLeagueList)
         {
            if(_loc2_.cd_region == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getLeagueShop(param1:int, param2:Boolean = true, param3:Boolean = false) : PShopDivision
      {
         var _loc4_:PShopDivision = null;
         for each(_loc4_ in this.leagueList)
         {
            if(param2)
            {
               if(param1 <= _loc4_.division_level)
               {
                  return _loc4_;
               }
            }
            else if(param1 == _loc4_.division_num)
            {
               return _loc4_;
            }
         }
         return param3 ? null : this.leagueList[this.leagueList.length - 1];
      }
      
      public function getClanLeagueByNum(param1:uint, param2:Boolean = false) : PClanDivision
      {
         if(param1 > 0)
         {
            param1--;
         }
         if(param1 < this.clanLeagueList.length)
         {
            return this.clanLeagueList[param1];
         }
         return param2 ? null : this.clanLeagueList[this.clanLeagueList.length - 1];
      }
      
      public function getDivisionByLevel(param1:int) : PClanTownhallDivision
      {
         var _loc2_:PClanTownhallDivision = null;
         for each(_loc2_ in this.clanTownhallDivisionInfo)
         {
            if(_loc2_.townhall == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getUnitLevel(param1:Array, param2:String, param3:uint = 1) : uint
      {
         var _loc4_:PUnitsLevel = null;
         if(param2 == "un_hero" || param2 == "un_hero_jaina")
         {
            return Facade.userProxy.getHeroLevel(param2);
         }
         for each(_loc4_ in param1)
         {
            if(_loc4_.ul_kind == param2)
            {
               return _loc4_.ul_level;
            }
         }
         return param3;
      }
      
      public function getJainaEventInfo(param1:int) : PJainaEventInfo
      {
         var _loc2_:PJainaEventInfo = null;
         for each(_loc2_ in this.jainaEventList)
         {
            if(_loc2_.jei_id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getJainaBuild(param1:String) : PShopBuilding
      {
         var _loc2_:PShopBuilding = null;
         var _loc3_:PBuildRequierement = null;
         for each(_loc2_ in this.buildShopList)
         {
            if(_loc2_.sb_requirements.length > 0)
            {
               for each(_loc3_ in _loc2_.sb_requirements)
               {
                  if(_loc3_.variance == PBuildRequierement.JAINA_MISSION && _loc3_.value == param1)
                  {
                     return _loc2_;
                  }
               }
            }
         }
         return null;
      }
      
      public function getJainaUnit(param1:String) : PShopUnit
      {
         var _loc2_:PShopUnit = null;
         var _loc3_:PBuildRequierement = null;
         for each(_loc2_ in this.soldierShopList)
         {
            _loc3_ = _loc2_.su_event_requirement;
            if(Boolean(_loc3_) && Boolean(_loc3_.variance == PBuildRequierement.JAINA_MISSION) && _loc3_.value == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getMissionInfoFromJaina(param1:int, param2:int) : PMissionInfo
      {
         var _loc3_:PJainaMissionInfo = null;
         for each(_loc3_ in this.jainaMissionList)
         {
            if(_loc3_.jmi_event_id == param1 && _loc3_.jmi_number == param2)
            {
               return this.getMissionInfo(_loc3_.jmi_mission);
            }
         }
         return null;
      }
      
      public function getAdventureReward(param1:String, param2:int) : Array
      {
         var _loc5_:PAdventureReward = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         for each(_loc5_ in this.adventureRewardList)
         {
            if(_loc5_.kind == param1)
            {
               if(_loc5_.level == param2)
               {
                  return _loc5_.prize;
               }
               if(_loc5_.level < param2 && _loc5_.level > _loc3_)
               {
                  _loc3_ = _loc5_.level;
                  _loc4_ = _loc5_.prize;
               }
            }
         }
         return _loc4_;
      }
      
      public function getRewardPercInfo(param1:int) : PClanRewardPerc
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.clanRewardPercInfo.length - 1)
         {
            if(this.clanRewardPercInfo[_loc2_].place <= param1 && param1 < this.clanRewardPercInfo[_loc2_ + 1].place)
            {
               return this.clanRewardPercInfo[_loc2_];
            }
            _loc2_++;
         }
         return this.clanRewardPercInfo[this.clanRewardPercInfo.length - 1];
      }
      
      public function getClanReward(param1:int) : PClanReward
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.clanChestReward.length - 1)
         {
            if(this.clanChestReward[_loc2_].place <= param1 && param1 < this.clanChestReward[_loc2_ + 1].place)
            {
               return this.clanChestReward[_loc2_];
            }
            _loc2_++;
         }
         return this.clanChestReward[this.clanChestReward.length - 1];
      }
      
      public function getClanRewardIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.clanChestReward.length - 1)
         {
            if(this.clanChestReward[_loc2_].place <= param1 && param1 < this.clanChestReward[_loc2_ + 1].place)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return this.clanChestReward.length - 1;
      }
      
      public function getSubscription(param1:int) : PShopSubscription
      {
         var _loc2_:PShopSubscription = null;
         for each(_loc2_ in this.subscriptions)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

