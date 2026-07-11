package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PFightKind2 implements IClientPacket
   {
      
      public static const USER_WAR_TARGET:uint = 3;
      
      public static const REVENGE:uint = 2;
      
      public static const USER_WAR:uint = 1;
      
      public static const USER:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PFightKind2()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PFightKind2
      {
         var _loc3_:PFightKind2 = new PFightKind2();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PFightKind2
      {
         var _loc2_:PFightKind2 = new PFightKind2();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
            case 1:
               break;
            case 2:
               _loc2_.value = param1.readUTF();
               break;
            case 3:
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
               break;
            case 2:
               param1.writeUTF(this.value as String);
               break;
            case 3:
               param1.writeUTF(this.value as String);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

