package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PBtype implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 15;
      
      public static const SCOUTING:uint = 14;
      
      public static const SHIELD:uint = 13;
      
      public static const LIBRARY:uint = 12;
      
      public static const RAID:uint = 11;
      
      public static const GUARD:uint = 10;
      
      public static const HERO:uint = 9;
      
      public static const CLAN:uint = 8;
      
      public static const RESEARCH:uint = 7;
      
      public static const PYLON:uint = 6;
      
      public static const STORAGE:uint = 5;
      
      public static const RESOURCE:uint = 4;
      
      public static const BARRACK:uint = 3;
      
      public static const CAMP:uint = 2;
      
      public static const WORKER:uint = 1;
      
      public static const TOWNHALL:uint = 0;
      
      public var variance:uint;
      
      public function PBtype()
      {
         super();
      }
      
      public static function create(param1:uint) : PBtype
      {
         var _loc2_:PBtype = new PBtype();
         _loc2_.variance = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PBtype
      {
         var _loc2_:PBtype = new PBtype();
         _loc2_.variance = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
      }
   }
}

