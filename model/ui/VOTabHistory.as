package model.ui
{
   public class VOTabHistory
   {
      
      public var index:uint;
      
      public var open:uint;
      
      public var pages:Array;
      
      public function VOTabHistory(param1:uint, param2:Array)
      {
         super();
         this.index = param1;
         this.pages = param2;
      }
      
      public function get pageCount() : uint
      {
         return this.pages.length;
      }
   }
}

