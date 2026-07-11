package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopGuard implements IClientPacket
   {
      
      public var sga_kind:String;
      
      public var sga_level:uint;
      
      public var sga_capacity:uint;
      
      public var sga_charge_count:uint;
      
      public var sga_radius:uint;
      
      public function PShopGuard()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:uint, param4:uint, param5:uint) : PShopGuard
      {
         var _loc6_:PShopGuard = new PShopGuard();
         _loc6_.sga_kind = param1;
         _loc6_.sga_level = param2;
         _loc6_.sga_capacity = param3;
         _loc6_.sga_charge_count = param4;
         _loc6_.sga_radius = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PShopGuard
      {
         var _loc2_:PShopGuard = new PShopGuard();
         _loc2_.sga_kind = param1.readUTF();
         _loc2_.sga_level = param1.readUnsignedByte();
         _loc2_.sga_capacity = param1.readUnsignedInt();
         _loc2_.sga_charge_count = param1.readUnsignedInt();
         _loc2_.sga_radius = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.sga_kind);
         param1.writeByte(this.sga_level);
         param1.writeInt(this.sga_capacity);
         param1.writeInt(this.sga_charge_count);
         param1.writeByte(this.sga_radius);
      }
   }
}

