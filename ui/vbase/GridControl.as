package ui.vbase
{
   import flash.events.MouseEvent;
   
   public class GridControl
   {
      
      public static const NAV_BT_VISIBLE:uint = 1;
      
      public static const NAV_BT_DISABLED:uint = 2;
      
      public static const NAV_SMART:uint = 3;
      
      public static const PAGER_VISIBLE:uint = 4;
      
      public static const PAGER_CALC_COUNT:uint = 8;
      
      public static const SMART:uint = NAV_BT_VISIBLE | NAV_BT_DISABLED | PAGER_VISIBLE;
      
      public static const NAV_VERTICAL:uint = 4096;
      
      public var grid:VGrid;
      
      public var scrollBar:VScrollBar;
      
      public var pager:VPager;
      
      public var prevBt:VButton;
      
      public var nextBt:VButton;
      
      public var navBtFactory:Function;
      
      public var pagerFactory:Function;
      
      protected var mode:uint;
      
      private var addNavBtFunc:Function;
      
      private var addPagerFunc:Function;
      
      public function GridControl(param1:VGrid, param2:uint = 0)
      {
         super();
         this.grid = param1;
         param1.control = this;
         this.mode = param2;
         param1.addListener(VEvent.CHANGE,this.onChangeIndex);
      }
      
      public static function assign(param1:VGrid, param2:uint, param3:Function, param4:Function, param5:Function = null, param6:Function = null) : void
      {
         var _loc7_:GridControl = new GridControl(param1,param2);
         _loc7_.navBtFactory = param3;
         var _loc8_:Boolean = param1.length > param1.maxRenderer;
         if(param4 != null)
         {
            _loc7_.addNavBtFunc = param4;
            if(_loc8_ || (param2 & GridControl.NAV_BT_VISIBLE) == 0)
            {
               _loc7_.createNavBt();
            }
         }
         _loc7_.pagerFactory = param5;
         if(param6 != null)
         {
            _loc7_.addPagerFunc = param6;
            if(_loc8_ || (param2 & GridControl.PAGER_VISIBLE) == 0)
            {
               _loc7_.createPager();
            }
         }
      }
      
      public function dispose() : void
      {
         this.assignNavButtons();
         this.assignPager(null);
         this.assignScrollBar(null);
         this.grid.removeListener(VEvent.CHANGE,this.onChangeIndex);
         this.grid.control = null;
      }
      
      protected function onChangeIndex(param1:VEvent) : void
      {
         if((this.mode & GridControl.NAV_BT_VISIBLE) != 0)
         {
            if(!this.nextBt && this.grid.length > this.grid.maxRenderer)
            {
               this.createNavBt();
            }
         }
         if((this.mode & GridControl.PAGER_VISIBLE) != 0)
         {
            if(!this.pager && this.grid.length > this.grid.maxRenderer)
            {
               this.createPager();
            }
         }
         if(this.pager)
         {
            this.syncPager();
         }
         if(Boolean(this.prevBt) || Boolean(this.nextBt))
         {
            this.syncNavButton();
         }
         if(this.scrollBar)
         {
            this.syncScrollBar();
         }
      }
      
      public function assignPager(param1:VPager) : void
      {
         if(this.pager)
         {
            this.pager.removeListener(VEvent.SELECT,this.onChangePage);
         }
         this.pager = param1;
         if(param1)
         {
            param1.addListener(VEvent.SELECT,this.onChangePage);
            this.syncPager();
         }
      }
      
      private function onChangePage(param1:VEvent) : void
      {
         this.grid.index = uint(param1.data) * this.grid.maxRenderer;
      }
      
      protected function syncPager() : void
      {
         var _loc1_:uint = this.grid.maxRenderer;
         var _loc2_:uint = Math.ceil(this.grid.length / _loc1_);
         this.pager.setParam(Math.ceil(this.grid.index / _loc1_),_loc2_);
         if((this.mode & PAGER_VISIBLE) != 0)
         {
            this.pager.visible = this.grid.length > 0;
         }
      }
      
      public function assignNavButtons(param1:VButton = null, param2:VButton = null) : void
      {
         if(this.prevBt)
         {
            this.prevBt.removeListener(MouseEvent.CLICK,this.onNavButton);
            this.prevBt.visible = true;
         }
         this.prevBt = param1;
         if(param1)
         {
            param1.addClickListener(this.onNavButton);
         }
         if(this.nextBt)
         {
            this.nextBt.removeListener(MouseEvent.CLICK,this.onNavButton);
            this.nextBt.visible = true;
         }
         this.nextBt = param2;
         if(param2)
         {
            param2.addClickListener(this.onNavButton);
         }
         if(Boolean(param1) || Boolean(param2))
         {
            this.syncNavButton();
         }
      }
      
      private function onNavButton(param1:MouseEvent) : void
      {
         var _loc2_:uint = this.grid.length;
         var _loc3_:uint = this.grid.index;
         var _loc4_:uint = this.grid.maxRenderer;
         if(param1.currentTarget == this.prevBt)
         {
            if(_loc4_ > _loc3_)
            {
               if(_loc3_ == 0)
               {
                  _loc3_ = uint(_loc2_ / _loc4_) * _loc4_;
               }
               else
               {
                  _loc3_ = 0;
               }
            }
            else
            {
               _loc3_ -= _loc4_;
            }
         }
         else if(_loc3_ + _loc4_ >= _loc2_)
         {
            _loc3_ = 0;
         }
         else
         {
            _loc3_ += _loc4_;
         }
         this.grid.index = _loc3_;
      }
      
      protected function syncNavButton() : void
      {
         var _loc1_:Boolean = (this.mode & NAV_BT_VISIBLE) != 0;
         var _loc2_:Boolean = (this.mode & NAV_BT_DISABLED) != 0;
         if(this.prevBt)
         {
            if(_loc1_)
            {
               this.prevBt.visible = this.grid.length > this.grid.maxRenderer;
            }
            if(_loc2_)
            {
               this.prevBt.disabled = this.grid.index == 0;
            }
         }
         if(this.nextBt)
         {
            if(_loc1_)
            {
               this.nextBt.visible = this.grid.length > this.grid.maxRenderer;
            }
            if(_loc2_)
            {
               this.nextBt.disabled = this.grid.index >= this.grid.length - this.grid.maxRenderer;
            }
         }
      }
      
      public function assignScrollBar(param1:VScrollBar) : void
      {
         if(this.scrollBar)
         {
            this.scrollBar.removeListener(VEvent.SCROLL,this.onScroll);
         }
         this.scrollBar = param1;
         if(param1)
         {
            param1.addListener(VEvent.SCROLL,this.onScroll);
            this.syncScrollBar();
         }
      }
      
      private function onScroll(param1:VEvent) : void
      {
         this.grid.index = uint(param1.data);
      }
      
      protected function syncScrollBar() : void
      {
         if(this.grid.length != this.scrollBar.getMax() || this.grid.maxRenderer != this.scrollBar.getPageSize())
         {
            this.scrollBar.setEnv(this.grid.maxRenderer,this.grid.length,this.grid.index);
         }
         else
         {
            this.scrollBar.value = this.grid.index;
         }
      }
      
      private function createNavBt() : void
      {
         if(this.navBtFactory == null)
         {
            return;
         }
         var _loc1_:Boolean = (this.mode & NAV_VERTICAL) != 0;
         var _loc2_:VButton = this.navBtFactory(false,_loc1_);
         var _loc3_:VButton = this.navBtFactory(true,_loc1_);
         if(this.addNavBtFunc != null)
         {
            this.addNavBtFunc(this.grid,_loc2_,_loc3_);
         }
         this.assignNavButtons(_loc2_,_loc3_);
      }
      
      private function createPager() : void
      {
         if(this.pagerFactory == null)
         {
            return;
         }
         var _loc1_:VPager = this.pagerFactory();
         if(this.addPagerFunc != null)
         {
            this.addPagerFunc(this.grid,_loc1_);
         }
         this.assignPager(_loc1_);
      }
   }
}

