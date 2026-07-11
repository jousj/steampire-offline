package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PTownhallDiff implements IClientPacket
   {
      
      public var td_level:int;
      
      public var td_k:Number;
      
      public function PTownhallDiff()
      {
         super();
      }
      
      public static function create(param1:int, param2:Number) : PTownhallDiff
      {
         var _loc3_:PTownhallDiff = new PTownhallDiff();
         _loc3_.td_level = param1;
         _loc3_.td_k = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PTownhallDiff
      {
         var _loc2_:PTownhallDiff = new PTownhallDiff();
         _loc2_.td_level = param1.readInt();
         _loc2_.td_k = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.td_level);
         param1.writeDouble(this.td_k);
      }
   }
}

