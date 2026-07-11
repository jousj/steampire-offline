package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopShieldGen implements IClientPacket
   {
      
      public var ssg_kind:String;
      
      public var ssg_level:uint;
      
      public var ssg_time:Number;
      
      public var ssg_cooldown:Number;
      
      public function PShopShieldGen()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:Number, param4:Number) : PShopShieldGen
      {
         var _loc5_:PShopShieldGen = new PShopShieldGen();
         _loc5_.ssg_kind = param1;
         _loc5_.ssg_level = param2;
         _loc5_.ssg_time = param3;
         _loc5_.ssg_cooldown = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PShopShieldGen
      {
         var _loc2_:PShopShieldGen = new PShopShieldGen();
         _loc2_.ssg_kind = param1.readUTF();
         _loc2_.ssg_level = param1.readUnsignedInt();
         _loc2_.ssg_time = param1.readDouble();
         _loc2_.ssg_cooldown = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.ssg_kind);
         param1.writeInt(this.ssg_level);
         param1.writeDouble(this.ssg_time);
         param1.writeDouble(this.ssg_cooldown);
      }
   }
}

