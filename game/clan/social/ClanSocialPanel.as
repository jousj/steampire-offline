package game.clan.social
{
   import ui.common.CountPanel;
   import ui.common.TabPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class ClanSocialPanel extends VComponent
   {
      
      public const tabPanel:TabPanel = new TabPanel(5,false);
      
      public const closeBt:VButton = VButton.createEmbed("CloseBt");
      
      public var tabPage:VComponent;
      
      private var notifyIndex:int = -1;
      
      private var countPanel:CountPanel;
      
      public function ClanSocialPanel(param1:Boolean = true)
      {
         super();
         setSize(586,260);
         add(SkinManager.getEmbed("ChatBg",VSkin.STRETCH),{
            "wP":100,
            "top":25,
            "bottom":0
         });
         add(this.tabPanel,{
            "left":20,
            "top":-4
         });
         var _loc2_:Vector.<String> = new <String>[Lang.getString("requests_tab")];
         if(param1)
         {
            _loc2_.unshift(Lang.getString("chat_tab"));
         }
         this.tabPanel.init(_loc2_);
         add(SkinManager.getEmbed("TabBgActive",VSkin.STRETCH),{
            "right":18,
            "top":-4,
            "w":57
         });
         add(this.closeBt,{
            "right":25,
            "top":-1
         });
      }
      
      public function setTabPage(param1:VComponent, param2:Object) : void
      {
         if(this.tabPage)
         {
            this.tabPage.removeFromParent();
         }
         this.tabPage = param1;
         add(param1,param2);
      }
      
      public function setTabNotify(param1:int) : void
      {
         var _loc2_:VButton = null;
         if(this.notifyIndex != param1)
         {
            this.resetNotify();
            _loc2_ = this.tabPanel.getTab(param1);
            if(_loc2_)
            {
               this.notifyIndex = param1;
               this.countPanel = new CountPanel(0,false);
               _loc2_.add(this.countPanel,{
                  "right":-10,
                  "top":-11
               });
               this.countPanel.title = "!";
            }
         }
      }
      
      public function resetNotify() : void
      {
         if(this.countPanel)
         {
            this.countPanel.removeFromParent();
            this.countPanel = null;
            this.notifyIndex = -1;
         }
      }
   }
}

