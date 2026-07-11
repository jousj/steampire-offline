package proto.game.family_0050
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PCevent;
   
   public class Packet_0050_01 implements IClientPacket
   {
      
      public var value:PCevent;
      
      public function Packet_0050_01(param1:PCevent)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 80;
         param1.subfamily = 1;
         this.value.write(param1);
      }
   }
}

