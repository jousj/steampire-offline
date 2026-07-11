package proto.game.family_0005
{
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PSettingsGame;
   
   public class Packet_0005_07 implements IClientPacket
   {
      
      public var value:PSettingsGame;
      
      public function Packet_0005_07(param1:PSettingsGame)
      {
         super();
         this.value = param1;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.family = 5;
         param1.subfamily = 7;
         this.value.write(param1);
      }
   }
}

