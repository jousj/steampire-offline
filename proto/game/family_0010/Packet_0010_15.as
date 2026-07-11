package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.model.PSign;
   
   public class Packet_0010_15
   {
      
      public var value:PSign;
      
      public function Packet_0010_15(param1:IDataInput)
      {
         super();
         if(param1.readUnsignedByte() == 1)
         {
            this.value = PSign.read(param1);
         }
         else
         {
            this.value = null;
         }
      }
   }
}

