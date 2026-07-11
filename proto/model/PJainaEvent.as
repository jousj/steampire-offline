package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PJainaEvent implements IClientPacket
   {
      
      public var je_mission:int;
      
      public var je_mission_finished:Boolean;
      
      public var je_alive_objs:int;
      
      public var je_stamina_koef:Number;
      
      public function PJainaEvent()
      {
         super();
      }
      
      public static function create(param1:int, param2:Boolean, param3:int, param4:Number) : PJainaEvent
      {
         var _loc5_:PJainaEvent = new PJainaEvent();
         _loc5_.je_mission = param1;
         _loc5_.je_mission_finished = param2;
         _loc5_.je_alive_objs = param3;
         _loc5_.je_stamina_koef = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PJainaEvent
      {
         var _loc2_:PJainaEvent = new PJainaEvent();
         _loc2_.je_mission = param1.readInt();
         _loc2_.je_mission_finished = param1.readBoolean();
         _loc2_.je_alive_objs = param1.readInt();
         _loc2_.je_stamina_koef = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.je_mission);
         param1.writeBoolean(this.je_mission_finished);
         param1.writeInt(this.je_alive_objs);
         param1.writeDouble(this.je_stamina_koef);
      }
   }
}

