package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_i;
   
   public class PGroupFightInfo implements IClientPacket
   {
      
      public var fgi_raid_kind:String;
      
      public var fgi_mission_kind:String;
      
      public var fgi_members:Array;
      
      public var fgi_units_levels:Array;
      
      public var fgi_create_time:Number;
      
      public var fgi_time:Number;
      
      public var fgi_hspaces:Array;
      
      public var fgi_pre_prize:Array;
      
      public function PGroupFightInfo()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:Array, param4:Array, param5:Number, param6:Number, param7:Array, param8:Array) : PGroupFightInfo
      {
         var _loc9_:PGroupFightInfo = new PGroupFightInfo();
         _loc9_.fgi_raid_kind = param1;
         _loc9_.fgi_mission_kind = param2;
         _loc9_.fgi_members = param3;
         _loc9_.fgi_units_levels = param4;
         _loc9_.fgi_create_time = param5;
         _loc9_.fgi_time = param6;
         _loc9_.fgi_hspaces = param7;
         _loc9_.fgi_pre_prize = param8;
         return _loc9_;
      }
      
      public static function read(param1:IDataInput) : PGroupFightInfo
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PGroupFightInfo = new PGroupFightInfo();
         _loc2_.fgi_raid_kind = param1.readUTF();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.fgi_mission_kind = param1.readUTF();
         }
         else
         {
            _loc2_.fgi_mission_kind = null;
         }
         _loc2_.fgi_members = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.fgi_members.length)
         {
            _loc2_.fgi_members[_loc3_] = _loc4_ = PUserBase.read(param1);
            _loc3_++;
         }
         _loc2_.fgi_units_levels = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.fgi_units_levels.length)
         {
            _loc2_.fgi_units_levels[_loc3_] = _loc4_ = PGroupUnitsInfo.read(param1);
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.fgi_create_time = param1.readDouble();
         }
         else
         {
            _loc2_.fgi_create_time = NaN;
         }
         _loc2_.fgi_time = param1.readDouble();
         _loc2_.fgi_hspaces = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.fgi_hspaces.length)
         {
            _loc2_.fgi_hspaces[_loc3_] = _loc4_ = str_i.read(param1);
            _loc3_++;
         }
         _loc2_.fgi_pre_prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.fgi_pre_prize.length)
         {
            _loc2_.fgi_pre_prize[_loc3_] = _loc4_ = PRaidPrePrize.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.fgi_raid_kind);
         if(this.fgi_mission_kind != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.fgi_mission_kind);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.fgi_members == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.fgi_members.length);
            _loc2_ = 0;
            while(_loc2_ < this.fgi_members.length)
            {
               this.fgi_members[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.fgi_units_levels == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.fgi_units_levels.length);
            _loc2_ = 0;
            while(_loc2_ < this.fgi_units_levels.length)
            {
               this.fgi_units_levels[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(!isNaN(this.fgi_create_time))
         {
            param1.writeByte(1);
            param1.writeDouble(this.fgi_create_time);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeDouble(this.fgi_time);
         if(this.fgi_hspaces == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.fgi_hspaces.length);
            _loc2_ = 0;
            while(_loc2_ < this.fgi_hspaces.length)
            {
               this.fgi_hspaces[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.fgi_pre_prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.fgi_pre_prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.fgi_pre_prize.length)
            {
               this.fgi_pre_prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

