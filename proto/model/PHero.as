package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PHero implements IClientPacket
   {
      
      public var hero_kind:String;
      
      public var hero_stamina:uint;
      
      public var hero_last_reg_time:Number;
      
      public var stamina_mod_level:uint;
      
      public var armor_mod_level:uint;
      
      public var damage_mod_level:uint;
      
      public var recover_mod_level:uint;
      
      public function PHero()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:Number, param4:uint, param5:uint, param6:uint, param7:uint) : PHero
      {
         var _loc8_:PHero = new PHero();
         _loc8_.hero_kind = param1;
         _loc8_.hero_stamina = param2;
         _loc8_.hero_last_reg_time = param3;
         _loc8_.stamina_mod_level = param4;
         _loc8_.armor_mod_level = param5;
         _loc8_.damage_mod_level = param6;
         _loc8_.recover_mod_level = param7;
         return _loc8_;
      }
      
      public static function read(param1:IDataInput) : PHero
      {
         var _loc2_:PHero = new PHero();
         _loc2_.hero_kind = param1.readUTF();
         _loc2_.hero_stamina = param1.readUnsignedInt();
         _loc2_.hero_last_reg_time = param1.readDouble();
         _loc2_.stamina_mod_level = param1.readUnsignedInt();
         _loc2_.armor_mod_level = param1.readUnsignedInt();
         _loc2_.damage_mod_level = param1.readUnsignedInt();
         _loc2_.recover_mod_level = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.hero_kind);
         param1.writeInt(this.hero_stamina);
         param1.writeDouble(this.hero_last_reg_time);
         param1.writeInt(this.stamina_mod_level);
         param1.writeInt(this.armor_mod_level);
         param1.writeInt(this.damage_mod_level);
         param1.writeInt(this.recover_mod_level);
      }
   }
}

