package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class time_PSign implements IClientPacket
   {
      
      public var field_0:Number;
      
      public var field_1:PSign;
      
      public function time_PSign()
      {
         super();
      }
      
      public static function create(param1:Number, param2:PSign) : time_PSign
      {
         var _loc3_:time_PSign = new time_PSign();
         _loc3_.field_0 = param1;
         _loc3_.field_1 = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : time_PSign
      {
         var _loc2_:time_PSign = new time_PSign();
         _loc2_.field_0 = param1.readDouble();
         _loc2_.field_1 = PSign.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeDouble(this.field_0);
         this.field_1.write(param1);
      }
   }
}

