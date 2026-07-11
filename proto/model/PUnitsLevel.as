package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PUnitsLevel implements IClientPacket
   {
      
      public var ul_kind:String;
      
      public var ul_level:int;
      
      public function PUnitsLevel()
      {
         super();
      }
      
      public static function create(param1:String, param2:int) : PUnitsLevel
      {
         var _loc3_:PUnitsLevel = new PUnitsLevel();
         _loc3_.ul_kind = param1;
         _loc3_.ul_level = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PUnitsLevel
      {
         var _loc2_:PUnitsLevel = new PUnitsLevel();
         _loc2_.ul_kind = param1.readUTF();
         _loc2_.ul_level = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.ul_kind);
         param1.writeInt(this.ul_level);
      }
   }
}

