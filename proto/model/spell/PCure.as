package proto.model.spell
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCure implements IClientPacket
   {
      
      public var cure_duration:int;
      
      public var cure_count:int;
      
      public var cure_stamina:int;
      
      public var cure_radius:int;
      
      public function PCure()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:int, param4:int) : PCure
      {
         var _loc5_:PCure = new PCure();
         _loc5_.cure_duration = param1;
         _loc5_.cure_count = param2;
         _loc5_.cure_stamina = param3;
         _loc5_.cure_radius = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PCure
      {
         var _loc2_:PCure = new PCure();
         _loc2_.cure_duration = param1.readInt();
         _loc2_.cure_count = param1.readInt();
         _loc2_.cure_stamina = param1.readInt();
         _loc2_.cure_radius = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.cure_duration);
         param1.writeInt(this.cure_count);
         param1.writeInt(this.cure_stamina);
         param1.writeInt(this.cure_radius);
      }
   }
}

