package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0010_01 implements IClientPacket
   {
      
      public var actions:Array;
      
      public var fetch_events:Boolean;
      
      public function Packet_0010_01(param1:Array, param2:Boolean)
      {
         super();
         this.actions = param1;
         this.fetch_events = param2;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.family = 16;
         param1.subfamily = 1;
         if(this.actions == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.actions.length);
            _loc2_ = 0;
            while(_loc2_ < this.actions.length)
            {
               this.actions[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeBoolean(this.fetch_events);
      }
   }
}

