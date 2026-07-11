package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopScoutingPack implements IClientPacket
   {
      
      public var sp_num:int;
      
      public var sp_duration:Number;
      
      public var sp_price:Array;
      
      public function PShopScoutingPack()
      {
         super();
      }
      
      public static function create(param1:int, param2:Number, param3:Array) : PShopScoutingPack
      {
         var _loc4_:PShopScoutingPack = new PShopScoutingPack();
         _loc4_.sp_num = param1;
         _loc4_.sp_duration = param2;
         _loc4_.sp_price = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PShopScoutingPack
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PShopScoutingPack = new PShopScoutingPack();
         _loc2_.sp_num = param1.readInt();
         _loc2_.sp_duration = param1.readDouble();
         _loc2_.sp_price = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.sp_price.length)
         {
            _loc2_.sp_price[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.sp_num);
         param1.writeDouble(this.sp_duration);
         if(this.sp_price == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.sp_price.length);
            _loc2_ = 0;
            while(_loc2_ < this.sp_price.length)
            {
               this.sp_price[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

