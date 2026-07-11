package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanTop implements IClientPacket
   {
      
      public var id:String;
      
      public var name:String;
      
      public var level:uint;
      
      public var ratio:uint;
      
      public var min_level:uint;
      
      public var members_count:uint;
      
      public var max_members:uint;
      
      public var entry_policy:PEntryPolicy;
      
      public var icon:String;
      
      public var place:uint;
      
      public var full_cnt:uint;
      
      public var war_params:PWarParams;
      
      public var division:uint;
      
      public function PClanTop()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint, param8:PEntryPolicy, param9:String, param10:uint, param11:uint, param12:PWarParams, param13:uint) : PClanTop
      {
         var _loc14_:PClanTop = new PClanTop();
         _loc14_.id = param1;
         _loc14_.name = param2;
         _loc14_.level = param3;
         _loc14_.ratio = param4;
         _loc14_.min_level = param5;
         _loc14_.members_count = param6;
         _loc14_.max_members = param7;
         _loc14_.entry_policy = param8;
         _loc14_.icon = param9;
         _loc14_.place = param10;
         _loc14_.full_cnt = param11;
         _loc14_.war_params = param12;
         _loc14_.division = param13;
         return _loc14_;
      }
      
      public static function read(param1:IDataInput) : PClanTop
      {
         var _loc2_:PClanTop = new PClanTop();
         _loc2_.id = param1.readUTF();
         _loc2_.name = param1.readUTF();
         _loc2_.level = param1.readUnsignedInt();
         _loc2_.ratio = param1.readUnsignedInt();
         _loc2_.min_level = param1.readUnsignedInt();
         _loc2_.members_count = param1.readUnsignedInt();
         _loc2_.max_members = param1.readUnsignedInt();
         _loc2_.entry_policy = PEntryPolicy.read(param1);
         _loc2_.icon = param1.readUTF();
         _loc2_.place = param1.readUnsignedInt();
         _loc2_.full_cnt = param1.readUnsignedInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.war_params = PWarParams.read(param1);
         }
         else
         {
            _loc2_.war_params = null;
         }
         _loc2_.division = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.id);
         param1.writeUTF(this.name);
         param1.writeInt(this.level);
         param1.writeInt(this.ratio);
         param1.writeInt(this.min_level);
         param1.writeInt(this.members_count);
         param1.writeInt(this.max_members);
         this.entry_policy.write(param1);
         param1.writeUTF(this.icon);
         param1.writeInt(this.place);
         param1.writeInt(this.full_cnt);
         if(this.war_params != null)
         {
            param1.writeByte(1);
            this.war_params.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.division);
      }
   }
}

