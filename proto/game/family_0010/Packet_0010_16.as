package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0010_16 implements IClientPacket
   {
      
      public var value:String;
      
      public function Packet_0010_16(param1:String)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 16;
         param1.subfamily = 22;
         param1.writeUTF(this.value);
      }
   }
}

