package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopDivision implements IClientPacket
   {
      
      public var division_num:int;
      
      public var division_level:int;
      
      public var division_reward:Array;
      
      public function PShopDivision()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:Array) : PShopDivision
      {
         var _loc4_:PShopDivision = new PShopDivision();
         _loc4_.division_num = param1;
         _loc4_.division_level = param2;
         _loc4_.division_reward = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PShopDivision
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PShopDivision = new PShopDivision();
         _loc2_.division_num = param1.readInt();
         _loc2_.division_level = param1.readInt();
         _loc2_.division_reward = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.division_reward.length)
         {
            _loc2_.division_reward[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.division_num);
         param1.writeInt(this.division_level);
         if(this.division_reward == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.division_reward.length);
            _loc2_ = 0;
            while(_loc2_ < this.division_reward.length)
            {
               this.division_reward[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

