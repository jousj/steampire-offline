package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanInfo implements IClientPacket
   {
      
      public var ci_id:String;
      
      public var ci_icon:String;
      
      public var ci_name:String;
      
      public function PClanInfo()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:String) : PClanInfo
      {
         var _loc4_:PClanInfo = new PClanInfo();
         _loc4_.ci_id = param1;
         _loc4_.ci_icon = param2;
         _loc4_.ci_name = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PClanInfo
      {
         var _loc2_:PClanInfo = new PClanInfo();
         _loc2_.ci_id = param1.readUTF();
         _loc2_.ci_icon = param1.readUTF();
         _loc2_.ci_name = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.ci_id);
         param1.writeUTF(this.ci_icon);
         param1.writeUTF(this.ci_name);
      }
   }
}

