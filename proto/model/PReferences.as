package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PReferences implements IClientPacket
   {
      
      public var vector_max_time:int;
      
      public var units_landing_period:int;
      
      public var win_percentage:Number;
      
      public var landing_anim_time:int;
      
      public var call_repair_period:Number;
      
      public var raid_max_units_count:uint;
      
      public var raid_units_min_perc:uint;
      
      public var max_fight_time:Number;
      
      public var max_raid_time:Number;
      
      public var raid_bot_time:Number;
      
      public var fence_builder_req_lvl:uint;
      
      public var resource_fight_k:Number;
      
      public var raid_min_hspace_landing:uint;
      
      public var clan_request_cd:Number;
      
      public var clan_request_size:int;
      
      public var online_timeout:Number;
      
      public var red_ore_to_green:uint;
      
      public var green_ore_to_blue:uint;
      
      public var pvp_ore_min_perc:Number;
      
      public var raid_members_count:int;
      
      public var request_cooldown:Number;
      
      public var request_max_count:int;
      
      public var create_clan_price:PCost;
      
      public var create_capital_price:PCost;
      
      public var edit_capital_timeout:Number;
      
      public var fight_prepare_time:Number;
      
      public var auto_command_time:Number;
      
      public var auto_command_perc:int;
      
      public var wp_generation:Number;
      
      public var wp_generation_during_storm:Number;
      
      public var wp_storm_req:int;
      
      public var wp_wave_duration:Number;
      
      public var wp_war_duration:Number;
      
      public var wp_wave_members_count:int;
      
      public var trophy_gen_time:Number;
      
      public var trophy_gen_cap_time:Number;
      
      public var trophy_gen_limit:int;
      
      public var trophy_gen_cap_limit:int;
      
      public var mithril_limit:int;
      
      public var blue_print_limit:int;
      
      public var clan_mithril_limit:int;
      
      public var hp_per_pp:int;
      
      public var raid_hp_per_pp:int;
      
      public var clan_hp_per_pp:int;
      
      public var stamina_per_pp:Number;
      
      public var boss_defend_spells:Array;
      
      public var enter_pvp_price:PCost;
      
      public var enter_storm_price:PCost;
      
      public var min_ratio_per_fight:int;
      
      public var max_ratio_per_fight:int;
      
      public var jaina_mission_start_cost:PCost;
      
      public var adventure_duration:Number;
      
      public var adventure_perc_per_level:Number;
      
      public var adventure_levels_count:int;
      
      public var change_creator_price:PCost;
      
      public var clan_competition_start_time:Number;
      
      public var clan_competition_duration:Number;
      
      public var pvp_win:int;
      
      public var raid_win:int;
      
      public var hero_raid_win:int;
      
      public var mission_win:int;
      
      public var clan_war_win:int;
      
      public var terra_win:int;
      
      public var terra_def:int;
      
      public var capital_resources_period:Number;
      
      public function PReferences()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:Number, param4:int, param5:Number, param6:uint, param7:uint, param8:Number, param9:Number, param10:Number, param11:uint, param12:Number, param13:uint, param14:Number, param15:int, param16:Number, param17:uint, param18:uint, param19:Number, param20:int, param21:Number, param22:int, param23:PCost, param24:PCost, param25:Number, param26:Number, param27:Number, param28:int, param29:Number, param30:Number, param31:int, param32:Number, param33:Number, param34:int, param35:Number, param36:Number, param37:int, param38:int, param39:int, param40:int, param41:int, param42:int, param43:int, param44:int, param45:Number, param46:Array, param47:PCost, param48:PCost, param49:int, param50:int, param51:PCost, param52:Number, param53:Number, param54:int, param55:PCost, param56:Number, param57:Number, param58:int, param59:int, param60:int, param61:int, param62:int, param63:int, param64:int, param65:Number) : PReferences
      {
         var _loc66_:PReferences = new PReferences();
         _loc66_.vector_max_time = param1;
         _loc66_.units_landing_period = param2;
         _loc66_.win_percentage = param3;
         _loc66_.landing_anim_time = param4;
         _loc66_.call_repair_period = param5;
         _loc66_.raid_max_units_count = param6;
         _loc66_.raid_units_min_perc = param7;
         _loc66_.max_fight_time = param8;
         _loc66_.max_raid_time = param9;
         _loc66_.raid_bot_time = param10;
         _loc66_.fence_builder_req_lvl = param11;
         _loc66_.resource_fight_k = param12;
         _loc66_.raid_min_hspace_landing = param13;
         _loc66_.clan_request_cd = param14;
         _loc66_.clan_request_size = param15;
         _loc66_.online_timeout = param16;
         _loc66_.red_ore_to_green = param17;
         _loc66_.green_ore_to_blue = param18;
         _loc66_.pvp_ore_min_perc = param19;
         _loc66_.raid_members_count = param20;
         _loc66_.request_cooldown = param21;
         _loc66_.request_max_count = param22;
         _loc66_.create_clan_price = param23;
         _loc66_.create_capital_price = param24;
         _loc66_.edit_capital_timeout = param25;
         _loc66_.fight_prepare_time = param26;
         _loc66_.auto_command_time = param27;
         _loc66_.auto_command_perc = param28;
         _loc66_.wp_generation = param29;
         _loc66_.wp_generation_during_storm = param30;
         _loc66_.wp_storm_req = param31;
         _loc66_.wp_wave_duration = param32;
         _loc66_.wp_war_duration = param33;
         _loc66_.wp_wave_members_count = param34;
         _loc66_.trophy_gen_time = param35;
         _loc66_.trophy_gen_cap_time = param36;
         _loc66_.trophy_gen_limit = param37;
         _loc66_.trophy_gen_cap_limit = param38;
         _loc66_.mithril_limit = param39;
         _loc66_.blue_print_limit = param40;
         _loc66_.clan_mithril_limit = param41;
         _loc66_.hp_per_pp = param42;
         _loc66_.raid_hp_per_pp = param43;
         _loc66_.clan_hp_per_pp = param44;
         _loc66_.stamina_per_pp = param45;
         _loc66_.boss_defend_spells = param46;
         _loc66_.enter_pvp_price = param47;
         _loc66_.enter_storm_price = param48;
         _loc66_.min_ratio_per_fight = param49;
         _loc66_.max_ratio_per_fight = param50;
         _loc66_.jaina_mission_start_cost = param51;
         _loc66_.adventure_duration = param52;
         _loc66_.adventure_perc_per_level = param53;
         _loc66_.adventure_levels_count = param54;
         _loc66_.change_creator_price = param55;
         _loc66_.clan_competition_start_time = param56;
         _loc66_.clan_competition_duration = param57;
         _loc66_.pvp_win = param58;
         _loc66_.raid_win = param59;
         _loc66_.hero_raid_win = param60;
         _loc66_.mission_win = param61;
         _loc66_.clan_war_win = param62;
         _loc66_.terra_win = param63;
         _loc66_.terra_def = param64;
         _loc66_.capital_resources_period = param65;
         return _loc66_;
      }
      
      public static function read(param1:IDataInput) : PReferences
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PReferences = new PReferences();
         _loc2_.vector_max_time = param1.readInt();
         _loc2_.units_landing_period = param1.readInt();
         _loc2_.win_percentage = param1.readDouble();
         _loc2_.landing_anim_time = param1.readInt();
         _loc2_.call_repair_period = param1.readDouble();
         _loc2_.raid_max_units_count = param1.readUnsignedInt();
         _loc2_.raid_units_min_perc = param1.readUnsignedInt();
         _loc2_.max_fight_time = param1.readDouble();
         _loc2_.max_raid_time = param1.readDouble();
         _loc2_.raid_bot_time = param1.readDouble();
         _loc2_.fence_builder_req_lvl = param1.readUnsignedInt();
         _loc2_.resource_fight_k = param1.readDouble();
         _loc2_.raid_min_hspace_landing = param1.readUnsignedInt();
         _loc2_.clan_request_cd = param1.readDouble();
         _loc2_.clan_request_size = param1.readInt();
         _loc2_.online_timeout = param1.readDouble();
         _loc2_.red_ore_to_green = param1.readUnsignedInt();
         _loc2_.green_ore_to_blue = param1.readUnsignedInt();
         _loc2_.pvp_ore_min_perc = param1.readDouble();
         _loc2_.raid_members_count = param1.readInt();
         _loc2_.request_cooldown = param1.readDouble();
         _loc2_.request_max_count = param1.readInt();
         _loc2_.create_clan_price = PCost.read(param1);
         _loc2_.create_capital_price = PCost.read(param1);
         _loc2_.edit_capital_timeout = param1.readDouble();
         _loc2_.fight_prepare_time = param1.readDouble();
         _loc2_.auto_command_time = param1.readDouble();
         _loc2_.auto_command_perc = param1.readInt();
         _loc2_.wp_generation = param1.readDouble();
         _loc2_.wp_generation_during_storm = param1.readDouble();
         _loc2_.wp_storm_req = param1.readInt();
         _loc2_.wp_wave_duration = param1.readDouble();
         _loc2_.wp_war_duration = param1.readDouble();
         _loc2_.wp_wave_members_count = param1.readInt();
         _loc2_.trophy_gen_time = param1.readDouble();
         _loc2_.trophy_gen_cap_time = param1.readDouble();
         _loc2_.trophy_gen_limit = param1.readInt();
         _loc2_.trophy_gen_cap_limit = param1.readInt();
         _loc2_.mithril_limit = param1.readInt();
         _loc2_.blue_print_limit = param1.readInt();
         _loc2_.clan_mithril_limit = param1.readInt();
         _loc2_.hp_per_pp = param1.readInt();
         _loc2_.raid_hp_per_pp = param1.readInt();
         _loc2_.clan_hp_per_pp = param1.readInt();
         _loc2_.stamina_per_pp = param1.readDouble();
         _loc2_.boss_defend_spells = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.boss_defend_spells.length)
         {
            _loc2_.boss_defend_spells[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.enter_pvp_price = PCost.read(param1);
         _loc2_.enter_storm_price = PCost.read(param1);
         _loc2_.min_ratio_per_fight = param1.readInt();
         _loc2_.max_ratio_per_fight = param1.readInt();
         _loc2_.jaina_mission_start_cost = PCost.read(param1);
         _loc2_.adventure_duration = param1.readDouble();
         _loc2_.adventure_perc_per_level = param1.readDouble();
         _loc2_.adventure_levels_count = param1.readInt();
         _loc2_.change_creator_price = PCost.read(param1);
         _loc2_.clan_competition_start_time = param1.readDouble();
         _loc2_.clan_competition_duration = param1.readDouble();
         _loc2_.pvp_win = param1.readInt();
         _loc2_.raid_win = param1.readInt();
         _loc2_.hero_raid_win = param1.readInt();
         _loc2_.mission_win = param1.readInt();
         _loc2_.clan_war_win = param1.readInt();
         _loc2_.terra_win = param1.readInt();
         _loc2_.terra_def = param1.readInt();
         _loc2_.capital_resources_period = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.vector_max_time);
         param1.writeInt(this.units_landing_period);
         param1.writeDouble(this.win_percentage);
         param1.writeInt(this.landing_anim_time);
         param1.writeDouble(this.call_repair_period);
         param1.writeInt(this.raid_max_units_count);
         param1.writeInt(this.raid_units_min_perc);
         param1.writeDouble(this.max_fight_time);
         param1.writeDouble(this.max_raid_time);
         param1.writeDouble(this.raid_bot_time);
         param1.writeInt(this.fence_builder_req_lvl);
         param1.writeDouble(this.resource_fight_k);
         param1.writeInt(this.raid_min_hspace_landing);
         param1.writeDouble(this.clan_request_cd);
         param1.writeInt(this.clan_request_size);
         param1.writeDouble(this.online_timeout);
         param1.writeInt(this.red_ore_to_green);
         param1.writeInt(this.green_ore_to_blue);
         param1.writeDouble(this.pvp_ore_min_perc);
         param1.writeInt(this.raid_members_count);
         param1.writeDouble(this.request_cooldown);
         param1.writeInt(this.request_max_count);
         this.create_clan_price.write(param1);
         this.create_capital_price.write(param1);
         param1.writeDouble(this.edit_capital_timeout);
         param1.writeDouble(this.fight_prepare_time);
         param1.writeDouble(this.auto_command_time);
         param1.writeInt(this.auto_command_perc);
         param1.writeDouble(this.wp_generation);
         param1.writeDouble(this.wp_generation_during_storm);
         param1.writeInt(this.wp_storm_req);
         param1.writeDouble(this.wp_wave_duration);
         param1.writeDouble(this.wp_war_duration);
         param1.writeInt(this.wp_wave_members_count);
         param1.writeDouble(this.trophy_gen_time);
         param1.writeDouble(this.trophy_gen_cap_time);
         param1.writeInt(this.trophy_gen_limit);
         param1.writeInt(this.trophy_gen_cap_limit);
         param1.writeInt(this.mithril_limit);
         param1.writeInt(this.blue_print_limit);
         param1.writeInt(this.clan_mithril_limit);
         param1.writeInt(this.hp_per_pp);
         param1.writeInt(this.raid_hp_per_pp);
         param1.writeInt(this.clan_hp_per_pp);
         param1.writeDouble(this.stamina_per_pp);
         if(this.boss_defend_spells == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.boss_defend_spells.length);
            _loc2_ = 0;
            while(_loc2_ < this.boss_defend_spells.length)
            {
               param1.writeUTF(this.boss_defend_spells[_loc2_]);
               _loc2_++;
            }
         }
         this.enter_pvp_price.write(param1);
         this.enter_storm_price.write(param1);
         param1.writeInt(this.min_ratio_per_fight);
         param1.writeInt(this.max_ratio_per_fight);
         this.jaina_mission_start_cost.write(param1);
         param1.writeDouble(this.adventure_duration);
         param1.writeDouble(this.adventure_perc_per_level);
         param1.writeInt(this.adventure_levels_count);
         this.change_creator_price.write(param1);
         param1.writeDouble(this.clan_competition_start_time);
         param1.writeDouble(this.clan_competition_duration);
         param1.writeInt(this.pvp_win);
         param1.writeInt(this.raid_win);
         param1.writeInt(this.hero_raid_win);
         param1.writeInt(this.mission_win);
         param1.writeInt(this.clan_war_win);
         param1.writeInt(this.terra_win);
         param1.writeInt(this.terra_def);
         param1.writeDouble(this.capital_resources_period);
      }
   }
}

