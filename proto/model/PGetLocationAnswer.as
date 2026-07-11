package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PGetLocationAnswer implements IClientPacket
   {
      
      public var me:PUser;
      
      public var location:PLocation;
      
      public function PGetLocationAnswer()
      {
         super();
      }
      
      public static function create(param1:PUser, param2:PLocation) : PGetLocationAnswer
      {
         var _loc3_:PGetLocationAnswer = new PGetLocationAnswer();
         _loc3_.me = param1;
         _loc3_.location = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PGetLocationAnswer
      {
         var _loc2_:PGetLocationAnswer = new PGetLocationAnswer();
         _loc2_.me = PUser.read(param1);
         _loc2_.location = PLocation.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.me.write(param1);
         this.location.write(param1);
      }
   }
}

