package game.shop
{
   import model.ui.VOShopItem;
   import proto.model.PCost;
   import proto.model.PMoneyPriceInfo;
   import proto.model.PShopBuilding;
   import proto.model.PShopCall;
   import proto.model.PShopCannon;
   import proto.model.PShopFence;
   import proto.model.PShopResourcesPack;
   import proto.model.PShopShield;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.DurationPanel;
   import ui.common.StatPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class ShopRenderer extends VRenderer
   {
      
      public const bt:VButton = VButton.createEmbed("ShopItemBg",VSkin.STRETCH,new ShopUnitPanel(),{
         "hCenter":0,
         "top":15,
         "w":200,
         "h":180
      });
      
      private const titleText:VText = UIFactory.createYellowText(null,VText.CENTER | VText.BOTTOM,22);
      
      private const countText:VText = UIFactory.createYellowText(null,VText.CONTAIN);
      
      private const priceBox:VBox = new VBox(null,8);
      
      private const pricePanel:PricePanel = new PricePanel(32,22,PricePanel.GLOW_FILTER);
      
      private const infoBt:CircleButton = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.TEAL,CircleButton.size42);
      
      private const descPanel:VComponent = new VComponent();
      
      private var durationPanel:DurationPanel;
      
      private var currencyPanel:VComponent;
      
      private var lockLb:VLabel;
      
      private var newStatusPanel:VComponent;
      
      public function ShopRenderer()
      {
         super();
         setSize(254,235);
         addChild(this.bt);
         this.bt.addVarianceListener(this,0);
         this.descPanel.mouseChildren = this.descPanel.mouseEnabled = false;
         addChild(this.descPanel);
         add(this.descPanel,{
            "hCenter":0,
            "bottom":12
         });
         this.descPanel.addChild(SkinManager.getEmbed("ShopItemPriceBg"));
         this.pricePanel.useCheck = true;
         this.priceBox.add(this.pricePanel);
         this.descPanel.add(this.priceBox,{
            "hCenter":0,
            "bottom":8
         });
         add(this.countText,{
            "left":21,
            "top":18
         });
         this.titleText.format.lineHeight = "90%";
         add(this.titleText,{
            "left":8,
            "right":8,
            "bottom":52,
            "h":42
         });
         this.infoBt.hint = Lang.getString("info");
         add(this.infoBt,{
            "right":-5,
            "top":-4
         });
         this.infoBt.addVarianceListener(this,1);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:VOShopItem = null;
         var _loc7_:String = null;
         this.infoBt.data = this.bt.data = param1;
         _loc2_ = param1 as VOShopItem;
         var _loc3_:Object = _loc2_.shop;
         this.titleText.value = Lang.getString(_loc2_.kind);
         var _loc4_:Boolean = _loc3_ is PMoneyPriceInfo;
         var _loc5_:Boolean = !((_loc4_) || _loc3_ is PShopShield || _loc3_ is PShopResourcesPack || _loc3_ is PShopCall);
         if(this.currencyPanel)
         {
            this.bt.remove(this.currencyPanel);
            this.currencyPanel = null;
         }
         var _loc6_:Boolean = _loc5_ && (_loc2_.townhall_req > 0 || _loc2_.cur >= _loc2_.max);
         this.bt.mouseEnabled = !_loc6_;
         this.priceBox.visible = !_loc6_ && !_loc4_;
         if(_loc6_)
         {
            this.addLockLb();
            if(_loc2_.townhall_req > 0 || _loc2_.next_townhall_req > 0)
            {
               _loc7_ = Lang.getPatternString("required_build","__BUILD__",StringHelper.getUnitName("bl_town_hall",_loc2_.townhall_req > 0 ? _loc2_.townhall_req : _loc2_.next_townhall_req,16,Style.yellowColor));
            }
            else
            {
               _loc7_ = Lang.getString("shop_limit");
            }
            this.lockLb.text = "<p fontSize=\"16\" lineHeight=\"90%\"" + Style.yellowColor + ">" + _loc7_ + "</p>";
         }
         else
         {
            if(!_loc4_)
            {
               this.pricePanel.assignCost(_loc2_.price || _loc2_.priceList[0]);
            }
            this.applyDuration(_loc5_ ? _loc2_.duration : 0);
            if(this.lockLb)
            {
               this.descPanel.remove(this.lockLb);
               this.lockLb = null;
            }
         }
         if(_loc5_)
         {
            (this.bt.icon as ShopUnitPanel).show(_loc2_.kind,1);
         }
         else
         {
            this.useCurrency(_loc2_,_loc3_);
         }
         this.descPanel.filters = this.bt.filters = _loc6_ ? VSkin.GREY_FILTER : null;
         this.countText.value = _loc2_.max > 0 ? _loc2_.cur + "/" + _loc2_.max : null;
         this.infoBt.visible = _loc3_ is PShopBuilding || _loc3_ is PShopCannon || _loc3_ is PShopFence;
         if((!_loc6_ && _loc2_.isNew) != Boolean(this.newStatusPanel))
         {
            if(this.newStatusPanel)
            {
               this.bt.remove(this.newStatusPanel);
               this.newStatusPanel = null;
               this.countText.top = 18;
            }
            else
            {
               this.newStatusPanel = new VComponent();
               this.newStatusPanel.addStretch(SkinManager.getEmbed("ShopBg5"));
               this.newStatusPanel.add(SkinManager.getEmbed("ShopDiffusion"),{
                  "hCenter":0,
                  "top":10
               });
               this.newStatusPanel.add(SkinManager.getEmbed("NewIcon"),{
                  "left":6,
                  "top":14
               });
               this.bt.add(this.newStatusPanel,{
                  "left":14,
                  "right":13,
                  "top":2,
                  "bottom":7
               },1);
               this.countText.top = 42;
            }
            this.countText.syncLayout();
         }
      }
      
      private function addLockLb() : void
      {
         if(!this.lockLb)
         {
            this.lockLb = new VLabel(null,VLabel.CENTER | VLabel.MIDDLE | VLabel.LEADING_BOX);
            Style.applyDefaultFilter(this.lockLb);
            this.descPanel.add(this.lockLb,{
               "w":230,
               "hCenter":0,
               "top":35,
               "h":31
            });
         }
      }
      
      private function useCurrency(param1:VOShopItem, param2:Object) : void
      {
         var _loc3_:PricePanel = null;
         var _loc4_:PMoneyPriceInfo = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         (this.bt.icon as ShopUnitPanel).reset();
         this.currencyPanel = new VComponent();
         this.currencyPanel.addStretch(SkinManager.getEmbed("ShopBg" + param1.cur));
         this.currencyPanel.add(SkinManager.getEmbed("ShopDiffusion"),{
            "hCenter":0,
            "top":10
         });
         this.currencyPanel.add(SkinManager.getExternal(param1.kind,SkinManager.PNG | SkinManager.LOAD_CLIP),{
            "hCenter":0,
            "vCenter":-6
         });
         if(param2 is PShopResourcesPack || param2 is PMoneyPriceInfo || param2 is PShopCall)
         {
            if(param2 is PMoneyPriceInfo)
            {
               _loc4_ = param2 as PMoneyPriceInfo;
               _loc5_ = PCost.GOLD;
               _loc6_ = uint(_loc4_.money);
               this.addLockLb();
               this.lockLb.text = "<p" + Style.yellowColor + ">" + _loc4_.votes + " " + StringHelper.addCDATA(_loc4_.caption) + "</p>";
            }
            else
            {
               _loc5_ = param2 is PShopCall ? PCost.CALL : CostHelper.getVarianceFromType((param2 as PShopResourcesPack).rs_type);
               _loc6_ = param1.next_townhall_req;
            }
            _loc3_ = new PricePanel(30,22,PricePanel.GLOW_B_FILTER);
            _loc3_.assign(_loc5_,_loc6_);
            this.currencyPanel.add(_loc3_,{
               "hCenter":0,
               "top":13
            });
         }
         else if(param2 is PShopShield)
         {
            this.currencyPanel.add(new StatPanel(SkinManager.getEmbed("ShieldIcon"),"+" + StringHelper.getTimeDesc(param1.duration),StatPanel.YELLOW_B_TEXT,2,30,22),{
               "hCenter":0,
               "top":13
            });
         }
         this.bt.add(this.currencyPanel,{
            "left":14,
            "right":13,
            "top":2,
            "bottom":7
         },1);
      }
      
      private function applyDuration(param1:Number) : void
      {
         if(param1 > 0)
         {
            if(!this.durationPanel)
            {
               this.durationPanel = new DurationPanel(30,20,2);
               this.priceBox.add(this.durationPanel,null,0);
            }
            this.durationPanel.setStaticTime(param1);
         }
         else if(this.durationPanel)
         {
            this.priceBox.remove(this.durationPanel);
            this.durationPanel = null;
         }
      }
   }
}

