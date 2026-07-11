package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PMessage implements IClientPacket
   {
      
      public var m_from:PChatMember;
      
      public var m_to:PChatMember;
      
      public var m_time:Number;
      
      public var m_data:String;
      
      public function PMessage()
      {
         super();
      }
      
      public static function create(param1:PChatMember, param2:PChatMember, param3:Number, param4:String) : PMessage
      {
         var _loc5_:PMessage = new PMessage();
         _loc5_.m_from = param1;
         _loc5_.m_to = param2;
         _loc5_.m_time = param3;
         _loc5_.m_data = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PMessage
      {
         var _loc2_:PMessage = new PMessage();
         _loc2_.m_from = PChatMember.read(param1);
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.m_to = PChatMember.read(param1);
         }
         else
         {
            _loc2_.m_to = null;
         }
         _loc2_.m_time = param1.readDouble();
         _loc2_.m_data = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.m_from.write(param1);
         if(this.m_to != null)
         {
            param1.writeByte(1);
            this.m_to.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeDouble(this.m_time);
         param1.writeUTF(this.m_data);
      }
   }
}

