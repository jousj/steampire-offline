package engine.display
{
   import flash.display.BitmapData;
   
   public class RBitmapData extends BitmapData
   {
      
      public var loaded:Boolean;
      
      public function RBitmapData(param1:int, param2:int, param3:Boolean = true, param4:uint = 0)
      {
         super(param1,param2,param3,param4);
      }
   }
}

