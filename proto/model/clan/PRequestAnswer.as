package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PUserClan;
   
   public class PRequestAnswer implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 6;
      
      public static const INCORRECT_LEVEL:uint = 5;
      
      public static const ACCESS_DENY:uint = 4;
      
      public static const NO_FREE_PLACE:uint = 3;
      
      public static const ALREADY_IN_CLAN:uint = 2;
      
      public static const RECEIVED:uint = 1;
      
      public static const OK:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PRequestAnswer()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PRequestAnswer
      {
         var _loc3_:PRequestAnswer = new PRequestAnswer();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PRequestAnswer
      {
         var _loc2_:PRequestAnswer = new PRequestAnswer();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = PUserClan.read(param1);
               break;
            case 1:
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
               (this.value as PUserClan).write(param1);
               break;
            case 1:
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

