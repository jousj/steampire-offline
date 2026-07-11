package proto.game.family_0050
{
   import flash.utils.IDataInput;
   
   public class Packet_0050_06
   {
      
      public var value:PReplay;
      
      public function Packet_0050_06(param1:IDataInput)
      {
         super();
         if(param1.readUnsignedByte() == 1)
         {
            this.value = PReplay.read(param1);
         }
         else
         {
            this.value = null;
         }
      }
   }
}

