package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0010_1B implements IClientPacket
   {
      
      public var value:String;
      
      public function Packet_0010_1B(param1:String)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 16;
         param1.subfamily = 27;
         param1.writeUTF(this.value);
      }
   }
}

