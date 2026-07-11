package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopGarbage implements IClientPacket
   {
      
      public var sg_kind:String;
      
      public var sg_remove_price:PCost;
      
      public var sg_remove_time:Number;
      
      public var sg_exp:uint;
      
      public var sg_gtype:String;
      
      public function PShopGarbage()
      {
         super();
      }
      
      public static function create(param1:String, param2:PCost, param3:Number, param4:uint, param5:String) : PShopGarbage
      {
         var _loc6_:PShopGarbage = new PShopGarbage();
         _loc6_.sg_kind = param1;
         _loc6_.sg_remove_price = param2;
         _loc6_.sg_remove_time = param3;
         _loc6_.sg_exp = param4;
         _loc6_.sg_gtype = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PShopGarbage
      {
         var _loc2_:PShopGarbage = new PShopGarbage();
         _loc2_.sg_kind = param1.readUTF();
         _loc2_.sg_remove_price = PCost.read(param1);
         _loc2_.sg_remove_time = param1.readDouble();
         _loc2_.sg_exp = param1.readUnsignedInt();
         _loc2_.sg_gtype = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.sg_kind);
         this.sg_remove_price.write(param1);
         param1.writeDouble(this.sg_remove_time);
         param1.writeInt(this.sg_exp);
         param1.writeUTF(this.sg_gtype);
      }
   }
}

