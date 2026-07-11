package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PTargetInfo implements IClientPacket
   {
      
      public var ti_user_base:PUserBase;
      
      public var ti_um:PUm;
      
      public var ti_oil:uint;
      
      public var ti_crystal:uint;
      
      public var ti_fight_type:PFightType;
      
      public var ti_inc_ratio:int;
      
      public var ti_dec_ratio:int;
      
      public var ti_attacker_info:PAttackerInfo;
      
      public var ti_share:PShareFight;
      
      public var ti_th_diff_k:Number;
      
      public var ti_storage_fight_k:Number;
      
      public var ti_time_now:Number;
      
      public var ti_prize:Array;
      
      public var ti_my_camp_capacity:int;
      
      public var ti_warpoints:int;
      
      public var ti_fight_id:String;
      
      public var ti_ticket:Number;
      
      public var ti_is_revenge:Boolean;
      
      public var ti_war_attack:Boolean;
      
      public function PTargetInfo()
      {
         super();
      }
      
      public static function create(param1:PUserBase, param2:PUm, param3:uint, param4:uint, param5:PFightType, param6:int, param7:int, param8:PAttackerInfo, param9:PShareFight, param10:Number, param11:Number, param12:Number, param13:Array, param14:int, param15:int, param16:String, param17:Number, param18:Boolean, param19:Boolean) : PTargetInfo
      {
         var _loc20_:PTargetInfo = new PTargetInfo();
         _loc20_.ti_user_base = param1;
         _loc20_.ti_um = param2;
         _loc20_.ti_oil = param3;
         _loc20_.ti_crystal = param4;
         _loc20_.ti_fight_type = param5;
         _loc20_.ti_inc_ratio = param6;
         _loc20_.ti_dec_ratio = param7;
         _loc20_.ti_attacker_info = param8;
         _loc20_.ti_share = param9;
         _loc20_.ti_th_diff_k = param10;
         _loc20_.ti_storage_fight_k = param11;
         _loc20_.ti_time_now = param12;
         _loc20_.ti_prize = param13;
         _loc20_.ti_my_camp_capacity = param14;
         _loc20_.ti_warpoints = param15;
         _loc20_.ti_fight_id = param16;
         _loc20_.ti_ticket = param17;
         _loc20_.ti_is_revenge = param18;
         _loc20_.ti_war_attack = param19;
         return _loc20_;
      }
      
      public static function read(param1:IDataInput) : PTargetInfo
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PTargetInfo = new PTargetInfo();
         _loc2_.ti_user_base = PUserBase.read(param1);
         _loc2_.ti_um = PUm.read(param1);
         _loc2_.ti_oil = param1.readUnsignedInt();
         _loc2_.ti_crystal = param1.readUnsignedInt();
         _loc2_.ti_fight_type = PFightType.read(param1);
         _loc2_.ti_inc_ratio = param1.readInt();
         _loc2_.ti_dec_ratio = param1.readInt();
         _loc2_.ti_attacker_info = PAttackerInfo.read(param1);
         _loc2_.ti_share = PShareFight.read(param1);
         _loc2_.ti_th_diff_k = param1.readDouble();
         _loc2_.ti_storage_fight_k = param1.readDouble();
         _loc2_.ti_time_now = param1.readDouble();
         _loc2_.ti_prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.ti_prize.length)
         {
            _loc2_.ti_prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.ti_my_camp_capacity = param1.readInt();
         _loc2_.ti_warpoints = param1.readInt();
         _loc2_.ti_fight_id = param1.readUTF();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.ti_ticket = param1.readInt();
         }
         else
         {
            _loc2_.ti_ticket = NaN;
         }
         _loc2_.ti_is_revenge = param1.readBoolean();
         _loc2_.ti_war_attack = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         this.ti_user_base.write(param1);
         this.ti_um.write(param1);
         param1.writeInt(this.ti_oil);
         param1.writeInt(this.ti_crystal);
         this.ti_fight_type.write(param1);
         param1.writeInt(this.ti_inc_ratio);
         param1.writeInt(this.ti_dec_ratio);
         this.ti_attacker_info.write(param1);
         this.ti_share.write(param1);
         param1.writeDouble(this.ti_th_diff_k);
         param1.writeDouble(this.ti_storage_fight_k);
         param1.writeDouble(this.ti_time_now);
         if(this.ti_prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.ti_prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.ti_prize.length)
            {
               this.ti_prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.ti_my_camp_capacity);
         param1.writeInt(this.ti_warpoints);
         param1.writeUTF(this.ti_fight_id);
         if(!isNaN(this.ti_ticket))
         {
            param1.writeByte(1);
            param1.writeInt(this.ti_ticket);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeBoolean(this.ti_is_revenge);
         param1.writeBoolean(this.ti_war_attack);
      }
   }
}

