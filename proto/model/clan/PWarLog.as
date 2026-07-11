package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PRole;
   
   public class PWarLog implements IClientPacket
   {
      
      public var wl_user_id:String;
      
      public var wl_user_name:String;
      
      public var wl_user_level:int;
      
      public var wl_user_role:PRole;
      
      public var wl_time:Number;
      
      public var wl_kind:PWarLogKind;
      
      public var wl_snetwork:String;
      
      public function PWarLog()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:int, param4:PRole, param5:Number, param6:PWarLogKind, param7:String) : PWarLog
      {
         var _loc8_:PWarLog = new PWarLog();
         _loc8_.wl_user_id = param1;
         _loc8_.wl_user_name = param2;
         _loc8_.wl_user_level = param3;
         _loc8_.wl_user_role = param4;
         _loc8_.wl_time = param5;
         _loc8_.wl_kind = param6;
         _loc8_.wl_snetwork = param7;
         return _loc8_;
      }
      
      public static function read(param1:IDataInput) : PWarLog
      {
         var _loc2_:PWarLog = new PWarLog();
         _loc2_.wl_user_id = param1.readUTF();
         _loc2_.wl_user_name = param1.readUTF();
         _loc2_.wl_user_level = param1.readInt();
         _loc2_.wl_user_role = PRole.read(param1);
         _loc2_.wl_time = param1.readDouble();
         _loc2_.wl_kind = PWarLogKind.read(param1);
         _loc2_.wl_snetwork = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.wl_user_id);
         param1.writeUTF(this.wl_user_name);
         param1.writeInt(this.wl_user_level);
         this.wl_user_role.write(param1);
         param1.writeDouble(this.wl_time);
         this.wl_kind.write(param1);
         param1.writeUTF(this.wl_snetwork);
      }
   }
}

