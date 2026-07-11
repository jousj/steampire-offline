package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PRole;
   
   public class PSetRole implements IClientPacket
   {
      
      public var sr_user_id:String;
      
      public var sr_role:PRole;
      
      public function PSetRole()
      {
         super();
      }
      
      public static function create(param1:String, param2:PRole) : PSetRole
      {
         var _loc3_:PSetRole = new PSetRole();
         _loc3_.sr_user_id = param1;
         _loc3_.sr_role = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PSetRole
      {
         var _loc2_:PSetRole = new PSetRole();
         _loc2_.sr_user_id = param1.readUTF();
         _loc2_.sr_role = PRole.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.sr_user_id);
         this.sr_role.write(param1);
      }
   }
}

