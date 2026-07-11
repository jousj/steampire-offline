package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopClanIcon implements IClientPacket
   {
      
      public var sci_kind:String;
      
      public var sci_price:Array;
      
      public function PShopClanIcon()
      {
         super();
      }
      
      public static function create(param1:String, param2:Array) : PShopClanIcon
      {
         var _loc3_:PShopClanIcon = new PShopClanIcon();
         _loc3_.sci_kind = param1;
         _loc3_.sci_price = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PShopClanIcon
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PShopClanIcon = new PShopClanIcon();
         _loc2_.sci_kind = param1.readUTF();
         _loc2_.sci_price = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.sci_price.length)
         {
            _loc2_.sci_price[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.sci_kind);
         if(this.sci_price == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.sci_price.length);
            _loc2_ = 0;
            while(_loc2_ < this.sci_price.length)
            {
               this.sci_price[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

