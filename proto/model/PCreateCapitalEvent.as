package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCreateCapitalEvent implements IClientPacket
   {
      
      public var cce_crystal:uint;
      
      public var cce_oil:uint;
      
      public var cce_th_level:uint;
      
      public function PCreateCapitalEvent()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint) : PCreateCapitalEvent
      {
         var _loc4_:PCreateCapitalEvent = new PCreateCapitalEvent();
         _loc4_.cce_crystal = param1;
         _loc4_.cce_oil = param2;
         _loc4_.cce_th_level = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PCreateCapitalEvent
      {
         var _loc2_:PCreateCapitalEvent = new PCreateCapitalEvent();
         _loc2_.cce_crystal = param1.readUnsignedInt();
         _loc2_.cce_oil = param1.readUnsignedInt();
         _loc2_.cce_th_level = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.cce_crystal);
         param1.writeInt(this.cce_oil);
         param1.writeInt(this.cce_th_level);
      }
   }
}

