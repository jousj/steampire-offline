package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PHallSeason implements IClientPacket
   {
      
      public var season:int;
      
      public var places:Array;
      
      public function PHallSeason()
      {
         super();
      }
      
      public static function create(param1:int, param2:Array) : PHallSeason
      {
         var _loc3_:PHallSeason = new PHallSeason();
         _loc3_.season = param1;
         _loc3_.places = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PHallSeason
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PHallSeason = new PHallSeason();
         _loc2_.season = param1.readInt();
         _loc2_.places = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.places.length)
         {
            _loc2_.places[_loc3_] = _loc4_ = PHallClan.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.season);
         if(this.places == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.places.length);
            _loc2_ = 0;
            while(_loc2_ < this.places.length)
            {
               this.places[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

