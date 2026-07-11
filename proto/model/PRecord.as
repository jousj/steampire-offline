package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PRecord implements IClientPacket
   {
      
      public var season:int;
      
      public var clan:PHallClan;
      
      public function PRecord()
      {
         super();
      }
      
      public static function create(param1:int, param2:PHallClan) : PRecord
      {
         var _loc3_:PRecord = new PRecord();
         _loc3_.season = param1;
         _loc3_.clan = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PRecord
      {
         var _loc2_:PRecord = new PRecord();
         _loc2_.season = param1.readInt();
         _loc2_.clan = PHallClan.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.season);
         this.clan.write(param1);
      }
   }
}

