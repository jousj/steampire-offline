package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PHeroUpgradeKind;
   
   public class PUpgradeHero implements IClientPacket
   {
      
      public var uh_hero_kind:String;
      
      public var uh_upgrade_kind:PHeroUpgradeKind;
      
      public function PUpgradeHero()
      {
         super();
      }
      
      public static function create(param1:String, param2:PHeroUpgradeKind) : PUpgradeHero
      {
         var _loc3_:PUpgradeHero = new PUpgradeHero();
         _loc3_.uh_hero_kind = param1;
         _loc3_.uh_upgrade_kind = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PUpgradeHero
      {
         var _loc2_:PUpgradeHero = new PUpgradeHero();
         _loc2_.uh_hero_kind = param1.readUTF();
         _loc2_.uh_upgrade_kind = PHeroUpgradeKind.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.uh_hero_kind);
         this.uh_upgrade_kind.write(param1);
      }
   }
}

