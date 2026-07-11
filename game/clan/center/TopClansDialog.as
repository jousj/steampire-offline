package game.clan.center
{
   import game.political.ClanLeaguePanel;
   import game.political.TopClanRendererBase;
   import proto.model.PClanDivision;
   import proto.model.clan.PTopRequest;
   import ui.common.TabPanel;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   
   public class TopClansDialog extends VComponent
   {
      
      public static const searchLineCount:int = 7;
      
      public static const seasonLineCount:int = 8;
      
      public var searchPanel:AllTopClansPanel;
      
      public var tabPanel:TabPanel = new TabPanel();
      
      public var panelCnt:VComponent = new VComponent();
      
      public var seasonPanel:SeasonPanel;
      
      public var leaguePanel:ClanLeaguePanel;
      
      public var fameHallPanel:ClanHallFamePanel;
      
      public var cur_searon:int = 0;
      
      public function TopClansDialog(param1:int, param2:Number, param3:PTopRequest)
      {
         super();
         this.searchPanel = new AllTopClansPanel(param3,searchLineCount);
         this.cur_searon = param1;
         setSize(946,-100);
         this.searchPanel.dispatcher = this;
         this.fameHallPanel = new ClanHallFamePanel();
         this.fameHallPanel.dispatcher = this;
         this.seasonPanel = new SeasonPanel(param2,seasonLineCount);
         this.seasonPanel.dispatcher = this;
         this.leaguePanel = new ClanLeaguePanel(10,false);
         var _loc4_:PClanDivision = Facade.manualProxy.getClanLeagueByNum(Facade.userProxy.clanData ? uint(Facade.userProxy.clanData.base.division) : 0);
         this.leaguePanel.assign(_loc4_,Facade.userProxy.clanData ? int(Facade.userProxy.clanData.townhall_level) : 0);
         this.leaguePanel.request(0);
         var _loc5_:Vector.<String> = new <String>[Lang.getString("season") + " " + param1.toString()];
         if(param1 != 1)
         {
            _loc5_.push(Lang.getString("season") + " " + (param1 - 1).toString());
         }
         _loc5_.push(Lang.getString("hall_of_fame"));
         _loc5_.push(Lang.getString("rating_mobile"));
         _loc5_.push(Lang.getString("my_league"));
         this.tabPanel.init(_loc5_);
         add(this.tabPanel,{
            "left":10,
            "right":5,
            "top":0
         });
         add(this.panelCnt,{
            "top":0,
            "w":-100
         });
         this.panelCnt.add(this.searchPanel,{
            "w":900,
            "hCenter":0,
            "top":50
         });
         this.panelCnt.add(this.seasonPanel,{
            "w":900,
            "hCenter":0,
            "top":50
         });
         this.panelCnt.add(this.leaguePanel,{
            "w":900,
            "hCenter":0,
            "top":50
         });
         this.panelCnt.add(this.fameHallPanel,{
            "w":900,
            "hCenter":0,
            "top":50
         });
         this.tabPanel.addListener(VEvent.CHANGE,this.onTabChange);
         this.onTabChange();
      }
      
      public function setTab(param1:int = 0) : void
      {
         var _loc3_:uint = 0;
         this.tabPanel.index = param1;
         this.searchPanel.visible = false;
         this.seasonPanel.visible = false;
         this.leaguePanel.visible = false;
         this.fameHallPanel.visible = false;
         switch(param1)
         {
            case TopClanRendererBase.curSeasonIndex():
               _loc3_ = TopClanRendererBase.CUR_SEASON;
               this.seasonPanel.visible = true;
               this.seasonPanel.setCurSeason(true);
               break;
            case TopClanRendererBase.topsIndex():
               _loc3_ = TopClanRendererBase.TOP;
               this.searchPanel.visible = true;
               break;
            case TopClanRendererBase.leagueIndex():
               _loc3_ = TopClanRendererBase.LEAGUE;
               this.leaguePanel.visible = true;
               break;
            case TopClanRendererBase.hallOfFameIndex():
               _loc3_ = TopClanRendererBase.HALL_OF_FAME;
               this.fameHallPanel.visible = true;
               break;
            case TopClanRendererBase.lastSeasonIndex():
               _loc3_ = TopClanRendererBase.LAST_SEASON;
               this.seasonPanel.visible = true;
               this.seasonPanel.setCurSeason(false);
         }
         var _loc2_:VEvent = new VEvent(VEvent.VARIANCE,null);
         _loc2_.variance = _loc3_;
         dispatcher.dispatchEvent(_loc2_);
      }
      
      private function onTabChange(param1:VEvent = null) : void
      {
         var _loc2_:int = !param1 ? 0 : int(param1.data);
         this.setTab(_loc2_);
      }
   }
}

