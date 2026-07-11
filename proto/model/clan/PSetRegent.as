package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PSetRegent implements IClientPacket
   {
      
      public var sr_ter_kind:String;
      
      public var sr_regent:String;
      
      public function PSetRegent()
      {
         super();
      }
      
      public static function create(param1:String, param2:String) : PSetRegent
      {
         var _loc3_:PSetRegent = new PSetRegent();
         _loc3_.sr_ter_kind = param1;
         _loc3_.sr_regent = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PSetRegent
      {
         var _loc2_:PSetRegent = new PSetRegent();
         _loc2_.sr_ter_kind = param1.readUTF();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.sr_regent = param1.readUTF();
         }
         else
         {
            _loc2_.sr_regent = null;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.sr_ter_kind);
         if(this.sr_regent != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.sr_regent);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

