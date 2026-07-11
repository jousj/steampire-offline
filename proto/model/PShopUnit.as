package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopUnit implements IClientPacket
   {
      
      public var su_kind:String;
      
      public var su_level:uint;
      
      public var su_radius:uint;
      
      public var su_damage:uint;
      
      public var su_stamina:uint;
      
      public var su_armor:uint;
      
      public var su_penetration:Number;
      
      public var su_is_air:Boolean;
      
      public var su_is_healer:Boolean;
      
      public var su_is_kamikaze:Boolean;
      
      public var su_move_delay:uint;
      
      public var su_priority_type:PUnitProirityType;
      
      public var su_priority_factor:Number;
      
      public var su_attack_time:uint;
      
      public var su_attack_delay:uint;
      
      public var su_bullet_speed:uint;
      
      public var su_aoe_radius:Number;
      
      public var su_price:PCost;
      
      public var su_hspace:uint;
      
      public var su_upgrade_price:Array;
      
      public var su_upgrade_time:Number;
      
      public var su_upgrade_requirement:PRequirement;
      
      public var su_can_buy:Boolean;
      
      public var su_target_type:PCannonTargetType;
      
      public var su_info_icons:Array;
      
      public var su_model_level:uint;
      
      public var su_is_hero:Boolean;
      
      public var su_attacked_by:Array;
      
      public var su_is_clan:Boolean;
      
      public var su_max_cure_stamina:int;
      
      public var su_eff:int;
      
      public var su_event_requirement:PBuildRequierement;
      
      public var su_power_points:int;
      
      public var order:uint;
      
      public function PShopUnit()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:Number, param8:Boolean, param9:Boolean, param10:Boolean, param11:uint, param12:PUnitProirityType, param13:Number, param14:uint, param15:uint, param16:uint, param17:Number, param18:PCost, param19:uint, param20:Array, param21:Number, param22:PRequirement, param23:Boolean, param24:PCannonTargetType, param25:Array, param26:uint, param27:Boolean, param28:Array, param29:Boolean, param30:int, param31:int, param32:PBuildRequierement, param33:int) : PShopUnit
      {
         var _loc34_:PShopUnit = new PShopUnit();
         _loc34_.su_kind = param1;
         _loc34_.su_level = param2;
         _loc34_.su_radius = param3;
         _loc34_.su_damage = param4;
         _loc34_.su_stamina = param5;
         _loc34_.su_armor = param6;
         _loc34_.su_penetration = param7;
         _loc34_.su_is_air = param8;
         _loc34_.su_is_healer = param9;
         _loc34_.su_is_kamikaze = param10;
         _loc34_.su_move_delay = param11;
         _loc34_.su_priority_type = param12;
         _loc34_.su_priority_factor = param13;
         _loc34_.su_attack_time = param14;
         _loc34_.su_attack_delay = param15;
         _loc34_.su_bullet_speed = param16;
         _loc34_.su_aoe_radius = param17;
         _loc34_.su_price = param18;
         _loc34_.su_hspace = param19;
         _loc34_.su_upgrade_price = param20;
         _loc34_.su_upgrade_time = param21;
         _loc34_.su_upgrade_requirement = param22;
         _loc34_.su_can_buy = param23;
         _loc34_.su_target_type = param24;
         _loc34_.su_info_icons = param25;
         _loc34_.su_model_level = param26;
         _loc34_.su_is_hero = param27;
         _loc34_.su_attacked_by = param28;
         _loc34_.su_is_clan = param29;
         _loc34_.su_max_cure_stamina = param30;
         _loc34_.su_eff = param31;
         _loc34_.su_event_requirement = param32;
         _loc34_.su_power_points = param33;
         return _loc34_;
      }
      
      public static function read(param1:IDataInput) : PShopUnit
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PShopUnit = new PShopUnit();
         _loc2_.su_kind = param1.readUTF();
         _loc2_.su_level = param1.readUnsignedByte();
         _loc2_.su_radius = param1.readUnsignedByte();
         _loc2_.su_damage = param1.readUnsignedInt();
         _loc2_.su_stamina = param1.readUnsignedInt();
         _loc2_.su_armor = param1.readUnsignedInt();
         _loc2_.su_penetration = param1.readDouble();
         _loc2_.su_is_air = param1.readBoolean();
         _loc2_.su_is_healer = param1.readBoolean();
         _loc2_.su_is_kamikaze = param1.readBoolean();
         _loc2_.su_move_delay = param1.readUnsignedInt();
         _loc2_.su_priority_type = PUnitProirityType.read(param1);
         _loc2_.su_priority_factor = param1.readDouble();
         _loc2_.su_attack_time = param1.readUnsignedInt();
         _loc2_.su_attack_delay = param1.readUnsignedInt();
         _loc2_.su_bullet_speed = param1.readUnsignedInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.su_aoe_radius = param1.readInt();
         }
         else
         {
            _loc2_.su_aoe_radius = NaN;
         }
         _loc2_.su_price = PCost.read(param1);
         _loc2_.su_hspace = param1.readUnsignedByte();
         _loc2_.su_upgrade_price = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.su_upgrade_price.length)
         {
            _loc2_.su_upgrade_price[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.su_upgrade_time = param1.readDouble();
         _loc2_.su_upgrade_requirement = PRequirement.read(param1);
         _loc2_.su_can_buy = param1.readBoolean();
         _loc2_.su_target_type = PCannonTargetType.read(param1);
         _loc2_.su_info_icons = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.su_info_icons.length)
         {
            _loc2_.su_info_icons[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.su_model_level = param1.readUnsignedByte();
         _loc2_.su_is_hero = param1.readBoolean();
         _loc2_.su_attacked_by = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.su_attacked_by.length)
         {
            _loc2_.su_attacked_by[_loc3_] = _loc4_ = PCannonTargetType.read(param1);
            _loc3_++;
         }
         _loc2_.su_is_clan = param1.readBoolean();
         _loc2_.su_max_cure_stamina = param1.readInt();
         _loc2_.su_eff = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.su_event_requirement = PBuildRequierement.read(param1);
         }
         else
         {
            _loc2_.su_event_requirement = null;
         }
         _loc2_.su_power_points = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.su_kind);
         param1.writeByte(this.su_level);
         param1.writeByte(this.su_radius);
         param1.writeInt(this.su_damage);
         param1.writeInt(this.su_stamina);
         param1.writeInt(this.su_armor);
         param1.writeDouble(this.su_penetration);
         param1.writeBoolean(this.su_is_air);
         param1.writeBoolean(this.su_is_healer);
         param1.writeBoolean(this.su_is_kamikaze);
         param1.writeInt(this.su_move_delay);
         this.su_priority_type.write(param1);
         param1.writeDouble(this.su_priority_factor);
         param1.writeInt(this.su_attack_time);
         param1.writeInt(this.su_attack_delay);
         param1.writeInt(this.su_bullet_speed);
         if(!isNaN(this.su_aoe_radius))
         {
            param1.writeByte(1);
            param1.writeInt(this.su_aoe_radius);
         }
         else
         {
            param1.writeByte(0);
         }
         this.su_price.write(param1);
         param1.writeByte(this.su_hspace);
         if(this.su_upgrade_price == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.su_upgrade_price.length);
            _loc2_ = 0;
            while(_loc2_ < this.su_upgrade_price.length)
            {
               this.su_upgrade_price[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeDouble(this.su_upgrade_time);
         this.su_upgrade_requirement.write(param1);
         param1.writeBoolean(this.su_can_buy);
         this.su_target_type.write(param1);
         if(this.su_info_icons == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.su_info_icons.length);
            _loc2_ = 0;
            while(_loc2_ < this.su_info_icons.length)
            {
               param1.writeUTF(this.su_info_icons[_loc2_]);
               _loc2_++;
            }
         }
         param1.writeByte(this.su_model_level);
         param1.writeBoolean(this.su_is_hero);
         if(this.su_attacked_by == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.su_attacked_by.length);
            _loc2_ = 0;
            while(_loc2_ < this.su_attacked_by.length)
            {
               this.su_attacked_by[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeBoolean(this.su_is_clan);
         param1.writeInt(this.su_max_cure_stamina);
         param1.writeInt(this.su_eff);
         if(this.su_event_requirement != null)
         {
            param1.writeByte(1);
            this.su_event_requirement.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.su_power_points);
      }
   }
}

