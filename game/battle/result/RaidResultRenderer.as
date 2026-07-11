package game.battle.result
{
   import logic.CoreLogic;
   import model.vo.VORaidMember;
   import proto.model.PUserBase;
   import ui.Style;
   import ui.common.LevelPanel;
   import ui.common.StatPanel;
   import ui.game.CircleAvatarPanel;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class RaidResultRenderer extends VRenderer
   {
      
      private const avatar:CircleAvatarPanel = new CircleAvatarPanel();
      
      private const nameText:VText = new VText(null,VText.CONTAIN,Style.metalRGB,16);
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size28);
      
      private const capacityStat:StatPanel = new StatPanel(SkinManager.getEmbed("ArmyCapacityIcon"),null,StatPanel.YELLOW_TEXT,3,38,18);
      
      private const bg:VSkin = new VSkin(VSkin.STRETCH);
      
      public var isMy:Boolean;
      
      private var item:VORaidMember;
      
      private var component:VComponent;
      
      private var radarSkin:VSkin;
      
      public function RaidResultRenderer()
      {
         super();
         layoutH = 66;
         add(this.bg,{
            "right":0,
            "left":22,
            "hP":100
         });
         add(this.avatar,{
            "w":56,
            "h":56,
            "vCenter":0
         });
         add(this.levelPanel,{
            "left":36,
            "bottom":-4
         });
         add(this.nameText,{
            "left":67,
            "top":11,
            "right":94
         });
         add(this.capacityStat,{
            "right":10,
            "vCenter":0
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc3_:Boolean = false;
         if(this.item == param1)
         {
            return;
         }
         this.item = param1 as VORaidMember;
         if(!this.bg.isContent || this.isMy != (this.item.num == 1))
         {
            this.isMy = this.item.num == 1;
            SkinManager.applyEmbed(this.bg,"RaidItemBg" + (this.isMy ? "2" : "1"));
         }
         var _loc2_:PUserBase = this.item.ub;
         this.nameText.value = _loc2_.name;
         this.avatar.setUser(_loc2_,this.item.num);
         this.capacityStat.value = this.item.dropCapacity;
         this.levelPanel.changeSNetwork(_loc2_.snetwork);
         this.levelPanel.value = _loc2_.level;
         if(this.component)
         {
            remove(this.component);
            this.component = null;
         }
         if(this.item.losing)
         {
            this.createSurrenderBox();
         }
         else if(Boolean(this.item.heroList) && this.item.heroList.length > 0)
         {
            this.createPrizePanel();
         }
         else
         {
            this.component = new VText(Lang.getString("raid_min_landing"),0,Style.darkKhakiRGB);
            add(this.component,{
               "left":72,
               "bottom":10,
               "right":94
            });
         }
         _loc3_ = _loc2_.scouting > CoreLogic.serverTime;
         if(_loc3_ && !this.radarSkin)
         {
            this.radarSkin = SkinManager.getEmbed("RadarIconAnim",VSkin.PLAY_MOVIE_CLIP);
            add(this.radarSkin,{
               "left":38,
               "w":23,
               "h":23
            });
         }
         if(this.radarSkin)
         {
            this.radarSkin.visible = _loc3_;
            this.setAdditionalMode(_loc3_,false);
         }
      }
      
      public function removeCapacityStat() : void
      {
         remove(this.capacityStat);
      }
      
      public function setAdditionalMode(param1:Boolean, param2:Boolean) : void
      {
         if(param2 && this.item.ub.account_id != Facade.userProxy.base.account_id)
         {
            return;
         }
         if(this.component is PriceListPanel)
         {
            (this.component as PriceListPanel).setAdditionalMode(param1,false);
         }
      }
      
      private function createSurrenderBox() : void
      {
         var _loc1_:VBox = new VBox();
         var _loc2_:VSkin = SkinManager.getEmbed("SurrenderIcon");
         _loc2_.layoutW = 36;
         _loc1_.add(_loc2_);
         _loc1_.add(new VText(Lang.getString("surrender_status"),0,Style.darkKhakiRGB).assignW(-100));
         add(_loc1_,{
            "left":72,
            "bottom":4,
            "right":94
         });
         this.component = _loc1_;
      }
      
      private function createPrizePanel() : void
      {
         var _loc1_:PriceListPanel = new PriceListPanel(9,VSkin.LEFT);
         _loc1_.priceMode |= PricePanel.TWEEN;
         add(_loc1_,{
            "left":72,
            "bottom":8,
            "right":94
         });
         _loc1_.assignList(this.item.heroList);
         this.component = _loc1_;
      }
   }
}

