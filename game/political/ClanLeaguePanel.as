package game.political
{
   import flash.display.Shape;
   import game.clan.center.TopClansDialog;
   import logic.DialogLogic;
   import logic.MainLogic;
   import proto.BinaryBuffer;
   import proto.game.family_0060.Packet_0060_1D;
   import proto.game.family_0060.Packet_0060_1E;
   import proto.model.PClanDivision;
   import proto.model.clan.PClan;
   import proto.model.clan.PClanTop;
   import proto.model.clan.PTopRequest;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VLabel;
   import ui.vbase.VSkin;
   import utils.StringHelper;
   
   public class ClanLeaguePanel extends TopClansPanel
   {
      
      private const bg:VSkin = new VSkin(VSkin.TOP);
      
      private const descLabel:VLabel = new VLabel(null,VLabel.MIDDLE);
      
      private const leagueRequest:PTopRequest = PTopRequest.create("",1,7,false,false,0);
      
      private const thLevelPanel:TownHallLevelPanel = new TownHallLevelPanel();
      
      private var titlePanel:VComponent;
      
      public var league:PClanDivision;
      
      public var toMapBt:RectButton;
      
      public function ClanLeaguePanel(param1:int, param2:Boolean = true)
      {
         add(this.bg,{
            "left":-12,
            "right":-17,
            "top":-7
         });
         super(this.leagueRequest.count,param1 + 87,16,16);
         layoutH = 543;
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.beginFill(16711680);
         _loc3_.graphics.moveTo(-12,-7);
         _loc3_.graphics.lineTo(918,-7);
         _loc3_.graphics.lineTo(918,546);
         _loc3_.graphics.lineTo(904,560);
         _loc3_.graphics.lineTo(1,560);
         _loc3_.graphics.lineTo(-12,548);
         _loc3_.graphics.moveTo(-12,-7);
         _loc3_.graphics.endFill();
         addChild(_loc3_);
         this.bg.mask = _loc3_;
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "left":54,
            "right":14,
            "top":param1,
            "h":77
         });
         add(this.thLevelPanel,{
            "left":10,
            "top":param1 - 3
         });
         add(this.descLabel,{
            "left":108,
            "right":(param2 ? 206 : 23),
            "top":param1 + 38,
            "h":34
         });
         Style.applyDefaultFilter(this.descLabel,16,Style.brownGlowRGB);
         if(param2)
         {
            this.toMapBt = RectButton.createIconAndTitle(SkinManager.getEmbed("TerritoryIcon"),Lang.getString("to_regions_map"),18,RectButton.GREEN,173);
            add(this.toMapBt,{
               "top":param1 + 11,
               "right":23,
               "w":173
            });
         }
         addListener(VEvent.VARIANCE,this.onVariance);
      }
      
      public function assign(param1:PClanDivision, param2:int) : void
      {
         this.league = param1;
         this.leagueRequest.division = param1.cd_num;
         if(this.titlePanel)
         {
            remove(this.titlePanel);
         }
         add(UIFactory.createDecorText(Lang.getString(param1.cd_region),true,24,this.toMapBt ? 494 : 670),{
            "left":108,
            "top":this.thLevelPanel.top + 10
         });
         this.thLevelPanel.value = param2;
         SkinManager.applyExternal(this.bg,UIFactory.POLITICAL_PACK,"map_" + param1.cd_region);
         var _loc3_:uint = Facade.userProxy.getClanLeagueNum();
         var _loc4_:Boolean = param1.cd_num == _loc3_;
         this.descLabel.text = "<p" + Style.yellowColor + " fontSize=\"16\" lineHeight=\"110%\">" + (param1.cd_num < _loc3_ ? Lang.getString("old_clan_league") : Lang.getPatternString(_loc4_ ? "next_clan_league" : "cur_clan_league","__BUILD__",StringHelper.getUnitName("bl_town_hall",param2 + (_loc4_ ? 1 : 0),16,Style.yellowColor))) + "</p>";
      }
      
      public function request(param1:Number) : void
      {
         this.leagueRequest.from_place = param1;
         loadMode = true;
         Facade.protoProxy.request(new Packet_0060_1D(this.leagueRequest),this.resultRequest,96,30,[this.league]);
      }
      
      private function resultRequest(param1:BinaryBuffer, param2:PClanDivision) : void
      {
         var _loc3_:PClan = null;
         var _loc6_:PClanTop = null;
         if(!stage || param2 != this.league)
         {
            return;
         }
         var _loc4_:Array = new Packet_0060_1E(param1).value;
         var _loc5_:Boolean = param2.cd_num == Facade.userProxy.getClanLeagueNum();
         if(_loc5_)
         {
            _loc3_ = Facade.userProxy.clanData;
            for each(_loc6_ in _loc4_)
            {
               if(_loc6_.id == _loc3_.base.id)
               {
                  _loc5_ = false;
                  myPlace = _loc6_.place;
                  break;
               }
            }
         }
         else
         {
            _loc5_ = false;
         }
         if(isNaN(this.leagueRequest.from_place))
         {
            this.leagueRequest.from_place = _loc4_.length > 0 ? (_loc4_[0] as PClanTop).place : 0;
         }
         change(this.leagueRequest.from_place,_loc4_,_loc5_,_loc3_ ? _loc3_.base : null,_loc4_.length > 0 ? (_loc4_[0] as PClanTop).full_cnt : 0);
         if(_loc5_ && myPlace == 0)
         {
            this.specifyMyPlace();
         }
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = param1.variance;
         switch(_loc2_)
         {
            case TopClanRendererBase.SEARCH:
            case TopClanRendererBase.PAGER:
               this.request(param1.data == int.MAX_VALUE ? NaN : Number(param1.data));
               break;
            case TopClanRendererBase.INFO:
               DialogLogic.openClanAbout(param1.data);
               break;
            case TopClanRendererBase.CAPITAL:
               this.toCapital(param1);
         }
      }
      
      private function toCapital(param1:VEvent) : void
      {
         var _loc2_:PClan = Facade.userProxy.clanData;
         if(param1.data != null || !_loc2_ || !_loc2_.war || isNaN(_loc2_.war.war_storm))
         {
            MainLogic.getCapitalMap(param1.data);
         }
         else
         {
            MainLogic.getStorm(false);
         }
      }
      
      private function specifyMyPlace() : void
      {
         Facade.protoProxy.request(new Packet_0060_1D(PTopRequest.create("",NaN,this.leagueRequest.count,false,false,this.league.cd_num)),this.resultPlaceRequest,96,30,[this.league]);
      }
      
      private function resultPlaceRequest(param1:BinaryBuffer, param2:PClanDivision) : void
      {
         var _loc4_:PClanTop = null;
         if(!stage || param2 != this.league || !Facade.userProxy.clan)
         {
            return;
         }
         var _loc3_:String = Facade.userProxy.clan.uc_clan_id;
         for each(_loc4_ in new Packet_0060_1E(param1).value)
         {
            if(_loc4_.id == _loc3_)
            {
               myPlace = _loc4_.place;
               if(myRenderer)
               {
                  myRenderer.setPlace(myPlace,TopClansDialog.seasonLineCount);
               }
               return;
            }
         }
      }
   }
}

