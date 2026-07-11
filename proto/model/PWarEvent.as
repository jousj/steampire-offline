package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PWarEvent implements IClientPacket
   {
      
      public var a_clan_name:String;
      
      public var a_clan_icon:String;
      
      public var a_win_prize:Array;
      
      public var t_clan_name:String;
      
      public var t_clan_icon:String;
      
      public var t_win_prize:Array;
      
      public var is_end:Boolean;
      
      public var is_win:Boolean;
      
      public var w_start_time:Number;
      
      public var my_clan_attacker:Boolean;
      
      public function PWarEvent()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:Array, param4:String, param5:String, param6:Array, param7:Boolean, param8:Boolean, param9:Number, param10:Boolean) : PWarEvent
      {
         var _loc11_:PWarEvent = new PWarEvent();
         _loc11_.a_clan_name = param1;
         _loc11_.a_clan_icon = param2;
         _loc11_.a_win_prize = param3;
         _loc11_.t_clan_name = param4;
         _loc11_.t_clan_icon = param5;
         _loc11_.t_win_prize = param6;
         _loc11_.is_end = param7;
         _loc11_.is_win = param8;
         _loc11_.w_start_time = param9;
         _loc11_.my_clan_attacker = param10;
         return _loc11_;
      }
      
      public static function read(param1:IDataInput) : PWarEvent
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PWarEvent = new PWarEvent();
         _loc2_.a_clan_name = param1.readUTF();
         _loc2_.a_clan_icon = param1.readUTF();
         _loc2_.a_win_prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.a_win_prize.length)
         {
            _loc2_.a_win_prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.t_clan_name = param1.readUTF();
         _loc2_.t_clan_icon = param1.readUTF();
         _loc2_.t_win_prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.t_win_prize.length)
         {
            _loc2_.t_win_prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.is_end = param1.readBoolean();
         _loc2_.is_win = param1.readBoolean();
         _loc2_.w_start_time = param1.readDouble();
         _loc2_.my_clan_attacker = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.a_clan_name);
         param1.writeUTF(this.a_clan_icon);
         if(this.a_win_prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.a_win_prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.a_win_prize.length)
            {
               this.a_win_prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeUTF(this.t_clan_name);
         param1.writeUTF(this.t_clan_icon);
         if(this.t_win_prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.t_win_prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.t_win_prize.length)
            {
               this.t_win_prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeBoolean(this.is_end);
         param1.writeBoolean(this.is_win);
         param1.writeDouble(this.w_start_time);
         param1.writeBoolean(this.my_clan_attacker);
      }
   }
}

