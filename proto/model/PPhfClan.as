package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PPhfClan implements IClientPacket
   {
      
      public var phf_icon:String;
      
      public var phf_name:String;
      
      public function PPhfClan()
      {
         super();
      }
      
      public static function create(param1:String, param2:String) : PPhfClan
      {
         var _loc3_:PPhfClan = new PPhfClan();
         _loc3_.phf_icon = param1;
         _loc3_.phf_name = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PPhfClan
      {
         var _loc2_:PPhfClan = new PPhfClan();
         _loc2_.phf_icon = param1.readUTF();
         _loc2_.phf_name = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.phf_icon);
         param1.writeUTF(this.phf_name);
      }
   }
}

