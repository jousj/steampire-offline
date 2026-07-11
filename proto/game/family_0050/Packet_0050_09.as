package proto.game.family_0050
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PUserTopRequest;
   
   public class Packet_0050_09 implements IClientPacket
   {
      
      public var value:PUserTopRequest;
      
      public function Packet_0050_09(param1:PUserTopRequest)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 80;
         param1.subfamily = 9;
         this.value.write(param1);
      }
   }
}

