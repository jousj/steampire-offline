package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PTerritoryAttack implements IClientPacket
   {
      
      public var ta_kind:String;
      
      public var ta_level:int;
      
      public var ta_is_my:Boolean;
      
      public var ta_end_time:Number;
      
      public var ta_clan_name:String;
      
      public var ta_clan_icon:String;
      
      public var ta_clan_id:String;
      
      public var ta_aclan_id:String;
      
      public var ta_aclan_name:String;
      
      public var ta_aclan_icon:String;
      
      public function PTerritoryAttack()
      {
         super();
      }
      
      public static function create(param1:String, param2:int, param3:Boolean, param4:Number, param5:String, param6:String, param7:String, param8:String, param9:String, param10:String) : PTerritoryAttack
      {
         var _loc11_:PTerritoryAttack = new PTerritoryAttack();
         _loc11_.ta_kind = param1;
         _loc11_.ta_level = param2;
         _loc11_.ta_is_my = param3;
         _loc11_.ta_end_time = param4;
         _loc11_.ta_clan_name = param5;
         _loc11_.ta_clan_icon = param6;
         _loc11_.ta_clan_id = param7;
         _loc11_.ta_aclan_id = param8;
         _loc11_.ta_aclan_name = param9;
         _loc11_.ta_aclan_icon = param10;
         return _loc11_;
      }
      
      public static function read(param1:IDataInput) : PTerritoryAttack
      {
         var _loc2_:PTerritoryAttack = new PTerritoryAttack();
         _loc2_.ta_kind = param1.readUTF();
         _loc2_.ta_level = param1.readInt();
         _loc2_.ta_is_my = param1.readBoolean();
         _loc2_.ta_end_time = param1.readDouble();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.ta_clan_name = param1.readUTF();
         }
         else
         {
            _loc2_.ta_clan_name = null;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.ta_clan_icon = param1.readUTF();
         }
         else
         {
            _loc2_.ta_clan_icon = null;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.ta_clan_id = param1.readUTF();
         }
         else
         {
            _loc2_.ta_clan_id = null;
         }
         _loc2_.ta_aclan_id = param1.readUTF();
         _loc2_.ta_aclan_name = param1.readUTF();
         _loc2_.ta_aclan_icon = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.ta_kind);
         param1.writeInt(this.ta_level);
         param1.writeBoolean(this.ta_is_my);
         param1.writeDouble(this.ta_end_time);
         if(this.ta_clan_name != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.ta_clan_name);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.ta_clan_icon != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.ta_clan_icon);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.ta_clan_id != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.ta_clan_id);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeUTF(this.ta_aclan_id);
         param1.writeUTF(this.ta_aclan_name);
         param1.writeUTF(this.ta_aclan_icon);
      }
   }
}

