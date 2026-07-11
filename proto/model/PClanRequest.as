package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanRequest implements IClientPacket
   {
      
      public var cr_user_id:String;
      
      public var cr_user_name:String;
      
      public var cr_user_level:uint;
      
      public var cr_time:Number;
      
      public function PClanRequest()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:uint, param4:Number) : PClanRequest
      {
         var _loc5_:PClanRequest = new PClanRequest();
         _loc5_.cr_user_id = param1;
         _loc5_.cr_user_name = param2;
         _loc5_.cr_user_level = param3;
         _loc5_.cr_time = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PClanRequest
      {
         var _loc2_:PClanRequest = new PClanRequest();
         _loc2_.cr_user_id = param1.readUTF();
         _loc2_.cr_user_name = param1.readUTF();
         _loc2_.cr_user_level = param1.readUnsignedInt();
         _loc2_.cr_time = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.cr_user_id);
         param1.writeUTF(this.cr_user_name);
         param1.writeInt(this.cr_user_level);
         param1.writeDouble(this.cr_time);
      }
   }
}

