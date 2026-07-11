package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PChangeClan implements IClientPacket
   {
      
      public var cc_min_level:uint;
      
      public var cc_entry_policy:PEntryPolicy;
      
      public var cc_description:String;
      
      public var cc_icon:String;
      
      public function PChangeClan()
      {
         super();
      }
      
      public static function create(param1:uint, param2:PEntryPolicy, param3:String, param4:String) : PChangeClan
      {
         var _loc5_:PChangeClan = new PChangeClan();
         _loc5_.cc_min_level = param1;
         _loc5_.cc_entry_policy = param2;
         _loc5_.cc_description = param3;
         _loc5_.cc_icon = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PChangeClan
      {
         var _loc2_:PChangeClan = new PChangeClan();
         _loc2_.cc_min_level = param1.readUnsignedInt();
         _loc2_.cc_entry_policy = PEntryPolicy.read(param1);
         _loc2_.cc_description = param1.readUTF();
         _loc2_.cc_icon = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.cc_min_level);
         this.cc_entry_policy.write(param1);
         param1.writeUTF(this.cc_description);
         param1.writeUTF(this.cc_icon);
      }
   }
}

