package game.clan.center
{
   import logic.CoreLogic;
   import model.vo.VOClanMember;
   import proto.model.PRole;
   import proto.model.clan.PMember;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class ClanMemberRenderer extends VRenderer
   {
      
      public const menuBt:RectButton = new RectButton(SkinManager.getEmbed("MenuIcon"));
      
      public var member:PMember;
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size28);
      
      private const nameText:VText = UIFactory.createYellowText(null,VText.CONTAIN);
      
      private const statusText:VText = new VText(null,VText.CONTAIN,Style.metalRGB,14);
      
      private const ratingStat:StatPanel = new StatPanel(SkinManager.getEmbed("RatingIcon"));
      
      private const chestStat:StatPanel = new StatPanel(new VSkin());
      
      private const scoreStat:StatPanel = new StatPanel(SkinManager.getEmbed("ClanEmblemIcon"));
      
      private var numPanel:VComponent;
      
      private var myFill:VFill;
      
      private var radarSkin:VSkin;
      
      public function ClanMemberRenderer()
      {
         super();
         layoutH = 48;
         add(this.levelPanel,{
            "vCenter":0,
            "left":50
         });
         add(this.nameText,{
            "left":90,
            "w":220,
            "top":8
         });
         add(this.statusText,{
            "left":90,
            "w":220,
            "bottom":5
         });
         add(this.chestStat,{
            "vCenter":1,
            "left":340,
            "w":110
         });
         this.ratingStat.hint = Lang.getString("rating");
         add(this.ratingStat,{
            "vCenter":1,
            "left":456
         });
         this.scoreStat.hint = Lang.getString("ClanEmblemIcon");
         add(this.scoreStat,{
            "vCenter":1,
            "left":573
         });
         add(this.menuBt,{
            "vCenter":0,
            "right":16,
            "w":40,
            "h":34
         });
         this.menuBt.addVarianceListener(this,0,this);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:VOClanMember = null;
         var _loc4_:int = 0;
         _loc2_ = param1 as VOClanMember;
         this.member = _loc2_.user;
         if(this.numPanel)
         {
            remove(this.numPanel);
         }
         this.numPanel = UIFactory.createGrayDecorText(String(dataIndex + 1),26,34);
         add(this.numPanel,{
            "hCenter":-356,
            "vCenter":2
         });
         this.levelPanel.changeSNetwork(_loc2_.user.user_base.snetwork);
         this.levelPanel.value = _loc2_.user.user_base.level;
         this.nameText.value = _loc2_.user.user_base.name;
         var _loc3_:uint = _loc2_.user.role.variance;
         this.statusText.setColor(_loc3_ == PRole.CREATOR || _loc3_ == PRole.SUB_CREATOR ? Style.redRGB : Style.metalRGB);
         this.statusText.value = Lang.getString("clan_role" + _loc3_);
         this.ratingStat.value = _loc2_.user.user_base.ratio;
         _loc4_ = ClanMembersMediator.getCurRating(_loc2_.user.user_base.clan_points);
         this.scoreStat.value = _loc4_;
         SkinManager.applyEmbed(this.chestStat.icon,CostHelper.getKind(_loc2_.prize[0].variance));
         this.chestStat.cacheValue = -1;
         this.chestStat.value = _loc2_.prize[0].value;
         this.chestStat.text.value += " + ...";
         this.chestStat.hint = "<p textAlign=\"center\" ><span " + Style.metalColor + ">" + Lang.getString("clan_member_prize_info") + "</span><br/>" + CostHelper.getListString(_loc2_.prize,20,14,5,2) + "</p>";
         this.chestStat.filters = _loc4_ == 0 ? VSkin.GREY_FILTER : null;
         if(_loc4_ == 0)
         {
            this.chestStat.hint = Lang.getString("clan_point_prize_null");
         }
         var _loc5_:Boolean = _loc2_.user.user_base.user_id != Preloader.uid;
         this.menuBt.visible = _loc5_;
         if(_loc5_ != !this.myFill)
         {
            if(_loc5_)
            {
               remove(this.myFill);
               this.myFill = null;
            }
            else
            {
               this.myFill = new VFill(16250930,0.4);
               addStretch(this.myFill,0);
            }
         }
         _loc5_ = _loc2_.user.user_base.scouting > CoreLogic.serverTime;
         if((_loc5_) && !this.radarSkin)
         {
            this.radarSkin = SkinManager.getEmbed("RadarIconAnim",VSkin.PLAY_MOVIE_CLIP);
            add(this.radarSkin,{
               "left":88,
               "top":3,
               "w":23,
               "h":23
            });
         }
         if(this.radarSkin)
         {
            this.radarSkin.visible = _loc5_;
            if(_loc5_ != (this.nameText.left == 115))
            {
               this.nameText.left = _loc5_ ? 115 : 90;
               this.nameText.layoutW = 310 - this.nameText.left;
               this.nameText.syncLayout();
            }
         }
      }
   }
}

