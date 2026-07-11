package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_str;
   
   public class PUser implements IClientPacket
   {
      
      public var base:PUserBase;
      
      public var gold:uint;
      
      public var crystal:uint;
      
      public var oil:uint;
      
      public var hglory:uint;
      
      public var quests:Array;
      
      public var quests_closed:Array;
      
      public var stage:String;
      
      public var win_missions:Array;
      
      public var ext_missions:Array;
      
      public var admin_units_mode:Boolean;
      
      public var stories:Array;
      
      public var fight_hist:Array;
      
      public var call_lat:Number;
      
      public var call:uint;
      
      public var facts:uint;
      
      public var settings_game:PSettingsGame;
      
      public var last_readed_news:String;
      
      public var clan_calls:int;
      
      public var clan_calls_time:Number;
      
      public var read_chat_time:Number;
      
      public var red_ore:int;
      
      public var green_ore:int;
      
      public var blue_ore:int;
      
      public var raid_cooldowns:Array;
      
      public var requests:Array;
      
      public var group_id:uint;
      
      public var request_list:Array;
      
      public var request_time:Number;
      
      public var offers:Array;
      
      public var shop_unwatched:Array;
      
      public var last_units:Array;
      
      public var mithril:int;
      
      public var blue_print:int;
      
      public var divisions_reward:Array;
      
      public var spells:Array;
      
      public var client_custom_data:Array;
      
      public var jaina_events:Array;
      
      public var jglory:int;
      
      public var rar_dragon:int;
      
      public var adventures:Array;
      
      public var current_adventure:PCurrentAdventure;
      
      public var subscription:PSubscription;
      
      public var ruby:int;
      
      public function PUser()
      {
         super();
      }
      
      public static function create(param1:PUserBase, param2:uint, param3:uint, param4:uint, param5:uint, param6:Array, param7:Array, param8:String, param9:Array, param10:Array, param11:Boolean, param12:Array, param13:Array, param14:Number, param15:uint, param16:uint, param17:PSettingsGame, param18:String, param19:int, param20:Number, param21:Number, param22:int, param23:int, param24:int, param25:Array, param26:Array, param27:uint, param28:Array, param29:Number, param30:Array, param31:Array, param32:Array, param33:int, param34:int, param35:Array, param36:Array, param37:Array, param38:Array, param39:int, param40:int, param41:Array, param42:PCurrentAdventure, param43:PSubscription, param44:int) : PUser
      {
         var _loc45_:PUser = new PUser();
         _loc45_.base = param1;
         _loc45_.gold = param2;
         _loc45_.crystal = param3;
         _loc45_.oil = param4;
         _loc45_.hglory = param5;
         _loc45_.quests = param6;
         _loc45_.quests_closed = param7;
         _loc45_.stage = param8;
         _loc45_.win_missions = param9;
         _loc45_.ext_missions = param10;
         _loc45_.admin_units_mode = param11;
         _loc45_.stories = param12;
         _loc45_.fight_hist = param13;
         _loc45_.call_lat = param14;
         _loc45_.call = param15;
         _loc45_.facts = param16;
         _loc45_.settings_game = param17;
         _loc45_.last_readed_news = param18;
         _loc45_.clan_calls = param19;
         _loc45_.clan_calls_time = param20;
         _loc45_.read_chat_time = param21;
         _loc45_.red_ore = param22;
         _loc45_.green_ore = param23;
         _loc45_.blue_ore = param24;
         _loc45_.raid_cooldowns = param25;
         _loc45_.requests = param26;
         _loc45_.group_id = param27;
         _loc45_.request_list = param28;
         _loc45_.request_time = param29;
         _loc45_.offers = param30;
         _loc45_.shop_unwatched = param31;
         _loc45_.last_units = param32;
         _loc45_.mithril = param33;
         _loc45_.blue_print = param34;
         _loc45_.divisions_reward = param35;
         _loc45_.spells = param36;
         _loc45_.client_custom_data = param37;
         _loc45_.jaina_events = param38;
         _loc45_.jglory = param39;
         _loc45_.rar_dragon = param40;
         _loc45_.adventures = param41;
         _loc45_.current_adventure = param42;
         _loc45_.subscription = param43;
         _loc45_.ruby = param44;
         return _loc45_;
      }
      
      public static function read(param1:IDataInput) : PUser
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PUser = new PUser();
         _loc2_.base = PUserBase.read(param1);
         _loc2_.gold = param1.readUnsignedInt();
         _loc2_.crystal = param1.readUnsignedInt();
         _loc2_.oil = param1.readUnsignedInt();
         _loc2_.hglory = param1.readUnsignedInt();
         _loc2_.quests = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.quests.length)
         {
            _loc2_.quests[_loc3_] = _loc4_ = PQuest.read(param1);
            _loc3_++;
         }
         _loc2_.quests_closed = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.quests_closed.length)
         {
            _loc2_.quests_closed[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.stage = param1.readUTF();
         _loc2_.win_missions = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.win_missions.length)
         {
            _loc2_.win_missions[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.ext_missions = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ext_missions.length)
         {
            _loc2_.ext_missions[_loc3_] = _loc4_ = PExtMission.read(param1);
            _loc3_++;
         }
         _loc2_.admin_units_mode = param1.readBoolean();
         _loc2_.stories = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.stories.length)
         {
            _loc2_.stories[_loc3_] = _loc4_ = str_str.read(param1);
            _loc3_++;
         }
         _loc2_.fight_hist = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.fight_hist.length)
         {
            _loc2_.fight_hist[_loc3_] = _loc4_ = PHistFight.read(param1);
            _loc3_++;
         }
         _loc2_.call_lat = param1.readDouble();
         _loc2_.call = param1.readUnsignedInt();
         _loc2_.facts = param1.readUnsignedInt();
         _loc2_.settings_game = PSettingsGame.read(param1);
         _loc2_.last_readed_news = param1.readUTF();
         _loc2_.clan_calls = param1.readInt();
         _loc2_.clan_calls_time = param1.readDouble();
         _loc2_.read_chat_time = param1.readDouble();
         _loc2_.red_ore = param1.readInt();
         _loc2_.green_ore = param1.readInt();
         _loc2_.blue_ore = param1.readInt();
         _loc2_.raid_cooldowns = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.raid_cooldowns.length)
         {
            _loc2_.raid_cooldowns[_loc3_] = _loc4_ = PRaidCooldown.read(param1);
            _loc3_++;
         }
         _loc2_.requests = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.requests.length)
         {
            _loc2_.requests[_loc3_] = _loc4_ = PAsk.read(param1);
            _loc3_++;
         }
         _loc2_.group_id = param1.readUnsignedByte();
         _loc2_.request_list = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.request_list.length)
         {
            _loc2_.request_list[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.request_time = param1.readDouble();
         _loc2_.offers = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.offers.length)
         {
            _loc2_.offers[_loc3_] = _loc4_ = POffer.read(param1);
            _loc3_++;
         }
         _loc2_.shop_unwatched = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.shop_unwatched.length)
         {
            _loc2_.shop_unwatched[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.last_units = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.last_units.length)
         {
            _loc2_.last_units[_loc3_] = _loc4_ = PKindCount.read(param1);
            _loc3_++;
         }
         _loc2_.mithril = param1.readInt();
         _loc2_.blue_print = param1.readInt();
         _loc2_.divisions_reward = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.divisions_reward.length)
         {
            _loc2_.divisions_reward[_loc3_] = _loc4_ = param1.readInt();
            _loc3_++;
         }
         _loc2_.spells = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.spells.length)
         {
            _loc2_.spells[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.client_custom_data = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.client_custom_data.length)
         {
            _loc2_.client_custom_data[_loc3_] = _loc4_ = str_str.read(param1);
            _loc3_++;
         }
         _loc2_.jaina_events = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.jaina_events.length)
         {
            _loc2_.jaina_events[_loc3_] = _loc4_ = i_PJainaEvent.read(param1);
            _loc3_++;
         }
         _loc2_.jglory = param1.readInt();
         _loc2_.rar_dragon = param1.readInt();
         _loc2_.adventures = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.adventures.length)
         {
            _loc2_.adventures[_loc3_] = _loc4_ = PAdventure.read(param1);
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.current_adventure = PCurrentAdventure.read(param1);
         }
         else
         {
            _loc2_.current_adventure = null;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.subscription = PSubscription.read(param1);
         }
         else
         {
            _loc2_.subscription = null;
         }
         _loc2_.ruby = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         this.base.write(param1);
         param1.writeInt(this.gold);
         param1.writeInt(this.crystal);
         param1.writeInt(this.oil);
         param1.writeInt(this.hglory);
         if(this.quests == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.quests.length);
            _loc2_ = 0;
            while(_loc2_ < this.quests.length)
            {
               this.quests[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.quests_closed == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.quests_closed.length);
            _loc2_ = 0;
            while(_loc2_ < this.quests_closed.length)
            {
               param1.writeUTF(this.quests_closed[_loc2_]);
               _loc2_++;
            }
         }
         param1.writeUTF(this.stage);
         if(this.win_missions == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.win_missions.length);
            _loc2_ = 0;
            while(_loc2_ < this.win_missions.length)
            {
               param1.writeUTF(this.win_missions[_loc2_]);
               _loc2_++;
            }
         }
         if(this.ext_missions == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ext_missions.length);
            _loc2_ = 0;
            while(_loc2_ < this.ext_missions.length)
            {
               this.ext_missions[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeBoolean(this.admin_units_mode);
         if(this.stories == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.stories.length);
            _loc2_ = 0;
            while(_loc2_ < this.stories.length)
            {
               this.stories[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.fight_hist == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.fight_hist.length);
            _loc2_ = 0;
            while(_loc2_ < this.fight_hist.length)
            {
               this.fight_hist[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeDouble(this.call_lat);
         param1.writeInt(this.call);
         param1.writeInt(this.facts);
         this.settings_game.write(param1);
         param1.writeUTF(this.last_readed_news);
         param1.writeInt(this.clan_calls);
         param1.writeDouble(this.clan_calls_time);
         param1.writeDouble(this.read_chat_time);
         param1.writeInt(this.red_ore);
         param1.writeInt(this.green_ore);
         param1.writeInt(this.blue_ore);
         if(this.raid_cooldowns == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.raid_cooldowns.length);
            _loc2_ = 0;
            while(_loc2_ < this.raid_cooldowns.length)
            {
               this.raid_cooldowns[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.requests == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.requests.length);
            _loc2_ = 0;
            while(_loc2_ < this.requests.length)
            {
               this.requests[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeByte(this.group_id);
         if(this.request_list == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.request_list.length);
            _loc2_ = 0;
            while(_loc2_ < this.request_list.length)
            {
               param1.writeUTF(this.request_list[_loc2_]);
               _loc2_++;
            }
         }
         param1.writeDouble(this.request_time);
         if(this.offers == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.offers.length);
            _loc2_ = 0;
            while(_loc2_ < this.offers.length)
            {
               this.offers[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.shop_unwatched == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.shop_unwatched.length);
            _loc2_ = 0;
            while(_loc2_ < this.shop_unwatched.length)
            {
               param1.writeUTF(this.shop_unwatched[_loc2_]);
               _loc2_++;
            }
         }
         if(this.last_units == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.last_units.length);
            _loc2_ = 0;
            while(_loc2_ < this.last_units.length)
            {
               this.last_units[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.mithril);
         param1.writeInt(this.blue_print);
         if(this.divisions_reward == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.divisions_reward.length);
            _loc2_ = 0;
            while(_loc2_ < this.divisions_reward.length)
            {
               param1.writeInt(this.divisions_reward[_loc2_]);
               _loc2_++;
            }
         }
         if(this.spells == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.spells.length);
            _loc2_ = 0;
            while(_loc2_ < this.spells.length)
            {
               param1.writeUTF(this.spells[_loc2_]);
               _loc2_++;
            }
         }
         if(this.client_custom_data == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.client_custom_data.length);
            _loc2_ = 0;
            while(_loc2_ < this.client_custom_data.length)
            {
               this.client_custom_data[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.jaina_events == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.jaina_events.length);
            _loc2_ = 0;
            while(_loc2_ < this.jaina_events.length)
            {
               this.jaina_events[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.jglory);
         param1.writeInt(this.rar_dragon);
         if(this.adventures == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.adventures.length);
            _loc2_ = 0;
            while(_loc2_ < this.adventures.length)
            {
               this.adventures[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.current_adventure != null)
         {
            param1.writeByte(1);
            this.current_adventure.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.subscription != null)
         {
            param1.writeByte(1);
            this.subscription.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.ruby);
      }
   }
}

