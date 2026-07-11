package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopRaidCooldown implements IClientPacket
   {
      
      public var src_kind:String;
      
      public var src_time:Number;
      
      public var src_hglory_k:Number;
      
      public var src_greenore_k:Number;
      
      public function PShopRaidCooldown()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number, param3:Number, param4:Number) : PShopRaidCooldown
      {
         var _loc5_:PShopRaidCooldown = new PShopRaidCooldown();
         _loc5_.src_kind = param1;
         _loc5_.src_time = param2;
         _loc5_.src_hglory_k = param3;
         _loc5_.src_greenore_k = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PShopRaidCooldown
      {
         var _loc2_:PShopRaidCooldown = new PShopRaidCooldown();
         _loc2_.src_kind = param1.readUTF();
         _loc2_.src_time = param1.readDouble();
         _loc2_.src_hglory_k = param1.readDouble();
         _loc2_.src_greenore_k = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.src_kind);
         param1.writeDouble(this.src_time);
         param1.writeDouble(this.src_hglory_k);
         param1.writeDouble(this.src_greenore_k);
      }
   }
}

