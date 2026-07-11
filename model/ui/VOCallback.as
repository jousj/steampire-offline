package model.ui
{
   public class VOCallback
   {
      
      public var func:Function;
      
      public var args:Array;
      
      public function VOCallback(param1:Function, param2:Array = null)
      {
         super();
         this.func = param1;
         this.args = param2;
      }
      
      public static function create(param1:Function, param2:Array = null) : VOCallback
      {
         return param1 != null ? new VOCallback(param1,param2) : null;
      }
      
      public function apply() : void
      {
         this.func.apply(null,this.args);
      }
   }
}

