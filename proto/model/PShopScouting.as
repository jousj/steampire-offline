package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopScouting implements IClientPacket
   {
      
      public var scouting_level:int;
      
      public var scouting_resources:int;
      
      public var scouting_speed_up_raid:int;
      
      public var scouting_ratio:int;
      
      public var scouting_speed_up_enegry:int;
      
      public var scouting_up_prize:int;
      
      public var scouting_ratio_limit:int;
      
      public function PShopScouting()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : PShopScouting
      {
         var _loc8_:PShopScouting = new PShopScouting();
         _loc8_.scouting_level = param1;
         _loc8_.scouting_resources = param2;
         _loc8_.scouting_speed_up_raid = param3;
         _loc8_.scouting_ratio = param4;
         _loc8_.scouting_speed_up_enegry = param5;
         _loc8_.scouting_up_prize = param6;
         _loc8_.scouting_ratio_limit = param7;
         return _loc8_;
      }
      
      public static function read(param1:IDataInput) : PShopScouting
      {
         var _loc2_:PShopScouting = new PShopScouting();
         _loc2_.scouting_level = param1.readInt();
         _loc2_.scouting_resources = param1.readInt();
         _loc2_.scouting_speed_up_raid = param1.readInt();
         _loc2_.scouting_ratio = param1.readInt();
         _loc2_.scouting_speed_up_enegry = param1.readInt();
         _loc2_.scouting_up_prize = param1.readInt();
         _loc2_.scouting_ratio_limit = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.scouting_level);
         param1.writeInt(this.scouting_resources);
         param1.writeInt(this.scouting_speed_up_raid);
         param1.writeInt(this.scouting_ratio);
         param1.writeInt(this.scouting_speed_up_enegry);
         param1.writeInt(this.scouting_up_prize);
         param1.writeInt(this.scouting_ratio_limit);
      }
   }
}

