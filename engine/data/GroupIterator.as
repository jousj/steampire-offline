package engine.data
{
   public class GroupIterator implements ILinkedIterator
   {
      
      public var item:LinkedItem;
      
      private var index:uint;
      
      private var groupList:Vector.<LinkedList>;
      
      private var iterator:LinkedIterator;
      
      public function GroupIterator(param1:Vector.<LinkedList>)
      {
         super();
         if(param1.length == 0)
         {
            throw new Error("GroupIterator: empty list");
         }
         this.groupList = param1;
         this.toHead();
      }
      
      public function toHead() : void
      {
         var _loc2_:LinkedList = null;
         var _loc1_:uint = this.groupList.length;
         this.index = 0;
         while(this.index < _loc1_)
         {
            _loc2_ = this.groupList[this.index];
            if(_loc2_.head)
            {
               if(this.iterator)
               {
                  this.iterator.assign(_loc2_);
                  break;
               }
               this.iterator = new LinkedIterator(_loc2_);
               break;
            }
            ++this.index;
         }
         this.item = this.iterator ? this.iterator.item : null;
      }
      
      public function dispose() : void
      {
         if(this.iterator)
         {
            this.iterator.dispose();
         }
         this.item = null;
         this.groupList = null;
      }
      
      public function next() : void
      {
         if(this.item)
         {
            this.iterator.next();
            this.item = this.iterator.item;
            if(!this.item)
            {
               ++this.index;
               while(this.index < this.groupList.length)
               {
                  if(this.groupList[this.index].head)
                  {
                     this.iterator.assign(this.groupList[this.index]);
                     this.item = this.iterator.item;
                     return;
                  }
                  ++this.index;
               }
               this.iterator.dispose();
            }
         }
      }
      
      public function getItem() : LinkedItem
      {
         return this.item;
      }
   }
}

