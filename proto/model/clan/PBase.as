package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PBase implements IClientPacket
   {
      
      public var id:String;
      
      public var name:String;
      
      public var icon:String;
      
      public var min_level:int;
      
      public var exp:int;
      
      public var level:int;
      
      public var ratio:int;
      
      public var members_count:uint;
      
      public var entry_policy:PEntryPolicy;
      
      public var description:String;
      
      public var creator:String;
      
      public var gold:int;
      
      public var oil:int;
      
      public var crystal:int;
      
      public var has_capital:Boolean;
      
      public var mithril:int;
      
      public var clan_points:int;
      
      public var division:int;
      
      public function PBase()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:String, param4:int, param5:int, param6:int, param7:int, param8:uint, param9:PEntryPolicy, param10:String, param11:String, param12:int, param13:int, param14:int, param15:Boolean, param16:int, param17:int, param18:int) : PBase
      {
         var _loc19_:PBase = new PBase();
         _loc19_.id = param1;
         _loc19_.name = param2;
         _loc19_.icon = param3;
         _loc19_.min_level = param4;
         _loc19_.exp = param5;
         _loc19_.level = param6;
         _loc19_.ratio = param7;
         _loc19_.members_count = param8;
         _loc19_.entry_policy = param9;
         _loc19_.description = param10;
         _loc19_.creator = param11;
         _loc19_.gold = param12;
         _loc19_.oil = param13;
         _loc19_.crystal = param14;
         _loc19_.has_capital = param15;
         _loc19_.mithril = param16;
         _loc19_.clan_points = param17;
         _loc19_.division = param18;
         return _loc19_;
      }
      
      public static function read(param1:IDataInput) : PBase
      {
         var _loc2_:PBase = new PBase();
         _loc2_.id = param1.readUTF();
         _loc2_.name = param1.readUTF();
         _loc2_.icon = param1.readUTF();
         _loc2_.min_level = param1.readInt();
         _loc2_.exp = param1.readInt();
         _loc2_.level = param1.readInt();
         _loc2_.ratio = param1.readInt();
         _loc2_.members_count = param1.readUnsignedInt();
         _loc2_.entry_policy = PEntryPolicy.read(param1);
         _loc2_.description = param1.readUTF();
         _loc2_.creator = param1.readUTF();
         _loc2_.gold = param1.readInt();
         _loc2_.oil = param1.readInt();
         _loc2_.crystal = param1.readInt();
         _loc2_.has_capital = param1.readBoolean();
         _loc2_.mithril = param1.readInt();
         _loc2_.clan_points = param1.readInt();
         _loc2_.division = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.id);
         param1.writeUTF(this.name);
         param1.writeUTF(this.icon);
         param1.writeInt(this.min_level);
         param1.writeInt(this.exp);
         param1.writeInt(this.level);
         param1.writeInt(this.ratio);
         param1.writeInt(this.members_count);
         this.entry_policy.write(param1);
         param1.writeUTF(this.description);
         param1.writeUTF(this.creator);
         param1.writeInt(this.gold);
         param1.writeInt(this.oil);
         param1.writeInt(this.crystal);
         param1.writeBoolean(this.has_capital);
         param1.writeInt(this.mithril);
         param1.writeInt(this.clan_points);
         param1.writeInt(this.division);
      }
   }
}

