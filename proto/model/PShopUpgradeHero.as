package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopUpgradeHero implements IClientPacket
   {
      
      public var shu_kind:PHeroUpgradeKind;
      
      public var shu_level:uint;
      
      public var shu_price:PCost;
      
      public var shu_effect:int;
      
      public var shu_hero_kind:String;
      
      public var shu_upgrade_requirement:PRequirement;
      
      public function PShopUpgradeHero()
      {
         super();
      }
      
      public static function create(param1:PHeroUpgradeKind, param2:uint, param3:PCost, param4:int, param5:String, param6:PRequirement) : PShopUpgradeHero
      {
         var _loc7_:PShopUpgradeHero = new PShopUpgradeHero();
         _loc7_.shu_kind = param1;
         _loc7_.shu_level = param2;
         _loc7_.shu_price = param3;
         _loc7_.shu_effect = param4;
         _loc7_.shu_hero_kind = param5;
         _loc7_.shu_upgrade_requirement = param6;
         return _loc7_;
      }
      
      public static function read(param1:IDataInput) : PShopUpgradeHero
      {
         var _loc2_:PShopUpgradeHero = new PShopUpgradeHero();
         _loc2_.shu_kind = PHeroUpgradeKind.read(param1);
         _loc2_.shu_level = param1.readUnsignedInt();
         _loc2_.shu_price = PCost.read(param1);
         _loc2_.shu_effect = param1.readInt();
         _loc2_.shu_hero_kind = param1.readUTF();
         _loc2_.shu_upgrade_requirement = PRequirement.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.shu_kind.write(param1);
         param1.writeInt(this.shu_level);
         this.shu_price.write(param1);
         param1.writeInt(this.shu_effect);
         param1.writeUTF(this.shu_hero_kind);
         this.shu_upgrade_requirement.write(param1);
      }
   }
}

