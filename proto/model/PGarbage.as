package proto.model
{
   import engine.Position;
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PGarbage implements IClientPacket
   {
      
      public var garbage_id:uint;
      
      public var garbage_kind:String;
      
      public var garbage_pos:Position;
      
      public var garbage_start_remove:Number;
      
      public var garbage_remove_prize:PCost;
      
      public function PGarbage()
      {
         super();
      }
      
      public static function create(param1:uint, param2:String, param3:Position, param4:Number, param5:PCost) : PGarbage
      {
         var _loc6_:PGarbage = new PGarbage();
         _loc6_.garbage_id = param1;
         _loc6_.garbage_kind = param2;
         _loc6_.garbage_pos = param3;
         _loc6_.garbage_start_remove = param4;
         _loc6_.garbage_remove_prize = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PGarbage
      {
         var _loc2_:PGarbage = new PGarbage();
         _loc2_.garbage_id = param1.readUnsignedInt();
         _loc2_.garbage_kind = param1.readUTF();
         _loc2_.garbage_pos = Position.read(param1);
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.garbage_start_remove = param1.readDouble();
         }
         else
         {
            _loc2_.garbage_start_remove = NaN;
         }
         _loc2_.garbage_remove_prize = PCost.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.garbage_id);
         param1.writeUTF(this.garbage_kind);
         this.garbage_pos.write(param1);
         if(!isNaN(this.garbage_start_remove))
         {
            param1.writeByte(1);
            param1.writeDouble(this.garbage_start_remove);
         }
         else
         {
            param1.writeByte(0);
         }
         this.garbage_remove_prize.write(param1);
      }
   }
}

