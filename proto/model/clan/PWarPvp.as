package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PWarPvp implements IClientPacket
   {
      
      public var target_name:String;
      
      public var target_level:int;
      
      public var inc_warpoints:int;
      
      public function PWarPvp()
      {
         super();
      }
      
      public static function create(param1:String, param2:int, param3:int) : PWarPvp
      {
         var _loc4_:PWarPvp = new PWarPvp();
         _loc4_.target_name = param1;
         _loc4_.target_level = param2;
         _loc4_.inc_warpoints = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PWarPvp
      {
         var _loc2_:PWarPvp = new PWarPvp();
         _loc2_.target_name = param1.readUTF();
         _loc2_.target_level = param1.readInt();
         _loc2_.inc_warpoints = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.target_name);
         param1.writeInt(this.target_level);
         param1.writeInt(this.inc_warpoints);
      }
   }
}

