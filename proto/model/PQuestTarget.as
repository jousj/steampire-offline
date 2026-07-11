package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PQuestTarget implements IClientPacket
   {
      
      public static const QTDONE:uint = 1;
      
      public static const QTOPEN:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PQuestTarget()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PQuestTarget
      {
         var _loc3_:PQuestTarget = new PQuestTarget();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PQuestTarget
      {
         var _loc2_:PQuestTarget = new PQuestTarget();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 1:
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
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

