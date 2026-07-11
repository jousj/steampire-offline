package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanCompTopAnswer implements IClientPacket
   {
      
      public var season_num:uint;
      
      public var clans:Array;
      
      public var records_count:uint;
      
      public function PClanCompTopAnswer()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Array, param3:uint) : PClanCompTopAnswer
      {
         var _loc4_:PClanCompTopAnswer = new PClanCompTopAnswer();
         _loc4_.season_num = param1;
         _loc4_.clans = param2;
         _loc4_.records_count = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PClanCompTopAnswer
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PClanCompTopAnswer = new PClanCompTopAnswer();
         _loc2_.season_num = param1.readUnsignedInt();
         _loc2_.clans = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clans.length)
         {
            _loc2_.clans[_loc3_] = _loc4_ = PClanTopRecord.read(param1);
            _loc3_++;
         }
         _loc2_.records_count = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.season_num);
         if(this.clans == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.clans.length);
            _loc2_ = 0;
            while(_loc2_ < this.clans.length)
            {
               this.clans[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.records_count);
      }
   }
}

