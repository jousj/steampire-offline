package model.vo
{
   import proto.model.PGuard;
   import proto.model.PShopGuard;
   
   public class VOGuardSpec
   {
      
      public var configList:Array = [];
      
      public var capacity:uint;
      
      public var chargeMax:uint;
      
      public var chargeCur:uint;
      
      public var radius:uint;
      
      public function VOGuardSpec()
      {
         super();
      }
      
      public function assignData(param1:PGuard) : void
      {
         this.configList = param1.guard_config;
         this.chargeCur = param1.guard_count;
      }
      
      public function assignShop(param1:PShopGuard) : void
      {
         this.capacity = param1.sga_capacity;
         this.chargeMax = param1.sga_charge_count;
         this.radius = param1.sga_radius;
      }
   }
}

