package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.PHallOfFame;
   
   public class Packet_0060_40
   {
      
      public var value:PHallOfFame;
      
      public function Packet_0060_40(param1:IDataInput)
      {
         super();
         this.value = PHallOfFame.read(param1);
      }
   }
}

