package logic.sim
{
   import flash.geom.Point;
   
   public class SimGroup
   {
      
      public var targets:Vector.<SimBoardObj> = new Vector.<SimBoardObj>();
      
      public var rhombs:Vector.<int> = new Vector.<int>();
      
      public var goal_pos:Point;
      
      public var attackers:Vector.<int> = new Vector.<int>();
      
      public var priority_type:int;
      
      public function SimGroup()
      {
         super();
      }
   }
}

