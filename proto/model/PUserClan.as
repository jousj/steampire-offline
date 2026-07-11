package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PUserClan implements IClientPacket
   {
      
      public var uc_clan_id:String;
      
      public var uc_name:String;
      
      public var uc_icon:String;
      
      public var uc_level:int;
      
      public var uc_role:PRole;
      
      public var uc_clan_calls_time:Number;
      
      public var uc_donate_oil:Number;
      
      public var uc_donate_crystal:Number;
      
      public var uc_units_can_buy:Array;
      
      public var uc_donate_mithril:Number;
      
      public function PUserClan()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:String, param4:int, param5:PRole, param6:Number, param7:Number, param8:Number, param9:Array, param10:Number) : PUserClan
      {
         var _loc11_:PUserClan = new PUserClan();
         _loc11_.uc_clan_id = param1;
         _loc11_.uc_name = param2;
         _loc11_.uc_icon = param3;
         _loc11_.uc_level = param4;
         _loc11_.uc_role = param5;
         _loc11_.uc_clan_calls_time = param6;
         _loc11_.uc_donate_oil = param7;
         _loc11_.uc_donate_crystal = param8;
         _loc11_.uc_units_can_buy = param9;
         _loc11_.uc_donate_mithril = param10;
         return _loc11_;
      }
      
      public static function read(param1:IDataInput) : PUserClan
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PUserClan = new PUserClan();
         _loc2_.uc_clan_id = param1.readUTF();
         _loc2_.uc_name = param1.readUTF();
         _loc2_.uc_icon = param1.readUTF();
         _loc2_.uc_level = param1.readInt();
         _loc2_.uc_role = PRole.read(param1);
         _loc2_.uc_clan_calls_time = param1.readDouble();
         _loc2_.uc_donate_oil = param1.readDouble();
         _loc2_.uc_donate_crystal = param1.readDouble();
         _loc2_.uc_units_can_buy = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.uc_units_can_buy.length)
         {
            _loc2_.uc_units_can_buy[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.uc_donate_mithril = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.uc_clan_id);
         param1.writeUTF(this.uc_name);
         param1.writeUTF(this.uc_icon);
         param1.writeInt(this.uc_level);
         this.uc_role.write(param1);
         param1.writeDouble(this.uc_clan_calls_time);
         param1.writeDouble(this.uc_donate_oil);
         param1.writeDouble(this.uc_donate_crystal);
         if(this.uc_units_can_buy == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.uc_units_can_buy.length);
            _loc2_ = 0;
            while(_loc2_ < this.uc_units_can_buy.length)
            {
               param1.writeUTF(this.uc_units_can_buy[_loc2_]);
               _loc2_++;
            }
         }
         param1.writeDouble(this.uc_donate_mithril);
      }
   }
}

