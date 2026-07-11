package logic.sim.SimAstar
{
   import flash.geom.Point;
   
   public class SimAstar
   {
      
      private var estimateRemainingCost:Function;
      
      private var dheap:DHeap = new DHeap();
      
      private var used_states:Array;
      
      private var cPoint:Point = new Point(0,0);
      
      public function SimAstar()
      {
         super();
      }
      
      public static function packState(param1:uint, param2:uint, param3:uint) : uint
      {
         return param3 << 12 | param1 << 6 | param2;
      }
      
      private function pushNode(param1:SimAstarNode, param2:int, param3:int) : void
      {
         var _loc4_:int = (param2 >> 12) + param1.path_cost;
         this.cPoint.x = param2 >> 6 & 0x3F;
         this.cPoint.y = param2 & 0x3F;
         var _loc5_:int = this.estimateRemainingCost(this.cPoint);
         var _loc6_:int = _loc4_ + _loc5_;
         this.dheap.push(param2,_loc4_,_loc5_,_loc6_,param1);
      }
      
      private function gobbleUpStatesToRoot(param1:SimAstarNode) : Vector.<Point>
      {
         var _loc4_:int = 0;
         var _loc5_:Point = null;
         var _loc2_:Vector.<Point> = new Vector.<Point>();
         var _loc3_:SimAstarNode = param1;
         while(_loc3_.parent)
         {
            _loc4_ = _loc3_.state;
            _loc5_ = new Point(_loc4_ >> 6 & 0x3F,_loc4_ & 0x3F);
            _loc2_.push(_loc5_);
            _loc3_ = _loc3_.parent;
         }
         return _loc2_.reverse();
      }
      
      private function init(param1:Point) : void
      {
         this.dheap.clear();
         this.used_states = [];
         var _loc2_:int = this.estimateRemainingCost(param1);
         var _loc3_:int = int(packState(param1.x,param1.y,_loc2_));
         this.dheap.push(_loc3_,0,_loc2_,_loc2_,null);
         this.used_states[_loc3_ & 0x0FFF] = 1;
      }
      
      public function find(param1:Point, param2:Function, param3:Function, param4:int) : Vector.<Point>
      {
         var p:Point = null;
         var currently_expanded_node:SimAstarNode = null;
         var states:Vector.<int> = null;
         var pi:int = 0;
         var i:int = 0;
         var s:int = 0;
         var initial_state:Point = param1;
         var generateSuccessorStates:Function = param2;
         var estimateRemainingCost:Function = param3;
         var etime:int = param4;
         var res:Vector.<Point> = new Vector.<Point>();
         this.estimateRemainingCost = estimateRemainingCost;
         this.init(initial_state);
         try
         {
            p = new Point();
            while(true)
            {
               currently_expanded_node = this.dheap.pop();
               if(currently_expanded_node.remaining_cost == 0)
               {
                  break;
               }
               currently_expanded_node.fillPoint(p);
               states = generateSuccessorStates(p);
               i = 0;
               while(i < states.length)
               {
                  s = states[i];
                  pi = s & 0x0FFF;
                  if(this.used_states[pi] == undefined)
                  {
                     this.used_states[pi] = 1;
                     this.pushNode(currently_expanded_node,s,etime);
                  }
                  i++;
               }
            }
            res = this.gobbleUpStatesToRoot(currently_expanded_node);
         }
         catch(e:Error)
         {
            if(e.message != DHeap.EMPTY)
            {
               throw e;
            }
            res = null;
         }
         return res;
      }
   }
}

