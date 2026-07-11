package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PMissionWin implements IClientPacket
   {
      
      public var mw_kind:String;
      
      public var mw_level:uint;
      
      public var mw_count:uint;
      
      public function PMissionWin()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:uint) : PMissionWin
      {
         var _loc4_:PMissionWin = new PMissionWin();
         _loc4_.mw_kind = param1;
         _loc4_.mw_level = param2;
         _loc4_.mw_count = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PMissionWin
      {
         var _loc2_:PMissionWin = new PMissionWin();
         _loc2_.mw_kind = param1.readUTF();
         _loc2_.mw_level = param1.readUnsignedInt();
         _loc2_.mw_count = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.mw_kind);
         param1.writeInt(this.mw_level);
         param1.writeInt(this.mw_count);
      }
   }
}

