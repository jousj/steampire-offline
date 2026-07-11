package logic.sim
{
   import flash.geom.Point;
   
   public class SimDecorT
   {
      
      public var id:int;
      
      public var pos:Point;
      
      public var size:Point;
      
      public function SimDecorT(param1:int, param2:Point, param3:Point)
      {
         super();
         this.id = param1;
         this.pos = param2;
         this.size = param3;
      }
      
      public function boardObj() : SimBoardObj
      {
         return new SimBoardObj(SimBoardObj.DECOR,this.id);
      }
   }
}

