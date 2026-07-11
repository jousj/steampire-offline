package proto.model.spell
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PRage implements IClientPacket
   {
      
      public var rage_move_k:Number;
      
      public var rage_attack_k:Number;
      
      public var rage_duration:int;
      
      public var rage_radius:int;
      
      public function PRage()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Number, param3:int, param4:int) : PRage
      {
         var _loc5_:PRage = new PRage();
         _loc5_.rage_move_k = param1;
         _loc5_.rage_attack_k = param2;
         _loc5_.rage_duration = param3;
         _loc5_.rage_radius = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PRage
      {
         var _loc2_:PRage = new PRage();
         _loc2_.rage_move_k = param1.readDouble();
         _loc2_.rage_attack_k = param1.readDouble();
         _loc2_.rage_duration = param1.readInt();
         _loc2_.rage_radius = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeDouble(this.rage_move_k);
         param1.writeDouble(this.rage_attack_k);
         param1.writeInt(this.rage_duration);
         param1.writeInt(this.rage_radius);
      }
   }
}

