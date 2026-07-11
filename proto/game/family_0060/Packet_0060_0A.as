package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0060_0A implements IClientPacket
   {
      
      public var value:String;
      
      public function Packet_0060_0A(param1:String)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 10;
         param1.writeUTF(this.value);
      }
   }
}

