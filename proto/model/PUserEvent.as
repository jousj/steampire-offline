package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_str;
   
   public class PUserEvent implements IClientPacket
   {
      
      public static const UPDATE_SUBSCRIPTION:uint = 32;
      
      public static const CLAN_CENTER_PRIZE:uint = 31;
      
      public static const USER_CLAN_POINTS:uint = 30;
      
      public static const CLAN_COMP_PRIZE:uint = 29;
      
      public static const ORE_SPELL_COMPENSATIONS:uint = 28;
      
      public static const CLAN_DIVISION:uint = 27;
      
      public static const DIVISION:uint = 26;
      
      public static const MITHRIL:uint = 25;
      
      public static const UNKNOWN:uint = 24;
      
      public static const END_WAR:uint = 23;
      
      public static const START_WAR:uint = 22;
      
      public static const RESTART_AT:uint = 21;
      
      public static const BUY_OFFER:uint = 20;
      
      public static const CREATE_CAPITAL:uint = 19;
      
      public static const DEL_OFFER:uint = 18;
      
      public static const NEW_OFFER:uint = 17;
      
      public static const SHARE_CALL:uint = 16;
      
      public static const STAGE_CHANGED:uint = 15;
      
      public static const SHARE_SHIELD:uint = 14;
      
      public static const SHARE_HGLORY:uint = 13;
      
      public static const SHARE_CRYSTAL:uint = 12;
      
      public static const SHARE_OIL:uint = 11;
      
      public static const SHARE_GOLD:uint = 10;
      
      public static const ALINK:uint = 9;
      
      public static const STORY:uint = 8;
      
      public static const FINISH_QUEST:uint = 7;
      
      public static const EDIT_QUEST:uint = 6;
      
      public static const START_QUEST:uint = 5;
      
      public static const LEVEL:uint = 4;
      
      public static const EXP:uint = 3;
      
      public static const OIL:uint = 2;
      
      public static const CRYSTAL:uint = 1;
      
      public static const GOLD:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PUserEvent()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PUserEvent
      {
         var _loc3_:PUserEvent = new PUserEvent();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PUserEvent
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PUserEvent = new PUserEvent();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = param1.readInt();
               break;
            case 1:
               _loc2_.value = param1.readInt();
               break;
            case 2:
               _loc2_.value = param1.readInt();
               break;
            case 3:
               _loc2_.value = param1.readInt();
               break;
            case 4:
               _loc2_.value = PNewLevelInfo.read(param1);
               break;
            case 5:
               _loc2_.value = PQuest.read(param1);
               break;
            case 6:
               _loc2_.value = PQuest.read(param1);
               break;
            case 7:
               _loc2_.value = PQuestFinish.read(param1);
               break;
            case 8:
               _loc2_.value = str_str.read(param1);
               break;
            case 9:
               _loc2_.value = PAlinkEvent.read(param1);
               break;
            case 10:
               _loc2_.value = i_PSign.read(param1);
               break;
            case 11:
               _loc2_.value = i_PSign.read(param1);
               break;
            case 12:
               _loc2_.value = i_PSign.read(param1);
               break;
            case 13:
               _loc2_.value = i_PSign.read(param1);
               break;
            case 14:
               _loc2_.value = time_PSign.read(param1);
               break;
            case 15:
               _loc2_.value = param1.readUTF();
               break;
            case 16:
               _loc2_.value = i_PSign.read(param1);
               break;
            case 17:
               _loc2_.value = POffer.read(param1);
               break;
            case 18:
               _loc2_.value = param1.readUTF();
               break;
            case 19:
               _loc2_.value = PCreateCapitalEvent.read(param1);
               break;
            case 20:
               _loc2_.value = param1.readUTF();
               break;
            case 21:
               _loc2_.value = param1.readDouble();
               break;
            case 22:
               _loc2_.value = PWarEvent.read(param1);
               break;
            case 23:
               _loc2_.value = PWarEvent.read(param1);
               break;
            case 24:
               break;
            case 25:
               _loc2_.value = PMithrilEvent.read(param1);
               break;
            case 26:
               _loc2_.value = param1.readInt();
               break;
            case 27:
               _loc2_.value = param1.readInt();
               break;
            case 28:
               _loc2_.value = POreSpellCompensation.read(param1);
               break;
            case 29:
               _loc2_.value = PClanCompPrize.read(param1);
               break;
            case 30:
               _loc2_.value = param1.readInt();
               break;
            case 31:
               _loc2_.value = new Array(param1.readUnsignedShort());
               _loc3_ = 0;
               while(_loc3_ < _loc2_.value.length)
               {
                  _loc2_.value[_loc3_] = _loc4_ = PCost.read(param1);
                  _loc3_++;
               }
               break;
            case 32:
               if(param1.readUnsignedByte() == 1)
               {
                  _loc2_.value = PSubscription.read(param1);
                  break;
               }
               _loc2_.value = null;
               break;
            default:
               throw new Error("Packet incorrect");
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeByte(this.variance);
         switch(this.variance)
         {
            case 0:
               param1.writeInt(this.value as int);
               break;
            case 1:
               param1.writeInt(this.value as int);
               break;
            case 2:
               param1.writeInt(this.value as int);
               break;
            case 3:
               param1.writeInt(this.value as int);
               break;
            case 4:
               (this.value as PNewLevelInfo).write(param1);
               break;
            case 5:
               (this.value as PQuest).write(param1);
               break;
            case 6:
               (this.value as PQuest).write(param1);
               break;
            case 7:
               (this.value as PQuestFinish).write(param1);
               break;
            case 8:
               (this.value as str_str).write(param1);
               break;
            case 9:
               (this.value as PAlinkEvent).write(param1);
               break;
            case 10:
               (this.value as i_PSign).write(param1);
               break;
            case 11:
               (this.value as i_PSign).write(param1);
               break;
            case 12:
               (this.value as i_PSign).write(param1);
               break;
            case 13:
               (this.value as i_PSign).write(param1);
               break;
            case 14:
               (this.value as time_PSign).write(param1);
               break;
            case 15:
               param1.writeUTF(this.value as String);
               break;
            case 16:
               (this.value as i_PSign).write(param1);
               break;
            case 17:
               (this.value as POffer).write(param1);
               break;
            case 18:
               param1.writeUTF(this.value as String);
               break;
            case 19:
               (this.value as PCreateCapitalEvent).write(param1);
               break;
            case 20:
               param1.writeUTF(this.value as String);
               break;
            case 21:
               param1.writeDouble(this.value as Number);
               break;
            case 22:
               (this.value as PWarEvent).write(param1);
               break;
            case 23:
               (this.value as PWarEvent).write(param1);
               break;
            case 24:
               break;
            case 25:
               (this.value as PMithrilEvent).write(param1);
               break;
            case 26:
               param1.writeInt(this.value as int);
               break;
            case 27:
               param1.writeInt(this.value as int);
               break;
            case 28:
               (this.value as POreSpellCompensation).write(param1);
               break;
            case 29:
               (this.value as PClanCompPrize).write(param1);
               break;
            case 30:
               param1.writeInt(this.value as int);
               break;
            case 31:
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
            case 32:
               if(this.value as PSubscription != null)
               {
                  param1.writeByte(1);
                  (this.value as PSubscription).write(param1);
                  break;
               }
               param1.writeByte(0);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

