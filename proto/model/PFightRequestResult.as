package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PFightRequestResult implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 3;
      
      public static const NO_TARGET:uint = 2;
      
      public static const GROUP:uint = 1;
      
      public static const FIGHT:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PFightRequestResult()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PFightRequestResult
      {
         var _loc3_:PFightRequestResult = new PFightRequestResult();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PFightRequestResult
      {
         var _loc2_:PFightRequestResult = new PFightRequestResult();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = PTargetInfo.read(param1);
               break;
            case 1:
               _loc2_.value = PGroupFightInfo.read(param1);
               break;
            case 2:
            case 3:
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
               (this.value as PTargetInfo).write(param1);
               break;
            case 1:
               (this.value as PGroupFightInfo).write(param1);
               break;
            case 2:
            case 3:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

