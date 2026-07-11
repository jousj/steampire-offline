package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PTerritoryAttacker implements IClientPacket
   {
      
      public var ta_end_time:Number;
      
      public var ta_clan_id:String;
      
      public var ta_clan_name:String;
      
      public var ta_clan_icon:String;
      
      public function PTerritoryAttacker()
      {
         super();
      }
      
      public static function create(param1:Number, param2:String, param3:String, param4:String) : PTerritoryAttacker
      {
         var _loc5_:PTerritoryAttacker = new PTerritoryAttacker();
         _loc5_.ta_end_time = param1;
         _loc5_.ta_clan_id = param2;
         _loc5_.ta_clan_name = param3;
         _loc5_.ta_clan_icon = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PTerritoryAttacker
      {
         var _loc2_:PTerritoryAttacker = new PTerritoryAttacker();
         _loc2_.ta_end_time = param1.readDouble();
         _loc2_.ta_clan_id = param1.readUTF();
         _loc2_.ta_clan_name = param1.readUTF();
         _loc2_.ta_clan_icon = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeDouble(this.ta_end_time);
         param1.writeUTF(this.ta_clan_id);
         param1.writeUTF(this.ta_clan_name);
         param1.writeUTF(this.ta_clan_icon);
      }
   }
}

