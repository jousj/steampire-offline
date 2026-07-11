package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PBuildState implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 2;
      
      public static const IN_PROGRESS:uint = 1;
      
      public static const FINISHED:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PBuildState()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PBuildState
      {
         var _loc3_:PBuildState = new PBuildState();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PBuildState
      {
         var _loc2_:PBuildState = new PBuildState();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
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

