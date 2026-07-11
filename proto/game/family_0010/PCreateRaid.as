package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCreateRaid implements IClientPacket
   {
      
      public var cr_kind:String;
      
      public var cr_manual:Boolean;
      
      public function PCreateRaid()
      {
         super();
      }
      
      public static function create(param1:String, param2:Boolean) : PCreateRaid
      {
         var _loc3_:PCreateRaid = new PCreateRaid();
         _loc3_.cr_kind = param1;
         _loc3_.cr_manual = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PCreateRaid
      {
         var _loc2_:PCreateRaid = new PCreateRaid();
         _loc2_.cr_kind = param1.readUTF();
         _loc2_.cr_manual = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.cr_kind);
         param1.writeBoolean(this.cr_manual);
      }
   }
}

