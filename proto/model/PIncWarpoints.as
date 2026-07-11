package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PIncWarpoints implements IClientPacket
   {
      
      public var iw_clan_id:String;
      
      public var iw_count:int;
      
      public function PIncWarpoints()
      {
         super();
      }
      
      public static function create(param1:String, param2:int) : PIncWarpoints
      {
         var _loc3_:PIncWarpoints = new PIncWarpoints();
         _loc3_.iw_clan_id = param1;
         _loc3_.iw_count = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PIncWarpoints
      {
         var _loc2_:PIncWarpoints = new PIncWarpoints();
         _loc2_.iw_clan_id = param1.readUTF();
         _loc2_.iw_count = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.iw_clan_id);
         param1.writeInt(this.iw_count);
      }
   }
}

