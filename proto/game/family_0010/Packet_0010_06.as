package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.model.PTargetInfo;
   
   public class Packet_0010_06
   {
      
      public var value:PTargetInfo;
      
      public function Packet_0010_06(param1:IDataInput)
      {
         super();
         if(param1.readUnsignedByte() == 1)
         {
            this.value = PTargetInfo.read(param1);
         }
         else
         {
            this.value = null;
         }
      }
   }
}

