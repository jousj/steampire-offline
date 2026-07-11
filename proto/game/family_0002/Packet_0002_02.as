package proto.game.family_0002
{
   import flash.utils.IDataInput;
   import proto.model.PFightRequestResult;
   import proto.model.PGetLocationAnswer;
   import proto.model.PStorm;
   import proto.model.clan.PTerritory;
   import proto.model.clan.PTerritoryAttack;
   
   public class Packet_0002_02
   {
      
      public static const UNKNOWN:uint = 5;
      
      public static const CLAN_TERRITORIES_ATTACK:uint = 4;
      
      public static const TERRITORY_INFO:uint = 3;
      
      public static const FIGHT:uint = 2;
      
      public static const STORM:uint = 1;
      
      public static const LOCATION:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function Packet_0002_02(param1:IDataInput)
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         super();
         this.variance = param1.readUnsignedByte();
         switch(this.variance)
         {
            case 0:
               this.value = PGetLocationAnswer.read(param1);
               break;
            case 1:
               this.value = PStorm.read(param1);
               break;
            case 2:
               this.value = PFightRequestResult.read(param1);
               break;
            case 3:
               this.value = PTerritory.read(param1);
               break;
            case 4:
               this.value = new Array(param1.readUnsignedShort());
               _loc2_ = 0;
               while(_loc2_ < this.value.length)
               {
                  this.value[_loc2_] = _loc3_ = PTerritoryAttack.read(param1);
                  _loc2_++;
               }
               break;
            case 5:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

