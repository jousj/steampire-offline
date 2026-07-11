package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopTerritory implements IClientPacket
   {
      
      public var ter_kind:String;
      
      public var ter_attack_price:Array;
      
      public var ter_region:String;
      
      public var ter_position_0:int;
      
      public var ter_position_1:int;
      
      public var ter_mission_kind:String;
      
      public var ter_resource_cost:Array;
      
      public var ter_resource_time:Number;
      
      public function PShopTerritory()
      {
         super();
      }
      
      public static function create(param1:String, param2:Array, param3:String, param4:int, param5:int, param6:String, param7:Array, param8:Number) : PShopTerritory
      {
         var _loc9_:PShopTerritory = new PShopTerritory();
         _loc9_.ter_kind = param1;
         _loc9_.ter_attack_price = param2;
         _loc9_.ter_region = param3;
         _loc9_.ter_position_0 = param4;
         _loc9_.ter_position_1 = param5;
         _loc9_.ter_mission_kind = param6;
         _loc9_.ter_resource_cost = param7;
         _loc9_.ter_resource_time = param8;
         return _loc9_;
      }
      
      public static function read(param1:IDataInput) : PShopTerritory
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PShopTerritory = new PShopTerritory();
         _loc2_.ter_kind = param1.readUTF();
         _loc2_.ter_attack_price = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ter_attack_price.length)
         {
            _loc2_.ter_attack_price[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.ter_region = param1.readUTF();
         _loc2_.ter_position_0 = param1.readInt();
         _loc2_.ter_position_1 = param1.readInt();
         _loc2_.ter_mission_kind = param1.readUTF();
         _loc2_.ter_resource_cost = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ter_resource_cost.length)
         {
            _loc2_.ter_resource_cost[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.ter_resource_time = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.ter_kind);
         if(this.ter_attack_price == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ter_attack_price.length);
            _loc2_ = 0;
            while(_loc2_ < this.ter_attack_price.length)
            {
               this.ter_attack_price[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeUTF(this.ter_region);
         param1.writeInt(this.ter_position_0);
         param1.writeInt(this.ter_position_1);
         param1.writeUTF(this.ter_mission_kind);
         if(this.ter_resource_cost == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ter_resource_cost.length);
            _loc2_ = 0;
            while(_loc2_ < this.ter_resource_cost.length)
            {
               this.ter_resource_cost[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeDouble(this.ter_resource_time);
      }
   }
}

