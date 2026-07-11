package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PObjectId implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 6;
      
      public static const UNIT:uint = 5;
      
      public static const GARBAGE:uint = 4;
      
      public static const DECOR:uint = 3;
      
      public static const FENCE:uint = 2;
      
      public static const CANNON:uint = 1;
      
      public static const BUILDING:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PObjectId()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PObjectId
      {
         var _loc3_:PObjectId = new PObjectId();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PObjectId
      {
         var _loc2_:PObjectId = new PObjectId();
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
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 3:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 4:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 5:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 6:
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
               param1.writeInt(this.value as uint);
               break;
            case 3:
               param1.writeInt(this.value as uint);
               break;
            case 4:
               param1.writeInt(this.value as uint);
               break;
            case 5:
               param1.writeInt(this.value as uint);
               break;
            case 6:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

