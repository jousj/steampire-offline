package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PClanCompPlaceRequest;
   
   public class Packet_0060_3B implements IClientPacket
   {
      
      public var value:PClanCompPlaceRequest;
      
      public function Packet_0060_3B(param1:PClanCompPlaceRequest)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 59;
         this.value.write(param1);
      }
   }
}

