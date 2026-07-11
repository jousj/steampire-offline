package game.missions
{
   import engine.signal.Tween;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import proto.model.PCost;
   import proto.model.PMissionInfo;
   import proto.model.PMissionPercentage;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.RectButton;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class CellarPanel extends VComponent
   {
      
      public const battleBt:RectButton = RectButton.createIconAndTitle(SkinManager.getEmbed("CannonIcon"),Lang.getString("to_mission"),20,RectButton.ORANGE,180,7);
      
      private const titleText:VText = UIFactory.createYellowText(null,VText.CONTAIN,22);
      
      private const targetGrid:VGrid = new VGrid(3,1,MapTargetRenderer,null,4,0,VGrid.USE_VISIBLE_CALC_LAYOUT);
      
      private const oilPanel:ResourcePanel = new ResourcePanel(PCost.OIL,ResourcePanel.BG | ResourcePanel.PROGRESS,null,36,32);
      
      private const crystalPanel:ResourcePanel = new ResourcePanel(PCost.CRYSTAL,ResourcePanel.BG | ResourcePanel.PROGRESS,null,36,32);
      
      private const descText:VText = new VText(null,VText.CENTER,Style.darkKhakiRGB,15);
      
      private const scrollBt:CircleButton = new CircleButton(SkinManager.getEmbed("BrArrow"),CircleButton.GOLD);
      
      private const paperPanel:VComponent = new VComponent();
      
      private const blackoutSkin:VSkin = SkinManager.getPack("MMapDg","BlackoutPaper",0,SkinManager.LOAD_CLIP);
      
      private const tween:Tween;
      
      private const difficultyPanel:VComponent = new VComponent();
      
      private const difficultyText:VText = UIFactory.createYellowText(null,VText.CONTAIN,16);
      
      private const difficultySkin:VSkin = new VSkin();
      
      private var iconComponent:VComponent;
      
      private var cacheLevel:uint;
      
      private var cacheEx:Boolean;
      
      private var learnArrow:VSkin;
      
      private var difficultyValue:uint;
      
      public var capacityCur:uint;
      
      public var capacityMax:uint;
      
      public function CellarPanel()
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
         add(new VText(Lang.getString("mission_target"),VText.CONTAIN_CENTER,Style.anthraciteRGB,18),{
            "left":50,
            "top":58,
            "w":160
         });
         add(this.targetGrid,{
            "left":38,
            "top":80,
            "w":180
         });
         add(new VText(Lang.getString("mission_info"),VText.CONTAIN_CENTER,Style.anthraciteRGB,18),{
            "left":225,
            "top":58,
            "w":180
         });
         add(this.oilPanel,{
            "top":78,
            "left":234,
            "w":160,
            "h":33
         });
         add(this.crystalPanel,{
            "top":114,
            "left":234,
            "w":160,
            "h":33
         });
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
         add(this.battleBt,{
            "hCenter":77,
            "top":88,
            "maxW":180
         });
         add(this.paperPanel,{
            "w":280,
            "bottom":10,
            "right":-10,
            "minH":130
         });
         var _loc1_:VSkin = SkinManager.getEmbed("PaperDialogBg",VSkin.STRETCH_BG);
         _loc1_.filters = [new GlowFilter(0,0.3,8,8,3)];
         this.paperPanel.add(_loc1_,{
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
         var _loc2_:VFill = new VFill(0,0.3);
         add(_loc2_,{
            "w":300,
            "right":-20,
            "bottom":0,
            "h":550
         });
         this.paperPanel.mask = _loc2_;
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
      
      public function setData(param1:String, param2:uint, param3:Boolean, param4:PMissionInfo, param5:PMissionPercentage) : void
      {
         if(this.cacheLevel == param2 && this.cacheEx == param3)
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
         this.cacheEx = param3;
         this.titleText.value = Lang.getString(param1);
         this.descText.value = Lang.getString(param1 + "_desc");
         var _loc6_:VSkin = this.paperPanel.getChildAt(0) as VSkin;
         _loc6_.layoutH = this.descText.measuredHeight + 50;
         _loc6_.syncLayout();
         this.onScroll(null);
         this.blackoutSkin.visible = this.scrollBt.visible = this.descText.measuredHeight > 152;
         this.targetGrid.setDataProvider(param4.mi_win);
         var _loc7_:uint = CostHelper.getValueFromList(param4.mi_resources,PCost.OIL);
         this.oilPanel.setDataEx(param5 ? int(param5.mp_oil_perc * _loc7_) : int(_loc7_),_loc7_);
         _loc7_ = CostHelper.getValueFromList(param4.mi_resources,PCost.CRYSTAL);
         this.crystalPanel.setDataEx(param5 ? int(param5.mp_cry_perc * _loc7_) : int(_loc7_),_loc7_);
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
         if(param3)
         {
            this.iconComponent.addStretch(SkinManager.getPack("MMapDg","exMb"));
            this.iconComponent.add(SkinManager.getEmbed("CannonIcon"),{
               "hCenter":0,
               "vCenter":0,
               "w":40,
               "h":40
            });
         }
         else
         {
            this.iconComponent.addStretch(SkinManager.getPack("MMapDg","activeMb"));
            this.iconComponent.add(MissionButton.getDigitBox(param2),{
               "hCenter":0,
               "vCenter":-2,
               "h":(param2 >= 10 ? 26 : 32)
            });
         }
         param2 = this.capacityCur < Math.round(param4.mi_average_hspace * 0.95) ? 3 : 2;
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

