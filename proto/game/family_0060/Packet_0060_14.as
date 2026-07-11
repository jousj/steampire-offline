package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0060_14 implements IClientPacket
   {
      
      public var value:String;
      
      public function Packet_0060_14(param1:String)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 96;
         param1.subfamily = 20;
         param1.writeUTF(this.value);
      }
   }
}

