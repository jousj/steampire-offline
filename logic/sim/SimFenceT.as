package logic.sim
{
   import flash.geom.Point;
   import proto.model.PShopFence;
   
   public class SimFenceT
   {
      
      public var id:int;
      
      public var stamina:int;
      
      public var pos:Point;
      
      public var size:Point;
      
      public var armor:int;
      
      public var max_stamina:int;
      
      public var shop:PShopFence;
      
      public function SimFenceT()
      {
         super();
      }
      
      public function boardObj() : SimBoardObj
      {
         return new SimBoardObj(SimBoardObj.FENCE,this.id);
      }
   }
}

