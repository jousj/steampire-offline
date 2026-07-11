package engine.data
{
   public class LinkedIterator extends LinkedItem implements ILinkedIterator
   {
      
      public var item:LinkedItem;
      
      private var list:LinkedList;
      
      public function LinkedIterator(param1:LinkedList)
      {
         super();
         this.assign(param1);
      }
      
      public function assign(param1:LinkedList) : void
      {
         if(param1 != this.list)
         {
            if(this.list)
            {
               this.list.iteratorList.remove(this);
            }
            this.list = param1;
            if(!param1.iteratorList)
            {
               param1.iteratorList = new LinkedList();
            }
            param1.iteratorList.push(this);
         }
         this.toHead();
      }
      
      public function clear() : void
      {
         this.item = null;
         this.list = null;
      }
      
      public function dispose() : void
      {
         if(this.list)
         {
            this.list.iteratorList.remove(this);
         }
         this.clear();
      }
      
      public function toHead() : void
      {
         this.item = this.list.head;
      }
      
      public function getItem() : LinkedItem
      {
         return this.item;
      }
      
      public function next() : void
      {
         if(this.item)
         {
            this.item = this.item.link_next;
         }
      }
      
      public function getList() : LinkedList
      {
         return this.list;
      }
      
      public function clone() : LinkedIterator
      {
         return new LinkedIterator(this.list);
      }
   }
}

