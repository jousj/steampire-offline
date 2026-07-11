package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PJainaMissionInfo implements IClientPacket
   {
      
      public var jmi_event_id:int;
      
      public var jmi_number:int;
      
      public var jmi_mission:String;
      
      public function PJainaMissionInfo()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:String) : PJainaMissionInfo
      {
         var _loc4_:PJainaMissionInfo = new PJainaMissionInfo();
         _loc4_.jmi_event_id = param1;
         _loc4_.jmi_number = param2;
         _loc4_.jmi_mission = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PJainaMissionInfo
      {
         var _loc2_:PJainaMissionInfo = new PJainaMissionInfo();
         _loc2_.jmi_event_id = param1.readInt();
         _loc2_.jmi_number = param1.readInt();
         _loc2_.jmi_mission = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.jmi_event_id);
         param1.writeInt(this.jmi_number);
         param1.writeUTF(this.jmi_mission);
      }
   }
}

