package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanWarOpponents implements IClientPacket
   {
      
      public var new_search_at:Number;
      
      public var opponents:Array;
      
      public function PClanWarOpponents()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Array) : PClanWarOpponents
      {
         var _loc3_:PClanWarOpponents = new PClanWarOpponents();
         _loc3_.new_search_at = param1;
         _loc3_.opponents = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PClanWarOpponents
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PClanWarOpponents = new PClanWarOpponents();
         _loc2_.new_search_at = param1.readDouble();
         _loc2_.opponents = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.opponents.length)
         {
            _loc2_.opponents[_loc3_] = _loc4_ = PClanWarOpponent.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeDouble(this.new_search_at);
         if(this.opponents == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.opponents.length);
            _loc2_ = 0;
            while(_loc2_ < this.opponents.length)
            {
               this.opponents[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

