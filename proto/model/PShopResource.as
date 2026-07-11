package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopResource implements IClientPacket
   {
      
      public var sr_kind:String;
      
      public var sr_level:uint;
      
      public var sr_cost:PCost;
      
      public var sr_time:Number;
      
      public var sr_capacity:uint;
      
      public function PShopResource()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:PCost, param4:Number, param5:uint) : PShopResource
      {
         var _loc6_:PShopResource = new PShopResource();
         _loc6_.sr_kind = param1;
         _loc6_.sr_level = param2;
         _loc6_.sr_cost = param3;
         _loc6_.sr_time = param4;
         _loc6_.sr_capacity = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PShopResource
      {
         var _loc2_:PShopResource = new PShopResource();
         _loc2_.sr_kind = param1.readUTF();
         _loc2_.sr_level = param1.readUnsignedInt();
         _loc2_.sr_cost = PCost.read(param1);
         _loc2_.sr_time = param1.readDouble();
         _loc2_.sr_capacity = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.sr_kind);
         param1.writeInt(this.sr_level);
         this.sr_cost.write(param1);
         param1.writeDouble(this.sr_time);
         param1.writeInt(this.sr_capacity);
      }
   }
}

