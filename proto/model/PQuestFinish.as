package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_uint;
   
   public class PQuestFinish implements IClientPacket
   {
      
      public var qf_id:String;
      
      public var qf_prize:Array;
      
      public var qf_sign:PSign;
      
      public var qf_stage:String;
      
      public var qf_prize_units:Array;
      
      public function PQuestFinish()
      {
         super();
      }
      
      public static function create(param1:String, param2:Array, param3:PSign, param4:String, param5:Array) : PQuestFinish
      {
         var _loc6_:PQuestFinish = new PQuestFinish();
         _loc6_.qf_id = param1;
         _loc6_.qf_prize = param2;
         _loc6_.qf_sign = param3;
         _loc6_.qf_stage = param4;
         _loc6_.qf_prize_units = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PQuestFinish
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PQuestFinish = new PQuestFinish();
         _loc2_.qf_id = param1.readUTF();
         _loc2_.qf_prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.qf_prize.length)
         {
            _loc2_.qf_prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.qf_sign = PSign.read(param1);
         }
         else
         {
            _loc2_.qf_sign = null;
         }
         _loc2_.qf_stage = param1.readUTF();
         _loc2_.qf_prize_units = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.qf_prize_units.length)
         {
            _loc2_.qf_prize_units[_loc3_] = _loc4_ = str_uint.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.qf_id);
         if(this.qf_prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.qf_prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.qf_prize.length)
            {
               this.qf_prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.qf_sign != null)
         {
            param1.writeByte(1);
            this.qf_sign.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeUTF(this.qf_stage);
         if(this.qf_prize_units == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.qf_prize_units.length);
            _loc2_ = 0;
            while(_loc2_ < this.qf_prize_units.length)
            {
               this.qf_prize_units[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

