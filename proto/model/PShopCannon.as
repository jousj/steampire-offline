package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopCannon implements IClientPacket
   {
      
      public var sc_kind:String;
      
      public var sc_level:uint;
      
      public var sc_radius:uint;
      
      public var sc_blind_radius:uint;
      
      public var sc_stamina:uint;
      
      public var sc_attack_time:uint;
      
      public var sc_attack_delay:uint;
      
      public var sc_bullet_speed:uint;
      
      public var sc_damage:uint;
      
      public var sc_armor:uint;
      
      public var sc_penetration:Number;
      
      public var sc_aoe_radius:uint;
      
      public var sc_slowdown:uint;
      
      public var sc_slowdown_time:uint;
      
      public var sc_price:Array;
      
      public var sc_upgrade_time:Number;
      
      public var sc_townhall_req:uint;
      
      public var sc_target_type:PCannonTargetType;
      
      public var sc_is_porabols:Boolean;
      
      public var sc_can_buy:Boolean;
      
      public var sc_info_icons:Array;
      
      public var sc_price_list:Array;
      
      public var sc_favorite_units:Array;
      
      public var sc_favorite_dmg_koef:Number;
      
      public var sc_model_level:int;
      
      public var sc_sort_by_distance:Boolean;
      
      public function PShopCannon()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint, param8:uint, param9:uint, param10:uint, param11:Number, param12:uint, param13:uint, param14:uint, param15:Array, param16:Number, param17:uint, param18:PCannonTargetType, param19:Boolean, param20:Boolean, param21:Array, param22:Array, param23:Array, param24:Number, param25:int, param26:Boolean) : PShopCannon
      {
         var _loc27_:PShopCannon = new PShopCannon();
         _loc27_.sc_kind = param1;
         _loc27_.sc_level = param2;
         _loc27_.sc_radius = param3;
         _loc27_.sc_blind_radius = param4;
         _loc27_.sc_stamina = param5;
         _loc27_.sc_attack_time = param6;
         _loc27_.sc_attack_delay = param7;
         _loc27_.sc_bullet_speed = param8;
         _loc27_.sc_damage = param9;
         _loc27_.sc_armor = param10;
         _loc27_.sc_penetration = param11;
         _loc27_.sc_aoe_radius = param12;
         _loc27_.sc_slowdown = param13;
         _loc27_.sc_slowdown_time = param14;
         _loc27_.sc_price = param15;
         _loc27_.sc_upgrade_time = param16;
         _loc27_.sc_townhall_req = param17;
         _loc27_.sc_target_type = param18;
         _loc27_.sc_is_porabols = param19;
         _loc27_.sc_can_buy = param20;
         _loc27_.sc_info_icons = param21;
         _loc27_.sc_price_list = param22;
         _loc27_.sc_favorite_units = param23;
         _loc27_.sc_favorite_dmg_koef = param24;
         _loc27_.sc_model_level = param25;
         _loc27_.sc_sort_by_distance = param26;
         return _loc27_;
      }
      
      public static function read(param1:IDataInput) : PShopCannon
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc2_:PShopCannon = new PShopCannon();
         _loc2_.sc_kind = param1.readUTF();
         _loc2_.sc_level = param1.readUnsignedByte();
         _loc2_.sc_radius = param1.readUnsignedByte();
         _loc2_.sc_blind_radius = param1.readUnsignedByte();
         _loc2_.sc_stamina = param1.readUnsignedInt();
         _loc2_.sc_attack_time = param1.readUnsignedInt();
         _loc2_.sc_attack_delay = param1.readUnsignedInt();
         _loc2_.sc_bullet_speed = param1.readUnsignedInt();
         _loc2_.sc_damage = param1.readUnsignedInt();
         _loc2_.sc_armor = param1.readUnsignedInt();
         _loc2_.sc_penetration = param1.readDouble();
         _loc2_.sc_aoe_radius = param1.readUnsignedByte();
         _loc2_.sc_slowdown = param1.readUnsignedInt();
         _loc2_.sc_slowdown_time = param1.readUnsignedInt();
         _loc2_.sc_price = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.sc_price.length)
         {
            _loc2_.sc_price[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.sc_upgrade_time = param1.readDouble();
         _loc2_.sc_townhall_req = param1.readUnsignedByte();
         _loc2_.sc_target_type = PCannonTargetType.read(param1);
         _loc2_.sc_is_porabols = param1.readBoolean();
         _loc2_.sc_can_buy = param1.readBoolean();
         _loc2_.sc_info_icons = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.sc_info_icons.length)
         {
            _loc2_.sc_info_icons[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.sc_price_list = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.sc_price_list.length)
         {
            _loc2_.sc_price_list[_loc3_] = _loc4_ = new Array(param1.readUnsignedShort());
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc4_[_loc5_] = _loc6_ = PCost.read(param1);
               _loc5_++;
            }
            _loc3_++;
         }
         _loc2_.sc_favorite_units = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.sc_favorite_units.length)
         {
            _loc2_.sc_favorite_units[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.sc_favorite_dmg_koef = param1.readDouble();
         _loc2_.sc_model_level = param1.readInt();
         _loc2_.sc_sort_by_distance = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         param1.writeUTF(this.sc_kind);
         param1.writeByte(this.sc_level);
         param1.writeByte(this.sc_radius);
         param1.writeByte(this.sc_blind_radius);
         param1.writeInt(this.sc_stamina);
         param1.writeInt(this.sc_attack_time);
         param1.writeInt(this.sc_attack_delay);
         param1.writeInt(this.sc_bullet_speed);
         param1.writeInt(this.sc_damage);
         param1.writeInt(this.sc_armor);
         param1.writeDouble(this.sc_penetration);
         param1.writeByte(this.sc_aoe_radius);
         param1.writeInt(this.sc_slowdown);
         param1.writeInt(this.sc_slowdown_time);
         if(this.sc_price == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.sc_price.length);
            _loc2_ = 0;
            while(_loc2_ < this.sc_price.length)
            {
               this.sc_price[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeDouble(this.sc_upgrade_time);
         param1.writeByte(this.sc_townhall_req);
         this.sc_target_type.write(param1);
         param1.writeBoolean(this.sc_is_porabols);
         param1.writeBoolean(this.sc_can_buy);
         if(this.sc_info_icons == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.sc_info_icons.length);
            _loc2_ = 0;
            while(_loc2_ < this.sc_info_icons.length)
            {
               param1.writeUTF(this.sc_info_icons[_loc2_]);
               _loc2_++;
            }
         }
         if(this.sc_price_list == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.sc_price_list.length);
            _loc2_ = 0;
            while(_loc2_ < this.sc_price_list.length)
            {
               if(this.sc_price_list[_loc2_] == null)
               {
                  param1.writeShort(0);
               }
               else
               {
                  param1.writeShort(this.sc_price_list[_loc2_].length);
                  _loc2_ = 0;
                  while(_loc2_ < this.sc_price_list[_loc2_].length)
                  {
                     this.sc_price_list[_loc2_][_loc2_].write(param1);
                     _loc2_++;
                  }
               }
               _loc2_++;
            }
         }
         if(this.sc_favorite_units == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.sc_favorite_units.length);
            _loc2_ = 0;
            while(_loc2_ < this.sc_favorite_units.length)
            {
               param1.writeUTF(this.sc_favorite_units[_loc2_]);
               _loc2_++;
            }
         }
         param1.writeDouble(this.sc_favorite_dmg_koef);
         param1.writeInt(this.sc_model_level);
         param1.writeBoolean(this.sc_sort_by_distance);
      }
   }
}

