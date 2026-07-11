package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PRaidCooldown implements IClientPacket
   {
      
      public var rc_raid_kind:String;
      
      public var rc_end_time:Number;
      
      public function PRaidCooldown()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number) : PRaidCooldown
      {
         var _loc3_:PRaidCooldown = new PRaidCooldown();
         _loc3_.rc_raid_kind = param1;
         _loc3_.rc_end_time = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PRaidCooldown
      {
         var _loc2_:PRaidCooldown = new PRaidCooldown();
         _loc2_.rc_raid_kind = param1.readUTF();
         _loc2_.rc_end_time = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.rc_raid_kind);
         param1.writeDouble(this.rc_end_time);
      }
   }
}

