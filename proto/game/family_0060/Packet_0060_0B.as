package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.clan.PClan;
   
   public class Packet_0060_0B
   {
      
      public var value:PClan;
      
      public function Packet_0060_0B(param1:IDataInput)
      {
         super();
         this.value = PClan.read(param1);
      }
   }
}

