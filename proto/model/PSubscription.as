package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PSubscription implements IClientPacket
   {
      
      public var id:int;
      
      public var start_time:Number;
      
      public var subscription_id:int;
      
      public var canceled:Boolean;
      
      public function PSubscription()
      {
         super();
      }
      
      public static function create(param1:int, param2:Number, param3:int, param4:Boolean) : PSubscription
      {
         var _loc5_:PSubscription = new PSubscription();
         _loc5_.id = param1;
         _loc5_.start_time = param2;
         _loc5_.subscription_id = param3;
         _loc5_.canceled = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PSubscription
      {
         var _loc2_:PSubscription = new PSubscription();
         _loc2_.id = param1.readInt();
         _loc2_.start_time = param1.readDouble();
         _loc2_.subscription_id = param1.readInt();
         _loc2_.canceled = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.id);
         param1.writeDouble(this.start_time);
         param1.writeInt(this.subscription_id);
         param1.writeBoolean(this.canceled);
      }
   }
}

