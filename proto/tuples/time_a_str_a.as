package proto.tuples
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class time_a_str_a implements IClientPacket
   {
      
      public var field_0:Number;
      
      public var field_1:Array;
      
      public function time_a_str_a()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Array) : time_a_str_a
      {
         var _loc3_:time_a_str_a = new time_a_str_a();
         _loc3_.field_0 = param1;
         _loc3_.field_1 = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : time_a_str_a
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:time_a_str_a = new time_a_str_a();
         _loc2_.field_0 = param1.readDouble();
         _loc2_.field_1 = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.field_1.length)
         {
            _loc2_.field_1[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeDouble(this.field_0);
         if(this.field_1 == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.field_1.length);
            _loc2_ = 0;
            while(_loc2_ < this.field_1.length)
            {
               param1.writeUTF(this.field_1[_loc2_]);
               _loc2_++;
            }
         }
      }
   }
}

