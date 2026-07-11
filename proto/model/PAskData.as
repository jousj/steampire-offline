package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PAskData implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 5;
      
      public static const ASK_CALL:uint = 4;
      
      public static const ASK_OIL:uint = 3;
      
      public static const ASK_CRYSTAL:uint = 2;
      
      public static const ASK_RESEARCH:uint = 1;
      
      public static const ASK_SPEED_UP:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PAskData()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PAskData
      {
         var _loc3_:PAskData = new PAskData();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PAskData
      {
         var _loc2_:PAskData = new PAskData();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 1:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 2:
            case 3:
            case 4:
            case 5:
               break;
            default:
               throw new Error("Packet incorrect");
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
         switch(this.variance)
         {
            case 0:
               param1.writeInt(this.value as uint);
               break;
            case 1:
               param1.writeInt(this.value as uint);
               break;
            case 2:
            case 3:
            case 4:
            case 5:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

