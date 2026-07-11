package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0010_23 implements IClientPacket
   {
      
      public var value:int;
      
      public function Packet_0010_23(param1:int)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 16;
         param1.subfamily = 35;
         param1.writeInt(this.value);
      }
   }
}

