package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PRole;
   
   public class PChatMember implements IClientPacket
   {
      
      public var cm_id:String;
      
      public var cm_name:String;
      
      public var cm_role:PRole;
      
      public function PChatMember()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:PRole) : PChatMember
      {
         var _loc4_:PChatMember = new PChatMember();
         _loc4_.cm_id = param1;
         _loc4_.cm_name = param2;
         _loc4_.cm_role = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PChatMember
      {
         var _loc2_:PChatMember = new PChatMember();
         _loc2_.cm_id = param1.readUTF();
         _loc2_.cm_name = param1.readUTF();
         _loc2_.cm_role = PRole.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.cm_id);
         param1.writeUTF(this.cm_name);
         this.cm_role.write(param1);
      }
   }
}

