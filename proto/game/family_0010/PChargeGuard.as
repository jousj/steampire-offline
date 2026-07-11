package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PChargeGuard implements IClientPacket
   {
      
      public var cg_building_id:uint;
      
      public var cg_is_charge:Boolean;
      
      public var cg_count:uint;
      
      public function PChargeGuard()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Boolean, param3:uint) : PChargeGuard
      {
         var _loc4_:PChargeGuard = new PChargeGuard();
         _loc4_.cg_building_id = param1;
         _loc4_.cg_is_charge = param2;
         _loc4_.cg_count = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PChargeGuard
      {
         var _loc2_:PChargeGuard = new PChargeGuard();
         _loc2_.cg_building_id = param1.readUnsignedInt();
         _loc2_.cg_is_charge = param1.readBoolean();
         _loc2_.cg_count = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.cg_building_id);
         param1.writeBoolean(this.cg_is_charge);
         param1.writeByte(this.cg_count);
      }
   }
}

