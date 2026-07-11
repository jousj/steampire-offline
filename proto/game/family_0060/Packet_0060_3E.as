package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.PUserClanPointsAnswer;
   
   public class Packet_0060_3E
   {
      
      public var value:PUserClanPointsAnswer;
      
      public function Packet_0060_3E(param1:IDataInput)
      {
         super();
         this.value = PUserClanPointsAnswer.read(param1);
      }
   }
}

