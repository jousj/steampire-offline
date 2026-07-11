package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCreateClan implements IClientPacket
   {
      
      public var name:String;
      
      public var icon:String;
      
      public var min_level:int;
      
      public var entry_policy:PEntryPolicy;
      
      public var description:String;
      
      public function PCreateClan()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:int, param4:PEntryPolicy, param5:String) : PCreateClan
      {
         var _loc6_:PCreateClan = new PCreateClan();
         _loc6_.name = param1;
         _loc6_.icon = param2;
         _loc6_.min_level = param3;
         _loc6_.entry_policy = param4;
         _loc6_.description = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PCreateClan
      {
         var _loc2_:PCreateClan = new PCreateClan();
         _loc2_.name = param1.readUTF();
         _loc2_.icon = param1.readUTF();
         _loc2_.min_level = param1.readInt();
         _loc2_.entry_policy = PEntryPolicy.read(param1);
         _loc2_.description = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.name);
         param1.writeUTF(this.icon);
         param1.writeInt(this.min_level);
         this.entry_policy.write(param1);
         param1.writeUTF(this.description);
      }
   }
}

