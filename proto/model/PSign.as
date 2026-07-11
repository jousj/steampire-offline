package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PSign implements IClientPacket
   {
      
      public var sign_key:String;
      
      public var sign:String;
      
      public function PSign()
      {
         super();
      }
      
      public static function create(param1:String, param2:String) : PSign
      {
         var _loc3_:PSign = new PSign();
         _loc3_.sign_key = param1;
         _loc3_.sign = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PSign
      {
         var _loc2_:PSign = new PSign();
         _loc2_.sign_key = param1.readUTF();
         _loc2_.sign = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.sign_key);
         param1.writeUTF(this.sign);
      }
   }
}

