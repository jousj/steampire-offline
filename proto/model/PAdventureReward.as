package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PAdventureReward implements IClientPacket
   {
      
      public var kind:String;
      
      public var level:int;
      
      public var prize:Array;
      
      public function PAdventureReward()
      {
         super();
      }
      
      public static function create(param1:String, param2:int, param3:Array) : PAdventureReward
      {
         var _loc4_:PAdventureReward = new PAdventureReward();
         _loc4_.kind = param1;
         _loc4_.level = param2;
         _loc4_.prize = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PAdventureReward
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PAdventureReward = new PAdventureReward();
         _loc2_.kind = param1.readUTF();
         _loc2_.level = param1.readInt();
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
         param1.writeUTF(this.kind);
         param1.writeInt(this.level);
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

