package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PUsersClanPoints implements IClientPacket
   {
      
      public var season_num:int;
      
      public var points:int;
      
      public function PUsersClanPoints()
      {
         super();
      }
      
      public static function create(param1:int, param2:int) : PUsersClanPoints
      {
         var _loc3_:PUsersClanPoints = new PUsersClanPoints();
         _loc3_.season_num = param1;
         _loc3_.points = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PUsersClanPoints
      {
         var _loc2_:PUsersClanPoints = new PUsersClanPoints();
         _loc2_.season_num = param1.readInt();
         _loc2_.points = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.season_num);
         param1.writeInt(this.points);
      }
   }
}

