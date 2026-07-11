package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PObjType implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 5;
      
      public static const GARBAGE:uint = 4;
      
      public static const DECOR:uint = 3;
      
      public static const FENCE:uint = 2;
      
      public static const CANNON:uint = 1;
      
      public static const BUILDING:uint = 0;
      
      public var variance:uint;
      
      public function PObjType()
      {
         super();
      }
      
      public static function create(param1:uint) : PObjType
      {
         var _loc2_:PObjType = new PObjType();
         _loc2_.variance = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PObjType
      {
         var _loc2_:PObjType = new PObjType();
         _loc2_.variance = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
      }
   }
}

