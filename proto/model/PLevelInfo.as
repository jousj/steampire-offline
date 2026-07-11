package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PLevelInfo implements IClientPacket
   {
      
      public var l_id:uint;
      
      public var l_require:uint;
      
      public var l_bonus:Array;
      
      public var l_max_ratio:uint;
      
      public function PLevelInfo()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:Array, param4:uint) : PLevelInfo
      {
         var _loc5_:PLevelInfo = new PLevelInfo();
         _loc5_.l_id = param1;
         _loc5_.l_require = param2;
         _loc5_.l_bonus = param3;
         _loc5_.l_max_ratio = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PLevelInfo
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PLevelInfo = new PLevelInfo();
         _loc2_.l_id = param1.readUnsignedInt();
         _loc2_.l_require = param1.readUnsignedInt();
         _loc2_.l_bonus = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.l_bonus.length)
         {
            _loc2_.l_bonus[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.l_max_ratio = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.l_id);
         param1.writeInt(this.l_require);
         if(this.l_bonus == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.l_bonus.length);
            _loc2_ = 0;
            while(_loc2_ < this.l_bonus.length)
            {
               this.l_bonus[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.l_max_ratio);
      }
   }
}

