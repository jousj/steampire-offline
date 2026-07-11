package proto.tuples
{
   import engine.Position;
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class str_Position implements IClientPacket
   {
      
      public var field_0:String;
      
      public var field_1:Position;
      
      public function str_Position()
      {
         super();
      }
      
      public static function create(param1:String, param2:Position) : str_Position
      {
         var _loc3_:str_Position = new str_Position();
         _loc3_.field_0 = param1;
         _loc3_.field_1 = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : str_Position
      {
         var _loc2_:str_Position = new str_Position();
         _loc2_.field_0 = param1.readUTF();
         _loc2_.field_1 = Position.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.field_0);
         this.field_1.write(param1);
      }
   }
}

