package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.model.PFightRequestResult;
   
   public class Packet_0010_04
   {
      
      public var value:PFightRequestResult;
      
      public function Packet_0010_04(param1:IDataInput)
      {
         super();
         this.value = PFightRequestResult.read(param1);
      }
   }
}

