package engine.data
{
   public class LinkedList
   {
      
      public var head:LinkedItem;
      
      public var tail:LinkedItem;
      
      public var iteratorList:LinkedList;
      
      public function LinkedList()
      {
         super();
      }
      
      public function add(param1:LinkedItem, param2:LinkedItem = null) : void
      {
         if(!this.head)
         {
            this.head = param1;
            this.tail = param1;
         }
         else if(!param2)
         {
            this.head.link_prev = param1;
            param1.link_next = this.head;
            this.head = param1;
         }
         else
         {
            param1.link_prev = param2;
            if(param2 == this.tail)
            {
               this.tail = param1;
            }
            else
            {
               param2.link_next.link_prev = param1;
               param1.link_next = param2.link_next;
            }
            param2.link_next = param1;
         }
      }
      
      public function remove(param1:LinkedItem) : void
      {
         var _loc2_:LinkedIterator = null;
         if(this.iteratorList)
         {
            _loc2_ = this.iteratorList.head as LinkedIterator;
            while(_loc2_)
            {
               if(_loc2_.item == param1)
               {
                  _loc2_.next();
               }
               _loc2_ = _loc2_.link_next as LinkedIterator;
            }
         }
         if(param1 == this.head)
         {
            this.head = this.head.link_next;
         }
         if(param1 == this.tail)
         {
            this.tail = this.tail.link_prev;
         }
         if(param1.link_prev)
         {
            param1.link_prev.link_next = param1.link_next;
         }
         if(param1.link_next)
         {
            param1.link_next.link_prev = param1.link_prev;
            param1.link_next = null;
         }
         param1.link_prev = null;
      }
      
      public function get length() : uint
      {
         var _loc1_:LinkedItem = this.head;
         var _loc2_:uint = 0;
         while(_loc1_)
         {
            _loc2_++;
            _loc1_ = _loc1_.link_next;
         }
         return _loc2_;
      }
      
      public function get isEmpty() : Boolean
      {
         return this.head == null;
      }
      
      public function clear() : void
      {
         var _loc1_:LinkedItem = null;
         var _loc2_:LinkedItem = null;
         if(this.iteratorList)
         {
            _loc1_ = this.iteratorList.head;
            while(_loc1_)
            {
               (_loc1_ as LinkedIterator).clear();
               _loc1_ = _loc1_.link_next;
            }
            this.iteratorList.clear();
            this.iteratorList = null;
         }
         _loc1_ = this.head;
         while(_loc1_)
         {
            _loc2_ = _loc1_.link_next;
            _loc1_.link_next = null;
            _loc1_.link_prev = null;
            _loc1_ = _loc2_;
         }
         this.head = null;
         this.tail = null;
      }
      
      public function getArray() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:LinkedItem = this.head;
         while(_loc2_)
         {
            _loc1_.push(_loc2_);
            _loc2_ = _loc2_.link_next;
         }
         return _loc1_;
      }
      
      public function getReverseArray() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:LinkedItem = this.tail;
         while(_loc2_)
         {
            _loc1_.push(_loc2_);
            _loc2_ = _loc2_.link_prev;
         }
         return _loc1_;
      }
      
      public function shift() : LinkedItem
      {
         var _loc1_:LinkedItem = null;
         if(this.head)
         {
            _loc1_ = this.head;
            this.remove(_loc1_);
         }
         return _loc1_;
      }
      
      public function pop() : LinkedItem
      {
         var _loc1_:LinkedItem = null;
         if(this.tail)
         {
            _loc1_ = this.tail;
            this.remove(_loc1_);
         }
         return _loc1_;
      }
      
      public function push(param1:LinkedItem) : void
      {
         if(this.tail)
         {
            this.tail.link_next = param1;
            param1.link_prev = this.tail;
            this.tail = param1;
         }
         else
         {
            this.head = param1;
            this.tail = param1;
         }
      }
   }
}

