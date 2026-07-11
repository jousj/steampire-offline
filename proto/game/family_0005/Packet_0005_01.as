package proto.game.family_0005
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0005_01 implements IClientPacket
   {
      
      public function Packet_0005_01()
      {
         super();
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 5;
         param1.subfamily = 1;
      }
   }
}

