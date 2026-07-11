package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PHeroUpgradeKind implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 4;
      
      public static const RECOVER:uint = 3;
      
      public static const DAMAGE:uint = 2;
      
      public static const ARMOR:uint = 1;
      
      public static const STAMINA:uint = 0;
      
      public var variance:uint;
      
      public function PHeroUpgradeKind()
      {
         super();
      }
      
      public static function create(param1:uint) : PHeroUpgradeKind
      {
         var _loc2_:PHeroUpgradeKind = new PHeroUpgradeKind();
         _loc2_.variance = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PHeroUpgradeKind
      {
         var _loc2_:PHeroUpgradeKind = new PHeroUpgradeKind();
         _loc2_.variance = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
      }
   }
}

