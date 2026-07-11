package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PUaPacket implements IClientPacket
   {
      
      public var ua_time:Number;
      
      public var ua_event:PUserAction;
      
      public function PUaPacket()
      {
         super();
      }
      
      public static function create(param1:Number, param2:PUserAction) : PUaPacket
      {
         var _loc3_:PUaPacket = new PUaPacket();
         _loc3_.ua_time = param1;
         _loc3_.ua_event = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PUaPacket
      {
         var _loc2_:PUaPacket = new PUaPacket();
         _loc2_.ua_time = param1.readDouble();
         _loc2_.ua_event = PUserAction.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeDouble(this.ua_time);
         this.ua_event.write(param1);
      }
   }
}

