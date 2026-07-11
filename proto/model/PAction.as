package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PAction implements IClientPacket
   {
      
      public static const AC_MOBILE_RATE:uint = 64;
      
      public static const AC_MOBILE_INSTALL:uint = 63;
      
      public static const AC_FRIEND_HELP:uint = 62;
      
      public static const AC_FIND_GOLD:uint = 61;
      
      public static const AC_USE_CLAN_UNIT:uint = 60;
      
      public static const AC_CLAN_ATTACK:uint = 59;
      
      public static const AC_SPEED_UP:uint = 58;
      
      public static const AC_CLAN_HELP:uint = 57;
      
      public static const AC_CLAN_LVL:uint = 56;
      
      public static const AC_LVL_UP:uint = 55;
      
      public static const AC_USE_RESOURCE:uint = 54;
      
      public static const AC_UP_CANNON:uint = 53;
      
      public static const AC_UP_BUILDING:uint = 52;
      
      public static const UNKNOWN:uint = 51;
      
      public static const AC_GAME_BOOKMARK:uint = 50;
      
      public static const AC_GAME_ENTER_GROUP:uint = 49;
      
      public static const AC_GAME_SHARE:uint = 48;
      
      public static const AC_GAME_LIKE:uint = 47;
      
      public static const AC_HERO_HAVE_ARMOR:uint = 46;
      
      public static const AC_HERO_HAVE_DAMAGE:uint = 45;
      
      public static const AC_HERO_HAVE_HP:uint = 44;
      
      public static const AC_UPGRADE_HERO_REGENTIME:uint = 43;
      
      public static const AC_UPGRADE_HERO_ARMOR:uint = 42;
      
      public static const AC_UPGRADE_HERO_DAMAGE:uint = 41;
      
      public static const AC_UPGRADE_HERO_HP:uint = 40;
      
      public static const AC_UPGRADE_HERO:uint = 39;
      
      public static const AC_WIN_RAID:uint = 38;
      
      public static const AC_RAID:uint = 37;
      
      public static const AC_HAVE_UNIT:uint = 36;
      
      public static const AC_FINISH_SIDE_MISSION:uint = 35;
      
      public static const AC_FINISH_CAMPAIGN_MISSION:uint = 34;
      
      public static const AC_START_SIDE_MISSION:uint = 33;
      
      public static const AC_START_CAMPAIGN_MISSION:uint = 32;
      
      public static const AC_HIRE_GUARD:uint = 31;
      
      public static const AC_JOIN_GROUP:uint = 30;
      
      public static const AC_SEND_INVITE:uint = 29;
      
      public static const AC_HAVE_FRIEND:uint = 28;
      
      public static const AC_REMOVE_STONE:uint = 27;
      
      public static const AC_REMOVE_TREE:uint = 26;
      
      public static const AC_REMOVE_GARBAGE:uint = 25;
      
      public static const AC_USE_SPELL:uint = 24;
      
      public static const AC_MAKE_SPELL:uint = 23;
      
      public static const AC_HAVE_SPELL:uint = 22;
      
      public static const AC_USE_HERO:uint = 21;
      
      public static const AC_HAVE_HERO:uint = 20;
      
      public static const AC_RESEARCH:uint = 19;
      
      public static const AC_USE_UNIT:uint = 18;
      
      public static const AC_TRAIN_UNIT:uint = 17;
      
      public static const AC_WIN_DEFEND:uint = 16;
      
      public static const AC_WIN_ATTACK:uint = 15;
      
      public static const AC_ATTACK:uint = 14;
      
      public static const AC_EARN_RATING:uint = 13;
      
      public static const AC_HAVE_RATING:uint = 12;
      
      public static const AC_CAN_STORE:uint = 11;
      
      public static const AC_HARVEST_STACK:uint = 10;
      
      public static const AC_HARVEST_RESOURCE:uint = 9;
      
      public static const AC_ROB_RESOURCE:uint = 8;
      
      public static const AC_HAVE_RESOURCE:uint = 7;
      
      public static const AC_HAVE_DECOR:uint = 6;
      
      public static const AC_DESTROY_FENCE:uint = 5;
      
      public static const AC_FINISH_FENCE:uint = 4;
      
      public static const AC_DESTROY_CANNON:uint = 3;
      
      public static const AC_FINISH_CANNON:uint = 2;
      
      public static const AC_DESTROY_BUILDING:uint = 1;
      
      public static const AC_FINISH_BUILDING:uint = 0;
      
      public var variance:uint;
      
      public function PAction()
      {
         super();
      }
      
      public static function create(param1:uint) : PAction
      {
         var _loc2_:PAction = new PAction();
         _loc2_.variance = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PAction
      {
         var _loc2_:PAction = new PAction();
         _loc2_.variance = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
      }
   }
}

