package proto.game.family_0010
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class Packet_0010_05 implements IClientPacket
   {
      
      public var id:String;
      
      public var is_mission:Boolean;
      
      public function Packet_0010_05(param1:String, param2:Boolean)
      {
         super();
         this.id = param1;
         this.is_mission = param2;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 16;
         param1.subfamily = 5;
         param1.writeUTF(this.id);
         param1.writeBoolean(this.is_mission);
      }
   }
}

