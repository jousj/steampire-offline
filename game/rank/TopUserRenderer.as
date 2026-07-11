package game.rank
{
   import proto.model.PUserTop;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.LevelPanel;
   import ui.common.StatPanel;
   import ui.game.ClanPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class TopUserRenderer extends VRenderer
   {
      
      public const bt:CircleButton = new CircleButton(new VSkin(),CircleButton.GOLD,CircleButton.size42);
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size34);
      
      private const nameText:VText = new VText(null,VText.CONTAIN,Style.metalRGB);
      
      private const ratingStat:StatPanel = new StatPanel(SkinManager.getEmbed("RatingIcon"));
      
      private const achvStat:StatPanel = new StatPanel(SkinManager.getEmbed("AchvPointsIcon"),null,0,2,28);
      
      private const clanPanel:ClanPanel = new ClanPanel(0,0,18,14);
      
      private var numPanel:VComponent;
      
      private var myFill:VFill;
      
      public function TopUserRenderer(param1:Boolean = false)
      {
         super();
         layoutH = 63;
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
               "left":71,
               "w":364,
               "hP":100
            });
            add(new VFill(16777215,0.4),{
               "hCenter":253,
               "w":130,
               "hP":100
            });
            SkinManager.applyEmbed(this.bt.icon as VSkin,"AttackDirection1");
         }
         else
         {
            SkinManager.applyEmbed(this.bt.icon as VSkin,"InfoIcon");
         }
         this.bt.addVarianceListener(this,param1 ? 3 : 1);
         add(this.bt,{
            "vCenter":1,
            "right":8
         });
         add(this.levelPanel,{
            "vCenter":0,
            "left":80
         });
         add(this.nameText,{
            "left":126,
            "top":13,
            "w":298
         });
         var _loc2_:VText = this.clanPanel.text;
         _loc2_.setColor(5720884);
         _loc2_.alpha = 0.5;
         add(this.clanPanel,{
            "left":this.nameText.left,
            "bottom":10,
            "maxW":298
         });
         this.achvStat.hint = Lang.getString("achv_points");
         add(this.achvStat,{
            "vCenter":1,
            "hCenter":253,
            "w":110
         });
         this.ratingStat.hint = Lang.getString("rating");
         add(this.ratingStat,{
            "vCenter":1,
            "hCenter":123,
            "w":110
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PUserTop = param1 as PUserTop;
         if(this.bt.variance == 3)
         {
            if(Boolean(this.bt.data) && Boolean((this.bt.data as PUserTop).ut_place == _loc2_.ut_place) && (this.bt.data as PUserTop).ut_ratio == this.ratingStat.cacheValue)
            {
               return;
            }
         }
         if(this.numPanel)
         {
            remove(this.numPanel);
         }
         var _loc3_:int = _loc2_.ut_place;
         if(_loc3_ > 10)
         {
            this.numPanel = UIFactory.createYellowText(_loc3_.toString(),VText.CONTAIN,24);
            this.numPanel.maxW = 64;
         }
         else
         {
            this.numPanel = _loc3_ <= 3 ? UIFactory.createDecorText(_loc3_.toString(),true,42,64) : UIFactory.createGrayDecorText(_loc3_.toString(),38,64);
         }
         add(this.numPanel,{
            "hCenter":-342,
            "vCenter":2
         });
         this.nameText.value = _loc2_.ut_name;
         this.levelPanel.changeSNetwork(_loc2_.ut_snetwork);
         this.levelPanel.value = _loc2_.ut_level;
         if(_loc2_.ut_clan)
         {
            this.clanPanel.assign(" " + _loc2_.ut_clan.ci_name,_loc2_.ut_clan.ci_icon);
         }
         else
         {
            this.clanPanel.noClan();
         }
         this.ratingStat.value = _loc2_.ut_ratio;
         this.achvStat.value = _loc2_.ut_achv_points;
         this.bt.data = _loc2_;
         if(this.bt.variance == 1 && Preloader.uid == _loc2_.ut_id != Boolean(this.myFill))
         {
            if(this.myFill)
            {
               remove(this.myFill);
               this.myFill = null;
            }
            else
            {
               this.myFill = new VFill(16250930,0.4);
               addStretch(this.myFill,0);
            }
            this.bt.disabled = Boolean(this.myFill);
         }
      }
   }
}

