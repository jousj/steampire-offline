package ui.common
{
   import flash.events.MouseEvent;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   
   public class BaseTabDialog extends BaseDialog
   {
      
      public const tabList:Vector.<VButton> = new Vector.<VButton>();
      
      private const tabBg:VSkin = SkinManager.getEmbed("QDialogBg",VSkin.STRETCH);
      
      private var activeTab:VButton;
      
      public function BaseTabDialog(param1:int = 22)
      {
         super();
         add(SkinManager.getEmbed("QTabBg",VSkin.STRETCH),{
            "top":50,
            "bottom":40
         });
         add(this.tabBg,{
            "left":13,
            "right":0,
            "top":param1,
            "bottom":0
         });
         addHeader();
      }
      
      public function addTab(param1:Object, param2:String, param3:uint = 0) : VButton
      {
         var _loc4_:VButton = null;
         var _loc5_:uint = 0;
         _loc4_ = VButton.create(new VSkin(),{"vCenter":0},param1 is String ? SkinManager.getEmbed(String(param1)) : param1 as VComponent,{
            "vCenter":0,
            "hCenter":2
         });
         _loc4_.setSize(32,106);
         _loc5_ = this.tabList.length;
         _loc4_.data = _loc5_;
         _loc4_.hint = param2;
         _loc4_.addClickListener(this.onTabClick);
         _loc4_.left = -16;
         _loc4_.top = 100 + _loc5_ * 106;
         this.tabList.push(_loc4_);
         this.setTabStatus(_loc4_,_loc5_ == param3);
         return _loc4_;
      }
      
      protected function setTabStatus(param1:VButton, param2:Boolean) : void
      {
         SkinManager.applyEmbed(param1.skin as VSkin,param2 ? "QActiveTab" : "QTab");
         param1.mouseEnabled = !param2;
         if(param1.parent)
         {
            removeChild(param1);
         }
         addChildAt(param1,getChildIndex(this.tabBg) + (param2 ? 1 : 0));
         if(param2)
         {
            this.activeTab = param1;
         }
      }
      
      private function onTabClick(param1:MouseEvent) : void
      {
         if(this.activeTab)
         {
            this.setTabStatus(this.activeTab,false);
         }
         var _loc2_:VButton = param1.currentTarget as VButton;
         this.setTabStatus(_loc2_,true);
         dispatchEvent(new VEvent(VEvent.CHANGE,_loc2_.data));
      }
      
      public function getTabIndex() : uint
      {
         return uint(this.activeTab.data);
      }
   }
}

