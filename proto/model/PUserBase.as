package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PUserBase implements IClientPacket
   {
      
      public var user_id:String;
      
      public var name:String;
      
      public var avatar:String;
      
      public var profile_url:String;
      
      public var level:uint;
      
      public var sex:String;
      
      public var exp:int;
      
      public var avatar_small:String;
      
      public var avatar_big:String;
      
      public var ratio:uint;
      
      public var units:Array;
      
      public var units_levels:Array;
      
      public var heroes:Array;
      
      public var clan:PUserClan;
      
      public var th_level:uint;
      
      public var account_id:String;
      
      public var snetwork:String;
      
      public var scouting:Number;
      
      public var clan_points:PUsersClanPoints;
      
      public function PUserBase()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:String, param4:String, param5:uint, param6:String, param7:int, param8:String, param9:String, param10:uint, param11:Array, param12:Array, param13:Array, param14:PUserClan, param15:uint, param16:String, param17:String, param18:Number, param19:PUsersClanPoints) : PUserBase
      {
         var _loc20_:PUserBase = new PUserBase();
         _loc20_.user_id = param1;
         _loc20_.name = param2;
         _loc20_.avatar = param3;
         _loc20_.profile_url = param4;
         _loc20_.level = param5;
         _loc20_.sex = param6;
         _loc20_.exp = param7;
         _loc20_.avatar_small = param8;
         _loc20_.avatar_big = param9;
         _loc20_.ratio = param10;
         _loc20_.units = param11;
         _loc20_.units_levels = param12;
         _loc20_.heroes = param13;
         _loc20_.clan = param14;
         _loc20_.th_level = param15;
         _loc20_.account_id = param16;
         _loc20_.snetwork = param17;
         _loc20_.scouting = param18;
         _loc20_.clan_points = param19;
         return _loc20_;
      }
      
      public static function read(param1:IDataInput) : PUserBase
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PUserBase = new PUserBase();
         _loc2_.user_id = param1.readUTF();
         _loc2_.name = param1.readUTF();
         _loc2_.avatar = param1.readUTF();
         _loc2_.profile_url = param1.readUTF();
         _loc2_.level = param1.readUnsignedShort();
         _loc2_.sex = param1.readUTF();
         _loc2_.exp = param1.readInt();
         _loc2_.avatar_small = param1.readUTF();
         _loc2_.avatar_big = param1.readUTF();
         _loc2_.ratio = param1.readUnsignedInt();
         _loc2_.units = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.units.length)
         {
            _loc2_.units[_loc3_] = _loc4_ = PKindCount.read(param1);
            _loc3_++;
         }
         _loc2_.units_levels = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.units_levels.length)
         {
            _loc2_.units_levels[_loc3_] = _loc4_ = PUnitsLevel.read(param1);
            _loc3_++;
         }
         _loc2_.heroes = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.heroes.length)
         {
            _loc2_.heroes[_loc3_] = _loc4_ = PHero.read(param1);
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.clan = PUserClan.read(param1);
         }
         else
         {
            _loc2_.clan = null;
         }
         _loc2_.th_level = param1.readUnsignedInt();
         _loc2_.account_id = param1.readUTF();
         _loc2_.snetwork = param1.readUTF();
         _loc2_.scouting = param1.readDouble();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.clan_points = PUsersClanPoints.read(param1);
         }
         else
         {
            _loc2_.clan_points = null;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.user_id);
         param1.writeUTF(this.name);
         param1.writeUTF(this.avatar);
         param1.writeUTF(this.profile_url);
         param1.writeShort(this.level);
         param1.writeUTF(this.sex);
         param1.writeInt(this.exp);
         param1.writeUTF(this.avatar_small);
         param1.writeUTF(this.avatar_big);
         param1.writeInt(this.ratio);
         if(this.units == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.units.length);
            _loc2_ = 0;
            while(_loc2_ < this.units.length)
            {
               this.units[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.units_levels == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.units_levels.length);
            _loc2_ = 0;
            while(_loc2_ < this.units_levels.length)
            {
               this.units_levels[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.heroes == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.heroes.length);
            _loc2_ = 0;
            while(_loc2_ < this.heroes.length)
            {
               this.heroes[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.clan != null)
         {
            param1.writeByte(1);
            this.clan.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.th_level);
         param1.writeUTF(this.account_id);
         param1.writeUTF(this.snetwork);
         param1.writeDouble(this.scouting);
         if(this.clan_points != null)
         {
            param1.writeByte(1);
            this.clan_points.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

