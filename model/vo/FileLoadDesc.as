package model.vo
{
   public class FileLoadDesc
   {
      
      public var url:String;
      
      public var isJson:Boolean;
      
      public var callFunc:Function;
      
      public var callArgs:Array;
      
      public function FileLoadDesc(param1:String, param2:Function, param3:Boolean = false, param4:Array = null)
      {
         super();
         this.url = param1;
         this.callFunc = param2;
         this.isJson = param3;
         this.callArgs = param4;
      }
   }
}

