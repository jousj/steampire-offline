package proto.model.spell
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PFog implements IClientPacket
   {
      
      public var fog_duration:int;
      
      public var fog_radius:int;
      
      public function PFog()
      {
         super();
      }
      
      public static function create(param1:int, param2:int) : PFog
      {
         var _loc3_:PFog = new PFog();
         _loc3_.fog_duration = param1;
         _loc3_.fog_radius = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PFog
      {
         var _loc2_:PFog = new PFog();
         _loc2_.fog_duration = param1.readInt();
         _loc2_.fog_radius = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.fog_duration);
         param1.writeInt(this.fog_radius);
      }
   }
}

