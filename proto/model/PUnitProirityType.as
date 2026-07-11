package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PUnitProirityType implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 5;
      
      public static const RESOURCE:uint = 4;
      
      public static const CANNON:uint = 3;
      
      public static const FENCE:uint = 2;
      
      public static const BUILDING:uint = 1;
      
      public static const ANY:uint = 0;
      
      public var variance:uint;
      
      public function PUnitProirityType()
      {
         super();
      }
      
      public static function create(param1:uint) : PUnitProirityType
      {
         var _loc2_:PUnitProirityType = new PUnitProirityType();
         _loc2_.variance = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PUnitProirityType
      {
         var _loc2_:PUnitProirityType = new PUnitProirityType();
         _loc2_.variance = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
      }
   }
}

