package proto.tuples
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class i_i implements IClientPacket
   {
      
      public var field_0:int;
      
      public var field_1:int;
      
      public function i_i()
      {
         super();
      }
      
      public static function create(param1:int, param2:int) : i_i
      {
         var _loc3_:i_i = new i_i();
         _loc3_.field_0 = param1;
         _loc3_.field_1 = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : i_i
      {
         var _loc2_:i_i = new i_i();
         _loc2_.field_0 = param1.readInt();
         _loc2_.field_1 = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.field_0);
         param1.writeInt(this.field_1);
      }
   }
}

