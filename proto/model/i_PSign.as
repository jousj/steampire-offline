package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class i_PSign implements IClientPacket
   {
      
      public var field_0:int;
      
      public var field_1:PSign;
      
      public function i_PSign()
      {
         super();
      }
      
      public static function create(param1:int, param2:PSign) : i_PSign
      {
         var _loc3_:i_PSign = new i_PSign();
         _loc3_.field_0 = param1;
         _loc3_.field_1 = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : i_PSign
      {
         var _loc2_:i_PSign = new i_PSign();
         _loc2_.field_0 = param1.readInt();
         _loc2_.field_1 = PSign.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.field_0);
         this.field_1.write(param1);
      }
   }
}

