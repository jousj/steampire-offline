package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PUserClanPointsAnswer implements IClientPacket
   {
      
      public var user_id:String;
      
      public var clan_points:PUsersClanPoints;
      
      public var ratio:int;
      
      public function PUserClanPointsAnswer()
      {
         super();
      }
      
      public static function create(param1:String, param2:PUsersClanPoints, param3:int) : PUserClanPointsAnswer
      {
         var _loc4_:PUserClanPointsAnswer = new PUserClanPointsAnswer();
         _loc4_.user_id = param1;
         _loc4_.clan_points = param2;
         _loc4_.ratio = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PUserClanPointsAnswer
      {
         var _loc2_:PUserClanPointsAnswer = new PUserClanPointsAnswer();
         _loc2_.user_id = param1.readUTF();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.clan_points = PUsersClanPoints.read(param1);
         }
         else
         {
            _loc2_.clan_points = null;
         }
         _loc2_.ratio = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.user_id);
         if(this.clan_points != null)
         {
            param1.writeByte(1);
            this.clan_points.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.ratio);
      }
   }
}

