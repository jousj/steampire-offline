package proto.game.family_0050
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PCommand;
   
   public class Packet_0050_03 implements IClientPacket
   {
      
      public var value:PCommand;
      
      public function Packet_0050_03(param1:PCommand)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 80;
         param1.subfamily = 3;
         this.value.write(param1);
      }
   }
}

