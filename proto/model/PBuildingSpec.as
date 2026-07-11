package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PBuildingSpec implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 15;
      
      public static const SCOUTING:uint = 14;
      
      public static const SHIELD:uint = 13;
      
      public static const LIBRARY:uint = 12;
      
      public static const RAID:uint = 11;
      
      public static const GUARD:uint = 10;
      
      public static const HERO:uint = 9;
      
      public static const CLAN:uint = 8;
      
      public static const RESEARCH:uint = 7;
      
      public static const PYLON:uint = 6;
      
      public static const STORAGE:uint = 5;
      
      public static const RESOURCE:uint = 4;
      
      public static const CAMP:uint = 3;
      
      public static const BARRACK:uint = 2;
      
      public static const WORKER:uint = 1;
      
      public static const TOWNHALL:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PBuildingSpec()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PBuildingSpec
      {
         var _loc3_:PBuildingSpec = new PBuildingSpec();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PBuildingSpec
      {
         var _loc2_:PBuildingSpec = new PBuildingSpec();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
            case 1:
            case 2:
            case 3:
               break;
            case 4:
               _loc2_.value = PResource.read(param1);
               break;
            case 5:
            case 6:
               break;
            case 7:
               if(param1.readUnsignedByte() == 1)
               {
                  _loc2_.value = PResearch.read(param1);
                  break;
               }
               _loc2_.value = null;
               break;
            case 8:
               _loc2_.value = PClanCenter.read(param1);
               break;
            case 9:
               break;
            case 10:
               _loc2_.value = PGuard.read(param1);
               break;
            case 11:
            case 12:
               break;
            case 13:
               _loc2_.value = param1.readDouble();
               break;
            case 14:
            case 15:
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
            case 2:
            case 3:
               break;
            case 4:
               (this.value as PResource).write(param1);
               break;
            case 5:
            case 6:
               break;
            case 7:
               if(this.value as PResearch != null)
               {
                  param1.writeByte(1);
                  (this.value as PResearch).write(param1);
                  break;
               }
               param1.writeByte(0);
               break;
            case 8:
               (this.value as PClanCenter).write(param1);
               break;
            case 9:
               break;
            case 10:
               (this.value as PGuard).write(param1);
               break;
            case 11:
            case 12:
               break;
            case 13:
               param1.writeDouble(this.value as Number);
               break;
            case 14:
            case 15:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

