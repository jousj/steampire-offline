package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PTerLogAction implements IClientPacket
   {
      
      public static const LOSE:uint = 2;
      
      public static const WIN:uint = 1;
      
      public static const START:uint = 0;
      
      public var variance:uint;
      
      public function PTerLogAction()
      {
         super();
      }
      
      public static function create(param1:uint) : PTerLogAction
      {
         var _loc2_:PTerLogAction = new PTerLogAction();
         _loc2_.variance = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PTerLogAction
      {
         var _loc2_:PTerLogAction = new PTerLogAction();
         _loc2_.variance = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
      }
   }
}

