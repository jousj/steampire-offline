package logic.sim
{
   public dynamic class Hashtbl
   {
      
      public static const Not_found:String = "exc_hashtbl_not_found";
      
      private var _length:int = 0;
      
      public function Hashtbl()
      {
         super();
      }
      
      public function isEmpty() : Boolean
      {
         return this._length == 0;
      }
      
      public function mem(param1:*) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.hasOwnProperty(param1) && this[param1] != null)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function add(param1:*, param2:*) : void
      {
         if(!this.mem(param1))
         {
            this._length += 1;
         }
         this[param1] = param2;
      }
      
      public function remove(param1:*) : void
      {
         if(this.mem(param1))
         {
            --this._length;
         }
         delete this[param1];
      }
      
      public function find(param1:*) : *
      {
         if(!this.mem(param1))
         {
            throw new Error(Not_found);
         }
         return this[param1];
      }
      
      public function get length() : int
      {
         return this._length;
      }
      
      public function iter(param1:Function) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this)
         {
            param1(_loc2_,this[_loc2_]);
         }
      }
   }
}

