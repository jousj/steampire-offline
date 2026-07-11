package proto.game.family_0060
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0060_1B implements IClientPacket
   {
      
      public var value:Array;
      
      public function Packet_0060_1B(param1:Array)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.family = 96;
         param1.subfamily = 27;
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
               this.value[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

