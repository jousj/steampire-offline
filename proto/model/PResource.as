package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PResource implements IClientPacket
   {
      
      public var last_apply_time:Number;
      
      public var done_count:uint;
      
      public function PResource()
      {
         super();
      }
      
      public static function create(param1:Number, param2:uint) : PResource
      {
         var _loc3_:PResource = new PResource();
         _loc3_.last_apply_time = param1;
         _loc3_.done_count = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PResource
      {
         var _loc2_:PResource = new PResource();
         _loc2_.last_apply_time = param1.readDouble();
         _loc2_.done_count = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeDouble(this.last_apply_time);
         param1.writeInt(this.done_count);
      }
   }
}

