package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PJainaMission implements IClientPacket
   {
      
      public var event_id:int;
      
      public var jaina_event:PJainaEvent;
      
      public function PJainaMission()
      {
         super();
      }
      
      public static function create(param1:int, param2:PJainaEvent) : PJainaMission
      {
         var _loc3_:PJainaMission = new PJainaMission();
         _loc3_.event_id = param1;
         _loc3_.jaina_event = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PJainaMission
      {
         var _loc2_:PJainaMission = new PJainaMission();
         _loc2_.event_id = param1.readInt();
         _loc2_.jaina_event = PJainaEvent.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.event_id);
         this.jaina_event.write(param1);
      }
   }
}

