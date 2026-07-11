package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PNewLevelInfo implements IClientPacket
   {
      
      public var new_level:uint;
      
      public var new_level_sign:PSign;
      
      public function PNewLevelInfo()
      {
         super();
      }
      
      public static function create(param1:uint, param2:PSign) : PNewLevelInfo
      {
         var _loc3_:PNewLevelInfo = new PNewLevelInfo();
         _loc3_.new_level = param1;
         _loc3_.new_level_sign = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PNewLevelInfo
      {
         var _loc2_:PNewLevelInfo = new PNewLevelInfo();
         _loc2_.new_level = param1.readUnsignedShort();
         _loc2_.new_level_sign = PSign.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeShort(this.new_level);
         this.new_level_sign.write(param1);
      }
   }
}

