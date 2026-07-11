package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanWarOpponent implements IClientPacket
   {
      
      public static const NONE:uint = 2;
      
      public static const WAIT_SEARCH:uint = 1;
      
      public static const READY:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PClanWarOpponent()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PClanWarOpponent
      {
         var _loc3_:PClanWarOpponent = new PClanWarOpponent();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PClanWarOpponent
      {
         var _loc2_:PClanWarOpponent = new PClanWarOpponent();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = PWarOpponent.read(param1);
               break;
            case 1:
               _loc2_.value = param1.readDouble();
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
               (this.value as PWarOpponent).write(param1);
               break;
            case 1:
               param1.writeDouble(this.value as Number);
               break;
            case 2:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

