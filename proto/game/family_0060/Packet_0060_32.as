package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.clan.PTerritoryCommand;
   
   public class Packet_0060_32 implements IClientPacket
   {
      
      public var value:PTerritoryCommand;
      
      public function Packet_0060_32(param1:PTerritoryCommand)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 50;
         this.value.write(param1);
      }
   }
}

