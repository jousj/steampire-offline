package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PClanCompTopRequest;
   
   public class Packet_0060_39 implements IClientPacket
   {
      
      public var value:PClanCompTopRequest;
      
      public function Packet_0060_39(param1:PClanCompTopRequest)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 57;
         this.value.write(param1);
      }
   }
}

