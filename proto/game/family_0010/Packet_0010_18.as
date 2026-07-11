package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0010_18 implements IClientPacket
   {
      
      public var value:Boolean;
      
      public function Packet_0010_18(param1:Boolean)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 16;
         param1.subfamily = 24;
         param1.writeBoolean(this.value);
      }
   }
}

