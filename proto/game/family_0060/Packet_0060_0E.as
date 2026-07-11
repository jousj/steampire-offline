package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.clan.PBase;
   
   public class Packet_0060_0E
   {
      
      public var value:PBase;
      
      public function Packet_0060_0E(param1:IDataInput)
      {
         super();
         this.value = PBase.read(param1);
      }
   }
}

