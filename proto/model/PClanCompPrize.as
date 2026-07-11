package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanCompPrize implements IClientPacket
   {
      
      public var prize:Array;
      
      public var clan_place:int;
      
      public var clan_points:int;
      
      public function PClanCompPrize()
      {
         super();
      }
      
      public static function create(param1:Array, param2:int, param3:int) : PClanCompPrize
      {
         var _loc4_:PClanCompPrize = new PClanCompPrize();
         _loc4_.prize = param1;
         _loc4_.clan_place = param2;
         _loc4_.clan_points = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PClanCompPrize
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PClanCompPrize = new PClanCompPrize();
         _loc2_.prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.prize.length)
         {
            _loc2_.prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.clan_place = param1.readInt();
         _loc2_.clan_points = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(this.prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.prize.length)
            {
               this.prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.clan_place);
         param1.writeInt(this.clan_points);
      }
   }
}

