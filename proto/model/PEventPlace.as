package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PEventPlace implements IClientPacket
   {
      
      public static const TERRITORY:uint = 4;
      
      public static const OTHER_CAPITAL:uint = 3;
      
      public static const ENEMY_CAPITAL:uint = 2;
      
      public static const MY_CAPITAL:uint = 1;
      
      public static const NOTHING:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PEventPlace()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PEventPlace
      {
         var _loc3_:PEventPlace = new PEventPlace();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PEventPlace
      {
         var _loc2_:PEventPlace = new PEventPlace();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
            case 1:
            case 2:
               break;
            case 3:
               _loc2_.value = param1.readUTF();
               break;
            case 4:
               _loc2_.value = param1.readUTF();
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
            case 1:
            case 2:
               break;
            case 3:
               param1.writeUTF(this.value as String);
               break;
            case 4:
               param1.writeUTF(this.value as String);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

