package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PExtMission implements IClientPacket
   {
      
      public var em_kind:String;
      
      public var em_last_time:Number;
      
      public var em_next_mission:String;
      
      public function PExtMission()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number, param3:String) : PExtMission
      {
         var _loc4_:PExtMission = new PExtMission();
         _loc4_.em_kind = param1;
         _loc4_.em_last_time = param2;
         _loc4_.em_next_mission = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PExtMission
      {
         var _loc2_:PExtMission = new PExtMission();
         _loc2_.em_kind = param1.readUTF();
         _loc2_.em_last_time = param1.readDouble();
         _loc2_.em_next_mission = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.em_kind);
         param1.writeDouble(this.em_last_time);
         param1.writeUTF(this.em_next_mission);
      }
   }
}

