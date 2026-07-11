package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PMemberLevelUp implements IClientPacket
   {
      
      public var name:String;
      
      public var level:int;
      
      public function PMemberLevelUp()
      {
         super();
      }
      
      public static function create(param1:String, param2:int) : PMemberLevelUp
      {
         var _loc3_:PMemberLevelUp = new PMemberLevelUp();
         _loc3_.name = param1;
         _loc3_.level = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PMemberLevelUp
      {
         var _loc2_:PMemberLevelUp = new PMemberLevelUp();
         _loc2_.name = param1.readUTF();
         _loc2_.level = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.name);
         param1.writeInt(this.level);
      }
   }
}

