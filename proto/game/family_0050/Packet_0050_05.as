package proto.game.family_0050
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0050_05 implements IClientPacket
   {
      
      public var value:String;
      
      public function Packet_0050_05(param1:String)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 80;
         param1.subfamily = 5;
         param1.writeUTF(this.value);
      }
   }
}

