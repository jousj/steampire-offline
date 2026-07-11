package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PCommand;
   
   public class PTerritoryCommand implements IClientPacket
   {
      
      public var ter_command:PCommand;
      
      public var ter_kind:String;
      
      public function PTerritoryCommand()
      {
         super();
      }
      
      public static function create(param1:PCommand, param2:String) : PTerritoryCommand
      {
         var _loc3_:PTerritoryCommand = new PTerritoryCommand();
         _loc3_.ter_command = param1;
         _loc3_.ter_kind = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PTerritoryCommand
      {
         var _loc2_:PTerritoryCommand = new PTerritoryCommand();
         _loc2_.ter_command = PCommand.read(param1);
         _loc2_.ter_kind = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.ter_command.write(param1);
         param1.writeUTF(this.ter_kind);
      }
   }
}

