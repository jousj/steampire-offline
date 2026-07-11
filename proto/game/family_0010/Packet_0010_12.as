package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0010_12 implements IClientPacket
   {
      
      public var value:Array;
      
      public function Packet_0010_12(param1:Array)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.family = 16;
         param1.subfamily = 18;
         if(this.value == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.value.length);
            _loc2_ = 0;
            while(_loc2_ < this.value.length)
            {
               param1.writeUTF(this.value[_loc2_]);
               _loc2_++;
            }
         }
      }
   }
}

