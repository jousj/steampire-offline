package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PRole;
   import proto.model.PUm;
   import proto.model.PUnitsLevel;
   
   public class PCapital implements IClientPacket
   {
      
      public var cap_um:PUm;
      
      public var cap_edit_lock:PCapitalEditLock;
      
      public var cap_base:PBase;
      
      public var cap_role:PRole;
      
      public var cap_units_levels:Array;
      
      public function PCapital()
      {
         super();
      }
      
      public static function create(param1:PUm, param2:PCapitalEditLock, param3:PBase, param4:PRole, param5:Array) : PCapital
      {
         var _loc6_:PCapital = new PCapital();
         _loc6_.cap_um = param1;
         _loc6_.cap_edit_lock = param2;
         _loc6_.cap_base = param3;
         _loc6_.cap_role = param4;
         _loc6_.cap_units_levels = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PCapital
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PCapital = new PCapital();
         _loc2_.cap_um = PUm.read(param1);
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.cap_edit_lock = PCapitalEditLock.read(param1);
         }
         else
         {
            _loc2_.cap_edit_lock = null;
         }
         _loc2_.cap_base = PBase.read(param1);
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.cap_role = PRole.read(param1);
         }
         else
         {
            _loc2_.cap_role = null;
         }
         _loc2_.cap_units_levels = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.cap_units_levels.length)
         {
            _loc2_.cap_units_levels[_loc3_] = _loc4_ = PUnitsLevel.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         this.cap_um.write(param1);
         if(this.cap_edit_lock != null)
         {
            param1.writeByte(1);
            this.cap_edit_lock.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         this.cap_base.write(param1);
         if(this.cap_role != null)
         {
            param1.writeByte(1);
            this.cap_role.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.cap_units_levels == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.cap_units_levels.length);
            _loc2_ = 0;
            while(_loc2_ < this.cap_units_levels.length)
            {
               this.cap_units_levels[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

