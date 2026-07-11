package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PRole implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 9;
      
      public static const WARLORD:uint = 8;
      
      public static const TREASURER:uint = 7;
      
      public static const VETERAN:uint = 6;
      
      public static const ARCHITECT:uint = 5;
      
      public static const BEGINNER:uint = 4;
      
      public static const SOLDIER:uint = 3;
      
      public static const ANCIENT:uint = 2;
      
      public static const SUB_CREATOR:uint = 1;
      
      public static const CREATOR:uint = 0;
      
      public var variance:uint;
      
      public function PRole()
      {
         super();
      }
      
      public static function create(param1:uint) : PRole
      {
         var _loc2_:PRole = new PRole();
         _loc2_.variance = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PRole
      {
         var _loc2_:PRole = new PRole();
         _loc2_.variance = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
      }
   }
}

