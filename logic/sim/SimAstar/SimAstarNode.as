package logic.sim.SimAstar
{
   import flash.geom.Point;
   
   public class SimAstarNode
   {
      
      public var state:int;
      
      public var path_cost:int;
      
      public var remaining_cost:int;
      
      public var total_cost:int;
      
      public var parent:SimAstarNode;
      
      public function SimAstarNode(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:SimAstarNode = null)
      {
         super();
         this.state = param1;
         this.path_cost = param2;
         this.remaining_cost = param3;
         this.total_cost = param4;
         this.parent = param5;
      }
      
      public function init(param1:int, param2:int, param3:int, param4:int, param5:SimAstarNode) : void
      {
         this.state = param1;
         this.path_cost = param2;
         this.remaining_cost = param3;
         this.total_cost = param4;
         this.parent = param5;
      }
      
      public function fillPoint(param1:Point) : void
      {
         param1.x = this.state >> 6 & 0x3F;
         param1.y = this.state & 0x3F;
      }
      
      public function toString() : String
      {
         return "{state=[" + (this.state >> 6 & 0x3F) + "," + (this.state & 0x3F) + "]; path_cost=" + this.path_cost + "; remaining_cost=" + this.remaining_cost + "; total_cost=" + this.total_cost + "}";
      }
   }
}

