package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.clan.PClan;
   
   public class Packet_0060_02
   {
      
      public var value:PClan;
      
      public function Packet_0060_02(param1:IDataInput)
      {
         super();
         this.value = PClan.read(param1);
      }
   }
}

