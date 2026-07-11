package model.vo
{
   import proto.model.PShopStorage;
   
   public class VOStorageSpec
   {
      
      public var costVariance:uint;
      
      public var capacityMax:uint;
      
      public var capacityCur:uint;
      
      public var steal:uint;
      
      public var stealTime:int;
      
      public function VOStorageSpec()
      {
         super();
      }
      
      public function assignShop(param1:PShopStorage) : void
      {
         this.costVariance = param1.ss_capacity.variance;
         this.capacityMax = param1.ss_capacity.value;
      }
      
      public function get percentage() : Number
      {
         return this.capacityMax > 0 ? (this.capacityCur - this.steal) / this.capacityMax : 0;
      }
   }
}

