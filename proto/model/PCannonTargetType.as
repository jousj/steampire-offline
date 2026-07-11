package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCannonTargetType implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 3;
      
      public static const AIR:uint = 2;
      
      public static const GROUND:uint = 1;
      
      public static const ANY:uint = 0;
      
      public var variance:uint;
      
      public function PCannonTargetType()
      {
         super();
      }
      
      public static function create(param1:uint) : PCannonTargetType
      {
         var _loc2_:PCannonTargetType = new PCannonTargetType();
         _loc2_.variance = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PCannonTargetType
      {
         var _loc2_:PCannonTargetType = new PCannonTargetType();
         _loc2_.variance = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
      }
   }
}

