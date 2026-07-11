package proto.model.spell
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShock implements IClientPacket
   {
      
      public var shock_radius:int;
      
      public var shock_duration:int;
      
      public function PShock()
      {
         super();
      }
      
      public static function create(param1:int, param2:int) : PShock
      {
         var _loc3_:PShock = new PShock();
         _loc3_.shock_radius = param1;
         _loc3_.shock_duration = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PShock
      {
         var _loc2_:PShock = new PShock();
         _loc2_.shock_radius = param1.readInt();
         _loc2_.shock_duration = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.shock_radius);
         param1.writeInt(this.shock_duration);
      }
   }
}

