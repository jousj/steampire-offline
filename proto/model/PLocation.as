package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PLocation implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 7;
      
      public static const BOSS:uint = 6;
      
      public static const SIMULATION:uint = 5;
      
      public static const STORM:uint = 4;
      
      public static const BATTLE:uint = 3;
      
      public static const GROUP:uint = 2;
      
      public static const HOME:uint = 1;
      
      public static const ATTACKED:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PLocation()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PLocation
      {
         var _loc3_:PLocation = new PLocation();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PLocation
      {
         var _loc2_:PLocation = new PLocation();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = PFightAttakerInfo.read(param1);
               break;
            case 1:
               _loc2_.value = PHome.read(param1);
               break;
            case 2:
               _loc2_.value = PGroupFightInfo.read(param1);
               break;
            case 3:
               _loc2_.value = PCurrentFight.read(param1);
               break;
            case 4:
               _loc2_.value = PStorm.read(param1);
               break;
            case 5:
               break;
            case 6:
               _loc2_.value = PBossAttack.read(param1);
               break;
            case 7:
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
               (this.value as PFightAttakerInfo).write(param1);
               break;
            case 1:
               (this.value as PHome).write(param1);
               break;
            case 2:
               (this.value as PGroupFightInfo).write(param1);
               break;
            case 3:
               (this.value as PCurrentFight).write(param1);
               break;
            case 4:
               (this.value as PStorm).write(param1);
               break;
            case 5:
               break;
            case 6:
               (this.value as PBossAttack).write(param1);
               break;
            case 7:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

