package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopAchv implements IClientPacket
   {
      
      public var achv_kind:String;
      
      public var achv_level:int;
      
      public var achv_points:int;
      
      public function PShopAchv()
      {
         super();
      }
      
      public static function create(param1:String, param2:int, param3:int) : PShopAchv
      {
         var _loc4_:PShopAchv = new PShopAchv();
         _loc4_.achv_kind = param1;
         _loc4_.achv_level = param2;
         _loc4_.achv_points = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PShopAchv
      {
         var _loc2_:PShopAchv = new PShopAchv();
         _loc2_.achv_kind = param1.readUTF();
         _loc2_.achv_level = param1.readInt();
         _loc2_.achv_points = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.achv_kind);
         param1.writeInt(this.achv_level);
         param1.writeInt(this.achv_points);
      }
   }
}

