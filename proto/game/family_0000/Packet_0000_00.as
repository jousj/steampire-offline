package proto.game.family_0000
{
   import flash.utils.IDataInput;
   import proto.model.PFightAttakerInfo;
   
   public class Packet_0000_00
   {
      
      public static const UNKNOWN:uint = 6;
      
      public static const ATTACKED:uint = 5;
      
      public static const WAIT_NEW_CLIENT:uint = 4;
      
      public static const OLD_CLIENT:uint = 3;
      
      public static const SOCIAL_ERROR:uint = 2;
      
      public static const CLIENT_ERROR:uint = 1;
      
      public static const INTERNAL_SERVER_ERROR:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function Packet_0000_00(param1:IDataInput)
      {
         super();
         this.variance = param1.readUnsignedByte();
         switch(this.variance)
         {
            case 0:
               break;
            case 1:
               this.value = param1.readUTF();
               break;
            case 2:
               this.value = param1.readUTF();
               break;
            case 3:
            case 4:
               break;
            case 5:
               this.value = PFightAttakerInfo.read(param1);
               break;
            case 6:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

