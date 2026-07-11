package proto.game.family_0002
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PFightKind2;
   
   public class Packet_0002_01 implements IClientPacket
   {
      
      public static const CLAN_TERRITORIES_ATTACK:uint = 7;
      
      public static const TO_TERRITORY_STORM:uint = 6;
      
      public static const TERRITORY_INFO:uint = 5;
      
      public static const WATCH_STORM:uint = 4;
      
      public static const CHECK_FINISH_WAR:uint = 3;
      
      public static const GET_TARGET:uint = 2;
      
      public static const ENTER_STORM:uint = 1;
      
      public static const GET_LOCATION:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function Packet_0002_01(param1:uint, param2:*)
      {
         super();
         this.variance = param1;
         this.value = param2;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 2;
         param1.subfamily = 1;
         param1.writeByte(this.variance);
         switch(this.variance)
         {
            case 0:
               break;
            case 1:
               param1.writeBoolean(this.value as Boolean);
               break;
            case 2:
               (this.value as PFightKind2).write(param1);
               break;
            case 3:
               break;
            case 4:
               param1.writeUTF(this.value as String);
               break;
            case 5:
               param1.writeUTF(this.value as String);
               break;
            case 6:
               param1.writeUTF(this.value as String);
               break;
            case 7:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

