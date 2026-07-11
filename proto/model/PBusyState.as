package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PBusyState implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 3;
      
      public static const ONLINE:uint = 2;
      
      public static const SHIELD:uint = 1;
      
      public static const ATTACKED:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PBusyState()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PBusyState
      {
         var _loc3_:PBusyState = new PBusyState();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PBusyState
      {
         var _loc2_:PBusyState = new PBusyState();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               break;
            case 1:
               _loc2_.value = param1.readDouble();
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
               break;
            case 1:
               param1.writeDouble(this.value as Number);
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

