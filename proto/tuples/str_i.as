package proto.tuples
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class str_i implements IClientPacket
   {
      
      public var field_0:String;
      
      public var field_1:int;
      
      public function str_i()
      {
         super();
      }
      
      public static function create(param1:String, param2:int) : str_i
      {
         var _loc3_:str_i = new str_i();
         _loc3_.field_0 = param1;
         _loc3_.field_1 = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : str_i
      {
         var _loc2_:str_i = new str_i();
         _loc2_.field_0 = param1.readUTF();
         _loc2_.field_1 = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.field_0);
         param1.writeInt(this.field_1);
      }
   }
}

