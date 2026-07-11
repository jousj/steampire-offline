package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.clan.PSendMessage;
   
   public class Packet_0060_12 implements IClientPacket
   {
      
      public var value:PSendMessage;
      
      public function Packet_0060_12(param1:PSendMessage)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 18;
         this.value.write(param1);
      }
   }
}

