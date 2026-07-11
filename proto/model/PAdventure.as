package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PAdventure implements IClientPacket
   {
      
      public var event_id:int;
      
      public var current_mission:int;
      
      public var level:int;
      
      public function PAdventure()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:int) : PAdventure
      {
         var _loc4_:PAdventure = new PAdventure();
         _loc4_.event_id = param1;
         _loc4_.current_mission = param2;
         _loc4_.level = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PAdventure
      {
         var _loc2_:PAdventure = new PAdventure();
         _loc2_.event_id = param1.readInt();
         _loc2_.current_mission = param1.readInt();
         _loc2_.level = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.event_id);
         param1.writeInt(this.current_mission);
         param1.writeInt(this.level);
      }
   }
}

