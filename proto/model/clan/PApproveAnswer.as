package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PApproveAnswer implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 6;
      
      public static const NO_FREE_PLACE:uint = 5;
      
      public static const NO_PERMISSIONS:uint = 4;
      
      public static const NO_SUCH_REQUEST:uint = 3;
      
      public static const USER_ALREADY_IN_CLAN:uint = 2;
      
      public static const NEW_MEMBER:uint = 1;
      
      public static const REMOVE_REQUEST:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PApproveAnswer()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PApproveAnswer
      {
         var _loc3_:PApproveAnswer = new PApproveAnswer();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PApproveAnswer
      {
         var _loc2_:PApproveAnswer = new PApproveAnswer();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = param1.readUTF();
               break;
            case 1:
               _loc2_.value = PMember.read(param1);
               break;
            case 2:
            case 3:
            case 4:
            case 5:
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
               param1.writeUTF(this.value as String);
               break;
            case 1:
               (this.value as PMember).write(param1);
               break;
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

