package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCommand implements IClientPacket
   {
      
      public var cm_kind:PCommandKind;
      
      public var cm_time:uint;
      
      public var cm_user_id:String;
      
      public function PCommand()
      {
         super();
      }
      
      public static function create(param1:PCommandKind, param2:uint, param3:String) : PCommand
      {
         var _loc4_:PCommand = new PCommand();
         _loc4_.cm_kind = param1;
         _loc4_.cm_time = param2;
         _loc4_.cm_user_id = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PCommand
      {
         var _loc2_:PCommand = new PCommand();
         _loc2_.cm_kind = PCommandKind.read(param1);
         _loc2_.cm_time = param1.readUnsignedInt();
         _loc2_.cm_user_id = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.cm_kind.write(param1);
         param1.writeInt(this.cm_time);
         param1.writeUTF(this.cm_user_id);
      }
   }
}

