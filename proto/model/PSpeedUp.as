package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PSpeedUp implements IClientPacket
   {
      
      public var su_obj_id:uint;
      
      public var su_cost:PCost;
      
      public function PSpeedUp()
      {
         super();
      }
      
      public static function create(param1:uint, param2:PCost) : PSpeedUp
      {
         var _loc3_:PSpeedUp = new PSpeedUp();
         _loc3_.su_obj_id = param1;
         _loc3_.su_cost = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PSpeedUp
      {
         var _loc2_:PSpeedUp = new PSpeedUp();
         _loc2_.su_obj_id = param1.readUnsignedInt();
         _loc2_.su_cost = PCost.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.su_obj_id);
         this.su_cost.write(param1);
      }
   }
}

