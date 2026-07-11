package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PApplyRaidInvite;
   
   public class Packet_0010_0F implements IClientPacket
   {
      
      public var value:PApplyRaidInvite;
      
      public function Packet_0010_0F(param1:PApplyRaidInvite)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 16;
         param1.subfamily = 15;
         this.value.write(param1);
      }
   }
}

