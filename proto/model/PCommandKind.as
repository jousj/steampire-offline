package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCommandKind implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 5;
      
      public static const BUY_POWER:uint = 4;
      
      public static const MESSAGE:uint = 3;
      
      public static const FINISH:uint = 2;
      
      public static const SPELL:uint = 1;
      
      public static const UNIT:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PCommandKind()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PCommandKind
      {
         var _loc3_:PCommandKind = new PCommandKind();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PCommandKind
      {
         var _loc2_:PCommandKind = new PCommandKind();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = PUnitCommand.read(param1);
               break;
            case 1:
               _loc2_.value = PSpellCommand.read(param1);
               break;
            case 2:
               _loc2_.value = PFinishCommand.read(param1);
               break;
            case 3:
               _loc2_.value = param1.readUTF();
               break;
            case 4:
               _loc2_.value = param1.readInt();
               break;
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
               (this.value as PUnitCommand).write(param1);
               break;
            case 1:
               (this.value as PSpellCommand).write(param1);
               break;
            case 2:
               (this.value as PFinishCommand).write(param1);
               break;
            case 3:
               param1.writeUTF(this.value as String);
               break;
            case 4:
               param1.writeInt(this.value as int);
               break;
            case 5:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

