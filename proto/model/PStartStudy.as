package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PStartStudy implements IClientPacket
   {
      
      public var ss_building_id:uint;
      
      public var ss_unit_kind:String;
      
      public function PStartStudy()
      {
         super();
      }
      
      public static function create(param1:uint, param2:String) : PStartStudy
      {
         var _loc3_:PStartStudy = new PStartStudy();
         _loc3_.ss_building_id = param1;
         _loc3_.ss_unit_kind = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PStartStudy
      {
         var _loc2_:PStartStudy = new PStartStudy();
         _loc2_.ss_building_id = param1.readUnsignedInt();
         _loc2_.ss_unit_kind = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.ss_building_id);
         param1.writeUTF(this.ss_unit_kind);
      }
   }
}

