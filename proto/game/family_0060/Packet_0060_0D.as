package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.clan.PChangeClan;
   
   public class Packet_0060_0D implements IClientPacket
   {
      
      public var value:PChangeClan;
      
      public function Packet_0060_0D(param1:PChangeClan)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 13;
         this.value.write(param1);
      }
   }
}

