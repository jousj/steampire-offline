package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PApplyRaidInvite implements IClientPacket
   {
      
      public var ari_raid_id:String;
      
      public var ari_mission_id:String;
      
      public function PApplyRaidInvite()
      {
         super();
      }
      
      public static function create(param1:String, param2:String) : PApplyRaidInvite
      {
         var _loc3_:PApplyRaidInvite = new PApplyRaidInvite();
         _loc3_.ari_raid_id = param1;
         _loc3_.ari_mission_id = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PApplyRaidInvite
      {
         var _loc2_:PApplyRaidInvite = new PApplyRaidInvite();
         _loc2_.ari_raid_id = param1.readUTF();
         _loc2_.ari_mission_id = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.ari_raid_id);
         param1.writeUTF(this.ari_mission_id);
      }
   }
}

