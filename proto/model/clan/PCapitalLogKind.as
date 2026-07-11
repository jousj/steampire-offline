package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PCost;
   import proto.tuples.str_i;
   
   public class PCapitalLogKind implements IClientPacket
   {
      
      public static const ATTACK_TERRITORY:uint = 14;
      
      public static const UPGRADE_TERRITORY:uint = 13;
      
      public static const UNKNOWN:uint = 12;
      
      public static const LOSE_WAR:uint = 11;
      
      public static const WIN_WAR:uint = 10;
      
      public static const START_WAR:uint = 9;
      
      public static const BUY_CAPITAL:uint = 8;
      
      public static const SELL_DECOR:uint = 7;
      
      public static const BUY_RESOURCES:uint = 6;
      
      public static const REMOVE_GARBAGE:uint = 5;
      
      public static const CANCEL:uint = 4;
      
      public static const DONATE:uint = 3;
      
      public static const SPEEDUP:uint = 2;
      
      public static const UPGRADE:uint = 1;
      
      public static const BUY:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PCapitalLogKind()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PCapitalLogKind
      {
         var _loc3_:PCapitalLogKind = new PCapitalLogKind();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PCapitalLogKind
      {
         var _loc2_:PCapitalLogKind = new PCapitalLogKind();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = param1.readUTF();
               break;
            case 1:
               _loc2_.value = str_i.read(param1);
               break;
            case 2:
               _loc2_.value = str_i.read(param1);
               break;
            case 3:
               break;
            case 4:
               _loc2_.value = str_i.read(param1);
               break;
            case 5:
               break;
            case 6:
               _loc2_.value = PCost.read(param1);
               break;
            case 7:
               _loc2_.value = param1.readUTF();
               break;
            case 8:
            case 9:
               break;
            case 10:
               _loc2_.value = param1.readInt();
               break;
            case 11:
               _loc2_.value = param1.readInt();
               break;
            case 12:
               break;
            case 13:
               _loc2_.value = str_i.read(param1);
               break;
            case 14:
               _loc2_.value = str_i.read(param1);
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
               (this.value as str_i).write(param1);
               break;
            case 2:
               (this.value as str_i).write(param1);
               break;
            case 3:
               break;
            case 4:
               (this.value as str_i).write(param1);
               break;
            case 5:
               break;
            case 6:
               (this.value as PCost).write(param1);
               break;
            case 7:
               param1.writeUTF(this.value as String);
               break;
            case 8:
            case 9:
               break;
            case 10:
               param1.writeInt(this.value as int);
               break;
            case 11:
               param1.writeInt(this.value as int);
               break;
            case 12:
               break;
            case 13:
               (this.value as str_i).write(param1);
               break;
            case 14:
               (this.value as str_i).write(param1);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

