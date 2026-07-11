package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PKindCount implements IClientPacket
   {
      
      public var kind:String;
      
      public var count:uint;
      
      public function PKindCount()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint) : PKindCount
      {
         var _loc3_:PKindCount = new PKindCount();
         _loc3_.kind = param1;
         _loc3_.count = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PKindCount
      {
         var _loc2_:PKindCount = new PKindCount();
         _loc2_.kind = param1.readUTF();
         _loc2_.count = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.kind);
         param1.writeInt(this.count);
      }
   }
}

