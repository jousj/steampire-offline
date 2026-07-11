package proto.model
{
   import engine.Position;
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PBuilding implements IClientPacket
   {
      
      public var building_id:uint;
      
      public var building_kind:String;
      
      public var building_level:uint;
      
      public var building_pos:Position;
      
      public var building_build_state:PBuildState;
      
      public var building_spec:PBuildingSpec;
      
      public function PBuilding()
      {
         super();
      }
      
      public static function create(param1:uint, param2:String, param3:uint, param4:Position, param5:PBuildState, param6:PBuildingSpec) : PBuilding
      {
         var _loc7_:PBuilding = new PBuilding();
         _loc7_.building_id = param1;
         _loc7_.building_kind = param2;
         _loc7_.building_level = param3;
         _loc7_.building_pos = param4;
         _loc7_.building_build_state = param5;
         _loc7_.building_spec = param6;
         return _loc7_;
      }
      
      public static function read(param1:IDataInput) : PBuilding
      {
         var _loc2_:PBuilding = new PBuilding();
         _loc2_.building_id = param1.readUnsignedInt();
         _loc2_.building_kind = param1.readUTF();
         _loc2_.building_level = param1.readUnsignedShort();
         _loc2_.building_pos = Position.read(param1);
         _loc2_.building_build_state = PBuildState.read(param1);
         _loc2_.building_spec = PBuildingSpec.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.building_id);
         param1.writeUTF(this.building_kind);
         param1.writeShort(this.building_level);
         this.building_pos.write(param1);
         this.building_build_state.write(param1);
         this.building_spec.write(param1);
      }
   }
}

