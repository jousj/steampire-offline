package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PHallOfFame implements IClientPacket
   {
      
      public var record:PRecord;
      
      public var seasons:Array;
      
      public function PHallOfFame()
      {
         super();
      }
      
      public static function create(param1:PRecord, param2:Array) : PHallOfFame
      {
         var _loc3_:PHallOfFame = new PHallOfFame();
         _loc3_.record = param1;
         _loc3_.seasons = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PHallOfFame
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PHallOfFame = new PHallOfFame();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.record = PRecord.read(param1);
         }
         else
         {
            _loc2_.record = null;
         }
         _loc2_.seasons = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.seasons.length)
         {
            _loc2_.seasons[_loc3_] = _loc4_ = PHallSeason.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(this.record != null)
         {
            param1.writeByte(1);
            this.record.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.seasons == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.seasons.length);
            _loc2_ = 0;
            while(_loc2_ < this.seasons.length)
            {
               this.seasons[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

