package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PFightKind implements IClientPacket
   {
      
      public static const ADVENTURE:uint = 4;
      
      public static const JAINA_MISSION:uint = 3;
      
      public static const RAID:uint = 2;
      
      public static const EXT_MISSION:uint = 1;
      
      public static const MISSION:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PFightKind()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PFightKind
      {
         var _loc3_:PFightKind = new PFightKind();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PFightKind
      {
         var _loc2_:PFightKind = new PFightKind();
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
               _loc2_.value = PCreateRaid.read(param1);
               break;
            case 3:
            case 4:
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
               (this.value as PCreateRaid).write(param1);
               break;
            case 3:
            case 4:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

