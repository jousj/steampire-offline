package proto.model
{
   import engine.Position;
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PMove implements IClientPacket
   {
      
      public var move_id:PObjectId;
      
      public var move_pos:Position;
      
      public function PMove()
      {
         super();
      }
      
      public static function create(param1:PObjectId, param2:Position) : PMove
      {
         var _loc3_:PMove = new PMove();
         _loc3_.move_id = param1;
         _loc3_.move_pos = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PMove
      {
         var _loc2_:PMove = new PMove();
         _loc2_.move_id = PObjectId.read(param1);
         _loc2_.move_pos = Position.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.move_id.write(param1);
         this.move_pos.write(param1);
      }
   }
}

