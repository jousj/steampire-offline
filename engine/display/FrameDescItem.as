package engine.display
{
   public class FrameDescItem
   {
      
      public var pid:uint;
      
      public var x:int;
      
      public var y:int;
      
      public var isEffect:Boolean;
      
      public var isFlipX:Boolean;
      
      public var alpha:Number = 1;
      
      public var scale:Number = 1;
      
      public function FrameDescItem(param1:int, param2:int)
      {
         super();
         this.x = param1;
         this.y = param2;
      }
   }
}

