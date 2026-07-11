package ui.vbase
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class VScrollBar extends VComponent
   {
      
      public static const HORIZONTAL:uint = 1;
      
      public static const TRACK_DOWN:uint = 2;
      
      public static const WHEEL:uint = 4;
      
      private var pageSize:uint;
      
      private var minShift:uint = 1;
      
      private var max:uint;
      
      private var cur:uint;
      
      private var thumbStartPos:uint;
      
      private var thumbDeltaPos:uint;
      
      private var isThumbMove:Boolean;
      
      private var thumbStagePos:Number;
      
      private var thumbMovePos:uint;
      
      private var track:VComponent;
      
      private var thumb:VComponent;
      
      private var upBt:VButton;
      
      private var downBt:VButton;
      
      public function VScrollBar(param1:VComponent, param2:VComponent, param3:uint = 0)
      {
         super();
         this.mode = param3;
         if((param3 & TRACK_DOWN) != 0)
         {
            param1.addListener(MouseEvent.MOUSE_DOWN,this.onTrackDown);
         }
         else
         {
            param1.addListener(MouseEvent.CLICK,this.onTrackClick);
         }
         this.track = param1;
         this.thumb = param2;
         param2.addListener(MouseEvent.MOUSE_DOWN,this.onThumbDown);
         if((param3 & WHEEL) != 0)
         {
            addListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
         }
         addListener(Event.REMOVED_FROM_STAGE,this.onThumbOut);
      }
      
      public function assignButton(param1:VButton, param2:VButton, param3:uint = 1) : void
      {
         this.upBt = param1;
         param1.addClickListener(this.onTrackClick,param3 > 0 ? param3 : 1);
         this.downBt = param2;
         param2.addClickListener(this.onTrackClick);
      }
      
      public function setEnv(param1:uint, param2:uint, param3:uint = 0, param4:uint = 1) : void
      {
         if(param1 > param2)
         {
            param1 = param2;
         }
         if(param1 == param2)
         {
            param3 = 0;
         }
         this.pageSize = param1;
         this.max = param2;
         this.minShift = param4 > 0 ? param4 : 1;
         this.cur = param3 > param2 - param1 ? uint(param2 - param1) : param3;
         this.thumb.mouseEnabled = this.track.mouseEnabled = param2 > param1;
         if(isGeometryPhase)
         {
            updatePhase(true);
         }
      }
      
      public function changeButtonSize(param1:uint) : void
      {
         if(param1 > 0 && Boolean(this.upBt))
         {
            this.upBt.data = param1;
         }
      }
      
      public function get value() : Number
      {
         return this.cur;
      }
      
      public function set value(param1:Number) : void
      {
         this.changePosition(param1,false);
      }
      
      public function getMax() : uint
      {
         return this.max;
      }
      
      public function getPageSize() : uint
      {
         return this.pageSize;
      }
      
      private function onTrackClick(param1:MouseEvent) : void
      {
         if(this.max > this.pageSize)
         {
            if(param1.currentTarget == this.upBt)
            {
               this.changePosition(this.cur - uint(this.upBt.data));
            }
            else if(param1.currentTarget == this.downBt)
            {
               this.changePosition(this.cur + uint(this.upBt.data));
            }
            else
            {
               this.changePosition(this.cur + (this.cur < this.mouseCur ? 1 : -1) * this.pageSize);
            }
         }
      }
      
      private function get mouseCur() : Number
      {
         return (((mode & HORIZONTAL) == 0 ? mouseY : mouseX) - this.thumbStartPos) / this.thumbDeltaPos * (this.max - this.pageSize);
      }
      
      private function onTrackDown(param1:MouseEvent) : void
      {
         this.changePosition(this.mouseCur);
         this.onThumbDown(param1);
         if(this.isThumbMove)
         {
            this.onThumbMove(param1);
         }
      }
      
      private function onWheel(param1:MouseEvent) : void
      {
         if(this.max > this.pageSize)
         {
            this.changePosition(this.cur + uint(this.upBt.data) * (param1.delta < 0 ? 1 : -1));
         }
      }
      
      private function onThumbDown(param1:MouseEvent) : void
      {
         if(this.max > this.pageSize)
         {
            this.thumbStagePos = (mode & HORIZONTAL) != 0 ? param1.stageX : param1.stageY;
            this.thumbMovePos = this.cur;
            if(!this.isThumbMove)
            {
               this.isThumbMove = true;
               stage.mouseChildren = false;
               stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMove);
               stage.addEventListener(MouseEvent.MOUSE_UP,this.onThumbOut);
            }
         }
      }
      
      private function onThumbMove(param1:MouseEvent) : void
      {
         this.changePosition(Math.round((this.thumbMovePos + (((mode & HORIZONTAL) != 0 ? param1.stageX : param1.stageY) - this.thumbStagePos) * ((this.max - this.pageSize) / this.thumbDeltaPos)) / this.minShift) * this.minShift);
      }
      
      private function onThumbOut(param1:Event) : void
      {
         if(this.isThumbMove)
         {
            this.isThumbMove = false;
            stage.mouseChildren = true;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onThumbOut);
         }
      }
      
      private function changePosition(param1:int, param2:Boolean = true) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > this.max - this.pageSize)
         {
            param1 = this.max - this.pageSize;
         }
         if(this.cur != param1)
         {
            this.cur = param1;
            this.syncUI();
            if(param2)
            {
               dispatcher.dispatchEvent(new VEvent(VEvent.SCROLL,param1));
            }
         }
      }
      
      protected function get thumbPos() : Number
      {
         var _loc1_:Number = this.thumbStartPos;
         if(this.max > this.pageSize)
         {
            _loc1_ += Math.round(this.thumbDeltaPos * (this.cur / (this.max - this.pageSize)));
         }
         return _loc1_;
      }
      
      protected function syncUI() : void
      {
         if(isGeometryPhase)
         {
            if((mode & HORIZONTAL) != 0)
            {
               this.thumb.x = this.thumbPos;
            }
            else
            {
               this.thumb.y = this.thumbPos;
            }
         }
         if(this.upBt)
         {
            this.upBt.disabled = this.cur <= 0;
            this.downBt.disabled = this.cur >= this.max - this.pageSize;
         }
      }
      
      override protected function customUpdate() : void
      {
         var _loc2_:uint = 0;
         super.customUpdate();
         var _loc1_:Boolean = (mode & HORIZONTAL) == 0;
         this.thumbStartPos = _loc1_ ? uint(this.thumb.y) : uint(this.thumb.x);
         if(this.max > this.pageSize)
         {
            if(_loc1_)
            {
               _loc2_ = this.thumb.applyRangeH(Math.round(this.pageSize / this.max * this.thumb.h));
               this.thumbDeltaPos = this.thumb.h - _loc2_;
               if(_loc2_ != this.thumb.h)
               {
                  this.thumb.setGeometrySize(this.thumb.w,_loc2_,false);
               }
            }
            else
            {
               _loc2_ = this.thumb.applyRangeW(Math.round(this.pageSize / this.max * this.thumb.w));
               this.thumbDeltaPos = this.thumb.w - _loc2_;
               if(_loc2_ != this.thumb.w)
               {
                  this.thumb.setGeometrySize(_loc2_,this.thumb.h,false);
               }
            }
         }
         else
         {
            this.thumbDeltaPos = 0;
         }
         this.syncUI();
      }
      
      override public function dispose() : void
      {
         this.onThumbOut(null);
         super.dispose();
      }
   }
}

