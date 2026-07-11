package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopClanRole implements IClientPacket
   {
      
      public var scr_role_kind:PRole;
      
      public var scr_role_is_unique:Boolean;
      
      public var scr_role_priority:uint;
      
      public var scr_role_permissions:Array;
      
      public function PShopClanRole()
      {
         super();
      }
      
      public static function create(param1:PRole, param2:Boolean, param3:uint, param4:Array) : PShopClanRole
      {
         var _loc5_:PShopClanRole = new PShopClanRole();
         _loc5_.scr_role_kind = param1;
         _loc5_.scr_role_is_unique = param2;
         _loc5_.scr_role_priority = param3;
         _loc5_.scr_role_permissions = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PShopClanRole
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PShopClanRole = new PShopClanRole();
         _loc2_.scr_role_kind = PRole.read(param1);
         _loc2_.scr_role_is_unique = param1.readBoolean();
         _loc2_.scr_role_priority = param1.readUnsignedInt();
         _loc2_.scr_role_permissions = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.scr_role_permissions.length)
         {
            _loc2_.scr_role_permissions[_loc3_] = _loc4_ = PPermission.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         this.scr_role_kind.write(param1);
         param1.writeBoolean(this.scr_role_is_unique);
         param1.writeInt(this.scr_role_priority);
         if(this.scr_role_permissions == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.scr_role_permissions.length);
            _loc2_ = 0;
            while(_loc2_ < this.scr_role_permissions.length)
            {
               this.scr_role_permissions[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

