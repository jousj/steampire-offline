package clans
{
   import game.clan.center.ClanCenterMediator;
   import game.clan.center.ClanMembersMediator;
   import game.clan.center.TopClansDialog;
   import game.clan.center.TopClansMediator;
   import game.clan.war.WarListMediator;
   import game.clan.war.WarMediator;
   import game.my.MyPanel;
   import game.political.PoliticalMapMediator;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.CircleButton;
   import ui.common.TabPanel;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class ClanDialog extends BaseDialog
   {
      
      public static const INFO:uint = 0;
      
      public static const MAP:uint = 1;
      
      public static const TOPS:uint = 2;
      
      public static const WAR:uint = 3;
      
      public static const WAR_LIST:uint = 4;
      
      public static const titleNames:Vector.<String> = new <String>[Lang.getString("clan"),Lang.getString("btMap"),Lang.getString("clan_tops"),Lang.getString("to_war_center")];
      
      public var activePanel:VComponent;
      
      public var panelCnt:VComponent = new VComponent();
      
      public var tabPanel:TabPanel = new TabPanel(5,false,6,true);
      
      public var infoPanel:VComponent;
      
      public var mapPanel:VComponent;
      
      public var warPanel:VComponent;
      
      public var topsPanel:VComponent;
      
      public var warListPanel:VComponent;
      
      public var ratingPanel:ResourcePanel = new ResourcePanel("ClanEmblemIcon",ResourcePanel.BG | ResourcePanel.PROGRESS,UIFactory.INDICATOR_GREEN);
      
      public var infoBt:CircleButton = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.TEAL,CircleButton.size42);
      
      public function ClanDialog()
      {
         super();
         setSize(950,670);
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "right":0,
            "w":250,
            "top":-9,
            "h":100
         });
         add(SkinManager.getEmbed("QDialogBg",VSkin.STRETCH),{
            "top":31,
            "bottom":0,
            "left":0,
            "right":0
         });
         addCloseButton({
            "right":15,
            "top":-3
         });
         add(this.panelCnt,{
            "top":50,
            "left":10,
            "right":10,
            "bottom":15
         });
         add(this.tabPanel,{
            "top":0,
            "left":20,
            "right":2
         });
         this.tabPanel.init(titleNames);
         this.ratingPanel.setSize(130,39);
         add(this.ratingPanel,{
            "right":100,
            "top":-5
         });
         this.ratingPanel.hint = Lang.getString("ClanEmblemIcon");
         this.ratingPanel.cur = ClanMembersMediator.getCurRating(Facade.userProxy.base.clan_points);
         add(this.infoBt,{
            "right":58,
            "top":-7
         });
         this.setTab(0);
      }
      
      public function setTab(param1:int, param2:int = 0) : void
      {
         var _loc4_:ClanCenterMediator = null;
         var _loc5_:PoliticalMapMediator = null;
         var _loc6_:WarListMediator = null;
         var _loc7_:WarListMediator = null;
         var _loc8_:WarMediator = null;
         var _loc9_:TopClansMediator = null;
         var _loc3_:Boolean = param2 > 0;
         MyPanel.changeButtonCount(this.tabPanel.getTab(WAR),(Facade.userProxy.clanData ? Boolean(Facade.userProxy.clanData.war) : Boolean(false)) && param1 != WAR ? -1 : 0,{
            "top":-9,
            "right":-8
         });
         this.tabPanel.index = param1;
         if(this.activePanel)
         {
            this.activePanel.removeFromParent(false);
         }
         if(param1 != WAR_LIST)
         {
            if(this.warListPanel)
            {
               this.tabPanel.removeTab(WAR_LIST,true);
            }
         }
         switch(param1)
         {
            case INFO:
               if(!this.infoPanel)
               {
                  _loc4_ = new ClanCenterMediator(null,false);
                  _loc4_.onAdd();
                  this.infoPanel = _loc4_.dialog;
               }
               this.activePanel = this.infoPanel;
               break;
            case MAP:
               if(!this.mapPanel)
               {
                  this.mapPanel = new VComponent();
                  _loc5_ = new PoliticalMapMediator();
                  _loc5_.onAdd();
                  this.mapPanel = _loc5_.dialog;
               }
               this.activePanel = this.mapPanel;
               break;
            case WAR:
               if(this.warPanel)
               {
                  this.warPanel.dispose();
               }
               if(this.warListPanel)
               {
                  this.warListPanel.dispose();
               }
               if(_loc3_)
               {
                  _loc6_ = new WarListMediator(null);
                  _loc6_.onAdd();
                  this.activePanel = this.warListPanel = _loc6_.panel;
                  this.tabPanel.addTab(Lang.getString("cur_war_list"),true);
                  break;
               }
               if(!Facade.userProxy.clanData)
               {
                  _loc7_ = new WarListMediator(null);
                  _loc7_.onAdd();
                  this.activePanel = this.warPanel = _loc7_.panel;
                  break;
               }
               _loc8_ = new WarMediator();
               _loc8_.onAdd();
               this.activePanel = this.warPanel = _loc8_.dialog;
               break;
            case TOPS:
               if(!this.topsPanel)
               {
                  _loc9_ = new TopClansMediator(param2);
                  _loc9_.onAdd();
                  this.topsPanel = _loc9_.dialog;
               }
               else
               {
                  (this.topsPanel as TopClansDialog).setTab(param2);
               }
               this.activePanel = this.topsPanel;
         }
         this.panelCnt.add(this.activePanel,{
            "hCenter":0,
            "vCenter":0
         });
      }
      
      override public function dispose() : void
      {
         if(this.infoPanel)
         {
            this.infoPanel.dispose();
         }
         if(this.mapPanel)
         {
            this.mapPanel.dispose();
         }
         if(this.warPanel)
         {
            this.warPanel.dispose();
         }
         if(this.topsPanel)
         {
            this.topsPanel.dispose();
         }
         super.dispose();
      }
   }
}

