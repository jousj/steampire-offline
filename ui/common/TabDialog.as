package ui.common
{
   import ui.UIFactory;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   
   public class TabDialog extends BaseDialog
   {
      
      public var tabPanel:TabPanel;
      
      public var page:VComponent;
      
      public var pageLayout:Object;
      
      public function TabDialog(param1:String)
      {
         super();
         useDefaultBg(638,param1);
      }
      
      public function init(param1:Vector.<String>, param2:uint = 0) : void
      {
         if(this.tabPanel)
         {
            return;
         }
         add(new VFill(12235690),{
            "left":2,
            "right":2,
            "top":40,
            "h":70
         },1);
         this.tabPanel = new TabPanel();
         this.tabPanel.init(param1,param2);
         add(this.tabPanel,{
            "left":2,
            "right":2,
            "top":76
         });
      }
      
      public function setPage(param1:VComponent, param2:Object = null, param3:Boolean = true) : void
      {
         if(this.page)
         {
            remove(this.page);
         }
         this.page = param1;
         if(param3)
         {
            param1.dispatcher = this;
         }
         add(param1,param2 ? param2 : this.pageLayout);
      }
      
      public function clearPage() : void
      {
         if(this.page)
         {
            remove(this.page);
            this.page = null;
         }
      }
      
      public function setLoadPage() : void
      {
         this.clearPage();
         this.page = UIFactory.createLoadPanel(this,{
            "w":778,
            "hCenter":0,
            "top":134,
            "bottom":32
         });
      }
   }
}

