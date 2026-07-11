package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PRaidEvents implements IClientPacket
   {
      
      public var re_ev_id:int;
      
      public var re_evs:Array;
      
      public function PRaidEvents()
      {
         super();
      }
      
      public static function create(param1:int, param2:Array) : PRaidEvents
      {
         var _loc3_:PRaidEvents = new PRaidEvents();
         _loc3_.re_ev_id = param1;
         _loc3_.re_evs = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PRaidEvents
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PRaidEvents = new PRaidEvents();
         _loc2_.re_ev_id = param1.readInt();
         _loc2_.re_evs = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.re_evs.length)
         {
            _loc2_.re_evs[_loc3_] = _loc4_ = PRaidFriendEvent.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.re_ev_id);
         if(this.re_evs == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.re_evs.length);
            _loc2_ = 0;
            while(_loc2_ < this.re_evs.length)
            {
               this.re_evs[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

