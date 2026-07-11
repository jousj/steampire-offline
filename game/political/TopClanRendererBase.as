package game.political
{
   import game.clan.center.TopClansMediator;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class TopClanRendererBase extends VRenderer
   {
      
      public static const SEARCH:uint = 1;
      
      public static const INFO:uint = 2;
      
      public static const CAPITAL:uint = 3;
      
      public static const TOP:uint = 4;
      
      public static const LAST_SEASON:uint = 5;
      
      public static const CUR_SEASON:uint = 6;
      
      public static const PAGER:uint = 7;
      
      public static const LEAGUE:uint = 8;
      
      public static const HALL_OF_FAME:uint = 9;
      
      protected const emblemSkin:VSkin = new VSkin();
      
      protected const titleText:VText = new VText(null,VText.MIDDLE,Style.metalRGB,18);
      
      protected const memberStat:StatPanel = new StatPanel(SkinManager.getEmbed("HumanIcon"),null,0,0,30,18);
      
      protected var infoBt:VButton;
      
      protected var numPanel:VComponent;
      
      protected var isMy:Boolean = false;
      
      public function TopClanRendererBase(param1:Boolean = false)
      {
         super();
         layoutH = 60;
         this.isMy = param1;
         if(param1)
         {
            add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
               "left":-20,
               "right":-18,
               "top":-9,
               "bottom":-12
            });
            add(new VFill(16247890,0.5),{
               "left":-9,
               "right":-8,
               "hP":100
            });
            add(new VFill(16777215,0.15),{
               "left":51,
               "w":58,
               "hP":100
            });
            add(new VFill(16777215,0.15),{
               "right":320,
               "w":72,
               "hP":100
            });
            this.infoBt = new RectButton(Lang.getString("to_friend"),RectButton.h30,RectButton.ORANGE);
            this.infoBt.addVarianceListener(this,PAGER,int.MAX_VALUE);
            this.infoBt.right = 5;
            this.infoBt.maxW = 106;
         }
         else
         {
            this.infoBt = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.TEAL,CircleButton.size42);
            this.infoBt.addVarianceListener(this,INFO);
            this.infoBt.right = 12;
         }
         this.infoBt.vCenter = 0;
         addChild(this.infoBt);
         add(this.emblemSkin,{
            "vCenter":0,
            "left":54,
            "w":52,
            "h":54
         });
         add(this.titleText,{
            "left":120,
            "w":350,
            "hP":100
         });
         this.memberStat.hint = Lang.getString("clan_member_count");
         add(this.memberStat,{
            "vCenter":0,
            "w":60,
            "right":320
         });
      }
      
      public static function curSeasonIndex() : int
      {
         return 0;
      }
      
      public static function lastSeasonIndex() : int
      {
         return 1;
      }
      
      public static function hallOfFameIndex() : int
      {
         return TopClansMediator.getCurSeason() == 1 ? 1 : 2;
      }
      
      public static function topsIndex() : int
      {
         return TopClansMediator.getCurSeason() == 1 ? 2 : 3;
      }
      
      public static function leagueIndex() : int
      {
         return TopClansMediator.getCurSeason() == 1 ? 3 : 4;
      }
      
      protected function update(param1:String, param2:String, param3:uint, param4:String) : void
      {
         this.titleText.value = param1;
         SkinManager.applyExternal(this.emblemSkin,UIFactory.EMBLEM_PACK,param2);
         this.memberStat.value = param3;
         this.infoBt.data = param4;
      }
      
      public function setPlace(param1:uint, param2:int) : void
      {
         if(this.numPanel)
         {
            remove(this.numPanel);
         }
         this.numPanel = new VComponent();
         if(param1 > 10)
         {
            this.numPanel.add(UIFactory.createYellowText(param1.toString(),VText.CONTAIN,22),{
               "hCenter":0,
               "maxW":50,
               "vCenter":0
            });
         }
         else
         {
            this.numPanel.add(param1 <= 3 ? UIFactory.createDecorText(param1 < 1 ? "-" : param1.toString(),true,42,36) : UIFactory.createGrayDecorText(param1.toString(),38,36),{
               "hCenter":0,
               "maxW":50,
               "vCenter":0
            });
         }
         add(this.numPanel,{
            "vCenter":2,
            "w":50
         });
         this.infoBt.visible = !(this.isMy && param1 < 1);
         if(this.isMy)
         {
            this.infoBt.data = (int((param1 + param2 - 2) / (param2 - 1)) - 1) * (param2 - 1);
         }
      }
   }
}

