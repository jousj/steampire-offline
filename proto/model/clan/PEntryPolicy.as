package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PEntryPolicy implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 3;
      
      public static const ON_DEMAND:uint = 2;
      
      public static const CLOSED:uint = 1;
      
      public static const FREE:uint = 0;
      
      public var variance:uint;
      
      public function PEntryPolicy()
      {
         super();
      }
      
      public static function create(param1:uint) : PEntryPolicy
      {
         var _loc2_:PEntryPolicy = new PEntryPolicy();
         _loc2_.variance = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PEntryPolicy
      {
         var _loc2_:PEntryPolicy = new PEntryPolicy();
         _loc2_.variance = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
      }
   }
}

