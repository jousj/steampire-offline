package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.PClanWarOpponents;
   
   public class Packet_0060_36
   {
      
      public var value:PClanWarOpponents;
      
      public function Packet_0060_36(param1:IDataInput)
      {
         super();
         this.value = PClanWarOpponents.read(param1);
      }
   }
}

