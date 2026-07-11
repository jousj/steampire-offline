package game.barrack
{
   import flash.display.Sprite;
   import model.ui.VOBarrackItem;
   import proto.model.PCost;
   import proto.model.PRequirement;
   import proto.model.PShopUnit;
   import proto.tuples.str_i;
   import ui.Style;
   import ui.common.CircleButton;
   import ui.common.LevelPanel;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.game.UnitPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class BarrackBuyRenderer extends VRenderer
   {
      
      public var buyBt:VButton;
      
      public var buy5Bt:CircleButton;
      
      private var specialCountText:VText;
      
      private var infoBt:CircleButton;
      
      private var lockSkin:VSkin;
      
      private var unitPanel:UnitPanel;
      
      private var levelPanel:LevelPanel;
      
      private var isCached:Boolean;
      
      private var spaceCache:int;
      
      protected var contextComponent:VComponent;
      
      public function BarrackBuyRenderer()
      {
         super();
         setSize(160,160);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:VOBarrackItem = param1 as VOBarrackItem;
         if(_loc2_)
         {
            this.showItem(_loc2_);
         }
         else
         {
            this.showEmpty();
         }
      }
      
      private function createBt() : void
      {
         var _loc1_:Sprite = null;
         this.unitPanel = new UnitPanel(UnitPanel.BARRACK_MODE,UnitPanel.barrackSize160);
         this.buyBt = new VButton();
         this.buyBt.addVarianceListener(this,BarrackDialog.INC);
         this.buyBt.setSkin(this.unitPanel);
         add(this.buyBt,null,0);
         _loc1_ = new Sprite();
         _loc1_.graphics.beginFill(16776960,1);
         var _loc2_:Number = this.unitPanel.layoutW / 2;
         _loc1_.graphics.drawCircle(_loc2_,_loc2_,_loc2_);
         _loc1_.mouseEnabled = false;
         _loc1_.visible = false;
         addChild(_loc1_);
         this.buyBt.hitArea = _loc1_;
      }
      
      private function addInfoBt() : void
      {
         this.infoBt = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.TEAL,CircleButton.size42);
         this.infoBt.hint = Lang.getString("info");
         add(this.infoBt,{
            "left":-6,
            "top":-10
         });
         this.infoBt.addVarianceListener(this,BarrackDialog.INFO);
      }
      
      private function setBtVisible(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.lockSkin)
            {
               this.lockSkin.visible = false;
            }
            if(!this.buyBt)
            {
               this.createBt();
            }
         }
         if(this.infoBt)
         {
            this.infoBt.visible = param1;
         }
         this.buyBt.visible = param1;
         if(!param1 && Boolean(this.buy5Bt))
         {
            this.buy5Bt.visible = false;
         }
      }
      
      protected function showItem(param1:VOBarrackItem) : void
      {
         var _loc2_:str_i = null;
         var _loc3_:PShopUnit = null;
         this.initBuyBt(param1);
         if(param1.specialPack)
         {
            _loc2_ = param1.specialPack.up_units[0];
            if(this.buy5Bt)
            {
               this.buy5Bt.visible = false;
            }
            if(this.infoBt)
            {
               this.infoBt.visible = false;
            }
            if(!this.specialCountText)
            {
               this.specialCountText = new VText("x" + _loc2_.field_1,0,Style.yellowRGB);
               Style.applyDefaultFormat(this.specialCountText,24,true);
               add(this.specialCountText,{
                  "vCenter":0,
                  "hCenter":60
               });
            }
            else
            {
               this.specialCountText.visible = true;
               this.specialCountText.value = "x" + _loc2_.field_1;
            }
            if(this.levelPanel)
            {
               this.buyBt.remove(this.levelPanel);
               this.levelPanel = null;
            }
            this.showPrice(param1.specialPack.up_price);
         }
         else
         {
            if(!this.infoBt)
            {
               this.addInfoBt();
            }
            this.infoBt.data = param1;
            this.infoBt.visible = true;
            if(this.specialCountText)
            {
               this.specialCountText.visible = false;
            }
            _loc3_ = param1.shop;
            if(this.buyBt.disabled)
            {
               this.applyReq(param1);
            }
            else if(param1.flag)
            {
               this.showPrice(_loc3_.su_price);
            }
            else
            {
               this.showBrkPrice(_loc3_.su_price,_loc3_.su_hspace);
            }
            if(!param1.flag && _loc3_.su_hspace < 10 && !this.buyBt.disabled)
            {
               if(!this.buy5Bt)
               {
                  this.buy5Bt = new CircleButton(null,CircleButton.GOLD,CircleButton.size30);
                  this.buy5Bt.applyText("+5",16,0);
                  this.buy5Bt.addVarianceListener(this,BarrackDialog.INC_5);
                  add(this.buy5Bt,{
                     "bottom":32,
                     "right":-10
                  });
               }
               else
               {
                  this.buy5Bt.visible = true;
               }
               this.buy5Bt.data = param1;
            }
            else if(this.buy5Bt)
            {
               this.buy5Bt.visible = false;
            }
         }
      }
      
      protected function initBuyBt(param1:VOBarrackItem) : void
      {
         this.setBtVisible(true);
         this.buyBt.disabled = param1.space > 0 || param1.isResearchLock;
         var _loc2_:PShopUnit = param1.shop;
         this.isCached = this.buyBt.data == param1 && _loc2_.su_level == (this.levelPanel ? this.levelPanel.value : 1);
         if(!this.isCached)
         {
            this.buyBt.data = param1;
            this.unitPanel.show(_loc2_.su_kind,_loc2_.su_model_level);
            if(!param1.isResearchLock || _loc2_.su_level > 1)
            {
               if(!this.levelPanel)
               {
                  this.levelPanel = new LevelPanel(LevelPanel.size34);
                  this.buyBt.add(this.levelPanel,{
                     "top":4,
                     "right":6
                  });
               }
               this.levelPanel.value = _loc2_.su_level;
            }
            else if(this.levelPanel)
            {
               this.buyBt.remove(this.levelPanel);
               this.levelPanel = null;
            }
         }
      }
      
      protected function showEmpty() : void
      {
         if(this.specialCountText)
         {
            this.specialCountText.visible = false;
         }
         if(this.buyBt)
         {
            this.buyBt.data = null;
            this.setBtVisible(false);
         }
         if(!this.lockSkin)
         {
            this.lockSkin = SkinManager.getEmbed("TrainBgLock");
            add(this.lockSkin);
         }
         else
         {
            this.lockSkin.visible = true;
         }
         hint = null;
      }
      
      protected function getContextComponent(param1:Class) : *
      {
         if(Boolean(this.contextComponent) && !(this.contextComponent is param1))
         {
            this.contextComponent.removeFromParent();
            this.contextComponent = null;
            return null;
         }
         return this.contextComponent;
      }
      
      private function showBrkPrice(param1:PCost, param2:uint) : void
      {
         var _loc4_:PricePanel = null;
         var _loc3_:PriceListPanel = this.getContextComponent(PriceListPanel);
         if(!_loc3_)
         {
            this.contextComponent = _loc3_ = new PriceListPanel(8);
            _loc3_.useVertical(34);
            _loc3_.useCostCheck = true;
            this.buyBt.setIcon(_loc3_,{
               "hCenter":0,
               "bottom":9
            });
         }
         else if(this.isCached)
         {
            return;
         }
         if(param2 > 0)
         {
            _loc3_.assignCost(param1);
            _loc4_ = _loc3_.getPricePanel(null);
            _loc4_.useCheck = false;
            _loc3_.addPricePanel(_loc4_);
            SkinManager.applyEmbed(_loc4_.skin,"HumanIcon");
            _loc4_.setValue(param2);
         }
         else
         {
            _loc3_.assignCost(param1);
         }
      }
      
      protected function showPrice(param1:PCost) : void
      {
         var _loc2_:PricePanel = this.getContextComponent(PricePanel);
         if(!_loc2_)
         {
            this.contextComponent = _loc2_ = new PricePanel(38,20,PricePanel.GLOW_FILTER | PricePanel.VERTICAL,8,150);
            _loc2_.useCheck = true;
         }
         else if(this.isCached)
         {
            return;
         }
         _loc2_.assignCost(param1);
         if(!_loc2_.parent)
         {
            this.buyBt.setIcon(_loc2_,{
               "hCenter":0,
               "bottom":9
            });
         }
      }
      
      protected function showPriceList(param1:Array) : void
      {
         var _loc2_:PriceListPanel = this.getContextComponent(PriceListPanel);
         if(!_loc2_)
         {
            this.contextComponent = _loc2_ = new PriceListPanel();
            _loc2_.useVertical(34,0,91);
            _loc2_.priceGap = 8;
            _loc2_.useCostCheck = true;
         }
         else if(this.isCached)
         {
            return;
         }
         _loc2_.assignList(param1);
         if(!_loc2_.parent)
         {
            this.buyBt.setIcon(_loc2_,{
               "hCenter":0,
               "bottom":9
            });
         }
      }
      
      protected function applyReq(param1:VOBarrackItem) : void
      {
         var _loc3_:String = null;
         var _loc4_:PRequirement = null;
         var _loc2_:VLabel = this.getContextComponent(VLabel);
         if(!_loc2_)
         {
            this.contextComponent = _loc2_ = new VLabel(null,VLabel.CENTER | VLabel.MIDDLE | VLabel.LEADING_BOX);
            Style.applyDefaultFilter(_loc2_,14);
            this.buyBt.add(_loc2_,{
               "wP":100,
               "top":100,
               "h":50
            });
         }
         else if(this.isCached && (param1.isResearchLock || this.spaceCache == param1.space))
         {
            return;
         }
         if(param1.isResearchLock)
         {
            _loc4_ = param1.shop.su_upgrade_requirement;
            _loc3_ = StringHelper.getUnitName(_loc4_.req_building_kind,_loc4_.req_building_level,14,"");
         }
         else
         {
            _loc3_ = StringHelper.getTLFImage("lib,ArmyCapacityIcon",22) + param1.space;
            this.spaceCache = param1.space;
         }
         _loc2_.text = "<p fontSize=\"14\"" + Style.yellowColor + ">" + Lang.getPatternString("required_build","__BUILD__",_loc3_) + "</p>";
      }
      
      public function checkBuyBt(param1:String = null) : Boolean
      {
         return Boolean(this.buyBt) && this.buyBt.data is VOBarrackItem && !this.buyBt.disabled && (!param1 || (this.buyBt.data as VOBarrackItem).shop.su_kind == param1);
      }
   }
}

