package ui.vbase
{
   import flash.events.Event;
   
   public class VEvent extends Event
   {
      
      public static const SCROLL:String = "vScroll";
      
      public static const SELECT:String = "vSelect";
      
      public static const CLOSE_DIALOG:String = "vCloseDialog";
      
      public static const CHANGE:String = "vChange";
      
      public static const VARIANCE:String = "vVariance";
      
      public static const EXTERNAL_COMPLETE:String = "vExternalComplete";
      
      public var variance:uint;
      
      public var data:*;
      
      public function VEvent(param1:String, param2:* = null, param3:uint = 0)
      {
         super(param1);
         this.data = param2;
         this.variance = param3;
      }
   }
}

