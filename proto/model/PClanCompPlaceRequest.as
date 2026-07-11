package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanCompPlaceRequest implements IClientPacket
   {
      
      public var season_num:uint;
      
      public var clan_id:String;
      
      public function PClanCompPlaceRequest()
      {
         super();
      }
      
      public static function create(param1:uint, param2:String) : PClanCompPlaceRequest
      {
         var _loc3_:PClanCompPlaceRequest = new PClanCompPlaceRequest();
         _loc3_.season_num = param1;
         _loc3_.clan_id = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PClanCompPlaceRequest
      {
         var _loc2_:PClanCompPlaceRequest = new PClanCompPlaceRequest();
         _loc2_.season_num = param1.readUnsignedInt();
         _loc2_.clan_id = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.season_num);
         param1.writeUTF(this.clan_id);
      }
   }
}

