package proto.model.spell
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PFireball implements IClientPacket
   {
      
      public var fireball_radius:int;
      
      public var fireball_damage:int;
      
      public function PFireball()
      {
         super();
      }
      
      public static function create(param1:int, param2:int) : PFireball
      {
         var _loc3_:PFireball = new PFireball();
         _loc3_.fireball_radius = param1;
         _loc3_.fireball_damage = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PFireball
      {
         var _loc2_:PFireball = new PFireball();
         _loc2_.fireball_radius = param1.readInt();
         _loc2_.fireball_damage = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.fireball_radius);
         param1.writeInt(this.fireball_damage);
      }
   }
}

