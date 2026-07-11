package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCeventFrom implements IClientPacket
   {
      
      public static const O_ID:uint = 1;
      
      public static const TIME:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PCeventFrom()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PCeventFrom
      {
         var _loc3_:PCeventFrom = new PCeventFrom();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PCeventFrom
      {
         var _loc2_:PCeventFrom = new PCeventFrom();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = param1.readDouble();
               break;
            case 1:
               _loc2_.value = param1.readInt();
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
               param1.writeDouble(this.value as Number);
               break;
            case 1:
               param1.writeInt(this.value as int);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

