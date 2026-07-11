package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PUserTopRequest implements IClientPacket
   {
      
      public var utr_from_place:Number;
      
      public var utr_count:int;
      
      public var utr_division:Number;
      
      public function PUserTopRequest()
      {
         super();
      }
      
      public static function create(param1:Number, param2:int, param3:Number) : PUserTopRequest
      {
         var _loc4_:PUserTopRequest = new PUserTopRequest();
         _loc4_.utr_from_place = param1;
         _loc4_.utr_count = param2;
         _loc4_.utr_division = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PUserTopRequest
      {
         var _loc2_:PUserTopRequest = new PUserTopRequest();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.utr_from_place = param1.readInt();
         }
         else
         {
            _loc2_.utr_from_place = NaN;
         }
         _loc2_.utr_count = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.utr_division = param1.readInt();
         }
         else
         {
            _loc2_.utr_division = NaN;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         if(!isNaN(this.utr_from_place))
         {
            param1.writeByte(1);
            param1.writeInt(this.utr_from_place);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.utr_count);
         if(!isNaN(this.utr_division))
         {
            param1.writeByte(1);
            param1.writeInt(this.utr_division);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

