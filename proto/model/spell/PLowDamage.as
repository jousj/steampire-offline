package proto.model.spell
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PLowDamage implements IClientPacket
   {
      
      public var low_damage_radius:int;
      
      public var low_damage_duration:int;
      
      public var low_damage_k:Number;
      
      public function PLowDamage()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:Number) : PLowDamage
      {
         var _loc4_:PLowDamage = new PLowDamage();
         _loc4_.low_damage_radius = param1;
         _loc4_.low_damage_duration = param2;
         _loc4_.low_damage_k = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PLowDamage
      {
         var _loc2_:PLowDamage = new PLowDamage();
         _loc2_.low_damage_radius = param1.readInt();
         _loc2_.low_damage_duration = param1.readInt();
         _loc2_.low_damage_k = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.low_damage_radius);
         param1.writeInt(this.low_damage_duration);
         param1.writeDouble(this.low_damage_k);
      }
   }
}

