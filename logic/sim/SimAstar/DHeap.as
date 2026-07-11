package logic.sim.SimAstar
{
   public class DHeap
   {
      
      public static const EMPTY:String = "empty";
      
      private var size:int = 0;
      
      private var array:Vector.<SimAstarNode> = new Vector.<SimAstarNode>();
      
      private var cache:Vector.<SimAstarNode> = new Vector.<SimAstarNode>();
      
      private var cache2:Vector.<SimAstarNode> = new Vector.<SimAstarNode>();
      
      public function DHeap()
      {
         super();
      }
      
      public function clear() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.cache2.length)
         {
            this.cache.push(this.cache2[_loc1_]);
            _loc1_++;
         }
         this.cache2.length = 0;
         this.size = 0;
      }
      
      private function lessThan(param1:SimAstarNode, param2:SimAstarNode) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1.total_cost < param2.total_cost)
         {
            return true;
         }
         if(param1.total_cost == param2.total_cost)
         {
            if(param1.path_cost > param2.path_cost)
            {
               return true;
            }
            if(param1.path_cost == param2.path_cost)
            {
               _loc3_ = param1.state;
               _loc4_ = _loc3_ >> 6 & 0x3F;
               _loc5_ = param2.state;
               _loc6_ = _loc5_ >> 6 & 0x3F;
               return _loc4_ < _loc6_ || _loc4_ == _loc6_ && (_loc3_ & 0x3F) < (_loc5_ & 0x3F);
            }
            return false;
         }
         return false;
      }
      
      public function push(param1:int, param2:int, param3:int, param4:int, param5:SimAstarNode) : void
      {
         var _loc6_:SimAstarNode = null;
         var _loc8_:int = 0;
         if(this.cache.length > 0)
         {
            _loc6_ = this.cache.shift();
            _loc6_.init(param1,param2,param3,param4,param5);
         }
         else
         {
            _loc6_ = new SimAstarNode(param1,param2,param3,param4,param5);
         }
         this.cache2.push(_loc6_);
         if(this.size + 1 > this.array.length)
         {
            this.array.push(null);
         }
         var _loc7_:int = this.size.valueOf();
         while(true)
         {
            _loc8_ = Math.floor((_loc7_ + 1) / 2) - 1;
            if(!(_loc7_ != 0 && this.lessThan(_loc6_,this.array[_loc8_])))
            {
               break;
            }
            this.array[_loc7_] = this.array[_loc8_];
            _loc7_ = _loc8_;
         }
         this.array[_loc7_] = _loc6_;
         this.size += 1;
      }
      
      public function pop() : SimAstarNode
      {
         var _loc1_:SimAstarNode = null;
         var _loc2_:SimAstarNode = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:SimAstarNode = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this.size == 0)
         {
            throw new Error(EMPTY);
         }
         --this.size;
         _loc1_ = this.array[0];
         if(this.size > 0)
         {
            _loc2_ = this.array[this.size];
            _loc3_ = 0;
            _loc4_ = 1;
            _loc5_ = 0;
            while(true)
            {
               _loc6_ = -1;
               _loc7_ = _loc2_;
               _loc8_ = _loc4_ + 2 * (_loc5_ - _loc3_);
               _loc9_ = _loc8_ + 1;
               if(_loc8_ < this.size && this.lessThan(this.array[_loc8_],_loc7_))
               {
                  _loc6_ = _loc8_;
                  _loc7_ = this.array[_loc8_];
               }
               if(_loc9_ < this.size && this.lessThan(this.array[_loc9_],_loc7_))
               {
                  _loc6_ = _loc9_;
                  _loc7_ = this.array[_loc9_];
               }
               if(_loc6_ == -1)
               {
                  break;
               }
               this.array[_loc5_] = this.array[_loc6_];
               _loc3_ = _loc4_;
               _loc4_ = 2 * (_loc4_ + 1) - 1;
               _loc5_ = _loc6_;
            }
            this.array[_loc5_] = _loc2_;
         }
         return _loc1_;
      }
   }
}

