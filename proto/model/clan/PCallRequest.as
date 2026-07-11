package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCallRequest implements IClientPacket
   {
      
      public var cr_user_id:String;
      
      public var cr_time:Number;
      
      public var cr_full_count:int;
      
      public var cr_current_count:int;
      
      public var cr_senders:Array;
      
      public var member:PMember;
      
      public function PCallRequest()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number, param3:int, param4:int, param5:Array) : PCallRequest
      {
         var _loc6_:PCallRequest = new PCallRequest();
         _loc6_.cr_user_id = param1;
         _loc6_.cr_time = param2;
         _loc6_.cr_full_count = param3;
         _loc6_.cr_current_count = param4;
         _loc6_.cr_senders = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PCallRequest
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PCallRequest = new PCallRequest();
         _loc2_.cr_user_id = param1.readUTF();
         _loc2_.cr_time = param1.readDouble();
         _loc2_.cr_full_count = param1.readInt();
         _loc2_.cr_current_count = param1.readInt();
         _loc2_.cr_senders = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.cr_senders.length)
         {
            _loc2_.cr_senders[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.cr_user_id);
         param1.writeDouble(this.cr_time);
         param1.writeInt(this.cr_full_count);
         param1.writeInt(this.cr_current_count);
         if(this.cr_senders == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.cr_senders.length);
            _loc2_ = 0;
            while(_loc2_ < this.cr_senders.length)
            {
               param1.writeUTF(this.cr_senders[_loc2_]);
               _loc2_++;
            }
         }
      }
   }
}

