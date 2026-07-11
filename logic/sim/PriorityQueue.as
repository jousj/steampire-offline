package logic.sim
{
   public class PriorityQueue
   {
      
      private var _heap:Array;
      
      private var _map:Object;
      
      private var _idInc:Number;
      
      private var _idIncFst:Number;
      
      public function PriorityQueue()
      {
         super();
         this._heap = [];
         this._map = {};
         this._idInc = 100000;
         this._idIncFst = 0;
      }
      
      public function add(param1:Number, param2:Object, param3:Boolean = false) : Number
      {
         var _loc4_:Number = this._heap.length;
         var _loc5_:int = param3 ? int(this._idIncFst++) : int(this._idInc++);
         var _loc6_:Object = {
            "priority":param1,
            "data":param2,
            "id":_loc5_,
            "pos":_loc4_
         };
         this._map[_loc5_] = _loc6_;
         this._heap[_loc4_] = _loc6_;
         this._filterUp(_loc4_);
         return _loc5_;
      }
      
      public function getTop() : Object
      {
         return this._heap[0].data;
      }
      
      public function removeTop() : Object
      {
         if(this._heap.length == 0)
         {
            return false;
         }
         var _loc1_:Object = this._heap[0].data;
         delete this._map[this._heap[0].id];
         this._heap[0] = this._heap[this._heap.length - 1];
         this._heap[0].pos = 0;
         this._heap.splice(this._heap.length - 1,1);
         this._filterDown(0);
         return _loc1_;
      }
      
      public function setPriority(param1:Number, param2:Number) : void
      {
         var _loc3_:Object = this._map[param1];
         var _loc4_:int = int(_loc3_.pos);
         var _loc5_:int = int(_loc3_.priority);
         _loc3_.priority = param2;
         if(_loc5_ > _loc3_.priority)
         {
            this._filterUp(_loc4_);
         }
         else
         {
            this._filterDown(_loc4_);
         }
      }
      
      public function getPriority(param1:Number) : Number
      {
         return this._map[param1].priority;
      }
      
      public function isEmpty() : Boolean
      {
         return this._heap.length == 0;
      }
      
      public function length() : int
      {
         return this._heap.length;
      }
      
      public function getTopPriority() : Number
      {
         return this._heap[0].priority;
      }
      
      public function isQueued(param1:Number) : Boolean
      {
         return this._map[param1] != null;
      }
      
      public function remove(param1:Number) : Boolean
      {
         if(!this.isQueued(param1))
         {
            return false;
         }
         var _loc2_:int = int(this._map[param1].pos);
         delete this._map[param1];
         delete this._heap[_loc2_];
         this._heap[_loc2_] = this._heap[this._heap.length - 1];
         this._heap[0].pos = 0;
         this._heap.splice(this._heap.length - 1,1);
         return true;
      }
      
      private function moreThen(param1:Object, param2:Object) : Boolean
      {
         if(param1.priority == param2.priority)
         {
            return param1.id > param2.id;
         }
         return param1.priority > param2.priority;
      }
      
      private function _filterUp(param1:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc2_:int = param1;
         while(_loc2_ > 0 && this.moreThen(this._heap[int((_loc2_ - 1) / 2)],this._heap[_loc2_]))
         {
            _loc3_ = Math.floor((_loc2_ - 1) / 2);
            _loc4_ = this._heap[_loc2_];
            this._heap[_loc2_] = this._heap[_loc3_];
            this._heap[_loc3_] = _loc4_;
            this._heap[_loc2_].pos = _loc2_;
            this._heap[_loc3_].pos = _loc3_;
            _loc2_ = _loc3_;
         }
      }
      
      private function _filterDown(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc2_:int = int(param1);
         if(_loc2_ < (this._heap.length - 1) / 2)
         {
            _loc3_ = 2 * _loc2_ + 1;
            _loc4_ = 2 * _loc2_ + 2;
            if(_loc4_ >= this._heap.length)
            {
               _loc5_ = _loc3_;
               _loc4_ = _loc3_;
            }
            else if(this._heap[_loc3_].priority < this._heap[_loc4_].priority)
            {
               _loc5_ = _loc3_;
            }
            else if(this._heap[_loc3_].priority == this._heap[_loc4_].priority)
            {
               if(this._heap[_loc3_].id < this._heap[_loc4_].id)
               {
                  _loc5_ = _loc3_;
               }
               else
               {
                  _loc5_ = _loc4_;
               }
            }
            else
            {
               _loc5_ = _loc4_;
            }
            if(this._heap[_loc2_].priority > this._heap[_loc5_].priority)
            {
               _loc6_ = this._heap[_loc2_];
               this._heap[_loc2_] = this._heap[_loc5_];
               this._heap[_loc5_] = _loc6_;
               this._heap[_loc2_].pos = _loc2_;
               this._heap[_loc5_].pos = _loc5_;
               this._filterDown(_loc5_);
            }
            else if(this._heap[_loc2_].priority == this._heap[_loc5_].priority)
            {
               if(this._heap[_loc2_].id > this._heap[_loc5_].id)
               {
                  _loc6_ = this._heap[_loc2_];
                  this._heap[_loc2_] = this._heap[_loc5_];
                  this._heap[_loc5_] = _loc6_;
                  this._heap[_loc2_].pos = _loc2_;
                  this._heap[_loc5_].pos = _loc5_;
                  this._filterDown(_loc5_);
               }
            }
         }
      }
   }
}

