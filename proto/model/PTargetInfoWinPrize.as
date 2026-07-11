package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_uint;
   
   public class PTargetInfoWinPrize implements IClientPacket
   {
      
      public var costs:Array;
      
      public var units:Array;
      
      public function PTargetInfoWinPrize()
      {
         super();
      }
      
      public static function create(param1:Array, param2:Array) : PTargetInfoWinPrize
      {
         var _loc3_:PTargetInfoWinPrize = new PTargetInfoWinPrize();
         _loc3_.costs = param1;
         _loc3_.units = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PTargetInfoWinPrize
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PTargetInfoWinPrize = new PTargetInfoWinPrize();
         _loc2_.costs = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.costs.length)
         {
            _loc2_.costs[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.units = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.units.length)
         {
            _loc2_.units[_loc3_] = _loc4_ = str_uint.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(this.costs == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.costs.length);
            _loc2_ = 0;
            while(_loc2_ < this.costs.length)
            {
               this.costs[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.units == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.units.length);
            _loc2_ = 0;
            while(_loc2_ < this.units.length)
            {
               this.units[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

