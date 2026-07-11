package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_uint;
   
   public class PQuestInfo implements IClientPacket
   {
      
      public var qi_prev:Array;
      
      public var qi_level:Number;
      
      public var qi_icon:String;
      
      public var qi_disabled:Boolean;
      
      public var qi_targets:Array;
      
      public var qi_nesting_level:Number;
      
      public var qi_story:String;
      
      public var qi_refusal:Boolean;
      
      public var qi_prize:Array;
      
      public var qi_achievement:PAchievement;
      
      public var qi_prize_units:Array;
      
      public function PQuestInfo()
      {
         super();
      }
      
      public static function create(param1:Array, param2:Number, param3:String, param4:Boolean, param5:Array, param6:Number, param7:String, param8:Boolean, param9:Array, param10:PAchievement, param11:Array) : PQuestInfo
      {
         var _loc12_:PQuestInfo = new PQuestInfo();
         _loc12_.qi_prev = param1;
         _loc12_.qi_level = param2;
         _loc12_.qi_icon = param3;
         _loc12_.qi_disabled = param4;
         _loc12_.qi_targets = param5;
         _loc12_.qi_nesting_level = param6;
         _loc12_.qi_story = param7;
         _loc12_.qi_refusal = param8;
         _loc12_.qi_prize = param9;
         _loc12_.qi_achievement = param10;
         _loc12_.qi_prize_units = param11;
         return _loc12_;
      }
      
      public static function read(param1:IDataInput) : PQuestInfo
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PQuestInfo = new PQuestInfo();
         _loc2_.qi_prev = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.qi_prev.length)
         {
            _loc2_.qi_prev[_loc3_] = _loc4_ = PQuestPrev.read(param1);
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.qi_level = param1.readInt();
         }
         else
         {
            _loc2_.qi_level = NaN;
         }
         _loc2_.qi_icon = param1.readUTF();
         _loc2_.qi_disabled = param1.readBoolean();
         _loc2_.qi_targets = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.qi_targets.length)
         {
            _loc2_.qi_targets[_loc3_] = _loc4_ = PQuestTargetInfo.read(param1);
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.qi_nesting_level = param1.readUnsignedByte();
         }
         else
         {
            _loc2_.qi_nesting_level = NaN;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.qi_story = param1.readUTF();
         }
         else
         {
            _loc2_.qi_story = null;
         }
         _loc2_.qi_refusal = param1.readBoolean();
         _loc2_.qi_prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.qi_prize.length)
         {
            _loc2_.qi_prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.qi_achievement = PAchievement.read(param1);
         }
         else
         {
            _loc2_.qi_achievement = null;
         }
         _loc2_.qi_prize_units = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.qi_prize_units.length)
         {
            _loc2_.qi_prize_units[_loc3_] = _loc4_ = str_uint.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(this.qi_prev == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.qi_prev.length);
            _loc2_ = 0;
            while(_loc2_ < this.qi_prev.length)
            {
               this.qi_prev[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(!isNaN(this.qi_level))
         {
            param1.writeByte(1);
            param1.writeInt(this.qi_level);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeUTF(this.qi_icon);
         param1.writeBoolean(this.qi_disabled);
         if(this.qi_targets == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.qi_targets.length);
            _loc2_ = 0;
            while(_loc2_ < this.qi_targets.length)
            {
               this.qi_targets[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(!isNaN(this.qi_nesting_level))
         {
            param1.writeByte(1);
            param1.writeByte(this.qi_nesting_level);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.qi_story != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.qi_story);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeBoolean(this.qi_refusal);
         if(this.qi_prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.qi_prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.qi_prize.length)
            {
               this.qi_prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.qi_achievement != null)
         {
            param1.writeByte(1);
            this.qi_achievement.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.qi_prize_units == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.qi_prize_units.length);
            _loc2_ = 0;
            while(_loc2_ < this.qi_prize_units.length)
            {
               this.qi_prize_units[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

