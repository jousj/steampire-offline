package engine.display
{
   import flash.geom.Rectangle;
   import utils.CommonUtils;
   
   public class Animation
   {
      
      public var name:String;
      
      public var lib:Library;
      
      public var iconX:int;
      
      public var iconY:int;
      
      public var frameNum:uint = 1;
      
      public var frames:Vector.<Vector.<FrameDescItem>>;
      
      public var frame:Vector.<FrameDescItem>;
      
      public var frameDelay:Number = 0.048;
      
      public var isCache:Boolean;
      
      public var isFlipCache:Boolean;
      
      public var viewRect:Rectangle = new Rectangle();
      
      public function Animation()
      {
         super();
      }
      
      public function get duration() : Number
      {
         return this.frameNum > 1 ? this.frameNum * this.frameDelay : 0;
      }
      
      public function getRandomIndex() : uint
      {
         return this.frameNum > 1 ? CommonUtils.getRangeRandom(0,this.frameNum - 1) : 0;
      }
   }
}

