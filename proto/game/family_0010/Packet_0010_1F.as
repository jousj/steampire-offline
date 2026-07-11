package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0010_1F implements IClientPacket
   {
      
      public function Packet_0010_1F()
      {
         super();
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 16;
         param1.subfamily = 31;
      }
   }
}

