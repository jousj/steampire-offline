package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.spell.PEffect;
   
   public class PShopSpell implements IClientPacket
   {
      
      public var ssp_kind:String;
      
      public var ssp_level:int;
      
      public var ssp_attack_time:int;
      
      public var ssp_price:Array;
      
      public var ssp_production_time:Number;
      
      public var ssp_upgrade_price:PCost;
      
      public var ssp_upgrade_requirement:PRequirement;
      
      public var ssp_upgrade_time:Number;
      
      public var ssp_gold_price:Array;
      
      public var ssp_can_buy:Boolean;
      
      public var ssp_effect:PEffect;
      
      public var ssp_power_price:int;
      
      public var order:uint;
      
      public function PShopSpell()
      {
         super();
      }
      
      public static function create(param1:String, param2:int, param3:int, param4:Array, param5:Number, param6:PCost, param7:PRequirement, param8:Number, param9:Array, param10:Boolean, param11:PEffect, param12:int) : PShopSpell
      {
         var _loc13_:PShopSpell = new PShopSpell();
         _loc13_.ssp_kind = param1;
         _loc13_.ssp_level = param2;
         _loc13_.ssp_attack_time = param3;
         _loc13_.ssp_price = param4;
         _loc13_.ssp_production_time = param5;
         _loc13_.ssp_upgrade_price = param6;
         _loc13_.ssp_upgrade_requirement = param7;
         _loc13_.ssp_upgrade_time = param8;
         _loc13_.ssp_gold_price = param9;
         _loc13_.ssp_can_buy = param10;
         _loc13_.ssp_effect = param11;
         _loc13_.ssp_power_price = param12;
         return _loc13_;
      }
      
      public static function read(param1:IDataInput) : PShopSpell
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PShopSpell = new PShopSpell();
         _loc2_.ssp_kind = param1.readUTF();
         _loc2_.ssp_level = param1.readInt();
         _loc2_.ssp_attack_time = param1.readInt();
         _loc2_.ssp_price = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ssp_price.length)
         {
            _loc2_.ssp_price[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.ssp_production_time = param1.readDouble();
         _loc2_.ssp_upgrade_price = PCost.read(param1);
         _loc2_.ssp_upgrade_requirement = PRequirement.read(param1);
         _loc2_.ssp_upgrade_time = param1.readDouble();
         _loc2_.ssp_gold_price = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ssp_gold_price.length)
         {
            _loc2_.ssp_gold_price[_loc3_] = _loc4_ = param1.readInt();
            _loc3_++;
         }
         _loc2_.ssp_can_buy = param1.readBoolean();
         _loc2_.ssp_effect = PEffect.read(param1);
         _loc2_.ssp_power_price = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.ssp_kind);
         param1.writeInt(this.ssp_level);
         param1.writeInt(this.ssp_attack_time);
         if(this.ssp_price == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ssp_price.length);
            _loc2_ = 0;
            while(_loc2_ < this.ssp_price.length)
            {
               this.ssp_price[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeDouble(this.ssp_production_time);
         this.ssp_upgrade_price.write(param1);
         this.ssp_upgrade_requirement.write(param1);
         param1.writeDouble(this.ssp_upgrade_time);
         if(this.ssp_gold_price == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ssp_gold_price.length);
            _loc2_ = 0;
            while(_loc2_ < this.ssp_gold_price.length)
            {
               param1.writeInt(this.ssp_gold_price[_loc2_]);
               _loc2_++;
            }
         }
         param1.writeBoolean(this.ssp_can_buy);
         this.ssp_effect.write(param1);
         param1.writeInt(this.ssp_power_price);
      }
   }
}

