package engine.units
{
   import proto.model.PCost;
   import proto.model.PShopGarbage;
   
   public class Garbage extends Unit
   {
      
      public var shop:PShopGarbage;
      
      public var prize:PCost;
      
      public var cleaning:Boolean;
      
      public function Garbage(param1:PShopGarbage)
      {
         super();
         this.shop = param1;
         applyKind(param1.sg_kind);
      }
      
      override public function stand() : void
      {
         super.stand();
         setShadow("stand");
      }
   }
}

