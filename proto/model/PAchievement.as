package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PAchievement implements IClientPacket
   {
      
      public var achv_kind:String;
      
      public var achv_level:uint;
      
      public function PAchievement()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint) : PAchievement
      {
         var _loc3_:PAchievement = new PAchievement();
         _loc3_.achv_kind = param1;
         _loc3_.achv_level = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PAchievement
      {
         var _loc2_:PAchievement = new PAchievement();
         _loc2_.achv_kind = param1.readUTF();
         _loc2_.achv_level = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.achv_kind);
         param1.writeByte(this.achv_level);
      }
   }
}

