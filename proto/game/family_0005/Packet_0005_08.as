package proto.game.family_0005
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0005_08 implements IClientPacket
   {
      
      public var value:uint;
      
      public function Packet_0005_08(param1:uint)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 5;
         param1.subfamily = 8;
         param1.writeInt(this.value);
      }
   }
}

