package game.clan.social
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VLabel;
   import ui.vbase.VScrollBar;
   import ui.vbase.VSkin;
   
   public class MessageListPanel extends VComponent
   {
      
      private const sb:VScrollBar = UIFactory.createScrollBar(16);
      
      private const calcLabel:VLabel = new VLabel();
      
      private const gap:int = 4;
      
      private const msgLayoutTop:int = 8;
      
      private var dp:Array;
      
      private var dpH:Vector.<int>;
      
      private var mH:int;
      
      private var cacheLabelList:Vector.<VLabel>;
      
      private var cacheMsgIndexList:Vector.<int>;
      
      private var cacheFillList:Vector.<VFill>;
      
      private var labelCount:uint;
      
      private var fillCount:uint;
      
      private var newLabelCount:uint;
      
      private var newFillCount:uint;
      
      private var screenTop:int;
      
      private var screenBottom:int;
      
      private var msgTop:int;
      
      private var msgBottom:int;
      
      private var msgLabel:VLabel;
      
      private var msgFill:VFill;
      
      private var fillChildIndex:int;
      
      private var dayIndex:int = -1;
      
      private var screenH:int;
      
      public function MessageListPanel(param1:int, param2:int)
      {
         super();
         setSize(param1,param2);
         this.calcLabel.layoutW = param1 - 36;
         this.screenH = param2 - 15;
         addStretch(SkinManager.getEmbed("ChBox",VSkin.STRETCH));
         this.fillChildIndex = numChildren;
         add(this.sb,{
            "right":0,
            "top":-2,
            "bottom":-2,
            "w":22
         });
         this.sb.addListener(VEvent.SCROLL,this.onScroll);
      }
      
      private function init() : void
      {
         this.dp = [];
         this.dpH = new Vector.<int>();
         this.cacheLabelList = new Vector.<VLabel>();
         this.cacheMsgIndexList = new Vector.<int>();
         this.cacheFillList = new Vector.<VFill>();
         if(this.calcLabel.parent)
         {
            removeChild(this.calcLabel);
         }
      }
      
      public function useEmptyMessage(param1:String) : void
      {
         this.calcLabel.text = "<p textAlign=\"center\"" + Style.darkKhakiColor + ">" + param1 + "</p>";
         add(this.calcLabel,{
            "vCenter":2,
            "left":9
         });
      }
      
      public function checkNewDay(param1:Date) : Boolean
      {
         var _loc2_:int = param1.month * 100 + param1.date;
         if(_loc2_ != this.dayIndex)
         {
            this.dayIndex = _loc2_;
            return true;
         }
         return false;
      }
      
      public function addText(param1:String, param2:Boolean, param3:Boolean = false) : void
      {
         if(!this.dp)
         {
            this.init();
         }
         param1 = "<div fontFamily=\"Myriad Pro\" fontSize=\"14\" color=\"#4D4D4D\">" + param1 + "</div>";
         this.calcLabel.text = param1;
         this.dpH.push(this.calcLabel.measuredHeight);
         this.dp.push(param1);
         this.mH += this.dpH[this.dpH.length - 1] + this.gap;
         if(param2)
         {
            this.syncScroll(param3);
         }
      }
      
      public function get isScrollDown() : Boolean
      {
         return this.sb.value + this.sb.getPageSize() >= this.sb.getMax();
      }
      
      public function syncScroll(param1:Boolean = true) : void
      {
         if(param1 || this.isScrollDown)
         {
            this.sb.setEnv(this.screenH,this.mH,this.mH);
            if(isGeometryPhase)
            {
               this.onScroll();
            }
         }
         else
         {
            if(isGeometryPhase && this.sb.getMax() < this.screenH)
            {
               this.onScroll();
            }
            this.sb.setEnv(this.screenH,this.mH,this.sb.value);
         }
      }
      
      public function clear() : void
      {
         if(this.dp)
         {
            this.dpH.length = 0;
            this.dp.length = 0;
            this.mH = 0;
         }
      }
      
      private function onScroll(param1:VEvent = null) : void
      {
         var _loc3_:uint = 0;
         this.screenTop = this.sb.value;
         this.screenBottom = this.screenTop + this.screenH;
         this.msgTop = 0;
         this.newLabelCount = 0;
         this.newFillCount = 0;
         if(this.dpH)
         {
            _loc3_ = this.dpH.length;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            this.msgBottom = this.msgTop + this.dpH[_loc2_];
            if(this.msgTop >= this.screenTop && this.msgTop < this.screenBottom || this.msgBottom > this.screenTop && this.msgBottom <= this.screenBottom || this.msgTop < this.screenTop && this.msgBottom > this.screenBottom)
            {
               if(this.newLabelCount == this.cacheLabelList.length)
               {
                  this.msgLabel = new VLabel(null,VLabel.SELECTION);
                  this.msgLabel.left = 10;
                  this.msgLabel.layoutW = this.calcLabel.layoutW;
                  this.msgLabel.mask = addChild(new Shape());
                  (this.msgLabel.mask as Shape).graphics.beginFill(0);
                  (this.msgLabel.mask as Shape).graphics.drawRect(this.msgLabel.left,this.msgLayoutTop,this.msgLabel.layoutW,this.screenH);
                  this.msgLabel.addListener(VEvent.SELECT,Facade.myMediator.onLink);
                  this.cacheLabelList.push(this.msgLabel);
                  this.cacheMsgIndexList.push(-1);
               }
               else
               {
                  this.msgLabel = this.cacheLabelList[this.newLabelCount];
               }
               if(this.cacheMsgIndexList[this.newLabelCount] != _loc2_)
               {
                  this.msgLabel.text = this.dp[_loc2_];
                  this.cacheMsgIndexList[this.newLabelCount] = _loc2_;
               }
               addChild(this.msgLabel);
               this.msgLabel.top = this.msgLayoutTop + this.msgTop - this.screenTop;
               this.msgLabel.geometryPhase();
               ++this.newLabelCount;
               if((_loc2_ & 1) != 0)
               {
                  if(this.newFillCount == this.cacheFillList.length)
                  {
                     this.msgFill = new VFill(14077378);
                     this.msgFill.left = this.msgLabel.left - 5;
                     this.msgFill.layoutW = this.calcLabel.layoutW + 10;
                     this.cacheFillList.push(this.msgFill);
                  }
                  else
                  {
                     this.msgFill = this.cacheFillList[this.newFillCount];
                  }
                  addChildAt(this.msgFill,this.fillChildIndex);
                  this.msgFill.top = this.msgLabel.top - 2;
                  this.msgFill.layoutH = this.dpH[_loc2_] + 3;
                  if(this.msgFill.top < this.msgLayoutTop)
                  {
                     this.msgFill.layoutH -= this.msgLayoutTop - this.msgFill.top;
                     this.msgFill.top = this.msgLayoutTop;
                  }
                  else if(this.msgFill.top + this.msgFill.layoutH > this.msgLayoutTop + this.screenH)
                  {
                     this.msgFill.layoutH = this.msgLayoutTop + this.screenH - this.msgFill.top;
                  }
                  this.msgFill.geometryPhase();
                  ++this.newFillCount;
               }
            }
            this.msgTop = this.msgBottom + this.gap;
            _loc2_++;
         }
         _loc2_ = int(this.newLabelCount);
         while(_loc2_ < this.labelCount)
         {
            removeChild(this.cacheLabelList[_loc2_]);
            this.cacheMsgIndexList[_loc2_] = -1;
            _loc2_++;
         }
         this.labelCount = this.newLabelCount;
         _loc2_ = int(this.newFillCount);
         while(_loc2_ < this.fillCount)
         {
            removeChild(this.cacheFillList[_loc2_]);
            _loc2_++;
         }
         this.fillCount = this.newFillCount;
      }
      
      override protected function customUpdate() : void
      {
         super.customUpdate();
         this.onScroll();
      }
      
      public function changeLayoutH(param1:int) : void
      {
         var _loc2_:VLabel = null;
         var _loc3_:Graphics = null;
         if(param1 == layoutH)
         {
            return;
         }
         layoutH = param1 < 50 ? 50 : param1;
         this.screenH = layoutH - 15;
         this.sb.setEnv(this.screenH,this.mH,this.mH);
         for each(_loc2_ in this.cacheLabelList)
         {
            _loc3_ = (_loc2_.mask as Shape).graphics;
            _loc3_.clear();
            _loc3_.beginFill(0);
            _loc3_.drawRect(_loc2_.left,this.msgLayoutTop,_loc2_.layoutW,this.screenH);
         }
         syncLayout();
      }
   }
}

