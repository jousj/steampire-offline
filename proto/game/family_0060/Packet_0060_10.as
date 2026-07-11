package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.clan.PSetRole;
   
   public class Packet_0060_10 implements IClientPacket
   {
      
      public var value:PSetRole;
      
      public function Packet_0060_10(param1:PSetRole)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 16;
         this.value.write(param1);
      }
   }
}

