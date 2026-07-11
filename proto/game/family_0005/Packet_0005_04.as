package proto.game.family_0005
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0005_04 implements IClientPacket
   {
      
      public var value:String;
      
      public function Packet_0005_04(param1:String)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 5;
         param1.subfamily = 4;
         param1.writeUTF(this.value);
      }
   }
}

