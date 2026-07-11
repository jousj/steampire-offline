package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PHallClan implements IClientPacket
   {
      
      public var id:String;
      
      public var icon:String;
      
      public var name:String;
      
      public var members_count:int;
      
      public var clan_points:int;
      
      public var wins:Array;
      
      public var place:int;
      
      public function PHallClan()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:String, param4:int, param5:int, param6:Array, param7:int) : PHallClan
      {
         var _loc8_:PHallClan = new PHallClan();
         _loc8_.id = param1;
         _loc8_.icon = param2;
         _loc8_.name = param3;
         _loc8_.members_count = param4;
         _loc8_.clan_points = param5;
         _loc8_.wins = param6;
         _loc8_.place = param7;
         return _loc8_;
      }
      
      public static function read(param1:IDataInput) : PHallClan
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PHallClan = new PHallClan();
         _loc2_.id = param1.readUTF();
         _loc2_.icon = param1.readUTF();
         _loc2_.name = param1.readUTF();
         _loc2_.members_count = param1.readInt();
         _loc2_.clan_points = param1.readInt();
         _loc2_.wins = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.wins.length)
         {
            _loc2_.wins[_loc3_] = _loc4_ = param1.readInt();
            _loc3_++;
         }
         _loc2_.place = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.id);
         param1.writeUTF(this.icon);
         param1.writeUTF(this.name);
         param1.writeInt(this.members_count);
         param1.writeInt(this.clan_points);
         if(this.wins == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.wins.length);
            _loc2_ = 0;
            while(_loc2_ < this.wins.length)
            {
               param1.writeInt(this.wins[_loc2_]);
               _loc2_++;
            }
         }
         param1.writeInt(this.place);
      }
   }
}

