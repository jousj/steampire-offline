package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PAskValue implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 2;
      
      public static const COUNT:uint = 1;
      
      public static const TIME:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PAskValue()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PAskValue
      {
         var _loc3_:PAskValue = new PAskValue();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PAskValue
      {
         var _loc2_:PAskValue = new PAskValue();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = param1.readDouble();
               break;
            case 1:
               _loc2_.value = param1.readInt();
               break;
            case 2:
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
               param1.writeDouble(this.value as Number);
               break;
            case 1:
               param1.writeInt(this.value as int);
               break;
            case 2:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

