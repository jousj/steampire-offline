package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class POffer implements IClientPacket
   {
      
      public var offer_kind:String;
      
      public var offer_start_time:Number;
      
      public var offer_is_gold:Boolean;
      
      public function POffer()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number, param3:Boolean) : POffer
      {
         var _loc4_:POffer = new POffer();
         _loc4_.offer_kind = param1;
         _loc4_.offer_start_time = param2;
         _loc4_.offer_is_gold = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : POffer
      {
         var _loc2_:POffer = new POffer();
         _loc2_.offer_kind = param1.readUTF();
         _loc2_.offer_start_time = param1.readDouble();
         _loc2_.offer_is_gold = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.offer_kind);
         param1.writeDouble(this.offer_start_time);
         param1.writeBoolean(this.offer_is_gold);
      }
   }
}

