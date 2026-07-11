package model.vo
{
   import proto.model.PResource;
   import proto.model.PShopResource;
   
   public class VOResourceSpec
   {
      
      public var lastTime:Number = 0;
      
      public var prodVariance:uint;
      
      public var prodValue:Number = 0;
      
      public var prodTime:Number = 1;
      
      public var capacityMax:uint;
      
      public var capacityCur:uint;
      
      public var steal:uint;
      
      public var stealTime:int;
      
      public function VOResourceSpec()
      {
         super();
      }
      
      public function assignData(param1:PResource) : void
      {
         this.lastTime = param1.last_apply_time;
         this.capacityCur = param1.done_count;
      }
      
      public function assignShop(param1:PShopResource) : void
      {
         this.prodVariance = param1.sr_cost.variance;
         this.prodValue = param1.sr_cost.value / param1.sr_time;
         this.prodTime = param1.sr_time;
         this.capacityMax = param1.sr_capacity;
      }
      
      public function get percentage() : Number
      {
         return (this.capacityCur - this.steal) / this.capacityMax;
      }
   }
}

