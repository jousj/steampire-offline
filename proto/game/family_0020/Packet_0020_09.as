package proto.game.family_0020
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PClientSimRes;
   
   public class Packet_0020_09 implements IClientPacket
   {
      
      public var value:PClientSimRes;
      
      public function Packet_0020_09(param1:PClientSimRes)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 32;
         param1.subfamily = 9;
         this.value.write(param1);
      }
   }
}

