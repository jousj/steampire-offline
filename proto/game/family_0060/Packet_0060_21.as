package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.clan.PWar;
   
   public class Packet_0060_21
   {
      
      public var value:PWar;
      
      public function Packet_0060_21(param1:IDataInput)
      {
         super();
         this.value = PWar.read(param1);
      }
   }
}

