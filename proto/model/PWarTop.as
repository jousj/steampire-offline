package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PWarTop implements IClientPacket
   {
      
      public var wt_attacker:PWarTopInfo;
      
      public var wt_target:PWarTopInfo;
      
      public function PWarTop()
      {
         super();
      }
      
      public static function create(param1:PWarTopInfo, param2:PWarTopInfo) : PWarTop
      {
         var _loc3_:PWarTop = new PWarTop();
         _loc3_.wt_attacker = param1;
         _loc3_.wt_target = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PWarTop
      {
         var _loc2_:PWarTop = new PWarTop();
         _loc2_.wt_attacker = PWarTopInfo.read(param1);
         _loc2_.wt_target = PWarTopInfo.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.wt_attacker.write(param1);
         this.wt_target.write(param1);
      }
   }
}

