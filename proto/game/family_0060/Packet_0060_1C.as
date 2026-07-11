package proto.game.family_0060
{
   import flash.utils.IDataInput;
   
   public class Packet_0060_1C
   {
      
      public var value:Number;
      
      public function Packet_0060_1C(param1:IDataInput)
      {
         super();
         this.value = param1.readDouble();
      }
   }
}

