package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.clan.PCapital;
   
   public class Packet_0060_1A
   {
      
      public var value:PCapital;
      
      public function Packet_0060_1A(param1:IDataInput)
      {
         super();
         this.value = PCapital.read(param1);
      }
   }
}

