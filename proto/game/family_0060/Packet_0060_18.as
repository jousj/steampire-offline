package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PCost;
   
   public class Packet_0060_18 implements IClientPacket
   {
      
      public var value:PCost;
      
      public function Packet_0060_18(param1:PCost)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 24;
         this.value.write(param1);
      }
   }
}

