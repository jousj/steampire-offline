package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PPermission implements IClientPacket
   {
      
      public static const REGENT_ASSIGNER:uint = 9;
      
      public static const UNKNOWN:uint = 8;
      
      public static const INIT_WAR:uint = 7;
      
      public static const CALL_TO_PAY:uint = 6;
      
      public static const TREAS_REPORTS:uint = 5;
      
      public static const ARCHITECT:uint = 4;
      
      public static const OUST:uint = 3;
      
      public static const ROLE:uint = 2;
      
      public static const APPROVE:uint = 1;
      
      public static const INFO:uint = 0;
      
      public var variance:uint;
      
      public function PPermission()
      {
         super();
      }
      
      public static function create(param1:uint) : PPermission
      {
         var _loc2_:PPermission = new PPermission();
         _loc2_.variance = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PPermission
      {
         var _loc2_:PPermission = new PPermission();
         _loc2_.variance = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
      }
   }
}

