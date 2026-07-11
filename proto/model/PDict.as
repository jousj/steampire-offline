package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PDict implements IClientPacket
   {
      
      public var levels:Array;
      
      public var building_info:Array;
      
      public var cannons_info:Array;
      
      public var fences_info:Array;
      
      public var units_info:Array;
      
      public var townhall_unlocks:Array;
      
      public var camps_info:Array;
      
      public var resources_info:Array;
      
      public var storages_info:Array;
      
      public var pylons_info:Array;
      
      public var references:PReferences;
      
      public var decors_info:Array;
      
      public var garbages_info:Array;
      
      public var townhall_diffs:Array;
      
      public var heroes_info:Array;
      
      public var quests:Object;
      
      public var guards_info:Array;
      
      public var stages:Array;
      
      public var shields_info:Array;
      
      public var resources_packs_info:Array;
      
      public var missions_info:Array;
      
      public var hero_upgrades:Array;
      
      public var gold_price_info:Array;
      
      public var news:Array;
      
      public var clan_roles_info:Array;
      
      public var clan_icons:Array;
      
      public var clanhalls_info:Array;
      
      public var libraries_info:Array;
      
      public var spells_info:Array;
      
      public var raid_cooldowns_info:Array;
      
      public var clan_townhall_unlocks:Array;
      
      public var clan_building_info:Array;
      
      public var clan_cannons_info:Array;
      
      public var clan_fences_info:Array;
      
      public var clan_decors_info:Array;
      
      public var clan_resources_info:Array;
      
      public var clan_storages_info:Array;
      
      public var offers_info:Array;
      
      public var clan_clanhalls_info:Array;
      
      public var clan_garbages_info:Array;
      
      public var clan_levels:Array;
      
      public var territories_info:Array;
      
      public var shield_gens_info:Array;
      
      public var clan_resources_packs_info:Array;
      
      public var mines_info:Array;
      
      public var scoutings:Array;
      
      public var scouting_packs:Array;
      
      public var achievements:Array;
      
      public var allowed_version:String;
      
      public var divisions:Array;
      
      public var territory_deny:Boolean;
      
      public var clan_divisions:Array;
      
      public var clan_icons_info:Array;
      
      public var power_points_info:Array;
      
      public var calls_info:Array;
      
      public var bosses_info:Array;
      
      public var units_packs_info:Array;
      
      public var jaina_events_info:Array;
      
      public var jaina_missions_info:Array;
      
      public var adventure_rewards:Array;
      
      public var clan_reward_perc_info:Array;
      
      public var clan_rewards:Array;
      
      public var clan_townhall_division_info:Array;
      
      public var subscriptions:Array;
      
      public function PDict()
      {
         super();
      }
      
      public static function create(param1:Array, param2:Array, param3:Array, param4:Array, param5:Array, param6:Array, param7:Array, param8:Array, param9:Array, param10:Array, param11:PReferences, param12:Array, param13:Array, param14:Array, param15:Array, param16:Object, param17:Array, param18:Array, param19:Array, param20:Array, param21:Array, param22:Array, param23:Array, param24:Array, param25:Array, param26:Array, param27:Array, param28:Array, param29:Array, param30:Array, param31:Array, param32:Array, param33:Array, param34:Array, param35:Array, param36:Array, param37:Array, param38:Array, param39:Array, param40:Array, param41:Array, param42:Array, param43:Array, param44:Array, param45:Array, param46:Array, param47:Array, param48:Array, param49:String, param50:Array, param51:Boolean, param52:Array, param53:Array, param54:Array, param55:Array, param56:Array, param57:Array, param58:Array, param59:Array, param60:Array, param61:Array, param62:Array, param63:Array, param64:Array) : PDict
      {
         var _loc65_:PDict = new PDict();
         _loc65_.levels = param1;
         _loc65_.building_info = param2;
         _loc65_.cannons_info = param3;
         _loc65_.fences_info = param4;
         _loc65_.units_info = param5;
         _loc65_.townhall_unlocks = param6;
         _loc65_.camps_info = param7;
         _loc65_.resources_info = param8;
         _loc65_.storages_info = param9;
         _loc65_.pylons_info = param10;
         _loc65_.references = param11;
         _loc65_.decors_info = param12;
         _loc65_.garbages_info = param13;
         _loc65_.townhall_diffs = param14;
         _loc65_.heroes_info = param15;
         _loc65_.quests = param16;
         _loc65_.guards_info = param17;
         _loc65_.stages = param18;
         _loc65_.shields_info = param19;
         _loc65_.resources_packs_info = param20;
         _loc65_.missions_info = param21;
         _loc65_.hero_upgrades = param22;
         _loc65_.gold_price_info = param23;
         _loc65_.news = param24;
         _loc65_.clan_roles_info = param25;
         _loc65_.clan_icons = param26;
         _loc65_.clanhalls_info = param27;
         _loc65_.libraries_info = param28;
         _loc65_.spells_info = param29;
         _loc65_.raid_cooldowns_info = param30;
         _loc65_.clan_townhall_unlocks = param31;
         _loc65_.clan_building_info = param32;
         _loc65_.clan_cannons_info = param33;
         _loc65_.clan_fences_info = param34;
         _loc65_.clan_decors_info = param35;
         _loc65_.clan_resources_info = param36;
         _loc65_.clan_storages_info = param37;
         _loc65_.offers_info = param38;
         _loc65_.clan_clanhalls_info = param39;
         _loc65_.clan_garbages_info = param40;
         _loc65_.clan_levels = param41;
         _loc65_.territories_info = param42;
         _loc65_.shield_gens_info = param43;
         _loc65_.clan_resources_packs_info = param44;
         _loc65_.mines_info = param45;
         _loc65_.scoutings = param46;
         _loc65_.scouting_packs = param47;
         _loc65_.achievements = param48;
         _loc65_.allowed_version = param49;
         _loc65_.divisions = param50;
         _loc65_.territory_deny = param51;
         _loc65_.clan_divisions = param52;
         _loc65_.clan_icons_info = param53;
         _loc65_.power_points_info = param54;
         _loc65_.calls_info = param55;
         _loc65_.bosses_info = param56;
         _loc65_.units_packs_info = param57;
         _loc65_.jaina_events_info = param58;
         _loc65_.jaina_missions_info = param59;
         _loc65_.adventure_rewards = param60;
         _loc65_.clan_reward_perc_info = param61;
         _loc65_.clan_rewards = param62;
         _loc65_.clan_townhall_division_info = param63;
         _loc65_.subscriptions = param64;
         return _loc65_;
      }
      
      public static function read(param1:IDataInput) : PDict
      {
         var _loc3_:* = 0;
         var _loc4_:Object = null;
         var _loc2_:PDict = new PDict();
         _loc2_.levels = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.levels.length)
         {
            _loc2_.levels[_loc3_] = _loc4_ = PLevelInfo.read(param1);
            _loc3_++;
         }
         _loc2_.building_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.building_info.length)
         {
            _loc2_.building_info[_loc3_] = _loc4_ = PShopBuilding.read(param1);
            _loc3_++;
         }
         _loc2_.cannons_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.cannons_info.length)
         {
            _loc2_.cannons_info[_loc3_] = _loc4_ = PShopCannon.read(param1);
            _loc3_++;
         }
         _loc2_.fences_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.fences_info.length)
         {
            _loc2_.fences_info[_loc3_] = _loc4_ = PShopFence.read(param1);
            _loc3_++;
         }
         _loc2_.units_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.units_info.length)
         {
            _loc2_.units_info[_loc3_] = _loc4_ = PShopUnit.read(param1);
            _loc3_++;
         }
         _loc2_.townhall_unlocks = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.townhall_unlocks.length)
         {
            _loc2_.townhall_unlocks[_loc3_] = _loc4_ = PTownhallUnlock.read(param1);
            _loc3_++;
         }
         _loc2_.camps_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.camps_info.length)
         {
            _loc2_.camps_info[_loc3_] = _loc4_ = PShopCamp.read(param1);
            _loc3_++;
         }
         _loc2_.resources_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.resources_info.length)
         {
            _loc2_.resources_info[_loc3_] = _loc4_ = PShopResource.read(param1);
            _loc3_++;
         }
         _loc2_.storages_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.storages_info.length)
         {
            _loc2_.storages_info[_loc3_] = _loc4_ = PShopStorage.read(param1);
            _loc3_++;
         }
         _loc2_.pylons_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.pylons_info.length)
         {
            _loc2_.pylons_info[_loc3_] = _loc4_ = PShopPylon.read(param1);
            _loc3_++;
         }
         _loc2_.references = PReferences.read(param1);
         _loc2_.decors_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.decors_info.length)
         {
            _loc2_.decors_info[_loc3_] = _loc4_ = PShopDecor.read(param1);
            _loc3_++;
         }
         _loc2_.garbages_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.garbages_info.length)
         {
            _loc2_.garbages_info[_loc3_] = _loc4_ = PShopGarbage.read(param1);
            _loc3_++;
         }
         _loc2_.townhall_diffs = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.townhall_diffs.length)
         {
            _loc2_.townhall_diffs[_loc3_] = _loc4_ = PTownhallDiff.read(param1);
            _loc3_++;
         }
         _loc2_.heroes_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.heroes_info.length)
         {
            _loc2_.heroes_info[_loc3_] = _loc4_ = PShopHero.read(param1);
            _loc3_++;
         }
         _loc2_.quests = new Object();
         _loc3_ = int(param1.readUnsignedShort());
         while(_loc3_ > 0)
         {
            _loc2_.quests[param1.readUTF()] = _loc4_ = PQuestInfo.read(param1);
            _loc3_--;
         }
         _loc2_.guards_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.guards_info.length)
         {
            _loc2_.guards_info[_loc3_] = _loc4_ = PShopGuard.read(param1);
            _loc3_++;
         }
         _loc2_.stages = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.stages.length)
         {
            _loc2_.stages[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.shields_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.shields_info.length)
         {
            _loc2_.shields_info[_loc3_] = _loc4_ = PShopShield.read(param1);
            _loc3_++;
         }
         _loc2_.resources_packs_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.resources_packs_info.length)
         {
            _loc2_.resources_packs_info[_loc3_] = _loc4_ = PShopResourcesPack.read(param1);
            _loc3_++;
         }
         _loc2_.missions_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.missions_info.length)
         {
            _loc2_.missions_info[_loc3_] = _loc4_ = PMissionInfo.read(param1);
            _loc3_++;
         }
         _loc2_.hero_upgrades = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.hero_upgrades.length)
         {
            _loc2_.hero_upgrades[_loc3_] = _loc4_ = PShopUpgradeHero.read(param1);
            _loc3_++;
         }
         _loc2_.gold_price_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.gold_price_info.length)
         {
            _loc2_.gold_price_info[_loc3_] = _loc4_ = PMoneyPriceInfo.read(param1);
            _loc3_++;
         }
         _loc2_.news = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.news.length)
         {
            _loc2_.news[_loc3_] = _loc4_ = PNewsInfo.read(param1);
            _loc3_++;
         }
         _loc2_.clan_roles_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_roles_info.length)
         {
            _loc2_.clan_roles_info[_loc3_] = _loc4_ = PShopClanRole.read(param1);
            _loc3_++;
         }
         _loc2_.clan_icons = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_icons.length)
         {
            _loc2_.clan_icons[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.clanhalls_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clanhalls_info.length)
         {
            _loc2_.clanhalls_info[_loc3_] = _loc4_ = PShopClanhall.read(param1);
            _loc3_++;
         }
         _loc2_.libraries_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.libraries_info.length)
         {
            _loc2_.libraries_info[_loc3_] = _loc4_ = PShopLibrary.read(param1);
            _loc3_++;
         }
         _loc2_.spells_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.spells_info.length)
         {
            _loc2_.spells_info[_loc3_] = _loc4_ = PShopSpell.read(param1);
            _loc3_++;
         }
         _loc2_.raid_cooldowns_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.raid_cooldowns_info.length)
         {
            _loc2_.raid_cooldowns_info[_loc3_] = _loc4_ = PShopRaidCooldown.read(param1);
            _loc3_++;
         }
         _loc2_.clan_townhall_unlocks = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_townhall_unlocks.length)
         {
            _loc2_.clan_townhall_unlocks[_loc3_] = _loc4_ = PClanTownhallUnlock.read(param1);
            _loc3_++;
         }
         _loc2_.clan_building_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_building_info.length)
         {
            _loc2_.clan_building_info[_loc3_] = _loc4_ = PShopBuilding.read(param1);
            _loc3_++;
         }
         _loc2_.clan_cannons_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_cannons_info.length)
         {
            _loc2_.clan_cannons_info[_loc3_] = _loc4_ = PShopCannon.read(param1);
            _loc3_++;
         }
         _loc2_.clan_fences_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_fences_info.length)
         {
            _loc2_.clan_fences_info[_loc3_] = _loc4_ = PShopFence.read(param1);
            _loc3_++;
         }
         _loc2_.clan_decors_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_decors_info.length)
         {
            _loc2_.clan_decors_info[_loc3_] = _loc4_ = PShopDecor.read(param1);
            _loc3_++;
         }
         _loc2_.clan_resources_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_resources_info.length)
         {
            _loc2_.clan_resources_info[_loc3_] = _loc4_ = PShopResource.read(param1);
            _loc3_++;
         }
         _loc2_.clan_storages_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_storages_info.length)
         {
            _loc2_.clan_storages_info[_loc3_] = _loc4_ = PShopStorage.read(param1);
            _loc3_++;
         }
         _loc2_.offers_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.offers_info.length)
         {
            _loc2_.offers_info[_loc3_] = _loc4_ = PShopOffer.read(param1);
            _loc3_++;
         }
         _loc2_.clan_clanhalls_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_clanhalls_info.length)
         {
            _loc2_.clan_clanhalls_info[_loc3_] = _loc4_ = PShopClanhall.read(param1);
            _loc3_++;
         }
         _loc2_.clan_garbages_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_garbages_info.length)
         {
            _loc2_.clan_garbages_info[_loc3_] = _loc4_ = PShopGarbage.read(param1);
            _loc3_++;
         }
         _loc2_.clan_levels = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_levels.length)
         {
            _loc2_.clan_levels[_loc3_] = _loc4_ = PLevelInfo.read(param1);
            _loc3_++;
         }
         _loc2_.territories_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.territories_info.length)
         {
            _loc2_.territories_info[_loc3_] = _loc4_ = PShopTerritory.read(param1);
            _loc3_++;
         }
         _loc2_.shield_gens_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.shield_gens_info.length)
         {
            _loc2_.shield_gens_info[_loc3_] = _loc4_ = PShopShieldGen.read(param1);
            _loc3_++;
         }
         _loc2_.clan_resources_packs_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_resources_packs_info.length)
         {
            _loc2_.clan_resources_packs_info[_loc3_] = _loc4_ = PShopResourcesPack.read(param1);
            _loc3_++;
         }
         _loc2_.mines_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.mines_info.length)
         {
            _loc2_.mines_info[_loc3_] = _loc4_ = PShopMine.read(param1);
            _loc3_++;
         }
         _loc2_.scoutings = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.scoutings.length)
         {
            _loc2_.scoutings[_loc3_] = _loc4_ = PShopScouting.read(param1);
            _loc3_++;
         }
         _loc2_.scouting_packs = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.scouting_packs.length)
         {
            _loc2_.scouting_packs[_loc3_] = _loc4_ = PShopScoutingPack.read(param1);
            _loc3_++;
         }
         _loc2_.achievements = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.achievements.length)
         {
            _loc2_.achievements[_loc3_] = _loc4_ = PShopAchv.read(param1);
            _loc3_++;
         }
         _loc2_.allowed_version = param1.readUTF();
         _loc2_.divisions = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.divisions.length)
         {
            _loc2_.divisions[_loc3_] = _loc4_ = PShopDivision.read(param1);
            _loc3_++;
         }
         _loc2_.territory_deny = param1.readBoolean();
         _loc2_.clan_divisions = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_divisions.length)
         {
            _loc2_.clan_divisions[_loc3_] = _loc4_ = PClanDivision.read(param1);
            _loc3_++;
         }
         _loc2_.clan_icons_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_icons_info.length)
         {
            _loc2_.clan_icons_info[_loc3_] = _loc4_ = PShopClanIcon.read(param1);
            _loc3_++;
         }
         _loc2_.power_points_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.power_points_info.length)
         {
            _loc2_.power_points_info[_loc3_] = _loc4_ = PShopPowerPoint.read(param1);
            _loc3_++;
         }
         _loc2_.calls_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.calls_info.length)
         {
            _loc2_.calls_info[_loc3_] = _loc4_ = PShopCall.read(param1);
            _loc3_++;
         }
         _loc2_.bosses_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.bosses_info.length)
         {
            _loc2_.bosses_info[_loc3_] = _loc4_ = PShopBoss.read(param1);
            _loc3_++;
         }
         _loc2_.units_packs_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.units_packs_info.length)
         {
            _loc2_.units_packs_info[_loc3_] = _loc4_ = PUnitsPackInfo.read(param1);
            _loc3_++;
         }
         _loc2_.jaina_events_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.jaina_events_info.length)
         {
            _loc2_.jaina_events_info[_loc3_] = _loc4_ = PJainaEventInfo.read(param1);
            _loc3_++;
         }
         _loc2_.jaina_missions_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.jaina_missions_info.length)
         {
            _loc2_.jaina_missions_info[_loc3_] = _loc4_ = PJainaMissionInfo.read(param1);
            _loc3_++;
         }
         _loc2_.adventure_rewards = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.adventure_rewards.length)
         {
            _loc2_.adventure_rewards[_loc3_] = _loc4_ = PAdventureReward.read(param1);
            _loc3_++;
         }
         _loc2_.clan_reward_perc_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_reward_perc_info.length)
         {
            _loc2_.clan_reward_perc_info[_loc3_] = _loc4_ = PClanRewardPerc.read(param1);
            _loc3_++;
         }
         _loc2_.clan_rewards = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_rewards.length)
         {
            _loc2_.clan_rewards[_loc3_] = _loc4_ = PClanReward.read(param1);
            _loc3_++;
         }
         _loc2_.clan_townhall_division_info = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_townhall_division_info.length)
         {
            _loc2_.clan_townhall_division_info[_loc3_] = _loc4_ = PClanTownhallDivision.read(param1);
            _loc3_++;
         }
         _loc2_.subscriptions = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.subscriptions.length)
         {
            _loc2_.subscriptions[_loc3_] = _loc4_ = PShopSubscription.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(this.levels == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.levels.length);
            _loc2_ = 0;
            while(_loc2_ < this.levels.length)
            {
               this.levels[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.building_info == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.building_info.length);
            _loc2_ = 0;
            while(_loc2_ < this.building_info.length)
            {
               this.building_info[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.cannons_info == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.cannons_info.length);
            _loc2_ = 0;
            while(_loc2_ < this.cannons_info.length)
            {
               this.cannons_info[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.fences_info == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.fences_info.length);
            _loc2_ = 0;
            while(_loc2_ < this.fences_info.length)
            {
               this.fences_info[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.units_info == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.units_info.length);
            _loc2_ = 0;
            while(_loc2_ < this.units_info.length)
            {
               this.units_info[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.townhall_unlocks == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.townhall_unlocks.length);
            _loc2_ = 0;
            while(_loc2_ < this.townhall_unlocks.length)
            {
               this.townhall_unlocks[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.camps_info == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.camps_info.length);
            _loc2_ = 0;
            while(_loc2_ < this.camps_info.length)
            {
               this.camps_info[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.resources_info == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.resources_info.length);
            _loc2_ = 0;
            while(_loc2_ < this.resources_info.length)
            {
               this.resources_info[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.storages_info == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.storages_info.length);
            _loc2_ = 0;
            while(_loc2_ < this.storages_info.length)
            {
               this.storages_info[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.pylons_info == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.pylons_info.length);
            _loc2_ = 0;
            while(_loc2_ < this.pylons_info.length)
            {
               this.pylons_info[_loc2_].write(param1);
               _loc2_++;
            }
         }
         this.references.write(param1);
         if(this.decors_info == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.decors_info.length);
            _loc2_ = 0;
            while(_loc2_ < this.decors_info.length)
            {
               this.decors_info[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.garbages_info == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.garbages_info.length);
            _loc2_ = 0;
            while(_loc2_ < this.garbages_info.length)
            {
               this.garbages_info[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.townhall_diffs == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.townhall_diffs.length);
            _loc2_ = 0;
            while(_loc2_ < this.townhall_diffs.length)
            {
               this.townhall_diffs[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.heroes_info == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.heroes_info.length);
            _loc2_ = 0;
            while(_loc2_ < this.heroes_info.length)
            {
               this.heroes_info[_loc2_].write(param1);
               _loc2_++;
            }
         }
         throw new Error("can\'t write quests, assoc writing not implemented. FIXME PLEASE!!!");
      }
   }
}

