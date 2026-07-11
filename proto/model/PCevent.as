package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCevent implements IClientPacket
   {
      
      public var from_time:PCeventFrom;
      
      public var event_place:PEventPlace;
      
      public function PCevent()
      {
         super();
      }
      
      public static function create(param1:PCeventFrom, param2:PEventPlace) : PCevent
      {
         var _loc3_:PCevent = new PCevent();
         _loc3_.from_time = param1;
         _loc3_.event_place = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PCevent
      {
         var _loc2_:PCevent = new PCevent();
         _loc2_.from_time = PCeventFrom.read(param1);
         _loc2_.event_place = PEventPlace.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.from_time.write(param1);
         this.event_place.write(param1);
      }
   }
}

