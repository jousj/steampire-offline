package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopMine implements IClientPacket
   {
      
      public var mine_region:String;
      
      public var mine_level:int;
      
      public var mine_price:Array;
      
      public var mine_attack_price_addition:Array;
      
      public var mine_stamina_koef:Number;
      
      public var mine_resource_addition:Array;
      
      public var mine_time_k:Number;
      
      public function PShopMine()
      {
         super();
      }
      
      public static function create(param1:String, param2:int, param3:Array, param4:Array, param5:Number, param6:Array, param7:Number) : PShopMine
      {
         var _loc8_:PShopMine = new PShopMine();
         _loc8_.mine_region = param1;
         _loc8_.mine_level = param2;
         _loc8_.mine_price = param3;
         _loc8_.mine_attack_price_addition = param4;
         _loc8_.mine_stamina_koef = param5;
         _loc8_.mine_resource_addition = param6;
         _loc8_.mine_time_k = param7;
         return _loc8_;
      }
      
      public static function read(param1:IDataInput) : PShopMine
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PShopMine = new PShopMine();
         _loc2_.mine_region = param1.readUTF();
         _loc2_.mine_level = param1.readInt();
         _loc2_.mine_price = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.mine_price.length)
         {
            _loc2_.mine_price[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.mine_attack_price_addition = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.mine_attack_price_addition.length)
         {
            _loc2_.mine_attack_price_addition[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.mine_stamina_koef = param1.readDouble();
         _loc2_.mine_resource_addition = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.mine_resource_addition.length)
         {
            _loc2_.mine_resource_addition[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.mine_time_k = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.mine_region);
         param1.writeInt(this.mine_level);
         if(this.mine_price == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.mine_price.length);
            _loc2_ = 0;
            while(_loc2_ < this.mine_price.length)
            {
               this.mine_price[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.mine_attack_price_addition == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.mine_attack_price_addition.length);
            _loc2_ = 0;
            while(_loc2_ < this.mine_attack_price_addition.length)
            {
               this.mine_attack_price_addition[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeDouble(this.mine_stamina_koef);
         if(this.mine_resource_addition == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.mine_resource_addition.length);
            _loc2_ = 0;
            while(_loc2_ < this.mine_resource_addition.length)
            {
               this.mine_resource_addition[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeDouble(this.mine_time_k);
      }
   }
}

