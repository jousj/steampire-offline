package logic.sim
{
   import flash.geom.Point;
   import proto.model.PShopBuilding;
   
   public class SimBuildingT
   {
      
      public var id:int;
      
      public var stamina:int;
      
      public var pos:Point;
      
      public var size:Point;
      
      public var type:int;
      
      public var guard_radius:int;
      
      public var armor:int;
      
      public var is_finished:Boolean;
      
      public var max_stamina:int;
      
      public var shop:PShopBuilding;
      
      public var capacityMax:uint;
      
      public var capacityCur:uint;
      
      public function SimBuildingT()
      {
         super();
      }
      
      public function boardObj() : SimBoardObj
      {
         return new SimBoardObj(SimBoardObj.BUILDING,this.id);
      }
   }
}

