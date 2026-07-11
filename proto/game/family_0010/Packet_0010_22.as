package proto.game.family_0010
{
   import flash.utils.IDataInput;
   
   public class Packet_0010_22
   {
      
      public var value:Number;
      
      public function Packet_0010_22(param1:IDataInput)
      {
         super();
         this.value = param1.readDouble();
      }
   }
}

