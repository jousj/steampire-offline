package proto.game.family_0060
{
   import flash.utils.IDataInput;
   import proto.model.clan.PClanTop;
   
   public class Packet_0060_1E
   {
      
      public var value:Array;
      
      public function Packet_0060_1E(param1:IDataInput)
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         super();
         this.value = new Array(param1.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < this.value.length)
         {
            this.value[_loc2_] = _loc3_ = PClanTop.read(param1);
            _loc2_++;
         }
      }
   }
}

