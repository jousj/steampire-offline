package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PGuard implements IClientPacket
   {
      
      public var guard_config:Array;
      
      public var guard_count:uint;
      
      public function PGuard()
      {
         super();
      }
      
      public static function create(param1:Array, param2:uint) : PGuard
      {
         var _loc3_:PGuard = new PGuard();
         _loc3_.guard_config = param1;
         _loc3_.guard_count = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PGuard
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PGuard = new PGuard();
         _loc2_.guard_config = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.guard_config.length)
         {
            _loc2_.guard_config[_loc3_] = _loc4_ = PKindCount.read(param1);
            _loc3_++;
         }
         _loc2_.guard_count = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(this.guard_config == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.guard_config.length);
            _loc2_ = 0;
            while(_loc2_ < this.guard_config.length)
            {
               this.guard_config[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeByte(this.guard_count);
      }
   }
}

