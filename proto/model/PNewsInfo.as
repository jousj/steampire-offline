package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PNewsInfo implements IClientPacket
   {
      
      public var news_kind:String;
      
      public var news_date:Number;
      
      public var news_banner:String;
      
      public var news_proto_version:int;
      
      public function PNewsInfo()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number, param3:String, param4:int) : PNewsInfo
      {
         var _loc5_:PNewsInfo = new PNewsInfo();
         _loc5_.news_kind = param1;
         _loc5_.news_date = param2;
         _loc5_.news_banner = param3;
         _loc5_.news_proto_version = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PNewsInfo
      {
         var _loc2_:PNewsInfo = new PNewsInfo();
         _loc2_.news_kind = param1.readUTF();
         _loc2_.news_date = param1.readDouble();
         _loc2_.news_banner = param1.readUTF();
         _loc2_.news_proto_version = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.news_kind);
         param1.writeDouble(this.news_date);
         param1.writeUTF(this.news_banner);
         param1.writeInt(this.news_proto_version);
      }
   }
}

