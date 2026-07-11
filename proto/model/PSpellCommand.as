package proto.model
{
   import engine.Position;
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PSpellCommand implements IClientPacket
   {
      
      public var pscm_kind:String;
      
      public var pscm_pos:Position;
      
      public function PSpellCommand()
      {
         super();
      }
      
      public static function create(param1:String, param2:Position) : PSpellCommand
      {
         var _loc3_:PSpellCommand = new PSpellCommand();
         _loc3_.pscm_kind = param1;
         _loc3_.pscm_pos = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PSpellCommand
      {
         var _loc2_:PSpellCommand = new PSpellCommand();
         _loc2_.pscm_kind = param1.readUTF();
         _loc2_.pscm_pos = Position.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.pscm_kind);
         this.pscm_pos.write(param1);
      }
   }
}

