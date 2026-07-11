package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PSendMessage implements IClientPacket
   {
      
      public var sm_to:PChatMember;
      
      public var sm_data:String;
      
      public function PSendMessage()
      {
         super();
      }
      
      public static function create(param1:PChatMember, param2:String) : PSendMessage
      {
         var _loc3_:PSendMessage = new PSendMessage();
         _loc3_.sm_to = param1;
         _loc3_.sm_data = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PSendMessage
      {
         var _loc2_:PSendMessage = new PSendMessage();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.sm_to = PChatMember.read(param1);
         }
         else
         {
            _loc2_.sm_to = null;
         }
         _loc2_.sm_data = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         if(this.sm_to != null)
         {
            param1.writeByte(1);
            this.sm_to.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeUTF(this.sm_data);
      }
   }
}

