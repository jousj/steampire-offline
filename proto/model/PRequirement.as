package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PRequirement implements IClientPacket
   {
      
      public var req_building_kind:String;
      
      public var req_building_level:uint;
      
      public function PRequirement()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint) : PRequirement
      {
         var _loc3_:PRequirement = new PRequirement();
         _loc3_.req_building_kind = param1;
         _loc3_.req_building_level = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PRequirement
      {
         var _loc2_:PRequirement = new PRequirement();
         _loc2_.req_building_kind = param1.readUTF();
         _loc2_.req_building_level = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.req_building_kind);
         param1.writeByte(this.req_building_level);
      }
   }
}

