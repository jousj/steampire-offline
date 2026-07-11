package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PMemberFinishBuild implements IClientPacket
   {
      
      public var name:String;
      
      public var kind:String;
      
      public var level:int;
      
      public function PMemberFinishBuild()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:int) : PMemberFinishBuild
      {
         var _loc4_:PMemberFinishBuild = new PMemberFinishBuild();
         _loc4_.name = param1;
         _loc4_.kind = param2;
         _loc4_.level = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PMemberFinishBuild
      {
         var _loc2_:PMemberFinishBuild = new PMemberFinishBuild();
         _loc2_.name = param1.readUTF();
         _loc2_.kind = param1.readUTF();
         _loc2_.level = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.name);
         param1.writeUTF(this.kind);
         param1.writeInt(this.level);
      }
   }
}

