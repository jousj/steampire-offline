package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PRaidFriendEvent implements IClientPacket
   {
      
      public var rf_friend_id:String;
      
      public var rf_event:PRaidEvent;
      
      public var rf_ts:Number;
      
      public function PRaidFriendEvent()
      {
         super();
      }
      
      public static function create(param1:String, param2:PRaidEvent, param3:Number) : PRaidFriendEvent
      {
         var _loc4_:PRaidFriendEvent = new PRaidFriendEvent();
         _loc4_.rf_friend_id = param1;
         _loc4_.rf_event = param2;
         _loc4_.rf_ts = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PRaidFriendEvent
      {
         var _loc2_:PRaidFriendEvent = new PRaidFriendEvent();
         _loc2_.rf_friend_id = param1.readUTF();
         _loc2_.rf_event = PRaidEvent.read(param1);
         _loc2_.rf_ts = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.rf_friend_id);
         this.rf_event.write(param1);
         param1.writeDouble(this.rf_ts);
      }
   }
}

