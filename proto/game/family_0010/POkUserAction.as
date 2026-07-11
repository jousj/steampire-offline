package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PUserEvent;
   
   public class POkUserAction implements IClientPacket
   {
      
      public var events:Array;
      
      public var server_time:Number;
      
      public function POkUserAction()
      {
         super();
      }
      
      public static function create(param1:Array, param2:Number) : POkUserAction
      {
         var _loc3_:POkUserAction = new POkUserAction();
         _loc3_.events = param1;
         _loc3_.server_time = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : POkUserAction
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:POkUserAction = new POkUserAction();
         _loc2_.events = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.events.length)
         {
            _loc2_.events[_loc3_] = _loc4_ = PUserEvent.read(param1);
            _loc3_++;
         }
         _loc2_.server_time = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(this.events == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.events.length);
            _loc2_ = 0;
            while(_loc2_ < this.events.length)
            {
               this.events[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeDouble(this.server_time);
      }
   }
}

