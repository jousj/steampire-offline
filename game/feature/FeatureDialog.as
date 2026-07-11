package game.feature
{
   import flash.geom.Rectangle;
   import game.political.TownHallLevelPanel;
   import logic.ActionLogic;
   import model.vo.MapAction;
   import proto.game.family_0010.Packet_0010_18;
   import proto.model.PCost;
   import proto.model.PShopUnit;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.game.PriceButton;
   import ui.game.PriceListButton;
   import ui.game.ResourcePanel;
   import ui.game.UnitPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class FeatureDialog extends BaseDialog
   {
      
      public const descBox:VBox = new VBox(null,10,VBox.VERTICAL);
      
      public var priceButton:VButton;
      
      public var resPanel:ResourcePanel;
      
      public var grid:VGrid;
      
      private const descPanel:VComponent = new VComponent();
      
      private const featurePanel:VComponent = new VComponent();
      
      private var unitPanel:UnitPanel;
      
      private var gearSkin:VSkin;
      
      public function FeatureDialog(param1:String, param2:uint, param3:Boolean, param4:uint = 0, param5:Boolean = false, param6:Boolean = true)
      {
         super();
         layoutW = param5 ? 710 : 600;
         this.descPanel.addStretch(SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH_BG));
         if(param3)
         {
            this.addAbout(param1);
         }
         this.descPanel.add(this.descBox,{
            "right":18,
            "left":18,
            "top":14,
            "bottom":22
         });
         add(this.descPanel,{
            "bottom":0,
            "wP":100
         });
         this.featurePanel.add(SkinManager.getEmbed("FeatureDialogBg",VSkin.STRETCH_BG),{
            "wP":100,
            "bottom":-5,
            "top":-28
         });
         this.grid = new VGrid(1,1,FeatureRenderer,null,0,param5 ? 8 : 5,VGrid.H_STRETCH | VGrid.USE_TOP_LEFT);
         this.featurePanel.add(this.grid,{
            "left":(param5 ? 176 : 102),
            "right":28,
            "top":10,
            "bottom":18
         });
         add(this.featurePanel,{
            "wP":100,
            "top":70,
            "minH":128
         });
         addHeader();
         if(param6)
         {
            addUnitDialogTitle(param1,param2);
         }
         if(param5)
         {
            this.grid.minH = 220;
            if(param1 == "un_hero_jaina")
            {
               add(SkinManager.getExternal(param1 + "_update",SkinManager.PNG),{
                  "left":14,
                  "top":88,
                  "w":162,
                  "h":282
               });
            }
            else
            {
               add(SkinManager.getExternal(param1 + "_update",SkinManager.JPG),{
                  "left":23,
                  "top":78,
                  "h":270
               });
            }
         }
         else
         {
            add(this.gearSkin = SkinManager.getEmbed("FeatureGear"),{
               "left":-60,
               "top":158
            },0);
            UnitPanel.feature(this.unitPanel = new UnitPanel(UnitPanel.FEATURE_MODE),param1);
            add(this.unitPanel,{
               "left":-72,
               "top":50
            });
            this.unitPanel.show(param1,param4 > 0 ? param4 : param2);
         }
      }
      
      public function addAbout(param1:String) : void
      {
         this.descBox.add(new VText(Lang.getString(param1 + "_about"),VText.CENTER | VText.MIDDLE,Style.darkKhakiRGB,16).assignW(layoutW - 66));
      }
      
      override protected function calcContentSize() : void
      {
         contentH = this.featurePanel.measuredHeight + this.featurePanel.vPadding + this.descPanel.measuredHeight;
      }
      
      public function addUpdateButton(param1:*, param2:Number, param3:Function, param4:Object = 0, param5:Boolean = false) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         if(param5)
         {
            if(param4 is MapAction)
            {
               _loc7_ = this.getActionDesc(param4 as MapAction);
            }
            else
            {
               _loc7_ = Lang.getString("research_start");
            }
         }
         else
         {
            if(param4 !== 0)
            {
               _loc6_ = true;
            }
            _loc7_ = _loc6_ ? Lang.getPatternString("townhall_req","__VALUE__",param4.toString()) : Lang.getString("start_update");
         }
         var _loc8_:VComponent = new VComponent();
         _loc8_.addChild(new VText(_loc7_,VText.CONTAIN_CENTER,_loc6_ ? Style.redRGB : Style.darkKhakiRGB,16).assignW(-100));
         if(param1 is Array && param1.length == 1)
         {
            param1 = param1[0];
         }
         this.priceButton = param1 is PCost ? new PriceButton(!_loc6_,param2).assignCost(param1) : new PriceListButton(param1,!_loc6_,param2);
         _loc8_.add(this.priceButton,{
            "hCenter":0,
            "top":19
         });
         if(_loc6_)
         {
            this.priceButton.disabled = true;
         }
         else
         {
            this.priceButton.addClickListener(param3);
         }
         this.descBox.add(_loc8_,{
            "left":30,
            "right":30
         });
         if((param1.variance == PCost.CRYSTAL || param1.variance == PCost.OIL) && Facade.userProxy.checkCost(param1.variance,param1.value) > 0)
         {
            Facade.protoProxy.request(new Packet_0010_18(param1.variance == PCost.OIL));
         }
      }
      
      private function getActionDesc(param1:MapAction) : String
      {
         if(param1.variance == ActionLogic.FINISH_RESEARCH)
         {
            return Lang.getPatternString("research_limit","__TITLE__",(param1.value as PShopUnit).su_kind,true);
         }
         return "";
      }
      
      public function setDp(param1:Array) : void
      {
         this.grid.changeRendererCount(1,param1.length,param1);
         if(param1.length <= 3 && Boolean(this.unitPanel))
         {
            this.unitPanel.top -= 26;
            this.gearSkin.top -= 26;
         }
         if(param1.length > 1)
         {
            this.grid.add(SkinManager.getEmbed("FrLine",VSkin.ROTATE_270 | VSkin.STRETCH),{
               "left":8,
               "top":24,
               "h":14 + (param1.length - 2) * (this.grid.renderList[0].measuredHeight + this.grid.vGap),
               "w":17
            },0);
         }
      }
      
      public function setExIcons(param1:Array) : void
      {
         var _loc3_:uint = 0;
         var _loc5_:VSkin = null;
         var _loc6_:VComponent = null;
         var _loc2_:VBox = new VBox(null,10);
         _loc3_ = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = SkinManager.getPack("InfoExIcons",param1[_loc4_],VSkin.DRAW_FILL,SkinManager.LOAD_CLIP);
            _loc5_.setSize(40,40);
            _loc5_.mouseEnabled = true;
            _loc5_.hint = Lang.getString(param1[_loc4_]);
            _loc4_++;
            _loc6_ = _loc5_;
            if(_loc4_ < _loc3_ && !(param1[_loc4_] is String))
            {
               _loc6_ = new VComponent();
               _loc6_.add(_loc5_);
               _loc6_.add(UIFactory.createYellowText("x" + param1[_loc4_],0,16),{
                  "bottom":0,
                  "right":0
               });
               _loc4_++;
            }
            _loc2_.list.push(_loc6_);
         }
         _loc2_.addAll();
         if(_loc3_ > 1)
         {
            _loc6_ = new VComponent();
            _loc6_.add(SkinManager.getPack("InfoExIcons","IconExBg",VSkin.STRETCH_BG),{
               "vCenter":0,
               "left":20,
               "right":20
            });
            _loc6_.addChild(_loc2_);
         }
         else
         {
            _loc6_ = _loc2_;
         }
         _loc6_.bottom = this.grid.bottom - 4;
         _loc6_.left = this.grid.left;
         this.grid.bottom += 44;
         this.featurePanel.add(_loc6_);
      }
      
      public function addUpdateUnitTitle(param1:String, param2:uint, param3:uint) : void
      {
         addUnitDialogTitle(param1,param2,false,290,this.unitPanel ? 60 : 40);
         this.resPanel = new ResourcePanel(param3,ResourcePanel.BG | ResourcePanel.TWEEN);
         add(this.resPanel,{
            "right":64,
            "top":15,
            "w":126
         });
      }
      
      public function createClanLeague(param1:uint, param2:String) : VComponent
      {
         var _loc3_:VComponent = new VComponent();
         _loc3_.setSize(560,100);
         var _loc4_:VSkin = SkinManager.getPack(UIFactory.POLITICAL_PACK,"map" + param1);
         _loc4_.layoutW = _loc3_.layoutW - 4;
         _loc4_.scrollRect = new Rectangle(0,80,_loc4_.layoutW,_loc3_.layoutH - 8);
         _loc3_.add(_loc4_,{
            "left":2,
            "top":4
         });
         _loc3_.addStretch(SkinManager.getEmbed("DarkBorder",VSkin.STRETCH));
         _loc3_.add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "left":64,
            "right":14,
            "vCenter":1,
            "h":76
         });
         _loc3_.add(new TownHallLevelPanel(param1),{
            "left":12,
            "vCenter":1
         });
         _loc3_.add(UIFactory.createDecorText(Lang.getString(param2),true,24,426),{
            "left":110,
            "top":19
         });
         var _loc5_:VText = UIFactory.createYellowText(Lang.getString("town_hall_league"),VText.MIDDLE,16,true);
         _loc5_.format.lineHeight = "110%";
         _loc3_.add(_loc5_,{
            "left":110,
            "right":24,
            "bottom":17,
            "h":33
         });
         return _loc3_;
      }
   }
}

