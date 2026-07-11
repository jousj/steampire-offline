package proto.model
{
   import engine.Position;
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PUnitCommand implements IClientPacket
   {
      
      public var pucm_kind:String;
      
      public var pucm_pos:Position;
      
      public var pucm_count:uint;
      
      public var pucm_vector:Position;
      
      public function PUnitCommand()
      {
         super();
      }
      
      public static function create(param1:String, param2:Position, param3:uint, param4:Position) : PUnitCommand
      {
         var _loc5_:PUnitCommand = new PUnitCommand();
         _loc5_.pucm_kind = param1;
         _loc5_.pucm_pos = param2;
         _loc5_.pucm_count = param3;
         _loc5_.pucm_vector = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PUnitCommand
      {
         var _loc2_:PUnitCommand = new PUnitCommand();
         _loc2_.pucm_kind = param1.readUTF();
         _loc2_.pucm_pos = Position.read(param1);
         _loc2_.pucm_count = param1.readUnsignedShort();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.pucm_vector = Position.read(param1);
         }
         else
         {
            _loc2_.pucm_vector = null;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.pucm_kind);
         this.pucm_pos.write(param1);
         param1.writeShort(this.pucm_count);
         if(this.pucm_vector != null)
         {
            param1.writeByte(1);
            this.pucm_vector.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

