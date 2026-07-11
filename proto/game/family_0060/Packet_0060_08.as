package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.clan.PApprove;
   
   public class Packet_0060_08 implements IClientPacket
   {
      
      public var value:PApprove;
      
      public function Packet_0060_08(param1:PApprove)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 8;
         this.value.write(param1);
      }
   }
}

