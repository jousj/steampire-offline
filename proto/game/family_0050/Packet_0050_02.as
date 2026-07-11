package proto.game.family_0050
{
   import flash.utils.IDataInput;
   import proto.model.PRaidEvents;
   
   public class Packet_0050_02
   {
      
      public var value:PRaidEvents;
      
      public function Packet_0050_02(param1:IDataInput)
      {
         super();
         this.value = PRaidEvents.read(param1);
      }
   }
}

