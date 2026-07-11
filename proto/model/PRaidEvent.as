package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.clan.PCallRequest;
   import proto.model.clan.PChangeClan;
   import proto.model.clan.PMember;
   import proto.model.clan.PMessage;
   import proto.model.clan.PSetRegent;
   import proto.model.clan.PSetRole;
   import proto.model.clan.PWar;
   
   public class PRaidEvent implements IClientPacket
   {
      
      public static const FETCH_EVENTS:uint = 31;
      
      public static const MEMBER_FINISH_BUILD:uint = 30;
      
      public static const MEMBER_LEVEL_UP:uint = 29;
      
      public static const G_LSTART_WAR:uint = 28;
      
      public static const UNKNOWN:uint = 27;
      
      public static const TERRITORY_REGENT:uint = 26;
      
      public static const FINISH_WAR:uint = 25;
      
      public static const INC_WARPOINTS:uint = 24;
      
      public static const NEW_STORM_MEMBER:uint = 23;
      
      public static const START_WAR:uint = 22;
      
      public static const START_STORM:uint = 21;
      
      public static const BUY_OFFER:uint = 20;
      
      public static const CLAN_ACTION:uint = 19;
      
      public static const NEW_GARBAGES:uint = 18;
      
      public static const CREATE_CAPITAL:uint = 17;
      
      public static const CLAN_DONATE:uint = 16;
      
      public static const HELP:uint = 15;
      
      public static const ASK:uint = 14;
      
      public static const DEL_CLAN_REQUEST:uint = 13;
      
      public static const NEW_CLAN_REQUEST:uint = 12;
      
      public static const SET_CLAN_ROLE:uint = 11;
      
      public static const CHANGE_CLAN:uint = 10;
      
      public static const DEL_CLAN_MEMBER:uint = 9;
      
      public static const NEW_CLAN_MEMBER:uint = 8;
      
      public static const UPDATE_CALL_REQUEST:uint = 7;
      
      public static const CHAT_MESSAGE:uint = 6;
      
      public static const ENABLE_AUTO_MODE:uint = 5;
      
      public static const RAID_INVITE:uint = 4;
      
      public static const START_FIGHT:uint = 3;
      
      public static const DEL_MEMBER:uint = 2;
      
      public static const NEW_MEMBER:uint = 1;
      
      public static const COMMAND:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PRaidEvent()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PRaidEvent
      {
         var _loc3_:PRaidEvent = new PRaidEvent();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PRaidEvent
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc2_:PRaidEvent = new PRaidEvent();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = PCommand.read(param1);
               break;
            case 1:
               _loc2_.value = PUserBase.read(param1);
               break;
            case 2:
               _loc2_.value = param1.readUTF();
               break;
            case 3:
               break;
            case 4:
               _loc2_.value = PRaidInvite.read(param1);
               break;
            case 5:
               _loc2_.value = param1.readDouble();
               break;
            case 6:
               _loc2_.value = PMessage.read(param1);
               break;
            case 7:
               _loc2_.value = PCallRequest.read(param1);
               break;
            case 8:
               _loc2_.value = PMember.read(param1);
               break;
            case 9:
               _loc2_.value = param1.readUTF();
               break;
            case 10:
               _loc2_.value = PChangeClan.read(param1);
               break;
            case 11:
               _loc2_.value = PSetRole.read(param1);
               break;
            case 12:
               _loc2_.value = PClanRequest.read(param1);
               break;
            case 13:
               _loc2_.value = param1.readUTF();
               break;
            case 14:
               _loc2_.value = PAsk.read(param1);
               break;
            case 15:
               _loc2_.value = PAsk.read(param1);
               break;
            case 16:
               _loc2_.value = PCost.read(param1);
               break;
            case 17:
               _loc2_.value = PCreateCapitalEvent.read(param1);
               break;
            case 18:
               _loc2_.value = new Array(param1.readUnsignedShort());
               _loc3_ = 0;
               while(_loc3_ < _loc2_.value.length)
               {
                  _loc2_.value[_loc3_] = _loc4_ = PGarbage.read(param1);
                  _loc3_++;
               }
               break;
            case 19:
               _loc2_.value = new Array(param1.readUnsignedShort());
               _loc3_ = 0;
               while(_loc3_ < _loc2_.value.length)
               {
                  _loc2_.value[_loc3_] = _loc4_ = PClanAction.read(param1);
                  _loc3_++;
               }
               break;
            case 20:
               _loc2_.value = param1.readUTF();
               break;
            case 21:
               _loc2_.value = PStartStorm.read(param1);
               break;
            case 22:
               _loc2_.value = PWar.read(param1);
               break;
            case 23:
               _loc2_.value = PUserBase.read(param1);
               break;
            case 24:
               _loc2_.value = PIncWarpoints.read(param1);
               break;
            case 25:
               break;
            case 26:
               _loc2_.value = PSetRegent.read(param1);
               break;
            case 27:
               break;
            case 28:
               _loc2_.value = PGlStartWar.read(param1);
               break;
            case 29:
               _loc2_.value = PMemberLevelUp.read(param1);
               break;
            case 30:
               _loc2_.value = PMemberFinishBuild.read(param1);
               break;
            case 31:
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
               (this.value as PCommand).write(param1);
               break;
            case 1:
               (this.value as PUserBase).write(param1);
               break;
            case 2:
               param1.writeUTF(this.value as String);
               break;
            case 3:
               break;
            case 4:
               (this.value as PRaidInvite).write(param1);
               break;
            case 5:
               param1.writeDouble(this.value as Number);
               break;
            case 6:
               (this.value as PMessage).write(param1);
               break;
            case 7:
               (this.value as PCallRequest).write(param1);
               break;
            case 8:
               (this.value as PMember).write(param1);
               break;
            case 9:
               param1.writeUTF(this.value as String);
               break;
            case 10:
               (this.value as PChangeClan).write(param1);
               break;
            case 11:
               (this.value as PSetRole).write(param1);
               break;
            case 12:
               (this.value as PClanRequest).write(param1);
               break;
            case 13:
               param1.writeUTF(this.value as String);
               break;
            case 14:
               (this.value as PAsk).write(param1);
               break;
            case 15:
               (this.value as PAsk).write(param1);
               break;
            case 16:
               (this.value as PCost).write(param1);
               break;
            case 17:
               (this.value as PCreateCapitalEvent).write(param1);
               break;
            case 18:
               if(this.value as Array == null)
               {
                  param1.writeShort(0);
                  break;
               }
               param1.writeShort((this.value as Array).length);
               _loc2_ = 0;
               while(_loc2_ < (this.value as Array).length)
               {
                  (this.value as Array)[_loc2_].write(param1);
                  _loc2_++;
               }
               break;
            case 19:
               if(this.value as Array == null)
               {
                  param1.writeShort(0);
                  break;
               }
               param1.writeShort((this.value as Array).length);
               _loc2_ = 0;
               while(_loc2_ < (this.value as Array).length)
               {
                  (this.value as Array)[_loc2_].write(param1);
                  _loc2_++;
               }
               break;
            case 20:
               param1.writeUTF(this.value as String);
               break;
            case 21:
               (this.value as PStartStorm).write(param1);
               break;
            case 22:
               (this.value as PWar).write(param1);
               break;
            case 23:
               (this.value as PUserBase).write(param1);
               break;
            case 24:
               (this.value as PIncWarpoints).write(param1);
               break;
            case 25:
               break;
            case 26:
               (this.value as PSetRegent).write(param1);
               break;
            case 27:
               break;
            case 28:
               (this.value as PGlStartWar).write(param1);
               break;
            case 29:
               (this.value as PMemberLevelUp).write(param1);
               break;
            case 30:
               (this.value as PMemberFinishBuild).write(param1);
               break;
            case 31:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

