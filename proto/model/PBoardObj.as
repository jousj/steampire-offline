package proto.model
{
   import engine.Position;
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PBoardObj implements IClientPacket
   {
      
      public var bo_type:PObjType;
      
      public var bo_kind:String;
      
      public var bo_pos:Position;
      
      public function PBoardObj()
      {
         super();
      }
      
      public static function create(param1:PObjType, param2:String, param3:Position) : PBoardObj
      {
         var _loc4_:PBoardObj = new PBoardObj();
         _loc4_.bo_type = param1;
         _loc4_.bo_kind = param2;
         _loc4_.bo_pos = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PBoardObj
      {
         var _loc2_:PBoardObj = new PBoardObj();
         _loc2_.bo_type = PObjType.read(param1);
         _loc2_.bo_kind = param1.readUTF();
         _loc2_.bo_pos = Position.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.bo_type.write(param1);
         param1.writeUTF(this.bo_kind);
         this.bo_pos.write(param1);
      }
   }
}

