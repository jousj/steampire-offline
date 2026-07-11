package proto.game.family_0010
{
   import flash.utils.IDataInput;
   
   public class Packet_0010_02
   {
      
      public static const UNKNOWN:uint = 2;
      
      public static const ERROR:uint = 1;
      
      public static const OK:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function Packet_0010_02(param1:IDataInput)
      {
         super();
         this.variance = param1.readUnsignedByte();
         switch(this.variance)
         {
            case 0:
               this.value = POkUserAction.read(param1);
               break;
            case 1:
               this.value = param1.readUTF();
               break;
            case 2:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

