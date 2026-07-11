package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PFinishCommand implements IClientPacket
   {
      
      public var pfcm_percentage:uint;
      
      public var pfcm_prize:Array;
      
      public function PFinishCommand()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Array) : PFinishCommand
      {
         var _loc3_:PFinishCommand = new PFinishCommand();
         _loc3_.pfcm_percentage = param1;
         _loc3_.pfcm_prize = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PFinishCommand
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PFinishCommand = new PFinishCommand();
         _loc2_.pfcm_percentage = param1.readUnsignedInt();
         _loc2_.pfcm_prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.pfcm_prize.length)
         {
            _loc2_.pfcm_prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.pfcm_percentage);
         if(this.pfcm_prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.pfcm_prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.pfcm_prize.length)
            {
               this.pfcm_prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

