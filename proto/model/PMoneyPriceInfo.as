package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PMoneyPriceInfo implements IClientPacket
   {
      
      public var votes:Number;
      
      public var money:int;
      
      public var caption:String;
      
      public var num:uint;
      
      public var product_id:String;
      
      public function PMoneyPriceInfo()
      {
         super();
      }
      
      public static function create(param1:Number, param2:int, param3:String, param4:uint, param5:String) : PMoneyPriceInfo
      {
         var _loc6_:PMoneyPriceInfo = new PMoneyPriceInfo();
         _loc6_.votes = param1;
         _loc6_.money = param2;
         _loc6_.caption = param3;
         _loc6_.num = param4;
         _loc6_.product_id = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PMoneyPriceInfo
      {
         var _loc2_:PMoneyPriceInfo = new PMoneyPriceInfo();
         _loc2_.votes = param1.readDouble();
         _loc2_.money = param1.readInt();
         _loc2_.caption = param1.readUTF();
         _loc2_.num = param1.readUnsignedByte();
         _loc2_.product_id = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeDouble(this.votes);
         param1.writeInt(this.money);
         param1.writeUTF(this.caption);
         param1.writeByte(this.num);
         param1.writeUTF(this.product_id);
      }
   }
}

