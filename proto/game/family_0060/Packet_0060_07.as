package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.clan.PRequestAnswer;
   
   public class Packet_0060_07
   {
      
      public var value:PRequestAnswer;
      
      public function Packet_0060_07(param1:IDataInput)
      {
         super();
         this.value = PRequestAnswer.read(param1);
      }
   }
}

