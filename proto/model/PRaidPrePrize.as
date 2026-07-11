package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PRaidPrePrize implements IClientPacket
   {
      
      public var user_id:String;
      
      public var pre_prize:Array;
      
      public function PRaidPrePrize()
      {
         super();
      }
      
      public static function create(param1:String, param2:Array) : PRaidPrePrize
      {
         var _loc3_:PRaidPrePrize = new PRaidPrePrize();
         _loc3_.user_id = param1;
         _loc3_.pre_prize = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PRaidPrePrize
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PRaidPrePrize = new PRaidPrePrize();
         _loc2_.user_id = param1.readUTF();
         _loc2_.pre_prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.pre_prize.length)
         {
            _loc2_.pre_prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.user_id);
         if(this.pre_prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.pre_prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.pre_prize.length)
            {
               this.pre_prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

