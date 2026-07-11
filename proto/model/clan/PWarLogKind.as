package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_i;
   
   public class PWarLogKind implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 4;
      
      public static const USE_SPELL:uint = 3;
      
      public static const USE_UNIT:uint = 2;
      
      public static const USE_WORKER:uint = 1;
      
      public static const WAR_PVP:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PWarLogKind()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PWarLogKind
      {
         var _loc3_:PWarLogKind = new PWarLogKind();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PWarLogKind
      {
         var _loc2_:PWarLogKind = new PWarLogKind();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = PWarPvp.read(param1);
               break;
            case 1:
               _loc2_.value = str_i.read(param1);
               break;
            case 2:
               _loc2_.value = str_i.read(param1);
               break;
            case 3:
               _loc2_.value = str_i.read(param1);
               break;
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
               (this.value as PWarPvp).write(param1);
               break;
            case 1:
               (this.value as str_i).write(param1);
               break;
            case 2:
               (this.value as str_i).write(param1);
               break;
            case 3:
               (this.value as str_i).write(param1);
               break;
            case 4:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

