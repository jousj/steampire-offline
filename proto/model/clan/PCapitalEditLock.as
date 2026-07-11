package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCapitalEditLock implements IClientPacket
   {
      
      public var cel_user_id:String;
      
      public var cel_last_time:Number;
      
      public function PCapitalEditLock()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number) : PCapitalEditLock
      {
         var _loc3_:PCapitalEditLock = new PCapitalEditLock();
         _loc3_.cel_user_id = param1;
         _loc3_.cel_last_time = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PCapitalEditLock
      {
         var _loc2_:PCapitalEditLock = new PCapitalEditLock();
         _loc2_.cel_user_id = param1.readUTF();
         _loc2_.cel_last_time = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.cel_user_id);
         param1.writeDouble(this.cel_last_time);
      }
   }
}

