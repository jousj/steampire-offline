package game.clan.war
{
   import proto.model.PClanWarOpponent;
   import proto.model.PWarOpponent;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.DurationPanel;
   import ui.common.LevelPanel;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.game.CircleAvatarPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class WarEnemyRenderer extends VRenderer
   {
      
      private const bg:VSkin = SkinManager.getEmbed("SectionBg",VSkin.STRETCH);
      
      public function WarEnemyRenderer()
      {
         super();
         layoutH = 85;
         this.bg.assignLayout({
            "left":34,
            "right":0,
            "hP":100
         });
      }
      
      override public function setData(param1:Object) : void
      {
         remove(this.bg,false);
         removeAllChildren();
         add(this.bg);
         var _loc2_:PClanWarOpponent = param1 as PClanWarOpponent;
         if(_loc2_.variance == PClanWarOpponent.READY)
         {
            this.opponentMode(_loc2_.value);
         }
         else
         {
            this.searchMode(_loc2_.value,_loc2_.variance != PClanWarOpponent.WAIT_SEARCH);
         }
      }
      
      private function opponentMode(param1:PWarOpponent) : void
      {
         var _loc9_:VButton = null;
         var _loc2_:CircleAvatarPanel = new CircleAvatarPanel();
         add(_loc2_,{
            "w":85,
            "h":84
         });
         _loc2_.setUser(param1.wo_avatar,dataIndex);
         var _loc3_:LevelPanel = new LevelPanel(LevelPanel.size34);
         _loc3_.changeSNetwork(param1.wo_snetwork);
         _loc3_.value = param1.wo_level;
         add(_loc3_,{
            "left":-4,
            "bottom":-2
         });
         add(SkinManager.getEmbed("league" + Facade.manualProxy.getLeagueShop(param1.wo_level).division_num,VSkin.RIGHT | VSkin.BOTTOM),{
            "w":30,
            "h":30,
            "bottom":-3,
            "left":60
         });
         var _loc4_:VText = UIFactory.createYellowText(param1.wo_name);
         _loc4_.maxH = 40;
         var _loc5_:VText = new VText(Lang.getString("clan_role" + param1.wo_role.variance),VText.CONTAIN,Style.metalRGB,16);
         _loc5_.maxW = 164;
         var _loc6_:StatPanel = new StatPanel(SkinManager.getEmbed("RatingIcon"),null,0,5,28);
         _loc6_.value = param1.wo_ratio;
         _loc6_.maxW = 90;
         add(new VBox(new <VComponent>[_loc4_,new VBox(new <VComponent>[_loc5_,_loc6_],18)],2,VBox.VERTICAL | VBox.LEFT | VBox.STRETCH),{
            "left":100,
            "vCenter":2,
            "w":280
         });
         _loc4_ = new VText(Lang.getString("prize"),0,Style.darkKhakiRGB);
         _loc4_.maxW = 144;
         var _loc7_:PricePanel = new PricePanel(33,22,PricePanel.GLOW_FILTER,5);
         SkinManager.applyEmbed(_loc7_.skin,"MoralIcon");
         _loc7_.setValue(param1.wo_warpoints);
         add(new VBox(new <VComponent>[_loc4_,_loc7_],10,VBox.CENTER),{
            "right":10,
            "top":6,
            "w":240
         });
         var _loc8_:VButton = VButton.createEmbed(RectButton.GREEN,VSkin.STRETCH,SkinManager.getEmbed("SearchIcon"),{
            "hCenter":0,
            "vCenter":0,
            "w":25
         });
         _loc8_.setSize(46,30);
         _loc8_.hint = Lang.getString("to_friend");
         _loc8_.addVarianceListener(this,1,param1);
         _loc9_ = VButton.createEmbed(RectButton.YELLOW,VSkin.STRETCH,SkinManager.getEmbed("SkipIcon"),{
            "hCenter":0,
            "vCenter":0,
            "h":34
         });
         _loc9_.setSize(46,30);
         _loc9_.hint = Lang.getString("skip_clan_enemy");
         _loc9_.addVarianceListener(this,2,param1);
         var _loc10_:RectButton = RectButton.createIconAndTitle(SkinManager.getEmbed("BarrackIcon"),Lang.getString("battleGroup"),18,RectButton.ORANGE,130,4,RectButton.h30);
         _loc10_.addVarianceListener(this,3,param1);
         add(new VBox(new <VComponent>[_loc9_,_loc8_,_loc10_],8,VBox.CENTER),{
            "right":10,
            "bottom":9,
            "w":240
         });
      }
      
      private function searchMode(param1:Number, param2:Boolean) : void
      {
         var _loc5_:VText = null;
         var _loc3_:VSkin = SkinManager.getEmbed("RWait");
         add(_loc3_,{
            "w":85,
            "h":layoutH
         });
         if(param2)
         {
            _loc3_.filters = VSkin.GREY_FILTER;
            _loc5_ = new VText(Lang.getString("none_clan_enemy2"),0,Style.metalRGB,14);
            _loc5_.maxH = 48;
            add(new VBox(new <VComponent>[UIFactory.createYellowText(Lang.getString("none_clan_enemy1"),VText.CONTAIN),_loc5_],5,VBox.VERTICAL | VBox.LEFT | VBox.STRETCH),{
               "left":100,
               "vCenter":1,
               "w":366
            });
         }
         else
         {
            add(new VText(Lang.getString("wait_clan_enemy"),0,Style.metalRGB),{
               "left":100,
               "vCenter":0,
               "w":366,
               "maxH":62
            });
         }
         var _loc4_:DurationPanel = new DurationPanel(34);
         _loc4_.useBg(80);
         _loc4_.addListener(VEvent.CHANGE,this.onTimeEnd);
         _loc4_.setTrackTime(param1,true);
         add(_loc4_,{
            "right":42,
            "vCenter":0
         });
      }
      
      private function onTimeEnd(param1:VEvent) : void
      {
         dispatchVarianceEvent(5);
      }
   }
}

