package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PCost;
   
   public class PWarParams implements IClientPacket
   {
      
      public var wp_price:Array;
      
      public var wp_prize:Array;
      
      public var wp_trophy:int;
      
      public function PWarParams()
      {
         super();
      }
      
      public static function create(param1:Array, param2:Array, param3:int) : PWarParams
      {
         var _loc4_:PWarParams = new PWarParams();
         _loc4_.wp_price = param1;
         _loc4_.wp_prize = param2;
         _loc4_.wp_trophy = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PWarParams
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PWarParams = new PWarParams();
         _loc2_.wp_price = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.wp_price.length)
         {
            _loc2_.wp_price[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.wp_prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.wp_prize.length)
         {
            _loc2_.wp_prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.wp_trophy = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(this.wp_price == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.wp_price.length);
            _loc2_ = 0;
            while(_loc2_ < this.wp_price.length)
            {
               this.wp_price[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.wp_prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.wp_prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.wp_prize.length)
            {
               this.wp_prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.wp_trophy);
      }
   }
}

