package ui.vbase
{
   public class VDock extends VComponent
   {
      
      public function VDock(param1:uint = 0)
      {
         super();
         this.mode = param1;
      }
      
      override protected function syncChildLayout(param1:VComponent) : void
      {
         syncContentSize(true);
      }
      
      override protected function customUpdate() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:VComponent = null;
         super.customUpdate();
         if(!validContentSize)
         {
            calcContentSize();
            validContentSize = true;
         }
         var _loc1_:Number = contentW;
         var _loc2_:Number = contentH;
         var _loc3_:Number = 1;
         if(w > 0 && h > 0 && _loc1_ > 0 && _loc2_ > 0)
         {
            if((mode & VSkin.CONTAIN) != 0 && _loc1_ <= w && _loc2_ <= h)
            {
               return;
            }
            if(w / h <= _loc1_ / _loc2_)
            {
               _loc3_ = w / _loc1_;
            }
            else
            {
               _loc3_ = h / _loc2_;
            }
            _loc1_ *= _loc3_;
            _loc2_ *= _loc3_;
            if((mode & VSkin.RIGHT) != 0)
            {
               _loc4_ = w - _loc1_;
            }
            else if((mode & VSkin.LEFT) == 0)
            {
               _loc4_ = (w - _loc1_) / 2;
            }
            if((mode & VSkin.BOTTOM) != 0)
            {
               _loc5_ = h - _loc2_;
            }
            else if((mode & VSkin.TOP) == 0)
            {
               _loc5_ = (h - _loc2_) / 2;
            }
         }
         var _loc6_:* = int(numChildren - 1);
         while(_loc6_ >= 0)
         {
            _loc7_ = getChildAt(_loc6_) as VComponent;
            if(_loc7_)
            {
               _loc7_.scaleX = _loc3_;
               _loc7_.scaleY = _loc3_;
               if(_loc7_.left != EMPTY || _loc7_.right != EMPTY || _loc7_.hCenter != EMPTY)
               {
                  _loc7_.x += _loc4_;
               }
               else
               {
                  _loc7_.x = _loc4_;
               }
               if(_loc7_.top != EMPTY || _loc7_.bottom != EMPTY || _loc7_.vCenter != EMPTY)
               {
                  _loc7_.y += _loc5_;
               }
               else
               {
                  _loc7_.y = _loc5_;
               }
            }
            _loc6_--;
         }
      }
   }
}

