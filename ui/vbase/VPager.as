package ui.vbase
{
   import flash.events.MouseEvent;
   import ui.UIFactory;
   
   public class VPager extends VBox
   {
      
      private var bg:VComponent;
      
      private var maxCount:uint;
      
      private var curIndex:uint;
      
      private var onSkinName:String;
      
      private var offSkinName:String;
      
      private var prevBt:VButton;
      
      private var nextBt:VButton;
      
      private var prevDoubleBt:VButton;
      
      private var text:VText;
      
      private var nextDoubleBt:VButton;
      
      public var showCountLimit:uint;
      
      public function VPager(param1:String, param2:String, param3:uint = 6, param4:VComponent = null)
      {
         super(null,param3);
         if(param4)
         {
            this.bg = param4;
            addChild(param4);
         }
         this.onSkinName = param1;
         this.offSkinName = param2;
      }
      
      public function setParam(param1:uint, param2:uint) : void
      {
         var _loc4_:VButton = null;
         var _loc5_:* = 0;
         var _loc6_:uint = 0;
         if(param2 == 0)
         {
            param2 = 1;
         }
         var _loc3_:uint = this.maxCount;
         this.maxCount = param2;
         if(param2 != _loc3_)
         {
            if(param2 > this.showCountLimit)
            {
               if(_loc3_ <= this.showCountLimit)
               {
                  removeAll();
                  this.prevDoubleBt = UIFactory.createNavButton(false,false,0,"NavDoubleBt");
                  this.prevDoubleBt.data = param2 > 100 ? -10 : -5;
                  this.prevDoubleBt.addClickListener(this.onNavClickHandler);
                  add(this.prevDoubleBt,{"w":28});
                  this.text = UIFactory.createYellowText(this.curIndex + 1 + "/" + param2);
                  add(this.text);
                  this.nextDoubleBt = UIFactory.createNavButton(true,false,0,"NavDoubleBt");
                  this.nextDoubleBt.data = -int(this.prevDoubleBt.data);
                  this.nextDoubleBt.addClickListener(this.onNavClickHandler);
                  add(this.nextDoubleBt,{"w":28});
                  this.prevDoubleBt.disabled = this.curIndex == 0;
                  this.nextDoubleBt.disabled = this.curIndex == param2 - 1;
               }
               this.curIndex = int.MAX_VALUE;
               this.index = param1;
            }
            else
            {
               if(_loc3_ > this.showCountLimit)
               {
                  removeAll();
                  this.prevDoubleBt = this.nextDoubleBt = null;
               }
               _loc3_ = list.length;
               if(list.length > 0)
               {
                  _loc4_ = list[this.curIndex] as VButton;
                  _loc4_.mouseEnabled = true;
                  _loc4_.data = null;
               }
               if(param2 > _loc3_)
               {
                  _loc5_ = int(param2 - _loc3_);
                  while(_loc5_ >= 1)
                  {
                     _loc4_ = VButton.createEmbed(this.offSkinName);
                     addChild(_loc4_);
                     list.push(_loc4_);
                     _loc4_.addClickListener(this.onClickHandler);
                     _loc5_--;
                  }
               }
               else
               {
                  _loc5_ = int(_loc3_ - param2);
                  while(_loc5_ >= 1)
                  {
                     _loc6_ = list.length - 1;
                     _loc4_ = list[_loc6_] as VButton;
                     removeChild(_loc4_);
                     list.splice(_loc6_,1);
                     _loc4_.dispose();
                     _loc5_--;
                  }
               }
               this.curIndex = param1 >= param2 ? uint(param2 - 1) : param1;
               this.fullUpdate();
               (list[this.curIndex] as VButton).data = null;
               syncContentSize(true);
            }
         }
         else
         {
            this.index = param1;
         }
      }
      
      public function set index(param1:uint) : void
      {
         var _loc2_:VButton = null;
         if(param1 == this.curIndex)
         {
            return;
         }
         if(this.maxCount > this.showCountLimit)
         {
            this.curIndex = param1;
            this.text.value = this.curIndex + 1 + "/" + this.maxCount;
            this.prevDoubleBt.disabled = this.curIndex == 0;
            this.nextDoubleBt.disabled = this.curIndex == this.maxCount - 1;
         }
         else
         {
            _loc2_ = list[this.curIndex] as VButton;
            _loc2_.mouseEnabled = true;
            this.curIndex = param1;
            SkinManager.applyEmbed(_loc2_.skin as VSkin,this.offSkinName);
            _loc2_ = list[this.curIndex] as VButton;
            _loc2_.mouseEnabled = false;
            SkinManager.applyEmbed(_loc2_.skin as VSkin,this.onSkinName);
         }
      }
      
      public function get index() : uint
      {
         return this.curIndex;
      }
      
      public function get max() : uint
      {
         return this.maxCount;
      }
      
      private function fullUpdate() : void
      {
         var _loc2_:VButton = null;
         var _loc3_:Boolean = false;
         var _loc1_:* = int(list.length - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = list[_loc1_] as VButton;
            if(_loc2_)
            {
               _loc3_ = this.curIndex == _loc1_;
               if(_loc3_)
               {
                  _loc2_.mouseEnabled = false;
               }
               if(_loc2_.data !== _loc1_)
               {
                  _loc2_.data = _loc1_;
                  SkinManager.applyEmbed(_loc2_.skin as VSkin,_loc3_ ? this.onSkinName : this.offSkinName);
               }
            }
            _loc1_--;
         }
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         this.index = (param1.currentTarget as VButton).data as uint;
         dispatcher.dispatchEvent(new VEvent(VEvent.SELECT,this.curIndex));
      }
      
      private function onNavClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = this.curIndex + (param1.currentTarget as VButton).data;
         this.index = _loc2_ < 0 ? 0 : (_loc2_ >= this.maxCount ? uint(this.maxCount - 1) : uint(_loc2_));
         dispatcher.dispatchEvent(new VEvent(VEvent.SELECT,this.curIndex));
      }
      
      override protected function customUpdate() : void
      {
         if(this.bg)
         {
            this.bg.geometryPhase();
         }
         super.customUpdate();
      }
   }
}

