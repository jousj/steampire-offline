package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PBoardObj;
   import proto.model.PCommand;
   import proto.model.PCost;
   import proto.model.PMove;
   import proto.model.PObjectId;
   import proto.model.PSpeedUp;
   import proto.model.PStartStudy;
   import proto.tuples.str_str;
   
   public class PUserAction implements IClientPacket
   {
      
      public static const SET_CUSTOM_DATA:uint = 40;
      
      public static const BUY_UNITS_PACK:uint = 39;
      
      public static const ENABLE_SHIELD_GEN:uint = 38;
      
      public static const REMOVE_SHOP_UNWATCHED:uint = 37;
      
      public static const SPEED_UP_RAID:uint = 36;
      
      public static const CONVERT_ORE:uint = 35;
      
      public static const SET_SPELLS:uint = 34;
      
      public static const CLAN_CALL_REQUEST:uint = 33;
      
      public static const COLLECT_CLAN_CALLS:uint = 32;
      
      public static const SELL_DECOR:uint = 31;
      
      public static const READ_NEWS:uint = 30;
      
      public static const BUY_CALLS:uint = 29;
      
      public static const REMOVE_UNIT:uint = 28;
      
      public static const UPGRADE_HERO:uint = 27;
      
      public static const CANCEL_REMOVE_GARBAGE:uint = 26;
      
      public static const CANCEL_STUDY:uint = 25;
      
      public static const CANCEL_CONSTRUCTING_CANNON:uint = 24;
      
      public static const CANCEL_CONSTRUCTING_BUILDING:uint = 23;
      
      public static const READ_FIGHT_HIST:uint = 22;
      
      public static const SPEED_UP_HERO:uint = 21;
      
      public static const BUY_RESOURCES_PACK:uint = 20;
      
      public static const BUY_SHIELD:uint = 19;
      
      public static const READ_STORY:uint = 18;
      
      public static const BUY_RESOURCE_BY_GOLD:uint = 17;
      
      public static const EXECUTE_QUEST_TARGET:uint = 16;
      
      public static const USER_COMPLITE_QUEST:uint = 15;
      
      public static const DELETE_OBJECT:uint = 14;
      
      public static const CHARGE_GUARD:uint = 13;
      
      public static const SET_GUARD_CONFIG:uint = 12;
      
      public static const FIGHT_ADD_COMMAND:uint = 11;
      
      public static const SPEED_UP_GARBAGE:uint = 10;
      
      public static const REMOVE_GARBAGE:uint = 9;
      
      public static const SPEED_UP_STUDY:uint = 8;
      
      public static const START_STUDY:uint = 7;
      
      public static const COLLECT_RESOURCE:uint = 6;
      
      public static const MAKE_UNIT:uint = 5;
      
      public static const MOVE:uint = 4;
      
      public static const UPGRADE:uint = 3;
      
      public static const SPEED_UP_CANNON:uint = 2;
      
      public static const SPEED_UP_BUILDING:uint = 1;
      
      public static const BUY_OBJECT:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PUserAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PUserAction
      {
         var _loc3_:PUserAction = new PUserAction();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PUserAction
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc2_:PUserAction = new PUserAction();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = PBoardObj.read(param1);
               break;
            case 1:
               _loc2_.value = PSpeedUp.read(param1);
               break;
            case 2:
               _loc2_.value = PSpeedUp.read(param1);
               break;
            case 3:
               _loc2_.value = PObjectId.read(param1);
               break;
            case 4:
               _loc2_.value = PMove.read(param1);
               break;
            case 5:
               _loc2_.value = PMakeUnit.read(param1);
               break;
            case 6:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 7:
               _loc2_.value = PStartStudy.read(param1);
               break;
            case 8:
               _loc2_.value = PSpeedUp.read(param1);
               break;
            case 9:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 10:
               _loc2_.value = PSpeedUp.read(param1);
               break;
            case 11:
               _loc2_.value = PCommand.read(param1);
               break;
            case 12:
               _loc2_.value = PGuardConfig.read(param1);
               break;
            case 13:
               _loc2_.value = PChargeGuard.read(param1);
               break;
            case 14:
               _loc2_.value = PObjectId.read(param1);
               break;
            case 15:
               _loc2_.value = param1.readUTF();
               break;
            case 16:
               _loc2_.value = PExecuteQuestTarget.read(param1);
               break;
            case 17:
               _loc2_.value = PCost.read(param1);
               break;
            case 18:
               _loc2_.value = param1.readUTF();
               break;
            case 19:
               _loc2_.value = param1.readUTF();
               break;
            case 20:
               _loc2_.value = param1.readUTF();
               break;
            case 21:
               _loc2_.value = PSpeedUp.read(param1);
               break;
            case 22:
               break;
            case 23:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 24:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 25:
               _loc2_.value = PStartStudy.read(param1);
               break;
            case 26:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 27:
               _loc2_.value = PUpgradeHero.read(param1);
               break;
            case 28:
               _loc2_.value = PMakeUnit.read(param1);
               break;
            case 29:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 30:
               _loc2_.value = param1.readUTF();
               break;
            case 31:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 32:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 33:
               break;
            case 34:
               _loc2_.value = new Array(param1.readUnsignedShort());
               _loc3_ = 0;
               while(_loc3_ < _loc2_.value.length)
               {
                  _loc2_.value[_loc3_] = _loc4_ = param1.readUTF();
                  _loc3_++;
               }
               break;
            case 35:
               _loc2_.value = PCost.read(param1);
               break;
            case 36:
               _loc2_.value = param1.readUTF();
               break;
            case 37:
               _loc2_.value = new Array(param1.readUnsignedShort());
               _loc3_ = 0;
               while(_loc3_ < _loc2_.value.length)
               {
                  _loc2_.value[_loc3_] = _loc4_ = param1.readUTF();
                  _loc3_++;
               }
               break;
            case 38:
               _loc2_.value = param1.readInt();
               break;
            case 39:
               _loc2_.value = param1.readInt();
               break;
            case 40:
               _loc2_.value = str_str.read(param1);
               break;
            default:
               throw new Error("Packet incorrect");
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         param1.writeByte(this.variance);
         switch(this.variance)
         {
            case 0:
               (this.value as PBoardObj).write(param1);
               break;
            case 1:
               (this.value as PSpeedUp).write(param1);
               break;
            case 2:
               (this.value as PSpeedUp).write(param1);
               break;
            case 3:
               (this.value as PObjectId).write(param1);
               break;
            case 4:
               (this.value as PMove).write(param1);
               break;
            case 5:
               (this.value as PMakeUnit).write(param1);
               break;
            case 6:
               param1.writeInt(this.value as uint);
               break;
            case 7:
               (this.value as PStartStudy).write(param1);
               break;
            case 8:
               (this.value as PSpeedUp).write(param1);
               break;
            case 9:
               param1.writeInt(this.value as uint);
               break;
            case 10:
               (this.value as PSpeedUp).write(param1);
               break;
            case 11:
               (this.value as PCommand).write(param1);
               break;
            case 12:
               (this.value as PGuardConfig).write(param1);
               break;
            case 13:
               (this.value as PChargeGuard).write(param1);
               break;
            case 14:
               (this.value as PObjectId).write(param1);
               break;
            case 15:
               param1.writeUTF(this.value as String);
               break;
            case 16:
               (this.value as PExecuteQuestTarget).write(param1);
               break;
            case 17:
               (this.value as PCost).write(param1);
               break;
            case 18:
               param1.writeUTF(this.value as String);
               break;
            case 19:
               param1.writeUTF(this.value as String);
               break;
            case 20:
               param1.writeUTF(this.value as String);
               break;
            case 21:
               (this.value as PSpeedUp).write(param1);
               break;
            case 22:
               break;
            case 23:
               param1.writeInt(this.value as uint);
               break;
            case 24:
               param1.writeInt(this.value as uint);
               break;
            case 25:
               (this.value as PStartStudy).write(param1);
               break;
            case 26:
               param1.writeInt(this.value as uint);
               break;
            case 27:
               (this.value as PUpgradeHero).write(param1);
               break;
            case 28:
               (this.value as PMakeUnit).write(param1);
               break;
            case 29:
               param1.writeInt(this.value as uint);
               break;
            case 30:
               param1.writeUTF(this.value as String);
               break;
            case 31:
               param1.writeInt(this.value as uint);
               break;
            case 32:
               param1.writeInt(this.value as uint);
               break;
            case 33:
               break;
            case 34:
               if(this.value as Array == null)
               {
                  param1.writeShort(0);
                  break;
               }
               param1.writeShort((this.value as Array).length);
               _loc2_ = 0;
               while(_loc2_ < (this.value as Array).length)
               {
                  param1.writeUTF((this.value as Array)[_loc2_]);
                  _loc2_++;
               }
               break;
            case 35:
               (this.value as PCost).write(param1);
               break;
            case 36:
               param1.writeUTF(this.value as String);
               break;
            case 37:
               if(this.value as Array == null)
               {
                  param1.writeShort(0);
                  break;
               }
               param1.writeShort((this.value as Array).length);
               _loc2_ = 0;
               while(_loc2_ < (this.value as Array).length)
               {
                  param1.writeUTF((this.value as Array)[_loc2_]);
                  _loc2_++;
               }
               break;
            case 38:
               param1.writeInt(this.value as int);
               break;
            case 39:
               param1.writeInt(this.value as int);
               break;
            case 40:
               (this.value as str_str).write(param1);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

