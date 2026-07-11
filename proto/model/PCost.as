package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCost implements IClientPacket
   {
      
      public static const RUBY:uint = 16;
      
      public static const CLAN_POINTS:uint = 15;
      
      public static const RAR_DRAGON:uint = 14;
      
      public static const J_GLORY:uint = 13;
      
      public static const BLUE_PRINT:uint = 12;
      
      public static const TROPHY:uint = 11;
      
      public static const UNKNOWN:uint = 10;
      
      public static const MITHRIL:uint = 9;
      
      public static const BLUE_ORE:uint = 8;
      
      public static const GREEN_ORE:uint = 7;
      
      public static const RED_ORE:uint = 6;
      
      public static const CALL:uint = 5;
      
      public static const H_GLORY:uint = 4;
      
      public static const EXP:uint = 3;
      
      public static const OIL:uint = 2;
      
      public static const CRYSTAL:uint = 1;
      
      public static const GOLD:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PCost()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PCost
      {
         var _loc3_:PCost = new PCost();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PCost
      {
         var _loc2_:PCost = new PCost();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 1:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 2:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 3:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 4:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 5:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 6:
               _loc2_.value = param1.readInt();
               break;
            case 7:
               _loc2_.value = param1.readInt();
               break;
            case 8:
               _loc2_.value = param1.readInt();
               break;
            case 9:
               _loc2_.value = param1.readInt();
               break;
            case 10:
               break;
            case 11:
               _loc2_.value = param1.readInt();
               break;
            case 12:
               _loc2_.value = param1.readInt();
               break;
            case 13:
               _loc2_.value = param1.readInt();
               break;
            case 14:
               _loc2_.value = param1.readInt();
               break;
            case 15:
               _loc2_.value = param1.readInt();
               break;
            case 16:
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
               param1.writeInt(this.value as uint);
               break;
            case 1:
               param1.writeInt(this.value as uint);
               break;
            case 2:
               param1.writeInt(this.value as uint);
               break;
            case 3:
               param1.writeInt(this.value as uint);
               break;
            case 4:
               param1.writeInt(this.value as uint);
               break;
            case 5:
               param1.writeInt(this.value as uint);
               break;
            case 6:
               param1.writeInt(this.value as int);
               break;
            case 7:
               param1.writeInt(this.value as int);
               break;
            case 8:
               param1.writeInt(this.value as int);
               break;
            case 9:
               param1.writeInt(this.value as int);
               break;
            case 10:
               break;
            case 11:
               param1.writeInt(this.value as int);
               break;
            case 12:
               param1.writeInt(this.value as int);
               break;
            case 13:
               param1.writeInt(this.value as int);
               break;
            case 14:
               param1.writeInt(this.value as int);
               break;
            case 15:
               param1.writeInt(this.value as int);
               break;
            case 16:
               param1.writeInt(this.value as int);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

