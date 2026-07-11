package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.clan.PApproveAnswer;
   
   public class Packet_0060_09
   {
      
      public var value:PApproveAnswer;
      
      public function Packet_0060_09(param1:IDataInput)
      {
         super();
         this.value = PApproveAnswer.read(param1);
      }
   }
}

