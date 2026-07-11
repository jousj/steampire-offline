package proto.game.family_0050
{
   import flash.utils.IDataInput;
   import proto.model.PCommand;
   
   public class Packet_0050_04
   {
      
      public var value:PCommand;
      
      public function Packet_0050_04(param1:IDataInput)
      {
         super();
         this.value = PCommand.read(param1);
      }
   }
}

