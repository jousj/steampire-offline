package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.PClanCompTopAnswer;
   
   public class Packet_0060_3A
   {
      
      public var value:PClanCompTopAnswer;
      
      public function Packet_0060_3A(param1:IDataInput)
      {
         super();
         this.value = PClanCompTopAnswer.read(param1);
      }
   }
}

