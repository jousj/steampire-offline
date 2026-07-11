package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_i;
   
   public class POfferGoods implements IClientPacket
   {
      
      public static const SCOUTING:uint = 7;
      
      public static const UNKNOWN:uint = 6;
      
      public static const CLAN_CAPITAL:uint = 5;
      
      public static const SHIELD:uint = 4;
      
      public static const UPGRADE:uint = 3;
      
      public static const BUY:uint = 2;
      
      public static const UNIT:uint = 1;
      
      public static const COST:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function POfferGoods()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : POfferGoods
      {
         var _loc3_:POfferGoods = new POfferGoods();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : POfferGoods
      {
         var _loc2_:POfferGoods = new POfferGoods();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = PCost.read(param1);
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
               _loc2_.value = param1.readDouble();
               break;
            case 5:
            case 6:
               break;
            case 7:
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
               (this.value as PCost).write(param1);
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
               param1.writeDouble(this.value as Number);
               break;
            case 5:
            case 6:
               break;
            case 7:
               param1.writeInt(this.value as int);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

