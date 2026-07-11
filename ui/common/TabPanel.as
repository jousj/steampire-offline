package ui.common
{
   import flash.events.MouseEvent;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class TabPanel extends VComponent
   {
      
      public var activeBt:VButton;
      
      public var isBottom:Boolean;
      
      public var box:VBox;
      
      public function TabPanel(param1:uint = 5, param2:Boolean = true, param3:int = 6, param4:Boolean = false)
      {
         super();
         layoutH = 45;
         this.box = new VBox(null,param1,VBox.TOP);
         this.box.left = param3;
         if(param2)
         {
            add(SkinManager.getEmbed("DialogBorder",VSkin.STRETCH),{
               "wP":100,
               "bottom":0
            });
         }
         addChild(this.box);
         this.isBottom = param4;
      }
      
      public function getLen() : int
      {
         return this.box.list.length;
      }
      
      public function init(param1:Vector.<String>, param2:uint = 0) : void
      {
         var _loc4_:String = null;
         var _loc5_:VButton = null;
         this.box.removeAll();
         var _loc3_:uint = 0;
         for each(_loc4_ in param1)
         {
            _loc5_ = this.createTab(_loc4_);
            _loc5_.variance = _loc3_;
            _loc5_.addClickListener(this.onClick,_loc3_);
            if(_loc3_ == param2)
            {
               this.activeBt = _loc5_;
               this.applyActive(_loc5_,true);
            }
            else
            {
               this.applyActive(_loc5_,false);
            }
            _loc3_++;
            this.box.list.push(_loc5_);
         }
         this.box.addAll();
      }
      
      public function set index(param1:uint) : void
      {
         this.changeActive(this.getTab(param1));
      }
      
      public function get index() : uint
      {
         return this.activeBt ? this.activeBt.variance : uint.MAX_VALUE;
      }
      
      public function get dataIndex() : uint
      {
         return this.activeBt ? uint(this.activeBt.data) : uint.MAX_VALUE;
      }
      
      public function searchIndex(param1:uint) : uint
      {
         var _loc2_:VButton = null;
         for each(_loc2_ in this.box.list)
         {
            if(_loc2_.data === param1)
            {
               return _loc2_.variance;
            }
         }
         return uint.MAX_VALUE;
      }
      
      public function get max() : uint
      {
         return this.box.list.length;
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = this.index;
         this.changeActive(param1.currentTarget as VButton);
         dispatcher.dispatchEvent(new VEvent(VEvent.CHANGE,this.activeBt.variance,_loc2_));
      }
      
      protected function createTab(param1:String) : VButton
      {
         var _loc2_:VButton = VButton.create(new VSkin(VSkin.TOP | VSkin.STRETCH),null,UIFactory.createYellowText(param1,VText.CONTAIN_CENTER,16),{
            "top":13,
            "left":2,
            "right":2,
            "h":16
         });
         _loc2_.skin.layoutW = -100;
         _loc2_.layoutH = this.isBottom ? 36 : 45;
         if(this.isBottom)
         {
            _loc2_.skin.bottom = 0;
         }
         return _loc2_;
      }
      
      private function changeActive(param1:VButton) : void
      {
         if(param1 != this.activeBt)
         {
            if(this.activeBt)
            {
               this.applyActive(this.activeBt,false);
            }
            if(param1)
            {
               this.applyActive(param1,true);
            }
            this.activeBt = param1;
         }
      }
      
      protected function applyActive(param1:VButton, param2:Boolean) : void
      {
         SkinManager.applyEmbed(param1.skin as VSkin,param2 ? "TabBgActive" : "TabBg");
         param1.mouseEnabled = !param2;
      }
      
      public function getTab(param1:uint) : VButton
      {
         return param1 < this.box.list.length ? this.box.list[param1] as VButton : null;
      }
      
      public function addTab(param1:String, param2:Boolean = false, param3:int = -1) : VButton
      {
         var _loc4_:VButton = this.createTab(param1);
         _loc4_.addClickListener(this.onClick,param3 >= 0 ? uint(param3) : this.box.list.length);
         this.box.add(_loc4_,null,param3);
         this.syncTabIndex();
         if(param2)
         {
            this.changeActive(_loc4_);
         }
         else
         {
            this.applyActive(_loc4_,false);
         }
         return _loc4_;
      }
      
      public function removeTab(param1:uint, param2:Boolean) : void
      {
         if(param2)
         {
            param1 = this.searchIndex(param1);
         }
         if(param1 < this.max)
         {
            if(Boolean(this.activeBt) && param1 == this.activeBt.variance)
            {
               this.changeActive(null);
            }
            this.box.removeAt(param1);
            this.syncTabIndex();
         }
      }
      
      private function syncTabIndex() : void
      {
         var _loc1_:uint = this.box.list.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            (this.box.list[_loc2_] as VButton).variance = _loc2_;
            _loc2_++;
         }
      }
      
      public function setTitleTab(param1:Object, param2:String) : void
      {
         var _loc3_:VButton = param1 is VButton ? param1 as VButton : this.getTab(uint(param1));
         if(_loc3_)
         {
            (_loc3_.icon as VText).value = param2;
         }
      }
   }
}

