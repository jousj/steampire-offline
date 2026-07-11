package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanCompPlaceAnswer implements IClientPacket
   {
      
      public var season_num:uint;
      
      public var clan_id:String;
      
      public var place:Number;
      
      public var clan_points:uint;
      
      public function PClanCompPlaceAnswer()
      {
         super();
      }
      
      public static function create(param1:uint, param2:String, param3:Number, param4:uint) : PClanCompPlaceAnswer
      {
         var _loc5_:PClanCompPlaceAnswer = new PClanCompPlaceAnswer();
         _loc5_.season_num = param1;
         _loc5_.clan_id = param2;
         _loc5_.place = param3;
         _loc5_.clan_points = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PClanCompPlaceAnswer
      {
         var _loc2_:PClanCompPlaceAnswer = new PClanCompPlaceAnswer();
         _loc2_.season_num = param1.readUnsignedInt();
         _loc2_.clan_id = param1.readUTF();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.place = param1.readInt();
         }
         else
         {
            _loc2_.place = NaN;
         }
         _loc2_.clan_points = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.season_num);
         param1.writeUTF(this.clan_id);
         if(!isNaN(this.place))
         {
            param1.writeByte(1);
            param1.writeInt(this.place);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.clan_points);
      }
   }
}

