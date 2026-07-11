package proto.game.family_0050
{
   import flash.utils.IDataInput;
   import proto.model.PTopRes;
   
   public class Packet_0050_0A
   {
      
      public var value:PTopRes;
      
      public function Packet_0050_0A(param1:IDataInput)
      {
         super();
         this.value = PTopRes.read(param1);
      }
   }
}

