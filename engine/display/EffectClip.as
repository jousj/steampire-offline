package engine.display
{
   public class EffectClip extends AnimClip
   {
      
      public static var cacheHead:EffectClip;
      
      public var link:EffectClip;
      
      public function EffectClip()
      {
         super();
         isSimulate = true;
      }
      
      public static function create() : EffectClip
      {
         var _loc1_:EffectClip = null;
         if(cacheHead)
         {
            _loc1_ = cacheHead;
            cacheHead = _loc1_.link;
            _loc1_.link = null;
            return _loc1_;
         }
         return new EffectClip();
      }
      
      public static function clear() : void
      {
         var _loc1_:EffectClip = null;
         while(cacheHead)
         {
            _loc1_ = cacheHead;
            cacheHead = _loc1_.link;
            _loc1_.link = null;
         }
      }
      
      override protected function endFrame() : void
      {
         removeFromParent();
         clear();
         this.link = cacheHead;
         cacheHead = this;
      }
      
      public function end() : void
      {
         this.endFrame();
      }
   }
}

