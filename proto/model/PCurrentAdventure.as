package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCurrentAdventure implements IClientPacket
   {
      
      public var event_id:int;
      
      public var start_time:Number;
      
      public var alive_objs:Number;
      
      public var mission_num:int;
      
      public var adventure_level:int;
      
      public var is_jaina_mission_finished:Boolean;
      
      public function PCurrentAdventure()
      {
         super();
      }
      
      public static function create(param1:int, param2:Number, param3:Number, param4:int, param5:int, param6:Boolean) : PCurrentAdventure
      {
         var _loc7_:PCurrentAdventure = new PCurrentAdventure();
         _loc7_.event_id = param1;
         _loc7_.start_time = param2;
         _loc7_.alive_objs = param3;
         _loc7_.mission_num = param4;
         _loc7_.adventure_level = param5;
         _loc7_.is_jaina_mission_finished = param6;
         return _loc7_;
      }
      
      public static function read(param1:IDataInput) : PCurrentAdventure
      {
         var _loc2_:PCurrentAdventure = new PCurrentAdventure();
         _loc2_.event_id = param1.readInt();
         _loc2_.start_time = param1.readDouble();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.alive_objs = param1.readInt();
         }
         else
         {
            _loc2_.alive_objs = NaN;
         }
         _loc2_.mission_num = param1.readInt();
         _loc2_.adventure_level = param1.readInt();
         _loc2_.is_jaina_mission_finished = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.event_id);
         param1.writeDouble(this.start_time);
         if(!isNaN(this.alive_objs))
         {
            param1.writeByte(1);
            param1.writeInt(this.alive_objs);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.mission_num);
         param1.writeInt(this.adventure_level);
         param1.writeBoolean(this.is_jaina_mission_finished);
      }
   }
}

