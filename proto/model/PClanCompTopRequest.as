package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanCompTopRequest implements IClientPacket
   {
      
      public var season_num:uint;
      
      public var from_place:uint;
      
      public var count:uint;
      
      public function PClanCompTopRequest()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint) : PClanCompTopRequest
      {
         var _loc4_:PClanCompTopRequest = new PClanCompTopRequest();
         _loc4_.season_num = param1;
         _loc4_.from_place = param2;
         _loc4_.count = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PClanCompTopRequest
      {
         var _loc2_:PClanCompTopRequest = new PClanCompTopRequest();
         _loc2_.season_num = param1.readUnsignedInt();
         _loc2_.from_place = param1.readUnsignedInt();
         _loc2_.count = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.season_num);
         param1.writeInt(this.from_place);
         param1.writeInt(this.count);
      }
   }
}

