package proto.model.spell
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PMultifireball implements IClientPacket
   {
      
      public var mf_count:int;
      
      public var mf_period:int;
      
      public var mf_radius:int;
      
      public var mf_damage:int;
      
      public var mf_penetration:Number;
      
      public function PMultifireball()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:int, param4:int, param5:Number) : PMultifireball
      {
         var _loc6_:PMultifireball = new PMultifireball();
         _loc6_.mf_count = param1;
         _loc6_.mf_period = param2;
         _loc6_.mf_radius = param3;
         _loc6_.mf_damage = param4;
         _loc6_.mf_penetration = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PMultifireball
      {
         var _loc2_:PMultifireball = new PMultifireball();
         _loc2_.mf_count = param1.readInt();
         _loc2_.mf_period = param1.readInt();
         _loc2_.mf_radius = param1.readInt();
         _loc2_.mf_damage = param1.readInt();
         _loc2_.mf_penetration = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.mf_count);
         param1.writeInt(this.mf_period);
         param1.writeInt(this.mf_radius);
         param1.writeInt(this.mf_damage);
         param1.writeDouble(this.mf_penetration);
      }
   }
}

