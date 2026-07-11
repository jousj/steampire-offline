package ui.vbase
{
   public class VOGridFilterItem
   {
      
      public var isFilterHide:Boolean;
      
      public var isHide:Boolean;
      
      public function VOGridFilterItem()
      {
         super();
      }
      
      public function get isUse() : Boolean
      {
         return !(this.isFilterHide || this.isHide);
      }
   }
}

