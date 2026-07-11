package engine.display
{
   import flash.utils.ByteArray;
   
   public class Library
   {
      
      public static const EMPTY:uint = 0;
      
      public static const LOAD:uint = 1;
      
      public static const FULL:uint = 2;
      
      public static const BAD:uint = 3;
      
      public var name:String;
      
      public var index:uint;
      
      public var pngs:ByteArray;
      
      public var pngIndexs:Vector.<PngPosition> = new Vector.<PngPosition>();
      
      public var frames:Vector.<Vector.<FrameDescItem>> = new Vector.<Vector.<FrameDescItem>>();
      
      public var loadMode:uint = 0;
      
      public var fileSize:uint;
      
      public var isSecondLoad:Boolean;
      
      public var url:String;
      
      public function Library()
      {
         super();
      }
      
      public function clear() : void
      {
         this.pngs = null;
         this.pngIndexs.length = 0;
         this.frames.length = 0;
      }
   }
}

