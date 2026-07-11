package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PApprove implements IClientPacket
   {
      
      public var a_user_id:String;
      
      public var a_is_apply:Boolean;
      
      public function PApprove()
      {
         super();
      }
      
      public static function create(param1:String, param2:Boolean) : PApprove
      {
         var _loc3_:PApprove = new PApprove();
         _loc3_.a_user_id = param1;
         _loc3_.a_is_apply = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PApprove
      {
         var _loc2_:PApprove = new PApprove();
         _loc2_.a_user_id = param1.readUTF();
         _loc2_.a_is_apply = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.a_user_id);
         param1.writeBoolean(this.a_is_apply);
      }
   }
}

