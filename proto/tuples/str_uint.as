package proto.tuples
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class str_uint implements IClientPacket
   {
      
      public var field_0:String;
      
      public var field_1:uint;
      
      public function str_uint()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint) : str_uint
      {
         var _loc3_:str_uint = new str_uint();
         _loc3_.field_0 = param1;
         _loc3_.field_1 = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : str_uint
      {
         var _loc2_:str_uint = new str_uint();
         _loc2_.field_0 = param1.readUTF();
         _loc2_.field_1 = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.field_0);
         param1.writeInt(this.field_1);
      }
   }
}

