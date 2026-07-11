package proto.game.family_0050
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PCurrentFight;
   import proto.model.PUserBase;
   
   public class PReplay implements IClientPacket
   {
      
      public var attacker_base:PUserBase;
      
      public var fight:PCurrentFight;
      
      public function PReplay()
      {
         super();
      }
      
      public static function create(param1:PUserBase, param2:PCurrentFight) : PReplay
      {
         var _loc3_:PReplay = new PReplay();
         _loc3_.attacker_base = param1;
         _loc3_.fight = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PReplay
      {
         var _loc2_:PReplay = new PReplay();
         _loc2_.attacker_base = PUserBase.read(param1);
         _loc2_.fight = PCurrentFight.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.attacker_base.write(param1);
         this.fight.write(param1);
      }
   }
}

