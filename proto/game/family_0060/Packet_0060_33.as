package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.clan.PSetRegent;
   
   public class Packet_0060_33 implements IClientPacket
   {
      
      public var value:PSetRegent;
      
      public function Packet_0060_33(param1:PSetRegent)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 51;
         this.value.write(param1);
      }
   }
}

