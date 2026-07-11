package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.PClanCompPlaceAnswer;
   
   public class Packet_0060_3C
   {
      
      public var value:PClanCompPlaceAnswer;
      
      public function Packet_0060_3C(param1:IDataInput)
      {
         super();
         this.value = PClanCompPlaceAnswer.read(param1);
      }
   }
}

