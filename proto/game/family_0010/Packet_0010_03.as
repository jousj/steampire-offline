package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0010_03 implements IClientPacket
   {
      
      public var value:PFightKind;
      
      public function Packet_0010_03(param1:PFightKind)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 16;
         param1.subfamily = 3;
         this.value.write(param1);
      }
   }
}

