package proto.game.family_0050
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PPoesd;
   
   public class Packet_0050_0B implements IClientPacket
   {
      
      public var value:PPoesd;
      
      public function Packet_0050_0B(param1:PPoesd)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 80;
         param1.subfamily = 11;
         this.value.write(param1);
      }
   }
}

