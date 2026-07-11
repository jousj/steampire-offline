package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PRole;
   
   public class PRegent implements IClientPacket
   {
      
      public var regent_id:String;
      
      public var regent_name:String;
      
      public var regent_level:int;
      
      public var regent_role:PRole;
      
      public var regent_snetwork:String;
      
      public function PRegent()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:int, param4:PRole, param5:String) : PRegent
      {
         var _loc6_:PRegent = new PRegent();
         _loc6_.regent_id = param1;
         _loc6_.regent_name = param2;
         _loc6_.regent_level = param3;
         _loc6_.regent_role = param4;
         _loc6_.regent_snetwork = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PRegent
      {
         var _loc2_:PRegent = new PRegent();
         _loc2_.regent_id = param1.readUTF();
         _loc2_.regent_name = param1.readUTF();
         _loc2_.regent_level = param1.readInt();
         _loc2_.regent_role = PRole.read(param1);
         _loc2_.regent_snetwork = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.regent_id);
         param1.writeUTF(this.regent_name);
         param1.writeInt(this.regent_level);
         this.regent_role.write(param1);
         param1.writeUTF(this.regent_snetwork);
      }
   }
}

