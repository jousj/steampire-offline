package proto.game.family_0000
{
   import flash.utils.IDataInput;
   import proto.model.clan.PResources;
   
   public class Packet_0000_03
   {
      
      public var value:PResources;
      
      public function Packet_0000_03(param1:IDataInput)
      {
         super();
         if(param1.readUnsignedByte() == 1)
         {
            this.value = PResources.read(param1);
         }
         else
         {
            this.value = null;
         }
      }
   }
}

