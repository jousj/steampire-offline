package model.vo
{
   import proto.model.PShopPylon;
   
   public class VOPylonSpec
   {
      
      public var radius:uint;
      
      public function VOPylonSpec()
      {
         super();
      }
      
      public function assignShop(param1:PShopPylon) : void
      {
         this.radius = param1.sp_radius;
      }
   }
}

