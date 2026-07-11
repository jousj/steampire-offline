package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanReward implements IClientPacket
   {
      
      public var place:int;
      
      public var prize:Array;
      
      public function PClanReward()
      {
         super();
      }
      
      public static function create(param1:int, param2:Array) : PClanReward
      {
         var _loc3_:PClanReward = new PClanReward();
         _loc3_.place = param1;
         _loc3_.prize = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PClanReward
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PClanReward = new PClanReward();
         _loc2_.place = param1.readInt();
         _loc2_.prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.prize.length)
         {
            _loc2_.prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.place);
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
      }
   }
}

