package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0010_21 implements IClientPacket
   {
      
      public var value:uint;
      
      public function Packet_0010_21(param1:uint)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 16;
         param1.subfamily = 33;
         param1.writeInt(this.value);
      }
   }
}

