package proto.model.spell
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCall implements IClientPacket
   {
      
      public var call_duration:int;
      
      public function PCall()
      {
         super();
      }
      
      public static function create(param1:int) : PCall
      {
         var _loc2_:PCall = new PCall();
         _loc2_.call_duration = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PCall
      {
         var _loc2_:PCall = new PCall();
         _loc2_.call_duration = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.call_duration);
      }
   }
}

