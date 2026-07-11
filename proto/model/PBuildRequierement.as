package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PBuildRequierement implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 1;
      
      public static const JAINA_MISSION:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PBuildRequierement()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PBuildRequierement
      {
         var _loc3_:PBuildRequierement = new PBuildRequierement();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PBuildRequierement
      {
         var _loc2_:PBuildRequierement = new PBuildRequierement();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = param1.readUTF();
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
               param1.writeUTF(this.value as String);
               break;
            case 1:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

