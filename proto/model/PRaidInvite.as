package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PRaidInvite implements IClientPacket
   {
      
      public var ri_user_id:String;
      
      public var ri_name:String;
      
      public var ri_avatar:String;
      
      public var ri_raid_id:String;
      
      public var ri_raid_kind:String;
      
      public function PRaidInvite()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:String, param4:String, param5:String) : PRaidInvite
      {
         var _loc6_:PRaidInvite = new PRaidInvite();
         _loc6_.ri_user_id = param1;
         _loc6_.ri_name = param2;
         _loc6_.ri_avatar = param3;
         _loc6_.ri_raid_id = param4;
         _loc6_.ri_raid_kind = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PRaidInvite
      {
         var _loc2_:PRaidInvite = new PRaidInvite();
         _loc2_.ri_user_id = param1.readUTF();
         _loc2_.ri_name = param1.readUTF();
         _loc2_.ri_avatar = param1.readUTF();
         _loc2_.ri_raid_id = param1.readUTF();
         _loc2_.ri_raid_kind = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.ri_user_id);
         param1.writeUTF(this.ri_name);
         param1.writeUTF(this.ri_avatar);
         param1.writeUTF(this.ri_raid_id);
         param1.writeUTF(this.ri_raid_kind);
      }
   }
}

