package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PCost;
   
   public class PWar implements IClientPacket
   {
      
      public var war_start_time:Number;
      
      public var war_is_initiator:Boolean;
      
      public var war_damage:int;
      
      public var war_points:int;
      
      public var war_points_lat:Number;
      
      public var war_storm:Number;
      
      public var war_my_storm:Number;
      
      public var war_prize:Array;
      
      public var war_enemy:String;
      
      public var war_enemy_name:String;
      
      public var war_enemy_icon:String;
      
      public var war_enemy_points:int;
      
      public var war_enemy_townhall_level:int;
      
      public var war_enemy_damage:int;
      
      public function PWar()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Boolean, param3:int, param4:int, param5:Number, param6:Number, param7:Number, param8:Array, param9:String, param10:String, param11:String, param12:int, param13:int, param14:int) : PWar
      {
         var _loc15_:PWar = new PWar();
         _loc15_.war_start_time = param1;
         _loc15_.war_is_initiator = param2;
         _loc15_.war_damage = param3;
         _loc15_.war_points = param4;
         _loc15_.war_points_lat = param5;
         _loc15_.war_storm = param6;
         _loc15_.war_my_storm = param7;
         _loc15_.war_prize = param8;
         _loc15_.war_enemy = param9;
         _loc15_.war_enemy_name = param10;
         _loc15_.war_enemy_icon = param11;
         _loc15_.war_enemy_points = param12;
         _loc15_.war_enemy_townhall_level = param13;
         _loc15_.war_enemy_damage = param14;
         return _loc15_;
      }
      
      public static function read(param1:IDataInput) : PWar
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PWar = new PWar();
         _loc2_.war_start_time = param1.readDouble();
         _loc2_.war_is_initiator = param1.readBoolean();
         _loc2_.war_damage = param1.readInt();
         _loc2_.war_points = param1.readInt();
         _loc2_.war_points_lat = param1.readDouble();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.war_storm = param1.readDouble();
         }
         else
         {
            _loc2_.war_storm = NaN;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.war_my_storm = param1.readDouble();
         }
         else
         {
            _loc2_.war_my_storm = NaN;
         }
         _loc2_.war_prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.war_prize.length)
         {
            _loc2_.war_prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.war_enemy = param1.readUTF();
         _loc2_.war_enemy_name = param1.readUTF();
         _loc2_.war_enemy_icon = param1.readUTF();
         _loc2_.war_enemy_points = param1.readInt();
         _loc2_.war_enemy_townhall_level = param1.readInt();
         _loc2_.war_enemy_damage = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeDouble(this.war_start_time);
         param1.writeBoolean(this.war_is_initiator);
         param1.writeInt(this.war_damage);
         param1.writeInt(this.war_points);
         param1.writeDouble(this.war_points_lat);
         if(!isNaN(this.war_storm))
         {
            param1.writeByte(1);
            param1.writeDouble(this.war_storm);
         }
         else
         {
            param1.writeByte(0);
         }
         if(!isNaN(this.war_my_storm))
         {
            param1.writeByte(1);
            param1.writeDouble(this.war_my_storm);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.war_prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.war_prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.war_prize.length)
            {
               this.war_prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeUTF(this.war_enemy);
         param1.writeUTF(this.war_enemy_name);
         param1.writeUTF(this.war_enemy_icon);
         param1.writeInt(this.war_enemy_points);
         param1.writeInt(this.war_enemy_townhall_level);
         param1.writeInt(this.war_enemy_damage);
      }
   }
}

