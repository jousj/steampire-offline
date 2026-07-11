package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PCommand;
   
   public class Packet_0060_25 implements IClientPacket
   {
      
      public var value:PCommand;
      
      public function Packet_0060_25(param1:PCommand)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 37;
         this.value.write(param1);
      }
   }
}

