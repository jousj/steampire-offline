package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PFightType implements IClientPacket
   {
      
      public static const ADVENTURE:uint = 6;
      
      public static const JAINA_MISSION:uint = 5;
      
      public static const UNKNOWN:uint = 4;
      
      public static const GROUP:uint = 3;
      
      public static const SINGLE:uint = 2;
      
      public static const EXT_MISSION:uint = 1;
      
      public static const MISSION:uint = 0;
      
      public static const STORM:uint = 100;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PFightType()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PFightType
      {
         var _loc3_:PFightType = new PFightType();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PFightType
      {
         var _loc2_:PFightType = new PFightType();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = param1.readUTF();
               break;
            case 1:
               _loc2_.value = param1.readUTF();
               break;
            case 2:
               break;
            case 3:
               _loc2_.value = PGroupFightInfo.read(param1);
               break;
            case 4:
               break;
            case 5:
               _loc2_.value = PJainaMission.read(param1);
               break;
            case 6:
               _loc2_.value = PCurrentAdventure.read(param1);
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
               param1.writeUTF(this.value as String);
               break;
            case 2:
               break;
            case 3:
               (this.value as PGroupFightInfo).write(param1);
               break;
            case 4:
               break;
            case 5:
               (this.value as PJainaMission).write(param1);
               break;
            case 6:
               (this.value as PCurrentAdventure).write(param1);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

