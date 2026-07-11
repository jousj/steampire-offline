package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.PAttackerInfo;
   
   public class Packet_0060_24
   {
      
      public var value:PAttackerInfo;
      
      public function Packet_0060_24(param1:IDataInput)
      {
         super();
         this.value = PAttackerInfo.read(param1);
      }
   }
}

