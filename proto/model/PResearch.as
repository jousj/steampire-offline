package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PResearch implements IClientPacket
   {
      
      public var research_unit_kind:String;
      
      public var research_start_time:Number;
      
      public function PResearch()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number) : PResearch
      {
         var _loc3_:PResearch = new PResearch();
         _loc3_.research_unit_kind = param1;
         _loc3_.research_start_time = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PResearch
      {
         var _loc2_:PResearch = new PResearch();
         _loc2_.research_unit_kind = param1.readUTF();
         _loc2_.research_start_time = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.research_unit_kind);
         param1.writeDouble(this.research_start_time);
      }
   }
}

