package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0060_17 implements IClientPacket
   {
      
      public function Packet_0060_17()
      {
         super();
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 23;
      }
   }
}

