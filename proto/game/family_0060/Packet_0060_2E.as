package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.clan.PRegion;
   
   public class Packet_0060_2E
   {
      
      public var value:PRegion;
      
      public function Packet_0060_2E(param1:IDataInput)
      {
         super();
         this.value = PRegion.read(param1);
      }
   }
}

