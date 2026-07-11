package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.clan.PCreateClan;
   
   public class Packet_0060_01 implements IClientPacket
   {
      
      public var value:PCreateClan;
      
      public function Packet_0060_01(param1:PCreateClan)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 1;
         this.value.write(param1);
      }
   }
}

