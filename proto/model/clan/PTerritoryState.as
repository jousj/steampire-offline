package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.time_a_str_a;
   
   public class PTerritoryState implements IClientPacket
   {
      
      public static const REG_ATTACK:uint = 4;
      
      public static const UNKNOWN:uint = 3;
      
      public static const FREE:uint = 2;
      
      public static const ATTACK:uint = 1;
      
      public static const COOLDOWN:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PTerritoryState()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PTerritoryState
      {
         var _loc3_:PTerritoryState = new PTerritoryState();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PTerritoryState
      {
         var _loc2_:PTerritoryState = new PTerritoryState();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = param1.readDouble();
               break;
            case 1:
               _loc2_.value = PTerritoryAttacker.read(param1);
               break;
            case 2:
            case 3:
               break;
            case 4:
               _loc2_.value = time_a_str_a.read(param1);
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
               (this.value as PTerritoryAttacker).write(param1);
               break;
            case 2:
            case 3:
               break;
            case 4:
               (this.value as time_a_str_a).write(param1);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

