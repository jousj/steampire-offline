package game.missions
{
   import engine.signal.Tween;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import proto.model.PCost;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class JainaCellarPanel extends VComponent
   {
      
      private const titleText:VText = UIFactory.createYellowText(null,VText.CONTAIN,22);
      
      private const descText:VText = new VText(null,VText.CENTER,Style.darkKhakiRGB,15);
      
      private const scrollBt:CircleButton = new CircleButton(SkinManager.getEmbed("BrArrow"),CircleButton.GOLD);
      
      private const paperPanel:VComponent = new VComponent();
      
      private const blackoutSkin:VSkin = SkinManager.getPack("MMapDg","BlackoutPaper",0,SkinManager.LOAD_CLIP);
      
      private const tween:Tween;
      
      private const difficultyPanel:VComponent = new VComponent();
      
      private const difficultyText:VText = UIFactory.createYellowText(null,VText.CONTAIN,16);
      
      private const difficultySkin:VSkin = new VSkin();
      
      private const damageStat:StatPanel = new StatPanel(SkinManager.getEmbed("DamageIcon"),null,StatPanel.YELLOW_TEXT,0,55).useBg();
      
      private var iconComponent:VComponent;
      
      private var cacheLevel:uint;
      
      private var learnArrow:VSkin;
      
      private var difficultyValue:uint;
      
      private var rewardStat:StatPanel;
      
      public var capacityCur:uint;
      
      public var capacityMax:uint;
      
      public var battleBt:RectButton;
      
      public function JainaCellarPanel(param1:PCost, param2:uint)
      {
         this.tween = new Tween(this.paperPanel,this.onTween);
         super();
         setSize(840,162);
         addChild(SkinManager.getEmbed("DialogBottomPanel"));
         add(this.titleText,{
            "top":22,
            "left":74,
            "right":260
         });
         add(new VText(Lang.getString("ms_progress"),VText.CONTAIN_CENTER,Style.anthraciteRGB,18),{
            "left":50,
            "top":66,
            "w":160
         });
         add(this.damageStat,{
            "left":60,
            "top":85,
            "w":122
         });
         add(new VText(Lang.getString("prize"),VText.CONTAIN_CENTER,Style.anthraciteRGB,18),{
            "left":225,
            "top":66,
            "w":180
         });
         var _loc3_:String = CostHelper.getKind(param2);
         this.rewardStat = new StatPanel(SkinManager.getEmbed(_loc3_),null,StatPanel.YELLOW_TEXT,0,40).useBg();
         add(this.rewardStat,{
            "left":242,
            "top":92,
            "w":122
         });
         this.rewardStat.hint = "<p" + Style.metalColor + ">" + Lang.getString(_loc3_) + "</p>" + Lang.getString(_loc3_ + "_desc");
         this.difficultyPanel.mouseChildren = false;
         this.difficultyPanel.addStretch(SkinManager.getEmbed("TrackSPb",VSkin.STRETCH_BG));
         this.difficultyText.format.baselineShift = 1;
         this.difficultyText.maxW = 128;
         this.difficultyPanel.add(new VBox(new <VComponent>[this.difficultySkin,this.difficultyText],6),{
            "left":4,
            "right":4,
            "top":1
         });
         add(this.difficultyPanel,{
            "hCenter":77,
            "top":62,
            "h":18
         });
         var _loc4_:PricePanel = new PricePanel(25,18,PricePanel.GLOW_FILTER);
         _loc4_.assignCost(param1);
         var _loc5_:VText = UIFactory.createYellowText(Lang.getString("to_mission"),VText.CONTAIN_CENTER);
         _loc5_.minW = 80;
         _loc5_.maxW = 114;
         this.battleBt = new RectButton(new VBox(new <VComponent>[_loc5_,_loc4_],8),RectButton.h56,RectButton.ORANGE);
         add(this.battleBt,{
            "hCenter":77,
            "top":88
         });
         add(this.paperPanel,{
            "w":280,
            "bottom":10,
            "right":-10,
            "minH":130
         });
         var _loc6_:VSkin = SkinManager.getEmbed("PaperDialogBg",VSkin.STRETCH_BG);
         _loc6_.filters = [new GlowFilter(0,0.3,8,8,3)];
         this.paperPanel.add(_loc6_,{
            "wP":100,
            "top":-20,
            "minH":190
         });
         this.descText.format.lineHeight = "110%";
         this.paperPanel.add(this.descText,{
            "w":200,
            "hCenter":3
         });
         this.paperPanel.add(this.blackoutSkin,{
            "right":26,
            "bottom":-15,
            "w":223
         });
         var _loc7_:VFill = new VFill(0,0.3);
         add(_loc7_,{
            "w":300,
            "right":-20,
            "bottom":0,
            "h":550
         });
         this.paperPanel.mask = _loc7_;
         this.scrollBt.setSize(34,34);
         this.paperPanel.add(this.scrollBt,{
            "hCenter":0,
            "top":-38
         });
         this.scrollBt.addClickListener(this.onScroll);
      }
      
      private function onScroll(param1:MouseEvent) : void
      {
         this.tween.stop();
         var _loc2_:Number = this.paperPanel.y;
         this.paperPanel.maxH = !param1 || this.paperPanel.maxH == 550 ? 140 : 550;
         this.paperPanel.syncLayout();
         var _loc3_:VSkin = this.scrollBt.icon as VSkin;
         if(this.paperPanel.maxH == 550)
         {
            _loc3_.vCenter = 2;
            _loc3_.setMode(0);
         }
         else
         {
            _loc3_.vCenter = -1;
            _loc3_.setMode(VSkin.FLIP_Y);
         }
         if(Boolean(param1) && _loc2_ != this.paperPanel.y)
         {
            this.tween.play(["y",_loc2_,this.paperPanel.y],0.3);
         }
      }
      
      public function setData(param1:String, param2:uint, param3:int, param4:uint, param5:int) : void
      {
         if(this.cacheLevel == param2)
         {
            if(!this.learnArrow)
            {
               this.learnArrow = UIFactory.createLearnArrow(0);
               this.battleBt.add(this.learnArrow,{"hCenter":0});
            }
            return;
         }
         if(this.learnArrow)
         {
            this.learnArrow.removeFromParent();
            this.learnArrow = null;
         }
         this.cacheLevel = param2;
         this.titleText.value = Lang.getString(param1);
         this.descText.value = Lang.getString(param1 + "_desc");
         var _loc6_:VSkin = this.paperPanel.getChildAt(0) as VSkin;
         _loc6_.layoutH = this.descText.measuredHeight + 50;
         _loc6_.syncLayout();
         this.onScroll(null);
         this.blackoutSkin.visible = this.scrollBt.visible = this.descText.measuredHeight > 152;
         if(this.iconComponent)
         {
            remove(this.iconComponent);
         }
         this.iconComponent = new VComponent();
         add(this.iconComponent,{
            "left":3,
            "top":6,
            "w":61,
            "h":61
         });
         this.iconComponent.addStretch(SkinManager.getPack("MMapDg","activeMb"));
         this.iconComponent.add(MissionButton.getDigitBox(param2),{
            "hCenter":0,
            "vCenter":-2,
            "h":(param2 >= 10 ? 26 : 32)
         });
         this.damageStat.text.value = param3 + "%";
         this.rewardStat.value = param4;
         param2 = this.capacityCur < Math.round(param5 * 0.95) ? 3 : 2;
         if(param2 != this.difficultyValue)
         {
            this.difficultyValue = param2;
            if(param2 == 3)
            {
               SkinManager.applyEmbed(this.difficultySkin,"RedTag");
               this.difficultyText.value = Lang.getString("hard");
            }
            else
            {
               SkinManager.applyEmbed(this.difficultySkin,"YellowTag");
               this.difficultyText.value = Lang.getString("normal");
            }
         }
      }
      
      private function onTween(param1:Tween) : void
      {
         this.blackoutSkin.visible = this.paperPanel.maxH == 140;
      }
      
      override public function dispose() : void
      {
         this.tween.stop();
         super.dispose();
      }
   }
}

