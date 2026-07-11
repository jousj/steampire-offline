package engine.data
{
   public interface ILinkedIterator
   {
      
      function dispose() : void;
      
      function toHead() : void;
      
      function getItem() : LinkedItem;
      
      function next() : void;
   }
}

