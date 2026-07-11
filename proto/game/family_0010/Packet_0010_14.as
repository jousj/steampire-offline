package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PAsk;
   
   public class Packet_0010_14 implements IClientPacket
   {
      
      public var value:PAsk;
      
      public function Packet_0010_14(param1:PAsk)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 16;
         param1.subfamily = 20;
         this.value.write(param1);
      }
   }
}

