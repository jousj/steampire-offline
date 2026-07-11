package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PQuestTargetInfo implements IClientPacket
   {
      
      public var qti_count:uint;
      
      public var qti_buy_finish:Array;
      
      public var qti_action:PAction;
      
      public var qti_kind:String;
      
      public var qti_level:Number;
      
      public function PQuestTargetInfo()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Array, param3:PAction, param4:String, param5:Number) : PQuestTargetInfo
      {
         var _loc6_:PQuestTargetInfo = new PQuestTargetInfo();
         _loc6_.qti_count = param1;
         _loc6_.qti_buy_finish = param2;
         _loc6_.qti_action = param3;
         _loc6_.qti_kind = param4;
         _loc6_.qti_level = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PQuestTargetInfo
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PQuestTargetInfo = new PQuestTargetInfo();
         _loc2_.qti_count = param1.readUnsignedInt();
         _loc2_.qti_buy_finish = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.qti_buy_finish.length)
         {
            _loc2_.qti_buy_finish[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.qti_action = PAction.read(param1);
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.qti_kind = param1.readUTF();
         }
         else
         {
            _loc2_.qti_kind = null;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.qti_level = param1.readInt();
         }
         else
         {
            _loc2_.qti_level = NaN;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.qti_count);
         if(this.qti_buy_finish == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.qti_buy_finish.length);
            _loc2_ = 0;
            while(_loc2_ < this.qti_buy_finish.length)
            {
               this.qti_buy_finish[_loc2_].write(param1);
               _loc2_++;
            }
         }
         this.qti_action.write(param1);
         if(this.qti_kind != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.qti_kind);
         }
         else
         {
            param1.writeByte(0);
         }
         if(!isNaN(this.qti_level))
         {
            param1.writeByte(1);
            param1.writeInt(this.qti_level);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

