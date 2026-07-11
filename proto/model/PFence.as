package proto.model
{
   import engine.Position;
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PFence implements IClientPacket
   {
      
      public var fence_id:uint;
      
      public var fence_kind:String;
      
      public var fence_level:uint;
      
      public var fence_pos:Position;
      
      public function PFence()
      {
         super();
      }
      
      public static function create(param1:uint, param2:String, param3:uint, param4:Position) : PFence
      {
         var _loc5_:PFence = new PFence();
         _loc5_.fence_id = param1;
         _loc5_.fence_kind = param2;
         _loc5_.fence_level = param3;
         _loc5_.fence_pos = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PFence
      {
         var _loc2_:PFence = new PFence();
         _loc2_.fence_id = param1.readUnsignedInt();
         _loc2_.fence_kind = param1.readUTF();
         _loc2_.fence_level = param1.readUnsignedByte();
         _loc2_.fence_pos = Position.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.fence_id);
         param1.writeUTF(this.fence_kind);
         param1.writeByte(this.fence_level);
         this.fence_pos.write(param1);
      }
   }
}

