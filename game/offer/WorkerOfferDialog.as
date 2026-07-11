package game.offer
{
   import flash.events.MouseEvent;
   import game.shop.ShopUnitPanel;
   import logic.ShopLogic;
   import proto.game.family_0010.Packet_0010_1B;
   import proto.model.PBtype;
   import proto.model.PShopBuilding;
   import proto.model.PShopOffer;
   import ui.Style;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class WorkerOfferDialog extends BaseDialog
   {
      
      private var offer:PShopOffer;
      
      private var workerShop:PShopBuilding;
      
      public function WorkerOfferDialog(param1:PShopBuilding)
      {
         var _loc3_:PShopBuilding = null;
         var _loc4_:VBox = null;
         var _loc5_:Vector.<VComponent> = null;
         var _loc6_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:VBox = null;
         super();
         setSize(570,430);
         add(SkinManager.getEmbed("FeatureDialogBg",VSkin.STRETCH),{
            "w":-100,
            "bottom":0,
            "h":295
         });
         add(SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH),{
            "w":-100,
            "bottom":275,
            "h":134
         });
         add(SkinManager.getEmbed("DialogTop",VSkin.STRETCH_BG),{"wP":100});
         addDialogTitle(Lang.getString("additional_worker"));
         addCloseButton();
         var _loc2_:VText = new VText(Lang.getString("additional_worker_caption"),VText.CENTER,Style.metalRGB,15);
         add(_loc2_,{
            "w":420,
            "hCenter":0,
            "top":85
         });
         for each(_loc3_ in Facade.manualProxy.buildShopList)
         {
            if(_loc3_.sb_level == 1 && _loc3_.sb_btype.variance == PBtype.WORKER)
            {
               _loc11_ = Facade.userProxy.getConstructionCount(_loc3_.sb_kind);
               break;
            }
         }
         this.offer = Facade.manualProxy.getOfferShop("so_worker" + (_loc11_ + 2));
         _loc4_ = new VBox(null,5,VBox.VERTICAL);
         _loc5_ = new Vector.<VComponent>();
         OfferDialog.addGoodItems(_loc5_,this.offer.offer_goods);
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(_loc6_ % 2 == 0)
            {
               _loc12_ = new VBox(null,5,VBox.CENTER);
               _loc4_.add(_loc12_);
            }
            _loc12_.add(_loc5_[_loc6_]);
            _loc6_++;
         }
         _loc4_.scaleX = _loc4_.scaleY = 0.5;
         add(_loc4_,{
            "left":270,
            "top":160
         });
         _loc2_ = new VText(Lang.getReplaceString("additional_worker_button",{"__PRICE__":(this.offer.caption ? this.offer.offer_social_price + " " + this.offer.caption : Lang.getCurrency(this.offer.offer_social_price))}),0,Style.yellowRGB);
         Style.applyDefaultFilter(_loc2_,12,Style.grayGlowRGB);
         var _loc7_:RectButton = new RectButton(_loc2_,RectButton.h30);
         add(_loc7_,{
            "right":100,
            "bottom":12
         });
         _loc7_.addClickListener(this.onOfferClick);
         var _loc8_:VComponent = new VComponent();
         _loc8_.setSize(164,152);
         _loc8_.addStretch(SkinManager.getEmbed("ShopItemBg",VSkin.STRETCH));
         _loc8_.add(SkinManager.getEmbed("ShopDiffusion",VSkin.STRETCH),{
            "left":11,
            "right":11,
            "top":9,
            "bottom":42
         });
         var _loc9_:ShopUnitPanel = new ShopUnitPanel();
         _loc9_.show(param1.sb_kind,param1.sb_level);
         _loc8_.add(_loc9_,{
            "left":18,
            "right":18,
            "top":16,
            "bottom":36
         });
         var _loc10_:PriceListPanel = new PriceListPanel(7,PricePanel.GLOW_FILTER);
         _loc10_.useCostCheck = true;
         _loc10_.setStyle(25,18);
         _loc10_.priceGap = 1;
         _loc10_.assignList(ShopLogic.getCustomPrice("bl_builder",param1.sb_price_list,param1.sb_price));
         _loc7_ = new RectButton(_loc10_,RectButton.h42,RectButton.ORANGE);
         _loc7_.addClickListener(this.onWorkerClick);
         _loc8_.add(_loc7_,{
            "bottom":0,
            "left":-1,
            "right":-2
         });
         add(_loc8_,{
            "left":60,
            "top":200
         });
         Facade.protoProxy.request(new Packet_0010_1B(this.offer.offer_kind));
         this.workerShop = param1;
      }
      
      private function onWorkerClick(param1:MouseEvent) : void
      {
         ShopLogic.buy(this.workerShop);
      }
      
      private function onOfferClick(param1:MouseEvent) : void
      {
         close();
         Facade.callJS("pay",this.offer.offer_kind);
      }
   }
}

