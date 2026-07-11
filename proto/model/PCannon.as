package proto.model
{
   import engine.Position;
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCannon implements IClientPacket
   {
      
      public var cannon_id:uint;
      
      public var cannon_kind:String;
      
      public var cannon_level:uint;
      
      public var cannon_pos:Position;
      
      public var cannon_build_state:PBuildState;
      
      public function PCannon()
      {
         super();
      }
      
      public static function create(param1:uint, param2:String, param3:uint, param4:Position, param5:PBuildState) : PCannon
      {
         var _loc6_:PCannon = new PCannon();
         _loc6_.cannon_id = param1;
         _loc6_.cannon_kind = param2;
         _loc6_.cannon_level = param3;
         _loc6_.cannon_pos = param4;
         _loc6_.cannon_build_state = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PCannon
      {
         var _loc2_:PCannon = new PCannon();
         _loc2_.cannon_id = param1.readUnsignedInt();
         _loc2_.cannon_kind = param1.readUTF();
         _loc2_.cannon_level = param1.readUnsignedByte();
         _loc2_.cannon_pos = Position.read(param1);
         _loc2_.cannon_build_state = PBuildState.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.cannon_id);
         param1.writeUTF(this.cannon_kind);
         param1.writeByte(this.cannon_level);
         this.cannon_pos.write(param1);
         this.cannon_build_state.write(param1);
      }
   }
}

